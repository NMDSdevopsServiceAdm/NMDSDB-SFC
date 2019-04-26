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
  YearArrivedValue VARCHAR(5);
  YearArrivedYear INTEGER;
BEGIN
  RAISE NOTICE '... mapping easy properties (Approved Mental Health Worker, Gender, Disability, British Citizenship....): %(%) - %', _sfcid, _tribalId, _workerRecord;

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

  UPDATE
    cqc."Worker"
  SET
    "YearArrivedValue" = CASE WHEN YearArrivedValue IS NOT NULL THEN YearArrivedValue::cqc."WorkerYearArrived" ELSE NULL END,
    "YearArrivedYear" = CASE WHEN YearArrivedYear IS NOT NULL THEN YearArrivedYear ELSE NULL END,
    "YearArrivedSavedAt" = CASE WHEN YearArrivedValue IS NOT NULL THEN now() ELSE NULL END,
    "YearArrivedSavedBy" = CASE WHEN YearArrivedValue IS NOT NULL THEN 'migration' ELSE NULL END,
    "PostcodeValue" = CASE WHEN PostCode IS NOT NULL THEN PostCode ELSE NULL END,
    "PostcodeSavedAt" = CASE WHEN PostCode IS NOT NULL THEN now() ELSE NULL END,
    "PostcodeSavedBy" = CASE WHEN PostCode IS NOT NULL THEN 'migration' ELSE NULL END,
    "GenderValue" = CASE WHEN Gender IS NOT NULL THEN Gender::cqc."WorkerGender" ELSE NULL END,
    "GenderSavedAt" = CASE WHEN Gender IS NOT NULL THEN now() ELSE NULL END,
    "GenderSavedBy" = CASE WHEN Gender IS NOT NULL THEN 'migration' ELSE NULL END
  WHERE
    "ID" = _sfcid;
END;
$$ LANGUAGE plpgsql;