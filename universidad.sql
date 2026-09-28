DROP DATABASE IF EXISTS universidad;
CREATE DATABASE universidad CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE universidad;

CREATE TABLE departamento (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE persona (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nif VARCHAR(9) UNIQUE,
    nombre VARCHAR(25) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50),
    ciudad VARCHAR(25),
    direccion VARCHAR(50),
    telefono VARCHAR(9),
    fecha_nacimiento DATE,
    sexo ENUM('H','M') NOT NULL,
    tipo ENUM('profesor','alumno') NOT NULL
);

CREATE TABLE profesor (
    id_profesor INT UNSIGNED PRIMARY KEY,
    id_departamento INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_profesor) REFERENCES persona(id),
    FOREIGN KEY (id_departamento) REFERENCES departamento(id)
);

CREATE TABLE grado (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE alumno (
    id_alumno INT UNSIGNED PRIMARY KEY,
    FOREIGN KEY (id_alumno) REFERENCES persona(id)
);

CREATE TABLE curso_escolar (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    anyo_inicio YEAR NOT NULL,
    anyo_fin YEAR NOT NULL,
    CONSTRAINT chk_curso_anios CHECK (anyo_fin = anyo_inicio + 1),
    UNIQUE (anyo_inicio, anyo_fin)
);

CREATE TABLE asignatura (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    creditos DECIMAL(4,2) NOT NULL,
    tipo ENUM('básica','obligatoria','optativa') NOT NULL,
    curso TINYINT UNSIGNED NOT NULL,
    cuatrimestre TINYINT UNSIGNED NOT NULL,
    id_profesor INT UNSIGNED NULL,
    id_grado INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor),
    FOREIGN KEY (id_grado) REFERENCES grado(id),
    CONSTRAINT chk_creditos CHECK (creditos > 0),
    CONSTRAINT chk_curso CHECK (curso BETWEEN 1 AND 4),
    CONSTRAINT chk_cuatrimestre CHECK (cuatrimestre IN (1,2))
);

CREATE TABLE profesor_asignatura (
    id_profesor INT UNSIGNED NOT NULL,
    id_asignatura INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_profesor, id_asignatura),
    FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor),
    FOREIGN KEY (id_asignatura) REFERENCES asignatura(id)
);

CREATE TABLE alumno_se_matricula_asignatura (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_alumno INT UNSIGNED NOT NULL,
    id_asignatura INT UNSIGNED NOT NULL,
    id_curso_escolar INT UNSIGNED NOT NULL,
    UNIQUE (id_alumno, id_asignatura, id_curso_escolar),
    FOREIGN KEY (id_alumno) REFERENCES alumno(id_alumno),
    FOREIGN KEY (id_asignatura) REFERENCES asignatura(id),
    FOREIGN KEY (id_curso_escolar) REFERENCES curso_escolar(id)
);

INSERT INTO departamento (nombre) VALUES
('Informática'),('Matemáticas'),('Ingeniería'),('Administración');

INSERT INTO persona (nif,nombre,apellido1,apellido2,ciudad,direccion,telefono,fecha_nacimiento,sexo,tipo) VALUES
('100000001','Ana','García','López','Bogotá','Calle 10 #12-20','3001000001','1985-02-10','M','profesor'),
('100000002','Carlos','Martínez','Ruiz','Cali','Carrera 5 #20-15','3001000002','1980-06-18','H','profesor'),
('100000003','Laura','Pérez','Díaz','Popayán','Carrera 8 #4-10','3001000003','1988-09-21','M','profesor'),
('100000004','Diego','Torres','Mora','Pasto','Calle 7 #3-25','3001000004','1983-11-03','H','profesor'),
('100000005','María','Gómez','Castro','Popayán','Carrera 9 #8-12','3102000001','2003-01-15','M','alumno'),
('100000006','Juan','Rodríguez','Vera','Cali','Calle 4 #6-30','3102000002','2002-04-22','H','alumno'),
('100000007','Sofía','Hernández','León','Bogotá','Carrera 11 #14-08','3102000003','2004-07-09','M','alumno'),
('100000008','Andrés','Ramírez','Pardo','Pasto','Calle 2 #9-16','3102000004','2001-12-30','H','alumno'),
('100000009','Valentina','Morales','Ríos','Popayán','Carrera 3 #7-18','3102000005','2003-05-12','M','alumno'),
('100000010','Mateo','Vargas','Soto','Cali','Calle 13 #5-19','3102000006','2002-10-27','H','alumno');

INSERT INTO profesor VALUES (1,1),(2,2),(3,3),(4,4);
INSERT INTO alumno VALUES (5),(6),(7),(8),(9),(10);

INSERT INTO grado (nombre) VALUES
('Análisis y Desarrollo de Software'),
('Ingeniería de Sistemas');

INSERT INTO curso_escolar (anyo_inicio,anyo_fin) VALUES
(2025,2026),(2026,2027);

INSERT INTO asignatura (nombre,creditos,tipo,curso,cuatrimestre,id_profesor,id_grado) VALUES
('Bases de Datos',6.00,'obligatoria',1,1,1,1),
('Programación',6.00,'obligatoria',1,1,1,1),
('Matemáticas',6.00,'básica',1,1,2,1),
('Ingeniería de Software',6.00,'obligatoria',2,1,3,1),
('Sistemas Operativos',6.00,'obligatoria',2,2,4,1),
('Redes',4.50,'optativa',2,2,4,1),
('Algoritmos',6.00,'obligatoria',1,2,2,2),
('Arquitectura de Computadores',4.50,'optativa',2,1,3,2);

INSERT INTO profesor_asignatura VALUES
(1,1),(1,2),(2,3),(3,4),(4,5),(4,6),(2,7),(3,8);

INSERT INTO alumno_se_matricula_asignatura (id_alumno,id_asignatura,id_curso_escolar) VALUES
(5,1,1),(5,2,1),(5,3,1),(6,1,1),(6,3,1),(6,4,1),
(7,1,1),(7,2,1),(7,4,1),(8,1,1),(8,5,1),(9,2,1),
(9,3,1),(9,6,1),(10,1,1),(10,4,1),(10,7,1);
