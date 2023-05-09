SET SERVEROUTPUT ON

--CONDICIONAIS
DECLARE
  myage NUMBER := 31;
BEGIN
  IF myage < 11 THEN
    dbms_output.put_line(' I am a child ');
  END IF;
END;
/

DECLARE
  myage NUMBER := 31;
BEGIN
  IF myage < 11 THEN
    dbms_output.put_line(' I am a child ');
  ELSE
    dbms_output.put_line(' I am not a child ');
  END IF;
END;
/

DECLARE
  myage NUMBER := 31;
BEGIN
  IF myage < 11 THEN
    dbms_output.put_line(' I am a child ');
  ELSIF myage < 20 THEN
    dbms_output.put_line(' I am young ');
  ELSIF myage < 30 THEN
    dbms_output.put_line(' I am in my twenties');
  ELSIF myage < 40 THEN
    dbms_output.put_line(' I am in my thirties');
  ELSE
    dbms_output.put_line(' I am always young ');
  END IF;
END;
/

DECLARE
  myage NUMBER;
BEGIN
  IF myage < 11 --null < 11, se tem null dá false sempre
   THEN
    dbms_output.put_line(' I am a child ');
  ELSE
    dbms_output.put_line(' I am not a child ');
  END IF;
END;
/

DECLARE
  myage NUMBER;
BEGIN
  IF myage IS NULL THEN
    dbms_output.put_line(' I am a child ');
  ELSE
    dbms_output.put_line(' I am not a child ');
  END IF;
END;
/

DECLARE
  myage NUMBER;
BEGIN
  IF myage IS NOT NULL THEN
    dbms_output.put_line(' I am a child ');
  ELSE
    dbms_output.put_line(' I am not a child ');
  END IF;
END;
/

-- Expressão CASE -> atribuir em algum lugar o resultado do CASE
-- Instrução CASE -> switch case, executa algo

SET SERVEROUTPUT ON
SET VERIFY OFF

DECLARE
  grade     CHAR(1) := upper('&grade');
  appraisal VARCHAR2(20);
BEGIN
  appraisal :=
    CASE grade
      WHEN 'A' THEN
        'Excellent'
      WHEN 'B' THEN
        'Very Good'
      WHEN 'C' THEN
        'Good'
      ELSE 'No such grade'
    END; --Se termina com END é expressão
      -- Instrução termina com END CASE
  dbms_output.put_line('Grade: '
                       || grade
                       || ' Appraisal '
                       || appraisal);
END;
/

DECLARE
  grade     CHAR(1) := upper('&grade');
  appraisal VARCHAR2(20);
BEGIN
  appraisal :=
    CASE
      WHEN grade = 'A' THEN
        'Excellent' --usando operadores lógicos
      WHEN grade IN ( 'B', 'C' ) THEN
        'Good'
      ELSE 'No such grade'
    END;

  dbms_output.put_line('Grade: '
                       || grade
                       || ' Appraisal '
                       || appraisal);
END;
/

DECLARE
  deptid   NUMBER;
  deptname VARCHAR2(20);
  emps     NUMBER;
  mngid    NUMBER := 108;
BEGIN
  CASE mngid
    WHEN 108 THEN
      SELECT
        department_id,
        department_name
      INTO
        deptid,
        deptname
      FROM
        departments
      WHERE
        manager_id = mngid;

      SELECT
        COUNT(*)
      INTO emps
      FROM
        employees
      WHERE
        department_id = deptid;

    WHEN 200 THEN
      mngid := 100;
  END CASE; --INSTRUÇÃO CASE, Seletor
  dbms_output.put_line('You are working in the '
                       || deptname
                       || ' department. 
                      There are '
                       || emps
                       || ' employees in this department');

END;
/

-- LAÇOS

--basic loop, entra nele depois verifica

DECLARE
  countryid locations.country_id%TYPE := 'CA';
  loc_id    locations.location_id%TYPE;
  counter   NUMBER(2) := 1;
  new_city  locations.city%TYPE := 'Montreal';
BEGIN
  SELECT
    MAX(location_id)
  INTO loc_id
  FROM
    locations
  WHERE
    country_id = countryid;

  LOOP
    INSERT INTO locations (
      location_id,
      city,
      country_id
    ) VALUES (
      ( loc_id + counter ),
      new_city,
      countryid
    );

    counter := counter + 1;
    EXIT WHEN counter > 3; --nesse ponto já inseriu
    --posso contar quantas vezes vai passar por aqui
    -- rodará 3 vezes
  END LOOP;

END;
/

DECLARE
  countryid locations.country_id%TYPE := 'CA';
  loc_id    locations.location_id%TYPE;
  new_city  locations.city%TYPE := 'Montreal';
  counter   NUMBER := 1;
BEGIN
  SELECT
    MAX(location_id)
  INTO loc_id
  FROM
    locations
  WHERE
    country_id = countryid;

  WHILE counter <= 3 LOOP --nesse ponto ainda não inseriu, vai validar isso 4 vezes, mas na 4 não vai ter rodado, então inseriu 3
    INSERT INTO locations (
      location_id,
      city,
      country_id
    ) VALUES (
      ( loc_id + counter ),
      new_city,
      countryid
    );

    counter := counter + 1;
  END LOOP;

END;
/

DECLARE
  countryid locations.country_id%TYPE := 'CA';
  loc_id    locations.location_id%TYPE;
  new_city  locations.city%TYPE := 'Montreal';
BEGIN
  SELECT
    MAX(location_id)
  INTO loc_id
  FROM
    locations
  WHERE
    country_id = countryid;

  FOR i IN 1..3 LOOP
    INSERT INTO locations (
      location_id,
      city,
      country_id
    ) VALUES (
      ( loc_id + i ),
      new_city,
      countryid
    );

  END LOOP;

END;
/

BEGIN
  --não precisa declarar o i
  FOR v_count IN 1..10 LOOP
    --v_count := v_count + 1; não se altera um contador do FOR
    IF MOD(v_count, 2) = 0 THEN
      dbms_output.put_line(v_count);
    END IF;
  END LOOP;

END;
/

DECLARE
  vi NUMBER(3, 1) := 1.2;
  vf NUMBER(3, 1) := 10.5;
BEGIN
  --não precisa declarar o i
  -- como v_count é inteiro, ele arredonda
  -- se maior ou igual a 5 vai para cima
  -- se menor que 5 mantém
  FOR v_count IN vi..vf LOOP --ROUND(vi, 0)
    dbms_output.put_line(v_count);
  END LOOP;

END;
/

DECLARE
  vi NUMBER(3, 1) := 1.2;
  vf NUMBER(3, 1) := 10.5;
  v_count VARCHAR2(1) := 'X';
BEGIN
  dbms_output.put_line(v_count); --escopo do bloco
  FOR v_count IN vi..vf LOOP
    dbms_output.put_line(v_count); --escopo do FOR, só existe dentro do laço o v_count
  END LOOP;
  dbms_output.put_line(v_count); --escopo do bloco
END;
/

DECLARE
  vi NUMBER(3, 1) := 1;
  vf NUMBER(3, 1) := 10;
BEGIN
  FOR v_count IN vf..vi LOOP --funciona mas exibe nada
    dbms_output.put_line(v_count);
  END LOOP;
END;
/


DECLARE
  vi NUMBER(3, 1) := 1;
  vf NUMBER(3, 1) := 10;
BEGIN
  FOR v_count IN REVERSE vi..vf LOOP -- inverte
    dbms_output.put_line(v_count);
  END LOOP;
END;
/