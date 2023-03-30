/*
Conjuntos:
	Diagrama de Venn
	
	Opera��es de conjunto:
		A U B / Union -> n�o duplica as intersec��es
        A U B / Union All -> tr�s as intersec��es duas vezes
		A n B / INTERSECT -> s� intersec��o
		A - B / MINUS / EXCEPT (SQL SERVER) -> s� tem no A e n�o no B
	
	Onde: 
		A ou B s�o as tabelas
		os elementos dentro dos conjuntos s�o os registros
    
    Para usar opera��es de conjuntos primeiro � preciso entender o neg�cio, entender
        o que representa o conjunto A - B, o que � A n B, etc.
        
    Todos os operadores exceto o UNION ALL ordenam as linhas pela primeira coluna
    No UNION ALL voc� pode usar o ORDER BY mas s� na �ltima sele��o, e esse order by vai ordenar com base em alias/posi��o
    
    A quantidade de colunas e tipos de dados precisam bater nos dois SELECTs
    
    em alguns casos isso n�o ser� poss�vel, nesse caso podemos criar colunas vazias com os tipos corretos
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
    
    obs: em opera��es de conjuntos n�o precisa se preocupar com distinct em alguns casos, porque no conjunto � o mesmo elemento
    
*/

--Exerc�cios
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