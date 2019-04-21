-- this is a set of functions/stored procedures for migrating a single establishment

CREATE OR REPLACE FUNCTION cqc.establishment_other_services(tribalId INTEGER, sfcid INTEGER)
  RETURNS void AS $$
DECLARE
BEGIN
  RAISE NOTICE '... mapping other services';
END;
$$ LANGUAGE plpgsql;