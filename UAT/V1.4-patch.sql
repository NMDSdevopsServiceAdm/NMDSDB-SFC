-- this is an accummulative patch sql file that will be built up on each successive deployment in to sfctstdb
--  making it easier to apply patches to UAT DB after multiple deploys into sfctstdb

--- to apply DB patach for https://trello.com/c/BqSXEWI5
ALTER TABLE cqc."EstablishmentLocalAuthority" DROP CONSTRAINT localauthrity_establishmentlocalauthority_fk;
DROP TABLE cqc."LocalAuthority";

---CSSR TABLE CREATION 
CREATE TABLE cqc."Cssr"
(
    "CssrID" INTEGER NOT NULL,
    "CssR" TEXT COLLATE pg_catalog."default" NOT NULL,
	"LocalAuthority" TEXT NOT NULL,
    "LocalCustodianCode" integer NOT NULL,
    "Region" TEXT COLLATE pg_catalog."default" NOT NULL,
    "RegionID" INTEGER NOT NULL,
    "NmdsIDLetter" CHARACTER(1) COLLATE pg_catalog."default" NOT NULL,
	PRIMARY KEY ("CssrID", "LocalCustodianCode")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;
ALTER TABLE cqc."Cssr" OWNER TO sfcadmin;

CREATE SEQUENCE IF NOT EXISTS cqc."NmdsID_seq"
    AS integer
    START WITH 1001000
    INCREMENT BY 1
    MINVALUE 1001000
    MAXVALUE 9999999
    CACHE 1;

ALTER TABLE cqc."Establishment" ADD COLUMN "NmdsID" character(8);
ALTER TABLE cqc."EstablishmentLocalAuthority" ADD COLUMN "CssrID" INTEGER NULL;
ALTER TABLE cqc."EstablishmentLocalAuthority" ADD COLUMN "CssR" TEXT COLLATE pg_catalog."default" NULL;

-- The EstablishmentLocalAuthority.Cssr column is ideally NOT NULL, but if there are already records in
--   EstablishmentLocalAuthority table, then we need to do a bulk update against that and the Cssr table
--   to get the CssrID - use a "bulk update"
update cqc."EstablishmentLocalAuthority" set "CssrID" = "Cssr"."CssrID", "CssR" = "Cssr"."CssR"
    from cqc."Cssr" where "Cssr"."LocalCustodianCode" = "EstablishmentLocalAuthority"."LocalCustodianCode";

ALTER TABLE cqc."EstablishmentLocalAuthority" ALTER COLUMN "CssrID" SET NOT NULL;
ALTER TABLE cqc."EstablishmentLocalAuthority" ALTER COLUMN "CssR" SET NOT NULL;
ALTER TABLE cqc."EstablishmentLocalAuthority" DROP COLUMN "LocalCustodianCode";


-- and now update 
update cqc."Establishment"
set "NmdsID" = "CssrNmdsLetter"."NmdsIDLetter" || nextval('cqc."NmdsID_seq"')
from (
	select distinct pcodedata.postcode,
			pcodedata.local_custodian_code,
			"Cssr"."NmdsIDLetter",
			"Establishment"."EstablishmentID"
	from cqc."Establishment"
	 inner join cqc.pcodedata
			inner join cqc."Cssr" on pcodedata.local_custodian_code = "Cssr"."LocalCustodianCode"
		on pcodedata.postcode = "Establishment"."PostCode"
) as "CssrNmdsLetter"
where "CssrNmdsLetter"."EstablishmentID" = "Establishment"."EstablishmentID"
  and "Establishment"."NmdsID" is null;
ALTER TABLE cqc."Establishment" ALTER COLUMN "NmdsID" SET NOT NULL;


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
update cqc.services set "reportingID"=77	where id=22	;


-- DB Patch Schema for https://trello.com/c/pByUKSW3
DROP TABLE IF EXISTS  cqc."WorkerAudit";
DROP TYPE IF EXISTS cqc."WorkerAuditChangeType";
CREATE TYPE cqc."WorkerAuditChangeType" AS ENUM (
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
	"EventType" cqc."WorkerAuditChangeType" NOT NULL,
	"PropertyName" VARCHAR(100) NULL,
	"ChangeEvents" JSONB NULL,
	CONSTRAINT "WorkerAudit_Worker_fk" FOREIGN KEY ("WorkerFK") REFERENCES cqc."Worker" ("ID") MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);
CREATE INDEX "WorkerAudit_WorkerFK" on cqc."WorkerAudit" ("WorkerFK");

ALTER TABLE cqc."Login" ADD COLUMN "PasswdLastChanged" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW();

CREATE SEQUENCE IF NOT EXISTS cqc."PasswdResetTracking_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
    
CREATE TABLE IF NOT EXISTS cqc."PasswdResetTracking" (
    "ID" INTEGER NOT NULL PRIMARY KEY,
	"UserFK" INTEGER NOT NULL,
    "Created" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    "Expires" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW() + INTERVAL '24 hour',
    "ResetUuid"  UUID NOT NULL,
    "Completed" TIMESTAMP NULL,
	CONSTRAINT "PasswdResetTracking_User_fk" FOREIGN KEY ("UserFK") REFERENCES cqc."User" ("RegistrationID") MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);
ALTER TABLE cqc."PasswdResetTracking" ALTER COLUMN "ID" SET DEFAULT nextval('cqc."PasswdResetTracking_seq"');


ALTER TABLE cqc."User" ADD COLUMN "SecurityQuestion" character varying(255) NULL;
ALTER TABLE cqc."User" ADD COLUMN "SecurityQuestionAnswer" character varying(255) NULL;
-- migrate security question/answer from Login to User
UPDATE
	cqc."User"
SET
	"SecurityQuestion" = login."SecurityQuestion",
    "SecurityQuestionAnswer" = login."SecurityQuestionAnswer"	
FROM
	cqc."Login" as login
WHERE
	login."RegistrationID" = "User"."RegistrationID";
-- note - the security question/answer are not mandatory (later task to add users means they must be left null) so leave them nullable
-- and now drop the columns from Login
ALTER TABLE cqc."Login" DROP COLUMN "SecurityQuestion";
ALTER TABLE cqc."Login" DROP COLUMN "SecurityQuestionAnswer";

-- and now rename the User columns ready for Extended Change Properties
ALTER TABLE cqc."User" RENAME "FullName" TO "FullNameValue";
ALTER TABLE cqc."User" RENAME "JobTitle" TO "JobTitleValue";
ALTER TABLE cqc."User" RENAME "Email" TO "EmailValue";
ALTER TABLE cqc."User" RENAME "Phone" TO "PhoneValue";
ALTER TABLE cqc."User" RENAME "SecurityQuestion" TO "SecurityQuestionValue";
ALTER TABLE cqc."User" RENAME "SecurityQuestionAnswer" TO "SecurityQuestionAnswerValue";

-- and now add the additional the User columns ready for Extended Change Properties
ALTER TABLE cqc."User" ADD COLUMN "FullNameSavedAt" TIMESTAMP NULL;
ALTER TABLE cqc."User" ADD COLUMN "FullNameChangedAt" TIMESTAMP NULL;
ALTER TABLE cqc."User" ADD COLUMN "FullNameSavedBy" VARCHAR(120) NULL;
ALTER TABLE cqc."User" ADD COLUMN "FullNameChangedBy" VARCHAR(120) NULL;
ALTER TABLE cqc."User" ADD COLUMN "JobTitleSavedAt" TIMESTAMP NULL;
ALTER TABLE cqc."User" ADD COLUMN "JobTitleChangedAt" TIMESTAMP NULL;
ALTER TABLE cqc."User" ADD COLUMN "JobTitleSavedBy" VARCHAR(120) NULL;
ALTER TABLE cqc."User" ADD COLUMN "JobTitleChangedBy" VARCHAR(120) ==NULL;
ALTER TABLE cqc."User" ADD COLUMN "EmailSavedAt" TIMESTAMP NULL;
ALTER TABLE cqc."User" ADD COLUMN "EmailChangedAt" TIMESTAMP NULL;
ALTER TABLE cqc."User" ADD COLUMN "EmailSavedBy" VARCHAR(120) NULL;
ALTER TABLE cqc."User" ADD COLUMN "EmailChangedBy" VARCHAR(120) NULL;
ALTER TABLE cqc."User" ADD COLUMN "PhoneSavedAt" TIMESTAMP NULL;
ALTER TABLE cqc."User" ADD COLUMN "PhoneChangedAt" TIMESTAMP NULL;
ALTER TABLE cqc."User" ADD COLUMN "PhoneSavedBy" VARCHAR(120) NULL;
ALTER TABLE cqc."User" ADD COLUMN "PhoneChangedBy" VARCHAR(120) NULL;
ALTER TABLE cqc."User" ADD COLUMN "SecurityQuestionSavedAt" TIMESTAMP NULL;
ALTER TABLE cqc."User" ADD COLUMN "SecurityQuestionChangedAt" TIMESTAMP NULL;
ALTER TABLE cqc."User" ADD COLUMN "SecurityQuestionSavedBy" VARCHAR(120) NULL;
ALTER TABLE cqc."User" ADD COLUMN "SecurityQuestionChangedBy" VARCHAR(120) NULL;
ALTER TABLE cqc."User" ADD COLUMN "SecurityQuestionAnswerSavedAt" TIMESTAMP NULL;
ALTER TABLE cqc."User" ADD COLUMN "SecurityQuestionAnswerChangedAt" TIMESTAMP NULL;
ALTER TABLE cqc."User" ADD COLUMN "SecurityQuestionAnswerSavedBy" VARCHAR(120) NULL;
ALTER TABLE cqc."User" ADD COLUMN "SecurityQuestionAnswerChangedBy" VARCHAR(120) NULL;


-- add the created/updated/updatedBy columns
ALTER TABLE cqc."User" ADD COLUMN created TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW();
ALTER TABLE cqc."User" ADD COLUMN updated TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW();
ALTER TABLE cqc."User" ADD COLUMN updatedby VARCHAR(120) NULL;
UPDATE cqc."User" set updatedby='admin';                            -- cannot be null, so setting a default value on apply patch
ALTER TABLE cqc."User" ALTER COLUMN updatedby SET NOT NULL;

-- and drop the now unused "DateCreated" column
ALTER TABLE cqc."User" DROP COLUMN "DateCreated";

CREATE TYPE cqc."UserAuditChangeType" AS ENUM (
    'created',
    'updated',
    'saved',
    'changed',
    'passwdReset',
    'loginSuccess',
    'loginFailed',
    'loginWhileLocked'
);
CREATE TABLE IF NOT EXISTS cqc."UserAudit" (
	"ID" SERIAL NOT NULL PRIMARY KEY,
	"UserFK" INTEGER NOT NULL,
	"Username" VARCHAR(120) NOT NULL,
	"When" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
	"EventType" cqc."UserAuditChangeType" NOT NULL,
	"PropertyName" VARCHAR(100) NULL,
	"ChangeEvents" JSONB NULL,
	CONSTRAINT "WorkerAudit_User_fk" FOREIGN KEY ("UserFK") REFERENCES cqc."User" ("RegistrationID") MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);
CREATE INDEX "UserAudit_UserFK" on cqc."UserAudit" ("UserFK");

-- https://trello.com/c/1f4RSnlu defect fix
DROP INDEX IF EXISTS cqc."Establishment_unique_registration";
DROP INDEX IF EXISTS cqc."Establishment_unique_registration_with_locationid";
CREATE UNIQUE INDEX IF NOT EXISTS "Establishment_unique_registration" ON cqc."Establishment" ("Name", "PostCode", "LocationID");
CREATE UNIQUE INDEX IF NOT EXISTS "Establishment_unique_registration_with_locationid" ON cqc."Establishment" ("Name", "PostCode") WHERE "LocationID" IS NULL;

-- DB Patch Schema - https://trello.com/c/pByUKSW3 - add UUID to User
ALTER TABLE cqc."User" ADD COLUMN "UserUID" UUID NULL;

-- unfortunately, without the postgres extension "uuid-ossp", need an alternative method to
--  update existing User records with UUID
UPDATE
	cqc."User" 
SET
	"UserUID" = "USER_UUID"."UIDv4"
FROM (
	SELECT CAST(substr(CAST(myuuids."UID" AS TEXT), 0, 15) || '4' || substr(CAST(myuuids."UID" AS TEXT), 16, 3) || '-89' || substr(CAST(myuuids."UID" AS TEXT), 22, 36) AS UUID) "UIDv4", "RegID"
    FROM (
        SELECT uuid_in(md5(random()::text || clock_timestamp()::text)::cstring) "UID",
                "User"."RegistrationID" "RegID"
        FROM cqc."User", cqc."Login"
        WHERE "User"."RegistrationID" = "Login"."RegistrationID"
	) AS MyUUIDs
) AS "USER_UUID"
WHERE "USER_UUID"."RegID" = "User"."RegistrationID";

ALTER TABLE cqc."User" ALTER COLUMN "UserUID" SET NOT NULL;

-- DB Patch Schema - https://trello.com/c/MtKBV9EP
ALTER TYPE cqc.est_employertype_enum ADD VALUE 'Local Authority (generic/other)';
ALTER TYPE cqc.est_employertype_enum ADD VALUE 'Local Authority (adult services)';