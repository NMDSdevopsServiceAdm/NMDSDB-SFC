
 select E."Name" as "EstablishmentName" ,W."EstablishmentFK" as "EstablishmentID" , count(0) as "TotalCount" from cqc."Worker" W, cqc."Establishment" E where W."EstablishmentFK"="EstablishmentID"  group by E."Name", W."EstablishmentFK" order by count(0);


