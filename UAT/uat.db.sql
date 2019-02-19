--\i ../create_db_ddl.sql
-- creat cqcref schema and move the pcodedata and loction table into cqcref schema from cqc schema
CREATE SCHEMA cqcref
    AUTHORIZATION sfcadmin;

alter table cqc.pcodedata set schema cqcref;
alter table cqc.location set schema cqcref;


-- SERVICE MAPPING UPDATES  --  https://trello.com/c/geZXmbDi

alter table cqc.services add column "reportingID" integer;

ALTER TABLE cqc.services ADD CONSTRAINT "reportingID_Unq" UNIQUE ("reportingID");


	
update cqc.services  set  "reportingID"=1	where id=24		;
update cqc.services  set  "reportingID"=2	where id=25		;
update cqc.services  set  "reportingID"=53	where id=13		;
update cqc.services  set  "reportingID"=5	where id=12		;
update cqc.services  set  "reportingID"=6	where id=9		;
update cqc.services  set  "reportingID"=7	where id=10		;
update cqc.services  set  "reportingID"=8	where id=20		;
update cqc.services  set  "reportingID"=73	where id=35		;
update cqc.services  set  "reportingID"=10	where id=11		;
update cqc.services  set  "reportingID"=54	where id=21		;
update cqc.services  set  "reportingID"=55	where id=23		;
update cqc.services  set  "reportingID"=12	where id=18		;
update cqc.services  set  "reportingID"=13	where id=1		;
update cqc.services  set  "reportingID"=14	where id=7		;
update cqc.services  set  "reportingID"=15	where id=2		;
update cqc.services  set  "reportingID"=16	where id=8		;
update cqc.services  set  "reportingID"=17	where id=19		;
update cqc.services  set  "reportingID"=18	where id=3		;
update cqc.services  set  "reportingID"=19	where id=5		;
update cqc.services  set  "reportingID"=20	where id=4		;
update cqc.services  set  "reportingID"=21	where id=6		;
update cqc.services  set  "reportingID"=61	where id=27		;
update cqc.services  set  "reportingID"=62	where id=28		;
update cqc.services  set  "reportingID"=63	where id=26		;
update cqc.services  set  "reportingID"=64	where id=29		;
update cqc.services  set  "reportingID"=66	where id=30		;
update cqc.services  set  "reportingID"=67	where id=32		;
update cqc.services  set  "reportingID"=68	where id=31		;
update cqc.services  set  "reportingID"=69	where id=33		;
update cqc.services  set  "reportingID"=70	where id=34		;
update cqc.services  set  "reportingID"=71	where id=17		;
update cqc.services  set  "reportingID"=52	where id=15		;
update cqc.services  set  "reportingID"=72	where id=16		;
update cqc.services  set  "reportingID"=60	where id=36		;
update cqc.services  set  "reportingID"=76	where id=14		;
update cqc.services  set  "reportingID"=77	where id=22		;
