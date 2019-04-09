select w.id as "ID", 
w.guid as "WorkerUID",  
w.establishment_id as " EstablishmentFK",
w.startdate as "MainJobStartDateValue",
w.ni_enc as "NationalInsuranceNumberValue",
w.dob_enc  as "DateOfBirthValue",
w.postcode as "PostcodeValue",
case 
       When w.gender=1 then 'Male' 
       when w.gender=2 then 'Female'
       when w.gender=3 then 'Unknown'
       when w.gender=4 then 'Other'
       when w.gender=null then 'Null'
end 
as   "GenderValue",
w.ethnicity as "EthnicityFKValue",
c.name as "NationalityValue",
case 
    when c.numeric='826' then 'British'
    when c.numeric='150' then 'Other'
end
as "NationalityValue",
c.name as "CountryOfBirthValue",

case 
    when w.isbritishcitizen=0 then 'No'
    when w.isbritishcitizen=1 then 'Yes'
    when w.isbritishcitizen=null then 'Null'
    when w.isbritishcitizen=-1 then 'Don''t know'
end
as "BritishCitizenshipValue"  ,
w.yearofentry as "YearArrivedYear",
w.startedinsector as "SocialCareStartDateYear",
w.dayssick as "DaysSickDays",

case 
    when w.zerohourcontract=0 then 'No'
    when w.zerohourcontract=1 then 'Yes'
    when w.zerohourcontract=null then 'Null'
    when w.zerohourcontract=-1 then 'Don''t know'
end
as "ZeroHoursContractValue",


case 
    when w.socialcarequalification=0 then 'No'
    when w.socialcarequalification=1 then 'Yes'
    when w.socialcarequalification=null then 'Null'
    when w.socialcarequalification=-1 then 'Don''t know'
end
as "QualificationInSocialCareValue"
from worker w, country c
where w.countryofbirth=c.numeric
;



