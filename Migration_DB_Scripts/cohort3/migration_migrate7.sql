-- PROCEDURE: migration.migratebits()

-- DROP FUNCTION migration.migratebits();

-- Top level function to trigger migration of Establishments and all sub-elements.
-- RUN with call migration.migratebits();

CREATE OR REPLACE PROCEDURE migration.migrate7(
	)
 LANGUAGE plpgsql
AS $BODY$
DECLARE
        Allestbid  REFCURSOR;
        currentestbid record;
Begin 

--truncate migration.errorlog;
--truncate migration.runlog;

OPEN Allestbid  for 
        select id from (select "TribalID" as id from migration.excludecapability) as X order by 1 asc
;
Loop
Begin
FETCH Allestbid INTO currentestbid;
 EXIT WHEN NOT FOUND;

PERFORM  migration.MigrateEstablishments(currentestbid.id);            
PERFORM  migration.MigrateUsers(currentestbid.id);            
PERFORM  migration.MigrateWorkers(currentestbid.id);            
PERFORM  migration.worker_bulk_training(currentestbid.id);            
PERFORM  migration.worker_bulk_qualifications(currentestbid.id);            

END;
END LOOP;

	PERFORM migration.setparents();
	COMMIT;

END;
$BODY$;

ALTER PROCEDURE migration.migrate7()
    OWNER TO postgres;
