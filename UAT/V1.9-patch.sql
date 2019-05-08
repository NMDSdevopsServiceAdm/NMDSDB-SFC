-- additional qualifications for mapping - https://trello.com/c/lcIxIvdw
INSERT INTO cqc."Qualifications" ("ID", "Seq", "Group", "Title", "Code", "From", "Until", "Level", "MultipleLevel", "RelevantToSocialCare", "AnalysisFileCode") VALUES 
  (134, 675, 'Certificate','Any other social care relevant certificate', 113, '2018-01-01', NULL,NULL, 'No', 'Yes', 'unknown'),
  (135, 676, 'Certificate','Any other non-social care relevant certificate', 114, '2018-01-01', NULL,NULL, 'No', 'No', 'unknown');

UPDATE cqc."Qualifications"
SET "Level" = NULL
WHERE "ID" in (25, 26, 89, 113, 114, 115, 116);


-- Additional service capacities -  https://trello.com/c/O1RxWYlU
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (17, 21, 1, 'Number of people receiving care on the completion date');
INSERT INTO cqc."ServicesCapacity" ("ServiceCapacityID", "ServiceID", "Sequence", "Question") values (18, 23, 1, 'Number of people using the service on the completion date');
