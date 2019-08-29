-- https://trello.com/c/UsiGWFJU

DROP TABLE IF EXISTS cqc."LocalAuthorityReportEstablishment";
CREATE TABLE cqc."LocalAuthorityReportEstablishment" (
	"ID" SERIAL NOT NULL PRIMARY KEY,
	"ReportFrom" DATE NOT NULL,
	"ReportTo" DATE NOT NULL,
	"EstablishmentFK" INTEGER NOT NULL,
	"WorkplaceFK" INTEGER NOT NULL,
	"WorkplaceName" TEXT NOT NULL,
	"WorkplaceID" TEXT NOT NULL,
	"LastUpdatedDate" DATE NOT NULL,
	"EstablishmentType" TEXT NOT NULL,
	"MainService" TEXT NOT NULL,
	"ServiceUserGroups" TEXT NOT NULL,
	"CapacityOfMainService" INTEGER NULL,							-- a null value is equivalent to N/A
	"UtilisationOfMainService" INTEGER NULL,					-- a null value is equivalent to N/A
	"NumberOfVacancies" INTEGER NOT NULL,
	"NumberOfStarters" INTEGER NOT NULL,
	"NumberOfLeavers" INTEGER NOT NULL,
	"NumberOfStaffRecords" INTEGER NOT NULL,
	--"NumberOfNonAgencyStaffRecords" INTEGER NOT NULL,
	--"NumberOfAgencyStaffRecords" INTEGER NOT NULL,
	"WorkplaceComplete" BOOLEAN NULL,							-- a null value is equivalent to N/A
	"NumberOfIndividualStaffRecords" INTEGER NOT NULL,
	"PercentageOfStaffRecords" NUMERIC(4,1) NOT NULL,	-- a number of 100.4 has a precision of 4 (digits in total) and a scale of 1 (decimal place)
	"NumberOfStaffRecordsNotAgency" INTEGER NOT NULL,
	"NumberOfCompleteStaffNotAgency" INTEGER NOT NULL,
	"PercentageOfCompleteStaffRecords" NUMERIC(4,1) NOT NULL,
	"NumberOfAgencyStaffRecords" INTEGER NOT NULL,
	"NumberOfCompleteAgencyStaffRecords" INTEGER NOT NULL,
	"PercentageOfCompleteAgencyStaffRecords" NUMERIC(4,1) NOT NULL,
	CONSTRAINT "EstablishmentFK_WorkplaceID" UNIQUE ("EstablishmentFK", "WorkplaceID")
);
CREATE INDEX LocalAuthorityReportEstablishment_EstablishmentFK on cqc."LocalAuthorityReportEstablishment" ("EstablishmentFK");

-- intentionally not using foreign key constraints - although the worker records relate to the establishment records; they used separately
DROP TABLE IF EXISTS cqc."LocalAuthorityReportWorker";
CREATE TABLE cqc."LocalAuthorityReportWorker" (
	"ID" SERIAL NOT NULL PRIMARY KEY,
	"LocalAuthorityReportEstablishmentFK" INTEGER NOT NULL,
	"WorkerFK" INTEGER NOT NULL,
	"LocalID" TEXT,
	"WorkplaceName" TEXT NOT NULL,
	"WorkplaceID" TEXT NOT NULL,
	"Gender" TEXT NOT NULL,
	"DateOfBirth" TEXT NOT NULL,
	"Ethnicity" TEXT NOT NULL,
	"MainJob" TEXT NOT NULL,
	"EmploymentStatus" TEXT NOT NULL,
	"ContractedAverageHours" TEXT NOT NULL,
	"SickDays" TEXT NOT NULL,
	"PayInterval" TEXT NOT NULL,
	"RateOfPay" TEXT NOT NULL,
	"RelevantSocialCareQualification" TEXT NOT NULL,
	"HighestSocialCareQualification" TEXT NOT NULL,
	"NonSocialCareQualification" TEXT NOT NULL,
	"LastUpdated" DATE NOT NULL,
	"StaffRecordComplete" BOOLEAN NOT NULL,
	CONSTRAINT "LocalAuthorityReportEstablishmentFK_WorkerFK" UNIQUE ("LocalAuthorityReportEstablishmentFK", "WorkerFK")
);
CREATE INDEX LocalAuthorityReportWorker_LocalAuthorityReportEstablishmentFK on cqc."LocalAuthorityReportWorker" ("LocalAuthorityReportEstablishmentFK");
CREATE INDEX LocalAuthorityReportWorker_WorkerFK on cqc."LocalAuthorityReportWorker" ("WorkerFK");

-- only run these on dev, staging and accessibility/demo databases
-- GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE cqc."LocalAuthorityReportEstablishment" TO "Sfc_App_Role";
-- GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE cqc."LocalAuthorityReportEstablishment" TO "Sfc_Admin_Role";
-- GRANT ALL ON TABLE cqc."LocalAuthorityReportEstablishment" TO sfcadmin;
-- GRANT INSERT, SELECT, UPDATE ON TABLE cqc."LocalAuthorityReportEstablishment" TO "Read_Update_Role";
-- GRANT SELECT ON TABLE cqc."LocalAuthorityReportEstablishment" TO "Read_Only_Role";

-- GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE cqc."LocalAuthorityReportWorker" TO "Sfc_App_Role";
-- GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE cqc."LocalAuthorityReportWorker" TO "Sfc_Admin_Role";
-- GRANT ALL ON TABLE cqc."LocalAuthorityReportWorker" TO sfcadmin;
-- GRANT INSERT, SELECT, UPDATE ON TABLE cqc."LocalAuthorityReportWorker" TO "Read_Update_Role";
-- GRANT SELECT ON TABLE cqc."LocalAuthorityReportWorker" TO "Read_Only_Role";


DROP FUNCTION IF EXISTS cqc.localAuthorityReportEstablishment;
CREATE OR REPLACE FUNCTION cqc.localAuthorityReportEstablishment(establishmentID INTEGER, reportFrom DATE, reportTo DATE)
 RETURNS BOOLEAN 
AS $$
DECLARE
	success BOOLEAN;
	v_error_msg TEXT;
	v_error_stack TEXT;
	AllEstablishments REFCURSOR;
	CurrentEstablishment RECORD;
	CalculatedServiceUserGroups TEXT;
	CalculatedCapacity INTEGER;
	CalculatedUtilisation INTEGER;
	CalculatedVacancies INTEGER;
	CalculatedStarters INTEGER;
	CalculatedLeavers INTEGER;
	CalculatedNumberOfStaff INTEGER;
BEGIN
	success := true;
	
	RAISE NOTICE 'localAuthorityReportEstablishment (%) from % to %', establishmentID, reportFrom, reportTo;
	
	OPEN AllEstablishments FOR
	SELECT
		"Establishment"."EstablishmentID",
		"NmdsID",
		"NameValue",
		"EmployerTypeValue",
		"EmployerTypeSavedAt",
		MainService.name AS "MainService",
		"MainServiceFKSavedAt",
		(select count(0) from cqc."EstablishmentServiceUsers" where "EstablishmentServiceUsers"."EstablishmentID" = "Establishment"."EstablishmentID") AS "ServiceUsersCount",
		"ServiceUsersSavedAt",
		"VacanciesValue",
		(select sum("Total") from cqc."EstablishmentJobs" where "EstablishmentJobs"."EstablishmentID" = "Establishment"."EstablishmentID" AND "EstablishmentJobs"."JobType" = 'Vacancies') AS "Vacancies",
		"VacanciesSavedAt",
		"StartersValue",
		(select sum("Total") from cqc."EstablishmentJobs" where "EstablishmentJobs"."EstablishmentID" = "Establishment"."EstablishmentID" AND "EstablishmentJobs"."JobType" = 'Starters') AS "Starters",
		"StartersSavedAt",
		"LeaversValue",
		(select sum("Total") from cqc."EstablishmentJobs" where "EstablishmentJobs"."EstablishmentID" = "Establishment"."EstablishmentID" AND "EstablishmentJobs"."JobType" = 'Leavers') AS "Leavers",
		"LeaversSavedAt",
		"NumberOfStaffValue",
		"NumberOfStaffSavedAt",
		"EstablishmentMainServicesWithCapacitiesVW"."CAPACITY" AS "Capacities",
		"EstablishmentMainServicesWithCapacitiesVW"."CAPACITY" AS "Utilisations",
		"CapacityServicesSavedAt",
		"NumberOfStaffValue",
		"NumberOfStaffSavedAt",
		updated,
		to_char(updated, 'DD/MM/YYYY') AS lastupdateddate
    FROM
      cqc."Establishment"
	  	LEFT JOIN cqc.services as MainService on "Establishment"."MainServiceFKValue" = MainService.id
		LEFT JOIN cqc."EstablishmentMainServicesWithCapacitiesVW" on "EstablishmentMainServicesWithCapacitiesVW"."EstablishmentID" = "Establishment"."EstablishmentID"
    WHERE
		("Establishment"."EstablishmentID" = establishmentID OR "Establishment"."ParentID" = establishmentID) AND
		"Archived" = false
	ORDER BY
		"EstablishmentID";
	
	LOOP
		FETCH AllEstablishments INTO CurrentEstablishment;
		EXIT WHEN NOT FOUND;
		
		RAISE NOTICE 'localAuthorityReportEstablishment: %, %, %, %, %, %',
			CurrentEstablishment."EstablishmentID",
			CurrentEstablishment."NmdsID",
			CurrentEstablishment."NameValue",
			CurrentEstablishment.lastupdateddate,
			CurrentEstablishment."EmployerTypeValue",
			CurrentEstablishment."MainService";
		RAISE NOTICE 'localAuthorityReportEstablishment: %, %',
			CurrentEstablishment."ServiceUsersCount",
			CurrentEstablishment."NumberOfStaffValue"
			;
		RAISE NOTICE 'localAuthorityReportEstablishment: %, %, %, %, %, %',
			CurrentEstablishment."VacanciesValue",
			CurrentEstablishment."Vacancies",
			CurrentEstablishment."StartersValue",
			CurrentEstablishment."Starters",
			CurrentEstablishment."LeaversValue",
			CurrentEstablishment."Leavers"
			;
		RAISE NOTICE 'localAuthorityReportEstablishment: %, %, %',
			CurrentEstablishment."Capacities",
			CurrentEstablishment."Utilisations",
			CurrentEstablishment."CapacityServicesSavedAt"
			;
			
			
		IF CurrentEstablishment."ServiceUsersSavedAt"::DATE >= reportFrom THEN
			IF CurrentEstablishment."ServiceUsersCount" > 0 THEN
				CalculatedServiceUserGroups := 'Completed';
			ELSE
				CalculatedServiceUserGroups := 'n/a';
			END IF;
		ELSE
			CalculatedServiceUserGroups := '-99';
		END IF;
		
		IF CurrentEstablishment."Capacities" IS NOT NULL AND CurrentEstablishment."CapacityServicesSavedAt"::DATE >= reportFrom THEN
			IF CurrentEstablishment."Capacities" = -1 THEN
				CalculatedCapacity := '0';
			ELSE
				CalculatedCapacity := CurrentEstablishment."Capacities";
			END IF;
			IF CurrentEstablishment."Utilisations" = -1 THEN
				CalculatedUtilisation := '0';
			ELSE
				CalculatedUtilisation := CurrentEstablishment."Utilisations";
			END IF;
		ELSIF CurrentEstablishment."Capacities" IS NULL THEN
			CalculatedCapacity := null;
			CalculatedUtilisation := null;
		ELSE
			CalculatedCapacity := -99;
			CalculatedUtilisation := -99;
		END IF;
		
		IF CurrentEstablishment."VacanciesSavedAt"::DATE >= reportFrom THEN
			IF CurrentEstablishment."VacanciesValue" = 'With Jobs' THEN
				CalculatedVacancies := CurrentEstablishment."Vacancies";
			ELSE
				CalculatedVacancies := 0;
			END IF;
		ELSE
			CalculatedVacancies := '-99';
		END IF;
		
		IF CurrentEstablishment."StartersSavedAt"::DATE >= reportFrom THEN
			IF CurrentEstablishment."StartersValue" = 'With Jobs' THEN
				CalculatedStarters := CurrentEstablishment."Starters";
			ELSE
				CalculatedStarters := 0;
			END IF;
		ELSE
			CalculatedStarters := '-99';
		END IF;
		
		IF CurrentEstablishment."LeaversSavedAt"::DATE >= reportFrom THEN
			IF CurrentEstablishment."LeaversValue" = 'With Jobs' THEN
				CalculatedLeavers := CurrentEstablishment."Leavers";
			ELSE
				CalculatedLeavers := 0;
			END IF;
		ELSE
			CalculatedLeavers := '-99';
		END IF;
		
		IF CurrentEstablishment."NumberOfStaffSavedAt"::DATE >= reportFrom THEN
			CalculatedNumberOfStaff := CurrentEstablishment."NumberOfStaffValue";
		ELSE
			CalculatedNumberOfStaff := '-99';
		END IF;
		
		insert into cqc."LocalAuthorityReportEstablishment" (
			"ReportFrom",
			"ReportTo",
			"EstablishmentFK",
			"WorkplaceFK",
			"WorkplaceName",
			"WorkplaceID",
			"LastUpdatedDate",
			"EstablishmentType",
			"MainService",
			"ServiceUserGroups",
			"CapacityOfMainService",
			"UtilisationOfMainService",
			"NumberOfVacancies",
			"NumberOfStarters",
			"NumberOfLeavers",
			"NumberOfStaffRecords",
			"WorkplaceComplete",
			"NumberOfIndividualStaffRecords",
			"PercentageOfStaffRecords",
			"NumberOfStaffRecordsNotAgency",
			"NumberOfCompleteStaffNotAgency",
			"PercentageOfCompleteStaffRecords",
			"NumberOfAgencyStaffRecords",
			"NumberOfCompleteAgencyStaffRecords",
			"PercentageOfCompleteAgencyStaffRecords"
		) values (
			reportFrom,
			reportTo,
			establishmentID,
			CurrentEstablishment."EstablishmentID",
			CurrentEstablishment."NameValue",
			CurrentEstablishment."NmdsID",
			CurrentEstablishment.updated::DATE,
			CurrentEstablishment."EmployerTypeValue",
			CurrentEstablishment."MainService",
			CalculatedServiceUserGroups,
			CalculatedCapacity,
			CalculatedUtilisation,
			CalculatedVacancies,
			CalculatedStarters,
			CalculatedLeavers,
			--CurrentEstablishment."NumberOfStaffValue",
			CalculatedNumberOfStaff,
			false,
			0,
			0::DECIMAL(4,1),
			0,
			0,
			0::DECIMAL(4,1),
			0,
			0,
			0::DECIMAL(4,1)
		);
		
	END LOOP;

	RETURN success;
	
	EXCEPTION WHEN OTHERS THEN
		GET STACKED DIAGNOSTICS v_error_stack=PG_EXCEPTION_CONTEXT, v_error_msg=MESSAGE_TEXT;
		RAISE WARNING 'localAuthorityReportWorker: %: %', v_error_msg, v_error_stack;
		RETURN false;

END; $$
LANGUAGE 'plpgsql';


DROP FUNCTION IF EXISTS cqc.localAuthorityReportWorker;
CREATE OR REPLACE FUNCTION cqc.localAuthorityReportWorker(establishmentID INTEGER, reportFrom DATE, reportTo DATE)
 RETURNS BOOLEAN 
AS $$
DECLARE
	success BOOLEAN;
	v_error_msg TEXT;
	v_error_stack TEXT;
BEGIN
	success := true;
	
	RAISE NOTICE 'localAuthorityReportWorker (%) from % to %', establishmentID, reportFrom, reportTo;
	
	RETURN success;
	
	EXCEPTION WHEN OTHERS THEN
		GET STACKED DIAGNOSTICS v_error_stack=PG_EXCEPTION_CONTEXT, v_error_msg=MESSAGE_TEXT;
		RAISE WARNING 'localAuthorityReportWorker: %: %', v_error_msg, v_error_stack;
		RETURN false;

END; $$
LANGUAGE 'plpgsql';


DROP FUNCTION IF EXISTS cqc.localAuthorityReport;
CREATE OR REPLACE FUNCTION cqc.localAuthorityReport(establishmentID INTEGER, reportFrom DATE, reportTo DATE)
 RETURNS BOOLEAN 
AS $$
DECLARE
	success BOOLEAN;
	v_error_msg TEXT;
	v_error_stack TEXT;
	establishmentReportStatus BOOLEAN;
	workerReportStatus BOOLEAN;
BEGIN
	success := true;
	
	RAISE NOTICE 'localAuthorityReport (%) from % to %', establishmentID, reportFrom, reportTo;
	
	-- first delete all Local Authority report data related to this establishment
	DELETE FROM cqc."LocalAuthorityReportWorker" WHERE "LocalAuthorityReportEstablishmentFK" in (SELECT "ID" FROM cqc."LocalAuthorityReportEstablishment" WHERE "EstablishmentFK"=establishmentID);
	DELETE FROM cqc."LocalAuthorityReportEstablishment" WHERE "EstablishmentFK"=establishmentID;

	SELECT cqc.localAuthorityReportEstablishment(establishmentID, reportFrom, reportTo) INTO establishmentReportStatus;
	SELECT cqc.localAuthorityReportWorker(establishmentID, reportFrom, reportTo) INTO workerReportStatus;
	
	
	IF NOT (establishmentReportStatus AND workerReportStatus) THEN
		success := false;
	END IF;
	
	RETURN success;
	
	EXCEPTION WHEN OTHERS THEN
		GET STACKED DIAGNOSTICS v_error_stack=PG_EXCEPTION_CONTEXT, v_error_msg=MESSAGE_TEXT;
		RAISE WARNING 'localAuthorityReport: %: %', v_error_msg, v_error_stack;
		RETURN false;

END; $$
LANGUAGE 'plpgsql';




--select cqc.localAuthorityReport(1::INTEGER, '2019-06-10'::DATE, '2019-08-10'::DATE);