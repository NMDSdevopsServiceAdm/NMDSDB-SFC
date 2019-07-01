-- https://trello.com/c/AscBN35F/47-18-bulk-upload-local-identifiers-establishment

ALTER TABLE cqc."Establishment" ADD COLUMN "LocalIdentifier" TEXT NULL;

ALTER TABLE ONLY cqc."Establishment"
    ADD CONSTRAINT "establishment_LocalIdentifier_unq" UNIQUE ("LocalIdentifier");
