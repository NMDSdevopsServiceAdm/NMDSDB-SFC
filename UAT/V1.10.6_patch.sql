UPDATE 
	cqc."ServicesCapacity"
SET
	"Type"='Utilisation'
WHERE
	"ServiceID" in (11, 13, 18, 20, 22, 35);


INSERT INTO cqc."ServicesCapacity"
("ServiceCapacityID", "ServiceID", "Question", "Sequence", "Type")
VALUES(17, 19, 'Total places Number of people using the service on the completion date', 1, 'Capacity');
