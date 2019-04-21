-- this is a set of functions/stored procedures for migrating a single Worker's training and qualifications
CREATE OR REPLACE FUNCTION cqc.worker_training(tribalId INTEGER, sfcid INTEGER)
  RETURNS void AS $$
DECLARE
BEGIN
  RAISE NOTICE '... mapping training';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION cqc.worker_qualifications(tribalId INTEGER, sfcid INTEGER)
  RETURNS void AS $$
DECLARE
BEGIN
  RAISE NOTICE '... mapping qualifications';
END;
$$ LANGUAGE plpgsql;