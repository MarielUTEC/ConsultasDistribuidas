CREATE EXTENSION postgres_fdw;

CREATE SERVER worker1
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'worker1', port '5432', dbname 'db2');

CREATE SERVER worker2
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'worker2', port '5432', dbname 'db3');

-- Crear un mapeo de usuario para worker1
CREATE USER MAPPING FOR user1
SERVER worker1
OPTIONS (user 'user2', password '123456');
-- Crear un mapeo de usuario para worker2
CREATE USER MAPPING FOR user1
SERVER worker2
OPTIONS (user 'user3', password '123456');


-- Para Worker 1
IMPORT FOREIGN SCHEMA public
LIMIT TO (medico_1)
FROM SERVER worker1
INTO public;

IMPORT FOREIGN SCHEMA public
LIMIT TO (medico_2)
FROM SERVER worker1
INTO public;

IMPORT FOREIGN SCHEMA public
LIMIT TO (diagnostico_1)
FROM SERVER worker1
INTO public;

IMPORT FOREIGN SCHEMA public
LIMIT TO (diagnostico_2)
FROM SERVER worker1
INTO public;

-- Para Worker 2
IMPORT FOREIGN SCHEMA public
LIMIT TO (medico_3)
FROM SERVER worker2
INTO public;

IMPORT FOREIGN SCHEMA public
LIMIT TO (medico_4)
FROM SERVER worker2
INTO public;

IMPORT FOREIGN SCHEMA public
LIMIT TO (diagnostico_3)
FROM SERVER worker2
INTO public;

IMPORT FOREIGN SCHEMA public
LIMIT TO (diagnostico_4)
FROM SERVER worker2
INTO public;


-- Consulta a): Select * From Diagnostico Order By Ciudad.

BEGIN;

-- Crear tabla temporal para consolidar particiones
--EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
CREATE TEMPORARY TABLE temp_diagnostico AS
SELECT * FROM diagnostico_1
UNION ALL
SELECT * FROM diagnostico_2
UNION ALL
SELECT * FROM diagnostico_3
UNION ALL
SELECT * FROM diagnostico_4;

-- Realizar la consulta ordenada
--EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM temp_diagnostico ORDER BY Ciudad;

-- Eliminar la tabla temporal
DROP TABLE temp_diagnostico;

COMMIT;

--Consulta b: Select distinct DNI_Paciente From Diagnostico.

BEGIN;

-- Crear tabla temporal para consolidar DNI_Paciente
--EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
CREATE TEMPORARY TABLE temp_dni_paciente AS
SELECT DNI_Paciente FROM diagnostico_1
UNION ALL
SELECT DNI_Paciente FROM diagnostico_2
UNION ALL
SELECT DNI_Paciente FROM diagnostico_3
UNION ALL
SELECT DNI_Paciente FROM diagnostico_4;

-- Realizar la consulta DISTINCT
--EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT DISTINCT DNI_Paciente FROM temp_dni_paciente;

-- Eliminar la tabla temporal
DROP TABLE temp_dni_paciente;

COMMIT;


--Consulta c: Select Edad, Count(*) From Diagnostico Group By Edad
BEGIN;

-- Crear tabla temporal para consolidar Edad
--EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
CREATE TEMPORARY TABLE temp_group_edad AS
SELECT Edad FROM diagnostico_1
UNION ALL
SELECT Edad FROM diagnostico_2
UNION ALL
SELECT Edad FROM diagnostico_3
UNION ALL
SELECT Edad FROM diagnostico_4;

-- Realizar la agrupación y contar registros
--EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT Edad, COUNT(*) AS conteo FROM temp_group_edad
GROUP BY Edad
ORDER BY Edad;

-- Eliminar la tabla temporal
DROP TABLE temp_group_edad;

COMMIT;

--Consulta d: Select Especialidad, Count(*) From Medico M Join Diagnostico D on M.DNI = D.DNI_Medico
BEGIN;

-- Consolidar las particiones de Medico y Diagnostico
--EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
CREATE TEMPORARY TABLE temp_medico AS
SELECT * FROM medico_1
UNION ALL
SELECT * FROM medico_2
UNION ALL
SELECT * FROM medico_3
UNION ALL
SELECT * FROM medico_4;

--EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
CREATE TEMPORARY TABLE temp_diagnostico AS
SELECT * FROM diagnostico_1
UNION ALL
SELECT * FROM diagnostico_2
UNION ALL
SELECT * FROM diagnostico_3
UNION ALL
SELECT * FROM diagnostico_4;

-- Realizar JOIN y agrupación
--EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT M.Especialidad, COUNT(*) AS conteo
FROM temp_medico M
JOIN temp_diagnostico D ON M.Dni = D.Dni_medico
GROUP BY M.Especialidad
ORDER BY conteo;

-- Eliminar tablas temporales
DROP TABLE temp_medico;
DROP TABLE temp_diagnostico;

COMMIT;