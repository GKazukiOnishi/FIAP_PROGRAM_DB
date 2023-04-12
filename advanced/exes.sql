-- Ctrl F7 formata
-- PoorSQL

--1
DROP TABLE sal_history;

CREATE TABLE sal_history (
    employee_id NUMBER(6),
    hire_date   DATE,
    salary      NUMBER(8, 2)
);
--2
DESC SAL_HISTORY;
--3
DROP TABLE mgr_history;

CREATE TABLE mgr_history (
    employee_id NUMBER(6),
    manager_id  NUMBER(6),
    salary      NUMBER(8, 2)
);
--4
DESC MGR_HISTORY;
--5
DROP TABLE special_sal;

CREATE TABLE special_sal (
    employee_id NUMBER(6),
    salary      NUMBER(8, 2)
);
--6
DESC SPECIAL_SAL;
--7
    --a)
    TRUNCATE TABLE special_sal;
    TRUNCATE TABLE sal_history;
    TRUNCATE TABLE mgr_history;
    /*
    INSERT --ALL
        WHEN salary > 20000 THEN
            INTO special_sal VALUES (employee_id, salary)
        WHEN 0 = 0 THEN
            INTO sal_history VALUES (employee_id, hire_date, salary)
        WHEN 0 = 0 THEN
            INTO mgr_history VALUES (employee_id, manager_id, salary)
    SELECT employee_id,
           hire_date,
           salary,
           manager_id
    FROM   employees
    WHERE  employee_id < 125;
    */
    INSERT --ALL
        WHEN salary > 20000 THEN
            INTO special_sal VALUES (employee_id, salary)
        ELSE
            INTO sal_history VALUES (employee_id, hire_date, salary)
            INTO mgr_history VALUES (employee_id, manager_id, salary)
    SELECT employee_id,
           hire_date,
           salary,
           manager_id
    FROM   employees
    WHERE  employee_id < 125;
    /*
    INSERT FIRST
        WHEN salary > 20000 THEN
            INTO special_sal VALUES (employee_id, salary)
        WHEN employee_id <= 102 THEN
            INTO sal_history VALUES (employee_id, hire_date, salary)
        ELSE
            INTO mgr_history VALUES (employee_id, manager_id, salary)
    SELECT employee_id,
           hire_date,
           salary,
           manager_id
    FROM   employees
    WHERE  employee_id < 125;
    */
    --b)
    SELECT * FROM special_sal;
    --c)
    SELECT * FROM sal_history;
    --d)
    SELECT * FROM mgr_history;
--8
    --a)
    DROP TABLE sales_source_data;
    
    CREATE TABLE sales_source_data (
        employee_id NUMBER(6),
        week_id     NUMBER(2),
        sales_mon   NUMBER(8, 2),
        sales_tue   NUMBER(8, 2),
        sales_wed   NUMBER(8, 2),
        sales_thur  NUMBER(8, 2),
        sales_fri   NUMBER(8, 2)
    );
    --b)
    INSERT INTO SALES_SOURCE_DATA VALUES (178, 6, 1750,2200,1500,1500,3000);
    COMMIT;
    --c)
    DESC SALES_SOURCE_DATA;
    --d)
    SELECT * FROM SALES_SOURCE_DATA;
    --e)
    DROP TABLE sales_info;
    
    CREATE TABLE sales_info (
        employee_id NUMBER(6),
        week        NUMBER(2),
        sales       NUMBER(8, 2)
    );
    --f)
    DESC sales_info;
    --g)
    INSERT ALL
        INTO sales_info VALUES (employee_id, week_id, sales_mon)
        INTO sales_info VALUES (employee_id, week_id, sales_tue)
        INTO sales_info VALUES (employee_id, week_id, sales_wed)
        INTO sales_info VALUES (employee_id, week_id, sales_thur)
        INTO sales_info VALUES (employee_id, week_id, sales_fri)
    SELECT employee_id,
         week_id,
         sales_mon,
         sales_tue,
         sales_wed,
         sales_thur,
         sales_fri 
    FROM sales_source_data;
    --h)
    SELECT * FROM sales_info;
-- 1 Relatório Agrupamento
SELECT manager_id, job_id, sum(salary)
FROM   employees
WHERE  manager_id < 120
GROUP  BY ROLLUP(manager_id, job_id);
-- 2
SELECT manager_id, job_id, sum(salary), GROUPING(manager_id), GROUPING(job_id)
FROM   employees
WHERE  manager_id < 120
GROUP  BY ROLLUP(manager_id, job_id);
-- 3
SELECT manager_id, job_id, sum(salary)
FROM   employees
WHERE  manager_id < 120
GROUP  BY CUBE(manager_id, job_id);
-- 4
SELECT manager_id, job_id, sum(salary), GROUPING(manager_id), GROUPING(job_id)
FROM   employees
WHERE  manager_id < 120
GROUP  BY CUBE(manager_id, job_id);
-- 5
SELECT department_id, manager_id, job_id, sum(salary)
FROM   employees
WHERE  manager_id < 120
GROUP  BY GROUPING SETS((department_id, manager_id, job_id), (department_id, job_id), (manager_id, job_id));
-- 3 Query Hierárquica
SELECT last_name
FROM   employees
WHERE  last_name <> 'Lorentz'
START  WITH last_name = 'Lorentz'
CONNECT BY PRIOR manager_id = employee_id;