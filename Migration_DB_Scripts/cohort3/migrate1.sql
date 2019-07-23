-- PROCEDURE: migration.migratebits()

-- DROP FUNCTION migration.migrate1000();

CREATE OR REPLACE PROCEDURE migration.migrate1(
	)
 LANGUAGE plpgsql
AS $BODY$
DECLARE
BEGIN

--truncate migration.errorlog;

    PERFORM migration.loop_estbid(1,0);
	COMMIT;

    PERFORM migration.loop_estbid_users(1,0);
	COMMIT;

    PERFORM migration.loop_estbid_migrateworkers(1,0);
	COMMIT;

    PERFORM migration.loop_estbid_worker_bulk_training(1,0);
	COMMIT;

    PERFORM migration.loop_estbid_worker_bulk_qualifications(1,0);
	COMMIT;

END;
$BODY$;

ALTER PROCEDURE migration.migrate1()
    OWNER TO postgres;
