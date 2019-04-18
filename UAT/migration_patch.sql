ALTER TABLE cqc."User" ADD COLUMN "IsPrimary" BOOLEAN NOT NULL DEFAULT true;
ALTER TABLE cqc."User" ADD COLUMN "TribalID" INTEGER NULL;
ALTER TABLE cqc."Establishment" ADD COLUMN "TribalID" INTEGER NULL;
ALTER TABLE cqc."Worker" ADD COLUMN "TribalID" INTEGER NULL;

-- temporary disable EstablishmentID
ALTER TABLE cqc."User" ALTER COLUMN "EstablishmentID" DROP NOT NULL;



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
BEGIN
	NotMapped := 'Not Mapped';
	MappedEmpty := 'Was empty';
	MigrationUser := 'migration';
	MigrationTimestamp := clock_timestamp();
	
  -- first clean up any already migrated data
  -- TODO - tidy up UserAudit records
  DELETE FROM cqc."Login" where "RegistrationID" in (select "RegistrationID" from cqc."User" where "TribalID" is not null);
  DELETE FROM cqc."User" where "TribalID" is not null;

  OPEN AllUsers FOR select establishment.id AS "TribalEstablishmentID",users.*, establishment_user.*
    from
      users
        inner join establishment_user on establishment_user.user_id = users.id
    			inner join establishment on establishment.id = establishment_user.establishment_id
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
			NewUserRole = CurrentUser.jobtitle;
	END CASE;
	
	
    SELECT nextval('cqc."User_RegistrationID_seq"') INTO ThisRegistrationID;
    INSERT INTO cqc."User" (
      "RegistrationID",
      "TribalID",
      "UserUID",
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
        false,
        FullName,
        NewJobTitle,
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
  END LOOP;

END;
$$ LANGUAGE plpgsql;