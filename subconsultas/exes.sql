--1
SELECT e2.last_name,
       e2.hire_date
FROM   employees e1
JOIN   employees e2
ON     e1.department_id = e2.department_id
AND    e1.employee_id <> e2.employee_id
WHERE  e1.last_name = INITCAP('&v_ln');--solicita caixa
--ou
UNDEFINE v_ln
SELECT last_name,
       hire_date
FROM   employees
WHERE  department_id IN (SELECT department_id -- se não fosse um IN poderia dar problema, já que pode ter mais de um func com mesmo last_name
                         FROM   employees
                         WHERE  last_name = INITCAP('&&v_ln'))--solicita e armazena
AND    last_name <> INITCAP('&v_ln'); --tratamento para não digitar no case errado

--2
SELECT employee_id,
       last_name,
       salary
FROM   employees
WHERE  salary > (SELECT AVG(salary)
                 FROM   employees)
ORDER  BY salary;

--3
SELECT e.employee_id,
       e.last_name
FROM   employees e
WHERE  e.department_id IN (SELECT DISTINCT department_id
                           FROM   employees
                           WHERE  LOWER(last_name) LIKE '%u%'); --tratar para pega letra U e u

--4
SELECT e.last_name,
       e.department_id,
       e.job_id
FROM   employees e
WHERE  e.department_id IN (SELECT department_id
                           FROM   departments
                           WHERE  location_id = &v_li);
--ou
SELECT e.last_name,
       e.department_id,
       e.job_id
FROM   employees e
JOIN   departments d
ON     d.department_id = e.department_id
WHERE  d.location_id = &v_li;
--no oracle o desempenho é igual, pois a oracle sabe escolher o melhor plano de execução
--porém, em geral as subqueries são menos performáticas
--em outros sgbd a performance muito provavelmente será pior
--dê preferência para junção

--5
SELECT last_name,
       salary
FROM   employees
WHERE  manager_id IN (SELECT employee_id
                      FROM   employees
                      WHERE  first_name = 'Steven'
                      AND    last_name = 'King');
--
SELECT e1.last_name,
       e1.salary
FROM   employees e1
JOIN   employees e2
ON     e1.manager_id = e2.employee_id
WHERE  e2.first_name = 'Steven'
AND    e2.last_name = 'King';

--6
SELECT department_id,
       last_name,
       job_id
FROM   employees
WHERE  department_id = (SELECT department_id
                        FROM   departments
                        WHERE  department_name = 'Executive');

--7
SELECT e.employee_id,
       e.last_name,
       e.salary
FROM   employees e
WHERE  e.department_id IN (SELECT DISTINCT department_id
                           FROM   employees
                           WHERE  LOWER(last_name) LIKE '%u%')
AND    e.salary > (SELECT AVG(salary)
                   FROM   employees);