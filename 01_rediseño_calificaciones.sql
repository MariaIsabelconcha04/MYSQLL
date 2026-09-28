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
