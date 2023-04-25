--SET SERVEROUTPUT ON
SET SERVEROUT ON
--comando da IDE para ligar o put line, n�o � do PLSQL

CL SCR
CLEAR SCREEN

--DECLARE
BEGIN
  --DBMS_OUTPUT PACKAGE - PUT_LINE - PROCEDIMENTO
  /*coment�rio de bloco*/
  DBMS_OUTPUT.PUT_LINE('Hello World');
--EXCEPTION
END;
/

SET SERVEROUT OFF
DESC DBMS_OUTPUT;

-- Obs: ao tomar erro, a IDE vai indicar a linha do erro come�ando em 1 no BEGIN do bloco

DECLARE
  amount INTEGER(10) := 10;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Hello World');
  DBMS_OUTPUT.PUT_LINE(amount);
END;
/

ACCEPT P_EMP_ID PROMPT 'Informe o n�mero do funcion�rio'
ACCEPT P_LAST_NAME PROMPT 'Informe o nome do funcion�rio'

DECLARE
  v_emp_id NUMBER(5) := 10;
  v_count INT := 1;
  v_tax NUMBER(3,1) NOT NULL := 10; --vari�vel obrigat�ria, ou seja, vc precisa iniciar sempre
  c_tax CONSTANT INT := 100; --valor que nunca muda
  v_tax2 NUMBER(3,1) NOT NULL DEFAULT 10; --DEFAULT � a mesma coisa que := na inicializa��o (no declare)
  v_emp_id2 NUMBER(5) := &P_EMP_ID;
  v_ln VARCHAR2(100) := '&P_LAST_NAME';
BEGIN
  v_emp_id := 11;
  DBMS_OUTPUT.PUT_LINE(v_emp_id);
  DBMS_OUTPUT.PUT_LINE(v_count);
  v_count := v_count + 1;
  DBMS_OUTPUT.PUT_LINE(v_count);
  
  --c_tax := 30; --n�o pode, � constante
END;
/

CREATE OR REPLACE SYNONYM dbmsout FOR DBMS_OUTPUT;

BEGIN
  dbmsout.put_line('teste');
END;
/

ACCEPT P_EMP_ID PROMPT 'Informe o n�mero do funcion�rio'
ACCEPT P_LAST_NAME PROMPT 'Informe o nome do funcion�rio'

DECLARE
  v_emp_id NUMBER(5) := &P_EMP_ID;
  v_ln VARCHAR2(100) := INITCAP('&P_LAST_NAME');
BEGIN
  dbmsout.put_line(v_emp_id);
  dbmsout.put_line(v_ln);
END;
/