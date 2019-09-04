DROP FUNCTION IF EXISTS cqc.localAuthorityReportAdmin;
CREATE OR REPLACE FUNCTION cqc.localAuthorityReportAdmin(reportFrom DATE, reportTo DATE)
 RETURNS TABLE (
		"LocalAuthority" TEXT,
		"WorkplaceName" TEXT,
		"WorkplaceID" TEXT,
	 	"PrimaryEstablishmentID" INTEGER,
		"LastYearsConfirmedNumbers" INTEGER,
		"LatestUpdate" DATE,
		"WorkplacesCompleted" BIGINT,
		"StaffCompleted" BIGINT,
		"NumberOfWorkplaces" BIGINT,
		"NumberOfWorkplacesCompleted" BIGINT,
		"CountEstablishmentType" BIGINT,
		"CountMainService" BIGINT,
		"CountServiceUserGroups" BIGINT,
		"CountCapacity" BIGINT,
		"CountUiltisation" BIGINT,
		"CountNumberOfStaff" BIGINT,
		"CountVacancies" BIGINT,
		"CountStarters" BIGINT,
		"CountLeavers" BIGINT,
		"SumStaff" BIGINT,
		"CountIndividualStaffRecords" BIGINT,
		"CountOfIndividualStaffRecordsNotAgency" BIGINT,
		"CountOfIndividualStaffRecordsNotAgencyComplete" BIGINT,
		"PercentageNotAgencyComplete" DECIMAL(4,1),
		"CountOfIndividualStaffRecordsAgency" BIGINT,
		"CountOfIndividualStaffRecordsAgencyComplete" BIGINT,
		"PercentageAgencyComplete" DECIMAL(4,1),
		"CountOfGender" BIGINT,
		"CountOfDateOfBirth" BIGINT,
		"CountOfEthnicity" BIGINT,
		"CountOfMainJobRole" BIGINT,
		"CountOfEmploymentStatus" BIGINT,
		"CountOfContractedAverageHours" BIGINT,
		"CountOfSickness" BIGINT,
		"CountOfPay" BIGINT,
		"CountOfQualification" BIGINT
	)
AS $$
DECLARE
	success BOOLEAN;
	v_error_msg TEXT;
	v_error_stack TEXT;
	AllLaEstablishments REFCURSOR;
	CurrentEstablishment RECORD;
BEGIN
	success := true;

	OPEN AllLaEstablishments FOR
	SELECT MyLocalAuthorities."LocalAuthority", MyLocalAuthorities."NmdsID", "Establishment"."EstablishmentID", "LAEstablishment"."WorkplaceName", "LAEstablishment"."WorkplaceID"
	FROM (
		VALUES
			('Barking & Dagenham','G100283', 394),
			('Barnet','G109436', 346),
			('Barnsley','J115228', 405),
			('Bath and North East Somerset','D238068', 69),
			('Bedford','I236353', 568),
			('Bexley','G112580', 335),
			('Birmingham','E200127', 1992),
			('Blackburn with Darwen','F92383', 289),
			('Blackpool','F194727', 626),
			('Bolton','F134107', 691),
			('Bournemouth','D112506', 333),
			('Bracknell Forest','H114435', 316),
			('Bradford','J139447', 1553),
			('Brent','G233567', 353),
			('Brighton & Hove','H102995', 862),
			('Bristol','D231967', 1048),
			('Bromley','G114788', 378),
			('Buckinghamshire','H235947', 648),
			('Bury','F105233', 540),
			('Calderdale','J114267', 675),
			('Cambridgeshire','I156828', 1058),
			('Camden','G110402', 369),
			('Central Bedfordshire','I174567', 584),
			('Cheshire East','F227307', 994),
			('Cheshire West and Chester','F107121', 577),
			('City of London','G232387', 15),
			('Cornwall','D114992', 1089),
			('Coventry','E178967', 863),
			('Croydon','G158292', 584),
			('Cumbria','F181827', 2749),
			('Darlington','B10784', 192),
			('Derby','C104755', 675),
			('Derbyshire','C107021', 3635),
			('Devon','D107716', 1315),
			('Doncaster','J106920', 716),
			('Dorset','D227879', 639),
			('Dudley','E104880', 838),
			('Durham','B104830', 828),
			('Ealing','G251344', 456),
			('East Riding of Yorkshire','J228012', 1290),
			('East Sussex','H105090', 1754),
			('Enfield','G174087', 208),
			('Essex','I100769', 1214),
			('Gateshead','B108334', 756),
			('Gloucestershire','D51188', 1073),
			('Greenwich','G231414', 516),
			('Hackney','G122327', 546),
			('Halton','F131587', 1173),
			('Hammersmith & Fulham','G104757', 277),
			('Hampshire','H228327', 3474),
			('Haringey','G104471', 283),
			('Harrow','G246107', 368),
			('Hartlepool','B102671', 310),
			('Havering','G247910', 242),
			('Herefordshire','E141307', 283),
			('Hertfordshire','I102895', 2206),
			('Hillingdon','G102559', 354),
			('Hounslow','G103425', 613),
			('Isle of Wight','H129207', 733),
			('Isles of Scilly','D233649', 31),
			('Islington','G251598', 444),
			('Kensington & Chelsea','G210367', 326),
			('Kent','H108087', 2871),
			('Kingston-upon-Hull','J233376', 811),
			('Kingston-Upon-Thames','G173768', 156),
			('Kirklees','J100346', 1248),
			('Knowsley','F138807', 397),
					('Lambeth','G107515', 522),
			('Lancashire','F144667', 3924),
			('Leeds','J206148', 1419),
			('Leicester','C105021', 759),
			('Leicestershire','C104324', 1349),
			('Lewisham','G238960', 417),
			('Lincolnshire','C235693', 691),
			('Liverpool','F112420', 1088),
			('Luton','I169167', 529),
			('Manchester','F92068', 1460),
			('Medway','H120367', 238),
			('Merton','G179107', 310),
			('Middlesbrough','B116107', 427),
			('Milton Keynes','H104058', 724),
			('Newcastle-upon-Tyne','B115867', 880),
			('Newham','G247772', 413),
			('Norfolk','I107881', 2578),
			('North East Lincolnshire','J251291', 1),
			('North Lincolnshire','J134007', 509),
			('North Somerset','D115028', 304),
			('North Tyneside','B136247', 508),
			('North Yorkshire','J113547', 2410),
			('Northamptonshire','C106716', 1488),
			('Northumberland','B106802', 535),
			('Nottingham','C100004', 1033),
			('Nottinghamshire','C31061', 2029),
					('Oldham','F92140', 237),
			('Oxfordshire','H134847', 799),
			('Peterborough','I161067', 207),
			('Plymouth','D112677', 157),
			('Poole','D51078', 365),
			('Portsmouth','H123527', 847),
			('Reading','H107691', 311),
			('Redbridge','G102939', 397),
			('Redcar & Cleveland','B103244', 359),
			('Richmond-upon-Thames','G102074', 284),
			('Rochdale','F92427', 369),
			('Rotherham','J116648', 790),
			('Rutland','C232251', 99),
			('Salford','F105473', 167),
			('Sandwell','E160467', 759),
			('Sefton','F121567', 345),
			('Sheffield','J109224', 1177),
			('Shropshire','E245728', 632),
			('Slough','H102664', 287),
			('Solihull','E233120', 514),
			('Somerset','D148447', 414),
			('South Gloucestershire','D108414', 530),
			('South Tyneside','B174687', 4250),
			('Southampton','H158538', 430),
			('Southend-on-Sea','I174667', 237),
			('Southwark','G166348', 440),
			('St Helens','F105698', 675),
			('Staffordshire','E109339', 739),
			('Stockport','F92250', 634),
			('Stockton-on-Tees','B117463', 635),
			('Stoke-on-Trent','E100715', 694),
			('Suffolk','I105347', 1345),
			('Sunderland','B104660', 292),
			('Surrey','H129567', 1996),
			('Sutton','G106959', 272),
			('Swindon','D109088', 478),
			('Tameside','F108511', 626),
			('Telford & Wrekin','E207567', 477),
			('Thurrock','I125827', 449),
			('Torbay','D253007', 18),
			('Tower Hamlets','G106537', 446),
			('Trafford','F112554', 439),
			('Wakefield','J112649', 960),
			('Walsall','E122167', 402),
			('Waltham Forest','G104057', 395),
			('Wandsworth','G108652', 395),
			('Warrington','F103037', 481),
			('Warwickshire','E251688', 698),
			('West Berkshire','H117047', 497),
			('West Sussex','H237687', 1268),
			('Westminster','G105680', 434),
			('Wigan','B10756', 1144),
			('Wiltshire','D119247', 577),
			('Windsor & Maidenhead','H112607', 9),
			('Wirral','F102294', 81),
			('Wokingham','H106740', 88),
			('Wolverhampton','E118530', 543),
			('Worcestershire','E235582', 1162),
			('York','J161268', 382),
			('Wozziland', 'G1001020', 0),
			('Wozziland2', 'G1001010', 0),
			('Jackieland', 'J1001074', 111)
		) AS MyLocalAuthorities ("LocalAuthority", "NmdsID", "LastYears")
			LEFT JOIN cqc."Establishment" on "Establishment"."NmdsID" = MyLocalAuthorities."NmdsID"
			LEFT JOIN cqc."LocalAuthorityReportEstablishment" AS "LAEstablishment" on "LAEstablishment"."WorkplaceID" = MyLocalAuthorities."NmdsID";


	-- first, run through and generate all Local Authority user reports - NOW
	LOOP
		FETCH AllLaEstablishments INTO CurrentEstablishment;
		EXIT WHEN NOT FOUND;

 		IF CurrentEstablishment."EstablishmentID" IS NOT NULL THEN
 			PERFORM cqc.localAuthorityReport(CurrentEstablishment."EstablishmentID", reportFrom, reportTo);
 		END IF;		
	END LOOP;

	-- now report against all those generated user reports
	RETURN QUERY SELECT
		MyLocalAuthorities."LocalAuthority",
		LAEstablishments."WorkplaceName",
		LAEstablishments."WorkplaceID",
		LAEstablishments."EstablishmentFK" AS "PrimaryEstablishmentID",
		MyLocalAuthorities."LastYears",
		CASE WHEN max(LAEstablishments2."LastUpdatedDate") > max(LAWorkers."LastUpdated") THEN max(LAEstablishments2."LastUpdatedDate") ELSE max(LAWorkers."LastUpdated") END AS "LatestUpdate",
		count(LAEstablishments2."WorkplaceID") FILTER (WHERE LAEstablishments2."WorkplaceComplete" = true) AS "WorkplacesCompleted",
		sum(LAWorkers."CountIndividualStaffRecordsCompleted") AS "StaffCompleted",
		count(LAEstablishments2."WorkplaceID") AS "NumberOfWorkplaces",
		count(LAEstablishments2."WorkplaceID") FILTER (WHERE LAEstablishments2."WorkplaceComplete" = true) AS "NumberOfWorkplacesCompleted",
		count(LAEstablishments2."WorkplaceID") FILTER (WHERE SUBSTRING(LAEstablishments2."EstablishmentType" from 1 for 15) = 'Local Authority') AS "CountEstablishmentType",
		count(LAEstablishments2."WorkplaceID") AS  "CountMainService",			-- main service is mandatory
		count(LAEstablishments2."WorkplaceID") FILTER (WHERE LAEstablishments2."ServiceUserGroups" <> 'Missing') AS  "CountServiceUserGroups",
		count(LAEstablishments2."WorkplaceID") FILTER (WHERE LAEstablishments2."CapacityOfMainService" <> 'Missing') AS  "CountCapacity",
		count(LAEstablishments2."WorkplaceID") FILTER (WHERE LAEstablishments2."UtilisationOfMainService" <> 'Missing') AS  "CountUiltisation",
		count(LAEstablishments2."WorkplaceID") FILTER (WHERE LAEstablishments2."NumberOfStaffRecords" <> 'Missing') AS  "CountNumberOfStaff",
		count(LAEstablishments2."WorkplaceID") FILTER (WHERE LAEstablishments2."NumberOfVacancies" <> 'Missing') AS  "CountVacancies",
		count(LAEstablishments2."WorkplaceID") FILTER (WHERE LAEstablishments2."NumberOfStarters" <> 'Missing') AS  "CountStarters",
		count(LAEstablishments2."WorkplaceID") FILTER (WHERE LAEstablishments2."NumberOfLeavers" <> 'Missing') AS  "CountLeavers",
		sum(LAEstablishments2."NumberOfStaffRecords"::INTEGER) FILTER (WHERE LAEstablishments2."NumberOfStaffRecords" <> 'Missing') AS  "SumStaff",
		sum(LAWorkers."CountIndividualStaffRecords") AS "CountIndividualStaffRecords",
		sum(LAWorkers."CountOfIndividualStaffRecordsNotAgency") AS "CountOfIndividualStaffRecordsNotAgency",
		sum(LAWorkers."CountOfIndividualStaffRecordsNotAgencyComplete") AS "CountOfIndividualStaffRecordsNotAgencyComplete",
		sum(LAWorkers."PercentageNotAgencyComplete") AS "PercentageNotAgencyComplete",
		sum(LAWorkers."CountOfIndividualStaffRecordsAgency") AS "CountOfIndividualStaffRecordsAgency",
		sum(LAWorkers."CountOfIndividualStaffRecordsAgencyComplete") AS "CountOfIndividualStaffRecordsAgencyComplete",
		sum(LAWorkers."PercentageAgencyComplete") AS "PercentageAgencyComplete",
		sum(LAWorkers."CountOfGender") AS "CountOfGender",
		sum(LAWorkers."CountOfDateOfBirth") AS "CountOfDateOfBirth",
		sum(LAWorkers."CountOfEthnicity") AS "CountOfEthnicity",
		sum(LAWorkers."CountOfMainJobRole") AS "CountOfMainJobRole",
		sum(LAWorkers."CountOfEmploymentStatus") AS "CountOfEmploymentStatus",
		sum(LAWorkers."CountOfContractedAverageHours") AS "CountOfContractedAverageHours",
		sum(LAWorkers."CountOfSickness") AS "CountOfSickness",
		sum(LAWorkers."CountOfPay") AS "CountOfPay",
		sum(LAWorkers."CountOfQualification") AS "CountOfQualification"
	FROM (
		VALUES
			('Barking & Dagenham','G100283', 394),
			('Barnet','G109436', 346),
			('Barnsley','J115228', 405),
			('Bath and North East Somerset','D238068', 69),
			('Bedford','I236353', 568),
			('Bexley','G112580', 335),
			('Birmingham','E200127', 1992),
			('Blackburn with Darwen','F92383', 289),
			('Blackpool','F194727', 626),
			('Bolton','F134107', 691),
			('Bournemouth','D112506', 333),
			('Bracknell Forest','H114435', 316),
			('Bradford','J139447', 1553),
			('Brent','G233567', 353),
			('Brighton & Hove','H102995', 862),
			('Bristol','D231967', 1048),
			('Bromley','G114788', 378),
			('Buckinghamshire','H235947', 648),
			('Bury','F105233', 540),
			('Calderdale','J114267', 675),
			('Cambridgeshire','I156828', 1058),
			('Camden','G110402', 369),
			('Central Bedfordshire','I174567', 584),
			('Cheshire East','F227307', 994),
			('Cheshire West and Chester','F107121', 577),
			('City of London','G232387', 15),
			('Cornwall','D114992', 1089),
			('Coventry','E178967', 863),
			('Croydon','G158292', 584),
			('Cumbria','F181827', 2749),
			('Darlington','B10784', 192),
			('Derby','C104755', 675),
			('Derbyshire','C107021', 3635),
			('Devon','D107716', 1315),
			('Doncaster','J106920', 716),
			('Dorset','D227879', 639),
			('Dudley','E104880', 838),
			('Durham','B104830', 828),
			('Ealing','G251344', 456),
			('East Riding of Yorkshire','J228012', 1290),
			('East Sussex','H105090', 1754),
			('Enfield','G174087', 208),
			('Essex','I100769', 1214),
			('Gateshead','B108334', 756),
			('Gloucestershire','D51188', 1073),
			('Greenwich','G231414', 516),
			('Hackney','G122327', 546),
			('Halton','F131587', 1173),
			('Hammersmith & Fulham','G104757', 277),
			('Hampshire','H228327', 3474),
			('Haringey','G104471', 283),
			('Harrow','G246107', 368),
			('Hartlepool','B102671', 310),
			('Havering','G247910', 242),
			('Herefordshire','E141307', 283),
			('Hertfordshire','I102895', 2206),
			('Hillingdon','G102559', 354),
			('Hounslow','G103425', 613),
			('Isle of Wight','H129207', 733),
			('Isles of Scilly','D233649', 31),
			('Islington','G251598', 444),
			('Kensington & Chelsea','G210367', 326),
			('Kent','H108087', 2871),
			('Kingston-upon-Hull','J233376', 811),
			('Kingston-Upon-Thames','G173768', 156),
			('Kirklees','J100346', 1248),
			('Knowsley','F138807', 397),
			('Lambeth','G107515', 522),
			('Lancashire','F144667', 3924),
			('Leeds','J206148', 1419),
			('Leicester','C105021', 759),
			('Leicestershire','C104324', 1349),
			('Lewisham','G238960', 417),
			('Lincolnshire','C235693', 691),
			('Liverpool','F112420', 1088),
			('Luton','I169167', 529),
			('Manchester','F92068', 1460),
			('Medway','H120367', 238),
			('Merton','G179107', 310),
			('Middlesbrough','B116107', 427),
			('Milton Keynes','H104058', 724),
			('Newcastle-upon-Tyne','B115867', 880),
			('Newham','G247772', 413),
			('Norfolk','I107881', 2578),
			('North East Lincolnshire','J251291', 1),
			('North Lincolnshire','J134007', 509),
			('North Somerset','D115028', 304),
			('North Tyneside','B136247', 508),
			('North Yorkshire','J113547', 2410),
			('Northamptonshire','C106716', 1488),
			('Northumberland','B106802', 535),
			('Nottingham','C100004', 1033),
			('Nottinghamshire','C31061', 2029),
					('Oldham','F92140', 237),
			('Oxfordshire','H134847', 799),
			('Peterborough','I161067', 207),
			('Plymouth','D112677', 157),
			('Poole','D51078', 365),
			('Portsmouth','H123527', 847),
			('Reading','H107691', 311),
			('Redbridge','G102939', 397),
			('Redcar & Cleveland','B103244', 359),
			('Richmond-upon-Thames','G102074', 284),
			('Rochdale','F92427', 369),
			('Rotherham','J116648', 790),
			('Rutland','C232251', 99),
			('Salford','F105473', 167),
			('Sandwell','E160467', 759),
			('Sefton','F121567', 345),
			('Sheffield','J109224', 1177),
			('Shropshire','E245728', 632),
			('Slough','H102664', 287),
			('Solihull','E233120', 514),
			('Somerset','D148447', 414),
			('South Gloucestershire','D108414', 530),
			('South Tyneside','B174687', 4250),
			('Southampton','H158538', 430),
			('Southend-on-Sea','I174667', 237),
			('Southwark','G166348', 440),
			('St Helens','F105698', 675),
			('Staffordshire','E109339', 739),
			('Stockport','F92250', 634),
			('Stockton-on-Tees','B117463', 635),
			('Stoke-on-Trent','E100715', 694),
			('Suffolk','I105347', 1345),
			('Sunderland','B104660', 292),
			('Surrey','H129567', 1996),
			('Sutton','G106959', 272),
			('Swindon','D109088', 478),
			('Tameside','F108511', 626),
			('Telford & Wrekin','E207567', 477),
			('Thurrock','I125827', 449),
			('Torbay','D253007', 18),
			('Tower Hamlets','G106537', 446),
			('Trafford','F112554', 439),
			('Wakefield','J112649', 960),
			('Walsall','E122167', 402),
			('Waltham Forest','G104057', 395),
			('Wandsworth','G108652', 395),
			('Warrington','F103037', 481),
			('Warwickshire','E251688', 698),
			('West Berkshire','H117047', 497),
			('West Sussex','H237687', 1268),
			('Westminster','G105680', 434),
			('Wigan','B10756', 1144),
			('Wiltshire','D119247', 577),
			('Windsor & Maidenhead','H112607', 9),
			('Wirral','F102294', 81),
			('Wokingham','H106740', 88),
			('Wolverhampton','E118530', 543),
			('Worcestershire','E235582', 1162),
			('York','J161268', 382),
			('Wozziland', 'G1001020', 0),
			('Wozziland2', 'G1001010', 0),
			('Jackieland', 'J1001074', 111)
		) AS MyLocalAuthorities ("LocalAuthority", "NmdsID", "LastYears")
	INNER JOIN cqc."LocalAuthorityReportEstablishment" LAEstablishments on LAEstablishments."WorkplaceID" = MyLocalAuthorities."NmdsID"
	INNER JOIN cqc."LocalAuthorityReportEstablishment" LAEstablishments2 on LAEstablishments2."EstablishmentFK" = LAEstablishments."EstablishmentFK"
	INNER JOIN (
		SELECT 
			"WorkplaceFK",
			max("LastUpdated") AS "LastUpdated",
			count(LAWorkers2."MainJob") AS  "CountIndividualStaffRecords",
			count(LAWorkers2."MainJob") FILTER (WHERE LAWorkers2."StaffRecordComplete" = true)  AS  "CountIndividualStaffRecordsCompleted",
			count(LAWorkers2."EmploymentStatus") FILTER (WHERE LAWorkers2."EmploymentStatus" <> 'Agency') AS  "CountOfIndividualStaffRecordsNotAgency",
			count(LAWorkers2."EmploymentStatus") FILTER (WHERE LAWorkers2."EmploymentStatus" <> 'Agency' AND LAWorkers2."StaffRecordComplete" = true) AS  "CountOfIndividualStaffRecordsNotAgencyComplete",
			0.00::DECIMAL(4,1) AS "PercentageNotAgencyComplete",
			count(LAWorkers2."EmploymentStatus") FILTER (WHERE LAWorkers2."EmploymentStatus" = 'Agency') AS  "CountOfIndividualStaffRecordsAgency",
			count(LAWorkers2."EmploymentStatus") FILTER (WHERE LAWorkers2."EmploymentStatus" = 'Agency'  AND LAWorkers2."StaffRecordComplete" = true) AS  "CountOfIndividualStaffRecordsAgencyComplete",
			0.00::DECIMAL(4,1) AS "PercentageAgencyComplete",
			count(LAWorkers2."EmploymentStatus") FILTER (WHERE LAWorkers2."Gender" <> 'Missing') AS  "CountOfGender",
			count(LAWorkers2."EmploymentStatus") FILTER (WHERE LAWorkers2."DateOfBirth" <> 'Missing') AS  "CountOfDateOfBirth",
			count(LAWorkers2."EmploymentStatus") FILTER (WHERE LAWorkers2."Ethnicity" <> 'Missing') AS  "CountOfEthnicity",
			count(LAWorkers2."EmploymentStatus") FILTER (WHERE LAWorkers2."MainJob" <> 'Missing') AS  "CountOfMainJobRole",
			count(LAWorkers2."EmploymentStatus") FILTER (WHERE LAWorkers2."EmploymentStatus" <> 'Missing') AS  "CountOfEmploymentStatus",
			count(LAWorkers2."EmploymentStatus") FILTER (WHERE LAWorkers2."ContractedAverageHours" <> 'Missing') AS  "CountOfContractedAverageHours",
			count(LAWorkers2."EmploymentStatus") FILTER (WHERE LAWorkers2."SickDays" <> 'Missing') AS  "CountOfSickness",
			count(LAWorkers2."EmploymentStatus") FILTER (WHERE LAWorkers2."PayInterval" <> 'Missing' AND LAWorkers2."RateOfPay" <> 'Missing') AS  "CountOfPay",
			count(LAWorkers2."EmploymentStatus") FILTER (WHERE LAWorkers2."RelevantSocialCareQualification" <> 'Missing' AND LAWorkers2."HighestSocialCareQualification" <> 'Missing' AND LAWorkers2."NonSocialCareQualification" <> 'Missing') AS  "CountOfQualification"
		FROM cqc."LocalAuthorityReportWorker" LAWorkers2
		group by LAWorkers2."WorkplaceFK"
	) LAWorkers ON LAWorkers."WorkplaceFK" = LAEstablishments2."WorkplaceFK"
	GROUP BY
 		MyLocalAuthorities."LocalAuthority",
 		LAEstablishments."WorkplaceName",
 		LAEstablishments."WorkplaceID",
 		LAEstablishments."EstablishmentFK",
		MyLocalAuthorities."LastYears";

END; $$
LANGUAGE 'plpgsql';

--select * from cqc.localAuthorityReportAdmin('2019-06-10'::DATE, '2019-08-10'::DATE);