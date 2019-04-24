-- this is a set of functions/stored procedures for migrating a single establishment
DROP FUNCTION IF EXISTS cqc.establishment_other_services;
CREATE OR REPLACE FUNCTION cqc.establishment_other_services(_tribalId INTEGER, _sfcid INTEGER)
  RETURNS void AS $$
DECLARE
  MyOtherServices REFCURSOR;
  CurrrentOtherService RECORD;
  TotalOtherServices INTEGER;
BEGIN
  RAISE NOTICE '... mapping other services';

  -- now add any "other services"
  OPEN MyOtherServices FOR SELECT ms.sfcid
    FROM establishment e
      INNER JOIN provision p
        INNER JOIN provision_servicetype pst INNER JOIN migration.services ms ON pst.servicetype_id = ms.tribalid
          ON pst.provision_id = p.id and pst.ismainservice = 0
        ON p.establishment_id = e.id
    WHERE e.id=_tribalId;

  -- first delete any existing "other services"
  DELETE FROM cqc."EstablishmentServices" WHERE "EstablishmentID" = _sfcid;

  LOOP
    BEGIN
      FETCH MyOtherServices INTO CurrrentOtherService;
      EXIT WHEN NOT FOUND;

      INSERT INTO cqc."EstablishmentServices" ("EstablishmentID", "ServiceID") VALUES (_sfcid, CurrrentOtherService.sfcid);

      EXCEPTION WHEN OTHERS THEN RAISE WARNING 'Failed to process other services: % (%)', _tribalId, _sfcid;
    END;
  END LOOP;

  -- update the Establishment's OtherServices change property
  SELECT count(0) FROM cqc."EstablishmentServices" WHERE "EstablishmentID" = _sfcid INTO TotalOtherServices;
  IF (TotalOtherServices > 0) THEN
    UPDATE
      cqc."Establishment"
    SET
      "OtherServicesSavedAt" = now(),
      "OtherServicesSavedBy" = 'migration'
    WHERE
      "EstablishmentID" = _sfcid;
  END IF;
END;
$$ LANGUAGE plpgsql;

-- intentionally not sharing anything recordset between "other services" and "capacities"
DROP FUNCTION IF EXISTS cqc.establishment_capacities;
CREATE OR REPLACE FUNCTION cqc.establishment_capacities(_tribalId INTEGER, _sfcid INTEGER)
  RETURNS void AS $$
DECLARE
  MyCapacities REFCURSOR;
  CurrrentCapacityService RECORD;
  TargetCapacities REFCURSOR;
  TargetTotalCapacityRecord RECORD;
  TargetUtilisationRecord RECORD;
  TotalCapacities INTEGER;
BEGIN
  RAISE NOTICE '... mapping capacities';

  -- first delete any existing "capacities"
  DELETE FROM cqc."EstablishmentCapacity" WHERE "EstablishmentID" = _sfcid;

  -- capacities in tribal are recorded in the same table as "main/other services"
  OPEN MyCapacities FOR SELECT ms.sfcid, pst.totalcapacity, pst.currentutilisation
    FROM establishment e
      INNER JOIN provision p
        INNER JOIN provision_servicetype pst INNER JOIN migration.services ms ON pst.servicetype_id = ms.tribalid
          ON pst.provision_id = p.id and pst.ismainservice = 0
        ON p.establishment_id = e.id
    WHERE e.id=_tribalId;

  LOOP
    BEGIN
      FETCH MyCapacities INTO CurrrentCapacityService;
      EXIT WHEN NOT FOUND;
	  
	    RAISE NOTICE 'CurrrentCapacityService: %', CurrrentCapacityService;
      OPEN TargetCapacities FOR SELECT
          "ServiceCapacityID" servicecapacityid,
          "ServiceID" AS serviceid,
          "Question" as question,
          "Sequence" as questionsequence
        FROM cqc."ServicesCapacity"
        WHERE "ServiceID" = CurrrentCapacityService.sfcid
        ORDER BY questionsequence ASC;

      -- we're expecting up to two target capacities for the given source (ref) service
      FETCH TargetCapacities INTO TargetTotalCapacityRecord;
      FETCH TargetCapacities INTO TargetUtilisationRecord;
	  
      --RAISE NOTICE 'TargetTotalCapacityRecord: %', TargetTotalCapacityRecord;
      --RAISE NOTICE 'TargetUtilisationRecord: %', TargetUtilisationRecord;
      
      IF (TargetTotalCapacityRecord.servicecapacityid IS NOT NULL AND TargetUtilisationRecord.servicecapacityid IS NOT NULL) THEN
        -- expecting two capacities
		    IF (CurrrentCapacityService.totalcapacity IS NOT NULL) THEN
        	INSERT INTO cqc."EstablishmentCapacity" ("EstablishmentID", "ServiceCapacityID","Answer")
          		VALUES (_sfcid, TargetTotalCapacityRecord.servicecapacityid, CurrrentCapacityService.totalcapacity);
		    END IF;
		
		    IF (CurrrentCapacityService.currentutilisation IS NOT NULL) THEN
	        INSERT INTO cqc."EstablishmentCapacity" ("EstablishmentID", "ServiceCapacityID","Answer")
    	      VALUES (_sfcid, TargetUtilisationRecord.servicecapacityid, CurrrentCapacityService.currentutilisation);
		    END IF;
      ELSIF (TargetTotalCapacityRecord.servicecapacityid IS NOT NULL AND TargetUtilisationRecord.servicecapacityid IS NULL) THEN
        -- expecting just one capacity
		    IF (CurrrentCapacityService.totalcapacity IS NOT NULL) THEN
	        INSERT INTO cqc."EstablishmentCapacity" ("EstablishmentID", "ServiceCapacityID","Answer")
    	      VALUES (_sfcid, TargetTotalCapacityRecord.servicecapacityid, CurrrentCapacityService.totalcapacity);
		    END IF;
      ELSE
        -- do nothing - skip over this source service as target has no capacities
      END IF;

      --EXCEPTION WHEN OTHERS THEN RAISE WARNING 'Failed to process capacities: % (%)', _tribalId, _sfcid;

      CLOSE TargetCapacities;
    END;
  END LOOP;

  -- update the Establishment's OtherServices change property
  SELECT count(0) FROM cqc."EstablishmentCapacity" WHERE "EstablishmentID" = _sfcid INTO TotalCapacities;
  IF (TotalCapacities > 0) THEN
    UPDATE
      cqc."Establishment"
    SET
      "CapacityServicesSavedAt" = now(),
      "CapacityServicesSavedBy" = 'migration'
    WHERE
      "EstablishmentID" = _sfcid;
  END IF;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS cqc.establishment_service_users;
CREATE OR REPLACE FUNCTION cqc.establishment_service_users(_tribalId INTEGER, _sfcid INTEGER)
  RETURNS void AS $$
DECLARE
  MyServiceUsers REFCURSOR;
  CurrrentServiceUser RECORD;
  TotalServiceUsers INTEGER;
BEGIN
  RAISE NOTICE '... mapping service users';

  -- now add any "other services"
  OPEN MyServiceUsers FOR SELECT ms.sfcid
    FROM establishment e
      INNER JOIN provision p
        inner join provision_usertype
          inner join usertype
            inner join migration.serviceusers ms on ms.tribalid = usertype.id
            on usertype.id = provision_usertype.usertype_id
          on provision_usertype.provision_id = p.id
        ON p.establishment_id = e.id
    WHERE e.id=_tribalId;

  -- first delete any existing "service users"
  DELETE FROM cqc."EstablishmentServiceUsers" WHERE "EstablishmentID" = _sfcid;

  LOOP
    BEGIN
      FETCH MyServiceUsers INTO CurrrentServiceUser;
      EXIT WHEN NOT FOUND;

      INSERT INTO cqc."EstablishmentServiceUsers" ("EstablishmentID", "ServiceUserID") VALUES (_sfcid, CurrrentServiceUser.sfcid);

      EXCEPTION WHEN OTHERS THEN RAISE WARNING 'Failed to process service users: % (%)', _tribalId, _sfcid;
    END;
  END LOOP;

  -- update the Establishment's ServiceUsers change property
  SELECT count(0) FROM cqc."EstablishmentServiceUsers" WHERE "EstablishmentID" = _sfcid INTO TotalServiceUsers;
  IF (TotalServiceUsers > 0) THEN
    UPDATE
      cqc."Establishment"
    SET
      "ServiceUsersSavedAt" = now(),
      "ServiceUsersSavedBy" = 'migration'
    WHERE
      "EstablishmentID" = _sfcid;
  END IF;
END;
$$ LANGUAGE plpgsql;


DROP FUNCTION IF EXISTS cqc.establishment_local_authorities;
CREATE OR REPLACE FUNCTION cqc.establishment_local_authorities(_tribalId INTEGER, _sfcid INTEGER)
  RETURNS void AS $$
DECLARE
  MyLocalAuthorities REFCURSOR;
  CurrrentLocalAuthority RECORD;
  TotalLocalAuthorities INTEGER;
  TargetCssrID INTEGER;
  TargetCssrName VARCHAR(200);
BEGIN
  RAISE NOTICE '... mapping Local Authorities (CSSRs)';

  -- note - there are four source CSSRs that map different to the target CSSRs
  --        therefore it is necessary to do a left join from cssr to cqc."Cssr"
  OPEN MyLocalAuthorities FOR SELECT
      cssr.code::INTEGER AS sourcecssrid,
      cssr.name AS sourcecssr,
      DistinctTargetCssrs."CssrID" AS targetcssrid,
      DistinctTargetCssrs."CssR" AS targetcssr
    FROM establishment
      INNER JOIN establishment_cssr
        INNER JOIN cssr
          LEFT JOIN (SELECT DISTINCT "CssrID", "CssR" FROM cqc."Cssr") DistinctTargetCssrs ON cssr.code::INTEGER = DistinctTargetCssrs."CssrID"
          ON cssr.id = establishment_cssr.cssr_id
      ON establishment.id = establishment_cssr.establishment_id
    WHERE establishment.id=_tribalId;

  -- first delete any existing "local authorities"
  DELETE FROM cqc."EstablishmentLocalAuthority" WHERE "EstablishmentID" = _sfcid;

  LOOP
    BEGIN
      FETCH MyLocalAuthorities INTO CurrrentLocalAuthority;
      EXIT WHEN NOT FOUND;

      CASE CurrrentLocalAuthority.sourcecssrid
        WHEN 625 THEN
          TargetCssrID = 996;
          TargetCssrName = CurrrentLocalAuthority.sourcecssr;
        WHEN 626 THEN
          TargetCssrID = 997;
          TargetCssrName = CurrrentLocalAuthority.sourcecssr;
        WHEN 326 THEN
          TargetCssrID = 998;
          TargetCssrName = CurrrentLocalAuthority.sourcecssr;
        WHEN 327 THEN
          TargetCssrID = 999;
          TargetCssrName = CurrrentLocalAuthority.sourcecssr;
        ELSE
          TargetCssrID = CurrrentLocalAuthority.targetcssrid;
          TargetCssrName = CurrrentLocalAuthority.targetcssr;
      END CASE;

      INSERT INTO cqc."EstablishmentLocalAuthority" ("EstablishmentID", "CssrID", "CssR")
        VALUES (_sfcid, TargetCssrID, TargetCssrName);

      EXCEPTION WHEN OTHERS THEN RAISE WARNING 'Failed to process Local Authority: % (%) - %', _tribalId, _sfcid, CurrrentLocalAuthority.sourcecssr;
    END;
  END LOOP;

  -- update the Establishment's ShareWithLA change property
  SELECT count(0) FROM cqc."EstablishmentLocalAuthority" WHERE "EstablishmentID" = _sfcid INTO TotalLocalAuthorities;
  IF (TotalLocalAuthorities > 0) THEN
    RAISE NOTICE '...... sharing with LA and sharing to true';
    UPDATE
      cqc."Establishment"
    SET
      "ShareWithLASavedAt" = now(),
      "ShareWithLASavedBy" = 'migration',
      "ShareDataValue" = true,
      "ShareDataWithLA" = true
    WHERE
      "EstablishmentID" = _sfcid;
  ELSE
    RAISE NOTICE '...... sharing with LA and sharing to false';
    UPDATE
      cqc."Establishment"
    SET
      "ShareWithLASavedAt" = now(),
      "ShareWithLASavedBy" = 'migration',
      "ShareDataValue" = false,
      "ShareDataWithLA" = false
    WHERE
      "EstablishmentID" = _sfcid;
  END IF;
END;
$$ LANGUAGE plpgsql;