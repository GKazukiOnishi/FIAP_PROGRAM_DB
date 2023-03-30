--DQL PROJEÇÃO
SELECT last_name FROM employees;

--DQL SELEÇÃO
SELECT last_name
FROM employees
WHERE department_id = 90;

SELECT last_name, department_name, street_address
FROM employees e 
JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
ON l.location_id = d.location_id;