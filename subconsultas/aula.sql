SELECT last_name
FROM employees e
WHERE e.salary > 5000;

SELECT last_name, salary
FROM employees e
WHERE e.salary > 
                (SELECT salary 
                 FROM employees 
                 WHERE last_name = 'Abel');
                 
SELECT last_name, job_id, salary
FROM   employees
WHERE  salary = 
                (SELECT MAX(salary)
                 FROM   employees);

SELECT last_name, job_id, salary
FROM   employees
WHERE  salary > 
                (SELECT AVG(salary)
                 FROM   employees);
                 
SELECT COUNT(*)
FROM   employees e;

SELECT d.department_name, COUNT(*)
FROM   employees e
LEFT   JOIN departments d
ON     d.department_id = e.department_id
GROUP  BY e.department_id, d.department_name;

DESC employees;

SELECT d.department_name, COUNT(*)
FROM   employees e
LEFT   JOIN departments d
ON     d.department_id = e.department_id
WHERE  d.department_id IN (10, 20, 30, 40, 80, 90)
GROUP  BY e.department_id, d.department_name;

SELECT d.department_name, COUNT(*)
FROM   employees e
LEFT   JOIN departments d
ON     d.department_id = e.department_id
WHERE  d.department_id IN (10, 20, 30, 40, 80, 90)
GROUP  BY e.department_id, d.department_name
HAVING COUNT(*) > 5;

