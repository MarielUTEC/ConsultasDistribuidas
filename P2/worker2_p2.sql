CREATE SCHEMA IF NOT EXISTS public;
SET search_path TO public;
-- En worker1, crear las particiones de Medico
CREATE TABLE IF NOT EXISTS medico_3 (
    Dni BIGINT NOT NULL,
    Nombre VARCHAR(60) NOT NULL,
    Apellidos VARCHAR(60) NOT NULL,
    Especialidad VARCHAR(60) NOT NULL,
    NumColegiado VARCHAR(15) NOT NULL,
    CentroSalud VARCHAR(60) NOT NULL,
    Ciudad VARCHAR(60) NOT NULL,
    PRIMARY KEY (Dni, Ciudad)
);

CREATE TABLE IF NOT EXISTS medico_4 (
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
CREATE TABLE IF NOT EXISTS diagnostico_3 (
    id SERIAL NOT NULL,
    Dni_paciente BIGINT NOT NULL,
    Dni_medico BIGINT NOT NULL,
    Ciudad VARCHAR(40) NOT NULL,
    Diagnostico TEXT NOT NULL,
    Peso_kg NUMERIC(5, 2) NOT NULL,
    Edad INT NOT NULL,
    Sexo CHAR(1) CHECK (Sexo IN ('M', 'F')),
    PRIMARY KEY (id, Ciudad),
    FOREIGN KEY (Dni_medico, Ciudad) REFERENCES medico_3(Dni, Ciudad)
);

CREATE TABLE IF NOT EXISTS diagnostico_4 (
    id SERIAL NOT NULL,
    Dni_paciente BIGINT NOT NULL,
    Dni_medico BIGINT NOT NULL,
    Ciudad VARCHAR(40) NOT NULL,
    Diagnostico TEXT NOT NULL,
    Peso_kg NUMERIC(5, 2) NOT NULL,
    Edad INT NOT NULL,
    Sexo CHAR(1) CHECK (Sexo IN ('M', 'F')),
    PRIMARY KEY (id, Ciudad),
    FOREIGN KEY (Dni_medico, Ciudad) REFERENCES medico_4(Dni, Ciudad)
);


-- Insertar datos en la tabla medico_3
INSERT INTO medico_3 (Dni, Nombre, Apellidos, Especialidad, NumColegiado, CentroSalud, Ciudad)
VALUES
(10000001, 'Juan', 'Pérez', 'Pediatría', '12345', 'Centro Médico A', 'Tacna'),
(10000002, 'María', 'Lopez', 'Cardiología', '54321', 'Centro Médico B', 'Piura');

-- Insertar datos en la tabla medico_4
INSERT INTO medico_4 (Dni, Nombre, Apellidos, Especialidad, NumColegiado, CentroSalud, Ciudad)
VALUES
(10000003, 'Carlos', 'Garcia', 'Dermatología', '67890', 'Clínica C', 'Lima'),
(10000004, 'Ana', 'Martinez', 'Gastroenterología', '09876', 'Clínica D', 'Arequipa');


-- Insertar datos en la tabla diagnostico_3
INSERT INTO diagnostico_3 (Dni_paciente, Dni_medico, Ciudad, Diagnostico, Peso_kg, Edad, Sexo)
VALUES
(20000001, 10000001, 'Tacna', 'Faringitis', 45.5, 12, 'M'),
(20000002, 10000002, 'Piura', 'Hipertensión', 72.3, 50, 'F');

-- Insertar datos en la tabla diagnostico_4
INSERT INTO diagnostico_4 (Dni_paciente, Dni_medico, Ciudad, Diagnostico, Peso_kg, Edad, Sexo)
VALUES
(20000003, 10000003, 'Lima', 'Dermatitis', 68.4, 35, 'M'),
(20000004, 10000004, 'Arequipa', 'Gastritis', 58.9, 28, 'F');

SELECT * FROM medico_3;
SELECT * FROM medico_4;
SELECT * FROM diagnostico_3;
SELECT * FROM diagnostico_4;


