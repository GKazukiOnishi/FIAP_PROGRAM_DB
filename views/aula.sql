/*
Views
    * Facilitar consultas complexas -> mais conhecido
    * Restringir o acesso a dados -> tem como só exibir os dados e colunas que quiser
        Visões não armazenam dados, são as tabelas bases
    * Permitir a independência de dados -> é um objeto separado, pode ter tabela sem a view, view sem a tabela (fica inválida)
    * Apresentar exibições diferentes dos mesmos dados -> já exibir formatado
    
    Simples:
        Uma tabela
        Sem function
        Sem group by
        Permitem DML -> nem sempre, nem 100%
    Complexas:
        Uma ou mais tabelas
        Podem ter functions
        Podem ter group by
        Nem sempre vão rodar DML
    
    Para criar é só fazer o SELECT e colocar no começo:
        CREATE [OR REPLACE] [FORCE|NOFORCE] VIEW nome_view AS query
            [WITH CHECK OPTION
            [WITH READ ONLY
            FORCE -> deixa criar view sem que a tabela exista
        
    Teoricamente view já está processada, então pode ser que seja mais rápido
    
    Se você mexer no dado da tabela base a view também percebe a mudança
    
    CREATE OR REPLACE -> mantém as permissões
    DROP
    CREATE -> não mantém as permissões
*/

-- CREATE TABLE SIS3(salary*12 int); não funciona

--Exercícios

--1
CREATE OR REPLACE VIEW EMPLOYEE_VU AS
    SELECT employee_id,
           last_name employee,
           department_id
    FROM   employees;
--2
SELECT * FROM EMPLOYEE_VU;
--3
SELECT employee,
       department_id
FROM   employee_vu;
--4
CREATE OR REPLACE VIEW DEPT50 AS
    SELECT employee_id EMPNO,
           last_name EMPLOYEE,
           department_id DEPTNO
    FROM   employees
    WHERE  department_id = 50
    WITH CHECK OPTION CONSTRAINT DEPT50_CK;
--5
DESCRIBE DEPT50;
SELECT * FROM DEPT50;
--6
UPDATE DEPT50
SET    deptno = 80
WHERE  employee = 'Matos';

--SELECT * FROM pf0645.dept50;