ALTER TABLE cqc."Establishment" ADD COLUMN "OverallWdfEligibility" timestamp without time zone NULL;
ALTER TABLE cqc."Establishment" ADD COLUMN "CurrentWdfEligibiity" BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE cqc."Establishment" ADD COLUMN "LastWdfEligibility" timestamp without time zone NULL;

ALTER TABLE cqc."Worker" ADD COLUMN "CurrentWdfEligibiity" BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE cqc."Worker" ADD COLUMN "LastWdfEligibility" timestamp without time zone NULL;

