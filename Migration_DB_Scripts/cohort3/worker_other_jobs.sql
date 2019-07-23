-- FUNCTION: migration.worker_other_jobs(integer, integer)

-- DROP FUNCTION migration.worker_other_jobs(integer, integer);

CREATE OR REPLACE FUNCTION migration.worker_other_jobs(
	_tribalid integer,
	_sfcid integer)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
  MyOtherJobs REFCURSOR;
  CurrrentOtherJob RECORD;
  TotalOtherJobs INTEGER;
BEGIN
  RAISE NOTICE '... mapping other jobs';

  OPEN MyOtherJobs FOR SELECT jobs.sfcid AS sfcid
    FROM worker_otherjobrole
	    INNER JOIN migration.jobs ON jobs.tribalid=worker_otherjobrole.jobrole
    where worker_id = _tribalId;

  -- first delete any existing "other jobs"
  DELETE FROM cqc."WorkerJobs" WHERE "WorkerFK" = _sfcid;

  LOOP
    BEGIN
      FETCH MyOtherJobs INTO CurrrentOtherJob;
      EXIT WHEN NOT FOUND;

      INSERT INTO cqc."WorkerJobs" ("WorkerFK", "JobFK")
        VALUES (_sfcid, CurrrentOtherJob.sfcid)
        ON CONFLICT DO NOTHING;

      EXCEPTION WHEN OTHERS THEN RAISE WARNING 'Failed to process other jobs: % (%)', _tribalId, _sfcid;
    END;
  END LOOP;

  -- update the Worker's OtherServices change property
  SELECT count(0) FROM cqc."WorkerJobs" WHERE "WorkerFK" = _sfcid INTO TotalOtherJobs;
  IF (TotalOtherJobs > 0) THEN
    UPDATE
      cqc."Worker"
    SET
      "OtherJobsValue" = 'Yes'::cqc."WorkerOtherJobs",
      "OtherJobsSavedAt" = now(),
      "OtherJobsSavedBy" = 'migration'
    WHERE
      "ID" = _sfcid;
  END IF;END;
$BODY$;

ALTER FUNCTION migration.worker_other_jobs(integer, integer)
    OWNER TO postgres;
