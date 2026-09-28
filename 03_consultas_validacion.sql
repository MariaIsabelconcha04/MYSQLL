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
