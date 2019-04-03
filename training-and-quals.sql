-- Qualifications Reference Data
CREATE TABLE IF NOT EXISTS cqc."Qualifications" (
	"ID" INTEGER NOT NULL PRIMARY KEY,
	"Seq" INTEGER NOT NULL, 	-- this is the order in which the Qualification will appear without impacting on primary key (existing foreign keys)
	"Group" TEXT NOT NULL,
	"Title" TEXT NOT NULL,
  "Code" SMALLINT NOT NULL,
  "From" DATE NULL,         -- Just date component, no time.
  "Until" DATE NULL,        -- Just date component, no time.
  "Level" SMALLINT NULL,
  "MultipleLevel" BOOLEAN NOT NULL,
  "RelevantToSocialCare" BOOLEAN NOT NULL,
  "AnalysisFileCode" VARCHAR(20) NOT NULL
);

INSERT INTO cqc."Qualifications" ("ID", "Seq", "Group", "Title", "Code", "From", "Until", "Level", "MultipleLevel", "RelevantToSocialCare", "AnalysisFileCode") VALUES 
(1, 1, 'Award','Advanced Award in Social Work (AASW)', 20, NULL, NULL,7, 'No', 'Yes', 'QL20ACHQ4'),
(2, 2, 'Award','Award in Stroke Awareness', 86, '2011-01-01', NULL,2, 'No', 'Yes', 'QL86ACHQ2'),
(3, 3, 'Award','Award in Supporting Individuals on the Autistic Spectrum', 107, NULL, NULL,3, 'No', 'Yes', 'QL107ACHQ3'),
(4, 4, 'Award','Awareness of Dementia', 48, '2010-09-01', NULL,2, 'Yes', 'Yes', 'QL48ACHQ2'),
(5, 5, 'Award','Awareness of Dementia', 49, '2010-09-01', NULL,3, 'Yes', 'Yes', 'QL49ACHQ3'),
(6, 6, 'Award','Awareness of End of Life Care', 99, NULL, NULL,2, 'Yes', 'Yes', 'QL99ACHQ2'),
(7, 7, 'Award','Awareness of End of Life Care', 100, NULL, NULL,3, 'Yes', 'Yes', 'QL100ACHQ3'),
(8, 8, 'Award','Awareness of the Mental Capacity Act 2005', 103, '2013-01-01', NULL,3, 'No', 'Yes', 'QL103ACHQ3'),
(9, 9, 'Award','Basic awareness of Diabetes', 88, '2011-01-01', NULL,2, 'No', 'Yes', 'QL88ACHQ2'),
(10, 10, 'Award','Emergency First Aid at Work', 52, '2008-09-01', NULL,2, 'No', 'No', 'QL52ACHQ2'),
(11, 11, 'Award','Employment Responsibilities and Rights in Health, Social Care, Children and Young People''s Settings', 96, '2010-01-01', NULL,2, 'No', 'Yes', 'QL96ACHQ2'),
(12, 12, 'Award','Food safety in health and social care and early years and childcare settings', 90, '2011-01-01', NULL,2, 'No', 'Yes', 'QL90ACHQ2'),
(13, 13, 'Award','Introduction to Health, Social Care and Children''s and Young People''s Settings', 92, '2011-01-01', NULL,1, 'No', 'Yes', 'QL92ACHQ1'),
(14, 14, 'Award','Mental Health Social Work Award (MHSWA)', 22, NULL, NULL,4, 'No', 'Yes', 'QL22ACHQ4'),
(15, 15, 'Award','Mentor Award', 25, NULL, NULL,4, 'No', 'No', 'QL25ACHQ4'),
(16, 16, 'Award','Post-Qualifying Award in Social Work (PQSW) Part 1', 19, NULL, NULL,4, 'No', 'Yes', 'QL19ACHQ4'),
(17, 17, 'Award','Preparing to Work in Adult Social Care', 85, '2011-01-01', NULL,1, 'No', 'Yes', 'QL85ACHQ1'),
(18, 18, 'Award','Promoting food safety and nutrition in health and social care or early years and childcare settings', 91, '2011-01-01', NULL,2, 'No', 'Yes', 'QL91ACHQ2'),
(19, 19, 'Award','Providing an Induction in to Assisting & Moving Individuals in Adult Social Care', 74, '2011-01-01', NULL,3, 'No', 'Yes', 'QL74ACHQ3'),
(20, 20, 'Award','Supporting Activity Provision in Social Care', 41, NULL, NULL,2, 'No', 'Yes', 'QL41ACHQ2'),
(21, 21, 'Award','Supporting Individuals with Learning Disabilities', 95, '2011-10-01', NULL,2, 'Yes', 'Yes', 'QL94ACHQ2'),
(22, 22, 'Award','Supporting Individuals with Learning Disabilities', 94, '2011-10-01', NULL,3, 'Yes', 'Yes', 'QL95ACHQ3'),
(23, 23, 'Award','Understanding Working with People with Mental Health Issues', 72, '2011-01-01', NULL,2, 'No', 'Yes', 'QL72ACHQ2'),
(24, 24, 'Award','Any Learning Disabled Awards Framework (LDAF) award', 8, NULL, '2010-07-31',NULL, 'No', 'Yes', 'QL08ACHQ'),
(25, 25, 'Award','Other management awards', 12, NULL, NULL,3, 'No', 'No', 'QL12ACHQ3'),
(26, 26, 'Award','Other Post-Qualifying Social Work Award', 26, NULL, NULL,4, 'No', 'Yes', 'QL26ACHQ4'),
(27, 27, 'Award','Any other social care relevant award', 111, NULL, NULL,NULL, 'No', 'No', 'QL111ACHQ'),
(28, 28, 'Award','Any other non-social care relevant award', 112, NULL, NULL,NULL, 'No', 'Yes', 'QL112ACHQ'),
(30, 30, 'Certificate','Activity Provision in Social Care', 42, NULL, NULL,3, 'No', 'Yes', 'QL42ACHQ3'),
(31, 31, 'Certificate','Adult Care', 110, NULL, NULL,4, 'No', 'Yes', 'QL110ACHQ4'),
(32, 32, 'Certificate','Assisting and Moving Individuals in Social Care', 73, '2011-01-01', NULL,2, 'No', 'Yes', 'QL73ACHQ2'),
(33, 33, 'Certificate','Certificate in Assisting and Moving Individuals for a Social care Setting', 119, NULL, NULL,2, 'No', 'Yes', 'QL119ACHQ2'),
(34, 34, 'Certificate','Certificate in Autism Support', 121, NULL, NULL,3, 'No', 'Yes', 'QL121ACHQ3'),
(35, 35, 'Certificate','Certificate in Awareness of Mental Health Problems', 136, NULL, NULL,2, 'No', 'Yes', 'QL136ACHQ2'),
(36, 36, 'Certificate','Certificate in Clinical Skills', 123, NULL, NULL,2, 'Yes', 'Yes', 'QL123ACHQ2'),
(37, 37, 'Certificate','Certificate in Clinical Skills', 124, NULL, NULL,3, 'Yes', 'Yes', 'QL124ACHQ3'),
(38, 38, 'Certificate','Certificate in Fundamental Knowledge in Commissioning for Wellbeing', 125, NULL, NULL,5, 'No', 'Yes', 'QL125ACHQ5'),
(39, 39, 'Certificate','Certificate in Independent Advocacy', 118, NULL, NULL,3, 'No', 'Yes', 'QL118ACHQ3'),
(40, 40, 'Certificate','Certificate in Mental Health Awareness', 137, NULL, NULL,2, 'No', 'Yes', 'QL137ACHQ2'),
(41, 41, 'Certificate','Certificate in Principles of Leadership and Management in Adult Care', 131, NULL, NULL,4, 'No', 'Yes', 'QL131ACHQ4'),
(42, 42, 'Certificate','Certificate in Principles of Safe Handling of Medication in Health and Social Care (RQF)', 134, NULL, NULL,2, 'No', 'Yes', 'QL134ACHQ2'),
(43, 43, 'Certificate','Certificate in Principles of Working with People with Mental Health Needs', 138, NULL, NULL,2, 'No', 'Yes', 'QL138ACHQ2'),
(44, 44, 'Certificate','Certificate in Social Prescribing', 143, NULL, NULL,3, 'No', 'Yes', 'QL143ACHQ3'),
(45, 45, 'Certificate','Certificate in Stroke Care Management', 87, '2011-01-01', NULL,3, 'No', 'Yes', 'QL87ACHQ3'),
(47, 47, 'Certificate','Certificate in Supporting Individuals on the Autistic Spectrum', 108, NULL, NULL,3, 'No', 'Yes', 'QL108ACHQ3'),
(48, 48, 'Certificate','Certificate in Understand Mental Health', 141, NULL, NULL,3, 'No', 'Yes', 'QL141ACHQ3'),
(49, 49, 'Certificate','Certificate in Understanding Autism', 120, NULL, NULL,2, 'Yes', 'Yes', 'QL120ACHQ2'),
(50, 50, 'Certificate','Certificate in Understanding Autism', 122, NULL, NULL,3, 'Yes', 'Yes', 'QL122ACHQ3'),
(51, 51, 'Certificate','Certificate in Understanding Care and Management of Diabetes', 126, NULL, NULL,2, 'Yes', 'Yes', 'QL126ACHQ2'),
(52, 52, 'Certificate','Certificate in Understanding Care and Management of Diabetes', 128, NULL, NULL,3, 'Yes', 'Yes', 'QL128ACHQ3'),
(53, 53, 'Certificate','Certificate in Understanding Diabetes', 127, NULL, NULL,2, 'No', 'Yes', 'QL127ACHQ2'),
(54, 54, 'Certificate','Certificate in Understanding Mental Health Care', 142, NULL, NULL,3, 'No', 'Yes', 'QL142ACHQ3'),
(55, 55, 'Certificate','Certificate in Understanding the Safe Handling of Medication', 133, NULL, NULL,2, 'No', 'Yes', 'QL133ACHQ2'),
(56, 56, 'Certificate','Certificate in Understanding the Safe Handling of Medication in Health and Social Care', 135, NULL, NULL,2, 'No', 'Yes', 'QL135ACHQ2'),
(57, 57, 'Certificate','Certificate in Understanding Working in Mental Health', 139, NULL, NULL,2, 'No', 'Yes', 'QL139ACHQ2'),
(58, 58, 'Certificate','Certificate in Understanding Working with People with Mental Health Needs', 140, NULL, NULL,2, 'No', 'Yes', 'QL140ACHQ2'),
(59, 59, 'Certificate','Delivering Chair-Based Exercise with Frailer Older Adults and Adults with Disabilities in Care and Community Settings', 98, '2012-01-01', NULL,2, 'No', 'Yes', 'QL98ACHQ2'),
(60, 60, 'Certificate','Dementia Care', 50, '2010-09-01', NULL,2, 'Yes', 'Yes', 'QL50ACHQ2'),
(61, 61, 'Certificate','Dementia Care', 51, '2010-09-01', NULL,3, 'Yes', 'Yes', 'QL51ACHQ3'),
(62, 62, 'Certificate','Introduction to Health, Social Care and Children''s and Young People''s Settings', 93, '2011-01-01', NULL,1, 'No', 'Yes', 'QL93ACHQ1'),
(63, 63, 'Certificate','Leading and Managing Services to Support End of Life and Significant Life Events', 102, NULL, NULL,5, 'No', 'Yes', 'QL102ACHQ5'),
(64, 64, 'Certificate','Preparing to work in Adult Social Care', 76, '2011-01-01', NULL,2, 'Yes', 'Yes', 'QL76ACHQ2'),
(65, 65, 'Certificate','Preparing to work in Adult Social Care', 77, '2011-01-01', NULL,3, 'Yes', 'Yes', 'QL77ACHQ3'),
(66, 66, 'Certificate','Supporting Individuals with Learning Disabilities', 67, '2011-01-01', NULL,2, 'Yes', 'Yes', 'QL67ACHQ2'),
(67, 67, 'Certificate','Supporting Individuals with Learning Disabilities', 68, '2011-01-01', NULL,3, 'Yes', 'Yes', 'QL68ACHQ3'),
(68, 68, 'Certificate','Working in End of Life care', 101, NULL, NULL,3, 'No', 'Yes', 'QL101ACHQ3'),
(69, 69, 'Certificate','Working with individuals with Diabetes', 89, '2011-01-01', NULL,3, 'No', 'Yes', 'QL89ACHQ3'),
(71, 71, 'Degree','Combined Nursing & Social Work degree', 18, NULL, NULL,6, 'No', 'Yes', 'QL18ACHQ4'),
(72, 72, 'Degree','Social Work degree (UK)', 16, NULL, NULL,6, 'No', 'Yes', 'QL16ACHQ4'),
(74, 74, 'Diploma','Adult Care', 109, NULL, NULL,4, 'No', 'Yes', 'QL109ACHQ4'),
(75, 75, 'Diploma','Approved Mental Health Practitioner', 104, '2000-01-01', NULL,4, 'No', 'Yes', 'QL104ACHQ4'),
(76, 76, 'Diploma','Approved Social Worker', 105, '2000-01-01', NULL,4, 'No', 'Yes', 'QL105ACHQ4'),
(77, 77, 'Diploma','Diploma in Care (RQF)', 129, NULL, NULL,2, 'Yes', 'Yes', 'QL129ACHQ2'),
(78, 78, 'Diploma','Diploma in Care (RQF)', 130, NULL, NULL,3, 'Yes', 'Yes', 'QL130ACHQ3'),
(79, 79, 'Diploma','Diploma in Leadership and Management for Adult Care (RQF)', 132, NULL, NULL,5, 'No', 'Yes', 'QL132ACHQ5'),
(80, 80, 'Diploma','Health and Social Care - Generic Pathway', 53, '2011-01-01', NULL,2, 'Yes', 'Yes', 'QL53ACHQ2'),
(81, 81, 'Diploma','Health and Social Care - Generic Pathway', 54, '2011-01-01', NULL,3, 'Yes', 'Yes', 'QL54ACHQ3'),
(82, 82, 'Diploma','Health and Social Care - Dementia', 55, '2011-01-01', NULL,2, 'Yes', 'Yes', 'QL55ACHQ2'),
(83, 83, 'Diploma','Health and Social Care - Dementia', 56, '2011-01-01', NULL,3, 'Yes', 'Yes', 'QL56ACHQ3'),
(84, 84, 'Diploma','Health and Social Care - Learning Disabilities', 57, '2011-01-01', NULL,2, 'Yes', 'Yes', 'QL57ACHQ2'),
(85, 85, 'Diploma','Health and Social Care - Learning Disabilities', 58, '2011-01-01', NULL,3, 'Yes', 'Yes', 'QL58ACHQ3'),
(86, 86, 'Diploma','Leadership in Health and Social Care and Children and Young People''s Services - Adults'' Residential Management', 62, '2011-01-01', NULL,5, 'No', 'Yes', 'QL62ACHQ5'),
(87, 87, 'Diploma','Leadership in Health and Social Care and Children and Young People''s Services - Adults'' Management', 63, '2011-01-01', NULL,5, 'No', 'Yes', 'QL63ACHQ5'),
(88, 88, 'Diploma','Leadership in Health and Social Care and Children and Young People''s Services - Adults'' Advanced Practice', 64, '2011-01-01', NULL,5, 'No', 'Yes', 'QL64ACHQ5'),
(89, 89, 'Diploma','Social Work diploma or other approved UK or non-UK social work qualification', 17, NULL, NULL,4, 'Yes', 'Yes', 'QL17ACHQ4'),
(90, 90, 'Diploma','Any other social care relevant diploma', 115, NULL, NULL,NULL, 'No', 'Yes', 'QL115ACHQ'),
(91, 91, 'Diploma','Any other non-social care relevant diploma', 116, NULL, NULL,NULL, 'No', 'No', 'QL116ACHQ'),
(93, 93, 'NVQ','Care NVQ', 4, NULL, '2007-01-31',2, 'Yes', 'Yes', 'QL04ACHQ2'),
(94, 94, 'NVQ','Care NVQ', 5, NULL, '2007-01-31',3, 'Yes', 'Yes', 'QL05ACHQ3'),
(95, 95, 'NVQ','Care NVQ', 6, NULL, '2007-01-31',4, 'Yes', 'Yes', 'QL06ACHQ4'),
(96, 96, 'NVQ','Health and Social Care NVQ', 3, NULL, '2012-12-31',4, 'Yes', 'Yes', 'QL03ACHQ4'),
(97, 97, 'NVQ','Health and Social Care NVQ', 1, NULL, '2012-12-31',2, 'Yes', 'Yes', 'QL01ACHQ2'),
(98, 98, 'NVQ','Health and Social Care NVQ', 2, NULL, '2012-12-31',3, 'Yes', 'Yes', 'QL02ACHQ3'),
(99, 99, 'NVQ','Other health and care-related NVQ(s)', 9, NULL, '2012-12-31',NULL, 'No', 'Yes', 'QL09ACHQ'),
(100, 100, 'NVQ','Registered Manager''s (Adults) NVQ', 10, NULL, '2011-07-31',4, 'No', 'Yes', 'QL10ACHQ4'),
(102, 102, 'Assessor and mentoring','A1, A2 or other Assessor NVQ', 13, NULL, '2013-12-31',3, 'No', 'No', 'QL13ACHQ3'),
(103, 103, 'Assessor and mentoring','Any Assessor qualification', 82, '2011-01-01', NULL,NULL, 'No', 'No', 'QL82ACHQ'),
(104, 104, 'Assessor and mentoring','Any Internal Verifier qualification', 83, '2011-01-01', NULL,NULL, 'No', 'No', 'QL83ACHQ'),
(105, 105, 'Assessor and mentoring','Any Mentoring qualification', 84, '2011-01-01', NULL,NULL, 'No', 'No', 'QL84ACHQ'),
(106, 106, 'Assessor and mentoring','L20 or other Mentoring NVQ', 15, NULL, '2013-12-31',3, 'No', 'No', 'QL15ACHQ3'),
(107, 107, 'Assessor and mentoring','V1 or other Internal Verifier NVQ', 14, NULL, '2013-12-31',3, 'No', 'No', 'QL14ACHQ3'),
(109, 109, 'Any other qualification','A Basic Skills qualification', 35, NULL, '2014-08-31',1, 'Yes', 'No', 'QL35ACHQ1'),
(110, 110, 'Any other qualification','A Basic Skills qualification', 36, NULL, '2014-08-31',2, 'Yes', 'No', 'QL36ACHQ2'),
(111, 111, 'Any other qualification','A Basic Skills qualification', 34, NULL, NULL,NULL, 'Yes', 'No', 'QL34ACHQE'),
(112, 112, 'Any other qualification','Any childrens/young people''s qualification', 117, NULL, NULL,NULL, 'No', 'No', 'QL117ACHQ'),
(113, 113, 'Any other qualification','Any other relevant professional qualification', 33, NULL, NULL,4, 'No', 'No', 'QL33ACHQ4'),
(114, 114, 'Any other qualification','Any professional Occupational Therapy qualification', 27, NULL, NULL,4, 'No', 'Yes', 'QL27ACHQ4'),
(115, 115, 'Any other qualification','Any qualification in assessment of work-based learning other than social work', 32, NULL, NULL,3, 'No', 'No', 'QL32ACHQ3'),
(116, 116, 'Any other qualification','Any Registered Nursing qualification', 28, NULL, NULL,4, 'No', 'Yes', 'QL28ACHQ4'),
(117, 117, 'Any other qualification','Any other qualification relevant to social care', 37, NULL, NULL,NULL, 'No', 'Yes', 'QL37ACHQ'),
(118, 118, 'Any other qualification','Any other qualification relevant to the job role', 38, NULL, NULL,NULL, 'No', 'No', 'QL38ACHQ'),
(119, 119, 'Any other qualification','Any other qualifications held', 39, NULL, NULL,NULL, 'No', 'No', 'QL39ACHQ');
--(119, 119, 'Any other qualification','Any other qualifications held', 39, NULL, NULL,NULL, 'No', 'No', 'QL39ACHQ'),
--(121, 121, 'Apprenticeship','Adult Care Worker (standard)', 302, NULL, NULL,2, 'Yes', 'n/a', 'QL302ACHQ2'),
--(122, 122, 'Apprenticeship','Adult Care Worker (standard)', 304, NULL, NULL,3, 'Yes', 'n/a', 'QL304ACHQ3'),
--(123, 123, 'Apprenticeship','Advance Apprenticeships in Health and Social Care (framework)', 303, NULL, NULL,3, 'No', 'n/a', 'QL303ACHQ3'),
--(124, 124, 'Apprenticeship','Degree Registered Nurse (standard)', 310, NULL, NULL,6, 'No', 'n/a', 'QL310ACHQ6'),
--(125, 125, 'Apprenticeship','Degree Social Worker (standard)', 308, NULL, NULL,6, 'No', 'n/a', 'QL308ACHQ6'),
--(126, 126, 'Apprenticeship','Higher Apprenticeship in Care Leadership and Management (framework)', 306, NULL, NULL,5, 'No', 'n/a', 'QL306ACHQ5'),
--(127, 127, 'Apprenticeship','Intermediate Apprenticeship in Health and Social Care (framework)', 301, NULL, NULL,2, 'No', 'n/a', 'QL301ACHQ2'),
--(128, 128, 'Apprenticeship','Lead Practitioner in Adult Care (standard)', 305, NULL, NULL,4, 'No', 'n/a', 'QL305ACHQ4'),
--(129, 129, 'Apprenticeship','Leader in Adult Care (standard)', 307, NULL, NULL,5, 'No', 'n/a', 'QL307ACHQ5'),
--(130, 130, 'Apprenticeship','Nursing Associate (standard)', 309, NULL, NULL,5, 'No', 'n/a', 'QL309ACHQ5'),
--(131, 131, 'Apprenticeship','Occupational Therapist', 312, NULL, NULL,6, 'No', 'n/a', 'QL312ACHQ6'),
--(132, 132, 'Apprenticeship','Physiotherapist', 313, NULL, NULL,6, 'No', 'n/a', 'QL313ACHQ6'),
--(133, 133, 'Apprenticeship','Any other apprenticeship framework or standard', 311, NULL, NULL,NULL, 'No', 'n/a', 'QL311ACHQ');


CREATE TYPE cqc."WorkerQualificationType" AS ENUM (
	'NVQ',
  'Any other qualification',
  'Certificate',
  'Degree',
  'Assessor and mentoring',
  'Award', 
  'Diploma',
  'Apprenticeship'
);

CREATE TABLE IF NOT EXISTS cqc."WorkerQualifications" (
	"ID" SERIAL NOT NULL PRIMARY KEY,
  "UID" UUID NOT NULL,
  "WorkerFK" INTEGER NOT NULL,
  "QualificationsFK" INTEGER NOT NULL,
  "Type" cqc."WorkerQualificationType" NOT NULL,
  "Year" SMALLINT NOT NULL,
  "Other" VARCHAR(100) NULL,
  "Notes" TEXT NULL,
  created timestamp without time zone NOT NULL DEFAULT now(),
  updated timestamp without time zone NOT NULL DEFAULT now(),
  updatedby character varying(120) COLLATE pg_catalog."default" NOT NULL,
  CONSTRAINT "WorkerQualifications_Worker_fk" FOREIGN KEY ("WorkerFK") REFERENCES cqc."Worker" ("ID") MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "WorkerQualifications_Qualifications_fk" FOREIGN KEY ("QualificationsFK") REFERENCES cqc."Qualifications" ("ID") MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "WorkerQualifications_UID_unq" UNIQUE ("UID"),
  CONSTRAINT "Workers_WorkerQualifications_unq" UNIQUE ("WorkerFK", "QualificationsFK")
);
CREATE INDEX "WorkerQualifications_WorkerFK" on cqc."WorkerQualifications" ("WorkerFK");
CREATE INDEX "WorkerQualifications_QualificationsFK" on cqc."WorkerQualifications" ("QualificationsFK");


-- Training Categories Reference Data
CREATE TABLE IF NOT EXISTS cqc."TrainingCategories" (
	"ID" INTEGER NOT NULL PRIMARY KEY,
	"Seq" INTEGER NOT NULL, 	-- this is the order in which the Training Category will appear without impacting on primary key (existing foreign keys)
	"Category" TEXT NOT NULL
);

INSERT INTO cqc."TrainingCategories" ("ID", "Seq", "Category") VALUES 
(1, 1, 'Moving and Handling'),
(2, 2, 'Safeguarding Adults'),
(3, 3, 'Any other not in the above categories'),
(4, 4, 'Health and Safety'),
(5, 5, 'Fire safety'),
(6, 6, 'Food safety and catering'),
(7, 7, 'Infection Control'),
(8, 8, 'First Aid'),
(9, 9, 'Medication safe handling and awareness'),
(10, 10, 'Mental capacity and Deprivation of liberty'),
(11, 11, 'Dementia care'),
(12, 12, 'Equality, diversity and human rights training'),
(13, 13, 'Dignity, Respect, Person Centred care'),
(14, 14, 'Nutrition and hydration'),
(15, 15, 'Palliative or end of life care'),
(16, 16, 'Positive behaviour and support'),
(17, 17, 'Emergency Aid awareness'),
(18, 18, 'Control and restraint'),
(19, 19, 'Learning disability'),
(20, 20, 'Leadership & Management'),
(21, 21, 'Physical Disability'),
(22, 22, 'Confidentiality/GDPR'),
(23, 23, 'Epilepsy'),
(24, 24, 'Communication skills'),
(25, 25, 'Diabetes'),
(26, 26, 'Coshh'),
(27, 27, 'Mental health'),
(28, 28, 'Autism'),
(29, 29, 'Continence Care'),
(30, 30, 'Duty of care'),
(31, 31, 'Supervision / Performance management'),
(32, 32, 'Stroke'),
(33, 33, 'Complaints handling/conflict resolution'),
(34, 34, 'Personal Care'),
(35, 35, 'Activity provision/Well-being'),
(36, 36, 'Sensory disability'),
(37, 37, 'Childrens / young people''s related training');

CREATE TABLE IF NOT EXISTS cqc."WorkerTraining" (
	"ID"  SERIAL NOT NULL PRIMARY KEY,
  "UID" UUID NOT NULL,
  "WorkerFK" INTEGER NOT NULL,
  "CategoryFK" INTEGER NOT NULL,
  "Title" VARCHAR(120) NOT NULL,
  "Accredited" BOOLEAN NOT NULL,
  "Completed" DATE NOT NULL,
  "Expires" DATE NULL,
  "Notes" TEXT NULL,
  created timestamp without time zone NOT NULL DEFAULT now(),
  updated timestamp without time zone NOT NULL DEFAULT now(),
  updatedby character varying(120) COLLATE pg_catalog."default" NOT NULL,
  CONSTRAINT "WorkerTraining_Worker_fk" FOREIGN KEY ("WorkerFK") REFERENCES cqc."Worker" ("ID") MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "WorkerTraining_Training_Category_fk" FOREIGN KEY ("CategoryFK") REFERENCES cqc."TrainingCategories" ("ID") MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "WorkerTraining_UID_unq" UNIQUE ("UID")
);
CREATE INDEX "WorkerTraining_WorkerFK" on cqc."WorkerTraining" ("WorkerFK");
CREATE INDEX "WorkerTraining_QualificationsFK" on cqc."WorkerTraining" ("CategoryFK");
