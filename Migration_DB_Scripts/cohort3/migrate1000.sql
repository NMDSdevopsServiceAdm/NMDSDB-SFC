-- PROCEDURE: migration.migratebits()

-- DROP FUNCTION migration.migrate1000();

CREATE OR REPLACE PROCEDURE migration.migrate1000(
	)
 LANGUAGE plpgsql
AS $BODY$
DECLARE
BEGIN

truncate migration.errorlog;

FOR loop_counter IN 0..999 by 100 LOOP
    raise NOTICE 'Establishments %',loop_counter;
    PERFORM migration.loop_estbid(100,loop_counter);
	COMMIT;
END LOOP;

FOR loop_counter IN 0..999 by 100 LOOP
    raise NOTICE 'Users %',loop_counter;
    PERFORM migration.loop_estbid_users(100,loop_counter);
	COMMIT;
END LOOP;

FOR loop_counter IN 0..999 by 100 LOOP
    raise NOTICE 'Workers %',loop_counter;
    PERFORM migration.loop_estbid_migrateworkers(100,loop_counter);
	COMMIT;
END LOOP;

FOR loop_counter IN 0..999 by 100 LOOP
    raise NOTICE 'Training %',loop_counter;
    PERFORM migration.loop_estbid_worker_bulk_training(100,loop_counter);
	COMMIT;
END LOOP;

FOR loop_counter IN 0..999 by 100 LOOP
    raise NOTICE 'Qualifications %',loop_counter;
    PERFORM migration.loop_estbid_worker_bulk_qualifications(100,loop_counter);
	COMMIT;
END LOOP;

	PERFORM migration.setparents();
	COMMIT;

END;
$BODY$;

ALTER PROCEDURE migration.migrate1000()
    OWNER TO postgres;
