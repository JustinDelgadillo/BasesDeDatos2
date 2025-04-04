-- Mostrar bases de datos existentes
SHOW DATABASES;
-- Crear base de datos si no existe
CREATE DATABASE IF NOT EXISTS ico;
-- Usar la base de datos
USE ico;
-- Mostrar tablas en la base de datos actual
SHOW TABLES;

-- Crear tabla ALUMNO
CREATE TABLE IF NOT EXISTS alumno (
    id_alumno INT NOT NULL AUTO_INCREMENT,
    nombre_s VARCHAR(60) NOT NULL,
    apellido_paterno VARCHAR(45) NOT NULL,
    apellido_materno VARCHAR(45) NOT NULL,
    no_cuenta BIGINT NOT NULL,
    correo VARCHAR(100) NOT NULL,
    semestre INT,
    Laboratorio VARCHAR(100),
    PRIMARY KEY (id_alumno)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Crear tabla MATERIA
CREATE TABLE IF NOT EXISTS materia (
    id_materia INT NOT NULL AUTO_INCREMENT,
    nombre_s VARCHAR(100) NOT NULL,
    semestre VARCHAR(10) NOT NULL,
    clave VARCHAR(10) NOT NULL,
    creditos INT,
    tipo VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_materia))
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Crear tabla PROFESOR
CREATE TABLE IF NOT EXISTS profesor (
    id_profesor INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(60) NOT NULL,
    apellido_paterno VARCHAR(45) NOT NULL,
    apellido_materno VARCHAR(45) NOT NULL,
    correo VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_profesor))
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Crear tabla GRUPO
CREATE TABLE IF NOT EXISTS grupo (
    id_grupo INT NOT NULL AUTO_INCREMENT,
    numero VARCHAR(10) NOT NULL,
    turno VARCHAR(20) NOT NULL,
    semestre VARCHAR(10) NOT NULL,
    PRIMARY KEY (id_grupo))
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Crear tabla LABORATORIO
CREATE TABLE IF NOT EXISTS laboratorio (
    id_laboratorios INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    semestre VARCHAR(10) NOT NULL,
    clave VARCHAR(10) NOT NULL,
    creditos INT,
    tipo VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_laboratorios))
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Crear tabla DOMICILIO (manteniendo relación con ALUMNO)
CREATE TABLE IF NOT EXISTS domicilio (
    id_domicilio INT NOT NULL AUTO_INCREMENT,
    id_alumno INT NOT NULL,
    cp VARCHAR(10) DEFAULT NULL,
    pais VARCHAR(30) DEFAULT NULL,
    PRIMARY KEY (id_domicilio),
    FOREIGN KEY (id_alumno) REFERENCES alumno(id_alumno)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- Importar datos desde el archivo alumno.txt
-- Importar datos (ajusta la ruta según lo que muestre el comando anterior)
LOAD DATA INFILE '"C:\Users\angel\Downloads\BD\Alumno.txt"'
INTO TABLE alumno
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 0 LINES
(nombre_s, apellido_paterno, apellido_materno, no_cuenta, correo, semestre)
SET id_alumno = NULL; -- Para que AUTO_INCREMENT funcione
-- Verificar datos importados
SELECT * FROM alumno LIMIT 5;


-- Importar datos desde el archivo materias.txt
-- Importar datos (ajusta la ruta según lo que muestre el comando anterior)
LOAD DATA INFILE 'C:/Users/user/Desktop/materias.txt'
INTO TABLE materia
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 0 LINES
(nombre, semestre, clave, creditos, tipo)
SET id_materia = NULL; -- Para que AUTO_INCREMENT funcione
-- Verificar datos importados
SELECT * FROM materia LIMIT 5;

-- Importar datos desde el archivo profesores.txt
-- Importar datos (ajusta la ruta según lo que muestre el comando anterior)
LOAD DATA INFILE 'C:/Users/user/Desktop/profesores.txt'
INTO TABLE profesor
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 0 LINES
(nombre, apellido_paterno, apellido_materno, correo)
SET id_profesor = NULL; -- Para que AUTO_INCREMENT funcione
-- Verificar datos importados
SELECT * FROM profesor LIMIT 5;


-- Importar datos desde el archivo grupos.txt
-- Importar datos (ajusta la ruta según lo que muestre el comando anterior)
LOAD DATA INFILE 'C:/Users/user/Desktop/grupos.txt'
INTO TABLE grupo
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 0 LINES
(numero, turno, semestre)
SET id_grupo = NULL; -- Para que AUTO_INCREMENT funcione
-- Verificar datos importados
SELECT * FROM grupo LIMIT 5;


-- Importar datos desde el archivo laboratorios.txt
-- Importar datos (ajusta la ruta según lo que muestre el comando anterior)
LOAD DATA INFILE 'C:/Users/user/Desktop/laboratorios.txt'
INTO TABLE laboratorio
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 0 LINES
(nombre, semestre, clave, creditos, tipo)
SET id_laboratorios = NULL; -- Para que AUTO_INCREMENT funcione
-- Verificar datos importados
SELECT * FROM laboratorio LIMIT 5;


