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
  
  OPEN AllUsers FOR select cqc."Establishment"."EstablishmentID" AS establishmentid, "User"."TribalID" AS newuserid, users.*, establishment_user.*
    from
      users
        inner join establishment_user on establishment_user.user_id = users.id
          inner join cqc."Establishment" on "Establishment"."TribalID" = establishment_user.establishment_id
		    left join cqc."User" on "User"."TribalID" = users.id
    where users.mustchangepassword = 0
      and establishment_user.establishment_id in (248,189859,225383,59, 248, 669, 187078, 215842, 162286, 2533, 2952, 200560, 225586, 3278, 60682, 5228, 12937, 232842, 10121, 10757, 216264, 12041, 17047, 177958, 136485, 15000, 20876, 233642, 17661, 168369, 40762, 205162, 154806, 42683, 45882, 196119, 85603, 181062, 218926, 196840, 144133, 215263, 170258, 217893, 231842);

  LOOP
    FETCH AllUsers INTO CurrentUser;
    EXIT WHEN NOT FOUND;

    IF CurrentUser.newuserid IS NULL THEN
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
        
      INSERT INTO cqc."Login" (
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
    END IF;

  END LOOP;

END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION cqc.migrateestablishments(
	)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
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
     where e.id in (248,189859,225383,59, 248, 669, 187078, 215842, 162286, 2533, 2952, 200560, 225586, 3278, 60682, 5228, 12937, 232842, 10121, 10757, 216264, 12041, 17047, 177958, 136485, 15000, 20876, 233642, 17661, 168369, 40762, 205162, 154806, 42683, 45882, 196119, 85603, 181062, 218926, 196840, 144133, 215263, 170258, 217893, 231842)
     order by e.id asc;

  LOOP
    BEGIN
    FETCH AllEstablishments INTO CurrentEstablishment;
    EXIT WHEN NOT FOUND;

	RAISE NOTICE 'Processing tribal establishment: % (%)', CurrentEstablishment.id, CurrentEstablishment.newestablishmentid;
    IF CurrentEstablishment.newestablishmentid IS NOT NULL THEN
      -- we have already migrated this record - prepare to enrich/embellish the Establishment
      PERFORM cqc.establishment_other_services(CurrentEstablishment.id, CurrentEstablishment.newestablishmentid);
      PERFORM cqc.establishment_capacities(CurrentEstablishment.id, CurrentEstablishment.newestablishmentid);
      PERFORM cqc.establishment_service_users(CurrentEstablishment.id, CurrentEstablishment.newestablishmentid);
      PERFORM cqc.establishment_local_authorities(CurrentEstablishment.id, CurrentEstablishment.newestablishmentid);
      PERFORM cqc.establishment_jobs(CurrentEstablishment.id, CurrentEstablishment.newestablishmentid);
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

      -- having inserted the new establishment, adorn with additional properties
      PERFORM cqc.establishment_other_services(CurrentEstablishment.id, ThisEstablishmentID);
      PERFORM cqc.establishment_capacities(CurrentEstablishment.id, ThisEstablishmentID);
      PERFORM cqc.establishment_service_users(CurrentEstablishment.id, ThisEstablishmentID);
      PERFORM cqc.establishment_local_authorities(CurrentEstablishment.id, ThisEstablishmentID);
      PERFORM cqc.establishment_jobs(CurrentEstablishment.id, CurrentEstablishment.newestablishmentid);

    END IF;

    EXCEPTION WHEN OTHERS THEN RAISE WARNING 'Skipping establishment with id: %', CurrentEstablishment.id;
  END;
  END LOOP;

END;
$BODY$;


CREATE OR REPLACE FUNCTION cqc.migrateworkers(
	)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
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
$BODY$;

create schema if not exists migration;

-- from services to services
drop table if exists migration.services;
create table migration.services (
	tribalid INTEGER NOT NULL,
	sfcid INTEGER NOT NULL
);
insert into migration.services (tribalid, sfcid) values
  (1, 24),
  (2, 25),
  (3, 12),
  (4, 13),
  (5, 12),
  (6, 9),
  (7, 10),
  (8, 20),
  (9, 15),
  (10, 11),
  (11, 15),
  (12, 18),
  (13, 1),
  (14, 7),
  (15, 2),
  (16, 8),
  (17, 19),
  (18, 3),
  (19, 5),
  (20, 4),
  (21, 6),
  (22, 15),
  (23, 15),
  (24, 14),
  (25, 14),
  (26, 14),
  (27, 14),
  (28, 14),
  (29, 14),
  (30, 14),
  (31, 14),
  (32, 14),
  (33, 14),
  (34, 14),
  (35, 14),
  (36, 14),
  (37, 14),
  (38, 14),
  (39, 14),
  (40, 28),
  (41, 14),
  (42, 17),
  (43, 17),
  (44, 17),
  (45, 17),
  (46, 17),
  (47, 17),
  (48, 28),
  (49, 30),
  (50, 15),
  (51, 17),
  (52, 15),
  (53, 13),
  (54, 21),
  (55, 23),
  (56, 14),
  (57, 15),
  (58, 14),
  (59, 14),
  (60, 36),
  (61, 27),
  (62, 28),
  (63, 26),
  (64, 29),
  (65, 15),
  (66, 30),
  (67, 32),
  (68, 27),
  (69, 33),
  (70, 34),
  (71, 17),
  (72, 16),
  (73, 35);


-- from jobs to jobs
drop table if exists migration.jobs;
create table migration.jobs (
	tribalid INTEGER NOT NULL,
	sfcid INTEGER NOT NULL
);
insert into migration.jobs (tribalid, sfcid) values 
  (80, 26),
  (81, 15),
  (82, 13),
  (83, 22),
  (84, 28),
  (85, 27),
  (86, 25),
  (87, 10),
  (88, 11),
  (89, 12),
  (90, 3),
  (91, 5),
  (92, 5),
  (93, 3),
  (94, 18),
  (95, 23),
  (96, 4),
  (97, 16),
  (98, 21),
  (99, 21),
  (100, 21),
  (101, 29),
  (102, 20),
  (103, 14),
  (104, 2),
  (105, 5),
  (106, 21),
  (107, 21),
  (108, 1),
  (109, 24),
  (140, 18),
  (141, 17),
  (142, 16),
  (143, 7),
  (144, 8),
  (145, 9);

-- from usertype to serviceusers
drop table if exists migration.serviceusers;
create table migration.serviceusers (
	tribalid INTEGER NOT NULL,
	sfcid INTEGER NOT NULL
);
insert into migration.serviceusers (tribalid, sfcid) values 
  (1, 1),
  (2, 2),
  (3, 9),
  (4, 5),
  (5, 4),
  (6, 2),
  (7, 6),
  (8, 16),
  (9, 18),
  (10, 19),
  (11, 19),
  (12, 19),
  (13, 19),
  (14, 19),
  (15, 19),
  (16, 19),
  (17, 19),
  (18, 20),
  (19, 21),
  (20, 22),
  (21, 23),
  (22, 3),
  (23, 4),
  (24, 4),
  (25, 5),
  (26, 6),
  (27, 7),
  (28, 10),
  (29, 12),
  (30, 13),
  (31, 17),
  (33, 19),
  (34, 19),
  (35, 19),
  (36, 9),
  (37, 9),
  (38, 9),
  (39, 18),
  (40, 18),
  (41, 18),
  (42, 19),
  (43, 19),
  (44, 19);