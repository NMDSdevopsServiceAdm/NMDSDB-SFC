-- Fixes for Cohort 3
-- Load jobrolecategory

CREATE OR REPLACE FUNCTION migration.migrateworkers()
 RETURNS void
 LANGUAGE plpgsql
AS $function$DECLARE
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
      w.createddate,
      "Job"."JobID" as jobid,
      "Worker"."ID" as newworkerid,
      originalcountrycode,
      targetcountryid,
      originalnationalitycode,
      targetnationalityid,
      wp.jobrolecategory,
      wp.contractedhours,
      wp.hourlyrate,
      worker_decrypted.dob_dcd as target_dob,
      worker_decrypted.ni_dcd as target_ni,
      w.*
    from worker w
      inner join cqc."Establishment" on w.establishment_id = "Establishment"."TribalID"
      inner join "worker_provision" wp
        inner join migration.jobs mj
          inner join cqc."Job" on "Job"."JobID" = mj.sfcid
          on mj.tribalid = wp.jobrole
        on w.id = wp.worker_id
      left join cqc."Worker" on "Worker"."TribalID" = w.id
      left join (SELECT country.numeric AS originalcountrycode, "ID" AS targetcountryid
                 FROM country
                  LEFT JOIN migration.country AS migrationcountry
                    INNER JOIN cqc."Country" ON migrationcountry.sfcid = "Country"."ID"
                    ON migrationcountry.tribalid = country.id
                ) AS MappedCountries ON MappedCountries.originalcountrycode = w.countryofbirth
	    left join (SELECT country.numeric AS originalnationalitycode, "ID" AS targetnationalityid
                 FROM country
                  LEFT JOIN migration.nationality as migrationnationality
                    INNER JOIN cqc."Nationality" on migrationnationality.sfcid = "Nationality"."ID"
                    ON migrationnationality.tribalid = country.id
                ) AS MappedNationalities ON MappedNationalities.originalnationalitycode = w.nationality
      left join worker_decrypted on worker_decrypted.id = w.id
    where (w.employmentstatus = 195 or w.localidentifier is not null);   -- employmenbt status of 195 is volunteer (we're not migrating volunteer workers)

  LOOP
    BEGIN
    FETCH AllWorkers INTO CurrentWorker;
    EXIT WHEN NOT FOUND;

    RAISE NOTICE 'Processing tribal worker: % (%)', CurrentWorker.id, CurrentWorker.newworkerid;
    IF CurrentWorker.newworkerid IS NOT NULL THEN
      -- we have already migrated this record - prepare to enrich/embellish the Worker
      PERFORM migration.worker_easy_properties(CurrentWorker.id, CurrentWorker.newworkerid, CurrentWorker);
      PERFORM migration.worker_other_jobs(CurrentWorker.id, CurrentWorker.newworkerid);

    ELSE
      -- we have already migrated this record - prepare to insert new Worker
      -- target Worker needs a UID; unlike User, there is no UID in tribal dataset
      SELECT CAST(substr(CAST(v1uuid."UID" AS TEXT), 0, 15) || '4' || substr(CAST(v1uuid."UID" AS TEXT), 16, 3) || '-89' || substr(CAST(v1uuid."UID" AS TEXT), 22, 36) AS UUID)
        FROM (
          SELECT uuid_in(md5(random()::text || clock_timestamp()::text)::cstring) "UID"
        ) v1uuid
      INTO NewWorkerUID;

      IF (CurrentWorker.employmentstatus IS NULL) THEN
            NewContract = 'Permanent';
      ELSE
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
      END IF;

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

      -- having inserted the new worker, adorn with additional properties
      PERFORM migration.worker_easy_properties(CurrentWorker.id, CurrentWorker.newworkerid, CurrentWorker);
      PERFORM migration.worker_other_jobs(CurrentWorker.id, CurrentWorker.newworkerid);
    END IF;

    EXCEPTION WHEN OTHERS THEN RAISE WARNING 'Skipping worker with id: %', CurrentWorker.id;
    raise notice E'Got exception:
	
        SQLSTATE: % 
        SQLERRM: %', SQLSTATE, SQLERRM;     
  END;
  END LOOP;
END;
$function$



