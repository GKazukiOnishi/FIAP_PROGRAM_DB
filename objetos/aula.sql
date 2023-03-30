/*
    Sequence
    
        Equivalente ao identity, mas a Oracle fez meio diferente
        
        Pode gerar n�meros exclusivos automaticamente
        Objeto compartilh�vel
        mais eficiente
        Economiza para n precisar gerar o c�digo
        
        CREATE SEQUENCE sequence_name
    
*/

CREATE SEQUENCE dept_deptid_seq;
DROP SEQUENCE dept_deptid_seq;

/*
    Param START WITH -> onde a sequence vai come�ar, por padr�o 1
    Param INCREMENT BY -> por padr�o 1
    MAXVALUE -> valor m�ximo que a sequ�ncia chega, 1 * 10^27
    NOCACHE -> n�o vai armazenar em mem�ria, por default � 20
    NOCYCLE -> MAXVALUE � o �ltimo n�mero, se alcan�ar e for NOCYCLE vai dar erro, com CYCLE ela volta para o MINVALUE
    MINVALUE -> menor valor que a sequ�ncia permite
    
    sequ�ncia tamb�m trabalha com range negativo, vai at� -1 * 10^26
    
    ** sequ�ncia entrega N�meros Inteiros **
    
    O �nico par�metro que n�o pode ser alterado � o START WITH
*/

CREATE SEQUENCE dept_deptid_seq
                INCREMENT BY 10
--                START WITH 1000
                MINVALUE 1000
                MAXVALUE 1040
                NOCACHE
                CYCLE;

-- dept_deptid_seq.nextval; -> retorna o pr�ximo valor da sequ�ncia

INSERT INTO departments(department_id, department_name, location_id)
VALUES                 (dept_deptid_seq.nextval, 'Support', 2500);

SELECT max(department_id) FROM departments;

SELECT dept_deptid_seq.currval FROM dual;

--dual -> tabela com uma linha e uma coluna, com valor X, coluna dummy, usada para ter um jeito de executar de uma tabela padr�o com 1 linha

--Ctrl F10 -> abre nova sql window

--na vers�o 21 do Oracle temos o EXCEPT, temos tamb�m SELECT 3*2;

-- Para usar CURRVAL vc precisa executar o NEXTVAL antes, se n�o vai reclamar que a sequ�ncia n�o tem valor na sess�o

SELECT dept_deptid_seq.nextval FROM dual;

-- Para alterar Start WITH � DROP e recriar

SELECT pf0645.SIS3_SEQ.nextval FROM dual;

/*
    Sin�nimos -> nomes curtos para nomes longos
    
    Quando � de outro banco, outro schema, etc.
    Isso ajuda bastante para reduzir o nome
    
    Temos sin�nimos p�blicos tamb�m
    PUBLIC SYNONYM
    vai para todos
*/

CREATE SYNONYM SEQ
FOR pf0645.SIS3_SEQ;

SELECT seq.nextval FROM dual;

--ALTER SEQUENCE seq_name ...modificacoes;

DROP SYNONYM SEQ;

/*
    �ndices
    
    CREATE INDEX index_name
    ON nome_table(colunas_para_indexar...);
    
    Por padr�o cria BTREE, �rvore bin�ria
    
    Objeto de esquema, � um objeto relacional
    Depende da tabela que indexa?
    �ndice � uma refer�ncia a um dado de tabela
    
    Criando �ndices, ao mexer em uma tabela, o Oracle tamb�m mexe nos �ndices
    
    Facilita I/O? Se indexar tudo, um INSERT vira v�rios I/Os
    Se indexar tudo, o banco vai usar? Tem regras para isso?
    
    Table Access por Index -> quando busca pelo Index
    Cardinality -> estimativa de linhas
    Cost -> custo para o banco Oracle executar
    
    Sem index temos
    Table Access por Filter Predicates -> vai dar custo maior
        Acesso FULL -> leu a tabela inteira para retornar poucas linhas �s vezes
    
    1) As colunas s�o usadas no WHERE? Se n�o n�o tem motivo para index, raramente vai fazer sentido
    
    
*/

CREATE INDEX idx_emp_ln
ON employees(last_name);

SELECT last_name, job_id, salary FROM employees WHERE employee_id = 100;

SELECT last_name, job_id, salary FROM employees WHERE last_name = 'King';

--Mesmo assim o custo da busca pelo last_name vai ser mais lenta, porque a compara��o de varchar2 � mais lenta, mais complicada
--Range Scan

-- Comando SELECT BOM tem BAIXA CARDINALIDADE
-- Pois o otimizador est� programado para usar �ndica quando a cardinalidade est� abaixo de 7%
-- Se vc manipula menos de 7% ele usa
-- Se vc manipula mais de 10% dependendo n�o vai usar
-- Isso � programado no Kernel do Banco, n�o mexemos
-- Por isso a cardinalidade � essencial para o otimizador decidir o que fazer

-- MongoDB, n�o tem consist�ncia e atomicidade, abre m�o disso mas ser� mais r�pido
-- Relacional � isso, garante ACID mas tem isso

-- Oracle vai aprendendo o que � melhor fazer
-- Se ele aprender ele sabe que mesmo buscando 50 ids � melhor usar index
-- Limpando o Cache talvez ele n�o saiba

SELECT table_name, num_rows FROM user_tables ORDER BY 1;

SELECT COUNT(*) FROM departments;

-- A user_tables � estat�stica, n�o atualiza toda hora, atualiza a cada 8h etc.
-- Se de manh� para tarde duplica linhas, j� era, o otimizador se perde e n�o vai entender que � melhor usar �ndice
-- A estat�stica deve ser atualizada quando ningu�m est� mexendo, ou pouco, porque onera o banco
-- Comum casos em que de manh� � r�pido depois � lento

-- TODA PK e colunas EXCLUSIVAS Tem INDEX automaticamente
-- Se vc tentar inserir dado duplicado no INDEX d� erro

CREATE TABLE sis3_t (codigo int          constraint sis3_pk primary key,
                     email varchar2(500) constraint sis3_uk unique);
                     
-- Aqui temos dois �ndices �nicos

INSERT INTO sis3_t VALUES(1, 'x');
INSERT INTO sis3_t VALUES(1, 'x'); --Erro de constraint, SIS3_PK � um �ndice

SELECT index_name FROM user_indexes WHERE table_name = 'SIS3_T'; --Dado em ma�sculo

-- TODA PK e UK s�o index

DROP TABLE sis3_t;

CREATE TABLE sis3_t (codigo int          NOT NULL,
                     email varchar2(500) );
                     
CREATE UNIQUE INDEX sis3_pk ON sis3_t(codigo);

INSERT INTO sis3_t VALUES(1, 'x');
INSERT INTO sis3_t VALUES(1, 'x'); --D� no mesmo ERRO

/*
    Diretrizes no slide, j� comentado na aula
    
    Podemos apagar INDEX manuais, mas se a tabela for criada como PK ele reclama
*/