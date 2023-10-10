--Exemplo 1

CREATE OR REPLACE PACKAGE comm_pkg IS
    std_comm NUMBER := 0.10;  --initialized to 0.10
    FUNCTION validate (
        comm NUMBER
    ) RETURN BOOLEAN; --Se não especificar a function validate fica privada
    PROCEDURE reset_comm (
        new_comm NUMBER
    );

END comm_pkg;
/


--Exemplo 2
CREATE OR REPLACE PACKAGE BODY comm_pkg IS

    FUNCTION validate (
        comm NUMBER
    ) RETURN BOOLEAN IS
        max_comm employees.commission_pct%TYPE;
    BEGIN
        SELECT
            MAX(commission_pct)
        INTO max_comm
        FROM
            employees;

        RETURN ( comm BETWEEN 0.0 AND max_comm );
    END validate;

    PROCEDURE reset_comm (
        new_comm NUMBER
    ) IS
    BEGIN
        IF validate(new_comm) THEN
            std_comm := new_comm; -- reset public var
        ELSE
            raise_application_error(-20210, 'Bad Commission');
        END IF;
    END reset_comm;

END comm_pkg;
/

DESC COMM_PKG;

-- Exemplo 3
CREATE OR REPLACE PROCEDURE raise_salary (
    id      IN employees.employee_id%TYPE,
    percent IN NUMBER
) IS
    e_no_update EXCEPTION;
BEGIN
    UPDATE employees
    SET
        salary = salary * ( 1 + percent / 100 )
    WHERE
        employee_id = id;

    IF SQL%notfound THEN
        RAISE e_no_update;
    ELSE
        dbms_output.put_line('Salary Updated');
    END IF;

EXCEPTION
    WHEN e_no_update THEN
        dbms_output.put_line('ID Not found');
END raise_salary;
/

CREATE OR REPLACE FUNCTION get_sal (
    id employees.employee_id%TYPE
) RETURN NUMBER IS
    sal employees.salary%TYPE := 0;
BEGIN
    SELECT
        salary
    INTO sal
    FROM
        employees
    WHERE
        employee_id = id;

    RETURN sal;
END get_sal;
/

CREATE OR REPLACE PACKAGE raise_get_sal IS
    PROCEDURE raise_salary (
        id      IN employees.employee_id%TYPE,
        percent IN NUMBER
    );

    FUNCTION get_sal (
        id employees.employee_id%TYPE
    ) RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE BODY raise_get_sal IS
    PROCEDURE raise_salary (
        id      IN employees.employee_id%TYPE,
        percent IN NUMBER
    ) IS
        e_no_update EXCEPTION;
    BEGIN
        UPDATE employees
        SET
            salary = salary * ( 1 + percent / 100 )
        WHERE
            employee_id = id;

        IF SQL%notfound THEN
            RAISE e_no_update;
        ELSE
            dbms_output.put_line('Salary Updated');
        END IF;

    EXCEPTION
        WHEN e_no_update THEN
            dbms_output.put_line('ID Not found');
    END raise_salary;

    FUNCTION get_sal (
        id employees.employee_id%TYPE
    ) RETURN NUMBER IS
        sal employees.salary%TYPE := 0;
    BEGIN
        SELECT
            salary
        INTO sal
        FROM
            employees
        WHERE
            employee_id = id;

        RETURN sal;
    END get_sal;
END;
/

DROP FUNCTION GET_SAL;
DROP PROCEDURE RAISE_SALARY;

EXEC RAISE_GET_SAL.raise_salary(100, 1);
SELECT RAISE_GET_SAL.get_sal(100) FROM dual;

DESC RAISE_GET_SAL;

DESC DBMS_OUTPUT;

SET SERVEROUT ON
EXEC SYS.DBMS_OUTPUT.PUT_LINE('Oi');