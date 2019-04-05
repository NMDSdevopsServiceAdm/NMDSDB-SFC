-- Monthly Report

select "EstablishmentName",
    "EstablishmentID",
    "TotalWorkers" ,
    "EmailAddress",
    case when "Vacancies" is null then 0 else "Vacancies" end,
    case when "Starters" is null then 0 else "Starters" end,
    case when "Leavers" is null then 0 else "Leavers" end
from (
    select
        "Establishment"."Name" "EstablishmentName",
        "Establishment"."EstablishmentID" "EstablishmentID",
        "Establishment"."NumberOfStaff" "TotalWorkers",
        "User"."EmailValue" "EmailAddress",
        sum(case when "JobType" = 'Vacancies' then "Total" end) "Vacancies",
        sum(case when "JobType" = 'Starters' then "Total" end) "Starters",
        sum(case when "JobType" = 'Leavers' then "Total" end) "Leavers"
    from cqc."EstablishmentJobs", cqc."Establishment",cqc."User"
    where "Establishment"."EstablishmentID" = "EstablishmentJobs"."EstablishmentID" and "Establishment"."EstablishmentID"="User"."EstablishmentID"
    group by "Establishment"."Name", "Establishment"."EstablishmentID","Establishment"."NumberOfStaff","User"."EmailValue"
) as MyWorker
order by "EstablishmentName" asc;



