CREATE SCHEMA IF NOT EXISTS labsito;
SET search_path TO labsito;

--correr lo siguiente solo una vez:
SET enable_partition_pruning = on;
--P0
CREATE TABLE IF NOT EXISTS Medico (
    Dni BIGINT NOT NULL,
    Nombre VARCHAR(60) NOT NULL,
    Apellidos VARCHAR(60) NOT NULL,
    Especialidad VARCHAR(60) NOT NULL,
    NumColegiado VARCHAR(15) NOT NULL,
    CentroSalud VARCHAR(60) NOT NULL,
    Ciudad VARCHAR(60) NOT NULL,
	PRIMARY KEY (Dni, Ciudad) --clave primaria incluye Ciudad
) PARTITION BY HASH (Ciudad);

CREATE TABLE IF NOT EXISTS Diagnostico (
    id SERIAL NOT NULL,
    Dni_paciente BIGINT NOT NULL,
    Dni_medico BIGINT NOT NULL,
    Ciudad VARCHAR(40) NOT NULL,
    Diagnostico TEXT NOT NULL,
    Peso_kg NUMERIC(5, 2) NOT NULL,
    Edad INT NOT NULL,
    Sexo CHAR(1) CHECK (Sexo IN ('M', 'F')),
	PRIMARY KEY (id, Ciudad), -- Incluye Ciudad en la clave primaria
    FOREIGN KEY (Dni_medico, Ciudad) REFERENCES Medico(Dni, Ciudad) -- Clave externa incluye Ciudad
) PARTITION BY HASH (Ciudad);

--Medico
CREATE TABLE medico_1 PARTITION OF Medico FOR VALUES WITH (MODULUS 4, REMAINDER 0);
CREATE TABLE medico_2 PARTITION OF Medico FOR VALUES WITH (MODULUS 4, REMAINDER 1);
CREATE TABLE medico_3 PARTITION OF Medico FOR VALUES WITH (MODULUS 4, REMAINDER 2);
CREATE TABLE medico_4 PARTITION OF Medico FOR VALUES WITH (MODULUS 4, REMAINDER 3);

--Diagnostico
-- Particiones derivadas de Medico
CREATE TABLE diagnostico_1 PARTITION OF Diagnostico
FOR VALUES WITH (MODULUS 4, REMAINDER 0);

CREATE TABLE diagnostico_2 PARTITION OF Diagnostico
FOR VALUES WITH (MODULUS 4, REMAINDER 1);

CREATE TABLE diagnostico_3 PARTITION OF Diagnostico
FOR VALUES WITH (MODULUS 4, REMAINDER 2);

CREATE TABLE diagnostico_4 PARTITION OF Diagnostico
FOR VALUES WITH (MODULUS 4, REMAINDER 3);


COPY Medico(Dni, Nombre, Apellidos, Especialidad, NumColegiado, CentroSalud, Ciudad)
FROM 'C:/Users/Public/bd2/medico.csv'
DELIMITER ','
CSV HEADER;

COPY Diagnostico(id, Dni_paciente, Dni_medico, Ciudad, Diagnostico, Peso_kg, Edad, Sexo)
FROM 'C:/Users/Public/bd2/diagnostico.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM Medico;
SELECT ciudad, count(*) from medico group by ciudad
--SELECT hashtext('Huanuco');--226857871--0
--SELECT hashtext('Lima');--31795019--5
--SELECT hashtext('Loreto');--4
--SELECT hashtext('Tumbes');--3
--SELECT hashtext('Piura');--2
--SELECT hashtext('Ayacucho');--7
--SELECT hashtext('Tacna');--6
--SELECT hashtext('Iquitos');--1


--Esto fue lo más equitativo posible que pudimos obtener 
--despues de muchos intentos para que ningun fragmento se quedara vacio:
SELECT * FROM medico_1;--250
SELECT * FROM medico_2;--250
SELECT * FROM medico_3;--375
SELECT * FROM medico_4;--125


SELECT * FROM Diagnostico;

SELECT * FROM diagnostico_1;--267
SELECT * FROM diagnostico_2;--247
SELECT * FROM diagnostico_3;--356
SELECT * FROM diagnostico_4;--130
