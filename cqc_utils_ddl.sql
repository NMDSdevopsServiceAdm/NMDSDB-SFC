DROP FUNCTION IF EXISTS cqc.EstablishlmentIdFromNmdsID;
CREATE OR REPLACE FUNCTION cqc.EstablishlmentIdFromNmdsID(_nmdsid VARCHAR)
  RETURNS INTEGER AS $$
DECLARE
	establishmentID INTEGER;
BEGIN
  select "EstablishmentID" from cqc."Establishment" where "NmdsID" ilike _nmdsid into establishmentID;
  return establishmentID;
END;
$$ LANGUAGE plpgsql;
DROP FUNCTION IF EXISTS cqc.EstablishlmentIdFromTribalId;
CREATE OR REPLACE FUNCTION cqc.EstablishlmentIdFromTribalId(_tribalID INTEGER)
  RETURNS INTEGER AS $$
DECLARE
	establishmentID INTEGER;
BEGIN
  select "EstablishmentID" from cqc."Establishment" where "TribalID"=_tribalID into establishmentID;
  return establishmentID;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS cqc.PurgeEstablishlment;
CREATE OR REPLACE FUNCTION cqc.PurgeEstablishlment(_estId INTEGER)
  RETURNS void AS $$
DECLARE
BEGIN
  delete from cqc."WorkerQualifications" where "WorkerFK" in (select distinct "ID" from cqc."Worker" where "EstablishmentFK"=_estId);
  delete from cqc."WorkerTraining" where "WorkerFK" in (select distinct "ID" from cqc."Worker" where "EstablishmentFK"=_estId);
  delete from cqc."WorkerAudit" where "WorkerFK" in (select distinct "ID" from cqc."Worker" where "EstablishmentFK"=_estId);
  delete from cqc."WorkerJobs" where "WorkerFK" in (select distinct "ID" from cqc."Worker" where "EstablishmentFK"=_estId);
  delete from cqc."Worker" where "EstablishmentFK"=_estId;
  delete from cqc."EstablishmentCapacity" where "EstablishmentID"=_estId;
  delete from cqc."EstablishmentJobs" where "EstablishmentID"=_estId;
  delete from cqc."EstablishmentServices" where "EstablishmentID"=_estId;
  delete from cqc."EstablishmentLocalAuthority" where "EstablishmentID"=_estId;
  delete from cqc."EstablishmentServiceUsers" where "EstablishmentID"=_estId;

  delete from cqc."Login" where "RegistrationID" in (select distinct "RegistrationID" from cqc."User" where "EstablishmentID"=_estId);
  delete from cqc."UserAudit" where "UserFK" in (select distinct "RegistrationID" from cqc."User" where "EstablishmentID"=_estId);
  delete from cqc."PasswdResetTracking" where "UserFK" in (select distinct "RegistrationID" from cqc."User" where "EstablishmentID"=_estId);
  delete from cqc."User" where "EstablishmentID"=_estId;
  delete from cqc."EstablishmentAudit" where "EstablishmentFK"=_estId;
  delete from cqc."Establishment" where "EstablishmentID"=_estId;
END;
$$ LANGUAGE plpgsql;
