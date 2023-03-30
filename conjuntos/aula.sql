/*
Conjuntos:
	Diagrama de Venn
	
	Operações de conjunto:
		A U B / Union -> não duplica as intersecções
        A U B / Union All -> trás as intersecções duas vezes
		A n B / INTERSECT -> só intersecção
		A - B / MINUS / EXCEPT (SQL SERVER) -> só tem no A e não no B
	
	Onde: 
		A ou B são as tabelas
		os elementos dentro dos conjuntos são os registros
    
    Para usar operações de conjuntos primeiro é preciso entender o negócio, entender
        o que representa o conjunto A - B, o que é A n B, etc.
        
    Todos os operadores exceto o UNION ALL ordenam as linhas pela primeira coluna
    No UNION ALL você pode usar o ORDER BY mas só na última seleção, e esse order by vai ordenar com base em alias/posição
    
    A quantidade de colunas e tipos de dados precisam bater nos dois SELECTs
    
    em alguns casos isso não será possível, nesse caso podemos criar colunas vazias com os tipos corretos
        SELECT department_id, null location, hire_date
        FROM   employees
        UNION
        SELECT department_id, location_id, null
        FROM   departments;
        
        SELECT employee_id, job_id, to_char(salary)
        FROM   employees
        UNION
        SELECT employee_id, job_id, '---'
        FROM   job_history;
    
    obs: em operações de conjuntos não precisa se preocupar com distinct em alguns casos, porque no conjunto é o mesmo elemento
    
*/

--Exercícios
--1
    SELECT department_id
    FROM   departments
    MINUS
    SELECT department_id
    FROM   employees
    WHERE  job_id = 'ST_CLERK';

--2
    SELECT country_id, country_name
    FROM   countries
    MINUS
    SELECT c.country_id, c.country_name
    FROM   countries c
    JOIN   locations l
    ON     c.country_id = l.country_id
    JOIN   departments d
    ON     d.location_id = l.location_id;

--3
    SELECT DISTINCT e.job_id, e.department_id
    FROM   employees e
    WHERE  e.department_id = 10
    UNION  ALL
    SELECT DISTINCT e.job_id, e.department_id
    FROM   employees e
    WHERE  e.department_id = 50
    UNION  ALL
    SELECT DISTINCT e.job_id, e.department_id
    FROM   employees e
    WHERE  e.department_id = 20;

--4
   SELECT employee_id, job_id
   FROM   employees
   INTERSECT
   SELECT employee_id, job_id
   FROM   job_history;

--5
   SELECT last_name, department_id, to_char(null)
   FROM   employees
   UNION  ALL
   SELECT null, department_id, department_name
   FROM   departments;