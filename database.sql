-- Crear base de datos
CREATE DATABASE IF NOT EXISTS sistema_inscripciones;
USE sistema_inscripciones;

-- Tabla ALUMNO
CREATE TABLE IF NOT EXISTS alumno (
    id_alumno INT NOT NULL AUTO_INCREMENT,
    nombre_s VARCHAR(60) NOT NULL,
    apellido_paterno VARCHAR(45) NOT NULL,
    apellido_materno VARCHAR(45) NOT NULL,
    no_cuenta VARCHAR(20) NOT NULL UNIQUE,
    correo VARCHAR(100) NOT NULL UNIQUE,
    semestre INT NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_alumno)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla PROFESOR
CREATE TABLE IF NOT EXISTS profesor (
    id_profesor INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(60) NOT NULL,
    apellido_paterno VARCHAR(45) NOT NULL,
    apellido_materno VARCHAR(45) NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY (id_profesor)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla MATERIA
CREATE TABLE IF NOT EXISTS materia (
    id_materia INT NOT NULL AUTO_INCREMENT,
    nombre_s VARCHAR(100) NOT NULL,
    semestre INT NOT NULL,
    clave VARCHAR(10) NOT NULL UNIQUE,
    creditos INT NOT NULL,
    tipo ENUM('Obligatoria', 'Optativa', 'Especialidad') NOT NULL,
    PRIMARY KEY (id_materia)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla GRUPO
CREATE TABLE IF NOT EXISTS grupo (
    id_grupo INT NOT NULL AUTO_INCREMENT,
    id_materia INT NOT NULL,
    id_profesor INT NOT NULL,
    clave_grupo VARCHAR(10) NOT NULL,
    turno ENUM('Matutino', 'Vespertino', 'Nocturno') NOT NULL,
    cupo INT NOT NULL,
    horario VARCHAR(100) NOT NULL,
    aula VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_grupo),
    FOREIGN KEY (id_materia) REFERENCES materia(id_materia),
    FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor),
    UNIQUE KEY (id_materia, clave_grupo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla INSCRIPCION
CREATE TABLE IF NOT EXISTS inscripcion (
    id_inscripcion INT NOT NULL AUTO_INCREMENT,
    id_alumno INT NOT NULL,
    id_grupo INT NOT NULL,
    fecha_inscripcion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estatus ENUM('Activa', 'Baja', 'Finalizada') DEFAULT 'Activa',
    calificacion DECIMAL(3,1),
    PRIMARY KEY (id_inscripcion),
    FOREIGN KEY (id_alumno) REFERENCES alumno(id_alumno),
    FOREIGN KEY (id_grupo) REFERENCES grupo(id_grupo),
    UNIQUE KEY (id_alumno, id_grupo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insertar datos de prueba
INSERT INTO profesor (nombre, apellido_paterno, apellido_materno, correo) VALUES
('Juan', 'Pérez', 'López', 'jperez@escuela.edu.mx'),
('María', 'González', 'Martínez', 'mgonzalez@escuela.edu.mx'),
('Carlos', 'Sánchez', 'Ramírez', 'csanchez@escuela.edu.mx');

INSERT INTO materia (nombre_s, semestre, clave, creditos, tipo) VALUES
('Programación I', 1, 'PROG1', 8, 'Obligatoria'),
('Matemáticas Discretas', 1, 'MATD1', 6, 'Obligatoria'),
('Bases de Datos', 3, 'BD3', 8, 'Obligatoria'),
('Inteligencia Artificial', 7, 'IA7', 6, 'Especialidad'),
('Taller de Investigación', 5, 'TINV5', 4, 'Obligatoria'),
('Programación II', 2, 'PROG2', 8, 'Obligatoria'),
('Estructuras de Datos', 3, 'ED3', 6, 'Obligatoria');

INSERT INTO grupo (id_materia, id_profesor, clave_grupo, turno, cupo, horario, aula) VALUES
(1, 1, 'G01', 'Matutino', 25, 'Lunes y Miércoles 7:00-9:00', 'A101'),
(1, 2, 'G02', 'Vespertino', 25, 'Martes y Jueves 14:00-16:00', 'A102'),
(3, 3, 'G01', 'Matutino', 20, 'Lunes y Miércoles 9:00-11:00', 'A201'),
(4, 1, 'G01', 'Nocturno', 15, 'Martes y Jueves 19:00-21:00', 'LAB1'),
(6, 2, 'G01', 'Matutino', 25, 'Lunes y Viernes 8:00-10:00', 'A103'),
(7, 3, 'G01', 'Vespertino', 20, 'Martes y Jueves 16:00-18:00', 'A202');