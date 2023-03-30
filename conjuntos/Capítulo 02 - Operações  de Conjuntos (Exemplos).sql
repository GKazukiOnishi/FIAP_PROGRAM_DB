--Exemplo Slide 12
SELECT employee_id, job_id
FROM   employees
UNION
SELECT employee_id, job_id
FROM   job_history;
-- quem aparece s� uma vez nunca foi promovido
-- s� mostra as promo��es, n�o tem como saber se desceu de cargo

--Exemplo Slide 15
SELECT employee_id, job_id, department_id
FROM   employees
UNION ALL
SELECT employee_id, job_id, department_id
FROM   job_history
ORDER BY  employee_id; -- ORDER BY s� pode na �ltima sele��o e no UNION ALL
-- mostra a intersec��o junto, ent�o tem como saber se foi e voltou de cargo

--Exemplo Slide 17
SELECT employee_id, job_id
FROM   employees
INTERSECT
SELECT employee_id, job_id
FROM   job_history;
-- quem desceu de cargo em algum momento

--Exemplo Slide 19
SELECT employee_id
FROM   employees
MINUS
SELECT employee_id
FROM   job_history;


--Exemplo slide 22
SELECT department_id, TO_NUMBER(null) location, hire_date
FROM   employees
UNION
SELECT department_id, location_id,  TO_DATE(null)
FROM   departments;

SELECT department_id, null location, hire_date
FROM   employees
UNION
SELECT department_id, location_id, null
FROM   departments;

--Exemplo slide 23
SELECT employee_id, job_id,salary
FROM   employees
UNION
SELECT employee_id, job_id,0
FROM   job_history;

SELECT employee_id, job_id, to_char(salary)
FROM   employees
UNION
SELECT employee_id, job_id, '---'
FROM   job_history;



