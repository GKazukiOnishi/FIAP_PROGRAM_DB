-- 3. Qual dos operadores de conjunto retorna todas as linhas distintas selecionadas pelas duas consultas?
-- UNION

-- 4.
/*
SELECT titulo FROM livros
MINUS
SELECT l.titulo
FROM   emprestimos e INNER JOIN livros l
ON     e.cod_livro = l.cod_livro
WHERE  e.data_dev IS NULL;
*/

-- 5.
CREATE TABLE my_brick_collection (
  colour VARCHAR2(50),
  shape VARCHAR2(50),
  weight NUMBER(3)
);

CREATE TABLE your_brick_collection (
  height NUMBER(3),
  width NUMBER(3),
  depth NUMBER(3),
  colour VARCHAR2(50),
  shape VARCHAR2(50)
);

INSERT INTO my_brick_collection VALUES('red', 'cube', 10);
INSERT INTO my_brick_collection VALUES('blue', 'cuboid', 8);
INSERT INTO my_brick_collection VALUES('green', 'pyramid', 20);
INSERT INTO my_brick_collection VALUES('green', 'pyramid', 20);
INSERT INTO my_brick_collection VALUES(null, 'cuboid', 20);

INSERT INTO your_brick_collection VALUES(2, 2, 2, 'red', 'cube');
INSERT INTO your_brick_collection VALUES(2, 2, 2, 'blue', 'cube');
INSERT INTO your_brick_collection VALUES(2, 2, 8, null, 'cuboid');

COMMIT;

SELECT shape FROM my_brick_collection
UNION ALL
SELECT shape FROM your_brick_collection
ORDER BY shape;

-- 6.
SELECT colour FROM my_brick_collection
UNION
SELECT colour FROM your_brick_collection
ORDER BY colour;

-- 7.
SELECT shape FROM my_brick_collection
MINUS
SELECT shape FROM your_brick_collection;

-- 8.
SELECT colour FROM my_brick_collection
INTERSECT
SELECT colour FROM your_brick_collection
ORDER BY colour;

-- 9.
-- Todos os operadores de conjunto têm a mesma precedência.

-- 10.
SELECT   department_id, MIN(salary)
FROM     employees
GROUP BY department_id
HAVING   MIN(salary) >
                       (SELECT MIN(salary)
                        FROM   employees
                        WHERE  department_id = 50);
                        
-- 11.
select region_name
from regions
intersect
select region_name
from regions r join countries c
on (r.region_id = c.region_id);

-- 12.
select department_name,avg(salary)
from   employees e join departments d
on     d.department_id=e.department_id
group  by department_name
having avg(salary) > (select avg(salary)
                      from employees);

