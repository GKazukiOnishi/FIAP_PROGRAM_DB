set serverout on
DECLARE
   v_lname employees.last_name%type;
BEGIN
   SELECT last_name
   INTO   v_lname
   FROM   employees
   WHERE  first_name = 'John';
   dbms_output.put_line ('John''s last name is: '||v_lname);
END;
/
------------------------------------------------------------------------
--PREDEFINIDA
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
------------------------------------------------------------------------
DECLARE
   v_dept_id   DEPARTMENTS.DEPARTMENT_ID%TYPE := 280;
   v_dept_name DEPARTMENTS.DEPARTMENT_NAME%TYPE;
BEGIN
   INSERT INTO departments (department_id,department_name)
   VALUES (v_dept_id,v_dept_name);
   COMMIT;
END;
/
------------------------------------------------------------------------
--NAO PREDEFINIDA
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
      dbms_output.put_line ('ERROR CODE:'||CHR(10)||SQLCODE);
      dbms_output.put_line ('ERROR MESSAGE:'||CHR(10)||SQLERRM);
END;
/
------------------------------------------------------------------------
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
      e_cod := SQLCODE;
      e_msg := SQLERRM;
      INSERT INTO LOG_ERROR_MESSAGE
      VALUES (e_cod,e_msg);
      COMMIT;
END;
/
select * from LOG_ERROR_MESSAGE;
------------------------------------------------------------------------
--DEFINIDA PELO USUARIO
DECLARE
   v_depno number := 500;
   v_name  varchar(20) := 'Testing';
   e_invalid_dept EXCEPTION;
BEGIN
   UPDATE departments
   SET    department_name = v_name
   WHERE  department_id = v_depno;
   
   IF SQL%NOTFOUND THEN
      RAISE e_invalid_dept;
   END IF;
   
   COMMIT;  
EXCEPTION
   WHEN e_invalid_dept THEN
      dbms_output.put_line ('No such department id '||v_depno);
END;
/
