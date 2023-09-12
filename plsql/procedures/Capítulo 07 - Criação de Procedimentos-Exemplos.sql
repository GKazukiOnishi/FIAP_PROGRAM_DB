-- Exemplo 1
DECLARE
  id       employees.employee_id%TYPE:=100;
  percent  NUMBER:=2;
  e_no_update exception;
BEGIN
  UPDATE employees
  SET    salary = salary * (1 + percent/100)
  WHERE  employee_id = id;
  
  IF SQL%NOTFOUND THEN
      RAISE e_no_update;
  ELSE
     DBMS_OUTPUT.PUT_LINE('Salary Updated'); 
  END IF;
EXCEPTION
WHEN e_no_update THEN
    DBMS_OUTPUT.PUT_LINE('ID Not found');
END;
/

-- Exemplo 1
CREATE OR REPLACE PROCEDURE raise_salary
  (id      IN employees.employee_id%TYPE,
   percent IN NUMBER)
IS
  e_no_update exception;
BEGIN
  UPDATE employees
  SET    salary = salary * (1 + percent/100)
  WHERE  employee_id = id;
  
  IF SQL%NOTFOUND THEN
      RAISE e_no_update;
  ELSE
     DBMS_OUTPUT.PUT_LINE('Salary Updated'); 
  END IF;
EXCEPTION
WHEN e_no_update THEN
    DBMS_OUTPUT.PUT_LINE('ID Not found');
END raise_salary;
/

set serveroutput on
EXECUTE raise_salary(1236,10);

BEGIN
  raise_salary(1236,10);
END;
/

-- Exemplo 2
CREATE OR REPLACE PROCEDURE query_emp
 (id     IN  employees.employee_id%TYPE,
  name   OUT employees.last_name%TYPE,
  salary OUT employees.salary%TYPE) IS
BEGIN
  SELECT   last_name, salary INTO name, salary
   FROM    employees
   WHERE   employee_id = id;
END query_emp;
/

DECLARE
  emp_name employees.last_name%TYPE;
  emp_sal  employees.salary%TYPE;
BEGIN
  query_emp(171, emp_name, emp_sal);
  dbms_output.put_line(emp_name || ' ' || emp_sal);
END;


-- Exemplo 3
CREATE OR REPLACE PROCEDURE format_phone
  (phone_no IN OUT VARCHAR2) IS
BEGIN
  phone_no := '(' || SUBSTR(phone_no,1,3) ||
              ')' || SUBSTR(phone_no,4,3) ||
              '-' || SUBSTR(phone_no,7);
END format_phone;
/
var v_phone varchar2(15)
execute :v_phone :='8006330575';
print v_phone
execute format_phone(:v_phone)
print v_phone


--Exemplo 4
CREATE OR REPLACE PROCEDURE process_employees
IS
   CURSOR emp_cursor IS
    SELECT employee_id
    FROM   employees;
BEGIN
   FOR emp_rec IN emp_cursor 
   LOOP
     raise_salary(emp_rec.employee_id, 10);
   END LOOP;    
   COMMIT;
END process_employees;
/



--Exemplo 6 - Cenário 2 sem tratamento de exceção
CREATE or replace PROCEDURE add_department_noex(
    name VARCHAR2, mgr NUMBER, loc NUMBER) IS
BEGIN
  INSERT INTO DEPARTMENTS (department_id,
    department_name, manager_id, location_id)
  VALUES (DEPARTMENTS_SEQ.NEXTVAL, name, mgr, loc);
  DBMS_OUTPUT.PUT_LINE('Added Dept: '||name);
END;
/

CREATE or  replace PROCEDURE create_departments_noex IS
BEGIN
  add_department_noex('Media', 100, 1800);
  add_department_noex('Editing', 99, 1800);
  add_department_noex('Advertising', 101, 1800);
exception
  when others then 
     dbms_output.put_line(sqlerrm);
END;
/

set  serverout on
exec create_departments_noex;

--Exemplo 5 - Cenário 1 com tratamento de exceção

CREATE or replace PROCEDURE add_department(
    name VARCHAR2, mgr NUMBER, loc NUMBER) IS
BEGIN
     INSERT INTO DEPARTMENTS (department_id,
     department_name, manager_id, location_id)
     VALUES (DEPARTMENTS_SEQ.NEXTVAL, name, mgr, loc);
     DBMS_OUTPUT.PUT_LINE('Added Dept: '||name);
EXCEPTION
 WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('Err: adding dept: '||name);
END;
/

CREATE or replace  PROCEDURE create_departments IS
BEGIN
  add_department('Media', 100, 1800);
  add_department('Editing', 99, 1800);
  add_department('Advertising', 101, 1800);
END;
/

set  serverout on
exec create_departments ;

delete from departments
where department_name in ('Media','Editing','Advertising');
commit;

set serverout on
exec create_departments_noex ;

