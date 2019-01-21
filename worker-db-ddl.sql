-- DDL for Workers

-- DROP/CLEAN SCHEMA
DROP TABLE IF EXISTS cqc."WorkerAudit";
DROP TABLE IF EXISTS cqc."Worker";
DROP TYPE IF EXISTS cqc."WorkerContract";
DROP TYPE IF EXISTS cqc."WorkerApprovedMentalHealthWorker";
DROP TYPE IF EXISTS cqc."WorkerGender";
DROP TYPE IF EXISTS cqc."WorkerDisability";
DROP TYPE IF EXISTS cqc."AuditChangeType";

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

CREATE TYPE cqc."WorkerGender" AS ENUM (
	'Female',
	'Male',
	'Other',
	'Don''t know'
);

CREATE TYPE cqc."WorkerDisability" AS ENUM (
	'Yes',
	'No',
	'Undisclosed',
	'Don''t know'
);


CREATE TABLE IF NOT EXISTS cqc."Worker" (
	"ID" SERIAL NOT NULL PRIMARY KEY,
	"WorkerUID" UUID NOT NULL,
	"EstablishmentFK" INTEGER NOT NULL,
	"NameOrIdValue" VARCHAR(50) NOT NULL,
	"NameOrIdSavedAt" TIMESTAMP NULL,
	"NameOrIdChangedAt" TIMESTAMP NULL,
	"NameOrIdSavedBy" VARCHAR(120) NULL,
	"NameOrIdChangedBy" VARCHAR(120) NULL,
	"ContractValue" cqc."WorkerContract" NOT NULL,
	"ContractSavedAt" TIMESTAMP NULL,
	"ContractChangedAt" TIMESTAMP NULL,
	"ContractSavedBy" VARCHAR(120) NULL,
	"ContractChangedBy" VARCHAR(120) NULL,
	"MainJobFKValue" INTEGER NOT NULL,
	"MainJobFKSavedAt" TIMESTAMP NULL,
	"MainJobFKChangedAt" TIMESTAMP NULL,
	"MainJobFKSavedBy" VARCHAR(120) NULL,
	"MainJobFKChangedBy" VARCHAR(120) NULL,
	"ApprovedMentalHealthWorkerValue" cqc."WorkerApprovedMentalHealthWorker" NULL,
	"ApprovedMentalHealthWorkerSavedAt" TIMESTAMP NULL,
	"ApprovedMentalHealthWorkerChangedAt" TIMESTAMP NULL,
	"ApprovedMentalHealthWorkerSavedBy" VARCHAR(120) NULL,
	"ApprovedMentalHealthWorkerChangedBy" VARCHAR(120) NULL,
	"MainJobStartDateValue" DATE NULL,		-- Just date component, no time.
	"MainJobStartDateSavedAt" TIMESTAMP NULL,
	"MainJobStartDateChangedAt" TIMESTAMP NULL,
	"MainJobStartDateSavedBy" VARCHAR(120) NULL,
	"MainJobStartDateChangedBy" VARCHAR(120) NULL,
	"NationalInsuranceNumberValue" VARCHAR(13) NULL,
	"NationalInsuranceNumberSavedAt" TIMESTAMP NULL,
	"NationalInsuranceNumberChangedAt" TIMESTAMP NULL,
	"NationalInsuranceNumberSavedBy" VARCHAR(120) NULL,
	"NationalInsuranceNumberChangedBy" VARCHAR(120) NULL,
	"DateOfBirthValue" DATE NULL,
	"DateOfBirthSavedAt" TIMESTAMP NULL,
	"DateOfBirthChangedAt" TIMESTAMP NULL,
	"DateOfBirthSavedBy" VARCHAR(120) NULL,
	"DateOfBirthChangedBy" VARCHAR(120) NULL,
	"PostcodeValue" VARCHAR(8) NULL,
	"PostcodeSavedAt" TIMESTAMP NULL,
	"PostcodeChangedAt" TIMESTAMP NULL,
	"PostcodeSavedBy" VARCHAR(120) NULL,
	"PostcodeChangedBy" VARCHAR(120) NULL,
	"DisabilityValue" cqc."WorkerDisability" NULL,
	"DisabilitySavedAt" TIMESTAMP NULL,
	"DisabilityChangedAt" TIMESTAMP NULL,
	"DisabilitySavedBy" VARCHAR(120) NULL,
	"DisabilityChangedBy" VARCHAR(120) NULL,
	"GenderValue" cqc."WorkerGender" NULL,
	"GenderSavedAt" TIMESTAMP NULL,
	"GenderChangedAt" TIMESTAMP NULL,
	"GenderSavedBy" VARCHAR(120) NULL,
	"GenderChangedBy" VARCHAR(120) NULL,
	created TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
	updated TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),	-- note, on creation of record, updated and created are equal
	updatedby VARCHAR(120) NOT NULL,
    CONSTRAINT "Worker_Establishment_fk" FOREIGN KEY ("EstablishmentFK") REFERENCES cqc."Establishment" ("EstablishmentID") MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "Worker_Job_mainjob_fk" FOREIGN KEY ("MainJobFKValue") REFERENCES cqc."Job" ("JobID") MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "Worker_WorkerUID_unq" UNIQUE ("WorkerUID")
);

CREATE UNIQUE INDEX "Worker_WorkerUID" on cqc."Worker" ("WorkerUID");
CREATE INDEX "Worker_EstablishmentFK" on cqc."Worker" ("EstablishmentFK");

-- change auditting
CREATE TYPE cqc."AuditChangeType" AS ENUM (
	'created',
	'updated',
	'saved',
	'changed'
);
CREATE TABLE IF NOT EXISTS cqc."WorkerAudit" (
	"ID" SERIAL NOT NULL PRIMARY KEY,
	"WorkerFK" INTEGER NOT NULL,
	"Username" VARCHAR(120) NOT NULL,
	"When" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
	"EventType" cqc."AuditChangeType" NOT NULL,
	"PropertyName" VARCHAR(100) NULL,
	"ChangeEvents" JSONB NULL,
	CONSTRAINT "WorkerAudit_Worker_fk" FOREIGN KEY ("WorkerFK") REFERENCES cqc."Worker" ("ID") MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);
CREATE INDEX "WorkerAudit_WorkerFK" on cqc."WorkerAudit" ("WorkerFK");
