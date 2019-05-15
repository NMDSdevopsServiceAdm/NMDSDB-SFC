-- https://trello.com/c/ikScd2O3 - parents & subs - view my workplaces


CREATE TYPE cqc.establisgment_owner AS ENUM (
    'Workplace',
    'Parent'
);

CREATE TYPE cqc.establisgment_owner_access_permission AS ENUM (
    'Workplace',
    'Staff'
);

ALTER TABLE cqc."Establishment" ADD COLUMN "Owner" cqc.establisgment_owner NOT NULL DEFAULT 'Workplace';
ALTER TABLE cqc."Establishment" ADD COLUMN "OwnerDataAccess" cqc.establisgment_owner_access_permission NULL;
