desc PF0645.diabetes;
select * from PF0645.discharge_disposition;
select * from PF0645.admission_type;
select * from PF0645.admission_source;

DROP TABLE diabetes;
DROP TABLE discharge_disposition;
DROP TABLE admission_type;
DROP TABLE admission_source;

CREATE TABLE diabetes
    AS
        SELECT
            *
        FROM
            pf0645.diabetes;

CREATE TABLE discharge_disposition
    AS
        SELECT
            *
        FROM
            pf0645.discharge_disposition;

CREATE TABLE admission_type
    AS
        SELECT
            *
        FROM
            pf0645.admission_type;

CREATE TABLE admission_source
    AS
        SELECT
            *
        FROM
            pf0645.admission_source;

ALTER TABLE diabetes ADD CONSTRAINT diabetes_pk PRIMARY KEY ( encounter_id );

ALTER TABLE discharge_disposition ADD CONSTRAINT DISCHARGE_DISPOSITION_PK PRIMARY KEY ( discharge_disposition_id );

ALTER TABLE admission_type ADD CONSTRAINT ADMISSION_TYPE_PK PRIMARY KEY ( admission_type_id );

ALTER TABLE admission_source ADD CONSTRAINT ADMISSION_SOURCE_PK PRIMARY KEY ( admission_source_id );

ALTER TABLE diabetes
    ADD CONSTRAINT diabetes_admission_source_fk FOREIGN KEY ( admission_source_id )
        REFERENCES admission_source ( admission_source_id )
    ADD CONSTRAINT diabetes_admission_type_fk FOREIGN KEY ( admission_type_id )
        REFERENCES admission_type ( admission_type_id )
    ADD CONSTRAINT diabetes_discharge_disposition_fk FOREIGN KEY ( discharge_disposition_id )
        REFERENCES discharge_disposition ( discharge_disposition_id );