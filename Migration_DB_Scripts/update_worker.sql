-- this is a set of functions/stored procedures for migrating a single worker
DROP FUNCTION IF EXISTS cqc.worker_other_jobs;
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
  SocialCareStartDateValue VARCHAR(5);
  SocialCareStartDateYear INTEGER;
  DaysSickValue VARCHAR(5);
  DaysSickDays INTEGER;
  IsBritshCitizen VARCHAR(10);
  ZeroHourContract VARCHAR(10);
  SocialCareQualification VARCHAR(10);
  NonSocialCareQualification VARCHAR(10);
  SocialCareQualificationFK INTEGER;
  NonSocialCareQualificationFK INTEGER;
  MainJobStartDate DATE;
  CareCertificate VARCHAR(50);
  Apprenticeship VARCHAR(10);
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

  SocialCareStartDateValue = NULL;
  SocialCareStartDateYear = NULL;
  IF (_workerRecord.startedinsector IS NOT NULL) THEN
    SocialCareStartDateValue = 'Yes';
    SocialCareStartDateYear = _workerRecord.startedinsector;
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


  IsBritshCitizen = NULL;
  IF (_workerRecord.isbritishcitizen=1) THEN
    IsBritshCitizen = 'Yes';
  ELSIF (_workerRecord.isbritishcitizen=0) THEN
    IsBritshCitizen = 'No';
  ELSIF (_workerRecord.isbritishcitizen=-1) THEN
    IsBritshCitizen = 'Don''t know';
  END IF;
  
  ZeroHourContract = NULL;
  IF (_workerRecord.ZeroHourContract=1) THEN
    ZeroHourContract = 'Yes';
  ELSIF (_workerRecord.ZeroHourContract=0) THEN
    ZeroHourContract = 'No';
  ELSIF (_workerRecord.ZeroHourContract=-1) THEN
    ZeroHourContract = 'Don''t know';
  END IF;

  SocialCareQualification = NULL;
  IF (_workerRecord.socialcarequalification=1) THEN
    SocialCareQualification = 'Yes';
  ELSIF (_workerRecord.socialcarequalification=0) THEN
    SocialCareQualification = 'No';
  ELSIF (_workerRecord.socialcarequalification=-1) THEN
    SocialCareQualification = 'Don''t know';
  END IF;

  SocialCareQualificationFK = NULL;
  IF (_workerRecord.socialcarequallevel IS NOT NULL) THEN
    IF (_workerRecord.socialcarequallevel = -1) THEN
      SocialCareQualificationFK = 10;
    ELSIF (_workerRecord.socialcarequallevel = 621) THEN
      SocialCareQualificationFK = 1;
    ELSIF (_workerRecord.socialcarequallevel = 622) THEN
      SocialCareQualificationFK = 2;
    ELSIF (_workerRecord.socialcarequallevel = 623) THEN
      SocialCareQualificationFK = 3;
    ELSIF (_workerRecord.socialcarequallevel = 624) THEN
      SocialCareQualificationFK = 4;
    ELSIF (_workerRecord.socialcarequallevel = 625) THEN
      SocialCareQualificationFK = 5;
    ELSIF (_workerRecord.socialcarequallevel = 626) THEN
      SocialCareQualificationFK = 6;
    ELSIF (_workerRecord.socialcarequallevel = 627) THEN
      SocialCareQualificationFK = 7;
    ELSIF (_workerRecord.socialcarequallevel = 628) THEN
      SocialCareQualificationFK = 8;
    ELSIF (_workerRecord.socialcarequallevel = 629) THEN
      SocialCareQualificationFK = 9;
    END IF;
  END IF;

  NonSocialCareQualification = NULL;
  IF (_workerRecord.nonsocialcarequalification=1) THEN
    NonSocialCareQualification = 'Yes';
  ELSIF (_workerRecord.nonsocialcarequalification=0) THEN
    NonSocialCareQualification = 'No';
  ELSIF (_workerRecord.nonsocialcarequalification=-1) THEN
    NonSocialCareQualification = 'Don''t know';
  END IF;

  NonSocialCareQualificationFK = NULL;
  IF (_workerRecord.nonsocialcarequallevel IS NOT NULL) THEN
    IF (_workerRecord.nonsocialcarequallevel = -1) THEN
      NonSocialCareQualificationFK = 10;
    ELSIF (_workerRecord.nonsocialcarequallevel = 621) THEN
      NonSocialCareQualificationFK = 1;
    ELSIF (_workerRecord.nonsocialcarequallevel = 622) THEN
      NonSocialCareQualificationFK = 2;
    ELSIF (_workerRecord.nonsocialcarequallevel = 623) THEN
      NonSocialCareQualificationFK = 3;
    ELSIF (_workerRecord.nonsocialcarequallevel = 624) THEN
      NonSocialCareQualificationFK = 4;
    ELSIF (_workerRecord.nonsocialcarequallevel = 625) THEN
      NonSocialCareQualificationFK = 5;
    ELSIF (_workerRecord.nonsocialcarequallevel = 626) THEN
      NonSocialCareQualificationFK = 6;
    ELSIF (_workerRecord.nonsocialcarequallevel = 627) THEN
      NonSocialCareQualificationFK = 7;
    ELSIF (_workerRecord.nonsocialcarequallevel = 628) THEN
      NonSocialCareQualificationFK = 8;
    ELSIF (_workerRecord.nonsocialcarequallevel = 629) THEN
      NonSocialCareQualificationFK = 9;
    END IF;
  END IF;

  MainJobStartDate = NULL;
  IF (_workerRecord.startdate IS NOT NULL) THEN
    MainJobStartDate = _workerRecord.startdate::DATE;
  END IF;

  CareCertificate = NULL;
  IF (_workerRecord.carecertificate IS NOT NULL) THEN
    IF (_workerRecord.carecertificate = 802) THEN
      CareCertificate = 'Yes, completed';
    ELSIF (_workerRecord.carecertificate = 803) THEN
      CareCertificate = 'No';
    ELSIF (_workerRecord.carecertificate = 804) THEN
      CareCertificate = 'Yes, in progress or partially completed';
    END IF;
  END IF;

  Apprenticeship = NULL;
  IF (_workerRecord.isapprentice=1) THEN
    Apprenticeship = 'Yes';
  ELSIF (_workerRecord.isapprentice=0) THEN
    Apprenticeship = 'No';
  ELSIF (_workerRecord.isapprentice=-1) THEN
    Apprenticeship = 'Don''t know';
  END IF;


  UPDATE
    cqc."Worker"
  SET
    "QualificationInSocialCareValue" = CASE WHEN IsBritshCitizen IS NOT NULL THEN IsBritshCitizen::cqc."WorkerQualificationInSocialCare" ELSE NULL END,
    "QualificationInSocialCareSavedAt" = CASE WHEN IsBritshCitizen IS NOT NULL THEN now() ELSE NULL END,
    "QualificationInSocialCareSavedBy" = CASE WHEN IsBritshCitizen IS NOT NULL THEN 'migration' ELSE NULL END,
    "SocialCareQualificationFKValue" = CASE WHEN SocialCareQualificationFK IS NOT NULL THEN SocialCareQualificationFK ELSE NULL END,
    "SocialCareQualificationFKSavedAt" = CASE WHEN SocialCareQualificationFK IS NOT NULL THEN now() ELSE NULL END,
    "SocialCareQualificationFKSavedBy" = CASE WHEN SocialCareQualificationFK IS NOT NULL THEN 'migration' ELSE NULL END,
    "OtherQualificationsValue" = CASE WHEN IsBritshCitizen IS NOT NULL THEN IsBritshCitizen::cqc."WorkerOtherQualifications" ELSE NULL END,
    "OtherQualificationsSavedAt" = CASE WHEN IsBritshCitizen IS NOT NULL THEN now() ELSE NULL END,
    "OtherQualificationsSavedBy" = CASE WHEN IsBritshCitizen IS NOT NULL THEN 'migration' ELSE NULL END,
    "HighestQualificationFKValue" = CASE WHEN NonSocialCareQualificationFK IS NOT NULL THEN NonSocialCareQualificationFK ELSE NULL END,
    "HighestQualificationFKSavedAt" = CASE WHEN NonSocialCareQualificationFK IS NOT NULL THEN now() ELSE NULL END,
    "HighestQualificationFKSavedBy" = CASE WHEN NonSocialCareQualificationFK IS NOT NULL THEN 'migration' ELSE NULL END,
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
    "SocialCareStartDateValue" = CASE WHEN SocialCareStartDateValue IS NOT NULL THEN SocialCareStartDateValue::cqc."WorkerSocialCareStartDate" ELSE NULL END,
    "SocialCareStartDateYear" = CASE WHEN SocialCareStartDateYear IS NOT NULL THEN SocialCareStartDateYear ELSE NULL END,
    "SocialCareStartDateSavedAt" = CASE WHEN SocialCareStartDateValue IS NOT NULL THEN now() ELSE NULL END,
    "SocialCareStartDateSavedBy" = CASE WHEN SocialCareStartDateValue IS NOT NULL THEN 'migration' ELSE NULL END,
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
    "GenderSavedBy" = CASE WHEN Gender IS NOT NULL THEN 'migration' ELSE NULL END,
    "MainJobStartDateValue" = CASE WHEN Gender IS NOT NULL THEN MainJobStartDate ELSE NULL END,
    "MainJobStartDateSavedAt" = CASE WHEN Gender IS NOT NULL THEN now() ELSE NULL END,
    "MainJobStartDateSavedBy" = CASE WHEN Gender IS NOT NULL THEN 'migration' ELSE NULL END,
    "CareCertificateValue" = CASE WHEN Gender IS NOT NULL THEN CareCertificate::cqc."WorkerCareCertificate" ELSE NULL END,
    "CareCertificateSavedAt" = CASE WHEN Gender IS NOT NULL THEN now() ELSE NULL END,
    "CareCertificateSavedBy" = CASE WHEN Gender IS NOT NULL THEN 'migration' ELSE NULL END,
    "ApprenticeshipTrainingValue" = CASE WHEN Apprenticeship IS NOT NULL THEN Apprenticeship::cqc."WorkerApprenticeshipTraining" ELSE NULL END,
    "ApprenticeshipTrainingSavedAt" = CASE WHEN Apprenticeship IS NOT NULL THEN now() ELSE NULL END,
    "ApprenticeshipTrainingSavedBy" = CASE WHEN Apprenticeship IS NOT NULL THEN 'migration' ELSE NULL END
  WHERE
    "ID" = _sfcid;
END;
$$ LANGUAGE plpgsql;