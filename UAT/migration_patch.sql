ALTER TABLE cqc."User" ADD COLUMN "IsPrimary" BOOLEAN NOT NULL DEFAULT true;
ALTER TABLE cqc."User" ADD COLUMN "TribalID" INTEGER NULL;
ALTER TABLE cqc."Establishment" ADD COLUMN "TribalID" INTEGER NULL;
ALTER TABLE cqc."Worker" ADD COLUMN "TribalID" INTEGER NULL;

CREATE OR REPLACE FUNCTION cqc.MigrateUsers()
	RETURNS void AS $$
DECLARE
  AllUsers REFCURSOR;
  CurrentUser RECORD;
  NewUserRole VARCHAR(4);
  NewJobTitle VARCHAR(120);
  NewIsPrimary BOOLEAN;
  NotMapped VARCHAR(10);
  MappedEmpty VARCHAR(10);
  MigrationUser VARCHAR(10);
  FullName VARCHAR(120);
  ThisRegistrationID INTEGER;
  MigrationTimestamp timestamp without time zone;
  DuffHash VARCHAR(10);
BEGIN
	NotMapped := 'Not Mapped';
	MappedEmpty := 'Was empty';
	MigrationUser := 'migration';
	MigrationTimestamp := clock_timestamp();
	DuffHash := 'To Fix';
	
  -- first clean up any already migrated data
  -- TODO - tidy up UserAudit records
  DELETE FROM cqc."Login" where "RegistrationID" in (select "RegistrationID" from cqc."User" where "TribalID" is not null);
  DELETE FROM cqc."User" where "TribalID" is not null;

  OPEN AllUsers FOR select cqc."Establishment"."EstablishmentID" AS establishmentid, users.*, establishment_user.*
    from
      users
        inner join establishment_user on establishment_user.user_id = users.id
    			inner join cqc."Establishment" on "Establishment"."TribalID" = establishment_user.establishment_id
    where users.mustchangepassword = 0;

  LOOP
    FETCH AllUsers INTO CurrentUser;
    EXIT WHEN NOT FOUND;
	
	FullName := CurrentUser.firstname || ' ' || CurrentUser.lastname;
	
	CASE CurrentUser.isreadonly
		WHEN 1 THEN
			NewUserRole = 'Read';
		ELSE
			NewUserRole = 'Edit';
	END CASE;
	
	CASE CurrentUser.isprimary
		WHEN 1 THEN
			NewIsPrimary = true;
		ELSE
			NewIsPrimary = false;
	END CASE;
	
	-- handle null job title
	CASE CurrentUser.jobtitle
		WHEN NULL THEN
			NewJobTitle = MappedEmpty;
		ELSE
			NewJobTitle = CurrentUser.jobtitle;
	END CASE;
	
    SELECT nextval('cqc."User_RegistrationID_seq"') INTO ThisRegistrationID;
    INSERT INTO cqc."User" (
      "RegistrationID",
      "TribalID",
      "UserUID",
      "EstablishmentID",
      "AdminUser",
      "FullNameValue",
      "JobTitleValue",
      "EmailValue",
      "PhoneValue",
      "SecurityQuestionValue",
      "SecurityQuestionAnswerValue",
	  "UserRoleValue",
      "created",
      "updated",
      "updatedby",
      "Archived",
      "IsPrimary") VALUES (
        ThisRegistrationID,
        CurrentUser.id,
        uuid(CurrentUser.uniqueid),
        CurrentUser.establishmentid,
        false,
        FullName,
        COALESCE(CurrentUser.jobtitle, 'Empty'),
        CurrentUser.loweremail,
        NotMapped,
        CurrentUser.passwordquestion,
        NotMapped,
		NewUserRole::cqc.user_role,
        CurrentUser.creationdate,
        MigrationTimestamp,
        MigrationUser,
        false,
		NewIsPrimary
      );
	  
	insert into cqc."Login" (
	 	"RegistrationID",
		"Username",
		"Active",
		"InvalidAttempt",
		"Hash",
		"FirstLogin",
		"LastLoggedIn",
		"PasswdLastChanged"
	) VALUES (
		ThisRegistrationID,
		CurrentUser.lowerusername,
		true,
		0,
		DuffHash,
		null,
		CurrentUser.lastlogindate,
		CurrentUser.lastpasswordchangeddate
	);
  END LOOP;

END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION cqc.MigrateEstablishments()
	RETURNS void AS $$
DECLARE
  AllEstablishments REFCURSOR;
  CurrentEstablishment RECORD;
  NotMapped VARCHAR(10);
  MappedEmpty VARCHAR(10);
  MigrationUser VARCHAR(10);
  ThisEstablishmentID INTEGER;
  NewEstablishmentUID UUID;
  MigrationTimestamp timestamp without time zone;
  FullAddress TEXT;
  NewIsRegulated BOOLEAN;
  NewEmployerType VARCHAR(40);
  NewIsCqcRegistered BOOLEAN;
BEGIN
	NotMapped := 'Not Mapped';
	MappedEmpty := 'Was empty';
	MigrationUser := 'migration';
	MigrationTimestamp := clock_timestamp();
	
  -- first clean up any already migrated data
  -- TODO - tidy up EstablishmentAudit records
  DELETE FROM cqc."Establishment" where "TribalID" is not null;

  OPEN AllEstablishments FOR 	select
			e.id,
			e.name,
			e.address1,
			e.address2,
			e.address3,
			e.town,
			p.locationid,
			e.postcode,
			e.type as employertypeid,
			p.totalstaff as numberofstaff,
			e.nmdsid,
			e.createddate
		from establishment e
			  inner join provision p on p.establishment_id = e.id
--			  inner join establishment_user eu on eu.establishment_id = e.id
--				inner join users on eu.user_id = users.id
--		where
--		  users.mustchangepassword = 0
		 order by e.id asc;

  LOOP
  	BEGIN
		FETCH AllEstablishments INTO CurrentEstablishment;
		EXIT WHEN NOT FOUND;

		FullAddress = CurrentEstablishment.address1 || ', ' || CurrentEstablishment.address2 || ', ' || CurrentEstablishment.address3 || ', ' || CurrentEstablishment.town;

		-- target Establishment needs a UID; unlike User, there is no UID in tribal dataset
		SELECT CAST(substr(CAST(v1uuid."UID" AS TEXT), 0, 15) || '4' || substr(CAST(v1uuid."UID" AS TEXT), 16, 3) || '-89' || substr(CAST(v1uuid."UID" AS TEXT), 22, 36) AS UUID)
			FROM (
				SELECT uuid_in(md5(random()::text || clock_timestamp()::text)::cstring) "UID"
			) v1uuid
		INTO NewEstablishmentUID;

		CASE CurrentEstablishment.locationid
			WHEN NULL THEN
				NewIsRegulated = false;
			ELSE
				NewIsRegulated = true;
		END CASE;

		CASE CurrentEstablishment.employertypeid
			WHEN 130 THEN
				NewEmployerType = 'Local Authority (adult services)';
			WHEN 131 THEN
				NewEmployerType = 'Local Authority (generic/other)';
			WHEN 132 THEN
				NewEmployerType = 'Local Authority (generic/other)';
			WHEN 133 THEN
				NewEmployerType = 'Local Authority (generic/other)';
			WHEN 134 THEN
				NewEmployerType = 'Other';
			WHEN 135 THEN
				NewEmployerType = 'Private Sector';
			WHEN 136 THEN
				NewEmployerType = 'Voluntary / Charity';
			WHEN 137 THEN
				NewEmployerType = 'Other';
			WHEN 138 THEN
				NewEmployerType = 'Private Sector';
			ELSE
				NewEmployerType = 'Other';
		END CASE;
		
		SELECT nextval('cqc."Establishment_EstablishmentID_seq"') INTO ThisEstablishmentID;
		INSERT INTO cqc."Establishment" (
			"EstablishmentID",
			"TribalID",
			"EstablishmentUID",
			"NameValue",
			"Address",
			"LocationID",
			"PostCode",
			"IsRegulated",
			"NmdsID",
			"EmployerTypeValue",
			"NumberOfStaffValue",
			"created",
			"updated",
			"updatedby"
		) VALUES (
			ThisEstablishmentID,
			CurrentEstablishment.id,
			NewEstablishmentUID,
			CurrentEstablishment.name,
			FullAddress,
			CurrentEstablishment.locationid,
			CurrentEstablishment.postcode,
			NewIsRegulated,
			CurrentEstablishment.nmdsid,
			NewEmployerType::cqc.est_employertype_enum,
			CurrentEstablishment.numberofstaff,
			CurrentEstablishment.createddate,
			MigrationTimestamp,
			MigrationUser
		  );
		  
  	EXCEPTION WHEN OTHERS THEN
		RAISE NOTICE 'Skipping establishment with id: %', CurrentEstablishment.id;
	END;
  END LOOP;

END;
$$ LANGUAGE plpgsql;