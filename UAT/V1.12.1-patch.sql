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
	CalculatedEmployerType TEXT;
	CalculatedServiceUserGroups TEXT;
	CalculatedCapacity INTEGER;
	CalculatedUtilisation INTEGER;
	CalculatedVacancies INTEGER;
	CalculatedStarters INTEGER;
	CalculatedLeavers INTEGER;
	CalculatedNumberOfStaff INTEGER;
	CalculatedWorkplaceComplete BOOLEAN := true;
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
		"MainServiceFKValue",
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
		to_char(updated, 'DD/MM/YYYY') AS lastupdateddate,
		"NumberOfIndividualStaffRecords",
		"NumberOfStaffRecordsNotAgency",
		"NumberOfAgencyStaffRecords"
    FROM
      cqc."Establishment"
	  	LEFT JOIN cqc.services as MainService on "Establishment"."MainServiceFKValue" = MainService.id
		LEFT JOIN cqc."EstablishmentMainServicesWithCapacitiesVW" on "EstablishmentMainServicesWithCapacitiesVW"."EstablishmentID" = "Establishment"."EstablishmentID"
		LEFT JOIN (
			SELECT
				"EstablishmentID",
				count("Worker"."ID") AS "NumberOfIndividualStaffRecords",
				count("Worker"."ID") FILTER (WHERE "Worker"."ContractValue" in ('Permanent', 'Temporary')) AS "NumberOfStaffRecordsNotAgency",
				count("Worker"."ID") FILTER (WHERE "Worker"."ContractValue" not in ('Permanent', 'Temporary')) AS "NumberOfAgencyStaffRecords"
			FROM
			  cqc."Establishment"
				LEFT JOIN cqc."Worker" on "Worker"."EstablishmentFK" = "Establishment"."EstablishmentID" AND "Worker"."Archived" = false
			WHERE
				("Establishment"."EstablishmentID" = establishmentID OR "Establishment"."ParentID" = establishmentID) AND
				"Establishment"."Archived" = false
			GROUP BY
				"EstablishmentID"
		) "EstablishmentWorkers" ON "EstablishmentWorkers"."EstablishmentID" = "Establishment"."EstablishmentID"
    WHERE
		("Establishment"."EstablishmentID" = establishmentID OR "Establishment"."ParentID" = establishmentID) AND
		"Archived" = false
	ORDER BY
		"EstablishmentID";
		
	LOOP
		FETCH AllEstablishments INTO CurrentEstablishment;
		EXIT WHEN NOT FOUND;
		
		RAISE NOTICE 'localAuthorityReportEstablishment: %, %, %, %, %, % %',
			CurrentEstablishment."EstablishmentID",
			CurrentEstablishment."NmdsID",
			CurrentEstablishment."NameValue",
			CurrentEstablishment.lastupdateddate,
			CurrentEstablishment."EmployerTypeValue",
			CurrentEstablishment."MainServiceFKValue",
			CurrentEstablishment."MainService";
		
		IF CurrentEstablishment."MainServiceFKValue" = 16 OR CurrentEstablishment."ServiceUsersSavedAt"::DATE >= reportFrom THEN
			-- 16 is Head ofice services
			IF CurrentEstablishment."MainServiceFKValue" <> 16 AND CurrentEstablishment."ServiceUsersCount" > 0 THEN
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
		
		IF CurrentEstablishment."EmployerTypeValue" IS NOT NULL THEN
			CalculatedEmployerType := CurrentEstablishment."EmployerTypeValue";
		ELSE
			CalculatedEmployerType := '-99';
		END IF;
		
		-- calculated the workplace "completed" flag is only true if:
		-- 1. The establishment type is one of Local Authority
		-- 2. The main service is known
		-- 3. The service user group is not -99 (n/a and completed are acceptable)
		-- 4. If the capacity of main service is not -99 (NULL is acceptable as is 0 or more)
		-- 5. If the utilisation of main service is not -99 (NULL is acceptable as is 0 or more)
		-- 6. If number of staff is not -99 (0 or more is acceptable)
		-- 7. If vacancies is not -99 (0 or more is acceptable)
		-- 8. If starters is not -99 (0 or more is acceptable)
		-- 9. If leavers is not -99 (0 or more is acceptable)
		
		IF SUBSTRING(CalculatedEmployerType::text from 1 for 15) <> 'Local Authority' THEN
			RAISE NOTICE 'employer type is NOT local authority: %', SUBSTRING(CalculatedEmployerType::text from 1 for 15);
			CalculatedWorkplaceComplete := false;
		END IF;
		
		IF CalculatedServiceUserGroups = '-99' THEN
			RAISE NOTICE 'calculated service groups is NOT valid: %', CalculatedServiceUserGroups;
			CalculatedWorkplaceComplete := false;
		END IF;
		
		IF CalculatedCapacity IS NOT NULL AND CalculatedCapacity = -99 THEN
			RAISE NOTICE 'calculated capacity is NOT valid: %', CalculatedCapacity;
			CalculatedWorkplaceComplete := false;
		END IF;
		
		IF CalculatedUtilisation IS NOT NULL AND CalculatedUtilisation = -99 THEN
			RAISE NOTICE 'calculated utilisation is NOT valid: %', CalculatedUtilisation;
			CalculatedWorkplaceComplete := false;
		END IF;
		
		IF CalculatedNumberOfStaff = -99 THEN
			RAISE NOTICE 'calculated number of staff is NOT valid: %', CalculatedNumberOfStaff;
			CalculatedWorkplaceComplete := false;
		END IF;
		
		IF CalculatedVacancies = -99 THEN
			RAISE NOTICE 'calculated vacancies is NOT valid: %', CalculatedVacancies;
			CalculatedWorkplaceComplete := false;
		END IF;
		IF CalculatedStarters = -99 THEN
			RAISE NOTICE 'calculated starters is NOT valid: %', CalculatedStarters;
			CalculatedWorkplaceComplete := false;
		END IF;
		IF CalculatedLeavers = -99 THEN
			RAISE NOTICE 'calculated leavers is NOT valid: %', CalculatedLeavers;
			CalculatedWorkplaceComplete := false;
		END IF;
		
		IF SUBSTRING(CalculatedEmployerType::text from 1 for 15) = 'Local Authority'
		   --CurrentEstablishment."MainService"
		   AND CalculatedServiceUserGroups <> '-99'
		   AND (CalculatedCapacity IS NULL OR CalculatedCapacity <> '-99' )
		   AND (CalculatedUtilisation IS NULL OR CalculatedUtilisation <> '-99')
		   AND CalculatedNumberOfStaff <> -99
		   AND CalculatedVacancies <> -99
		   AND CalculatedStarters <> -99
		   AND CalculatedLeavers <> -99
			THEN
		   CalculatedWorkplaceComplete := true;
		END IF;
		

		INSERT INTO cqc."LocalAuthorityReportEstablishment" (
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
		) VALUES (
			reportFrom,
			reportTo,
			establishmentID,
			CurrentEstablishment."EstablishmentID",
			CurrentEstablishment."NameValue",
			CurrentEstablishment."NmdsID",
			CurrentEstablishment.updated::DATE,
			CalculatedEmployerType,
			CurrentEstablishment."MainService",
			CalculatedServiceUserGroups,
			CalculatedCapacity,
			CalculatedUtilisation,
			CalculatedVacancies,
			CalculatedStarters,
			CalculatedLeavers,
			CalculatedNumberOfStaff,
			CalculatedWorkplaceComplete,
			CurrentEstablishment."NumberOfIndividualStaffRecords",
			(CurrentEstablishment."NumberOfIndividualStaffRecords" / CalculatedNumberOfStaff * 100)::DECIMAL(4,1),
			CurrentEstablishment."NumberOfStaffRecordsNotAgency",
			CurrentEstablishment."NumberOfStaffRecordsNotAgency",
			100::DECIMAL(4,1),
			CurrentEstablishment."NumberOfAgencyStaffRecords",
			CurrentEstablishment."NumberOfAgencyStaffRecords",
			100::DECIMAL(4,1)
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
	AllWorkers REFCURSOR;
	CurrentWorker RECORD;
	CalculatedGender TEXT;
	CalculatedDateOfBirth TEXT;
	CalculatedEthnicity TEXT;
	CalculatedMainJobRole TEXT;
	CalculatedEmploymentStatus TEXT;
	CalculatedSickDays TEXT;
	CalculatedPayInterval TEXT;
	CalculatedPayRate TEXT;
	CalculatedRelevantSocialCareQualification TEXT;
	CalculatedHighestSocialCareQualification TEXT;
	CalculatedNonSocialCareQualification TEXT;
	CalculatedContractedAverageHours TEXT;
	CalculatedStaffComplete BOOLEAN := true;
BEGIN
	success := true;
	
	RAISE NOTICE 'localAuthorityReportWorker (%) from % to %', establishmentID, reportFrom, reportTo;
	
	OPEN AllWorkers FOR
	SELECT
		"LocalAuthorityReportEstablishment"."ID" AS "LocalAuthorityReportEstablishmentFK",
		"LocalAuthorityReportEstablishment"."WorkplaceName",
		"LocalAuthorityReportEstablishment"."WorkplaceID",
		"Worker".updated,
		"Worker"."ID" AS "WorkerID",
		"Worker"."NameOrIdValue",
		"Worker"."GenderValue",
		"Worker"."GenderSavedAt",
		"Worker"."DateOfBirthValue",
		"Worker"."DateOfBirthSavedAt",
		"Ethnicity"."Ethnicity" AS "Ethnicity",
		"Worker"."EthnicityFKValue",
		"Worker"."EthnicityFKSavedAt",
		"Job"."JobName" AS "MainJobRole",
		"Worker"."MainJobFKValue",
		"Worker"."MainJobFKSavedAt",
		"ContractValue",
		"ContractSavedAt",
		"WeeklyHoursContractedValue",
		"WeeklyHoursContractedSavedAt",
		"WeeklyHoursAverageValue",
		"WeeklyHoursAverageSavedAt",
		"DaysSickValue",
		"DaysSickSavedAt",
		"AnnualHourlyPayValue",
		"AnnualHourlyPayRate",
		"AnnualHourlyPaySavedAt",
		"QualificationInSocialCareValue",
		"QualificationInSocialCareSavedAt",
		"Qualification"."Level" AS "QualificationInSocialCare",
		"SocialCareQualificationFKValue",
		"SocialCareQualificationFKSavedAt",
		"OtherQualificationsValue",
		"OtherQualificationsSavedAt"
	FROM cqc."Worker"
		INNER JOIN cqc."Establishment" on "Establishment"."EstablishmentID" = "Worker"."EstablishmentFK" AND "Establishment"."Archived" = false AND ("Establishment"."EstablishmentID" = establishmentID OR "Establishment"."ParentID" = establishmentID)
		INNER JOIN cqc."LocalAuthorityReportEstablishment" on "LocalAuthorityReportEstablishment"."WorkplaceFK" = "Establishment"."EstablishmentID"
		LEFT JOIN cqc."Ethnicity" on "Worker"."EthnicityFKValue" = "Ethnicity"."ID"
		LEFT JOIN cqc."Job" on "Worker"."MainJobFKValue" = "Job"."JobID"
		LEFT JOIN cqc."Qualification" on "Worker"."SocialCareQualificationFKValue" = "Qualification"."ID"
	WHERE
		"Worker"."Archived" = false;

	LOOP
		FETCH AllWorkers INTO CurrentWorker;
		EXIT WHEN NOT FOUND;
		
		IF CurrentWorker."GenderSavedAt"::DATE >= reportFrom THEN
			CalculatedGender := CurrentWorker."GenderValue"::TEXT;
		ELSE
			IF CurrentWorker."GenderSavedAt" IS NULL THEN
				CalculatedGender := 'Missing';
			ELSE
				CalculatedGender := 'Too Old';
			END IF;
		END IF;
		
		IF CurrentWorker."DateOfBirthSavedAt"::DATE >= reportFrom THEN
			CalculatedDateOfBirth := TO_CHAR(CurrentWorker."DateOfBirthValue", 'DD/MM/YYYY');
		ELSE
			IF CurrentWorker."DateOfBirthSavedAt" IS NULL THEN
				CalculatedDateOfBirth := 'Missing';
			ELSE
				CalculatedDateOfBirth := 'Too Old';
			END IF;
		END IF;

		IF CurrentWorker."EthnicityFKSavedAt"::DATE >= reportFrom THEN
			CalculatedEthnicity := CurrentWorker."Ethnicity";
		ELSE
			IF CurrentWorker."EthnicityFKSavedAt" IS NULL THEN
				CalculatedEthnicity := 'Missing';
			ELSE
				CalculatedEthnicity := 'Too Old';
			END IF;
		END IF;
		
		IF CurrentWorker."MainJobFKSavedAt"::DATE >= reportFrom THEN
			CalculatedMainJobRole := CurrentWorker."MainJobRole";
		ELSE
			IF CurrentWorker."MainJobFKSavedAt" IS NULL THEN
				CalculatedMainJobRole := 'Missing';
			ELSE
				CalculatedMainJobRole := 'Too Old';
			END IF;
		END IF;

		IF CurrentWorker."ContractSavedAt"::DATE >= reportFrom THEN
			CalculatedEmploymentStatus := CurrentWorker."MainJobRole";
		ELSE
			IF CurrentWorker."ContractSavedAt" IS NULL THEN
				CalculatedEmploymentStatus := 'Missing';
			ELSE
				CalculatedEmploymentStatus := 'Too Old';
			END IF;
		END IF;

		IF CurrentWorker."ContractSavedAt"::DATE >= reportFrom THEN
			CalculatedEmploymentStatus := CurrentWorker."MainJobRole";
		ELSE
			IF CurrentWorker."ContractSavedAt" IS NULL THEN
				CalculatedEmploymentStatus := 'Missing';
			ELSE
				CalculatedEmploymentStatus := 'Too Old';
			END IF;
		END IF;

		IF CurrentWorker."ContractSavedAt"::DATE >= reportFrom THEN
			CalculatedEmploymentStatus := CurrentWorker."ContractValue";
		ELSE
			IF CurrentWorker."ContractSavedAt" IS NULL THEN
				CalculatedEmploymentStatus := 'Missing';
			ELSE
				CalculatedEmploymentStatus := 'Too Old';
			END IF;
		END IF;
		
		IF CurrentWorker."DaysSickSavedAt"::DATE >= reportFrom THEN
			CalculatedSickDays := CurrentWorker."DaysSickValue";
		ELSE
			IF CurrentWorker."DaysSickSavedAt" IS NULL THEN
				CalculatedSickDays := 'Missing';
			ELSE
				CalculatedSickDays := 'Too Old';
			END IF;
		END IF;
		
		IF CurrentWorker."AnnualHourlyPaySavedAt"::DATE >= reportFrom THEN
			CalculatedPayInterval := CurrentWorker."AnnualHourlyPayValue";
			
			IF CurrentWorker."AnnualHourlyPayRate" IS NOT NULL THEN
				CalculatedPayRate := CurrentWorker."AnnualHourlyPayRate";
			ELSE
				CalculatedPayRate := 'n/a';
			END IF;
		ELSE
			IF CurrentWorker."AnnualHourlyPaySavedAt" IS NULL THEN
				CalculatedPayInterval := 'Missing';
				CalculatedPayRate := 'Missing';
			ELSE
				CalculatedPayInterval := 'Too Old';
				CalculatedPayRate := 'Too Old';
			END IF;
		END IF;
		
		
		IF CurrentWorker."QualificationInSocialCareSavedAt"::DATE >= reportFrom THEN
			CalculatedRelevantSocialCareQualification := CurrentWorker."QualificationInSocialCareValue";
			
			-- the highest social care qualification level is only relevant if knowing the qualification in social care
			IF CurrentWorker."QualificationInSocialCareValue" IS NOT NULL AND CurrentWorker."QualificationInSocialCareValue" = 'Yes' THEN
				IF CurrentWorker."SocialCareQualificationFKSavedAt"::DATE >= reportFrom THEN
					CalculatedHighestSocialCareQualification := CurrentWorker."QualificationInSocialCare";
				ELSE
					IF CurrentWorker."SocialCareQualificationFKSavedAt" IS NULL THEN
						CalculatedHighestSocialCareQualification := 'Missing';
					ELSE
						CalculatedHighestSocialCareQualification := 'Too Old';
					END IF;
				END IF;
			ELSE
				CalculatedHighestSocialCareQualification := 'n/a';
			END IF;
		ELSE
			IF CurrentWorker."QualificationInSocialCareSavedAt" IS NULL THEN
				CalculatedRelevantSocialCareQualification := 'Missing';
			ELSE
				CalculatedRelevantSocialCareQualification := 'Too Old';
			END IF;
		END IF;
		
		IF CurrentWorker."OtherQualificationsSavedAt"::DATE >= reportFrom THEN
			CalculatedNonSocialCareQualification := CurrentWorker."OtherQualificationsValue";			
		ELSE
			IF CurrentWorker."OtherQualificationsSavedAt" IS NULL THEN
				CalculatedNonSocialCareQualification := 'Missing';
			ELSE
				CalculatedNonSocialCareQualification := 'Too Old';
			END IF;
		END IF;
		
		-- if contract type is perm/temp contracted hours else average hours
		IF CurrentWorker."ContractValue" in ('Permanent', 'Temporary') THEN
			IF CurrentWorker."WeeklyHoursContractedSavedAt"::DATE >= reportFrom THEN
				CalculatedContractedAverageHours := CurrentWorker."WeeklyHoursContractedValue";			
			ELSE
				IF CurrentWorker."WeeklyHoursContractedSavedAt" IS NULL THEN
					CalculatedContractedAverageHours := 'Missing';
				ELSE
					CalculatedContractedAverageHours := 'Too Old';
				END IF;
			END IF;
		ELSE
			IF CurrentWorker."WeeklyHoursAverageSavedAt"::DATE >= reportFrom THEN
				CalculatedContractedAverageHours := CurrentWorker."WeeklyHoursAverageValue";			
			ELSE
				IF CurrentWorker."WeeklyHoursAverageSavedAt" IS NULL THEN
					CalculatedContractedAverageHours := 'Missing';
				ELSE
					CalculatedContractedAverageHours := 'Too Old';
				END IF;
			END IF;
		END IF;
		

		
		INSERT INTO cqc."LocalAuthorityReportWorker" (
			"LocalAuthorityReportEstablishmentFK",
			"WorkerFK",
			"LocalID",
			"WorkplaceName",
			"WorkplaceID",
			"Gender",
			"DateOfBirth",
			"Ethnicity",
			"MainJob",
			"EmploymentStatus",
			"ContractedAverageHours",
			"SickDays",
			"PayInterval",
			"RateOfPay",
			"RelevantSocialCareQualification",
			"HighestSocialCareQualification",
			"NonSocialCareQualification",
			"LastUpdated",
			"StaffRecordComplete"
		) VALUES (
			CurrentWorker."LocalAuthorityReportEstablishmentFK",
			CurrentWorker."WorkerID",
			CurrentWorker."NameOrIdValue",
			CurrentWorker."WorkplaceName",
			CurrentWorker."WorkplaceID",
			CalculatedGender,
			CalculatedDateOfBirth,
			CalculatedEthnicity,
			CalculatedMainJobRole,
			CalculatedEmploymentStatus,
			CalculatedContractedAverageHours,
			CalculatedSickDays,
			CalculatedPayInterval,
			CalculatedPayRate,
			CalculatedRelevantSocialCareQualification,
			CalculatedHighestSocialCareQualification,
			CalculatedNonSocialCareQualification,
			CurrentWorker.updated,
			CalculatedStaffComplete
		);
		
	END LOOP;
	
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