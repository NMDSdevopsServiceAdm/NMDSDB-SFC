-- PROCEDURE: migration.migratebits()

-- DROP FUNCTION migration.migratebits();

CREATE OR REPLACE PROCEDURE migration.migratebits(
	)
 LANGUAGE plpgsql
AS $BODY$
DECLARE
BEGIN

--truncate migration.errorlog;

FOR loop_counter IN 0..20000 by 500 LOOP
    raise NOTICE 'Establishments %',loop_counter;
    PERFORM migration.loop_estbid(500,loop_counter);
	COMMIT;
END LOOP;

FOR loop_counter IN 0..20000 by 5000 LOOP
    raise NOTICE 'Users %',loop_counter;
    PERFORM migration.loop_estbid_users(5000,loop_counter);
	COMMIT;
END LOOP;

FOR loop_counter IN 0..20000 by 500 LOOP
    raise NOTICE 'Workers %',loop_counter;
    PERFORM migration.loop_estbid_migrateworkers(500,loop_counter);
	COMMIT;
END LOOP;

FOR loop_counter IN 0..20000 by 2000 LOOP
    raise NOTICE 'Training %',loop_counter;
    PERFORM migration.loop_estbid_worker_bulk_training(2000,loop_counter);
	COMMIT;
END LOOP;

FOR loop_counter IN 0..20000 by 2000 LOOP
    raise NOTICE 'Qualifications %',loop_counter;
    PERFORM migration.loop_estbid_worker_bulk_qualifications(2000,loop_counter);
	COMMIT;
END LOOP;

END;
$BODY$;

ALTER PROCEDURE migration.migratebits()
    OWNER TO postgres;
