DROP VIEW IF EXISTS cqc."AnnS";
CREATE OR REPLACE VIEW cqc."AnnS" AS
 SELECT "Establishment"."EstablishmentID",
    "Establishment"."NameValue",
    "Establishment"."NmdsID",
    "Establishment"."Address",
    "Establishment"."LocationID",
    "Establishment"."PostCode",
    "Establishment"."IsRegulated",
    "Establishment"."MainServiceFKValue",
    "Establishment"."EmployerTypeValue",
    "Establishment"."NumberOfStaffValue",
    ( SELECT count(0) AS count
           FROM cqc."EstablishmentServices"
          WHERE "EstablishmentServices"."EstablishmentID" = "Establishment"."EstablishmentID") AS "OtherServices",
    ( SELECT count(0) AS count
           FROM cqc."EstablishmentCapacity"
          WHERE "EstablishmentCapacity"."EstablishmentID" = "Establishment"."EstablishmentID") AS "Capacities",
    ( SELECT count(0) AS count
           FROM cqc."EstablishmentServiceUsers"
          WHERE "EstablishmentServiceUsers"."EstablishmentID" = "Establishment"."EstablishmentID") AS "ServiceUsers",
    "Establishment"."ShareDataValue",
    "Establishment"."ShareDataWithCQC",
    "Establishment"."ShareDataWithLA",
    ( SELECT count(0) AS count
           FROM cqc."EstablishmentLocalAuthority"
          WHERE "EstablishmentLocalAuthority"."EstablishmentID" = "Establishment"."EstablishmentID") AS "LocalAuthorities",
    "Establishment"."VacanciesValue",
    "Establishment"."StartersValue",
    "Establishment"."LeaversValue",
    "Establishment".created AS "EstablishmentCreated",
    "Establishment".updated AS "EstablishmentUpdated",
    "Worker"."EstablishmentFK",
        CASE
            WHEN "Worker"."NameOrIdValue" IS NOT NULL THEN 'Name-ID Entered'::character varying
            ELSE "Worker"."NameOrIdValue"
        END AS "NameOrIdValue",
    "Worker"."CompletedValue",
    "Worker"."ContractValue",
    "Worker"."MainJobFKValue",
    "Worker"."ApprovedMentalHealthWorkerValue",
    "Worker"."MainJobStartDateValue",
    "Worker"."OtherJobsValue",
        CASE
            WHEN "Worker"."NationalInsuranceNumberValue" IS NOT NULL THEN 'Yes'::character varying
            ELSE "Worker"."NationalInsuranceNumberValue"
        END AS "NationalInsuranceNumberValue",
    date_part('year'::text, age(now(), "Worker"."DateOfBirthValue"::timestamp with time zone)) AS "DateOfBirthValue",
    "left"("Worker"."PostcodeValue"::text, "position"("Worker"."PostcodeValue"::text, ' '::text)) AS "PostcodeValue",
    "Worker"."DisabilityValue",
    "Worker"."GenderValue",
    "Worker"."EthnicityFKValue",
    "Worker"."NationalityValue",
    "Worker"."NationalityOtherFK",
    "Worker"."CountryOfBirthValue",
    "Worker"."CountryOfBirthOtherFK",
    "Worker"."RecruitedFromValue",
    "Worker"."RecruitedFromOtherFK",
    "Worker"."BritishCitizenshipValue",
    "Worker"."YearArrivedValue",
    "Worker"."YearArrivedYear",
    "Worker"."SocialCareStartDateValue",
    "Worker"."SocialCareStartDateYear",
    "Worker"."DaysSickValue",
    "Worker"."DaysSickDays",
    "Worker"."ZeroHoursContractValue",
    "Worker"."WeeklyHoursAverageValue",
    "Worker"."WeeklyHoursAverageHours",
    "Worker"."WeeklyHoursContractedValue",
    "Worker"."WeeklyHoursContractedHours",
    "Worker"."AnnualHourlyPayValue",
    "Worker"."AnnualHourlyPayRate",
    "Worker"."CareCertificateValue",
    "Worker"."ApprenticeshipTrainingValue",
    "Worker"."QualificationInSocialCareValue",
    "Worker"."SocialCareQualificationFKValue",
    "Worker"."OtherQualificationsValue",
    "Worker"."HighestQualificationFKValue",
    "Worker"."Archived",
    "Worker"."LeaveReasonFK",
    "Worker"."LeaveReasonOther",
    "Worker".created AS "WorkerCreated",
    "Worker".updated AS "WorkerUpdated"
   FROM cqc."Establishment"
    LEFT JOIN cqc."Worker" on "Establishment"."EstablishmentID" = "Worker"."EstablishmentFK"
  WHERE "Worker"."Archived" IS FALSE
  ORDER BY "Establishment"."EstablishmentID", "Worker"."WorkerUID";

DROP VIEW IF EXISTS cqc."EstablishmentMainServicesWithCapacitiesVW";
CREATE OR REPLACE VIEW cqc."EstablishmentMainServicesWithCapacitiesVW" AS
SELECT
	"EstablishmentID",
	CASE WHEN "CAPACITY1" is null THEN -1 ELSE "CAPACITY1" END,
	CASE WHEN "CAPACITY2" is null THEN -1 ELSE "CAPACITY2" END
FROM (
	SELECT
		"EstablishmentID",
		SUM("Answer") FILTER(WHERE "Sequence"=1) "CAPACITY1",
		SUM("Answer") FILTER(WHERE "Sequence"=2) "CAPACITY2"
	FROM (
		SELECT
			"AllEstablishmentCapacityQuestions"."EstablishmentID",
			"AllEstablishmentCapacityQuestions"."ServiceCapacityID",
			"AllEstablishmentCapacityQuestions"."Sequence",
			"AllEstablishmentCapacityQuestions"."Question",
			"AllEstablishmentCapacities"."Answer"
		FROM
			(
				SELECT
					"Establishment"."EstablishmentID",
					"ServicesCapacity"."ServiceCapacityID",
					"ServicesCapacity"."Sequence",
					"ServicesCapacity"."Question"
				FROM cqc."ServicesCapacity", cqc."Establishment"
					INNER JOIN cqc.services on "Establishment"."MainServiceFKValue" = services.id
					LEFT JOIN cqc."EstablishmentCapacity" on "Establishment"."EstablishmentID" = "EstablishmentCapacity"."EstablishmentID"
				WHERE "ServicesCapacity"."ServiceID" = services.id
				  AND services.id in (SELECT DISTINCT "ServiceID" FROM cqc."ServicesCapacity" GROUP BY "ServiceID" HAVING COUNT(0) > 1)
				GROUP BY "Establishment"."EstablishmentID", "ServicesCapacity"."ServiceCapacityID", "ServicesCapacity"."Sequence"
				ORDER BY "Establishment"."EstablishmentID", "ServicesCapacity"."Sequence"
			) "AllEstablishmentCapacityQuestions"
				LEFT JOIN (
					SELECT "EstablishmentID", "EstablishmentCapacity"."ServiceCapacityID", "Answer"
					FROM cqc."EstablishmentCapacity"
						INNER JOIN cqc."ServicesCapacity" on "ServicesCapacity"."ServiceCapacityID" = "EstablishmentCapacity"."ServiceCapacityID"
				) "AllEstablishmentCapacities"
					ON "AllEstablishmentCapacities"."ServiceCapacityID" = "AllEstablishmentCapacityQuestions"."ServiceCapacityID" AND
					   "AllEstablishmentCapacities"."EstablishmentID" = "AllEstablishmentCapacityQuestions"."EstablishmentID"
		ORDER BY "AllEstablishmentCapacityQuestions"."EstablishmentID", "AllEstablishmentCapacityQuestions"."Sequence") AS "EstablishmentMainServicesWithCapacities"
	GROUP BY "EstablishmentID") AS "EstablishmentMainServicesWithCapacitiesTwo"


select "AnnS".*, "CAPACITY1", "CAPACITY2"
from cqc."AnnS"
  left join cqc."EstablishmentMainServicesWithCapacitiesVW" on "EstablishmentMainServicesWithCapacitiesVW"."EstablishmentID" = "AnnS"."EstablishmentID"