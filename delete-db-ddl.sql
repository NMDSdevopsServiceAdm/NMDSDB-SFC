-- other
DROP TABLE IF EXISTS cqc."Feedback";

-- workers
DROP TABLE IF EXISTS cqc."WorkerAudit";
DROP TABLE IF EXISTS cqc."WorkerJobs";
DROP TABLE IF EXISTS cqc."Worker";

-- establishments
DROP TABLE IF EXISTS cqc."EstablishmentServices";
DROP TABLE IF EXISTS cqc."EstablishmentLocalAuthority";
DROP TABLE IF EXISTS cqc."EstablishmentJobs";
DROP TABLE IF EXISTS cqc."EstablishmentCapacity";

-- registration
--DROP TABLE IF EXISTS cqc."CqcLog";
DROP TABLE IF EXISTS cqc."Login";
DROP TABLE IF EXISTS cqc."User";
DROP TABLE IF EXISTS cqc."Establishment";

-- lookup
DROP TABLE IF EXISTS cqc."Job";
DROP TABLE IF EXISTS cqc."LocalAuthority";
DROP TABLE IF EXISTS cqc."ServicesCapacity";
DROP TABLE IF EXISTS cqc.services;

-- large external reference - do not drop!
-- cqc.pcodedata;
-- cqc.location;

-- types
DROP TYPE IF EXISTS cqc.est_employertype_enum;
DROP TYPE IF EXISTS cqc.job_type;
DROP TYPE IF EXISTS cqc.job_declaration;
DROP TYPE IF EXISTS cqc."WorkerContract";

-- sequences
DROP SEQUENCE IF EXISTS cqc."EstablishmentCapacity_EstablishmentCapacityID_seq";
DROP SEQUENCE IF EXISTS cqc."EstablishmentJobs_EstablishmentJobID_seq";
DROP SEQUENCE IF EXISTS cqc."EstablishmentLocalAuthority_EstablishmentLocalAuthorityID_seq";
DROP SEQUENCE IF EXISTS cqc."Establishment_EstablishmentID_seq";
DROP SEQUENCE IF EXISTS cqc."Feedback_seq";
DROP SEQUENCE IF EXISTS cqc."Login_ID_seq";
DROP SEQUENCE IF EXISTS cqc."User_RegistrationID_seq";
DROP SEQUENCE IF EXISTS cqc.services_id_seq;
--DROP SEQUENCE IF EXISTS cqc.cqclog_id_seq;


---Removing unused schema's as clean up of DEV database
DROP SCHEMA cqctst cascade;
DROP SCHEMA cqctsttst cascade;



