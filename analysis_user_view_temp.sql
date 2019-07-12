DROP VIEW IF EXISTS "cqc"."AllEstablishmentAndWorkersVW";
CREATE OR REPLACE VIEW "cqc"."AllEstablishmentAndWorkersVW" AS
select
	"Login"."Username" AS "Username",
	"Login"."Active" AS "IsActive",
	"Login"."LastLoggedIn" AS "LastLoggedIn",
	"Login"."PasswdLastChanged" AS "PasswdLastChanged",
	"User"."RegistrationID" AS "UserID",
	"User"."UserUID" AS "UserUID",
	"User"."FullNameValue" AS "FullName",
	"User"."EmailValue" AS "Email",
	"User"."PhoneValue" AS "Phone",
	"User"."SecurityQuestionValue" AS "SecurityQuestion",
	"User"."SecurityQuestionAnswerValue" AS "SecurityAnswer",
	"User"."UserRoleValue" AS "UserRole",
	"User"."IsPrimary" AS "IsPrimary",
	"User".updated AS "LastUpdated",
	"Establishment"."EstablishmentUID" AS "EstablishmentUID",
	"Establishment"."PostCode" AS "EstablishmentPostcode",
	"Establishment"."NmdsID" AS "EstablishmentNDMSID",
	"Establishment"."NameValue" AS "EstablishmentName"
from cqc."User"
	inner join cqc."Login" on "User"."RegistrationID" = "Login"."RegistrationID"
	inner join cqc."Establishment" on "Establishment"."EstablishmentID" = "User"."EstablishmentID"
where
	"User"."Archived" = false and
	"Establishment"."Archived" = false;