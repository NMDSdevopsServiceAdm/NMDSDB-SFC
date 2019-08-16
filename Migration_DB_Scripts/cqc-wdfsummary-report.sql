DROP FUNCTION IF EXISTS cqc.wdfsummaryreport;
CREATE OR REPLACE FUNCTION cqc.wdfsummaryreport(effectiveDate DATE)
 RETURNS TABLE (
	"NmdsID" text,
    "EstablishmentID" integer,
    "EstablishmentName" text,
    "Address1" text,
    "Address2" text,
    "PostCode" text,
    "Region" text,
    "CSSR" text,
    "EstablishmentUpdated" timestamp with time zone,
    "ParentID" integer,
    "OverallWdfEligibility" timestamp with time zone,
    "ParentNmdsID" text,
    "ParentEstablishmentID" integer,
    "ParentName" text,
    "WorkerCount" bigint,
    "WorkerCompletedCount" bigint
) 
AS $$
BEGIN
   RETURN QUERY select
	"Establishment"."NmdsID"::text,
	"Establishment"."EstablishmentID",
	"Establishment"."NameValue" AS "EstablishmentName",
	"Establishment"."Address1",
	"Establishment"."Address2",
	"Establishment"."PostCode",
	pcode.region as "Region",
	pcode.cssr as "CSSR",
	"Establishment".updated,
	"Establishment"."ParentID",
	"Establishment"."OverallWdfEligibility",
	parents."NmdsID"::text As "ParentNmdsID",
	parents."EstablishmentID" AS "ParentEstablishmentID",
	parents."NameValue" AS "ParentName",
	COUNT(workers."ID") filter (where workers."ID" is not null) as "WorkerCount",
    COUNT(workers."ID") filter (where workers."LastWdfEligibility" > effectiveDate) as "WorkerCompletedCount"
from cqc."Establishment"
	left join cqcref.pcode on pcode.postcode = "Establishment"."PostCode"
	left join cqc."Establishment" as parents on parents."EstablishmentID" = "Establishment"."ParentID"
	left join cqc."Worker" as workers on workers."EstablishmentFK" = "Establishment"."EstablishmentID" and workers."Archived"=false
where "Establishment"."Archived"=false
  and ("Establishment"."ParentID"=479 OR "Establishment"."EstablishmentID"=479)
group by
	"Establishment"."NmdsID",
	"Establishment"."EstablishmentID",
	"Establishment"."NameValue",
	"Establishment"."Address1",
	"Establishment"."Address2",
	"Establishment"."PostCode",
	pcode.region,
	pcode.cssr,
	"Establishment".updated,
	"Establishment"."ParentID",
	"Establishment"."OverallWdfEligibility",
	parents."NmdsID",
	parents."EstablishmentID",
	parents."NameValue";
END; $$
LANGUAGE 'plpgsql';

-- select * from cqc.wdfsummaryreport('2019-04-01'::date)