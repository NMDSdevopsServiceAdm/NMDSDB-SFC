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

--fa
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
    "SecurityQuestion" character varying(255) NOT NULL,
    "SecurityQuestionAnswer" character varying(255) NOT NULL,
    "Active" boolean NOT NULL,
    "InvalidAttempt" integer NOT NULL,
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

---- Services
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



----Service Capacities
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (1, 24, 1, 'How many beds do you currently have?');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (2, 24, 2, 'How many of those beds are currently used?');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (3, 25, 1, 'How many beds do you currently have?');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (4, 25, 2, 'How many of those beds are currently used?');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (5, 13, 1, 'Number of people receiving care on the completion date');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (6, 12, 1, 'How many beds do you currently have?');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (7, 12, 2, 'How many of those beds are currently used?');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (8, 9, 1, 'How many places do you currently have?');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (9, 9, 2, 'Number of people using the service on the completion date');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (10, 10, 1, 'How many places do you currently have?');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (11, 10, 2, 'Number of people using the service on the completion date');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (12, 20, 2, 'Number of people using the service on the completion date');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (13, 22, 1, 'Number of people receiving care on the completion date');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (14, 35, 1, 'Number of people receiving care on the completion date');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (15, 11, 1, 'Number of people receiving care on the completion date');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (16, 18, 1, 'Number of people receiving care on the completion date');

----Jobs

insert into cqc."Job" ("JobID", "JobName") values (1, 'Activities worker or co-ordinator');
insert into cqc."Job" ("JobID", "JobName") values (2, 'Administrative / office staff not care-providing');
insert into cqc."Job" ("JobID", "JobName") values (3, 'Advice, Guidance and Advocacy');
insert into cqc."Job" ("JobID", "JobName") values (4, 'Allied Health Professional (not Occupational Therapist)');
insert into cqc."Job" ("JobID", "JobName") values (5, 'Ancillary staff not care-providing');
insert into cqc."Job" ("JobID", "JobName") values (6, 'Any childrens / young people''s job role');
insert into cqc."Job" ("JobID", "JobName") values (7, 'Assessment Officer');
insert into cqc."Job" ("JobID", "JobName") values (8, 'Care Coordinator');
insert into cqc."Job" ("JobID", "JobName") values (9, 'Care Navigator');
insert into cqc."Job" ("JobID", "JobName") values (10, 'Care Worker');
insert into cqc."Job" ("JobID", "JobName") values (11, 'Community, Support and Outreach Work');
insert into cqc."Job" ("JobID", "JobName") values (12, 'Employment Support');
insert into cqc."Job" ("JobID", "JobName") values (13, 'First Line Manager');
insert into cqc."Job" ("JobID", "JobName") values (14, 'Managers and staff care-related but not care-providing');
insert into cqc."Job" ("JobID", "JobName") values (15, 'Middle Management');
insert into cqc."Job" ("JobID", "JobName") values (16, 'Nursing Assistant');
insert into cqc."Job" ("JobID", "JobName") values (17, 'Nursing Associate');
insert into cqc."Job" ("JobID", "JobName") values (18, 'Occupational Therapist');
insert into cqc."Job" ("JobID", "JobName") values (19, 'Occupational Therapist Assistant');
insert into cqc."Job" ("JobID", "JobName") values (20, 'Other job roles directly involved in providing care');
insert into cqc."Job" ("JobID", "JobName") values (21, 'Other job roles not directly involved in providing care');
insert into cqc."Job" ("JobID", "JobName") values (22, 'Registered Manager');
insert into cqc."Job" ("JobID", "JobName") values (23, 'Registered Nurse');
insert into cqc."Job" ("JobID", "JobName") values (24, 'Safeguarding & Reviewing Officer');
insert into cqc."Job" ("JobID", "JobName") values (25, 'Senior Care Worker');
insert into cqc."Job" ("JobID", "JobName") values (26, 'Senior Management');
insert into cqc."Job" ("JobID", "JobName") values (27, 'Social Worker');
insert into cqc."Job" ("JobID", "JobName") values (28, 'Supervisor');
insert into cqc."Job" ("JobID", "JobName") values (29, 'Technician');


---- Local Authorities
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
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(425, 'WYCOMBE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(435, 'MILTON KEYNES');
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
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1045, 'DERBYSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1055, 'DERBY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1160, 'PLYMOUTH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1165, 'TORBAY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1250, 'BOURNEMOUTH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1255, 'POOLE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1350, 'DARLINGTON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1355, 'DURHAM');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1445, 'BRIGHTON & HOVE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1590, 'SOUTHEND-ON-SEA');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1620, 'GLOUCESTERSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1775, 'PORTSMOUTH CITY COUNCIL');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1780, 'SOUTHAMPTON');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(1850, 'HEREFORDSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2001, 'EAST RIDING OF YORKSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2002, 'NORTH EAST LINCOLNSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2003, 'NORTH LINCOLNSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2004, 'KINGSTON UPON HULL');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2114, 'ISLE OF WIGHT');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2280, 'MEDWAY');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2335, 'LANCASHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2372, 'BLACKBURN WITH DARWEN');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2373, 'BLACKPOOL');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2465, 'LEICESTER');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2470, 'RUTLAND');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2515, 'LINCOLNSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2635, 'KINGS LYNN AND WEST NORFOLK');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2741, 'YORK');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2830, 'SOUTH NORTHAMPTONSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(2935, 'NORTHUMBERLAND');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3060, 'NOTTINGHAM');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3110, 'OXFORDSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3240, 'TELFORD AND WREKIN');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3245, 'SHROPSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3320, 'WEST SOMERSET');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3430, 'SOUTH STAFFORDSHIRE');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3530, 'SUFFOLK COASTAL');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3640, 'SURREY HEATH');
insert into cqc."LocalAuthority" ("LocalCustodianCode", "LocalAuthorityName") values(3725, 'WARWICKSHIRE');
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


-- removing the unnecessary location.cqcid and promoting location.locationid as primary key
--ALTER TABLE cqc.location DROP CONSTRAINT location_pkey;
--ALTER TABLE cqc.location DROP COLUMN cqcid ;
--ALTER TABLE cqc.location  add constraint locationid_PK PRIMARY KEY (locationid);
--ALTER TABLE cqc.location  add constraint locationid_Unq UNIQUE  (locationid);

CREATE TYPE cqc.job_declaration AS ENUM (
    'None',
    'Don''t know',
	'With Jobs'
);

ALTER TABLE cqc."Establishment" add column "Vacancies" cqc.job_declaration NULL;
ALTER TABLE cqc."Establishment" add column "Starters" cqc.job_declaration NULL;
ALTER TABLE cqc."Establishment" add column "Leavers" cqc.job_declaration NULL;

-- https://trello.com/c/LgdigwUb - duplicate establishment
DROP INDEX IF EXISTS cqc."Establishment_unique_registration";
DROP INDEX IF EXISTS cqc."Establishment_unique_registration_with_locationid";
CREATE UNIQUE INDEX IF NOT EXISTS "Establishment_unique_registration" ON cqc."Establishment" ("Name", "PostCode");
CREATE UNIQUE INDEX IF NOT EXISTS "Establishment_unique_registration_with_locationid" ON cqc."Establishment" ("Name", "PostCode", "LocationID") WHERE "LocationID" IS NOT NULL;


-- password reset - https://trello.com/c/isgnA7X5
CREATE SEQUENCE IF NOT EXISTS cqc."PasswdResetTracking_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;CREATE SEQUENCE IF NOT EXISTS cqc.passwdresettracking_seq
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
ALTER TABLE cqc."PasswdResetTracking" ALTER COLUMN "ID" SET DEFAULT nextval('cqc.passwdresettracking_seq');
ALTER TABLE cqc."PasswdResetTracking" OWNER TO sfcadmin;


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
CREATE INDEX "UsertAudit_UserFK" on cqc."UserAudit" ("UserFK");

ALTER TABLE cqc."Login" ADD COLUMN "PasswdLastChanged" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW();