--SELECT INTO
set serverout on
declare
   v_dept_id  departments.department_id%type;
   v_dept_name departments.department_name%type;
   v_mgr_id    departments.manager_id%type;
   v_loc_id    departments.location_id%type;
begin
    select department_id,department_name,manager_id,location_id
    into v_dept_id, v_dept_name, v_mgr_id, v_loc_id
    from departments
    where department_id=90;
    
    dbms_output.put_line (v_dept_id|| ' ' || v_dept_name || ' ' || v_mgr_id || ' ' || v_loc_id);
end;
/

--SELECT INTO 
set serverout on
declare
   v_dept_id  departments.department_id%type;
   v_dept_name departments.department_name%type;
   v_mgr_id    departments.manager_id%type;
   v_loc_id    departments.location_id%type;
begin
    select *
    into v_dept_id, v_dept_name, v_mgr_id, v_loc_id
    from departments
    where department_id=90;
    
    dbms_output.put_line (v_dept_id|| ' ' || v_dept_name || ' ' || v_mgr_id || ' ' || v_mgr_id);
end;
/
--SELECT REGISTRO PL/SQL
set serverout on
declare
   reg_dept departments%rowtype;
begin
    select *
    into reg_dept
    from departments
    where department_id=90;
    
    dbms_output.put_line (reg_dept.department_id|| ' ' || reg_dept.department_name || ' ' || reg_dept.manager_id || ' ' || reg_dept.location_id);
end;
/

--CURSOR
declare
   v_ln  employees.last_name%type;
   v_sal employees.salary%type;
   cursor cur_Dept is
       select last_name,salary
       from employees
       where department_id=90;
begin
  open   cur_Dept;
  fetch cur_Dept into v_ln,v_sal;
  dbms_output.put_line (v_ln || ' ' || v_sal);
  close cur_Dept;
end;
/


declare
   v_ln  employees.last_name%type;
   v_sal employees.salary%type;
   cursor cur_Dept is
       select last_name,salary
       from employees
       where department_id=90;
begin
  open   cur_Dept;
  fetch cur_Dept into v_ln,v_sal; --Se essa linha estiver comentada, não vai dar %found, porque o fetch não rodou então está sem dado ainda
  while cur_Dept%found loop
     dbms_output.put_line (v_ln || ' ' || v_sal);
     fetch cur_Dept into v_ln,v_sal;
   end loop;
  close cur_Dept;
end;
/

declare
   v_ln  employees.last_name%type;
   v_sal employees.salary%type;
   cursor cur_Dept is
       select last_name,salary
       from employees
       where department_id=90;
    REG_EMP cur_Dept%rowtype; --Registro baseado em cursor, melhor do que criar registro pra linha toda mas usar 2 campos só
begin
  open   cur_Dept;
  loop
     fetch cur_Dept into v_ln,v_sal;
     exit when cur_Dept%notfound;
     dbms_output.put_line (v_ln || ' ' || v_sal);
   end loop;
  close cur_Dept;
end;
/

declare
  cursor cur_Dept is
    select last_name, salary
    from employees
    where department_id=90;
begin
  for REG_EMP in cur_Dept loop
    dbms_output.put_line (REG_EMP.last_name || ' ' || REG_EMP.salary);
  end loop;
end;
/

begin
  for REG_EMP in (select last_name, salary
                  from employees
                  where department_id=90) loop
    dbms_output.put_line (REG_EMP.last_name || ' ' || REG_EMP.salary);
  end loop;
end;
/

--Alt F10 abre outra janela
