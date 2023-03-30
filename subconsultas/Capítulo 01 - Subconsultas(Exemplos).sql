SELECT last_name
FROM   employees
WHERE  salary >
               (SELECT salary
                FROM   employees
                WHERE  last_name = 'Abel');

-------------------------------------------------
SELECT last_name, job_id, salary
FROM   employees
WHERE  job_id =  
                (SELECT job_id
                 FROM   employees
                 WHERE  employee_id = 141)
AND    salary >
                (SELECT salary
                 FROM   employees
                 WHERE  employee_id = 143);

-------------------------------------------------
SELECT last_name, job_id, salary
FROM   employees
WHERE  salary = 
                (SELECT MIN(salary)
                 FROM   employees);

-------------------------------------------------
SELECT   department_id, MIN(salary)
FROM     employees
GROUP BY department_id
HAVING   MIN(salary) >
                       (SELECT MIN(salary)
                        FROM   employees
                        WHERE  department_id = 50);

-------------------------------------------------
SELECT employee_id, last_name
FROM   employees
WHERE  salary IN
                (SELECT   MIN(salary)
                 FROM     employees
                 GROUP BY department_id);

-------------------------------------------------
SELECT last_name, job_id
FROM   employees
WHERE  job_id =
                (SELECT job_id
                 FROM   employees
                 WHERE  last_name = 'Haas'); --uma subquery retornando null pode anular toda a query principal, mesmo que o resto rode

-------------------------------------------------
SELECT employee_id, last_name, job_id, salary
FROM   employees
WHERE  salary < ANY
                    (SELECT salary
                     FROM   employees
                     WHERE  job_id = 'IT_PROG')
AND    job_id <> 'IT_PROG';
--melhor
SELECT employee_id, last_name, job_id, salary
FROM   employees
WHERE  salary < (SELECT MAX(salary)
                 FROM   employees
                 WHERE  job_id = 'IT_PROG')
AND    job_id <> 'IT_PROG';

-------------------------------------------------
SELECT employee_id, last_name, job_id, salary
FROM   employees
WHERE  salary < ALL
                    (SELECT salary
                     FROM   employees
                     WHERE  job_id = 'IT_PROG')
AND    job_id <> 'IT_PROG';

SELECT employee_id, last_name, job_id, salary
FROM   employees
WHERE  salary < (SELECT MIN(salary)
                 FROM   employees
                 WHERE  job_id = 'IT_PROG')
AND    job_id <> 'IT_PROG';

-------------------------------------------------
SELECT emp.last_name
FROM   employees emp
WHERE  emp.employee_id NOT IN
                           (SELECT mgr.manager_id
                            FROM   employees mgr
                            WHERE  mgr.manager_id IS NOT NULL); --validar o NOT NULL resolve para exibir, mas est� errado
-- o de cima retorna funcion�rios que n�o s�o managers, por�m dentre os managers temos aqueles que s�o subordinados de outros
-- o de baixo retorna funcion�rios que s�o subordinados
--melhor e correto assim
SELECT e.last_name
FROM   employees e
WHERE  e.manager_id IS NOT NULL;
-------------------------------------------------
