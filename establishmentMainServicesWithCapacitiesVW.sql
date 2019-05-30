DROP VIEW IF EXISTS cqc."AnnS";
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
UNION
SELECT
	"EstablishmentID",
	CASE WHEN "CAPACITY1" is null THEN -1 ELSE "CAPACITY1" END,
	null "CAPACITY2"
FROM (
	SELECT
		"EstablishmentID",
		SUM("Answer") FILTER(WHERE "Sequence"=1) "CAPACITY1"
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
          		  AND services.id in (SELECT DISTINCT "ServiceID" FROM cqc."ServicesCapacity" GROUP BY "ServiceID" HAVING COUNT(0) = 1)
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
	GROUP BY "EstablishmentID") AS "EstablishmentMainServicesWithCapacitiesTwo";