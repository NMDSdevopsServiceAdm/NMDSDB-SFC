 
Select distinct e."EstablishmentID", e."Name",e."PostCode",c."CssR",c."Region" from cqc."Establishment" e, cqc."Cssr" c,cqcref.pcodedata p,cqcref.location l where
c."LocalCustodianCode"=p.local_custodian_code and 
e."PostCode"=p.postcode and 
e."LocationID"=l.locationid
ORDER BY e."EstablishmentID";



