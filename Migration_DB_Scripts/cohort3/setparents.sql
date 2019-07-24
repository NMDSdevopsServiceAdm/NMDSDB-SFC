-- FUNCTION: migration.setparents()

-- DROP FUNCTION migration.setparents();

CREATE OR REPLACE FUNCTION migration.setparents(
	)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
BEGIN

	update cqc."Establishment" est
		set "ParentID" = npe."EstablishmentID", "ParentUID" = npe."EstablishmentUID"
		from cqc."Establishment" nce
			left join establishment oce on oce.id=nce."TribalID"
			left join cqc."Establishment" npe on oce.parentid=npe."TribalID"
		where nce."EstablishmentID"=est."EstablishmentID";

END;
$BODY$;

ALTER FUNCTION migration.setparents()
    OWNER TO postgres;
