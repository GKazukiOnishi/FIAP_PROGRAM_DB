SET SERVEROUT ON

--Exemplo Vetor 1
DECLARE
  TYPE Foursome IS VARRAY(4) OF VARCHAR2(15);  -- VARRAY type
 
  -- Inicia VARRARY com o método construtor
 
  team Foursome := Foursome('John', 'Mary', 'Alberto', 'Juanita');
 
  PROCEDURE print_team (heading VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(heading);
 
    FOR i IN 1..4 LOOP
      DBMS_OUTPUT.PUT_LINE(i || '.' || team(i));
    END LOOP;
 
    DBMS_OUTPUT.PUT_LINE('---'); 
  END;
BEGIN 
  print_team('2001 Team:');
 
  team(3) := 'Pierre';  -- Altera o valor de dois elementos
  team(4) := 'Yvonne';
  print_team('2005 Team:');
 
  -- Invoca o construtor para atribuir novos valores à variável varray:
 
  team := Foursome('Arun', 'Amitha', 'Allan', 'Mae');
  print_team('2009 Team:');
END;
/

----------------------------------------------------------------------------------------------
--Exemplo Vetor 2
SET SERVEROUT ON

ALTER SESSION SET nls_numeric_characters = '.,';

DECLARE
   -- define o tipo do vetor
    TYPE tvetor IS VARRAY(10)OF NUMBER;
--declara um vetor com o nome V e o tipo tVetor 
    v              tvetor;
    qtd_aprovados  PLS_INTEGER := 0;
BEGIN
-- INICIALIZA AS 10 POSIÇÕES DO VETOR
    v := tvetor(7.8,5.0,8.5,9.0,7.4,10,7.6,7.5,9.0,9.9);
   -- PERCORRE AS 10 POSIÇÕES DO VETOR

    FOR i IN 1..10 LOOP
        dbms_output.put_line(v(i));
        IF v(i)>= 6 THEN
            qtd_aprovados := qtd_aprovados + 1;
        END IF;
    END LOOP;
     dbms_output.put_line('----------');
    dbms_output.put_line(qtd_aprovados);
END;
/

----------------------------------------------------------------------------------------------
--Exemplo 1:
CREATE OR REPLACE PROCEDURE increase_salary (
   department_id_in   IN employees.department_id%TYPE,
   increase_pct_in    IN NUMBER)
IS 
BEGIN
   FOR employee_rec  IN (SELECT employee_id
                         FROM employees
                         WHERE department_id = department_id_in) LOOP
       UPDATE employees 
       SET    salary = salary + 
                       salary * increase_salary.increase_pct_in
       WHERE  employee_id = employee_rec.employee_id;
   END LOOP; 
END increase_salary;
/

-- Considere que há 100 funcionários alocados no departamento 50 
SET SERVEROUT ON
DECLARE 
   t0 number    := dbms_utility.get_time; 
   v_idx number := 1;  
BEGIN
   increase_salary (50, .10);
   dbms_output.put_line('Tempo: ' ||
   ((dbms_utility.get_time - t0) / 100) || ' segundos');  
END;
/

----------------------------------------------------------------------------------------------
--Exemplo 2
CREATE OR REPLACE PROCEDURE increase_salary (
   department_id_in   IN employees.department_id%TYPE,
   increase_pct_in    IN NUMBER)
IS
BEGIN
   UPDATE employees
   SET    salary = salary + 
          salary * increase_pct_in
   WHERE  department_id = department_id_in;
END increase_salary;
/

----------------------------------------------------------------------------------------------
--Exemplo 3
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

----------------------------------------------------------------------------------------------
--Exemplo DELETE com FORALL 
DROP TABLE employees_temp;
CREATE TABLE employees_temp AS SELECT * FROM employees;

DECLARE
  TYPE NumList IS VARRAY(20) OF NUMBER;
  depts NumList := NumList(10, 30, 70);  -- department numbers
BEGIN
  FORALL i IN depts.FIRST..depts.LAST
    DELETE FROM employees_temp
    WHERE department_id = depts(i);
END;
/


SELECT COUNT(*) FROM employees_temp;

----------------------------------------------------------------------------------------------
--Exemplo de declaração INSERT no FOR LOOP e na declaração FORALL


DROP TABLE parts1;
CREATE TABLE parts1 (
  pnum INTEGER,
  pname VARCHAR2(15)
);
 
DROP TABLE parts2;
CREATE TABLE parts2 (
  pnum INTEGER,
  pname VARCHAR2(15)
);

DECLARE
  TYPE NumTab IS TABLE OF parts1.pnum%TYPE INDEX BY PLS_INTEGER;
  TYPE NameTab IS TABLE OF parts1.pname%TYPE INDEX BY PLS_INTEGER;
  pnums   NumTab;
  pnames  NameTab;
  iterations  CONSTANT PLS_INTEGER := 900000;
  t1  INTEGER;
  t2  INTEGER;
  t3  INTEGER;
BEGIN
  FOR j IN 1..iterations LOOP  -- populate collections
    pnums(j) := j;
    pnames(j) := 'Part No. ' || TO_CHAR(j);
  END LOOP;

  t1 := DBMS_UTILITY.get_time;
---------------------------------------------------
  FOR i IN 1..iterations LOOP
    INSERT INTO parts1 (pnum, pname)
    VALUES (pnums(i), pnames(i));
  END LOOP;

  t2 := DBMS_UTILITY.get_time;
----------------------------------------------------
  FORALL i IN 1..iterations
    INSERT INTO parts2 (pnum, pname)
    VALUES (pnums(i), pnames(i));

  t3 := DBMS_UTILITY.get_time;

  DBMS_OUTPUT.PUT_LINE('Execution Time (secs)');
  DBMS_OUTPUT.PUT_LINE('---------------------');
  DBMS_OUTPUT.PUT_LINE('FOR LOOP: ' || TO_CHAR((t2 - t1)/100));
  DBMS_OUTPUT.PUT_LINE('FORALL:   ' || TO_CHAR((t3 - t2)/100));
  DBMS_OUTPUT.PUT_LINE('DIFF:   ' ||  (TO_CHAR((t2 - t1)/100)/TO_CHAR((t3 - t2)/100)));
  COMMIT;
END;
/
SELECT COUNT(*) FROM parts1;

SELECT COUNT(*) FROM parts2;
----------------------------------------------------------------------------------------------
--Exemplo 5 
set serverout on
declare
   type emp_t is record (
    empid employees.employee_id%type,
    sal   employees.salary%type);
    
   type emp_tbl_t is table of emp_t
   index by pls_integer;

   l_emp emp_tbl_t;
 
   v_employee_id employees.employee_id%type;
   v_salary      employees.salary%type;
begin
   select employee_id, salary
   BULK COLLECT INTO  l_emp
   from employees
   where department_id=90;
   
   for indx in 1..l_emp.count LOOP
       dbms_output.put_line(l_emp(indx).empid || ' ' || l_emp(indx).sal);
   end loop;
end;
/
----------------------------------------------------------------------------------------------
