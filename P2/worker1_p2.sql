CREATE SCHEMA IF NOT EXISTS public;
SET search_path TO public;
-- En worker1, crear las particiones de Medico
CREATE TABLE IF NOT EXISTS medico_1 (
    Dni BIGINT NOT NULL,
    Nombre VARCHAR(60) NOT NULL,
    Apellidos VARCHAR(60) NOT NULL,
    Especialidad VARCHAR(60) NOT NULL,
    NumColegiado VARCHAR(15) NOT NULL,
    CentroSalud VARCHAR(60) NOT NULL,
    Ciudad VARCHAR(60) NOT NULL,
    PRIMARY KEY (Dni, Ciudad)
);

CREATE TABLE IF NOT EXISTS medico_2 (
    Dni BIGINT NOT NULL,
    Nombre VARCHAR(60) NOT NULL,
    Apellidos VARCHAR(60) NOT NULL,
    Especialidad VARCHAR(60) NOT NULL,
    NumColegiado VARCHAR(15) NOT NULL,
    CentroSalud VARCHAR(60) NOT NULL,
    Ciudad VARCHAR(60) NOT NULL,
    PRIMARY KEY (Dni, Ciudad)
);
-- En worker1, crear las particiones de Diagnostico
CREATE TABLE IF NOT EXISTS diagnostico_1 (
    id SERIAL NOT NULL,
    Dni_paciente BIGINT NOT NULL,
    Dni_medico BIGINT NOT NULL,
    Ciudad VARCHAR(40) NOT NULL,
    Diagnostico TEXT NOT NULL,
    Peso_kg NUMERIC(5, 2) NOT NULL,
    Edad INT NOT NULL,
    Sexo CHAR(1) CHECK (Sexo IN ('M', 'F')),
    PRIMARY KEY (id, Ciudad),
    FOREIGN KEY (Dni_medico, Ciudad) REFERENCES medico_1(Dni, Ciudad)
);

CREATE TABLE IF NOT EXISTS diagnostico_2 (
    id SERIAL NOT NULL,
    Dni_paciente BIGINT NOT NULL,
    Dni_medico BIGINT NOT NULL,
    Ciudad VARCHAR(40) NOT NULL,
    Diagnostico TEXT NOT NULL,
    Peso_kg NUMERIC(5, 2) NOT NULL,
    Edad INT NOT NULL,
    Sexo CHAR(1) CHECK (Sexo IN ('M', 'F')),
    PRIMARY KEY (id, Ciudad),
    FOREIGN KEY (Dni_medico, Ciudad) REFERENCES medico_2(Dni, Ciudad)
);

---------------------------------------------------------------
-- Insertar datos en la tabla medico_1
INSERT INTO medico_1 (Dni, Nombre, Apellidos, Especialidad, NumColegiado, CentroSalud, Ciudad)
VALUES
(10100001, 'Luis', 'Ramirez', 'Neurología', '34567', 'Clínica Alpha', 'Trujillo'),
(10100002, 'Elena', 'Fernandez', 'Oncología', '23456', 'Clínica Beta', 'Huancayo');

-- Insertar datos en la tabla medico_2
INSERT INTO medico_2 (Dni, Nombre, Apellidos, Especialidad, NumColegiado, CentroSalud, Ciudad)
VALUES
(10200001, 'Mario', 'Gonzalez', 'Traumatología', '45678', 'Hospital Central', 'Cusco'),
(10200002, 'Sofia', 'Rodriguez', 'Cardiología', '67890', 'Centro Médico Vida', 'Chiclayo');


-- Insertar datos en la tabla diagnostico_1
INSERT INTO diagnostico_1 (Dni_paciente, Dni_medico, Ciudad, Diagnostico, Peso_kg, Edad, Sexo)
VALUES
(20100001, 10100001, 'Trujillo', 'Migraña', 70.5, 40, 'F'),
(20100002, 10100002, 'Huancayo', 'Cáncer de piel', 55.2, 60, 'M');

-- Insertar datos en la tabla diagnostico_2
INSERT INTO diagnostico_2 (Dni_paciente, Dni_medico, Ciudad, Diagnostico, Peso_kg, Edad, Sexo)
VALUES
(20200001, 10200001, 'Cusco', 'Fractura de pierna', 80.1, 35, 'M'),
(20200002, 10200002, 'Chiclayo', 'Hipertensión', 65.3, 55, 'F');


SELECT * FROM medico_1;
SELECT * FROM medico_2;
SELECT * FROM diagnostico_1;
SELECT * FROM diagnostico_2;


