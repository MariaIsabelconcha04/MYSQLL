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
