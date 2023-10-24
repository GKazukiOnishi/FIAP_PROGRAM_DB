DROP TABLE EMPLOYEES_INCREASE_ALLOWED force;

CREATE TABLE EMPLOYEES_INCREASE_ALLOWED
AS
SELECT OBJECT_ID employee_id ,
       TRUNC(dbms_random.value,2) increase_pct_allowed
FROM   ALL_OBJECTS
FETCH FIRST 107 ROWS ONLY;
/

SELECT * FROM
EMPLOYEES_INCREASE_ALLOWED;
/

-- EXE: Alterar para ser mais performático

CREATE OR REPLACE PROCEDURE check_eligibility
   (p_employee_id     IN number
   ,p_increase_pct_in IN NUMBER
   ,p_is_eligible OUT BOOLEAN
)
IS
   l_dummy NUMBER;
BEGIN
    SELECT EMPLOYEE_ID
    INTO   l_dummy
    FROM   EMPLOYEES_INCREASE_ALLOWED
    WHERE  EMPLOYEE_ID = p_employee_id
    AND    ABS(INCREASE_PCT_ALLOWED - p_increase_pct_in) <= .1;
   
    p_is_eligible := TRUE;
EXCEPTION
  WHEN NO_DATA_FOUND then
        p_is_eligible := FALSE;
END;
/

----------------------------------------------------------------------------------------------
-- Exemplo 4
CREATE OR REPLACE PROCEDURE increase_salary (
   department_id_in   IN employees.department_id%TYPE,
   increase_pct_in    IN NUMBER)
IS
   l_eligible   BOOLEAN;
BEGIN
   FOR employee_rec IN (SELECT employee_id
                        FROM   employees
           WHERE department_id = increase_salary.department_id_in)
   LOOP
      check_eligibility (employee_rec.employee_id,
                         increase_pct_in,
                         l_eligible);
      IF l_eligible
      THEN
         UPDATE employees emp
         SET    emp.salary = emp.salary +
                             emp.salary * increase_salary.increase_pct_in
        WHERE  emp.employee_id = employee_rec.employee_id;
      END IF;
   END LOOP;
END increase_salary;
/