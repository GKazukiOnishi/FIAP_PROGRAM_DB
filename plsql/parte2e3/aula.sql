-- PARTE 2

SET SERVEROUT ON

-- primeiro exemplo
declare 
    v_ei integer := 10;
    v_ln varchar(50) not null := 'Z';
    c_tax constant int := 0;
begin
    c_tax:=1; --> isso aqu ivai dar erro porque nao podemos alterar o valor de um constante
    dbms_output.put_line(v_ei);
end;
/

-- segundo exemplo 
-- um cursor tem a mesma ideia de matriz em java
-- colunas e linhas v�o sendo processadas e jogadas em alguma vari�vel para cada linha
declare 
    v_ei integer := 100;
    v_ln varchar(50) not null := 'Z';
    c_tax constant int := 0;
begin
    dbms_output.put_line(v_ei);
    select last_name
    into v_ln
    from employees
    where employee_id = v_ei;
    dbms_output.put_line(v_ln);
end;
/

--terceiro exemplo
-- dou um desc employees para conseguir entender qual o salario especificado, eu n�o posso usar um v_sal number (5) pq nesse caso o salario � um nuber (8,2)
declare 
    v_ei integer := 100;
    v_sal number(8,2);
    v_ln varchar(50);
    c_tax constant int := 0;
begin
    dbms_output.put_line(v_ei);
    select last_name, salary
    into v_ln, v_sal
    from employees
    where employee_id = v_ei;
    dbms_output.put_line(v_ln);
end;
/
desc employees;
alter table employees
modify last_name varchar(100);

-- no caso de cima � melhor eu falar para o oracle ir buscar o tipo na tabela direto em tempo de execu��o com o comando abaixo:
declare 
    v_ei integer := 100;
    v_sal number(8,2);
    v_ln employees.last_name%type;
    c_tax constant int := 0;
begin
    dbms_output.put_line(v_ei);
    select last_name, salary
    into v_ln, v_sal
    from employees
    where employee_id = v_ei;
    dbms_output.put_line(v_ln);
end;
/

-- quarto exemplo
declare 
    v_ei integer := 100;
    v_sal employees.salary%type not null;
    v_ln employees.last_name%type;
    c_tax constant int := 0;
    v_sal_comm v_sal%type; --> ele n�o vai funcionar pq ele tb pega o not null e o tipo, ou seja, ele n�o iniciou a variavel declarada
begin
    dbms_output.put_line(v_ei);
    select last_name, salary
    into v_ln, v_sal
    from employees
    where employee_id = v_ei;
    dbms_output.put_line(v_ln);
end;
/


DECLARE
  v_ei integer := 100;
  v_sal EMPLOYEES.salary%TYPE NOT NULL := 10; --NOT NULL indica que deve ser inicializado
  v_ln EMPLOYEES.last_name%TYPE; --melhor do que deixar fixo o tamanho, se for fixo e algu�m rodar alter ferrou
  c_tax CONSTANT int := 0;
  v_sal_comm v_sal%TYPE := 10; --tipo de uma outra vari�vel
  c_tax2 c_tax%TYPE; --isso aqui n�o copia o CONSTANT, s� o tipo int, portanto c_tax2 n�o � CONSTANT
BEGIN
  dbms_output.put_line(v_ei);
  
  c_tax2 := 1;
  c_tax2 := 2;
  
  SELECT last_name, salary
  INTO   v_ln, v_sal
  FROM   EMPLOYEES
  WHERE  employee_id = v_ei;
  
  dbms_output.put_line(v_ln);
END;
/ --> tipo um execute imediatamente, para n�o rodar o que tiver em baixo como se fosse parte do bloco

SET SERVEROUT OFF

DESC EMPLOYEES;
ALTER TABLE EMPLOYEES
MODIFY last_name VARCHAR2(100);

SELECT last_name
FROM   employees
WHERE  employee_id = 100;

SELECT last_name
FROM   employees
WHERE  employee_id = 102;

SELECT last_name
FROM   employees
WHERE  employee_id = 103;
--temos tr�s instru��es diferntes

-- SGA funciona assim
/*
Vai alterando em mem�ria, para depois ir pro disco
Tem o System Global Area, com tr�s estruturas obrigat�rias:
    DB Buffer Cache -> guarda s� dados, insert, update, delete
    Log Buffer -> tudo que � registrado de altera��o na estrutura, nos dados, vai indo para l� --> todo banco transacional tem
        --muito �til para recurpera��o
    Shared Pool -> Pool compartilhado, 6 divis�es, uma dela � a SQL_AREA
        SQL_AREA guarda as isntru��es SQL
        
    Toda instru��o executada passa por fases:
        PARSE -> an�lise de sintaxe, pensar no plano de execu��o etc.
            ap�s executar uma vez vai para a SQL_AREA
            E isso vai sendo empilhado at� ficar cheia
            
            LRU -> Last Recent Used, conforme instru��o for sendo usada vai ficando no top do ranking
                A menos usada vai ficando velha e sai da mem�ria
            
            A cada 100 isntru��es, 99 est� em mem�ria
            Se disparou 1000, precisa ter 10 comandos perdidos
            1% � perdido
            Isso � a m�trica de acerto, se for maior do que isso � mau indicador
            Cada tipo de banco tem uma m�trica base
            
            Isso tr�s ganhos de performance
        BIND -> liga vari�veis
        EXECUTE -> �ndice, etc.
        FETCH -> entrega
    
    Portanto, instru��es com literal � ruim, precisamos manter a mesma instru��o com vari�veis alterando o seu valor,
        nisso o PARSE se mant�m e o plano de execu��o j� estar� pronto para as pr�ximas execu��es
    
    Uma forma � SQL din�mico, usando bind variable, vari�vel de liga��o
    
    Quando encontramos o mesmo comando na SQL_AREA � porque tem algum problema
    PARSE precisa ser um
    
    Quando nos conectamos no banco temos uma �rea s� nossa UGA (User Global Area)
        dentro dela temos um bloco CURSOR_AREA -> s� nosso, � onde fica as vari�veis bind sendo armazenadas
        conex�es consumem o banco
*/

SELECT last_name
FROM   employees
WHERE  employee_id = :b1; --> :b1 � a bind variable

SET SERVEROUT ON
SET AUTOPRINT ON --sai imprimindo tudo

--VARIABLE  --coisa de ambiente externo, n�o tem %TYPE
VAR b_ln VARCHAR2(100)
--obs: n�o existe o tipo VARCHAR, s� VARCHAR2
--NUMBER -> n�o pode ter precis�o
--O erro vai mostrar os tipos permitidos

DECLARE
  v_ei integer := 100;
  v_sal EMPLOYEES.salary%TYPE NOT NULL := 10;
  v_ln EMPLOYEES.last_name%TYPE;
  c_tax CONSTANT int := 0;
  v_sal_comm v_sal%TYPE := 10;
  c_tax2 c_tax%TYPE;
BEGIN
  dbms_output.put_line(v_ei);
  
  c_tax2 := 1;
  c_tax2 := 2;
  
  SELECT last_name, salary
  INTO   :b_ln, v_sal --: diz que a vari�vel � de fora
  FROM   EMPLOYEES
  WHERE  employee_id = v_ei;
  
  dbms_output.put_line(v_ln);
END;
/

PRINT b_ln
--b_ln � vari�vel s� sua

SET SERVEROUT OFF

SELECT * FROM v$sqlarea; --view de desempenho din�mica, VIS�O

-- PARTE 3

SET SERVEROUTPUT ON
DECLARE
 fname VARCHAR2(25);
BEGIN
 --SELECT que n�o retorna dado d� NO_DATA_FOUND
 SELECT first_name 
 INTO fname 
 FROM employees WHERE employee_id=2100;
 DBMS_OUTPUT.PUT_LINE(' First Name is : '||fname);
END;
/

SET SERVEROUTPUT ON
DECLARE
 emp_hiredate   employees.hire_date%TYPE;
 emp_salary     employees.salary%TYPE;  
BEGIN
  SELECT   hire_date, salary
  INTO     emp_hiredate --se quantidade de colunas n�o corresponder vai dar NOT ENOUGH VALUES
  FROM     employees
  WHERE    employee_id = 100;  
END;
/

SET SERVEROUTPUT ON
DECLARE    
   sum_sal  NUMBER(10,2); 
   deptno   NUMBER NOT NULL := 60;           
BEGIN
   SELECT  SUM(salary)  -- group function
   INTO sum_sal FROM employees
   WHERE  department_id = deptno;
   DBMS_OUTPUT.PUT_LINE ('The sum of salary is '  || sum_sal);
END;
/

DECLARE
  hire_date      employees.hire_date%TYPE;
  sysdate        hire_date%TYPE;
  employee_id    employees.employee_id%TYPE := 176;        
BEGIN
  SELECT 	hire_date, sysdate --fun��o
  INTO   	hire_date, sysdate --vari�vel
  FROM   	employees
  WHERE  	employee_id = 176;  --nome da coluna igual a vari�vel
  --poder pode colocar nome de coluna igual a vari�vel, mas alguma hora vai dar ruim 
  /*
  SELECT 	hire_date, sysdate
  INTO   	hire_date, sysdate
  FROM   	employees
  WHERE  	employee_id = employee_id; a engine vai entender que isso � coluna = coluna, nisso vai retornar v�rias linhas
  e vai dar erro
  */
END;
/

SELECT 	hire_date, sysdate
FROM   	employees
WHERE  	employee_id = employee_id;

-- por isso � RECOMEND�VEL padronizar o nome da coluna
-- minimamente v_nome

--INSERT, UPDATE, DELETE dentro de bloco muda nada
BEGIN
 INSERT INTO employees
  (employee_id, first_name, last_name, email,     
   hire_date, job_id, salary)
   VALUES(employees_seq.NEXTVAL, 'Ruth', 'Cores',
   'RCORES',sysdate, 'AD_ASST', 4000);
END;
/

DECLARE					
  sal_increase   employees.salary%TYPE := 800;   
BEGIN
  UPDATE	employees
  SET		salary = salary + sal_increase
  WHERE	job_id = 'ST_CLERK';
END;
/

DECLARE
  deptno   employees.department_id%TYPE := 10; 
BEGIN							
  DELETE FROM   employees
  WHERE  department_id = deptno;
END;
/

-- TODA instru��o SQL � um CURSOR
-- TUDO na Oracle � CURSOR, CURSOR impl�cito, quem declara, manipula e fecha � o Oracle, mas podemos testar o status dele

DECLARE					
  sal_increase   employees.salary%TYPE := 800;   
BEGIN
  UPDATE	employees
  SET		salary = salary + sal_increase
  WHERE	job_id = 'ST_CLERK';
  
  dbms_output.put_line(SQL%ROWCOUNT || ' linha(s) atualizada(s)');
END;
/

DECLARE					
  sal_increase   employees.salary%TYPE := 800;   
BEGIN
  UPDATE	employees
  SET		salary = salary + sal_increase
  WHERE	job_id = 'ST_CLERK';
  COMMIT; -- apaga a transa��o, ent�o n�o vai exibir certo, precisa usar antes
  dbms_output.put_line(SQL%ROWCOUNT || ' linha(s) atualizada(s)');
END;
/

--SQL%ROWCOUNT
--SQL%FOUND
--SQL%NOTFOUND

VARIABLE rows_deleted VARCHAR2(30)
DECLARE
  empno employees.employee_id%TYPE := 176;
BEGIN
  DELETE FROM  employees 
  WHERE employee_id = empno;
  :rows_deleted := (SQL%ROWCOUNT || ' row deleted.');
END;
/
