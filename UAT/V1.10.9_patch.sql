CREATE TYPE cqc."worker_registerednurses_enum" AS ENUM (
    'Adult Nurse',
    'Mental Health Nurse',
    'Learning Disabilities Nurse',
    'Children''s Nurse',
    'Enrolled Nurse'
);

ALTER TABLE cqc."Worker" DROP COLUMN "RegisteredNurseValue";
ALTER TABLE cqc."Worker" ADD COLUMN "RegisteredNurseValue" cqc."worker_registerednurses_enum" NULL;
DROP TYPE IF EXISTS cqc."worker_registerednurse_enum";
