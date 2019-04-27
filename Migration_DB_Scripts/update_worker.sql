-- this is a set of functions/stored procedures for migrating a single worker

CREATE OR REPLACE FUNCTION cqc.worker_other_jobs(tribalId INTEGER, sfcid INTEGER)
  RETURNS void AS $$
DECLARE
BEGIN
  RAISE NOTICE '... mapping other jobs';
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS cqc.worker_easy_properties;
CREATE OR REPLACE FUNCTION cqc.worker_easy_properties(_tribalId INTEGER, _sfcid INTEGER, _workerRecord RECORD)
  RETURNS void AS $$
DECLARE
  PostCode VARCHAR(20);
  Gender VARCHAR(10);
  Disability VARCHAR(10);
  YearArrivedValue VARCHAR(5);
  YearArrivedYear INTEGER;
  DaysSickValue VARCHAR(5);
  DaysSickDays INTEGER;
  IsBritshCitizen VARCHAR(10);
  ZeroHourContract VARCHAR(10);
  SocialCareQualification VARCHAR(10);
  NonSocialCareQualification VARCHAR(10);
BEGIN
  RAISE NOTICE '... mapping easy properties (Gender, Disability, British Citizenship....)';

  -- map postcode - a straight map
  PostCode = NULL;
  IF (_workerRecord.postcode IS NOT NULL) THEN
    PostCode = _workerRecord.postcode;
  END IF;

  YearArrivedValue = NULL;
  YearArrivedYear = NULL;
  IF (_workerRecord.yearofentry IS NOT NULL) THEN
    IF (_workerRecord.yearofentry = -1) THEN
      YearArrivedValue = 'No';
    ELSIF (_workerRecord.yearofentry > 1000) THEN
      YearArrivedValue = 'Yes';
      YearArrivedYear = _workerRecord.yearofentry;
    END IF;
  END IF;

  DaysSickValue = NULL;
  DaysSickDays = NULL;
  IF (_workerRecord.dayssick IS NOT NULL) THEN
    IF (_workerRecord.dayssick = -1) THEN
      DaysSickValue = 'No';
    ELSIF (_workerRecord.dayssick > -1) THEN
      DaysSickValue = 'Yes';
      DaysSickDays = _workerRecord.dayssick;
    END IF;
  END IF;
  
  Disability = NULL;
  IF (_workerRecord.disabled=0) THEN
    Disability = 'No';
  ELSIF (_workerRecord.disabled=1) THEN
    Disability = 'Yes';
  END IF;

  Gender = NULL;
  IF (_workerRecord.gender=1) THEN
    Gender = 'Male';
  ELSIF (_workerRecord.gender=2) THEN
    Gender = 'Female';
  ELSIF (_workerRecord.gender=0) THEN
    Gender = 'Unknown';
  ELSIF (_workerRecord.gender=3) THEN
    Gender = 'Other';
  END IF;


  IsBritshCitizen = null;
  IF (_workerRecord.isbritishcitizen=1) THEN
    IsBritshCitizen = 'Yes';
  ELSIF (_workerRecord.isbritishcitizen=0) THEN
    IsBritshCitizen = 'No';
  ELSIF (_workerRecord.isbritishcitizen=-1) THEN
    IsBritshCitizen = 'Don''t know';
  END IF;
  
  ZeroHourContract = null;
  IF (_workerRecord.ZeroHourContract=1) THEN
    ZeroHourContract = 'Yes';
  ELSIF (_workerRecord.ZeroHourContract=0) THEN
    ZeroHourContract = 'No';
  ELSIF (_workerRecord.ZeroHourContract=-1) THEN
    ZeroHourContract = 'Don''t know';
  END IF;

  SocialCareQualification = null;
  IF (_workerRecord.socialcarequalification=1) THEN
    SocialCareQualification = 'Yes';
  ELSIF (_workerRecord.socialcarequalification=0) THEN
    SocialCareQualification = 'No';
  ELSIF (_workerRecord.socialcarequalification=-1) THEN
    SocialCareQualification = 'Don''t know';
  END IF;

  NonSocialCareQualification = null;
  IF (_workerRecord.nonsocialcarequalification=1) THEN
    NonSocialCareQualification = 'Yes';
  ELSIF (_workerRecord.nonsocialcarequalification=0) THEN
    NonSocialCareQualification = 'No';
  ELSIF (_workerRecord.nonsocialcarequalification=-1) THEN
    NonSocialCareQualification = 'Don''t know';
  END IF;


  UPDATE
    cqc."Worker"
  SET
    "QualificationInSocialCareValue" = CASE WHEN IsBritshCitizen IS NOT NULL THEN IsBritshCitizen::cqc."WorkerQualificationInSocialCare" ELSE NULL END,
    "QualificationInSocialCareSavedAt" = CASE WHEN IsBritshCitizen IS NOT NULL THEN now() ELSE NULL END,
    "QualificationInSocialCareSavedBy" = CASE WHEN IsBritshCitizen IS NOT NULL THEN 'migration' ELSE NULL END,
    "OtherQualificationsValue" = CASE WHEN IsBritshCitizen IS NOT NULL THEN IsBritshCitizen::cqc."WorkerOtherQualifications" ELSE NULL END,
    "OtherQualificationsSavedAt" = CASE WHEN IsBritshCitizen IS NOT NULL THEN now() ELSE NULL END,
    "OtherQualificationsSavedBy" = CASE WHEN IsBritshCitizen IS NOT NULL THEN 'migration' ELSE NULL END,
    "ZeroHoursContractValue" = CASE WHEN IsBritshCitizen IS NOT NULL THEN IsBritshCitizen::cqc."WorkerZeroHoursContract" ELSE NULL END,
    "ZeroHoursContractSavedAt" = CASE WHEN IsBritshCitizen IS NOT NULL THEN now() ELSE NULL END,
    "ZeroHoursContractSavedBy" = CASE WHEN IsBritshCitizen IS NOT NULL THEN 'migration' ELSE NULL END,
    "BritishCitizenshipValue" = CASE WHEN IsBritshCitizen IS NOT NULL THEN IsBritshCitizen::cqc."WorkerBritishCitizenship" ELSE NULL END,
    "BritishCitizenshipSavedAt" = CASE WHEN IsBritshCitizen IS NOT NULL THEN now() ELSE NULL END,
    "BritishCitizenshipSavedBy" = CASE WHEN IsBritshCitizen IS NOT NULL THEN 'migration' ELSE NULL END,
    "YearArrivedValue" = CASE WHEN YearArrivedValue IS NOT NULL THEN YearArrivedValue::cqc."WorkerYearArrived" ELSE NULL END,
    "YearArrivedYear" = CASE WHEN YearArrivedYear IS NOT NULL THEN YearArrivedYear ELSE NULL END,
    "YearArrivedSavedAt" = CASE WHEN YearArrivedValue IS NOT NULL THEN now() ELSE NULL END,
    "YearArrivedSavedBy" = CASE WHEN YearArrivedValue IS NOT NULL THEN 'migration' ELSE NULL END,
    "DaysSickValue" = CASE WHEN DaysSickValue IS NOT NULL THEN DaysSickValue::cqc."WorkerDaysSick" ELSE NULL END,
    "DaysSickDays" = CASE WHEN DaysSickDays IS NOT NULL THEN DaysSickDays ELSE NULL END,
    "DaysSickSavedAt" = CASE WHEN DaysSickValue IS NOT NULL THEN now() ELSE NULL END,
    "DaysSickSavedBy" = CASE WHEN DaysSickValue IS NOT NULL THEN 'migration' ELSE NULL END,
    "PostcodeValue" = CASE WHEN PostCode IS NOT NULL THEN PostCode ELSE NULL END,
    "PostcodeSavedAt" = CASE WHEN PostCode IS NOT NULL THEN now() ELSE NULL END,
    "PostcodeSavedBy" = CASE WHEN PostCode IS NOT NULL THEN 'migration' ELSE NULL END,
    "DisabilityValue" = CASE WHEN Disability IS NOT NULL THEN Disability::cqc."WorkerDisability" ELSE NULL END,
    "DisabilitySavedAt" = CASE WHEN Disability IS NOT NULL THEN now() ELSE NULL END,
    "DisabilitySavedBy" = CASE WHEN Disability IS NOT NULL THEN 'migration' ELSE NULL END,
    "GenderValue" = CASE WHEN Gender IS NOT NULL THEN Gender::cqc."WorkerGender" ELSE NULL END,
    "GenderSavedAt" = CASE WHEN Gender IS NOT NULL THEN now() ELSE NULL END,
    "GenderSavedBy" = CASE WHEN Gender IS NOT NULL THEN 'migration' ELSE NULL END
  WHERE
    "ID" = _sfcid;
END;
$$ LANGUAGE plpgsql;