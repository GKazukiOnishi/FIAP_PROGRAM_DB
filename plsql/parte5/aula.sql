/*
Registro
    pode ser baseado em tabela, sinonimo, view, cursor
    
    Armazena v�rios dados em uma tabela
    
    tabela.rowtype% declara um registro do tipo da tabela
    
    select * into variavelRegistro from tabela;
    
    insert into tabela values variavelRegistro;
    
    UPDATE retired_emps SET ROW = emp_rec WHERE empno=&employee_number;
    
Cursor
    Cursor impl�cito, ROWCOUNT, etc.
        declarados para todos os selects, dmls
    
    Cursores expl�citos: declarados e nomeados pelo programador
        Criamos um SELECT qualquer
        
        Os dados do Cursor podem ser extra�dos em vari�veis ou registros
        
        DECLARE
        OPEN
        FETCH
        EMPTY?
        CLOSE
        
        Ao abrir um cursor, o pointer fica na primeira linha
        Fetch carrega a linha que est� no pointer e avan�a o pointer
        D� para dar fetch at� n�o ter mais linhas
        A� fechamos o cursor
        
        Usando o FOR com Cursor ele facilita porque abre, extrai e fecha implicitamente, registro � declaro implicitamente tamb�m
        Com os outros precisa do OPEN, FETCH, condi��o de exit com cursor%found ou cursor%notfound e CLOSE
        
        atributos implicitos do cursor
            %ISOPEN
            %NOTFOUND
            %FOUND
            %ROWCOUNT
        
begin
  for REG_EMP in (select last_name, salary
                  from employees
                  where department_id=90) loop
    dbms_output.put_line (REG_EMP.last_name || ' ' || REG_EMP.salary);
  end loop;
end;
/
        SELECT trabalha com FOR, ent�o o c�digo acima j� funciona
        
        SELECT ROWNUM FROM tabela WHERE ROWNUM < 11;
        SELECT * FROM TABELA FETCH FIRST 10 ROWS ONLY; --mais leve do que ficar fazendo condi��es no loop
        Ou executa o cursor at� %ROWCOUNT > 10
        
*/