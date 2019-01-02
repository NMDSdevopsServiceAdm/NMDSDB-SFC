--
-- PostgreSQL database dump
--

-- Dumped from database version 11.0
-- Dumped by pg_dump version 11.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: cqc; Type: SCHEMA; Schema: -; Owner: sfcadmin
--

CREATE SCHEMA IF NOT EXISTS cqc;


ALTER SCHEMA cqc OWNER TO sfcadmin;

--
-- Name: est_employertype_enum; Type: TYPE; Schema: cqc; Owner: postgres
--

CREATE TYPE cqc.est_employertype_enum AS ENUM (
    'Private Sector',
    'Voluntary / Charity',
    'Other'
);


ALTER TYPE cqc.est_employertype_enum OWNER TO sfcadmin;

--
-- Name: job_type; Type: TYPE; Schema: cqc; Owner: postgres
--

CREATE TYPE cqc.job_type AS ENUM (
    'Vacancies',
    'Starters',
    'Leavers'
);


ALTER TYPE cqc.job_type OWNER TO sfcadmin;

--SET default_tablespace = sfcdevtbs_logins;

SET default_with_oids = false;

--
-- Name: CqcLog; Type: TABLE; Schema: cqc; Owner: postgres; Tablespace: sfcdevtbs_logins
--

CREATE TABLE IF NOT EXISTS cqc."CqcLog" (
    id integer NOT NULL,
    success boolean,
    message character varying(255),
    createdat timestamp with time zone NOT NULL,
    "lastUpdatedAt" text
);


ALTER TABLE cqc."CqcLog" OWNER TO sfcadmin;

--
-- Name: Establishment; Type: TABLE; Schema: cqc; Owner: sfcadmin; Tablespace: sfcdevtbs_logins
--

CREATE TABLE IF NOT EXISTS cqc."Establishment" (
    "EstablishmentID" integer NOT NULL,
    "Name" text NOT NULL,
    "Address" text,
    "LocationID" text,
    "PostCode" text,
    "IsRegulated" boolean NOT NULL,
    "MainServiceId" integer,
    "EmployerType" cqc.est_employertype_enum,
    "ShareDataWithCQC" boolean DEFAULT false,
    "ShareDataWithLA" boolean DEFAULT false,
    "ShareData" boolean DEFAULT false,
    "NumberOfStaff" integer
);


ALTER TABLE cqc."Establishment" OWNER TO sfcadmin;
ALTER TABLE ONLY cqc."Establishment"
    ADD CONSTRAINT unqestbid UNIQUE ("EstablishmentID");


--SET default_tablespace = '';

--
-- Name: EstablishmentCapacity; Type: TABLE; Schema: cqc; Owner: postgres
--

CREATE TABLE IF NOT EXISTS cqc."EstablishmentCapacity" (
    "EstablishmentCapacityID" integer NOT NULL,
    "EstablishmentID" integer,
    "ServiceCapacityID" integer NOT NULL,
    "Answer" integer
);


ALTER TABLE cqc."EstablishmentCapacity" OWNER TO sfcadmin;

--
-- Name: EstablishmentCapacity_EstablishmentCapacityID_seq; Type: SEQUENCE; Schema: cqc; Owner: postgres
--

CREATE SEQUENCE IF NOT EXISTS cqc."EstablishmentCapacity_EstablishmentCapacityID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cqc."EstablishmentCapacity_EstablishmentCapacityID_seq" OWNER TO sfcadmin;

--
-- Name: EstablishmentCapacity_EstablishmentCapacityID_seq; Type: SEQUENCE OWNED BY; Schema: cqc; Owner: postgres
--

ALTER SEQUENCE IF EXISTS cqc."EstablishmentCapacity_EstablishmentCapacityID_seq" OWNED BY cqc."EstablishmentCapacity"."EstablishmentCapacityID";


--
-- Name: EstablishmentJobs; Type: TABLE; Schema: cqc; Owner: sfcadmin
--

CREATE TABLE IF NOT EXISTS cqc."EstablishmentJobs" (
    "JobID" integer NOT NULL,
    "EstablishmentID" integer NOT NULL,
    "EstablishmentJobID" integer NOT NULL,
    "JobType" cqc.job_type NOT NULL,
	"Total" INTEGER NOT NULL
);


ALTER TABLE cqc."EstablishmentJobs" OWNER TO sfcadmin;

--
-- Name: EstablishmentJobs_EstablishmentJobID_seq; Type: SEQUENCE; Schema: cqc; Owner: sfcadmin
--

CREATE SEQUENCE IF NOT EXISTS cqc."EstablishmentJobs_EstablishmentJobID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cqc."EstablishmentJobs_EstablishmentJobID_seq" OWNER TO sfcadmin;

--
-- Name: EstablishmentJobs_EstablishmentJobID_seq; Type: SEQUENCE OWNED BY; Schema: cqc; Owner: sfcadmin
--

ALTER SEQUENCE IF EXISTS cqc."EstablishmentJobs_EstablishmentJobID_seq" OWNED BY cqc."EstablishmentJobs"."EstablishmentJobID";

--
-- Name: LocalAuthority; Type: TABLE; Schema: cqc; Owner: sfcadmin
--

CREATE TABLE IF NOT EXISTS cqc."LocalAuthority" (
    "LocalCustodianCode" integer NOT NULL,
    "LocalAuthorityName" text
);


ALTER TABLE cqc."LocalAuthority" OWNER TO sfcadmin;

--
-- Name: LocalAuthority localcustodiancode_pk; Type: CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."LocalAuthority"
    ADD CONSTRAINT localcustodiancode_pk PRIMARY KEY ("LocalCustodianCode");


--
-- Name: LocalAuthority localcustodiancode_unq; Type: CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."LocalAuthority"
    ADD CONSTRAINT localcustodiancode_unq UNIQUE ("LocalCustodianCode");


--
-- Name: EstablishmentLocalAuthority_EstablishmentLocalAuthorityID_seq; Type: SEQUENCE; Schema: cqc; Owner: postgres
--

CREATE SEQUENCE IF NOT EXISTS cqc."EstablishmentLocalAuthority_EstablishmentLocalAuthorityID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: EstablishmentLocalAuthority; Type: TABLE; Schema: cqc; Owner: postgres
--

CREATE TABLE IF NOT EXISTS cqc."EstablishmentLocalAuthority" (
    "EstablishmentLocalAuthorityID" integer NOT NULL DEFAULT nextval('cqc."EstablishmentLocalAuthority_EstablishmentLocalAuthorityID_seq"'::regclass),
    "EstablishmentID" integer NOT NULL,
    "LocalCustodianCode" integer,
	CONSTRAINT establishmentlocalauthority_pk PRIMARY KEY ("EstablishmentLocalAuthorityID"),
    CONSTRAINT "EstablishmentLocalAuthorityID_Unq" UNIQUE ("EstablishmentLocalAuthorityID"),
    CONSTRAINT establishment_establishmentlocalauthority_fk FOREIGN KEY ("EstablishmentID")
        REFERENCES cqc."Establishment" ("EstablishmentID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT localauthrity_establishmentlocalauthority_fk FOREIGN KEY ("LocalCustodianCode")
        REFERENCES cqc."LocalAuthority" ("LocalCustodianCode") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);


ALTER TABLE cqc."EstablishmentLocalAuthority" OWNER TO sfcadmin;

ALTER TABLE cqc."EstablishmentLocalAuthority_EstablishmentLocalAuthorityID_seq" OWNER TO sfcadmin;
ALTER SEQUENCE IF EXISTS cqc."EstablishmentLocalAuthority_EstablishmentLocalAuthorityID_seq" OWNED BY cqc."EstablishmentLocalAuthority"."EstablishmentLocalAuthorityID";



--
-- Name: EstablishmentServices; Type: TABLE; Schema: cqc; Owner: sfcadmin
--

CREATE TABLE IF NOT EXISTS cqc."EstablishmentServices" (
    "EstablishmentID" integer NOT NULL,
    "ServiceID" integer NOT NULL
);


ALTER TABLE cqc."EstablishmentServices" OWNER TO sfcadmin;

--
-- Name: Establishment_EstablishmentID_seq; Type: SEQUENCE; Schema: cqc; Owner: sfcadmin
--

CREATE SEQUENCE IF NOT EXISTS cqc."Establishment_EstablishmentID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cqc."Establishment_EstablishmentID_seq" OWNER TO sfcadmin;

--
-- Name: Establishment_EstablishmentID_seq; Type: SEQUENCE OWNED BY; Schema: cqc; Owner: sfcadmin
--

ALTER SEQUENCE IF EXISTS cqc."Establishment_EstablishmentID_seq" OWNED BY cqc."Establishment"."EstablishmentID";


--
-- Name: Job; Type: TABLE; Schema: cqc; Owner: sfcadmin
--

CREATE TABLE IF NOT EXISTS cqc."Job" (
    "JobID" integer NOT NULL,
    "JobName" text
);


ALTER TABLE cqc."Job" OWNER TO sfcadmin;


--SET default_tablespace = sfcdevtbs_logins;

--
-- Name: Login; Type: TABLE; Schema: cqc; Owner: sfcadmin; Tablespace: sfcdevtbs_logins
--

CREATE TABLE IF NOT EXISTS cqc."Login" (
    "ID" integer NOT NULL,
    "RegistrationID" integer NOT NULL,
    "Username" character varying(120) NOT NULL,
    "Password" character varying(120) NOT NULL,
    "SecurityQuestion" character varying(255) NOT NULL,
    "SecurityQuestionAnswer" character varying(255) NOT NULL,
    "Active" boolean NOT NULL,
    "InvalidAttempt" integer NOT NULL,
    "Salt" character varying(255),
    "Hash" character varying(255),
    "FirstLogin" timestamp(4) without time zone
);


ALTER TABLE cqc."Login" OWNER TO sfcadmin;

--
-- Name: Login_ID_seq; Type: SEQUENCE; Schema: cqc; Owner: sfcadmin
--

CREATE SEQUENCE IF NOT EXISTS cqc."Login_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cqc."Login_ID_seq" OWNER TO sfcadmin;

--
-- Name: Login_ID_seq; Type: SEQUENCE OWNED BY; Schema: cqc; Owner: sfcadmin
--

ALTER SEQUENCE IF EXISTS cqc."Login_ID_seq" OWNED BY cqc."Login"."ID";


SET default_tablespace = '';

--
-- Name: ServicesCapacity; Type: TABLE; Schema: cqc; Owner: sfcadmin
--

CREATE TABLE IF NOT EXISTS cqc."ServicesCapacity" (
    "ServiceCapacityID" integer NOT NULL,
    "ServiceID" integer,
    "Question" text,
    "Sequence" integer
);


ALTER TABLE cqc."ServicesCapacity" OWNER TO sfcadmin;

--SET default_tablespace = sfcdevtbs_logins;

--
-- Name: User; Type: TABLE; Schema: cqc; Owner: sfcadmin; Tablespace: sfcdevtbs_logins
--

CREATE TABLE IF NOT EXISTS cqc."User" (
    "RegistrationID" integer NOT NULL,
    "FullName" character varying(120) NOT NULL,
    "JobTitle" character varying(255) NOT NULL,
    "Email" character varying(255) NOT NULL,
    "Phone" character varying(50) NOT NULL,
    "DateCreated" timestamp without time zone NOT NULL,
    "EstablishmentID" integer NOT NULL,
    "AdminUser" boolean NOT NULL
);


ALTER TABLE cqc."User" OWNER TO sfcadmin;

--
-- Name: User_RegistrationID_seq; Type: SEQUENCE; Schema: cqc; Owner: sfcadmin
--

CREATE SEQUENCE IF NOT EXISTS cqc."User_RegistrationID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cqc."User_RegistrationID_seq" OWNER TO sfcadmin;

--
-- Name: User_RegistrationID_seq; Type: SEQUENCE OWNED BY; Schema: cqc; Owner: sfcadmin
--

ALTER SEQUENCE IF EXISTS cqc."User_RegistrationID_seq" OWNED BY cqc."User"."RegistrationID";


--
-- Name: cqclog_id_seq; Type: SEQUENCE; Schema: cqc; Owner: postgres
--

CREATE SEQUENCE cqc.cqclog_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cqc.cqclog_id_seq OWNER TO sfcadmin;

--
-- Name: cqclog_id_seq; Type: SEQUENCE OWNED BY; Schema: cqc; Owner: postgres
--

ALTER SEQUENCE cqc.cqclog_id_seq OWNED BY cqc."CqcLog".id;


--
-- Name: location_cqcid_seq; Type: SEQUENCE; Schema: cqc; Owner: sfcadmin
--

CREATE SEQUENCE IF NOT EXISTS cqc.location_cqcid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cqc.location_cqcid_seq OWNER TO sfcadmin;

--
-- Name: location; Type: TABLE; Schema: cqc; Owner: sfcadmin; Tablespace: sfcdevtbs_logins
--

CREATE TABLE IF NOT EXISTS cqc.location (
    cqcid integer DEFAULT nextval('cqc.location_cqcid_seq'::regclass) NOT NULL,
    locationid text,
    locationname text,
    addressline1 text,
    addressline2 text,
    towncity text,
    county text,
    postalcode text,
    mainservice text,
    createdat timestamp without time zone NOT NULL,
    updatedat timestamp without time zone,
	CONSTRAINT location_pkey PRIMARY KEY (cqcid),
	CONSTRAINT uniqlocationid UNIQUE (locationid)
);


ALTER TABLE cqc.location OWNER TO sfcadmin;

--
-- Name: pcodedata; Type: TABLE; Schema: cqc; Owner: sfcadmin; Tablespace: sfcdevtbs_logins
--

CREATE TABLE IF NOT EXISTS cqc.pcodedata (
    uprn bigint,
    sub_building_name character varying,
    building_name character varying,
    building_number character varying,
    street_description character varying,
    post_town character varying,
    postcode character varying,
    local_custodian_code bigint,
    county character varying,
    rm_organisation_name character varying
);


ALTER TABLE cqc.pcodedata OWNER TO sfcadmin;

--
-- Name: services; Type: TABLE; Schema: cqc; Owner: sfcadmin; Tablespace: sfcdevtbs_logins
--

CREATE TABLE IF NOT EXISTS cqc.services (
    id integer NOT NULL,
    name text,
    category text,
    iscqcregistered boolean,
    ismain boolean DEFAULT true
);


ALTER TABLE cqc.services OWNER TO sfcadmin;

--
-- Name: services_id_seq; Type: SEQUENCE; Schema: cqc; Owner: sfcadmin
--

CREATE SEQUENCE IF NOT EXISTS cqc.services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cqc.services_id_seq OWNER TO sfcadmin;

--
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: cqc; Owner: sfcadmin
--

ALTER SEQUENCE IF EXISTS cqc.services_id_seq OWNED BY cqc.services.id;


--
-- Name: CqcLog id; Type: DEFAULT; Schema: cqc; Owner: postgres
--

ALTER TABLE ONLY cqc."CqcLog" ALTER COLUMN id SET DEFAULT nextval('cqc.cqclog_id_seq'::regclass);


--
-- Name: Establishment EstablishmentID; Type: DEFAULT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."Establishment" ALTER COLUMN "EstablishmentID" SET DEFAULT nextval('cqc."Establishment_EstablishmentID_seq"'::regclass);


--
-- Name: EstablishmentCapacity EstablishmentCapacityID; Type: DEFAULT; Schema: cqc; Owner: postgres
--

ALTER TABLE ONLY cqc."EstablishmentCapacity" ALTER COLUMN "EstablishmentCapacityID" SET DEFAULT nextval('cqc."EstablishmentCapacity_EstablishmentCapacityID_seq"'::regclass);


--
-- Name: EstablishmentJobs EstablishmentJobID; Type: DEFAULT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."EstablishmentJobs" ALTER COLUMN "EstablishmentJobID" SET DEFAULT nextval('cqc."EstablishmentJobs_EstablishmentJobID_seq"'::regclass);



--
-- Name: Login ID; Type: DEFAULT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."Login" ALTER COLUMN "ID" SET DEFAULT nextval('cqc."Login_ID_seq"'::regclass);


--
-- Name: User RegistrationID; Type: DEFAULT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."User" ALTER COLUMN "RegistrationID" SET DEFAULT nextval('cqc."User_RegistrationID_seq"'::regclass);


--
-- Name: services id; Type: DEFAULT; Schema: cqc; Owner: sfcadmin
--
-- services is a lookup table; primary key must be fixed and known not auto increment
--ALTER TABLE ONLY cqc.services ALTER COLUMN id SET DEFAULT nextval('cqc.services_id_seq'::regclass);


SET default_tablespace = '';

--
-- Name: CqcLog CQCLog_pkey; Type: CONSTRAINT; Schema: cqc; Owner: postgres
--

ALTER TABLE ONLY cqc."CqcLog"
    ADD CONSTRAINT "CQCLog_pkey" PRIMARY KEY (id);


--
-- Name: EstablishmentCapacity EstablishmentCapacity_pkey1; Type: CONSTRAINT; Schema: cqc; Owner: postgres
--

ALTER TABLE ONLY cqc."EstablishmentCapacity"
    ADD CONSTRAINT "EstablishmentCapacity_pkey1" PRIMARY KEY ("EstablishmentCapacityID");


--
-- Name: EstablishmentJobs EstablishmentJobs_pkey; Type: CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."EstablishmentJobs"
    ADD CONSTRAINT "EstablishmentJobs_pkey" PRIMARY KEY ("EstablishmentJobID");


--
-- Name: EstablishmentCapacity EstablishmentServiceCapacity_unq1; Type: CONSTRAINT; Schema: cqc; Owner: postgres
--

ALTER TABLE ONLY cqc."EstablishmentCapacity"
    ADD CONSTRAINT "EstablishmentServiceCapacity_unq1" UNIQUE ("EstablishmentID", "ServiceCapacityID");


--
-- Name: Establishment Establishment_pkey; Type: CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."Establishment"
    ADD CONSTRAINT "Establishment_pkey" PRIMARY KEY ("EstablishmentID");


--
-- Name: Job Job_pkey; Type: CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."Job"
    ADD CONSTRAINT "Job_pkey" PRIMARY KEY ("JobID");


--
-- Name: EstablishmentServices OtherServices_pkey; Type: CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."EstablishmentServices"
    ADD CONSTRAINT "OtherServices_pkey" PRIMARY KEY ("EstablishmentID", "ServiceID");


--
-- Name: ServicesCapacity ServicesCapacity_pkey; Type: CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."ServicesCapacity"
    ADD CONSTRAINT "ServicesCapacity_pkey" PRIMARY KEY ("ServiceCapacityID");



--
-- Name: Login pk_Login; Type: CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."Login"
    ADD CONSTRAINT "pk_Login" PRIMARY KEY ("ID");


--
-- Name: User pk_User; Type: CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."User"
    ADD CONSTRAINT "pk_User" PRIMARY KEY ("RegistrationID");


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: Login uc_Login_Username; Type: CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."Login"
    ADD CONSTRAINT "uc_Login_Username" UNIQUE ("Username");



--
-- Name: services unq_serviceid; Type: CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc.services
    ADD CONSTRAINT unq_serviceid UNIQUE (id);


--
-- Name: ServicesCapacity unq_servicescapacityid; Type: CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."ServicesCapacity"
    ADD CONSTRAINT unq_servicescapacityid UNIQUE ("ServiceCapacityID");


--
-- Name: User unq_userregistrationid; Type: CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."User"
    ADD CONSTRAINT unq_userregistrationid UNIQUE ("RegistrationID");




--
-- Name: ServicesCapacity unqsrvcid; Type: CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."ServicesCapacity"
    ADD CONSTRAINT unqsrvcid UNIQUE ("ServiceID", "Sequence");


--SET default_tablespace = sfcdevtbs_index;

--
-- Name: Postcodedata_postcode_Idx; Type: INDEX; Schema: cqc; Owner: sfcadmin; Tablespace: sfcdevtbs_index
--

CREATE INDEX IF NOT EXISTS "Postcodedata_postcode_Idx" ON cqc.pcodedata USING btree (postcode text_pattern_ops);


--
-- Name: EstablishmentCapacity EstablishmentServiceCapacity_Establishment_fk1; Type: FK CONSTRAINT; Schema: cqc; Owner: postgres
--

ALTER TABLE ONLY cqc."EstablishmentCapacity"
    ADD CONSTRAINT "EstablishmentServiceCapacity_Establishment_fk1" FOREIGN KEY ("EstablishmentID") REFERENCES cqc."Establishment"("EstablishmentID");


--
-- Name: EstablishmentCapacity EstablishmentServiceCapacity_ServiceCapacity_fk1; Type: FK CONSTRAINT; Schema: cqc; Owner: postgres
--

ALTER TABLE ONLY cqc."EstablishmentCapacity"
    ADD CONSTRAINT "EstablishmentServiceCapacity_ServiceCapacity_fk1" FOREIGN KEY ("ServiceCapacityID") REFERENCES cqc."ServicesCapacity"("ServiceCapacityID");


--
-- Name: ServicesCapacity constr_srvcid_fk; Type: FK CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."ServicesCapacity"
    ADD CONSTRAINT constr_srvcid_fk FOREIGN KEY ("ServiceID") REFERENCES cqc.services(id);


--
-- Name: Login constraint_fk; Type: FK CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."Login"
    ADD CONSTRAINT constraint_fk FOREIGN KEY ("RegistrationID") REFERENCES cqc."User"("RegistrationID");


--
-- Name: EstablishmentJobs establishment_establishmentjobs_fk; Type: FK CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."EstablishmentJobs"
    ADD CONSTRAINT establishment_establishmentjobs_fk FOREIGN KEY ("EstablishmentID") REFERENCES cqc."Establishment"("EstablishmentID");


--
-- Name: Establishment estloc_fk; Type: FK CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."Establishment"
    ADD CONSTRAINT estloc_fk FOREIGN KEY ("LocationID") REFERENCES cqc.location(locationid);


--
-- Name: EstablishmentServices estsrvc_estb_fk; Type: FK CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."EstablishmentServices"
    ADD CONSTRAINT estsrvc_estb_fk FOREIGN KEY ("EstablishmentID") REFERENCES cqc."Establishment"("EstablishmentID");


--
-- Name: EstablishmentServices estsrvc_services_fk; Type: FK CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."EstablishmentServices"
    ADD CONSTRAINT estsrvc_services_fk FOREIGN KEY ("ServiceID") REFERENCES cqc.services(id);


--
-- Name: EstablishmentJobs jobs_establishmentjobs_fk; Type: FK CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."EstablishmentJobs"
    ADD CONSTRAINT jobs_establishmentjobs_fk FOREIGN KEY ("JobID") REFERENCES cqc."Job"("JobID");



--
-- Name: Establishment mainserviceid_fk; Type: FK CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."Establishment"
    ADD CONSTRAINT mainserviceid_fk FOREIGN KEY ("MainServiceId") REFERENCES cqc.services(id) MATCH FULL;


--
-- Name: User user_establishment_fk; Type: FK CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."User"
    ADD CONSTRAINT user_establishment_fk FOREIGN KEY ("EstablishmentID") REFERENCES cqc."Establishment"("EstablishmentID");


--
-- Name: TABLE "CqcLog"; Type: ACL; Schema: cqc; Owner: postgres
--

GRANT ALL ON TABLE cqc."CqcLog" TO sfcadmin;


--
-- Name: SEQUENCE cqclog_id_seq; Type: ACL; Schema: cqc; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE cqc.cqclog_id_seq TO sfcadmin;


--
-- Name: Feedback
--
DROP SEQUENCE IF EXISTS cqc."Feedback_seq";
CREATE SEQUENCE cqc."Feedback_seq";
ALTER SEQUENCE cqc."Feedback_seq"
    OWNER TO sfcadmin;

    -- now table
DROP TABLE IF EXISTS cqc."Feedback";
CREATE TABLE cqc."Feedback"
(
    "FeedbackID" integer NOT NULL DEFAULT nextval('cqc."Feedback_seq"'::regclass),
    "Doing" Text NOT NULL,
    "Tellus" Text NOT NULL,
    "Name" Text,
    "Email" Text,
    created timestamp NOT NULL DEFAULT NOW(),
    CONSTRAINT feedback_pk PRIMARY KEY ("FeedbackID"),
    CONSTRAINT feedback_unq UNIQUE ("FeedbackID")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE cqc."Feedback"
    OWNER to sfcadmin;


--
-- PostgreSQL database dump complete
--

insert into cqc.services (id, name, category, iscqcregistered, ismain) values (1, 'Carers support', 'Adult community care', 'f', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (2, 'Community support and outreach', 'Adult community care', 'f', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (3, 'Disability adaptations / assistive technology services', 'Adult community care', 'f', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (4, 'Information and advice services', 'Adult community care', 'f', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (5, 'Occupational / employment-related services', 'Adult community care', 'f', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (6, 'Other adult community care service', 'Adult community care', 'f', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (7, 'Short breaks / respite care', 'Adult community care', 'f', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (8, 'Social work and care management', 'Adult community care', 'f', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (9, 'Day care and day services', 'Adult day', 'f', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (10, 'Other adult day care services', 'Adult day', 'f', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (11, 'Domestic services and home help', 'Adult domiciliary', 'f', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (12, 'Other adult residential care services', 'Adult residential', 'f', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (13, 'Sheltered housing', 'Adult residential', 'f', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (14, 'Any childrens / young peoples services', 'Other', 'f', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (15, 'Any other services', 'Other', 'f', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (16, 'Head office services', 'Other', 'f', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (17, 'Other healthcare service', 'Other', 'f', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (18, 'Other adult domiciliary care service', 'Adult domiciliary', 'f', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (19, 'Shared lives', 'Adult community care', 't', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (20, 'Domiciliary care services', 'Adult domiciliary', 't', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (21, 'Extra care housing services', 'Adult domiciliary', 't', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (22, 'Nurses agency', 'Adult domiciliary', 't', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (23, 'Supported living services', 'Adult domiciliary', 't', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (26, 'Community based services for people who misuse substances', 'Healthcare', 't', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (27, 'Community based services for people with a learning disability', 'Healthcare', 't', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (28, 'Community based services for people with mental health needs', 'Healthcare', 't', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (29, 'Community healthcare services', 'Healthcare', 't', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (30, 'Hospice services', 'Healthcare', 't', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (31, 'Hospital services for people with mental health needs, learning disabilities and/or problems with substance misuse', 'Healthcare', 't', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (32, 'Long term conditions services', 'Healthcare', 't', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (33, 'Rehabilitation services', 'Healthcare', 't', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (34, 'Residential substance misuse treatment/ rehabilitation services', 'Healthcare', 't', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (36, 'Specialist college services', 'Other', 't', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (24, 'Care home services with nursing', 'Adult residential', 't', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (25, 'Care home services without nursing', 'Adult residential', 't', 't');
insert into cqc.services (id, name, category, iscqcregistered, ismain) values (35, 'Live-in care', 'Other', 't', 'f');



----Insert From Warren
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (1, 7, 1, 'Number of people receiving care on the completion date');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (2, 9, 1, 'How many beds do you currently have?');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (3, 9, 2, 'How many of those beds are currently used?');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (4, 10, 1, 'How many places do you currently have?');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (5, 10, 2, 'Number of people using the service on the completion date');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (6, 11, 1, 'Number of people receiving care on the completion date');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (7, 12, 1, 'Number of people receiving care on the completion date');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (8, 20, 1, 'How many places do you currently have?');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (9, 20, 2, 'Number of people using the service on the completion date');

INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (10, 21, 1, 'Number of people using the service on the completion date');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (11, 22, 1, 'Number of people receiving care on the completion date');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (12, 24, 1, 'How many beds do you currently have?');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (13, 24, 2, 'How many of those beds are currently used?');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (14, 25, 1, 'How many beds do you currently have?');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (15, 25, 2, 'How many of those beds are currently used?');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (16, 35, 1, 'Number of people receiving care on the completion date');
---------------------

insert into cqc."Job" ("JobID", "JobName") values (1, 'Senior Care Worker');
insert into cqc."Job" ("JobID", "JobName") values (2, 'Care Worker');
insert into cqc."Job" ("JobID", "JobName") values (3, 'Community Support and Outreach Work');
insert into cqc."Job" ("JobID", "JobName") values (4, 'Advice Guidance and Advocacy');
insert into cqc."Job" ("JobID", "JobName") values (5, 'Other care-providing job role');
insert into cqc."Job" ("JobID", "JobName") values (6, 'Senior Management');
insert into cqc."Job" ("JobID", "JobName") values (7, 'Middle Management');
insert into cqc."Job" ("JobID", "JobName") values (8, 'First Line Manager');
insert into cqc."Job" ("JobID", "JobName") values (9, 'Registered Manager');
insert into cqc."Job" ("JobID", "JobName") values (10, 'Supervisor');
insert into cqc."Job" ("JobID", "JobName") values (11, 'Managers and staff in care-related but not care-providing roles');
insert into cqc."Job" ("JobID", "JobName") values (12, 'Social Worker');
insert into cqc."Job" ("JobID", "JobName") values (13, 'Occupational Therapist');
insert into cqc."Job" ("JobID", "JobName") values (14, 'Registered Nurse');
insert into cqc."Job" ("JobID", "JobName") values (15, 'Allied Health Professional');
insert into cqc."Job" ("JobID", "JobName") values (16, 'Safeguarding and reviewing officer');
insert into cqc."Job" ("JobID", "JobName") values (17, 'Administrative or office staff not care-providing');
insert into cqc."Job" ("JobID", "JobName") values (18, 'Ancillary staff not care-providing');
insert into cqc."Job" ("JobID", "JobName") values (19, 'Activities worker or co-ordinator');
insert into cqc."Job" ("JobID", "JobName") values (20, 'Occupational therapist assistant');
insert into cqc."Job" ("JobID", "JobName") values (21, 'Other non-care-providing job roles');



insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(116, 'BRISTOL');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(119, 'SOUTH GLOUCESTERSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(121, 'NORTH SOMERSET');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(230, 'LUTON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(235, 'BEDFORD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(240, 'CENTRAL BEDFORDSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(335, 'BRACKNELL FOREST');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(340, 'WEST BERKSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(345, 'READING');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(350, 'SLOUGH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(355, 'WINDSOR AND MAIDENHEAD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(360, 'WOKINGHAM');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(405, 'AYLESBURY VALE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(410, 'SOUTH BUCKS');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(415, 'CHILTERN');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(425, 'WYCOMBE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(435, 'MILTON KEYNES');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(505, 'CAMBRIDGE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(510, 'EAST CAMBRIDGESHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(515, 'FENLAND');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(520, 'HUNTINGDONSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(530, 'SOUTH CAMBRIDGESHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(540, 'PETERBOROUGH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(650, 'HALTON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(655, 'WARRINGTON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(660, 'CHESHIRE EAST');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(665, 'CHESHIRE WEST AND CHESTER');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(724, 'HARTLEPOOL');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(728, 'REDCAR AND CLEVELAND');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(734, 'MIDDLESBROUGH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(738, 'STOCKTON-ON-TEES');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(835, 'ISLES OF SCILLY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(840, 'CORNWALL');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(905, 'ALLERDALE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(910, 'BARROW-IN-FURNESS');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(915, 'CARLISLE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(920, 'COPELAND');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(925, 'EDEN');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(930, 'SOUTH LAKELAND');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1005, 'AMBER VALLEY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1010, 'BOLSOVER');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1015, 'CHESTERFIELD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1025, 'EREWASH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1030, 'HIGH PEAK');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1035, 'NORTH EAST DERBYSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1040, 'SOUTH DERBYSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1045, 'DERBYSHIRE DALES');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1055, 'DERBY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1105, 'EAST DEVON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1110, 'EXETER');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1115, 'NORTH DEVON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1125, 'SOUTH HAMS');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1130, 'TEIGNBRIDGE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1135, 'MID DEVON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1145, 'TORRIDGE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1150, 'WEST DEVON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1160, 'PLYMOUTH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1165, 'TORBAY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1210, 'CHRISTCHURCH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1215, 'NORTH DORSET');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1225, 'PURBECK');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1230, 'WEST DORSET');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1235, 'WEYMOUTH AND PORTLAND');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1240, 'EAST DORSET');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1250, 'BOURNEMOUTH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1255, 'POOLE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1350, 'DARLINGTON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1355, 'DURHAM');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1410, 'EASTBOURNE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1415, 'HASTINGS');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1425, 'LEWES');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1430, 'ROTHER');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1435, 'WEALDEN');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1445, 'BRIGHTON & HOVE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1505, 'BASILDON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1510, 'BRAINTREE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1515, 'BRENTWOOD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1520, 'CASTLE POINT');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1525, 'CHELMSFORD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1530, 'COLCHESTER');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1535, 'EPPING FOREST');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1540, 'HARLOW');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1545, 'MALDON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1550, 'ROCHFORD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1560, 'TENDRING');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1570, 'UTTLESFORD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1590, 'SOUTHEND-ON-SEA');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1595, 'THURROCK');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1605, 'CHELTENHAM');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1610, 'COTSWOLD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1615, 'FOREST OF DEAN');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1620, 'GLOUCESTER');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1625, 'STROUD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1630, 'TEWKESBURY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1705, 'BASINGSTOKE AND DEANE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1710, 'EAST HAMPSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1715, 'EASTLEIGH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1720, 'FAREHAM');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1725, 'GOSPORT');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1730, 'HART');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1735, 'HAVANT');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1740, 'NEW FOREST');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1750, 'RUSHMOOR');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1760, 'TEST VALLEY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1765, 'WINCHESTER');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1775, 'PORTSMOUTH CITY COUNCIL');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1780, 'SOUTHAMPTON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1805, 'BROMSGROVE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1820, 'MALVERN HILLS');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1825, 'REDDITCH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1835, 'WORCESTER');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1840, 'WYCHAVON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1845, 'WYRE FOREST');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1850, 'HEREFORDSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1905, 'BROXBOURNE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1910, 'DACORUM');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1915, 'EAST HERTFORDSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1920, 'HERTSMERE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1925, 'NORTH HERTFORDSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1930, 'ST ALBANS');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1935, 'STEVENAGE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1940, 'THREE RIVERS');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1945, 'WATFORD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1950, 'WELWYN HATFIELD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2001, 'EAST RIDING OF YORKSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2002, 'NORTH EAST LINCOLNSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2003, 'NORTH LINCOLNSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2004, 'KINGSTON UPON HULL');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2114, 'ISLE OF WIGHT');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2205, 'ASHFORD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2210, 'CANTERBURY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2215, 'DARTFORD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2220, 'DOVER');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2230, 'GRAVESHAM');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2235, 'MAIDSTONE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2245, 'SEVENOAKS');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2250, 'Folkestone and Hythe');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2255, 'SWALE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2260, 'THANET DISTRICT');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2265, 'TONBRIDGE AND MALLING');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2270, 'TUNBRIDGE WELLS');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2280, 'MEDWAY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2315, 'BURNLEY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2320, 'CHORLEY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2325, 'FYLDE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2330, 'HYNDBURN');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2335, 'LANCASTER CITY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2340, 'PENDLE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2345, 'PRESTON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2350, 'RIBBLE VALLEY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2355, 'ROSSENDALE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2360, 'SOUTH RIBBLE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2365, 'WEST LANCASHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2370, 'WYRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2372, 'BLACKBURN WITH DARWEN');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2373, 'BLACKPOOL');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2405, 'BLABY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2410, 'CHARNWOOD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2415, 'HARBOROUGH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2420, 'HINCKLEY AND BOSWORTH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2430, 'MELTON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2435, 'NORTH WEST LEICESTERSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2440, 'OADBY AND WIGSTON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2465, 'LEICESTER CITY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2470, 'RUTLAND');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2505, 'BOSTON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2510, 'EAST LINDSEY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2515, 'LINCOLN');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2520, 'NORTH KESTEVEN');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2525, 'SOUTH HOLLAND');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2530, 'SOUTH KESTEVEN');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2535, 'WEST LINDSEY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2605, 'BRECKLAND');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2610, 'BROADLAND');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2615, 'GREAT YARMOUTH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2620, 'NORTH NORFOLK');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2625, 'NORWICH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2630, 'SOUTH NORFOLK');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2635, 'KINGS LYNN AND WEST NORFOLK');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2705, 'CRAVEN');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2710, 'HAMBLETON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2715, 'HARROGATE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2720, 'RICHMONDSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2725, 'RYEDALE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2730, 'SCARBOROUGH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2735, 'SELBY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2741, 'YORK');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2805, 'CORBY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2810, 'DAVENTRY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2815, 'EAST NORTHAMPTONSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2820, 'KETTERING');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2825, 'NORTHAMPTON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2830, 'SOUTH NORTHAMPTONSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2835, 'WELLINGBOROUGH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2935, 'NORTHUMBERLAND');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3005, 'ASHFIELD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3010, 'BASSETLAW');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3015, 'BROXTOWE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3020, 'GEDLING');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3025, 'MANSFIELD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3030, 'NEWARK AND SHERWOOD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3040, 'RUSHCLIFFE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3060, 'NOTTINGHAM CITY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3105, 'CHERWELL');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3110, 'OXFORD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3115, 'SOUTH OXFORDSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3120, 'VALE OF WHITE HORSE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3125, 'WEST OXFORDSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3240, 'TELFORD AND WREKIN');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3245, 'SHROPSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3305, 'MENDIP');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3310, 'SEDGEMOOR');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3315, 'TAUNTON DEANE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3320, 'WEST SOMERSET');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3325, 'SOUTH SOMERSET');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3405, 'CANNOCK CHASE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3410, 'EAST STAFFORDSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3415, 'LICHFIELD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3420, 'NEWCASTLE-UNDER-LYME');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3425, 'STAFFORD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3430, 'SOUTH STAFFORDSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3435, 'STAFFORDSHIRE MOORLANDS');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3445, 'TAMWORTH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3455, 'CITY OF STOKE-ON-TRENT');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3505, 'BABERGH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3510, 'FOREST HEATH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3515, 'IPSWICH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3520, 'MID SUFFOLK');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3525, 'ST EDMUNDSBURY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3530, 'SUFFOLK COASTAL');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3535, 'WAVENEY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3605, 'ELMBRIDGE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3610, 'EPSOM AND EWELL');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3615, 'GUILDFORD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3620, 'MOLE VALLEY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3625, 'REIGATE AND BANSTEAD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3630, 'RUNNYMEDE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3635, 'SPELTHORNE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3640, 'SURREY HEATH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3645, 'TANDRIDGE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3650, 'WAVERLEY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3655, 'WOKING');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3705, 'NORTH WARWICKSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3710, 'NUNEATON AND BEDWORTH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3715, 'RUGBY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3720, 'STRATFORD-ON-AVON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3725, 'WARWICK');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3805, 'ADUR');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3810, 'ARUN');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3815, 'CHICHESTER');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3820, 'CRAWLEY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3825, 'HORSHAM');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3830, 'MID SUSSEX');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3835, 'WORTHING');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3935, 'SWINDON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3940, 'WILTSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4205, 'BOLTON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4210, 'BURY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4215, 'MANCHESTER');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4220, 'OLDHAM');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4225, 'ROCHDALE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4230, 'SALFORD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4235, 'STOCKPORT');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4240, 'TAMESIDE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4245, 'TRAFFORD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4250, 'WIGAN');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4305, 'KNOWSLEY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4310, 'LIVERPOOL');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4315, 'ST HELENS COUNCIL');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4320, 'SEFTON COUNCIL');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4325, 'WIRRAL');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4405, 'BARNSLEY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4410, 'DONCASTER');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4415, 'ROTHERHAM');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4420, 'SHEFFIELD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4505, 'GATESHEAD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4510, 'NEWCASTLE UPON TYNE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4515, 'NORTH TYNESIDE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4520, 'SOUTH TYNESIDE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4525, 'SUNDERLAND');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4605, 'BIRMINGHAM');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4610, 'COVENTRY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4615, 'DUDLEY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4620, 'SANDWELL');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4625, 'SOLIHULL');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4630, 'WALSALL');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4635, 'WOLVERHAMPTON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4705, 'BRADFORD MDC');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4710, 'CALDERDALE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4715, 'KIRKLEES');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4720, 'LEEDS');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(4725, 'WAKEFIELD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5030, 'CITY OF LONDON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5060, 'BARKING AND DAGENHAM');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5090, 'BARNET');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5120, 'BEXLEY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5150, 'BRENT');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5180, 'LONDON BOROUGH OF BROMLEY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5210, 'CAMDEN');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5240, 'CROYDON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5270, 'EALING');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5300, 'ENFIELD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5330, 'GREENWICH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5360, 'HACKNEY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5390, 'HAMMERSMITH AND FULHAM');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5420, 'LONDON BOROUGH OF HARINGEY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5450, 'HARROW');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5480, 'HAVERING');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5510, 'HILLINGDON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5540, 'LONDON BOROUGH OF HOUNSLOW');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5570, 'ISLINGTON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5600, 'KENSINGTON AND CHELSEA');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5630, 'KINGSTON UPON THAMES');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5660, 'LAMBETH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5690, 'LEWISHAM');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5720, 'MERTON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5750, 'NEWHAM');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5780, 'REDBRIDGE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5810, 'RICHMOND UPON THAMES');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5840, 'SOUTHWARK');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5870, 'SUTTON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5900, 'TOWER HAMLETS');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5930, 'WALTHAM FOREST');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5960, 'WANDSWORTH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(5990, 'CITY OF WESTMINSTER');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(6805, 'ISLE OF ANGLESEY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(6810, 'GWYNEDD');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(6815, 'CARDIFF');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(6820, 'CEREDIGION');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(6825, 'CARMARTHENSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(6830, 'DENBIGHSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(6835, 'FLINTSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(6840, 'MONMOUTHSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(6845, 'PEMBROKESHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(6850, 'POWYS');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(6855, 'SWANSEA');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(6905, 'CONWY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(6910, 'BLAENAU GWENT');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(6915, 'BRIDGEND COUNTY BOROUGH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(6920, 'CAERPHILLY COUNTY BOROUGH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(6925, 'MERTHYR TYDFIL UA');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(6930, 'NEATH PORT TALBOT');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(6935, 'NEWPORT');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(6940, 'RHONDDA CYNON TAFF');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(6945, 'TORFAEN');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(6950, 'VALE OF GLAMORGAN');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(6955, 'WREXHAM');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9000, 'ORKNEY ISLANDS');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9010, 'SHETLAND ISLANDS');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9020, 'WESTERN ISLES');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9051, 'CITY OF ABERDEEN');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9052, 'ABERDEENSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9053, 'ANGUS');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9054, 'ARGYLL AND BUTE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9055, 'SCOTTISH BORDERS');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9056, 'CLACKMANNAN');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9057, 'WEST DUNBARTONSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9058, 'DUMFRIES AND GALLOWAY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9059, 'CITY OF DUNDEE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9060, 'EAST AYRSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9061, 'EAST DUNBARTONSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9062, 'EAST LOTHIAN');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9063, 'EAST RENFREWSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9064, 'CITY OF EDINBURGH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9065, 'FALKIRK');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9066, 'FIFE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9067, 'CITY OF GLASGOW');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9068, 'HIGHLAND');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9069, 'INVERCLYDE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9070, 'MIDLOTHIAN');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9071, 'MORAY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9072, 'NORTH AYRSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9073, 'NORTH LANARKSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9074, 'PERTH AND KINROSS');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9075, 'RENFREWSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9076, 'SOUTH AYRSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9077, 'SOUTH LANARKSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9078, 'STIRLING');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(9079, 'WEST LOTHIAN');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(7655, 'ORDNANCE SURVEY');