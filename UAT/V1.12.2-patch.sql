-- https://trello.com/c/6DpN53GL
DROP FUNCTION IF EXISTS cqc.localAuthorityReportAdmin;
CREATE OR REPLACE FUNCTION cqc.localAuthorityReportAdmin(reportFrom DATE, reportTo DATE)
 RETURNS TABLE (
		"LocalAuthority" TEXT,
		"WorkplaceName" TEXT,
		"WorkplaceID" TEXT,
	 	"PrimaryEstablishmentID" INTEGER,
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
		"SumStaff" BIGINT
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
			('Barking & Dagenham','G100283'),
			('Barnet','G109436'),
			('Barnsley','J115228'),
			('Bath and North East Somerset','D238068'),
			('Bedford','I236353'),
			('Bexley','G112580'),
			('Birmingham','E200127'),
			('Blackburn with Darwen','F92383'),
			('Blackpool','F194727'),
			('Bolton','F134107'),
			('Bournemouth','D112506'),
			('Bracknell Forest','H114435'),
			('Bradford','J139447'),
			('Brent','G233567'),
			('Brighton & Hove','H102995'),
			('Bristol','D231967'),
			('Bromley','G114788'),
			('Buckinghamshire','H235947'),
			('Bury','F105233'),
			('Calderdale','J114267'),
			('Cambridgeshire','I156828'),
			('Camden','G110402'),
			('Central Bedfordshire','I174567'),
			('Cheshire East','F227307'),
			('Cheshire West and Chester','F107121'),
			('City of London','G232387'),
			('Cornwall','D114992'),
			('Coventry','E178967'),
			('Croydon','G158292'),
			('Cumbria','F181827'),
			('Darlington','B10784'),
			('Derby','C104755'),
			('Derbyshire','C107021'),
			('Devon','D107716'),
			('Doncaster','J106920'),
			('Dorset','D227879'),
			('Dudley','E104880'),
			('Durham','B104830'),
			('Ealing','G251344'),
			('East Riding of Yorkshire','J228012'),
			('East Sussex','H105090'),
			('Enfield','G174087'),
			('Essex','I100769'),
			('Gateshead','B108334'),
			('Gloucestershire','D51188'),
			('Greenwich','G231414'),
			('Hackney','G122327'),
			('Halton','F131587'),
			('Hammersmith & Fulham','G104757'),
			('Hampshire','H228327'),
			('Haringey','G104471'),
			('Harrow','G246107'),
			('Hartlepool','B102671'),
			('Havering','G247910'),
			('Herefordshire','E141307'),
			('Hertfordshire','I102895'),
			('Hillingdon','G102559'),
			('Hounslow','G103425'),
			('Isle of Wight','H129207'),
			('Isles of Scilly','D233649'),
			('Islington','G251598'),
			('Kensington & Chelsea','G210367'),
			('Kent','H108087'),
			('Kingston-upon-Hull','J233376'),
			('Kingston-Upon-Thames','G173768'),
			('Kirklees','J100346'),
			('Knowsley','F138807'),
			('Lambeth','G107515'),
			('Lancashire','F144667'),
			('Leeds','J206148'),
			('Leicester','C105021'),
			('Leicestershire','C104324'),
			('Lewisham','G238960'),
			('Lincolnshire','C235693'),
			('Liverpool','F112420'),
			('Luton','I169167'),
			('Manchester','F92068'),
			('Medway','H120367'),
			('Merton','G179107'),
			('Middlesbrough','B116107'),
			('Milton Keynes','H104058'),
			('Newcastle-upon-Tyne','B115867'),
			('Newham','G247772'),
			('Norfolk','I107881'),
			('North East Lincolnshire','J251291'),
			('North Lincolnshire','J134007'),
			('North Somerset','D115028'),
			('North Tyneside','B136247'),
			('North Yorkshire','J113547'),
			('Northamptonshire','C106716'),
			('Northumberland','B106802'),
			('Nottingham','C100004'),
			('Nottinghamshire','C31061'),
			('Oldham','F92140'),
			('Oxfordshire','H134847'),
			('Peterborough','I161067'),
			('Plymouth','D112677'),
			('Poole','D51078'),
			('Portsmouth','H123527'),
			('Reading','H107691'),
			('Redbridge','G102939'),
			('Redcar & Cleveland','B103244'),
			('Richmond-upon-Thames','G102074'),
			('Rochdale','F92427'),
			('Rotherham','J116648'),
			('Rutland','C232251'),
			('Salford','F105473'),
			('Sandwell','E160467'),
			('Sefton','F121567'),
			('Sheffield','J109224'),
			('Shropshire','E245728'),
			('Slough','H102664'),
			('Solihull','E233120'),
			('Somerset','D148447'),
			('South Gloucestershire','D108414'),
			('South Tyneside','B174687'),
			('Southampton','H158538'),
			('Southend-on-Sea','I174667'),
			('Southwark','G166348'),
			('St Helens','F105698'),
			('Staffordshire','E109339'),
			('Stockport','F92250'),
			('Stockton-on-Tees','B117463'),
			('Stoke-on-Trent','E100715'),
			('Suffolk','I105347'),
			('Sunderland','B104660'),
			('Surrey','H129567'),
			('Sutton','G106959'),
			('Swindon','D109088'),
			('Tameside','F108511'),
			('Telford & Wrekin','E207567'),
			('Thurrock','I125827'),
			('Torbay','D253007'),
			('Tower Hamlets','G106537'),
			('Trafford','F112554'),
			('Wakefield','J112649'),
			('Walsall','E122167'),
			('Waltham Forest','G104057'),
			('Wandsworth','G108652'),
			('Warrington','F103037'),
			('Warwickshire','E251688'),
			('West Berkshire','H117047'),
			('West Sussex','H237687'),
			('Westminster','G105680'),
			('Wigan','B10756'),
			('Wiltshire','D119247'),
			('Windsor & Maidenhead','H112607'),
			('Wirral','F102294'),
			('Wokingham','H106740'),
			('Wolverhampton','E118530'),
			('Worcestershire','E235582'),
			('York','J161268'),
			('Wozziland', 'G1001020')
		) AS MyLocalAuthorities ("LocalAuthority", "NmdsID")
			LEFT JOIN cqc."Establishment" on "Establishment"."NmdsID" = MyLocalAuthorities."NmdsID"
			LEFT JOIN cqc."LocalAuthorityReportEstablishment" AS "LAEstablishment" on "LAEstablishment"."WorkplaceID" = MyLocalAuthorities."NmdsID";


	-- first, run through and generate all Local Authority user reports - NOW
	LOOP
		FETCH AllLaEstablishments INTO CurrentEstablishment;
		EXIT WHEN NOT FOUND;

		RAISE NOTICE 'Current Establishment: % (%) - %', CurrentEstablishment."LocalAuthority", CurrentEstablishment."NmdsID", CurrentEstablishment."EstablishmentID";
		
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
		max(LAEstablishments."LastUpdatedDate") AS "LatestUpdate",
		count(LAEstablishments."WorkplaceID") FILTER (WHERE LAEstablishments."WorkplaceComplete" = true) AS "WorkplacesCompleted",
		0::BIGINT AS "StaffCompleted",
		count(LAEstablishments."WorkplaceID") AS "NumberOfWorkplaces",
		count(LAEstablishments."WorkplaceID") FILTER (WHERE LAEstablishments."WorkplaceComplete" = true) AS "NumberOfWorkplacesCompleted",
		count(LAEstablishments."WorkplaceID") FILTER (WHERE SUBSTRING(LAEstablishments."EstablishmentType" from 1 for 15) = 'Local Authority') AS "CountEstablishmentType",
		count(LAEstablishments."WorkplaceID") AS  "CountMainService",			-- main service is mandatory
		count(LAEstablishments."WorkplaceID") FILTER (WHERE LAEstablishments."ServiceUserGroups" <> 'Missing') AS  "CountServiceUserGroups",
		count(LAEstablishments."WorkplaceID") FILTER (WHERE LAEstablishments."CapacityOfMainService" <> 'Missing') AS  "CountCapacity",
		count(LAEstablishments."WorkplaceID") FILTER (WHERE LAEstablishments."UtilisationOfMainService" <> 'Missing') AS  "CountUiltisation",
		count(LAEstablishments."WorkplaceID") FILTER (WHERE LAEstablishments."NumberOfStaffRecords" <> 'Missing') AS  "CountNumberOfStaff",
		count(LAEstablishments."WorkplaceID") FILTER (WHERE LAEstablishments."NumberOfVacancies" <> 'Missing') AS  "CountVacancies",
		count(LAEstablishments."WorkplaceID") FILTER (WHERE LAEstablishments."NumberOfStarters" <> 'Missing') AS  "CountStarters",
		count(LAEstablishments."WorkplaceID") FILTER (WHERE LAEstablishments."NumberOfLeavers" <> 'Missing') AS  "CountLeavers",
		sum(LAEstablishments."NumberOfStaffRecords"::INTEGER) FILTER (WHERE LAEstablishments."NumberOfStaffRecords" <> 'Missing') AS  "SumStaff"
	FROM (
		VALUES
			('Barking & Dagenham','G100283'),
			('Barnet','G109436'),
			('Barnsley','J115228'),
			('Bath and North East Somerset','D238068'),
			('Bedford','I236353'),
			('Bexley','G112580'),
			('Birmingham','E200127'),
			('Blackburn with Darwen','F92383'),
			('Blackpool','F194727'),
			('Bolton','F134107'),
			('Bournemouth','D112506'),
			('Bracknell Forest','H114435'),
			('Bradford','J139447'),
			('Brent','G233567'),
			('Brighton & Hove','H102995'),
			('Bristol','D231967'),
			('Bromley','G114788'),
			('Buckinghamshire','H235947'),
			('Bury','F105233'),
			('Calderdale','J114267'),
			('Cambridgeshire','I156828'),
			('Camden','G110402'),
			('Central Bedfordshire','I174567'),
			('Cheshire East','F227307'),
			('Cheshire West and Chester','F107121'),
			('City of London','G232387'),
			('Cornwall','D114992'),
			('Coventry','E178967'),
			('Croydon','G158292'),
			('Cumbria','F181827'),
			('Darlington','B10784'),
			('Derby','C104755'),
			('Derbyshire','C107021'),
			('Devon','D107716'),
			('Doncaster','J106920'),
			('Dorset','D227879'),
			('Dudley','E104880'),
			('Durham','B104830'),
			('Ealing','G251344'),
			('East Riding of Yorkshire','J228012'),
			('East Sussex','H105090'),
			('Enfield','G174087'),
			('Essex','I100769'),
			('Gateshead','B108334'),
			('Gloucestershire','D51188'),
			('Greenwich','G231414'),
			('Hackney','G122327'),
			('Halton','F131587'),
			('Hammersmith & Fulham','G104757'),
			('Hampshire','H228327'),
			('Haringey','G104471'),
			('Harrow','G246107'),
			('Hartlepool','B102671'),
			('Havering','G247910'),
			('Herefordshire','E141307'),
			('Hertfordshire','I102895'),
			('Hillingdon','G102559'),
			('Hounslow','G103425'),
			('Isle of Wight','H129207'),
			('Isles of Scilly','D233649'),
			('Islington','G251598'),
			('Kensington & Chelsea','G210367'),
			('Kent','H108087'),
			('Kingston-upon-Hull','J233376'),
			('Kingston-Upon-Thames','G173768'),
			('Kirklees','J100346'),
			('Knowsley','F138807'),
			('Lambeth','G107515'),
			('Lancashire','F144667'),
			('Leeds','J206148'),
			('Leicester','C105021'),
			('Leicestershire','C104324'),
			('Lewisham','G238960'),
			('Lincolnshire','C235693'),
			('Liverpool','F112420'),
			('Luton','I169167'),
			('Manchester','F92068'),
			('Medway','H120367'),
			('Merton','G179107'),
			('Middlesbrough','B116107'),
			('Milton Keynes','H104058'),
			('Newcastle-upon-Tyne','B115867'),
			('Newham','G247772'),
			('Norfolk','I107881'),
			('North East Lincolnshire','J251291'),
			('North Lincolnshire','J134007'),
			('North Somerset','D115028'),
			('North Tyneside','B136247'),
			('North Yorkshire','J113547'),
			('Northamptonshire','C106716'),
			('Northumberland','B106802'),
			('Nottingham','C100004'),
			('Nottinghamshire','C31061'),
			('Oldham','F92140'),
			('Oxfordshire','H134847'),
			('Peterborough','I161067'),
			('Plymouth','D112677'),
			('Poole','D51078'),
			('Portsmouth','H123527'),
			('Reading','H107691'),
			('Redbridge','G102939'),
			('Redcar & Cleveland','B103244'),
			('Richmond-upon-Thames','G102074'),
			('Rochdale','F92427'),
			('Rotherham','J116648'),
			('Rutland','C232251'),
			('Salford','F105473'),
			('Sandwell','E160467'),
			('Sefton','F121567'),
			('Sheffield','J109224'),
			('Shropshire','E245728'),
			('Slough','H102664'),
			('Solihull','E233120'),
			('Somerset','D148447'),
			('South Gloucestershire','D108414'),
			('South Tyneside','B174687'),
			('Southampton','H158538'),
			('Southend-on-Sea','I174667'),
			('Southwark','G166348'),
			('St Helens','F105698'),
			('Staffordshire','E109339'),
			('Stockport','F92250'),
			('Stockton-on-Tees','B117463'),
			('Stoke-on-Trent','E100715'),
			('Suffolk','I105347'),
			('Sunderland','B104660'),
			('Surrey','H129567'),
			('Sutton','G106959'),
			('Swindon','D109088'),
			('Tameside','F108511'),
			('Telford & Wrekin','E207567'),
			('Thurrock','I125827'),
			('Torbay','D253007'),
			('Tower Hamlets','G106537'),
			('Trafford','F112554'),
			('Wakefield','J112649'),
			('Walsall','E122167'),
			('Waltham Forest','G104057'),
			('Wandsworth','G108652'),
			('Warrington','F103037'),
			('Warwickshire','E251688'),
			('West Berkshire','H117047'),
			('West Sussex','H237687'),
			('Westminster','G105680'),
			('Wigan','B10756'),
			('Wiltshire','D119247'),
			('Windsor & Maidenhead','H112607'),
			('Wirral','F102294'),
			('Wokingham','H106740'),
			('Wolverhampton','E118530'),
			('Worcestershire','E235582'),
			('York','J161268'),
			('Wozziland', 'G1001020')
		) AS MyLocalAuthorities ("LocalAuthority", "NmdsID")
	INNER JOIN cqc."LocalAuthorityReportEstablishment" LAEstablishments on LAEstablishments."WorkplaceID" = MyLocalAuthorities."NmdsID"
	GROUP BY
		MyLocalAuthorities."LocalAuthority",
		LAEstablishments."WorkplaceName",
		LAEstablishments."WorkplaceID",
		LAEstablishments."EstablishmentFK";

-- 	EXCEPTION WHEN OTHERS THEN
-- 		GET STACKED DIAGNOSTICS v_error_stack=PG_EXCEPTION_CONTEXT, v_error_msg=MESSAGE_TEXT;
-- 		RAISE WARNING 'localAuthorityReport: %: %', v_error_msg, v_error_stack;
-- 		RETURN false;

END; $$
LANGUAGE 'plpgsql';


--select * from cqc.localAuthorityReportAdmin('2019-06-10'::DATE, '2019-08-10'::DATE);