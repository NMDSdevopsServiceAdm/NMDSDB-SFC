

--https://trello.com/c/CKuDXAbq
update cqc."Establishment" set "MainServiceFKValue"=20 where "EstablishmentID"=340 and "LocationID"='1-5254278626';

--Verify the change reflected in table

\x

select count(0) from cqc."Establishment" where  "EstablishmentID"=340 and "LocationID"='1-5254278626';



--https://trello.com/c/oeYhp3Ui


update cqc."Establishment" set "IsRegulated"=True,"LocationID"='1-5400068426' where "EstablishmentID"=337 ;

--Verify the change reflected in table

select count(0) from cqc."Establishment" where "EstablishmentID"=337 ;


-- Date 16 May 2019

-- https://trello.com/c/Ypwr3hZ4/55-remove-parent-cohort-2-users-from-asc-wds

--Deletion data view before we delete the Establishment and related records

-- Selection based on Tribal ID [196840,170258]


select "TribalID"   from cqc."Establishment" where "NmdsID" IN ('E302906','G260465');

SELECT count(0) FROM cqc."Worker" where "TribalID" in (select "TribalID" from cqc."Establishment" where "NmdsID" IN ('E302906','G260465')) ;

select  count(0)    from cqc."WorkerQualification" where "TribalID" in (170258, 196840);
  select  count(0)    from cqc."WorkerTraining" where "TribalID"  in (170258, 196840);
  select  count(0)    from cqc."WorkerAudit" where "WorkerFK" in (select distinct "ID" from cqc."Worker" where "TribalID"  in (170258, 196840));
  select  count(0)    from cqc."WorkerJobs" where "WorkerFK" in (select distinct "ID" from cqc."Worker" where "TribalID"  in (170258, 196840));
  select  count(0)    from cqc."Worker" where "TribalID"  in (170258, 196840);
  select  count(0)    from cqc."EstablishmentCapacity" where "EstablishmentID" in (select distinct "EstablishmentID" from cqc."Establishment" where "TribalID"  in (170258, 196840));
  select  count(0)    from cqc."EstablishmentJobs" where "EstablishmentID" in (select distinct "EstablishmentID" from cqc."Establishment" where "TribalID"  in (170258, 196840));
  select  count(0)    from cqc."EstablishmentServices" where "EstablishmentID" in (select distinct "EstablishmentID" from cqc."Establishment" where "TribalID"  in (170258, 196840));
  select  count(0)    from cqc."EstablishmentLocalAuthority" where "EstablishmentID" in (select distinct "EstablishmentID" from cqc."Establishment" where "TribalID"  in (170258, 196840));
  select  count(0)    from cqc."EstablishmentServiceUsers" where "EstablishmentID" in (select distinct "EstablishmentID" from cqc."Establishment" where "TribalID"  in (170258, 196840));

  select  count(0)    from cqc."Login" where "RegistrationID" in (select distinct "RegistrationID" from cqc."User" where "TribalID"  in (170258, 196840));
  select  count(0)    from cqc."UserAudit" where "UserFK" in (select distinct "RegistrationID" from cqc."User" where "TribalID"  in (170258, 196840));
  select  count(0)    from cqc."PasswdResetTracking" where "UserFK" in (select distinct "RegistrationID" from cqc."User" where "TribalID"  in (170258, 196840));
  select  count(0)    from cqc."User" where "TribalID"  in (170258, 196840);
  select  count(0)    from cqc."EstablishmentAudit" where "EstablishmentFK" in (select distinct "EstablishmentID" from cqc."Establishment" where "TribalID"  in (170258, 196840));
  select  count(0)    from cqc."Establishment" where "TribalID"  in (170258, 196840);

--- Record Deletion 

-- Deletion based on Tribal ID [196840,170258]

delete from cqc."WorkerQualifications" where "TribalID" in (170258, 196840);
  delete from cqc."WorkerTraining" where "TribalID"  in (170258, 196840);
  delete from cqc."WorkerAudit" where "WorkerFK" in (select distinct "ID" from cqc."Worker" where "TribalID"  in (170258, 196840));
  delete from cqc."WorkerJobs" where "WorkerFK" in (select distinct "ID" from cqc."Worker" where "TribalID"  in (170258, 196840));
  delete from cqc."Worker" where "TribalID"  in (170258, 196840);
  delete from cqc."EstablishmentCapacity" where "EstablishmentID" in (select distinct "EstablishmentID" from cqc."Establishment" where "TribalID"  in (170258, 196840));
  delete from cqc."EstablishmentJobs" where "EstablishmentID" in (select distinct "EstablishmentID" from cqc."Establishment" where "TribalID"  in (170258, 196840));
  delete from cqc."EstablishmentServices" where "EstablishmentID" in (select distinct "EstablishmentID" from cqc."Establishment" where "TribalID"  in (170258, 196840));
  delete from cqc."EstablishmentLocalAuthority" where "EstablishmentID" in (select distinct "EstablishmentID" from cqc."Establishment" where "TribalID"  in (170258, 196840));
  delete from cqc."EstablishmentServiceUsers" where "EstablishmentID" in (select distinct "EstablishmentID" from cqc."Establishment" where "TribalID"  in (170258, 196840));

  delete from cqc."Login" where "RegistrationID" in (select distinct "RegistrationID" from cqc."User" where "TribalID"  in (170258, 196840));
  delete from cqc."UserAudit" where "UserFK" in (select distinct "RegistrationID" from cqc."User" where "TribalID"  in (170258, 196840));
  delete from cqc."PasswdResetTracking" where "UserFK" in (select distinct "RegistrationID" from cqc."User" where "TribalID"  in (170258, 196840));
  delete from cqc."User" where "TribalID"  in (170258, 196840);
  delete from cqc."EstablishmentAudit" where "EstablishmentFK" in (select distinct "EstablishmentID" from cqc."Establishment" where "TribalID"  in (170258, 196840));
  delete from cqc."Establishment" where "TribalID"  in (170258, 196840);


--- Deletion Verification 

-- Selection based on Tribal ID [196840,170258]


select "TribalID"   from cqc."Establishment" where "NmdsID" IN ('E302906','G260465');

SELECT count(0) FROM cqc."Worker" where "TribalID" in (select "TribalID" from cqc."Establishment" where "NmdsID" IN ('E302906','G260465')) ;

select  count(0)    from cqc."WorkerQualification" where "TribalID" in (170258, 196840);
  select  count(0)    from cqc."WorkerTraining" where "TribalID"  in (170258, 196840);
  select  count(0)    from cqc."WorkerAudit" where "WorkerFK" in (select distinct "ID" from cqc."Worker" where "TribalID"  in (170258, 196840));
  select  count(0)    from cqc."WorkerJobs" where "WorkerFK" in (select distinct "ID" from cqc."Worker" where "TribalID"  in (170258, 196840));
  select  count(0)    from cqc."Worker" where "TribalID"  in (170258, 196840);
  select  count(0)    from cqc."EstablishmentCapacity" where "EstablishmentID" in (select distinct "EstablishmentID" from cqc."Establishment" where "TribalID"  in (170258, 196840));
  select  count(0)    from cqc."EstablishmentJobs" where "EstablishmentID" in (select distinct "EstablishmentID" from cqc."Establishment" where "TribalID"  in (170258, 196840));
  select  count(0)    from cqc."EstablishmentServices" where "EstablishmentID" in (select distinct "EstablishmentID" from cqc."Establishment" where "TribalID"  in (170258, 196840));
  select  count(0)    from cqc."EstablishmentLocalAuthority" where "EstablishmentID" in (select distinct "EstablishmentID" from cqc."Establishment" where "TribalID"  in (170258, 196840));
  select  count(0)    from cqc."EstablishmentServiceUsers" where "EstablishmentID" in (select distinct "EstablishmentID" from cqc."Establishment" where "TribalID"  in (170258, 196840));

  select  count(0)    from cqc."Login" where "RegistrationID" in (select distinct "RegistrationID" from cqc."User" where "TribalID"  in (170258, 196840));
  select  count(0)    from cqc."UserAudit" where "UserFK" in (select distinct "RegistrationID" from cqc."User" where "TribalID"  in (170258, 196840));
  select  count(0)    from cqc."PasswdResetTracking" where "UserFK" in (select distinct "RegistrationID" from cqc."User" where "TribalID"  in (170258, 196840));
  select  count(0)    from cqc."User" where "TribalID"  in (170258, 196840);
  select  count(0)    from cqc."EstablishmentAudit" where "EstablishmentFK" in (select distinct "EstablishmentID" from cqc."Establishment" where "TribalID"  in (170258, 196840));
  select  count(0)    from cqc."Establishment" where "TribalID"  in (170258, 196840);


