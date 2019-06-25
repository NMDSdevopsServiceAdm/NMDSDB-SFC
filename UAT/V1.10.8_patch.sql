-- https://trello.com/c/PkupZnCs/51-10-staff-records-2-nurse-specialism-question
-- https://trello.com/c/ZfLqpOJV/50-10-staff-records-1-nurse-category-question

CREATE TYPE cqc."worker_registerednurse_enum" AS ENUM (
    'Adult nurse',
    'Mental health nurse',
    'Learning disabiliies',
    'Children''s nurse',
    'Enrolled nurse'
);

CREATE TABLE IF NOT EXISTS cqc."NurseSpecialism" (
	"ID" INTEGER NOT NULL PRIMARY KEY,
	"Seq" INTEGER NOT NULL, 	
	"Specialism" TEXT NOT NULL,
        "Other" BOOLEAN DEFAULT FALSE
);

ALTER TABLE cqc."Worker"   ADD COLUMN "RegisteredNurseValue" cqc."worker_registerednurse_enum" NULL;
ALTER TABLE cqc."Worker"   ADD COLUMN "RegisteredNurseSavedAt" TIMESTAMP NULL;
ALTER TABLE cqc."Worker"   ADD COLUMN "RegisteredNurseChangedAt" TIMESTAMP NULL;
ALTER TABLE cqc."Worker"   ADD COLUMN "RegisteredNurseSavedBy" VARCHAR(120) NULL;
ALTER TABLE cqc."Worker"   ADD COLUMN "RegisteredNurseChangedBy" VARCHAR(120) NULL;

ALTER TABLE cqc."Worker"   ADD COLUMN "NurseSpecialismFKValue" INTEGER NULL;
ALTER TABLE cqc."Worker"   ADD COLUMN "NurseSpecialismFKOther" TEXT NULL;
ALTER TABLE cqc."Worker"   ADD COLUMN "NurseSpecialismFKSavedAt" TIMESTAMP NULL;
ALTER TABLE cqc."Worker"   ADD COLUMN "NurseSpecialismFKChangedAt" TIMESTAMP NULL;
ALTER TABLE cqc."Worker"   ADD COLUMN "NurseSpecialismFKSavedBy" VARCHAR(120) NULL;
ALTER TABLE cqc."Worker"   ADD COLUMN "NurseSpecialismFKChangedBy" VARCHAR(120) NULL;