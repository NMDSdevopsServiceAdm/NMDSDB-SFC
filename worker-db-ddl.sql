-- DDL for Workers

-- DROP/CLEAN SCHEMA
DROP TABLE IF EXISTS cqc."Worker";
DROP TYPE IF EXISTS cqc."WorkerContract";

-- CREATE/RE-CREATE SCHEMA
CREATE TYPE cqc."WorkerContract" AS ENUM (
    'Permanent',
    'Temporary',
    'Pool/Bank',
	'Agency',
	'Other'
);


CREATE TABLE IF NOT EXISTS cqc."Worker" (
	"ID" serial NOT NULL PRIMARY KEY,
	"WorkerUID" uuid NOT NULL,
	"EstablishmentFK" integer NOT NULL,
	"NameOrID" varchar(50),
	"Contract" cqc."WorkerContract",
	"MainJobFK" INTEGER,
	created TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
	updated TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),	-- note, on creation of record, updated and created are equal
    CONSTRAINT "Worker_ID_unq" UNIQUE ("ID"),
    CONSTRAINT "Worker_Establishment_fk" FOREIGN KEY ("EstablishmentFK") REFERENCES cqc."Establishment" ("EstablishmentID") MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "Worker_Job_mainjob_fk" FOREIGN KEY ("MainJobFK") REFERENCES cqc."Job" ("JobID") MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "Worker_NameID_unq" UNIQUE ("NameOrID", "EstablishmentFK"),
	CONSTRAINT "Worker_WorkerUID_unq" UNIQUE ("WorkerUID", "EstablishmentFK")
);

-- REFERENCE DATA

-- new jobs data
insert into cqc."Job" ("JobID", "JobName") values (22, 'Any childrens / young people''s job role');
insert into cqc."Job" ("JobID", "JobName") values (23, 'Assessment Officer');
insert into cqc."Job" ("JobID", "JobName") values (24, 'Care Coordinator');
insert into cqc."Job" ("JobID", "JobName") values (25, 'Care Navigator');
insert into cqc."Job" ("JobID", "JobName") values (26, 'Employment Suppor');
insert into cqc."Job" ("JobID", "JobName") values (27, 'Nursing Assistant');
insert into cqc."Job" ("JobID", "JobName") values (28, 'Nursing Associate');
insert into cqc."Job" ("JobID", "JobName") values (29, 'Technician');

-- update jobs
update cqc."Job" set "JobName"='Allied Health Professional (not Occupational Therapist)' where "JobID"=15;
update cqc."Job" set "JobName"='Other job roles directly involved in providing care' where "JobID"=5;
update cqc."Job" set "JobName"='Other job roles not directly involved in providing care' where "JobID"=21;