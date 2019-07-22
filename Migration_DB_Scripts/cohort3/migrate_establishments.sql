-- Fixes for Cohort 3
-- Removed Address and FullAddress builder replaced with Address1, Address2, Address3, Town - merged in from establishment.x
-- Added ProvID merged in from establishment.registrationid

CREATE OR REPLACE FUNCTION migration.migrateestablishments_new_address()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
  AllEstablishments REFCURSOR;
  CurrentEstablishment RECORD;
  NotMapped VARCHAR(10);
  MappedEmpty VARCHAR(10);
  MigrationUser VARCHAR(10);
  ThisEstablishmentID INTEGER;
  NewEstablishmentUID UUID;
  MigrationTimestamp timestamp without time zone;
  NewIsRegulated BOOLEAN;
  NewEmployerType VARCHAR(40);
  NewIsCqcRegistered BOOLEAN;
BEGIN
  NotMapped := 'Not Mapped';
  MappedEmpty := 'Was empty';
  MigrationUser := 'migration';
  MigrationTimestamp := clock_timestamp();
  
  OPEN AllEstablishments FOR 	select
      e.id,
      e.name,
      e.address1,
      e.address2,
      e.address3,
      e.town,
      p.locationid,
	  p.registrationid,
      e.postcode,
      e.type as employertypeid,
      p.totalstaff as numberofstaff,
      e.nmdsid,
      e.createddate,
      e,visiblecsci,
      ms.sfcid as sfc_tribal_mainserviceid,
      "Establishment"."EstablishmentID" as newestablishmentid
    from establishment e
      inner join (
          select distinct establishment_id from establishment_user inner join users on establishment_user.user_id = users.id where users.mustchangepassword = 0
        ) allusers on allusers.establishment_id = e.id
      left join provision p
        inner join provision_servicetype pst inner join migration.services ms on pst.servicetype_id = ms.tribalid
          on pst.provision_id = p.id and pst.ismainservice = 1
        on p.establishment_id = e.id
	  left join cqc."Establishment" on "Establishment"."TribalID" = e.id
     where e.id in ( 1, 2,3,4,5,6)
     order by e.id asc;

  LOOP
    BEGIN
    FETCH AllEstablishments INTO CurrentEstablishment;
    EXIT WHEN NOT FOUND;

	RAISE NOTICE 'Processing tribal establishment: % (%)', CurrentEstablishment.id, CurrentEstablishment.newestablishmentid;
    IF CurrentEstablishment.newestablishmentid IS NOT NULL THEN
      -- we have already migrated this record - prepare to enrich/embellish the Establishment
      PERFORM migration.establishment_other_services(CurrentEstablishment.id, CurrentEstablishment.newestablishmentid);
      PERFORM migration.establishment_capacities(CurrentEstablishment.id, CurrentEstablishment.newestablishmentid);
      PERFORM migration.establishment_service_users(CurrentEstablishment.id, CurrentEstablishment.newestablishmentid);
      PERFORM migration.establishment_local_authorities(CurrentEstablishment.id, CurrentEstablishment.newestablishmentid, CurrentEstablishment.visiblecsci);
      PERFORM migration.establishment_jobs(CurrentEstablishment.id, CurrentEstablishment.newestablishmentid);
    ELSE
      -- we have not yet migrated this record because there is no "newestablishmentid" - prepare a basic Establishment for inserting

      -- target Establishment needs a UID; unlike User, there is no UID in tribal dataset
      SELECT CAST(substr(CAST(v1uuid."UID" AS TEXT), 0, 15) || '4' || substr(CAST(v1uuid."UID" AS TEXT), 16, 3) || '-89' || substr(CAST(v1uuid."UID" AS TEXT), 22, 36) AS UUID)
        FROM (
          SELECT uuid_in(md5(random()::text || clock_timestamp()::text)::cstring) "UID"
        ) v1uuid
      INTO NewEstablishmentUID;

      CASE CurrentEstablishment.locationid
        WHEN NULL THEN
          NewIsRegulated = false;
        ELSE
          NewIsRegulated = true;
      END CASE;

      CASE CurrentEstablishment.employertypeid
        WHEN 130 THEN
          NewEmployerType = 'Local Authority (adult services)';
        WHEN 131 THEN
          NewEmployerType = 'Local Authority (generic/other)';
        WHEN 132 THEN
          NewEmployerType = 'Local Authority (generic/other)';
        WHEN 133 THEN
          NewEmployerType = 'Local Authority (generic/other)';
        WHEN 134 THEN
          NewEmployerType = 'Other';
        WHEN 135 THEN
          NewEmployerType = 'Private Sector';
        WHEN 136 THEN
          NewEmployerType = 'Voluntary / Charity';
        WHEN 137 THEN
          NewEmployerType = 'Other';
        WHEN 138 THEN
          NewEmployerType = 'Private Sector';
        ELSE
          NewEmployerType = 'Other';
      END CASE;
      
      SELECT nextval('cqc."Establishment_EstablishmentID_seq"') INTO ThisEstablishmentID;
      INSERT INTO cqc."Establishment" (
        "EstablishmentID",
        "TribalID",
        "EstablishmentUID",
        "NameValue",
        "MainServiceFKValue",
        "Address1",
        "Address2",
        "Address3",
        "Town",
		"ProvID",
		"ReasonsForLeaving",
        "LocationID",
        "PostCode",
        "IsRegulated",
        "NmdsID",
        "EmployerTypeValue",
        "NumberOfStaffValue",
        "created",
        "updated",
        "updatedby"
      ) VALUES (
        ThisEstablishmentID,
        CurrentEstablishment.id,
        NewEstablishmentUID,
        CurrentEstablishment.name,
        CurrentEstablishment.sfc_tribal_mainserviceid,
		CurrentEstablishment.address1,
		CurrentEstablishment.address2,
		CurrentEstablishment.address3,
		CurrentEstablishment.town,
		CurrentEstablishment.registrationid,
		NULL,
        CurrentEstablishment.locationid,
        CurrentEstablishment.postcode,
        NewIsRegulated,
        CurrentEstablishment.nmdsid,
        NewEmployerType::cqc.est_employertype_enum,
        CurrentEstablishment.numberofstaff,
        CurrentEstablishment.createddate,
        MigrationTimestamp,
        MigrationUser
        );

      -- having inserted the new establishment, adorn with additional properties
      PERFORM migration.establishment_other_services(CurrentEstablishment.id, ThisEstablishmentID);
      PERFORM migration.establishment_capacities(CurrentEstablishment.id, ThisEstablishmentID);
      PERFORM migration.establishment_service_users(CurrentEstablishment.id, ThisEstablishmentID);
      PERFORM migration.establishment_local_authorities(CurrentEstablishment.id, ThisEstablishmentID, CurrentEstablishment.visiblecsci);
      PERFORM migration.establishment_jobs(CurrentEstablishment.id, ThisEstablishmentID);

    END IF;

    --EXCEPTION WHEN OTHERS THEN RAISE WARNING 'Skipping establishment with id: %', CurrentEstablishment.id;
  END;
  END LOOP;

END;
$function$
