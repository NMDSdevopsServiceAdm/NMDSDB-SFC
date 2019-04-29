-- this is a set of functions/stored procedures for migrating a single Worker's training and qualifications
DROP FUNCTION IF EXISTS migration.worker_training;
CREATE OR REPLACE FUNCTION migration.worker_training(tribalId INTEGER, sfcid INTEGER)
  RETURNS void AS $$
DECLARE
BEGIN
  RAISE NOTICE '... mapping training';
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS migration.worker_qualifications;
CREATE OR REPLACE FUNCTION migration.worker_qualifications(tribalId INTEGER, sfcid INTEGER)
  RETURNS void AS $$
DECLARE
BEGIN
  RAISE NOTICE '... mapping qualifications';
END;
$$ LANGUAGE plpgsql;