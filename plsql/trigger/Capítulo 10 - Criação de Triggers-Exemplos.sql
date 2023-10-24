----------------------------------------------------------------------------------------------------------------
--EXEMPLO 1
----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER secure_emp
BEFORE INSERT ON employees 
BEGIN
 --IF (TO_CHAR(SYSDATE,'DY') IN ('SAT','SUN')) OR (TO_CHAR(SYSDATE,'HH24:MI') 
 --NOT BETWEEN '08:00' AND '18:00') THEN
  IF (TO_CHAR(SYSDATE,'HH24:MI') BETWEEN '08:00' AND '12:00') THEN
  RAISE_APPLICATION_ERROR(-20500, 'You may insert '
                           ||' into EMPLOYEES table only during '
                           ||' business hours.');
  END IF;
END;
/

-- TESTANDO EXEMPLO 1...

insert into employees
values (1234,null,'Xiuderico','xiuderico@Xiuderico_inc.com',null,
       sysdate,'IT_PROG',null,null,null,null);

----------------------------------------------------------------------------------------------------------------
--EXEMPLO 2
----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER secure_emp
BEFORE
INSERT OR UPDATE OR DELETE ON employees 
BEGIN
 --IF (TO_CHAR(SYSDATE,'DY') IN ('SAT','SUN')) OR
   IF  (TO_CHAR(SYSDATE,'HH24')    BETWEEN '08' AND '18') THEN
   IF DELETING THEN 
      RAISE_APPLICATION_ERROR(-20502,'You may delete from EMPLOYEES table '||
                                              'only during business hours.');
   ELSIF INSERTING THEN 
        RAISE_APPLICATION_ERROR(-20500,'You may insert into EMPLOYEES table '|| 
                                             'only during business hours.');
   ELSIF UPDATING('SALARY') THEN
        RAISE_APPLICATION_ERROR(-20503, 'You may '||
                                'update SALARY only during business hours.');
   ELSE 
       RAISE_APPLICATION_ERROR(-20504,'You may'||
        ' update EMPLOYEES table only during'||
         ' normal hours.');
   END IF;
 END IF;
END;
/

-- TESTANDO EXEMPLO 2...

insert into employees
values (1234,null,'Xiuderico','xiuderico@Xiuderico_inc.com',
        null,sysdate,'IT_PROG',null,null,null,null);

update employees
set salary=25000
where employee_id=100;

delete from employees
where employee_id=127;

ALTER TRIGGER secure_emp DISABLE;
----------------------------------------------------------------------------------------------------------------
--EXEMPLO 3
----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER restrict_salary
BEFORE INSERT OR UPDATE OF salary ON employees
FOR EACH ROW
DECLARE
BEGIN
  IF NOT (:NEW.job_id IN ('AD_PRES', 'AD_VP')) 
     AND
     :NEW.salary > 15000 THEN
    RAISE_APPLICATION_ERROR (-20202, 'Employee cannot earn more than $15,000.');
  END IF;
END;
/
-- TESTANDO EXEMPLO 3...

UPDATE EMPLOYEES
SET SALARY = 100000
WHERE DEPARTMENT_ID=80;

insert into employees
values (1234,null,'Xiuderico','a@a.com.b',null,sysdate,'IT_PROG',17000,null,null,null);

----------------------------------------------------------------------------------------------------------------
--EXEMPLO 4
----------------------------------------------------------------------------------------------------------------
-- TABELA DE AUDITORIA

drop table audit_emp;

create table audit_emp (
user_name      varchar(100), 
time_stamp     date, 
id             number(5),
old_last_name  varchar(100), 
new_last_name  varchar(100),  
old_title      varchar(100), 
new_title      varchar(100),  
old_salary     NUMBER(8,2) ,
new_salary     NUMBER(8,2));

-- GATILHO DE AUDITORIA

CREATE OR REPLACE TRIGGER audit_emp_values
before DELETE OR INSERT OR UPDATE ON employees
FOR EACH ROW
BEGIN
  INSERT INTO 
     audit_emp(user_name, 
               time_stamp, 
               id,
               old_last_name, 
               new_last_name, 
               old_title, 
               new_title, 
               old_salary, 
               new_salary)
  VALUES (USER, 
         SYSDATE, 
         :OLD.employee_id,
         :OLD.last_name, 
         :NEW.last_name, 
         :OLD.job_id,
         :NEW.job_id, 
         :OLD.salary, 
         :NEW.salary);
END;
/

-- TESTANDO EXEMPLO 4...
insert into employees
values (1235,null,'Xiuderico','a@aA.com.b',null,sysdate,'IT_PROG',null,null,null,null);

delete from employees 
where employee_id=1234;

update employees
set salary=2000
where employee_id=100;

commit;

SELECT * FROM audit_emp;
--

----------------------------------------------------------------------------------------------------------------
--EXEMPLO 5
----------------------------------------------------------------------------------------------------------------
-- CRIANDO A VISÃO COMPLEXA

CREATE OR REPLACE VIEW REGION_COUNTRY 
(REGION_ID, REGION_NAME, COUNTRY_ID, COUNTRY_NAME) AS 
select r.region_id,r.region_name,c.country_id,c.country_name
from regions r inner join countries c
on (r.region_id=c.region_id);

-- CRIANDO O TRIGGER
CREATE OR REPLACE TRIGGER INS_REGIONS_COUNTRIES 
instead of   insert  on region_country
declare
   e_instrg_rc exception;
   pragma exception_init(e_instrg_rc,-1);
begin
    insert into regions
    values (:NEW.region_id,:NEW.region_name);
    insert into countries
    values (:NEW.country_id,:NEW.country_name,:NEW.region_id);
exception
   when e_instrg_rc then
       raise_application_error(-20107,'Duplicate ID value');
end;
/

-- TESTANDO EXEMPLO 5...

select * from REGION_COUNTRY;

insert into REGION_COUNTRY
values (100,'TDS','TD','2TDSG-M');

DESC REGION_COUNTRY;
select * from REGION_COUNTRY;
select * from regions;
select * from countries;

DESC COUNTRIES;
