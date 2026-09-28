
-- ============================================================
-- universidad.sql
-- ============================================================
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


-- ============================================================
-- 01_rediseño_calificaciones.sql
-- ============================================================
USE universidad;

DROP TABLE IF EXISTS calificaciones;

CREATE TABLE calificaciones (
    id_calificacion INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_matricula INT UNSIGNED NOT NULL UNIQUE,
    primer_parcial DECIMAL(4,2) NOT NULL,
    segundo_parcial DECIMAL(4,2) NOT NULL,
    parcial_final DECIMAL(4,2) NOT NULL,
    trabajo_practico DECIMAL(4,2) NULL,
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_matricula) REFERENCES alumno_se_matricula_asignatura(id),
    CONSTRAINT chk_primer_parcial CHECK (primer_parcial BETWEEN 0 AND 5),
    CONSTRAINT chk_segundo_parcial CHECK (segundo_parcial BETWEEN 0 AND 5),
    CONSTRAINT chk_parcial_final CHECK (parcial_final BETWEEN 0 AND 5),
    CONSTRAINT chk_trabajo_practico CHECK (trabajo_practico IS NULL OR trabajo_practico BETWEEN 0 AND 5)
);

CREATE INDEX idx_calificaciones_matricula ON calificaciones(id_matricula);
CREATE INDEX idx_calificaciones_fecha ON calificaciones(fecha_registro);


-- ============================================================
-- 02_datos_prueba.sql
-- ============================================================
USE universidad;

INSERT INTO calificaciones (id_matricula, primer_parcial, segundo_parcial, parcial_final, trabajo_practico) VALUES
(1,4.20,3.80,4.50,NULL),
(2,3.50,4.00,3.80,4.50),
(3,2.80,3.60,3.20,NULL),
(4,4.80,4.50,4.70,4.80),
(5,3.90,3.20,3.50,NULL),
(6,4.00,3.80,4.10,4.30),
(7,2.50,2.90,3.00,NULL),
(8,4.60,4.20,4.80,4.70),
(9,3.20,3.70,3.90,NULL),
(10,4.10,4.40,4.00,4.50),
(11,3.00,3.50,3.20,NULL),
(12,4.70,4.60,4.80,4.90),
(13,2.90,3.10,3.40,NULL),
(14,3.80,4.00,4.20,4.00),
(15,4.50,4.20,4.40,NULL),
(16,3.60,3.80,3.90,4.10),
(17,4.90,4.80,4.70,NULL);


-- ============================================================
-- 03_consultas_validacion.sql
-- ============================================================
USE universidad;

-- 01. Matrículas con sus calificaciones.
SELECT m.id, p.nombre, p.apellido1, a.nombre AS asignatura,
       c.primer_parcial, c.segundo_parcial, c.parcial_final, c.trabajo_practico
FROM alumno_se_matricula_asignatura m
JOIN alumno al ON al.id_alumno=m.id_alumno
JOIN persona p ON p.id=al.id_alumno
JOIN asignatura a ON a.id=m.id_asignatura
LEFT JOIN calificaciones c ON c.id_matricula=m.id;

-- 02. Alumnos sin calificación.
SELECT m.id, p.nombre, p.apellido1, a.nombre
FROM alumno_se_matricula_asignatura m
JOIN alumno al ON al.id_alumno=m.id_alumno
JOIN persona p ON p.id=al.id_alumno
JOIN asignatura a ON a.id=m.id_asignatura
LEFT JOIN calificaciones c ON c.id_matricula=m.id
WHERE c.id_calificacion IS NULL;

-- 03. Calificaciones sin matrícula relacionada.
SELECT c.*
FROM calificaciones c
LEFT JOIN alumno_se_matricula_asignatura m ON m.id=c.id_matricula
WHERE m.id IS NULL;

-- 04. Matrículas duplicadas.
SELECT id_alumno,id_asignatura,id_curso_escolar,COUNT(*) AS cantidad
FROM alumno_se_matricula_asignatura
GROUP BY id_alumno,id_asignatura,id_curso_escolar
HAVING COUNT(*)>1;

-- 05. Calificaciones duplicadas por matrícula.
SELECT id_matricula,COUNT(*) AS cantidad
FROM calificaciones
GROUP BY id_matricula
HAVING COUNT(*)>1;

-- 06. Trabajos prácticos NULL.
SELECT c.id_matricula,p.nombre,p.apellido1,a.nombre AS asignatura
FROM calificaciones c
JOIN alumno_se_matricula_asignatura m ON m.id=c.id_matricula
JOIN persona p ON p.id=m.id_alumno
JOIN asignatura a ON a.id=m.id_asignatura
WHERE c.trabajo_practico IS NULL;

-- 07. Trabajos prácticos registrados.
SELECT c.id_matricula,p.nombre,p.apellido1,c.trabajo_practico
FROM calificaciones c
JOIN alumno_se_matricula_asignatura m ON m.id=c.id_matricula
JOIN persona p ON p.id=m.id_alumno
WHERE c.trabajo_practico IS NOT NULL;

-- 08. Notas fuera de rango (debe devolver 0 filas).
SELECT * FROM calificaciones
WHERE primer_parcial NOT BETWEEN 0 AND 5
   OR segundo_parcial NOT BETWEEN 0 AND 5
   OR parcial_final NOT BETWEEN 0 AND 5
   OR (trabajo_practico IS NOT NULL AND trabajo_practico NOT BETWEEN 0 AND 5);

-- 09. Matrículas con alumno inexistente.
SELECT m.* FROM alumno_se_matricula_asignatura m
LEFT JOIN alumno al ON al.id_alumno=m.id_alumno
WHERE al.id_alumno IS NULL;

-- 10. Matrículas con asignatura inexistente.
SELECT m.* FROM alumno_se_matricula_asignatura m
LEFT JOIN asignatura a ON a.id=m.id_asignatura
WHERE a.id IS NULL;

-- 11. Matrículas con curso inexistente.
SELECT m.* FROM alumno_se_matricula_asignatura m
LEFT JOIN curso_escolar ce ON ce.id=m.id_curso_escolar
WHERE ce.id IS NULL;

-- 12. Alumnos sin matrículas.
SELECT al.id_alumno,p.nombre,p.apellido1
FROM alumno al
JOIN persona p ON p.id=al.id_alumno
LEFT JOIN alumno_se_matricula_asignatura m ON m.id_alumno=al.id_alumno
WHERE m.id IS NULL;

-- 13. Asignaturas sin matrículas.
SELECT a.id,a.nombre
FROM asignatura a
LEFT JOIN alumno_se_matricula_asignatura m ON m.id_asignatura=a.id
WHERE m.id IS NULL;

-- 14. Profesores sin asignaturas.
SELECT pr.id_profesor,p.nombre,p.apellido1
FROM profesor pr
JOIN persona p ON p.id=pr.id_profesor
LEFT JOIN profesor_asignatura pa ON pa.id_profesor=pr.id_profesor
WHERE pa.id_asignatura IS NULL;

-- 15. Matrículas con calificación completa.
SELECT m.id
FROM alumno_se_matricula_asignatura m
JOIN calificaciones c ON c.id_matricula=m.id
WHERE c.primer_parcial IS NOT NULL
  AND c.segundo_parcial IS NOT NULL
  AND c.parcial_final IS NOT NULL;

-- 16. Calificaciones sin trabajo práctico y con datos regulares completos.
SELECT c.*
FROM calificaciones c
WHERE c.trabajo_practico IS NULL
  AND c.primer_parcial IS NOT NULL
  AND c.segundo_parcial IS NOT NULL
  AND c.parcial_final IS NOT NULL;

-- 17. Calificaciones con trabajo práctico.
SELECT c.*
FROM calificaciones c
WHERE c.trabajo_practico IS NOT NULL;

-- 18. Validación de FK de calificaciones.
SELECT c.id_calificacion
FROM calificaciones c
WHERE NOT EXISTS (
    SELECT 1 FROM alumno_se_matricula_asignatura m
    WHERE m.id=c.id_matricula
);

-- 19. Alumnos con al menos una nota reprobatoria.
SELECT DISTINCT p.id,p.nombre,p.apellido1
FROM persona p
JOIN alumno al ON al.id_alumno=p.id
JOIN alumno_se_matricula_asignatura m ON m.id_alumno=al.id_alumno
JOIN calificaciones c ON c.id_matricula=m.id
WHERE c.primer_parcial < 3 OR c.segundo_parcial < 3 OR c.parcial_final < 3;

-- 20. Consistencia entre tipo de persona y tablas de alumno/profesor.
SELECT p.id,p.nombre,p.tipo
FROM persona p
LEFT JOIN alumno al ON al.id_alumno=p.id
LEFT JOIN profesor pr ON pr.id_profesor=p.id
WHERE (p.tipo='alumno' AND al.id_alumno IS NULL)
   OR (p.tipo='profesor' AND pr.id_profesor IS NULL);


-- ============================================================
-- 04_consultas_analisis.sql
-- ============================================================
USE universidad;

-- 01. Promedio de primer parcial.
SELECT AVG(primer_parcial) AS promedio_primer_parcial FROM calificaciones;

-- 02. Promedio de segundo parcial.
SELECT AVG(segundo_parcial) AS promedio_segundo_parcial FROM calificaciones;

-- 03. Promedio de parcial final.
SELECT AVG(parcial_final) AS promedio_parcial_final FROM calificaciones;

-- 04. Promedio de trabajo práctico.
SELECT AVG(trabajo_practico) AS promedio_trabajo_practico
FROM calificaciones WHERE trabajo_practico IS NOT NULL;

-- 05. Nota final automática con CASE.
SELECT m.id,p.nombre,p.apellido1,a.nombre AS asignatura,
ROUND(CASE WHEN c.trabajo_practico IS NULL
 THEN c.primer_parcial*0.20+c.segundo_parcial*0.35+c.parcial_final*0.45
 ELSE c.primer_parcial*0.20+c.segundo_parcial*0.35+c.parcial_final*0.35+c.trabajo_practico*0.10
END,2) AS nota_final
FROM calificaciones c
JOIN alumno_se_matricula_asignatura m ON m.id=c.id_matricula
JOIN persona p ON p.id=m.id_alumno
JOIN asignatura a ON a.id=m.id_asignatura;

-- 06. Estado académico según nota final.
SELECT m.id,p.nombre,p.apellido1,a.nombre,
ROUND(CASE WHEN c.trabajo_practico IS NULL
 THEN c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.45
 ELSE c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.35+c.trabajo_practico*.10 END,2) AS nota_final,
CASE WHEN (CASE WHEN c.trabajo_practico IS NULL
 THEN c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.45
 ELSE c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.35+c.trabajo_practico*.10 END) >= 3
THEN 'APROBADO' ELSE 'REPROBADO' END AS estado
FROM calificaciones c
JOIN alumno_se_matricula_asignatura m ON m.id=c.id_matricula
JOIN persona p ON p.id=m.id_alumno
JOIN asignatura a ON a.id=m.id_asignatura;

-- 07. Promedio por asignatura.
SELECT a.nombre,COUNT(c.id_calificacion) AS evaluados,
ROUND(AVG(CASE WHEN c.trabajo_practico IS NULL
 THEN c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.45
 ELSE c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.35+c.trabajo_practico*.10 END),2) AS promedio
FROM asignatura a
JOIN alumno_se_matricula_asignatura m ON m.id_asignatura=a.id
LEFT JOIN calificaciones c ON c.id_matricula=m.id
GROUP BY a.id,a.nombre
ORDER BY promedio DESC;

-- 08. Cantidad de aprobados por asignatura.
SELECT a.nombre,COUNT(*) AS aprobados
FROM asignatura a
JOIN alumno_se_matricula_asignatura m ON m.id_asignatura=a.id
JOIN calificaciones c ON c.id_matricula=m.id
WHERE (CASE WHEN c.trabajo_practico IS NULL
 THEN c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.45
 ELSE c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.35+c.trabajo_practico*.10 END) >= 3
GROUP BY a.id,a.nombre;

-- 09. Cantidad de reprobados por asignatura.
SELECT a.nombre,COUNT(*) AS reprobados
FROM asignatura a
JOIN alumno_se_matricula_asignatura m ON m.id_asignatura=a.id
JOIN calificaciones c ON c.id_matricula=m.id
WHERE (CASE WHEN c.trabajo_practico IS NULL
 THEN c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.45
 ELSE c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.35+c.trabajo_practico*.10 END) < 3
GROUP BY a.id,a.nombre;

-- 10. Máxima nota final por asignatura.
SELECT a.nombre,
MAX(CASE WHEN c.trabajo_practico IS NULL
 THEN c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.45
 ELSE c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.35+c.trabajo_practico*.10 END) AS maxima
FROM asignatura a JOIN alumno_se_matricula_asignatura m ON m.id_asignatura=a.id
JOIN calificaciones c ON c.id_matricula=m.id
GROUP BY a.id,a.nombre;

-- 11. Mínima nota final por asignatura.
SELECT a.nombre,
MIN(CASE WHEN c.trabajo_practico IS NULL
 THEN c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.45
 ELSE c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.35+c.trabajo_practico*.10 END) AS minima
FROM asignatura a JOIN alumno_se_matricula_asignatura m ON m.id_asignatura=a.id
JOIN calificaciones c ON c.id_matricula=m.id
GROUP BY a.id,a.nombre;

-- 12. Cantidad de estudiantes evaluados por asignatura.
SELECT a.nombre,COUNT(DISTINCT m.id_alumno) AS estudiantes
FROM asignatura a JOIN alumno_se_matricula_asignatura m ON m.id_asignatura=a.id
JOIN calificaciones c ON c.id_matricula=m.id
GROUP BY a.id,a.nombre;

-- 13. Promedio final por alumno.
SELECT p.id,p.nombre,p.apellido1,
ROUND(AVG(CASE WHEN c.trabajo_practico IS NULL
 THEN c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.45
 ELSE c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.35+c.trabajo_practico*.10 END),2) AS promedio
FROM persona p JOIN alumno al ON al.id_alumno=p.id
JOIN alumno_se_matricula_asignatura m ON m.id_alumno=al.id_alumno
JOIN calificaciones c ON c.id_matricula=m.id
GROUP BY p.id,p.nombre,p.apellido1
ORDER BY promedio DESC;

-- 14. Total de créditos matriculados por alumno.
SELECT p.id,p.nombre,p.apellido1,SUM(a.creditos) AS total_creditos
FROM persona p JOIN alumno al ON al.id_alumno=p.id
JOIN alumno_se_matricula_asignatura m ON m.id_alumno=al.id_alumno
JOIN asignatura a ON a.id=m.id_asignatura
GROUP BY p.id,p.nombre,p.apellido1;

-- 15. Asignaturas con promedio mayor o igual a 3 usando HAVING.
SELECT a.nombre,ROUND(AVG(CASE WHEN c.trabajo_practico IS NULL
 THEN c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.45
 ELSE c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.35+c.trabajo_practico*.10 END),2) promedio
FROM asignatura a JOIN alumno_se_matricula_asignatura m ON m.id_asignatura=a.id
JOIN calificaciones c ON c.id_matricula=m.id
GROUP BY a.id,a.nombre
HAVING promedio >= 3
ORDER BY promedio DESC;

-- 16. Comparación de estudiantes con y sin trabajo práctico.
SELECT CASE WHEN trabajo_practico IS NULL THEN 'Sin trabajo práctico' ELSE 'Con trabajo práctico' END escenario,
COUNT(*) cantidad,
ROUND(AVG(CASE WHEN trabajo_practico IS NULL
 THEN primer_parcial*.20+segundo_parcial*.35+parcial_final*.45
 ELSE primer_parcial*.20+segundo_parcial*.35+parcial_final*.35+trabajo_practico*.10 END),2) promedio
FROM calificaciones
GROUP BY escenario;

-- 17. Promedios por tipo de asignatura.
SELECT a.tipo,COUNT(*) evaluaciones,
ROUND(AVG(CASE WHEN c.trabajo_practico IS NULL
 THEN c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.45
 ELSE c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.35+c.trabajo_practico*.10 END),2) promedio
FROM asignatura a JOIN alumno_se_matricula_asignatura m ON m.id_asignatura=a.id
JOIN calificaciones c ON c.id_matricula=m.id
GROUP BY a.tipo;

-- 18. Promedios por curso.
SELECT a.curso,COUNT(*) evaluaciones,
ROUND(AVG(CASE WHEN c.trabajo_practico IS NULL
 THEN c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.45
 ELSE c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.35+c.trabajo_practico*.10 END),2) promedio
FROM asignatura a JOIN alumno_se_matricula_asignatura m ON m.id_asignatura=a.id
JOIN calificaciones c ON c.id_matricula=m.id
GROUP BY a.curso ORDER BY a.curso;

-- 19. Cantidad de alumnos aprobados y reprobados por curso.
SELECT a.curso,
SUM(CASE WHEN (CASE WHEN c.trabajo_practico IS NULL
 THEN c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.45
 ELSE c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.35+c.trabajo_practico*.10 END) >= 3 THEN 1 ELSE 0 END) aprobados,
SUM(CASE WHEN (CASE WHEN c.trabajo_practico IS NULL
 THEN c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.45
 ELSE c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.35+c.trabajo_practico*.10 END) < 3 THEN 1 ELSE 0 END) reprobados
FROM asignatura a JOIN alumno_se_matricula_asignatura m ON m.id_asignatura=a.id
JOIN calificaciones c ON c.id_matricula=m.id
GROUP BY a.curso;

-- 20. Consolidado general de calificaciones.
SELECT COUNT(*) total_evaluaciones,
ROUND(AVG(CASE WHEN c.trabajo_practico IS NULL
 THEN c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.45
 ELSE c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.35+c.trabajo_practico*.10 END),2) promedio_general,
MAX(CASE WHEN c.trabajo_practico IS NULL
 THEN c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.45
 ELSE c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.35+c.trabajo_practico*.10 END) nota_maxima,
MIN(CASE WHEN c.trabajo_practico IS NULL
 THEN c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.45
 ELSE c.primer_parcial*.20+c.segundo_parcial*.35+c.parcial_final*.35+c.trabajo_practico*.10 END) nota_minima
FROM calificaciones c;

