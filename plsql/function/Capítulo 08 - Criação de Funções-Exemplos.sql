-- Exemplo 1

CREATE OR REPLACE FUNCTION get_sal
 (id employees.employee_id%TYPE) RETURN NUMBER IS
  sal employees.salary%TYPE := 0;
BEGIN
  SELECT salary
  INTO   sal
  FROM   employees         
  WHERE  employee_id = id;
  RETURN sal;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('A');
    return null;
END get_sal;
/
select employee_id, salary, get_sal(employee_id) from employees;

select get_sal(1010) from dual;

EXECUTE dbms_output.put_line(get_sal(1010));

-- Exemplo 2
CREATE OR REPLACE FUNCTION tax(value IN NUMBER, taxa number)
 RETURN NUMBER IS
BEGIN
   RETURN (value * taxa);
END tax;
/
SELECT employee_id, last_name, salary, tax(salary, .275), salary - tax(salary, .275) sal_liq
FROM   employees
WHERE  department_id = 100;

SET SERVEROUT ON
DECLARE
  v_sal employees.salary%TYPE := get_sal(100);
BEGIN
  dbms_output.put_line(v_sal);
END;
/

DESC GET_SAL;
