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
-- colunas e linhas vão sendo processadas e jogadas em alguma variável para cada linha
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
-- dou um desc employees para conseguir entender qual o salario especificado, eu não posso usar um v_sal number (5) pq nesse caso o salario é um nuber (8,2)
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

-- no caso de cima é melhor eu falar para o oracle ir buscar o tipo na tabela direto em tempo de execução com o comando abaixo:
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
    v_sal_comm v_sal%type; --> ele não vai funcionar pq ele tb pega o not null e o tipo, ou seja, ele não iniciou a variavel declarada
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
  v_ln EMPLOYEES.last_name%TYPE; --melhor do que deixar fixo o tamanho, se for fixo e alguém rodar alter ferrou
  c_tax CONSTANT int := 0;
  v_sal_comm v_sal%TYPE := 10; --tipo de uma outra variável
  c_tax2 c_tax%TYPE; --isso aqui não copia o CONSTANT, só o tipo int, portanto c_tax2 não é CONSTANT
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
/ --> tipo um execute imediatamente, para não rodar o que tiver em baixo como se fosse parte do bloco

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
--temos três instruções diferntes

-- SGA funciona assim
/*
Vai alterando em memória, para depois ir pro disco
Tem o System Global Area, com três estruturas obrigatórias:
    DB Buffer Cache -> guarda só dados, insert, update, delete
    Log Buffer -> tudo que é registrado de alteração na estrutura, nos dados, vai indo para lá --> todo banco transacional tem
        --muito útil para recurperação
    Shared Pool -> Pool compartilhado, 6 divisões, uma dela é a SQL_AREA
        SQL_AREA guarda as isntruções SQL
        
    Toda instrução executada passa por fases:
        PARSE -> análise de sintaxe, pensar no plano de execução etc.
            após executar uma vez vai para a SQL_AREA
            E isso vai sendo empilhado até ficar cheia
            
            LRU -> Last Recent Used, conforme instrução for sendo usada vai ficando no top do ranking
                A menos usada vai ficando velha e sai da memória
            
            A cada 100 isntruções, 99 está em memória
            Se disparou 1000, precisa ter 10 comandos perdidos
            1% é perdido
            Isso é a métrica de acerto, se for maior do que isso é mau indicador
            Cada tipo de banco tem uma métrica base
            
            Isso trás ganhos de performance
        BIND -> liga variáveis
        EXECUTE -> índice, etc.
        FETCH -> entrega
    
    Portanto, instruções com literal é ruim, precisamos manter a mesma instrução com variáveis alterando o seu valor,
        nisso o PARSE se mantém e o plano de execução já estará pronto para as próximas execuções
    
    Uma forma é SQL dinâmico, usando bind variable, variável de ligação
    
    Quando encontramos o mesmo comando na SQL_AREA é porque tem algum problema
    PARSE precisa ser um
    
    Quando nos conectamos no banco temos uma área só nossa UGA (User Global Area)
        dentro dela temos um bloco CURSOR_AREA -> só nosso, é onde fica as variáveis bind sendo armazenadas
        conexões consumem o banco
*/

SELECT last_name
FROM   employees
WHERE  employee_id = :b1; --> :b1 é a bind variable

SET SERVEROUT ON
SET AUTOPRINT ON --sai imprimindo tudo

--VARIABLE  --coisa de ambiente externo, não tem %TYPE
VAR b_ln VARCHAR2(100)
--obs: não existe o tipo VARCHAR, só VARCHAR2
--NUMBER -> não pode ter precisão
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
  INTO   :b_ln, v_sal --: diz que a variável é de fora
  FROM   EMPLOYEES
  WHERE  employee_id = v_ei;
  
  dbms_output.put_line(v_ln);
END;
/

PRINT b_ln
--b_ln é variável só sua

SET SERVEROUT OFF

SELECT * FROM v$sqlarea; --view de desempenho dinâmica, VISÃO

-- PARTE 3

SET SERVEROUTPUT ON
DECLARE
 fname VARCHAR2(25);
BEGIN
 --SELECT que não retorna dado dá NO_DATA_FOUND
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
  INTO     emp_hiredate --se quantidade de colunas não corresponder vai dar NOT ENOUGH VALUES
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
  SELECT 	hire_date, sysdate --função
  INTO   	hire_date, sysdate --variável
  FROM   	employees
  WHERE  	employee_id = 176;  --nome da coluna igual a variável
  --poder pode colocar nome de coluna igual a variável, mas alguma hora vai dar ruim 
  /*
  SELECT 	hire_date, sysdate
  INTO   	hire_date, sysdate
  FROM   	employees
  WHERE  	employee_id = employee_id; a engine vai entender que isso é coluna = coluna, nisso vai retornar várias linhas
  e vai dar erro
  */
END;
/

SELECT 	hire_date, sysdate
FROM   	employees
WHERE  	employee_id = employee_id;

-- por isso é RECOMENDÁVEL padronizar o nome da coluna
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

-- TODA instrução SQL é um CURSOR
-- TUDO na Oracle é CURSOR, CURSOR implícito, quem declara, manipula e fecha é o Oracle, mas podemos testar o status dele

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
  COMMIT; -- apaga a transação, então não vai exibir certo, precisa usar antes
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
