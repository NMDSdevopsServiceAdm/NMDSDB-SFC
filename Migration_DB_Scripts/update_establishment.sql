-- this is a set of functions/stored procedures for migrating a single establishment
DROP FUNCTION cqc.establishment_other_services;
CREATE OR REPLACE FUNCTION cqc.establishment_other_services(_tribalId INTEGER, _sfcid INTEGER)
  RETURNS void AS $$
DECLARE
  MyOtherServices REFCURSOR;
  CurrrentOtherService RECORD;
BEGIN
  RAISE NOTICE '... mapping other services';

  -- first delete any existing "other services"
  DELETE FROM cqc."EstablishmentServices" WHERE "EstablishmentID" = _sfcid;

  -- now add any "other services"
  OPEN MyOtherServices FOR SELECT ms.sfcid
    FROM establishment e
      INNER JOIN provision p
        INNER JOIN provision_servicetype pst INNER JOIN migration.services ms ON pst.servicetype_id = ms.tribalid
          ON pst.provision_id = p.id and pst.ismainservice = 0
        ON p.establishment_id = e.id
    WHERE e.id=_tribalId;

  LOOP
    BEGIN
      FETCH MyOtherServices INTO CurrrentOtherService;
      EXIT WHEN NOT FOUND;

      INSERT INTO cqc."EstablishmentServices" ("EstablishmentID", "ServiceID") VALUES (_sfcid, CurrrentOtherService.sfcid);

      EXCEPTION WHEN OTHERS THEN RAISE WARNING 'Failed to process other services: % (%)', _tribalId, _sfcid;
    END;
  END LOOP;
END;
$$ LANGUAGE plpgsql;