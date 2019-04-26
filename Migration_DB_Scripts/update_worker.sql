-- this is a set of functions/stored procedures for migrating a single worker

CREATE OR REPLACE FUNCTION cqc.worker_other_jobs(tribalId INTEGER, sfcid INTEGER)
  RETURNS void AS $$
DECLARE
BEGIN
  RAISE NOTICE '... mapping other jobs';
END;
$$ LANGUAGE plpgsql;