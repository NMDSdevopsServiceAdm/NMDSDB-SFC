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
        select id from (
values

(	141969	),
(	216002	),
(	18645	),
(	784	),
(	192067	),
(	1043	),
(	1195	),
(	1222	),
(	1258	),
(	90822	),
(	1605	),
(	210022	),
(	219362	),
(	2816	),
(	232283	),
(	15014	),
(	209202	),
(	104862	),
(	240524	),
(	243724	),
(	223880	),
(	226342	),
(	8217	),
(	8351	),
(	215002	),
(	1247	),
(	207808	),
(	209025	),
(	194698	),
(	228962	),
(	212222	),
(	240183	),
(	161641	),
(	7285	),
(	14480	),
(	4540	),
(	17036	),
(	244522	),
(	220282	),
(	17999	),
(	227322	),
(	229684	),
(	143724	),
(	218476	),
(	214646	),
(	181738	),
(	239422	),
(	20873	),
(	1698	),
(	199618	),
(	230102	),
(	20060	),
(	13762	),
(	235604	),
(	21837	),
(	21837	),
(	19871	),
(	143667	),
(	242984	),
(	243382	),
(	13698	),
(	237002	),
(	220863	),
(	2520	),
(	208743	),
(	228023	),
(	112702	),
(	161309	),
(	202093	),
(	1387	),
(	46822	),
(	194061	),
(	192338	),
(	211764	),
(	10427	),
(	225122	),
(	187213	),
(	190481	),
(	200961	),
(	229922	),
(	192060	),
(	240102	),
(	180039	),
(	226222	),
(	216644	),
(	234644	),
(	189238	),
(	189238	),
(	171120	),
(	170263	),
(	239562	),
(	239562	),
(	93082	),
(	207467	),
(	229583	),
(	233305	),
(	177739	),
(	218323	),
(	234443	),
(	24070	),
(	180766	),
(	236048	),
(	229322	),
(	149076	),
(	222788	),
(	218469	),
(	845	),
(	223262	),
(	226324	),
(	196738	),
(	187578	),
(	216083	),
(	219262	),
(	179420	),
)  as t (id) order by 1 asc
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
