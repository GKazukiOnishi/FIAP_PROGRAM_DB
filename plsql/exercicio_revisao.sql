drop sequence seq_dept;

create sequence seq_dept
start with 280
increment by 10;

SET VERIFY OFF
SET FEED OFF
CL SCR
SET SERVEROUT ON

ACCEPT P_DEPT_NAME PROMPT 'Informe o nome do departamento'

DECLARE
  v_dept_name VARCHAR2(100) := initcap('&P_DEPT_NAME');
BEGIN
  INSERT INTO departments (department_id, department_name, manager_id, location_id)
  VALUES (seq_dept.nextval, v_dept_name, NULL, NULL);
  
  dbms_output.put_line(sql%rowcount || ' linhas inseridas');
  
  COMMIT;
END;
/

SELECT * FROM departments;

DESC departments;

SELECT * FROM employees;

ACCEPT P_EMP_ID PROMPT 'Informe o código do funcionário'

DECLARE
  v_emp_id employees.employee_id%TYPE := &P_EMP_ID;
  v_emp_name employees.last_name%TYPE;
  v_emp_salary employees.salary%TYPE;
  v_emp_star VARCHAR2(100);
BEGIN
  SELECT last_name,
         salary,
         RTRIM(LPAD(' ', ROUND(salary/1000) + 1, '*')) star
  INTO   v_emp_name,
         v_emp_salary,
         v_emp_star
  FROM   employees
  WHERE  employee_id = v_emp_id;

  dbms_output.put_line(v_emp_name);
  dbms_output.put_line(v_emp_salary);
  dbms_output.put_line(v_emp_star);
END;
/


ACCEPT P_EMP_ID PROMPT 'Informe o código do funcionário'

DECLARE
  v_emp_id employees.employee_id%TYPE := &P_EMP_ID;
  v_emp_name employees.last_name%TYPE;
  v_emp_salary employees.salary%TYPE;
  v_emp_qtd_star NUMBER(10);
  v_emp_star VARCHAR2(100) := '';
  --v_count number := 1;
BEGIN
  SELECT last_name,
         salary,
         salary/1000 star
  INTO   v_emp_name,
         v_emp_salary,
         v_emp_qtd_star
  FROM   employees
  WHERE  employee_id = v_emp_id;
  
  FOR v_i IN 1..v_emp_qtd_star LOOP --por padrão arredonda na conversão
    v_emp_star := v_emp_star || '*';
  END LOOP;
  
  -- ***** Se fizer com while precisa do round, porque ele trunca por padrão

/*
  while v_count <= round(v_emp_qtd_star) loop
      v_count := v_count + 1;
      v_emp_star := v_emp_star || '*';      
   end loop;
*/
/*
  loop
       v_emp_star := v_emp_star || '*';  
       exit when v_count >= round(v_emp_qtd_star); 
       v_count := v_count + 1;
  end loop;
*/
  dbms_output.put_line(v_emp_name);
  dbms_output.put_line(v_emp_salary);
  dbms_output.put_line(v_emp_star);
END;
/


SET SERVEROUT OFF