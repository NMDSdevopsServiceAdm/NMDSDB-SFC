-- DDL for Workers

-- DROP/CLEAN SCHEMA
DROP TABLE IF EXISTS cqc."Worker";
DROP TYPE IF EXISTS cqc."WorkerContract";
DROP TYPE IF EXISTS cqc."WorkerApprovedMentalHealthWorker";

-- CREATE/RE-CREATE SCHEMA
CREATE TYPE cqc."WorkerContract" AS ENUM (
    'Permanent',
    'Temporary',
    'Pool/Bank',
	'Agency',
	'Other'
);

CREATE TYPE cqc."WorkerApprovedMentalHealthWorker" AS ENUM (
	'Yes',
	'No',
	'Don''t know'
);


CREATE TABLE IF NOT EXISTS cqc."Worker" (
	"ID" serial NOT NULL PRIMARY KEY,
	"WorkerUID" uuid NOT NULL,
	"EstablishmentFK" integer NOT NULL,
	"NameOrID" varchar(50) NOT NULL,
	"Contract" cqc."WorkerContract" NOT NULL,
	"MainJobFK" INTEGER NOT NULL,
	"ApprovedMentalHealthProfessional" cqc."WorkerApprovedMentalHealthWorker" NULL,
	"MainJobStartDate" DATE NULL,		-- Just date component, no time.
	created TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
	updated TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),	-- note, on creation of record, updated and created are equal
    CONSTRAINT "Worker_Establishment_fk" FOREIGN KEY ("EstablishmentFK") REFERENCES cqc."Establishment" ("EstablishmentID") MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "Worker_Job_mainjob_fk" FOREIGN KEY ("MainJobFK") REFERENCES cqc."Job" ("JobID") MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "Worker_NameID_unq" UNIQUE ("NameOrID", "EstablishmentFK"),
	CONSTRAINT "Worker_WorkerUID_unq" UNIQUE ("WorkerUID", "EstablishmentFK")
);

CREATE UNIQUE INDEX "Worker_WorkerUID" on cqc."Worker" ("WorkerUID");
CREATE INDEX "Worker_EstablishmentFK" on cqc."Worker" ("EstablishmentFK");
