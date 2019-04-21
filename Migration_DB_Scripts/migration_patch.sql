ALTER TABLE cqc."User" ADD COLUMN "IsPrimary" BOOLEAN NOT NULL DEFAULT true;
ALTER TABLE cqc."User" ADD COLUMN "TribalID" INTEGER NULL;
ALTER TABLE cqc."Establishment" ADD COLUMN "TribalID" INTEGER NULL;
ALTER TABLE cqc."Worker" ADD COLUMN "TribalID" INTEGER NULL;


ALTER TABLE cqc."EstablishmentServiceUsers" ADD CONSTRAINT establishment_establishmentserviceusers_fk FOREIGN KEY ("EstablishmentID")
        REFERENCES cqc."Establishment" ("EstablishmentID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;
ALTER TABLE cqc."EstablishmentServiceUsers" ADD CONSTRAINT serviceusers_establishmentserviceusers_fk FOREIGN KEY ("ServiceUserID")
        REFERENCES cqc."ServiceUsers" ("ID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;

CREATE OR REPLACE FUNCTION cqc.DeleteAllTransactional()
  RETURNS void AS $$
DECLARE
BEGIN
  delete from cqc."WorkerAudit";
  delete from cqc."WorkerJobs";
  delete from cqc."Worker";
  delete from cqc."EstablishmentCapacity";
  delete from cqc."EstablishmentJobs";
  delete from cqc."EstablishmentServices";
  delete from cqc."EstablishmentLocalAuthority";
  delete from cqc."EstablishmentServiceUsers";

  delete from cqc."Login";
  delete from cqc."UserAudit";
  delete from cqc."PasswdResetTracking";
  delete from cqc."User";
  delete from cqc."EstablishmentAudit";
  delete from cqc."Establishment";
END;
$$ LANGUAGE plpgsql;

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
    where users.mustchangepassword = 0
      and establishment_user.establishment_id in (248,217042,2142,15222,232083,1245,6448,216002,165513,18245,13790,184420,168088,22545,159562,232144,179838,83383,14403,191318,232342,224883,18345,214883,9187,202300,9196,209335,182439,217662,47542,11714,7680,225383,139905,217683,179959,235804,624,7901,236463,8052,208164,222542,17769,189859,178562,234964,199662);

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
      e.createddate,
      ms.sfcid as sfc_tribal_mainserviceid,
      "Establishment"."EstablishmentID" as newestablishmentid
    from establishment e
      inner join (
          select distinct establishment_id from establishment_user inner join users on establishment_user.user_id = users.id where users.mustchangepassword = 0
        ) allusers on allusers.establishment_id = e.id
      left join provision p
        inner join provision_servicetype pst inner join migration.services ms on pst.servicetype_id = ms.tribalid
          on pst.provision_id = p.id and pst.ismainservice = 1
        on p.establishment_id = e.id
	    left join cqc."Establishment" on "Establishment"."TribalID" = e.id
     where e.id in (248,217042,2142,15222,232083,1245,6448,216002,165513,18245,13790,184420,168088,22545,159562,232144,179838,83383,14403,191318,232342,224883,18345,214883,9187,202300,9196,209335,182439,217662,47542,11714,7680,225383,139905,217683,179959,235804,624,7901,236463,8052,208164,222542,17769,189859,178562,234964,199662)
     order by e.id asc;

  LOOP
    BEGIN
    FETCH AllEstablishments INTO CurrentEstablishment;
    EXIT WHEN NOT FOUND;

    RAISE NOTICE 'Processing tribal establishment: % (%)', CurrentEstablishment.id, CurrentEstablishment.newestablishmentid;
    IF CurrentEstablishment.newestablishmentid IS NOT NULL THEN
      -- we have already migrated this record - prepare to enrich/embellish the Establishment
      PERFORM cqc.establishment_other_services(CurrentEstablishment.id, CurrentEstablishment.newestablishmentid);
    ELSE
      -- we have not yet migrated this record because there is no "newestablishmentid" - prepare a basic Establishment for inserting
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
        "MainServiceFKValue",
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
        CurrentEstablishment.sfc_tribal_mainserviceid,
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
    END IF;

    EXCEPTION WHEN OTHERS THEN RAISE WARNING 'Skipping establishment with id: %', CurrentEstablishment.id;
  END;
  END LOOP;

END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION cqc.MigrateWorkers()
  RETURNS void AS $$
DECLARE
  AllWorkers REFCURSOR;
  CurrentWorker RECORD;
  NotMapped VARCHAR(10);
  MappedEmpty VARCHAR(10);
  MigrationUser VARCHAR(10);
  ThisEstablishmentID INTEGER;
  NewWorkerUID UUID;
  MigrationTimestamp timestamp without time zone;
  NewContract VARCHAR(50);
  NewMainJobFK INTEGER;
BEGIN
  NotMapped := 'Not Mapped';
  MappedEmpty := 'Was empty';
  MigrationUser := 'migration';
  MigrationTimestamp := clock_timestamp();

  OPEN AllWorkers FOR select
      w.id as id,
      "Establishment"."EstablishmentID" as establishmentid,
      w.localidentifier,
      w.employmentstatus,
      createddate,
      "Job"."JobID" as jobid,
      "Worker"."ID" as newworkerid
    from worker w
      inner join cqc."Establishment" on w.establishment_id = "Establishment"."TribalID"
      inner join "worker_provision" wp
        inner join migration.jobs mj
          inner join cqc."Job" on "Job"."JobID" = mj.sfcid
          on mj.tribalid = wp.jobrole
        on w.id = wp.worker_id
      left join cqc."Worker" on "Worker"."TribalID" = w.id
    where (w.employmentstatus is not null or w.localidentifier is not null);

  LOOP
    BEGIN
    FETCH AllWorkers INTO CurrentWorker;
    EXIT WHEN NOT FOUND;

    RAISE NOTICE 'Processing tribal worker: % (%)', CurrentWorker.id, CurrentWorker.newworkerid;
    IF CurrentWorker.newworkerid IS NOT NULL THEN
      -- we have already migrated this record - prepare to enrich/embellish the Worker
      PERFORM cqc.worker_other_jobs(CurrentWorker.id, CurrentWorker.newworkerid);

      PERFORM cqc.worker_training(CurrentWorker.id, CurrentWorker.newworkerid);
      PERFORM cqc.worker_qualifications(CurrentWorker.id, CurrentWorker.newworkerid);
    ELSE
      -- we have already migrated this record - prepare to insert new Worker
      -- target Worker needs a UID; unlike User, there is no UID in tribal dataset
      SELECT CAST(substr(CAST(v1uuid."UID" AS TEXT), 0, 15) || '4' || substr(CAST(v1uuid."UID" AS TEXT), 16, 3) || '-89' || substr(CAST(v1uuid."UID" AS TEXT), 22, 36) AS UUID)
        FROM (
          SELECT uuid_in(md5(random()::text || clock_timestamp()::text)::cstring) "UID"
        ) v1uuid
      INTO NewWorkerUID;

      CASE CurrentWorker.employmentstatus
        WHEN 190 THEN
          NewContract = 'Permanent';
        WHEN 191 THEN
          NewContract = 'Temporary';
        WHEN 192 THEN
          NewContract = 'Pool/Bank';
        WHEN 193 THEN
          NewContract = 'Agency';
        ELSE
          NewContract = 'Other';
      END CASE;

    -- Worker does not have a sequence number; it's a serial
      INSERT INTO cqc."Worker" (
        "TribalID",
        "WorkerUID",
        "EstablishmentFK",
        "NameOrIdValue",
        "ContractValue",
        "MainJobFKValue",
        "created",
        "updated",
        "updatedby"
      ) VALUES (
        CurrentWorker.id,
        NewWorkerUID,
        CurrentWorker.establishmentid,
        CurrentWorker.localidentifier,
        NewContract::cqc."WorkerContract",
        CurrentWorker.jobid,
        CurrentWorker.createddate,
        MigrationTimestamp,
        MigrationUser
      );
    END IF;

    EXCEPTION WHEN OTHERS THEN RAISE WARNING 'Skipping worker with id: %', CurrentWorker.id;
  END;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

/* alter table cqc."User" drop constraint "user_establishment_fk";
alter table cqc."User" add CONSTRAINT user_establishment_fk FOREIGN KEY ("EstablishmentID")
        REFERENCES cqc."Establishment" ("EstablishmentID");
		
alter table cqc."Worker" drop constraint "Worker_Establishment_fk";
alter table cqc."Worker" add CONSTRAINT "Worker_Establishment_fk" FOREIGN KEY ("EstablishmentFK")
        REFERENCES cqc."Establishment" ("EstablishmentID");
		
-- ---------------------------------------------
		
alter table cqc."EstablishmentAudit" drop constraint "EstablishmentAudit_User_fk";
alter table cqc."EstablishmentAudit" add CONSTRAINT "EstablishmentAudit_User_fk" FOREIGN KEY ("EstablishmentFK")
        REFERENCES cqc."Establishment" ("EstablishmentID");
		
alter table cqc."EstablishmentCapacity" drop constraint "EstablishmentServiceCapacity_Establishment_fk1";
alter table cqc."EstablishmentCapacity" add CONSTRAINT "EstablishmentServiceCapacity_Establishment_fk1" FOREIGN KEY ("EstablishmentID")
        REFERENCES cqc."Establishment" ("EstablishmentID");
		
alter table cqc."EstablishmentJobs" drop constraint "establishment_establishmentjobs_fk";
alter table cqc."EstablishmentJobs" add CONSTRAINT establishment_establishmentjobs_fk FOREIGN KEY ("EstablishmentID")
        REFERENCES cqc."Establishment" ("EstablishmentID");

alter table cqc."EstablishmentLocalAuthority" drop constraint "establishment_establishmentlocalauthority_fk";
alter table cqc."EstablishmentLocalAuthority" add CONSTRAINT establishment_establishmentlocalauthority_fk FOREIGN KEY ("EstablishmentID")
        REFERENCES cqc."Establishment" ("EstablishmentID");

alter table cqc."EstablishmentServiceUsers" drop constraint "establishment_establishmentserviceusers_fk";
alter table cqc."EstablishmentServiceUsers" add CONSTRAINT establishment_establishmentserviceusers_fk FOREIGN KEY ("EstablishmentID")
        REFERENCES cqc."Establishment" ("EstablishmentID");
		
alter table cqc."EstablishmentServices" drop constraint "estsrvc_estb_fk";
alter table cqc."EstablishmentServices" add CONSTRAINT estsrvc_estb_fk FOREIGN KEY ("EstablishmentID")
        REFERENCES cqc."Establishment" ("EstablishmentID"); */