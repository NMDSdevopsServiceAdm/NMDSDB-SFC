select e.id as "EstablishmentID",e.name as "Name", e.address1 ||e. address2 ||e. address3||e. town  as "Address",p.locationid as "LocacationID",e.postcode as "PostCode" ,st.iscqcregistered as "IsRegulated",li.name as "EmployerType",p.Totalstaff as "NumberOfStaff"  ,e.nmdsid as "NmdsID"
from lookupitem li,provision p , establishment e, provision_servicetype ps , servicetype st
where e.id = p.establishment_id and p.id = ps.provision_id and ps.servicetype_id = st.id and e.type=li.id

