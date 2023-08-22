-- https://docs.oracle.com/cd/B10501_01/appdev.920/a96624/07_errs.htm#784

/*

Exceções
    Predefinidas
        NO_DATA_FOUND
        TOO_MANY_ROWS
        OTHERS -> genérica
        INVALID_CURSOR
        ZERO_DIVIDE
        DUP_VAL_ON_INDEX -> PK duplicada

        DECLARE
           v_lname employees.last_name%type;
        BEGIN
           SELECT last_name
           INTO   v_lname
           FROM   employees
           WHERE  first_name = 'John';
           
           dbms_output.put_line ('John''s last name is: '||v_lname);  
        EXCEPTION 
           WHEN NO_DATA_FOUND THEN
               dbms_output.put_line ('Funcionário não existe.');
           WHEN TOO_MANY_ROWS THEN
               dbms_output.put_line ('Your select statment retrived mulplite rows.');
           WHEN OTHERS THEN
               dbms_output.put_line ('Erro');
        END;
        /
    Não predefinidas

        DECLARE
           v_dept_id   DEPARTMENTS.DEPARTMENT_ID%TYPE := 280;
           v_dept_name DEPARTMENTS.DEPARTMENT_NAME%TYPE;
           e_insert_exception EXCEPTION;
           PRAGMA EXCEPTION_INIT(e_insert_exception,-01400);
        BEGIN
           INSERT INTO departments (department_id,department_name)
           VALUES (v_dept_id,v_dept_name);
           COMMIT;
        EXCEPTION
            WHEN e_insert_exception THEN
              ROLLBACK;
              dbms_output.put_line ('INSERT OPERATION FAILED');
              dbms_output.put_line ('ERROR CODE:'||CHR(10)||SQLCODE); --SQL CODE -> Código do erro
              dbms_output.put_line ('ERROR MESSAGE:'||CHR(10)||SQLERRM); --SQLERRM -> Mensagem de erro
        END;
        /
    Definidas pelo usuário

        DECLARE
           v_depno number := 500;
           v_name  varchar(20) := 'Testing';
           e_invalid_dept EXCEPTION;
        BEGIN
           UPDATE departments
           SET    department_name = v_name
           WHERE  department_id = v_depno;
           
           IF SQL%NOTFOUND THEN
              RAISE e_invalid_dept; --Lançamento de exceção
           END IF;
           
           COMMIT;  
        EXCEPTION
           WHEN e_invalid_dept THEN
              dbms_output.put_line ('No such department id '||v_depno);
        END;
        /

*/

DROP TABLE LOG_ERROR_MESSAGE;
CREATE TABLE LOG_ERROR_MESSAGE
(CODE INT,
MESSAGE VARCHAR(100));

DECLARE
   e_cod  log_error_message.code%type;
   e_msg  log_error_message.message%type;
   e_insert_exception EXCEPTION;
   PRAGMA EXCEPTION_INIT(e_insert_exception,-01400);  
BEGIN
   INSERT INTO departments (department_id,department_name)
   VALUES (280,NULL);
   COMMIT;
EXCEPTION
    WHEN e_insert_exception THEN
      ROLLBACK;
      dbms_output.put_line ('Error, see log:||chr(10)
                                            || select * from LOG_ERROR_MESSAGE;');
      e_cod := SQLCODE; --Necessário para conseguir inserir, caso contrário levanta erro
      e_msg := SQLERRM;
      INSERT INTO LOG_ERROR_MESSAGE -- Forma de obter uma rastreabilidade dos erros do ambiente
      VALUES (e_cod,e_msg);
      COMMIT;
END;
/
select * from LOG_ERROR_MESSAGE; 


--Exercício

--1 Exe de cursor e rowtype

CREATE TABLE TOP_DOGS
(name VARCHAR2(25),
salary NUMBER(11,2));

SET VERIFY OFF
SET FEED OFF
CL SCR
SET SERVEROUT ON

ACCEPT P_NUM_MAIOR_SAL PROMPT 'Informe o número de maiores salários'

DECLARE
  v_n_maior_sal NUMBER(3) := &P_NUM_MAIOR_SAL;
  
  CURSOR c_maiores_sal IS
    SELECT last_name,
           salary
    FROM   employees
    ORDER  BY salary DESC;
  reg_emp c_maiores_sal%ROWTYPE;
  v_count NUMBER(3) := 0;
BEGIN
  OPEN c_maiores_sal;
  LOOP
     FETCH c_maiores_sal INTO reg_emp;
     EXIT WHEN c_maiores_sal%NOTFOUND OR v_count = v_n_maior_sal;
     v_count := v_count + 1;
     
     INSERT INTO TOP_DOGS(name, salary) VALUES(reg_emp.last_name, reg_emp.salary);
  END LOOP;
  CLOSE c_maiores_sal;
END;
/

SELECT * FROM TOP_DOGS;

TRUNCATE TABLE TOP_DOGS;


ACCEPT P_NUM_MAIOR_SAL PROMPT 'Informe o número de maiores salários'

DECLARE
  v_n_maior_sal NUMBER(3) := &P_NUM_MAIOR_SAL;
BEGIN
  FOR reg_emp IN (SELECT last_name,
                         salary
                  FROM   employees
                  ORDER  BY salary DESC
                  FETCH FIRST v_n_maior_sal ROWS ONLY) LOOP
     INSERT INTO TOP_DOGS(name, salary) VALUES(reg_emp.last_name, reg_emp.salary);
  END LOOP;
  COMMIT;
END;
/



--1 Exe de exceção

CREATE TABLE MESSAGES 
(results VARCHAR(200));

--TRUNCATE TABLE messages;
SET VERIFY OFF
DEFINE p_sal = 100000
DECLARE
    v_last_name employees.last_name%TYPE;
    v_salary    employees.salary%TYPE := &p_sal;
BEGIN
    SELECT last_name
    INTO   v_last_name
    FROM   employees
    WHERE   salary = v_salary;

    INSERT INTO messages  
    VALUES ( v_last_name|| ' - '|| v_salary );
    
    COMMIT;
EXCEPTION
    WHEN no_data_found THEN
        INSERT INTO messages
        VALUES ( 'No employee with a salary of ' || v_salary);
    WHEN too_many_rows THEN
        INSERT INTO messages 
        VALUES ( 'More than one employee with a salary of ' || v_salary );
    WHEN OTHERS THEN
        INSERT INTO messages 
        VALUES ( 'Some other error occurred.' );
END;
/

SELECT *
FROM messages;

