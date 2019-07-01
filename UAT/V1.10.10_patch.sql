ALTER TABLE cqc."Worker" ADD COLUMN "LocalIdentifier" TEXT NULL;

ALTER TABLE ONLY cqc."Worker"
    ADD CONSTRAINT "worker_LocalIdentifier_unq" UNIQUE ("LocalIdentifier", "EstablishmentFK");