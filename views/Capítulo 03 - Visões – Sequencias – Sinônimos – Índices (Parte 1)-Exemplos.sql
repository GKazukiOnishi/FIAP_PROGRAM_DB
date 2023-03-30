--VIEWS
DROP VIEW empvu80;
CREATE VIEW 	empvu80
 AS SELECT  employee_id, last_name, salary
    FROM    employees
    WHERE   department_id = 80;

DESCRIBE empvu80;

SELECT * FROM EMPVU80;

UPDATE EMPVU80
SET SALARY=15000
WHERE EMPLOYEE_ID=145;

DELETE EMPVU80
WHERE EMPLOYEE_ID=179;

INSERT INTO EMPVU80
VALUES (12345,'Xiuderico',10000); --não funciona nesse caso, isso porque o INSERT vai na tabela base, então se
    -- ela tiver constraint vai valer também
    -- para usar todas as colunas NOT NULL e constraints precisam ser respetiadas

DESCRIBE employees;
ROLLBACK;

DROP VIEW  salvu50;
CREATE VIEW 	salvu50
 AS SELECT  employee_id ID_NUMBER, --coluna renomeada
            last_name   NAME,
            salary*12   ANN_SALARY
    FROM    employees
    WHERE   department_id = 50;


SELECT *
FROM   salvu50;

UPDATE SALVU50
SET ANN_SALARY = 10000000; -- coluna calculada -> não tem como atualizar

UPDATE SALVU50
SET    ANN_SALARY = 1000000;

DELETE SALVU50
WHERE  ID_NUMBER = 199;


CREATE OR REPLACE VIEW empvu80
  (id_number, name, sal, department_id) --alias das colunas da query
AS SELECT  employee_id,
            first_name || ' ' || last_name, 
			salary, 
			department_id
   FROM    employees
   WHERE   department_id = 80;

DROP VIEW dept_sum_vu;

--nessa aqui não tem como fazer nenhum DML, pois usa função e group by, em que as três últimas colunas precisam ser apelidadas
CREATE VIEW	dept_sum_vu
  (name, minsal, maxsal, avgsal)
AS SELECT	 d.department_name, MIN(e.salary), 
             MAX(e.salary),AVG(e.salary)
   FROM      employees e, departments d
   WHERE     e.department_id = d.department_id 
   GROUP BY  d.department_name;

CREATE OR REPLACE VIEW empvu20
AS SELECT	*
   FROM     employees
   WHERE    department_id = 20;
  -- WITH CHECK OPTION CONSTRAINT empvu20_ck ;

SELECT * FROM empvu20;

INSERT INTO empvu20
VALUES (2050,'Shelley','Higgins','SHIGGINS@XPTO',123,SYSDATE,'AC_MGR',12000,NULL,101,110); --esse roda

SELECT * FROM empvu20; --mas esse não mostra

CREATE OR REPLACE VIEW empvu20
AS SELECT	*
   FROM     employees
   WHERE    department_id = 20
   WITH CHECK OPTION CONSTRAINT empvu20_ck ;

SELECT * FROM empvu20;

INSERT INTO empvu20
VALUES (2051,'Shelley','Higgins','SHIGGINS@XPTO',123,SYSDATE,'AC_MGR',12000,NULL,101,110); --agora não roda, porque a view só enxerga o dept 20

INSERT INTO empvu20
VALUES (2051,'Shelley','Higgins','SHIGGINS@XPTO',123,SYSDATE,'AC_MGR',12000,NULL,101,20); --agora roda

--Com o WITH CHECK OPTION você não pode inserir/atualizar fora do domínio

UPDATE EMPVU20
SET    department_id = 10;

SELECT * FROM empvu20;

CREATE OR REPLACE VIEW empvu10
    (employee_number, employee_name, job_title)
AS SELECT	employee_id, last_name, job_id
   FROM     employees
   WHERE    department_id = 10
   WITH READ ONLY CONSTRAINT EMPVU10_RO;
--INSERT, UPDATE, DELETE não roda

DROP VIEW empvu80;
