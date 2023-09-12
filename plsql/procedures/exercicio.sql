--1
CREATE OR REPLACE PROCEDURE CAD_EMPLOYEES(p_first_name     employees.first_name%TYPE,
                                          p_last_name      employees.last_name%TYPE,
                                          p_email          employees.email%TYPE,
                                          p_phone_number   employees.phone_number%TYPE,
                                          p_hire_date      employees.hire_date%TYPE,
                                          p_job_id         employees.job_id%TYPE,
                                          p_salary         employees.salary%TYPE,
                                          p_commission_pct employees.commission_pct%TYPE,
                                          p_manager_id     employees.manager_id%TYPE,
                                          p_department_id  employees.department_id%TYPE) IS
    e_insert_exception EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_insert_exception,-01400);
    e_unique_exception EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_unique_exception,-00001);
BEGIN
    INSERT INTO employees (
        employee_id,
        first_name,
        last_name,
        email,
        phone_number,
        hire_date,
        job_id,
        salary,
        commission_pct,
        manager_id,
        department_id
    ) VALUES (
        employees_seq.nextval,
        p_first_name,
        p_last_name,
        p_email,
        p_phone_number,
        p_hire_date,
        p_job_id,
        p_salary,
        p_commission_pct,
        p_manager_id,
        p_department_id
    );
EXCEPTION
    WHEN e_insert_exception THEN
        DBMS_OUTPUT.PUT_LINE('Ocorreu um erro ao tentar inserir o funcionário ' || p_first_name || ' ' || p_last_name);
    WHEN e_unique_exception THEN
        DBMS_OUTPUT.PUT_LINE('Ocorreu um erro de unique ao tentar inserir o funcionário ' || p_first_name || ' ' || p_last_name);
END CAD_EMPLOYEES;
/

SELECT * FROM employees;

ALTER SESSION SET NLS_DATE_FORMAT='DD/MM/YYYY';

BEGIN
    cad_employees(p_first_name => 'TESTE01F',
                  p_last_name => 'TESTE01L',
                  p_email => 'SKING',
                  p_phone_number => '123.123.1234',
                  p_hire_date => '02/03/2000',
                  p_job_id => 'IT_PROG',
                  p_salary => '9000',
                  p_commission_pct => null,
                  p_manager_id => null,
                  p_department_id => 60);
END;