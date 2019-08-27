-- https://trello.com/c/GbaEC88q

update
	cqc."Establishment"
set
	"LastWdfEligibility" = TheSource.achieveddate::timestamp with time zone
from cqc."20190819_wdf" as TheSource
where "Establishment"."TribalID" = TheSource.tribalid;

update
	cqc."Worker"
set
	"LastWdfEligibility" = TheSource.achieveddate::timestamp with time zone
from cqc."Establishment"
	inner join cqc."20190819_wdf" as TheSource on "Establishment"."TribalID" = TheSource.tribalid
where "Establishment"."EstablishmentID" = "Worker"."EstablishmentFK";
