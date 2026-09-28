# Rediseño de Base de Datos Universitaria con Sistema de Calificaciones

Actividad práctica basada en la guía de rediseño de la base de datos universitaria.

## Contenido

- `universidad.sql`: crea la base de datos y las 9 tablas del modelo universitario, con datos de ejemplo.
- `01_rediseño_calificaciones.sql`: crea la nueva tabla independiente `calificaciones`, relacionada 1 a 1 con cada matrícula.
- `02_datos_prueba.sql`: inserta casos con trabajo práctico y casos donde `trabajo_practico = NULL`.
- `03_consultas_validacion.sql`: 20 consultas de validación multitabla.
- `04_consultas_analisis.sql`: 20 consultas de análisis con COUNT, SUM, AVG, MAX, MIN, GROUP BY, HAVING, ORDER BY, WHERE y CASE.
- `Actividad_Completa_MySQLL.sql`: archivo guía para ejecutar toda la actividad en orden.

## Modelo

La base queda con 10 tablas: las 9 del modelo universitario original y la nueva tabla `calificaciones`.

La tabla `calificaciones` contiene:

- `primer_parcial`: 20 %
- `segundo_parcial`: 35 %
- `parcial_final`: 45 % cuando no existe trabajo práctico
- `parcial_final`: 35 % cuando existe trabajo práctico
- `trabajo_practico`: 10 %, opcional y permite NULL

La nota final se calcula automáticamente en las consultas mediante `CASE WHEN`.

## Ejecución

En MySQL Workbench:

1. Abrir `universidad.sql`.
2. Ejecutarlo completo.
3. Ejecutar `01_rediseño_calificaciones.sql`.
4. Ejecutar `02_datos_prueba.sql`.
5. Ejecutar `03_consultas_validacion.sql`.
6. Ejecutar `04_consultas_analisis.sql`.

También puede ejecutarse el archivo `Actividad_Completa_MySQLL.sql` desde un cliente MySQL que soporte `SOURCE`.

La guía solicita un script DDL, un script de pruebas y consultas de validación; además exige mínimo 20 consultas de validación y 20 consultas de análisis/resumen.
