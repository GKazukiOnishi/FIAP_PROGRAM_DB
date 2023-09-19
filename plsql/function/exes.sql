CREATE OR REPLACE FUNCTION GET_ANNUAL_COMP(p_employee_id employees.employee_id%TYPE)
  RETURN NUMBER AS
  v_sal employees.salary%TYPE;
  v_commission employees.commission_pct%TYPE;
BEGIN
  SELECT salary,
         NVL(commission_pct, 0)
  INTO   v_sal,
         v_commission
  FROM   employees
  WHERE  employee_id = p_employee_id;
  
  RETURN (v_sal*12) + (v_commission*v_sal*12);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('Employee inexistente');
    RETURN NULL;
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
    RETURN NULL;
END GET_ANNUAL_COMP;
/


DESC employees;

SELECT employee_id, last_name, salary, commission_pct, GET_ANNUAL_COMP(employee_id) FROM employees;

select get_annual_comp(0) FROM dual;