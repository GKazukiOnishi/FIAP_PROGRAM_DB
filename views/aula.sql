/*
Views
    * Facilitar consultas complexas -> mais conhecido
    * Restringir o acesso a dados -> tem como s� exibir os dados e colunas que quiser
        Vis�es n�o armazenam dados, s�o as tabelas bases
    * Permitir a independ�ncia de dados -> � um objeto separado, pode ter tabela sem a view, view sem a tabela (fica inv�lida)
    * Apresentar exibi��es diferentes dos mesmos dados -> j� exibir formatado
    
    Simples:
        Uma tabela
        Sem function
        Sem group by
        Permitem DML -> nem sempre, nem 100%
    Complexas:
        Uma ou mais tabelas
        Podem ter functions
        Podem ter group by
        Nem sempre v�o rodar DML
    
    Para criar � s� fazer o SELECT e colocar no come�o:
        CREATE [OR REPLACE] [FORCE|NOFORCE] VIEW nome_view AS query
            [WITH CHECK OPTION
            [WITH READ ONLY
            FORCE -> deixa criar view sem que a tabela exista
        
    Teoricamente view j� est� processada, ent�o pode ser que seja mais r�pido
    
    Se voc� mexer no dado da tabela base a view tamb�m percebe a mudan�a
    
    CREATE OR REPLACE -> mant�m as permiss�es
    DROP
    CREATE -> n�o mant�m as permiss�es
*/

-- CREATE TABLE SIS3(salary*12 int); n�o funciona

--Exerc�cios

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