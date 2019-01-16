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

CREATE SCHEMA cqc;


ALTER SCHEMA cqc OWNER TO sfcadmin;

--
-- Name: cqctst; Type: SCHEMA; Schema: -; Owner: sfcadmin
--

CREATE SCHEMA cqctst;


ALTER SCHEMA cqctst OWNER TO sfcadmin;

--
-- Name: cqctsttst; Type: SCHEMA; Schema: -; Owner: sfcadmin
--

CREATE SCHEMA cqctsttst;


ALTER SCHEMA cqctsttst OWNER TO sfcadmin;

--
-- Name: sfcfuldata; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA sfcfuldata;


ALTER SCHEMA sfcfuldata OWNER TO postgres;

--
-- Name: est_employertype_enum; Type: TYPE; Schema: cqc; Owner: postgres
--

CREATE TYPE cqc.est_employertype_enum AS ENUM (
    'Private Sector',
    'Voluntary / Charity',
    'Other'
);


ALTER TYPE cqc.est_employertype_enum OWNER TO postgres;

SET default_tablespace = sfcdevtbs_logins;

SET default_with_oids = false;

--
-- Name: CqcLog; Type: TABLE; Schema: cqc; Owner: postgres; Tablespace: sfcdevtbs_logins
--

CREATE TABLE cqc."CqcLog" (
    id integer NOT NULL,
    success boolean,
    message character varying(255),
    createdat timestamp with time zone NOT NULL,
    "lastUpdatedAt" text
);


ALTER TABLE cqc."CqcLog" OWNER TO postgres;

--
-- Name: Establishment; Type: TABLE; Schema: cqc; Owner: sfcadmin; Tablespace: sfcdevtbs_logins
--

CREATE TABLE cqc."Establishment" (
    "EstablishmentID" integer NOT NULL,
    "Name" text NOT NULL,
    "Address" text,
    "LocationID" text,
    "PostCode" text,
    "IsRegulated" boolean NOT NULL,
    "MainServiceId" integer,
    "EmployerType" cqc.est_employertype_enum
);


ALTER TABLE cqc."Establishment" OWNER TO sfcadmin;

SET default_tablespace = '';

--
-- Name: EstablishmentCapacity; Type: TABLE; Schema: cqc; Owner: postgres
--

CREATE TABLE cqc."EstablishmentCapacity" (
    "EstablishmentCapacityID" integer NOT NULL,
    "EstablishmentID" integer,
    "ServiceCapacityID" integer NOT NULL,
    "Answer" integer
);


ALTER TABLE cqc."EstablishmentCapacity" OWNER TO postgres;

--
-- Name: EstablishmentCapacity_EstablishmentCapacityID_seq; Type: SEQUENCE; Schema: cqc; Owner: postgres
--

CREATE SEQUENCE cqc."EstablishmentCapacity_EstablishmentCapacityID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cqc."EstablishmentCapacity_EstablishmentCapacityID_seq" OWNER TO postgres;

--
-- Name: EstablishmentCapacity_EstablishmentCapacityID_seq; Type: SEQUENCE OWNED BY; Schema: cqc; Owner: postgres
--

ALTER SEQUENCE cqc."EstablishmentCapacity_EstablishmentCapacityID_seq" OWNED BY cqc."EstablishmentCapacity"."EstablishmentCapacityID";


--
-- Name: EstablishmentJobs; Type: TABLE; Schema: cqc; Owner: sfcadmin
--

CREATE TABLE cqc."EstablishmentJobs" (
    "JobID" integer NOT NULL,
    "EstablishmentID" integer,
    "EstablishmentJobID" integer
);


ALTER TABLE cqc."EstablishmentJobs" OWNER TO sfcadmin;

--
-- Name: EstablishmentJobs_JobID_seq; Type: SEQUENCE; Schema: cqc; Owner: sfcadmin
--

CREATE SEQUENCE cqc."EstablishmentJobs_JobID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cqc."EstablishmentJobs_JobID_seq" OWNER TO sfcadmin;

--
-- Name: EstablishmentJobs_JobID_seq; Type: SEQUENCE OWNED BY; Schema: cqc; Owner: sfcadmin
--

ALTER SEQUENCE cqc."EstablishmentJobs_JobID_seq" OWNED BY cqc."EstablishmentJobs"."JobID";


--
-- Name: EstablishmentLocalAuthority; Type: TABLE; Schema: cqc; Owner: sfcadmin
--

CREATE TABLE cqc."EstablishmentLocalAuthority" (
    "EstablishmentID" integer,
    "EstbLaID" integer,
    "LocalCustodianCode" integer
);


ALTER TABLE cqc."EstablishmentLocalAuthority" OWNER TO sfcadmin;

--
-- Name: EstablishmentServices; Type: TABLE; Schema: cqc; Owner: sfcadmin
--

CREATE TABLE cqc."EstablishmentServices" (
    "EstablishmentID" integer NOT NULL,
    "ServiceID" integer NOT NULL
);


ALTER TABLE cqc."EstablishmentServices" OWNER TO sfcadmin;

--
-- Name: Establishment_EstablishmentID_seq; Type: SEQUENCE; Schema: cqc; Owner: sfcadmin
--

CREATE SEQUENCE cqc."Establishment_EstablishmentID_seq"
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

ALTER SEQUENCE cqc."Establishment_EstablishmentID_seq" OWNED BY cqc."Establishment"."EstablishmentID";


--
-- Name: Job; Type: TABLE; Schema: cqc; Owner: sfcadmin
--

CREATE TABLE cqc."Job" (
    "JobID" integer NOT NULL,
    "JobName" text
);


ALTER TABLE cqc."Job" OWNER TO sfcadmin;

--
-- Name: LocalAuthority ; Type: TABLE; Schema: cqc; Owner: sfcadmin
--

CREATE TABLE cqc."LocalAuthority " (
    "LocalCustodianCode" integer,
    "LocalAuthorityName" text
);


ALTER TABLE cqc."LocalAuthority " OWNER TO sfcadmin;

SET default_tablespace = sfcdevtbs_logins;

--
-- Name: Login; Type: TABLE; Schema: cqc; Owner: sfcadmin; Tablespace: sfcdevtbs_logins
--

CREATE TABLE cqc."Login" (
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

CREATE SEQUENCE cqc."Login_ID_seq"
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

ALTER SEQUENCE cqc."Login_ID_seq" OWNED BY cqc."Login"."ID";


SET default_tablespace = '';

--
-- Name: ServicesCapacity; Type: TABLE; Schema: cqc; Owner: sfcadmin
--

CREATE TABLE cqc."ServicesCapacity" (
    "ServiceID" integer,
    "Question" text,
    "Sequence" integer,
    "ServiceCapacityID" integer NOT NULL
);


ALTER TABLE cqc."ServicesCapacity" OWNER TO sfcadmin;

SET default_tablespace = sfcdevtbs_logins;

--
-- Name: User; Type: TABLE; Schema: cqc; Owner: sfcadmin; Tablespace: sfcdevtbs_logins
--

CREATE TABLE cqc."User" (
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

CREATE SEQUENCE cqc."User_RegistrationID_seq"
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

ALTER SEQUENCE cqc."User_RegistrationID_seq" OWNED BY cqc."User"."RegistrationID";


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


ALTER TABLE cqc.cqclog_id_seq OWNER TO postgres;

--
-- Name: cqclog_id_seq; Type: SEQUENCE OWNED BY; Schema: cqc; Owner: postgres
--

ALTER SEQUENCE cqc.cqclog_id_seq OWNED BY cqc."CqcLog".id;


--
-- Name: location_cqcid_seq; Type: SEQUENCE; Schema: cqc; Owner: sfcadmin
--

CREATE SEQUENCE cqc.location_cqcid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cqc.location_cqcid_seq OWNER TO sfcadmin;

--
-- Name: location; Type: TABLE; Schema: cqc; Owner: sfcadmin; Tablespace: sfcdevtbs_logins
--

CREATE TABLE cqc.location (
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
    updatedat timestamp without time zone
);


ALTER TABLE cqc.location OWNER TO sfcadmin;

--
-- Name: log_id_seq; Type: SEQUENCE; Schema: cqc; Owner: postgres
--

CREATE SEQUENCE cqc.log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cqc.log_id_seq OWNER TO postgres;

--
-- Name: pcodedata; Type: TABLE; Schema: cqc; Owner: sfcadmin; Tablespace: sfcdevtbs_logins
--

CREATE TABLE cqc.pcodedata (
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

CREATE TABLE cqc.services (
    id integer NOT NULL,
    name text,
    category text,
    capacityquestion text,
    currentuptakequestion text,
    iscqcregistered boolean,
    ismain boolean DEFAULT true
);


ALTER TABLE cqc.services OWNER TO sfcadmin;

--
-- Name: services_id_seq; Type: SEQUENCE; Schema: cqc; Owner: sfcadmin
--

CREATE SEQUENCE cqc.services_id_seq
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

ALTER SEQUENCE cqc.services_id_seq OWNED BY cqc.services.id;


--
-- Name: Establishment; Type: TABLE; Schema: cqctst; Owner: sfcadmin; Tablespace: sfcdevtbs_logins
--

CREATE TABLE cqctst."Establishment" (
    "EstablishmentID" integer NOT NULL,
    "Name" text,
    "Address" text,
    "LocationID" text,
    "PostCode" text,
    "IsRegulated" boolean NOT NULL,
    "MainServiceId" integer
);


ALTER TABLE cqctst."Establishment" OWNER TO sfcadmin;

--
-- Name: Establishment_EstablishmentID_seq; Type: SEQUENCE; Schema: cqctst; Owner: sfcadmin
--

CREATE SEQUENCE cqctst."Establishment_EstablishmentID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cqctst."Establishment_EstablishmentID_seq" OWNER TO sfcadmin;

--
-- Name: Establishment_EstablishmentID_seq; Type: SEQUENCE OWNED BY; Schema: cqctst; Owner: sfcadmin
--

ALTER SEQUENCE cqctst."Establishment_EstablishmentID_seq" OWNED BY cqctst."Establishment"."EstablishmentID";


--
-- Name: Login; Type: TABLE; Schema: cqctst; Owner: sfcadmin; Tablespace: sfcdevtbs_logins
--

CREATE TABLE cqctst."Login" (
    "ID" integer NOT NULL,
    "RegistrationID" integer NOT NULL,
    "Username" character varying(50) NOT NULL,
    "Password" character varying(50) NOT NULL,
    "SecurityQuestion" character varying(255) NOT NULL,
    "SecurityQuestionAnswer" character varying(255) NOT NULL,
    "Active" boolean NOT NULL,
    "InvalidAttempt" integer NOT NULL
);


ALTER TABLE cqctst."Login" OWNER TO sfcadmin;

--
-- Name: Login_ID_seq; Type: SEQUENCE; Schema: cqctst; Owner: sfcadmin
--

CREATE SEQUENCE cqctst."Login_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cqctst."Login_ID_seq" OWNER TO sfcadmin;

--
-- Name: Login_ID_seq; Type: SEQUENCE OWNED BY; Schema: cqctst; Owner: sfcadmin
--

ALTER SEQUENCE cqctst."Login_ID_seq" OWNED BY cqctst."Login"."ID";


SET default_tablespace = '';

--
-- Name: TestTable; Type: TABLE; Schema: cqctst; Owner: sfcadmin
--

CREATE TABLE cqctst."TestTable" (
    "FreeText" text
);


ALTER TABLE cqctst."TestTable" OWNER TO sfcadmin;

SET default_tablespace = sfcdevtbs_logins;

--
-- Name: User; Type: TABLE; Schema: cqctst; Owner: sfcadmin; Tablespace: sfcdevtbs_logins
--

CREATE TABLE cqctst."User" (
    "RegistrationID" integer NOT NULL,
    "FullName" character varying(50) NOT NULL,
    "JobTitle" character varying(255) NOT NULL,
    "Email" character varying(255) NOT NULL,
    "Phone" character varying(50) NOT NULL,
    "DateCreated" timestamp without time zone NOT NULL,
    "EstablishmentID" integer NOT NULL,
    "AdminUser" boolean NOT NULL
);


ALTER TABLE cqctst."User" OWNER TO sfcadmin;

--
-- Name: User_RegistrationID_seq; Type: SEQUENCE; Schema: cqctst; Owner: sfcadmin
--

CREATE SEQUENCE cqctst."User_RegistrationID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cqctst."User_RegistrationID_seq" OWNER TO sfcadmin;

--
-- Name: User_RegistrationID_seq; Type: SEQUENCE OWNED BY; Schema: cqctst; Owner: sfcadmin
--

ALTER SEQUENCE cqctst."User_RegistrationID_seq" OWNED BY cqctst."User"."RegistrationID";


--
-- Name: cqctstlog; Type: TABLE; Schema: cqctst; Owner: postgres; Tablespace: sfcdevtbs_logins
--

CREATE TABLE cqctst.cqctstlog (
    id integer NOT NULL,
    success boolean,
    message character varying(255),
    createdat timestamp with time zone NOT NULL,
    "lastUpdatedAt" text
);


ALTER TABLE cqctst.cqctstlog OWNER TO postgres;

--
-- Name: cqctstlog_id_seq; Type: SEQUENCE; Schema: cqctst; Owner: postgres
--

CREATE SEQUENCE cqctst.cqctstlog_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cqctst.cqctstlog_id_seq OWNER TO postgres;

--
-- Name: cqctstlog_id_seq; Type: SEQUENCE OWNED BY; Schema: cqctst; Owner: postgres
--

ALTER SEQUENCE cqctst.cqctstlog_id_seq OWNED BY cqctst.cqctstlog.id;


--
-- Name: location_cqctstid_seq; Type: SEQUENCE; Schema: cqctst; Owner: sfcadmin
--

CREATE SEQUENCE cqctst.location_cqctstid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cqctst.location_cqctstid_seq OWNER TO sfcadmin;

--
-- Name: location; Type: TABLE; Schema: cqctst; Owner: sfcadmin; Tablespace: sfcdevtbs_logins
--

CREATE TABLE cqctst.location (
    cqctstid integer DEFAULT nextval('cqctst.location_cqctstid_seq'::regclass) NOT NULL,
    locationid text,
    locationname text,
    addressline1 text,
    addressline2 text,
    towncity text,
    county text,
    postalcode text,
    mainservice text,
    createdat timestamp without time zone NOT NULL,
    updatedat timestamp without time zone
);


ALTER TABLE cqctst.location OWNER TO sfcadmin;

--
-- Name: log_id_seq; Type: SEQUENCE; Schema: cqctst; Owner: postgres
--

CREATE SEQUENCE cqctst.log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cqctst.log_id_seq OWNER TO postgres;

--
-- Name: pcodedata; Type: TABLE; Schema: cqctst; Owner: postgres; Tablespace: sfcdevtbs_logins
--

CREATE TABLE cqctst.pcodedata (
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


ALTER TABLE cqctst.pcodedata OWNER TO postgres;

SET default_tablespace = '';

--
-- Name: pcodedata_old; Type: TABLE; Schema: cqctst; Owner: postgres
--

CREATE TABLE cqctst.pcodedata_old (
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


ALTER TABLE cqctst.pcodedata_old OWNER TO postgres;

SET default_tablespace = sfcdevtbs_logins;

--
-- Name: services; Type: TABLE; Schema: cqctst; Owner: sfcadmin; Tablespace: sfcdevtbs_logins
--

CREATE TABLE cqctst.services (
    id integer NOT NULL,
    name text,
    category text,
    capacityquestion text,
    currentuptakequestion text,
    iscqctstregistered boolean
);


ALTER TABLE cqctst.services OWNER TO sfcadmin;

--
-- Name: services_id_seq; Type: SEQUENCE; Schema: cqctst; Owner: sfcadmin
--

CREATE SEQUENCE cqctst.services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cqctst.services_id_seq OWNER TO sfcadmin;

--
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: cqctst; Owner: sfcadmin
--

ALTER SEQUENCE cqctst.services_id_seq OWNED BY cqctst.services.id;


SET default_tablespace = '';

--
-- Name: cqc.Establishment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."cqc.Establishment" (
    "EstablishmentID" integer NOT NULL,
    "Name" character varying(200) NOT NULL,
    "Address" character varying(200) NOT NULL,
    "LocationID" character varying(200) NOT NULL,
    "PostCode" character varying(200) NOT NULL,
    "MainService" character varying(200) NOT NULL,
    "IsRegulated" boolean NOT NULL
);


ALTER TABLE public."cqc.Establishment" OWNER TO postgres;

--
-- Name: cqc.Login; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."cqc.Login" (
    "ID" integer NOT NULL,
    "RegistrationID" integer NOT NULL,
    "Username" character varying(200) NOT NULL,
    "Password" character varying(200) NOT NULL,
    "SecurityQuestion" character varying(200) NOT NULL,
    "SecurityQuestionAnswer" character varying(200) NOT NULL,
    "Active" boolean NOT NULL,
    "InvalidAttempt" integer NOT NULL
);


ALTER TABLE public."cqc.Login" OWNER TO postgres;

--
-- Name: cqc.User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."cqc.User" (
    "RegistrationID" integer NOT NULL,
    "FullName" character varying(200) NOT NULL,
    "JobTitle" character varying(200) NOT NULL,
    "Email" character varying(200) NOT NULL,
    "Phone" character varying(200) NOT NULL,
    "DateCreated" timestamp without time zone NOT NULL,
    "EstablishmentID" integer NOT NULL,
    "AdminUser" boolean NOT NULL
);


ALTER TABLE public."cqc.User" OWNER TO postgres;

--
-- Name: cqctst.Establishment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."cqctst.Establishment" (
    "EstablishmentID" integer NOT NULL,
    "Name" character varying(200) NOT NULL,
    "Address" character varying(200) NOT NULL,
    "LocationID" character varying(200) NOT NULL,
    "PostCode" character varying(200) NOT NULL,
    "MainService" character varying(200) NOT NULL,
    "IsRegulated" boolean NOT NULL
);


ALTER TABLE public."cqctst.Establishment" OWNER TO postgres;

--
-- Name: cqctst.Login; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."cqctst.Login" (
    "ID" integer NOT NULL,
    "RegistrationID" integer NOT NULL,
    "Username" character varying(200) NOT NULL,
    "Password" character varying(200) NOT NULL,
    "SecurityQuestion" character varying(200) NOT NULL,
    "SecurityQuestionAnswer" character varying(200) NOT NULL,
    "Active" boolean NOT NULL,
    "InvalidAttempt" integer NOT NULL
);


ALTER TABLE public."cqctst.Login" OWNER TO postgres;

--
-- Name: cqctst.User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."cqctst.User" (
    "RegistrationID" integer NOT NULL,
    "FullName" character varying(200) NOT NULL,
    "JobTitle" character varying(200) NOT NULL,
    "Email" character varying(200) NOT NULL,
    "Phone" character varying(200) NOT NULL,
    "DateCreated" timestamp without time zone NOT NULL,
    "EstablishmentID" integer NOT NULL,
    "AdminUser" boolean NOT NULL
);


ALTER TABLE public."cqctst.User" OWNER TO postgres;

--
-- Name: adressbaseplus; Type: TABLE; Schema: sfcfuldata; Owner: postgres
--

CREATE TABLE sfcfuldata.adressbaseplus (
    uprn bigint NOT NULL,
    udprn bigint,
    change_type character varying,
    state bigint,
    state_date date,
    class character varying,
    parent_uprn bigint,
    x_coordinate numeric,
    y_coordinate numeric,
    latitude numeric,
    longitude numeric,
    rpc bigint,
    local_custodian_code bigint,
    country character varying,
    la_start_date date,
    last_update_date date,
    entry_date date,
    rm_organisation_name character varying,
    la_organisation character varying,
    department_name character varying,
    legal_name character varying,
    sub_building_name character varying,
    building_name character varying,
    building_number character varying,
    sao_start_number bigint,
    sao_start_suffix character varying,
    sao_end_number bigint,
    sao_end_suffix character varying,
    sao_text character varying,
    alt_language_sao_text character varying,
    pao_start_number bigint,
    pao_start_suffix character varying,
    pao_end_number bigint,
    pao_end_suffix character varying,
    pao_text character varying,
    alt_language_pao_text character varying,
    usrn bigint,
    usrn_match_indicator character varying,
    area_name character varying,
    level character varying,
    official_flag character varying,
    os_address_toid character varying,
    os_address_toid_version bigint,
    os_roadlink_toid character varying,
    os_roadlink_toid_version bigint,
    os_topo_toid character varying,
    os_topo_toid_version bigint,
    voa_ct_record bigint,
    voa_ndr_record bigint,
    street_description character varying,
    alt_language_street_description character varying,
    dependent_thoroughfare character varying,
    thoroughfare character varying,
    welsh_dependent_thoroughfare character varying,
    welsh_thoroughfare character varying,
    double_dependent_locality character varying,
    dependent_locality character varying,
    locality character varying,
    welsh_dependent_locality character varying,
    welsh_double_dependent_locality character varying,
    town_name character varying,
    administrative_area character varying,
    post_town character varying,
    welsh_post_town character varying,
    postcode character varying,
    postcode_locator character varying,
    postcode_type character varying,
    delivery_point_suffix character varying,
    addressbase_postal character varying,
    po_box_number character varying,
    ward_code character varying,
    parish_code character varying,
    rm_start_date date,
    multi_occ_count bigint,
    voa_ndr_p_desc_code character varying,
    voa_ndr_scat_code character varying,
    alt_language character varying
);


ALTER TABLE sfcfuldata.adressbaseplus OWNER TO postgres;

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
-- Name: EstablishmentJobs JobID; Type: DEFAULT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."EstablishmentJobs" ALTER COLUMN "JobID" SET DEFAULT nextval('cqc."EstablishmentJobs_JobID_seq"'::regclass);


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

ALTER TABLE ONLY cqc.services ALTER COLUMN id SET DEFAULT nextval('cqc.services_id_seq'::regclass);


--
-- Name: Establishment EstablishmentID; Type: DEFAULT; Schema: cqctst; Owner: sfcadmin
--

ALTER TABLE ONLY cqctst."Establishment" ALTER COLUMN "EstablishmentID" SET DEFAULT nextval('cqctst."Establishment_EstablishmentID_seq"'::regclass);


--
-- Name: Login ID; Type: DEFAULT; Schema: cqctst; Owner: sfcadmin
--

ALTER TABLE ONLY cqctst."Login" ALTER COLUMN "ID" SET DEFAULT nextval('cqctst."Login_ID_seq"'::regclass);


--
-- Name: User RegistrationID; Type: DEFAULT; Schema: cqctst; Owner: sfcadmin
--

ALTER TABLE ONLY cqctst."User" ALTER COLUMN "RegistrationID" SET DEFAULT nextval('cqctst."User_RegistrationID_seq"'::regclass);


--
-- Name: cqctstlog id; Type: DEFAULT; Schema: cqctst; Owner: postgres
--

ALTER TABLE ONLY cqctst.cqctstlog ALTER COLUMN id SET DEFAULT nextval('cqctst.cqctstlog_id_seq'::regclass);


--
-- Name: services id; Type: DEFAULT; Schema: cqctst; Owner: sfcadmin
--

ALTER TABLE ONLY cqctst.services ALTER COLUMN id SET DEFAULT nextval('cqctst.services_id_seq'::regclass);


--
-- Name: CqcLog CQCLog_pkey; Type: CONSTRAINT; Schema: cqc; Owner: postgres
--

ALTER TABLE ONLY cqc."CqcLog"
    ADD CONSTRAINT "CQCLog_pkey" PRIMARY KEY (id);


--
-- Name: EstablishmentCapacity EstablishmentCapacity_pkey1; Type: CONSTRAINT; Schema: cqc; Owner: postgres
--

ALTER TABLE ONLY cqc."EstablishmentCapacity"
    ADD CONSTRAINT "EstablishmentCapacity_pkey1" PRIMARY KEY ("ServiceCapacityID");


--
-- Name: EstablishmentJobs EstablishmentJobs_pkey; Type: CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."EstablishmentJobs"
    ADD CONSTRAINT "EstablishmentJobs_pkey" PRIMARY KEY ("JobID");


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
-- Name: location location_pkey; Type: CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc.location
    ADD CONSTRAINT location_pkey PRIMARY KEY (cqcid);


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
-- Name: location uniqlocationid; Type: CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc.location
    ADD CONSTRAINT uniqlocationid UNIQUE (locationid);


--
-- Name: Establishment unqestbid; Type: CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."Establishment"
    ADD CONSTRAINT unqestbid UNIQUE ("EstablishmentID");


--
-- Name: ServicesCapacity unqsrvcid; Type: CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."ServicesCapacity"
    ADD CONSTRAINT unqsrvcid UNIQUE ("ServiceID", "Sequence");


--
-- Name: cqctstlog cqctstLog_pkey; Type: CONSTRAINT; Schema: cqctst; Owner: postgres
--

ALTER TABLE ONLY cqctst.cqctstlog
    ADD CONSTRAINT "cqctstLog_pkey" PRIMARY KEY (id);


--
-- Name: location location_pkey; Type: CONSTRAINT; Schema: cqctst; Owner: sfcadmin
--

ALTER TABLE ONLY cqctst.location
    ADD CONSTRAINT location_pkey PRIMARY KEY (cqctstid);


--
-- Name: Login pk_Login; Type: CONSTRAINT; Schema: cqctst; Owner: sfcadmin
--

ALTER TABLE ONLY cqctst."Login"
    ADD CONSTRAINT "pk_Login" PRIMARY KEY ("ID");


--
-- Name: User pk_User; Type: CONSTRAINT; Schema: cqctst; Owner: sfcadmin
--

ALTER TABLE ONLY cqctst."User"
    ADD CONSTRAINT "pk_User" PRIMARY KEY ("RegistrationID");


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: cqctst; Owner: sfcadmin
--

ALTER TABLE ONLY cqctst.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: Login uc_Login_Username; Type: CONSTRAINT; Schema: cqctst; Owner: sfcadmin
--

ALTER TABLE ONLY cqctst."Login"
    ADD CONSTRAINT "uc_Login_Username" UNIQUE ("Username");


--
-- Name: location uniqlocationid; Type: CONSTRAINT; Schema: cqctst; Owner: sfcadmin
--

ALTER TABLE ONLY cqctst.location
    ADD CONSTRAINT uniqlocationid UNIQUE (locationid);


--
-- Name: cqc.Login pk_Login; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."cqc.Login"
    ADD CONSTRAINT "pk_Login" PRIMARY KEY ("ID");


--
-- Name: cqc.User pk_User; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."cqc.User"
    ADD CONSTRAINT "pk_User" PRIMARY KEY ("RegistrationID");


--
-- Name: cqc.Login uc_Login_Username; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."cqc.Login"
    ADD CONSTRAINT "uc_Login_Username" UNIQUE ("Username");


SET default_tablespace = sfcdevtbs_index;

--
-- Name: Postcodedata_postcode_Idx; Type: INDEX; Schema: cqc; Owner: sfcadmin; Tablespace: sfcdevtbs_index
--

CREATE INDEX "Postcodedata_postcode_Idx" ON cqc.pcodedata USING btree (postcode text_pattern_ops);


--
-- Name: Postcodedata_postcode_Idx; Type: INDEX; Schema: cqctst; Owner: postgres; Tablespace: sfcdevtbs_index
--

CREATE INDEX "Postcodedata_postcode_Idx" ON cqctst.pcodedata USING btree (postcode text_pattern_ops);


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
-- Name: Establishment mainserviceid_fk; Type: FK CONSTRAINT; Schema: cqc; Owner: sfcadmin
--

ALTER TABLE ONLY cqc."Establishment"
    ADD CONSTRAINT mainserviceid_fk FOREIGN KEY ("MainServiceId") REFERENCES cqc.services(id) MATCH FULL;


--
-- Name: Establishment mainserviceid_fk; Type: FK CONSTRAINT; Schema: cqctst; Owner: sfcadmin
--

ALTER TABLE ONLY cqctst."Establishment"
    ADD CONSTRAINT mainserviceid_fk FOREIGN KEY ("MainServiceId") REFERENCES cqctst.services(id) MATCH FULL;


--
-- Name: SCHEMA sfcfuldata; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA sfcfuldata TO sfcadmin;


--
-- Name: TABLE "CqcLog"; Type: ACL; Schema: cqc; Owner: postgres
--

GRANT ALL ON TABLE cqc."CqcLog" TO sfcadmin;


--
-- Name: SEQUENCE cqclog_id_seq; Type: ACL; Schema: cqc; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE cqc.cqclog_id_seq TO sfcadmin;


--
-- Name: SEQUENCE log_id_seq; Type: ACL; Schema: cqc; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE cqc.log_id_seq TO sfcadmin;


--
-- Name: TABLE cqctstlog; Type: ACL; Schema: cqctst; Owner: postgres
--

GRANT ALL ON TABLE cqctst.cqctstlog TO sfcadmin;


--
-- Name: SEQUENCE cqctstlog_id_seq; Type: ACL; Schema: cqctst; Owner: postgres
--

GRANT USAGE ON SEQUENCE cqctst.cqctstlog_id_seq TO sfcadmin;


--
-- Name: TABLE pcodedata; Type: ACL; Schema: cqctst; Owner: postgres
--

GRANT ALL ON TABLE cqctst.pcodedata TO sfcadmin;


--
-- Name: TABLE pcodedata_old; Type: ACL; Schema: cqctst; Owner: postgres
--

GRANT ALL ON TABLE cqctst.pcodedata_old TO sfcadmin;


--
-- Name: TABLE adressbaseplus; Type: ACL; Schema: sfcfuldata; Owner: postgres
--

GRANT ALL ON TABLE sfcfuldata.adressbaseplus TO sfcadmin;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: cqctst; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA cqctst REVOKE ALL ON TABLES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA cqctst GRANT ALL ON TABLES  TO sfcadmin;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: cqctsttst; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA cqctsttst REVOKE ALL ON TABLES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA cqctsttst GRANT ALL ON TABLES  TO sfcadmin;


-- CqcLocation Table Column update
ALTER TABLE cqc.location
    RENAME cqcid TO "EstablishmentID";
--
-- PostgreSQL database dump complete
--



