

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

--  https://trello.com/c/fvIRUygY
--Update the Login for user to be deleted.
--Check the User to be renamed
\x

select * from cqc."Login"  where "RegistrationID"=2402 and "Username"='watkinwytch';

update cqc."Login"  set "Username"='tobedeleted_193084_watkinwytch',
"TribalHash"=null,
"Hash"=null
 where "Username"='watkinwytch';

--verify the update ....



select * from cqc."Login" where "RegistrationID"=2402;

---Date 05 June 2019

----             https://trello.com/c/3plMq2kV

\x

--Checking the Main Service for requested change
select * from  cqc.services where id=23;

---Showing Main Service on existing
select * from  cqc.services where id=20;

---Record of existing Main Service

select * from cqc."Establishment" where "EstablishmentID"=2530 and "TribalID"='2533' and "NmdsID"='E70709';

--- Updating the Main Service

update cqc."Establishment" set "MainServiceFKValue"=23 where "EstablishmentID"=2530 and "TribalID"='2533' and "NmdsID"='E70709';

--Verify the change
select * from cqc."Establishment" where "EstablishmentID"=2530 and "TribalID"='2533' and "NmdsID"='E70709';


--       https://trello.com/c/RosKNoF4

--- Comments from Jackie Green

---    "Location ID should be 1-6299627829. This is another with null @peterwoodford "

--Check the record before update

Select "EstablishmentID", "NameValue", "Address", "LocationID", "PostCode", "IsRegulated", "MainServiceFKValue", "EmployerTypeValue", "ShareDataWithCQC", "ShareDataWithLA", "ShareDataValue", "NumberOfStaffValue", "NmdsID", "NmdsID", "EstablishmentUID" from cqc."Establishment" where "EstablishmentID"=331;

--Update the record 

Update cqc."Establishment" set "LocationID"='1-6299627829' where "EstablishmentID"=331;

-- Verify update is being done.

Select "EstablishmentID", "NameValue", "Address", "LocationID", "PostCode", "IsRegulated", "MainServiceFKValue", "EmployerTypeValue", "ShareDataWithCQC", "ShareDataWithLA", "ShareDataValue", "NumberOfStaffValue", "NmdsID", "NmdsID", "EstablishmentUID" from cqc."Establishment" where "EstablishmentID"=331;




-------------------------------- 11 June 2019 -------------------








----       https://trello.com/c/qYPIOtEp

--- Comments from Jackie Green

---    "Location ID should be 1-6210509431. This is another with null @peterwoodford "

--Check the record before update

Select "EstablishmentID", "NameValue", "Address", "LocationID", "PostCode", "IsRegulated", "MainServiceFKValue", "EmployerTypeValue", "ShareDataWithCQC", "ShareDataWithLA", "ShareDataValue", "NumberOfStaffValue", "NmdsID", "NmdsID", "EstablishmentUID" from cqc."Establishment" where "EstablishmentID"=326;

--Update the record

Update cqc."Establishment" set "LocationID"='1-6210509431' where "EstablishmentID"=326;

-- Verify update is being done.

Select "EstablishmentID", "NameValue", "Address", "LocationID", "PostCode", "IsRegulated", "MainServiceFKValue", "EmployerTypeValue", "ShareDataWithCQC", "ShareDataWithLA", "ShareDataValue", "NumberOfStaffValue", "NmdsID", "NmdsID", "EstablishmentUID" from cqc."Establishment" where "EstablishmentID"=326;


---- https://trello.com/c/tlVhbsS://trello.com/c/tlVhbsSk
Check the record before update

Select "EstablishmentID", "NameValue", "Address", "LocationID", "PostCode", "IsRegulated", "MainServiceFKValue", "EmployerTypeValue", "ShareDataWithCQC", "ShareDataWithLA", "ShareDataValue", "NumberOfStaffValue", "NmdsID", "NmdsID", "EstablishmentUID" from cqc."Establishment" where "EstablishmentID"=391;

--Update the record
update cqc."Establishment" set "Address"='Bluecoats,Thatcham' ,"PostCode"='RG18 4AE' where "EstablishmentID"=391;

-- Verify update is being done.

Select "EstablishmentID", "NameValue", "Address", "LocationID", "PostCode", "IsRegulated", "MainServiceFKValue", "EmployerTypeValue", "ShareDataWithCQC", "ShareDataWithLA", "ShareDataValue", "NumberOfStaffValue", "NmdsID", "NmdsID", "EstablishmentUID" from cqc."Establishment" where "EstablishmentID"=391;




