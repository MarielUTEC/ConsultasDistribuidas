--P1
-- Consulta a: Select * From Diagnostico Order By Ciudad.
BEGIN;

-- Creamos una tabla temporal para consolidar los resultados de las particiones
--EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
CREATE TEMPORARY TABLE temp_diagnostico AS
SELECT * FROM diagnostico_1
UNION ALL
SELECT * FROM diagnostico_2
UNION ALL
SELECT * FROM diagnostico_3
UNION ALL
SELECT * FROM diagnostico_4;

-- Realizamos la consulta ordenada por Ciudad sobre la tabla temporal.
--EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM temp_diagnostico ORDER BY Ciudad;

-- Eliminamos la tabla temporal
DROP TABLE temp_diagnostico;

COMMIT;

--Consulta b: Select distinct DNI_Paciente From Diagnostico.
BEGIN;

-- Consolidar resultados de las particiones en una tabla temporal
--EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
CREATE TEMPORARY TABLE temp_dni_paciente AS
SELECT DNI_Paciente FROM diagnostico_1
UNION ALL
SELECT DNI_Paciente FROM diagnostico_2
UNION ALL
SELECT DNI_Paciente FROM diagnostico_3
UNION ALL
SELECT DNI_Paciente FROM diagnostico_4;

-- Obtener los valores únicos
--EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT DISTINCT DNI_Paciente FROM temp_dni_paciente;

-- Eliminar la tabla temporal
DROP TABLE temp_dni_paciente;

COMMIT;


--Consulta c: Select Edad, Count(*) From Diagnostico Group By Edad
BEGIN;

-- Consolidar resultados de las particiones en una tabla temporal
--EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
CREATE TEMPORARY TABLE temp_group_edad AS
SELECT Edad FROM diagnostico_1
UNION ALL
SELECT Edad FROM diagnostico_2
UNION ALL
SELECT Edad FROM diagnostico_3
UNION ALL
SELECT Edad FROM diagnostico_4;

-- Realizar la agrupación y contar registros por edad
--EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT Edad, COUNT(*) AS conteo FROM temp_group_edad
GROUP BY Edad
ORDER BY Edad;--lo quisimos ordenar asi

-- Eliminar la tabla temporal
DROP TABLE temp_group_edad;

COMMIT;


--Consulta d: Select Especialidad, Count(*) From Medico M Join Diagnostico D on M.DNI = D.DNI_Medico
BEGIN;

-- Consolidar particiones de Medico
--EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
CREATE TEMPORARY TABLE temp_medico AS
SELECT * FROM medico_1
UNION ALL
SELECT * FROM medico_2
UNION ALL
SELECT * FROM medico_3
UNION ALL
SELECT * FROM medico_4;

-- Consolidar particiones de Diagnostico
--EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
CREATE TEMPORARY TABLE temp_diagnostico AS
SELECT * FROM diagnostico_1
UNION ALL
SELECT * FROM diagnostico_2
UNION ALL
SELECT * FROM diagnostico_3
UNION ALL
SELECT * FROM diagnostico_4;

-- Realizar el JOIN y la agrupación
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