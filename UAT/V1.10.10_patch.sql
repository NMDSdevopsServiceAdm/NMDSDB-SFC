
ALTER TABLE cqc."Worker" ADD COLUMN "LocalIdentifierValue" TEXT NULL;
ALTER TABLE cqc."Worker" ADD COLUMN "LocalIdentifierSavedAt" TEXT NULL;
ALTER TABLE cqc."Worker" ADD COLUMN "LocalIdentifierSavedBy" TEXT NULL;
ALTER TABLE cqc."Worker" ADD COLUMN "LocalIdentifierChangedAt" TEXT NULL;
ALTER TABLE cqc."Worker" ADD COLUMN "LocalIdentifierChangedBy" TEXT NULL;

ALTER TABLE ONLY cqc."Worker"
    ADD CONSTRAINT "worker_LocalIdentifier_unq" UNIQUE ("LocalIdentifierValue", "EstablishmentFK");


