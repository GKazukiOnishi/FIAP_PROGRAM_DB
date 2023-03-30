/*
    Sequence
    
        Equivalente ao identity, mas a Oracle fez meio diferente
        
        Pode gerar números exclusivos automaticamente
        Objeto compartilhável
        mais eficiente
        Economiza para n precisar gerar o código
        
        CREATE SEQUENCE sequence_name
    
*/

CREATE SEQUENCE dept_deptid_seq;
DROP SEQUENCE dept_deptid_seq;

/*
    Param START WITH -> onde a sequence vai começar, por padrão 1
    Param INCREMENT BY -> por padrão 1
    MAXVALUE -> valor máximo que a sequência chega, 1 * 10^27
    NOCACHE -> não vai armazenar em memória, por default é 20
    NOCYCLE -> MAXVALUE é o último número, se alcançar e for NOCYCLE vai dar erro, com CYCLE ela volta para o MINVALUE
    MINVALUE -> menor valor que a sequência permite
    
    sequência também trabalha com range negativo, vai até -1 * 10^26
    
    ** sequência entrega Números Inteiros **
    
    O único parâmetro que não pode ser alterado é o START WITH
*/

CREATE SEQUENCE dept_deptid_seq
                INCREMENT BY 10
--                START WITH 1000
                MINVALUE 1000
                MAXVALUE 1040
                NOCACHE
                CYCLE;

-- dept_deptid_seq.nextval; -> retorna o próximo valor da sequência

INSERT INTO departments(department_id, department_name, location_id)
VALUES                 (dept_deptid_seq.nextval, 'Support', 2500);

SELECT max(department_id) FROM departments;

SELECT dept_deptid_seq.currval FROM dual;

--dual -> tabela com uma linha e uma coluna, com valor X, coluna dummy, usada para ter um jeito de executar de uma tabela padrão com 1 linha

--Ctrl F10 -> abre nova sql window

--na versão 21 do Oracle temos o EXCEPT, temos também SELECT 3*2;

-- Para usar CURRVAL vc precisa executar o NEXTVAL antes, se não vai reclamar que a sequência não tem valor na sessão

SELECT dept_deptid_seq.nextval FROM dual;

-- Para alterar Start WITH é DROP e recriar

SELECT pf0645.SIS3_SEQ.nextval FROM dual;

/*
    Sinônimos -> nomes curtos para nomes longos
    
    Quando é de outro banco, outro schema, etc.
    Isso ajuda bastante para reduzir o nome
    
    Temos sinônimos públicos também
    PUBLIC SYNONYM
    vai para todos
*/

CREATE SYNONYM SEQ
FOR pf0645.SIS3_SEQ;

SELECT seq.nextval FROM dual;

--ALTER SEQUENCE seq_name ...modificacoes;

DROP SYNONYM SEQ;

/*
    Índices
    
    CREATE INDEX index_name
    ON nome_table(colunas_para_indexar...);
    
    Por padrão cria BTREE, Árvore binária
    
    Objeto de esquema, é um objeto relacional
    Depende da tabela que indexa?
    Índice é uma referência a um dado de tabela
    
    Criando índices, ao mexer em uma tabela, o Oracle também mexe nos ìndices
    
    Facilita I/O? Se indexar tudo, um INSERT vira vários I/Os
    Se indexar tudo, o banco vai usar? Tem regras para isso?
    
    Table Access por Index -> quando busca pelo Index
    Cardinality -> estimativa de linhas
    Cost -> custo para o banco Oracle executar
    
    Sem index temos
    Table Access por Filter Predicates -> vai dar custo maior
        Acesso FULL -> leu a tabela inteira para retornar poucas linhas às vezes
    
    1) As colunas são usadas no WHERE? Se não não tem motivo para index, raramente vai fazer sentido
    
    
*/

CREATE INDEX idx_emp_ln
ON employees(last_name);

SELECT last_name, job_id, salary FROM employees WHERE employee_id = 100;

SELECT last_name, job_id, salary FROM employees WHERE last_name = 'King';

--Mesmo assim o custo da busca pelo last_name vai ser mais lenta, porque a comparação de varchar2 é mais lenta, mais complicada
--Range Scan

-- Comando SELECT BOM tem BAIXA CARDINALIDADE
-- Pois o otimizador está programado para usar índica quando a cardinalidade está abaixo de 7%
-- Se vc manipula menos de 7% ele usa
-- Se vc manipula mais de 10% dependendo não vai usar
-- Isso é programado no Kernel do Banco, não mexemos
-- Por isso a cardinalidade é essencial para o otimizador decidir o que fazer

-- MongoDB, não tem consistência e atomicidade, abre mão disso mas será mais rápido
-- Relacional é isso, garante ACID mas tem isso

-- Oracle vai aprendendo o que é melhor fazer
-- Se ele aprender ele sabe que mesmo buscando 50 ids é melhor usar index
-- Limpando o Cache talvez ele não saiba

SELECT table_name, num_rows FROM user_tables ORDER BY 1;

SELECT COUNT(*) FROM departments;

-- A user_tables é estatística, não atualiza toda hora, atualiza a cada 8h etc.
-- Se de manhã para tarde duplica linhas, já era, o otimizador se perde e não vai entender que é melhor usar índice
-- A estatística deve ser atualizada quando ninguém está mexendo, ou pouco, porque onera o banco
-- Comum casos em que de manhã é rápido depois é lento

-- TODA PK e colunas EXCLUSIVAS Tem INDEX automaticamente
-- Se vc tentar inserir dado duplicado no INDEX dá erro

CREATE TABLE sis3_t (codigo int          constraint sis3_pk primary key,
                     email varchar2(500) constraint sis3_uk unique);
                     
-- Aqui temos dois índices únicos

INSERT INTO sis3_t VALUES(1, 'x');
INSERT INTO sis3_t VALUES(1, 'x'); --Erro de constraint, SIS3_PK é um índice

SELECT index_name FROM user_indexes WHERE table_name = 'SIS3_T'; --Dado em maísculo

-- TODA PK e UK são index

DROP TABLE sis3_t;

CREATE TABLE sis3_t (codigo int          NOT NULL,
                     email varchar2(500) );
                     
CREATE UNIQUE INDEX sis3_pk ON sis3_t(codigo);

INSERT INTO sis3_t VALUES(1, 'x');
INSERT INTO sis3_t VALUES(1, 'x'); --Dá no mesmo ERRO

/*
    Diretrizes no slide, já comentado na aula
    
    Podemos apagar INDEX manuais, mas se a tabela for criada como PK ele reclama
*/