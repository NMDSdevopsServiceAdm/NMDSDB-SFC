CREATE OR REPLACE VIEW "cqc"."AllEstablishmentAndWorkersVW" AS
  select
    "Establishment"."EstablishmentID",
    "Establishment"."EstablishmentUID",
    "Establishment"."NmdsID",
    "Establishment"."Address",
    "Establishment"."LocationID",
    "Establishment"."PostCode",
    "Establishment"."IsRegulated",
    "Establishment"."Name",
    "Establishment"."MainServiceFKValue",
    "Establishment"."EmployerTypeValue",
    "Establishment"."NumberOfStaffValue",
    "Establishment"."OtherServicesSavedAt",
    "Establishment"."OtherServicesChangedAt",
    "Establishment"."CapacityServicesSavedAt",
    "Establishment"."CapacityServicesChangedAt",
    "Establishment"."ShareData",
    "Establishment"."ShareDataWithCQC",
    "Establishment"."ShareDataWithLA",
    "Establishment"."ShareWithLASavedAt",
    "Establishment"."ShareWithLAChangedAt",
    "Establishment"."Vacancies",
    "Establishment"."Starters",
    "Establishment"."Leavers",
    "Establishment".created AS "EstablishmentCreated",
    "Establishment".updated AS "EstablishmentUpdated",
    "Worker"."WorkerUID",
    "Worker"."EstablishmentFK",
    "Worker"."NameOrIdSavedAt",
    "Worker"."NameOrIdChangedAt",
    "Worker"."ContractValue",
    "Worker"."ContractSavedAt",
    "Worker"."ContractChangedAt",
    "Worker"."MainJobFKValue",
    "Worker"."MainJobFKSavedAt",
    "Worker"."MainJobFKChangedAt",
    "Worker"."ApprovedMentalHealthWorkerValue",
    "Worker"."ApprovedMentalHealthWorkerSavedAt",
    "Worker"."ApprovedMentalHealthWorkerChangedAt",
    "Worker"."MainJobStartDateValue",
    "Worker"."MainJobStartDateSavedAt",
    "Worker"."MainJobStartDateChangedAt",
    "Worker"."OtherJobsValue",
    "Worker"."OtherJobsSavedAt",
    "Worker"."OtherJobsChangedAt",
    CASE WHEN "Worker"."NationalInsuranceNumberValue" is not null THEN 'Yes' ELSE "Worker"."NationalInsuranceNumberValue" END AS "NationalInsuranceNumberValue",
    "Worker"."NationalInsuranceNumberSavedAt",
    "Worker"."NationalInsuranceNumberChangedAt",
    date_part('year', age(now(), "Worker"."DateOfBirthValue")) AS "DateOfBirthValue",
    "Worker"."DateOfBirthSavedAt",
    "Worker"."DateOfBirthChangedAt",
    LEFT("PostcodeValue", POSITION(' ' in "PostcodeValue")) AS "PostcodeValue",
    "Worker"."PostcodeSavedAt",
    "Worker"."PostcodeChangedAt",
    "Worker"."DisabilityValue",
    "Worker"."DisabilitySavedAt",
    "Worker"."DisabilityChangedAt",
    "Worker"."GenderValue",
    "Worker"."GenderSavedAt",
    "Worker"."GenderChangedAt",
    "Worker"."EthnicityFKValue",
    "Worker"."EthnicityFKSavedAt",
    "Worker"."EthnicityFKChangedAt",
    "Worker"."NationalityValue",
    "Worker"."NationalityOtherFK",
    "Worker"."NationalitySavedAt",
    "Worker"."NationalityChangedAt",
    "Worker"."CountryOfBirthValue",
    "Worker"."CountryOfBirthOtherFK",
    "Worker"."CountryOfBirthSavedAt",
    "Worker"."CountryOfBirthChangedAt",
    "Worker"."RecruitedFromValue",
    "Worker"."RecruitedFromOtherFK",
    "Worker"."RecruitedFromSavedAt",
    "Worker"."RecruitedFromChangedAt",
    "Worker"."BritishCitizenshipValue",
    "Worker"."BritishCitizenshipSavedAt",
    "Worker"."BritishCitizenshipChangedAt",
    "Worker"."YearArrivedValue",
    "Worker"."YearArrivedYear",
    "Worker"."YearArrivedSavedAt",
    "Worker"."YearArrivedChangedAt",
    "Worker"."SocialCareStartDateValue",
    "Worker"."SocialCareStartDateYear",
    "Worker"."SocialCareStartDateSavedAt",
    "Worker"."SocialCareStartDateChangedAt",
    "Worker"."DaysSickValue",
    "Worker"."DaysSickDays",
    "Worker"."DaysSickSavedAt",
    "Worker"."DaysSickChangedAt",
    "Worker"."ZeroHoursContractValue",
    "Worker"."ZeroHoursContractSavedAt",
    "Worker"."ZeroHoursContractChangedAt",
    "Worker"."WeeklyHoursAverageValue",
    "Worker"."WeeklyHoursAverageHours",
    "Worker"."WeeklyHoursAverageSavedAt",
    "Worker"."WeeklyHoursAverageChangedAt",
    "Worker"."WeeklyHoursContractedValue",
    "Worker"."WeeklyHoursContractedHours",
    "Worker"."WeeklyHoursContractedSavedAt",
    "Worker"."WeeklyHoursContractedChangedAt",
    "Worker"."AnnualHourlyPayValue",
    "Worker"."AnnualHourlyPayRate",
    "Worker"."AnnualHourlyPaySavedAt",
    "Worker"."AnnualHourlyPayChangedAt",
    "Worker"."CareCertificateValue",
    "Worker"."CareCertificateSavedAt",
    "Worker"."CareCertificateChangedAt",
    "Worker"."ApprenticeshipTrainingValue",
    "Worker"."ApprenticeshipTrainingSavedAt",
    "Worker"."ApprenticeshipTrainingChangedAt",
    "Worker"."QualificationInSocialCareValue",
    "Worker"."QualificationInSocialCareSavedAt",
    "Worker"."QualificationInSocialCareChangedAt",
    "Worker"."SocialCareQualificationFKValue",
    "Worker"."SocialCareQualificationFKSavedAt",
    "Worker"."SocialCareQualificationFKChangedAt",
    "Worker"."OtherQualificationsValue",
    "Worker"."OtherQualificationsSavedAt",
    "Worker"."OtherQualificationsChangedAt",
    "Worker"."HighestQualificationFKValue",
    "Worker"."HighestQualificationFKSavedAt",
    "Worker"."HighestQualificationFKChangedAt",
    "Worker"."CompletedValue",
    "Worker"."CompletedSavedAt",
    "Worker"."CompletedChangedAt",
    "Worker"."Archived",
    "Worker"."LeaveReasonFK",
    "Worker"."LeaveReasonOther",
    "Worker".created AS "WorkerCreated",
    "Worker".updated As "WorkerUpdated"
  from
    cqc."Establishment", cqc."Worker"
  where
    "Establishment"."EstablishmentID" = "Worker"."EstablishmentFK";
