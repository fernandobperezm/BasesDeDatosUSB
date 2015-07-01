/*
 *  Archivo: operaciones.sql
 *
 *  Contenido:
 *          Definición y prueba de operaciones del Laboratorio Tema 10
 *
 *  Modificado por:
 *          Prof. Leonid TINEO
 *          UNIVERSIDAD SIMÓN BOLÍVAR
 *  Fecha:  22 de noviembre de 2014
 */

--------------------------------------------------------------------------------
-- 1. a)	

-- Cree una nueva tabla denominada ESTCOMPU con
-- los mismos atributos de la tabla estudiante
-- excepto el idcarrera.

CREATE TABLE ESTCOMPU(
    carnet         VARCHAR(7)   NOT NULL,
    apellidos      VARCHAR(30)  NOT NULL,
    nombres        VARCHAR(30)  NOT NULL,
    fechaNac       DATE         NOT NULL,
    indice         NUMERIC(4,2) NULL,
    creditosaprob  NUMERIC(3)   NULL,
    fechingreso    DATE         NOT NULL,
    CONSTRAINT PK_ESTCOMPU PRIMARY KEY(carnet)
);

-- Verificar la creación

\d ESTCOMPU

--------------------------------------------------------------------------------
-- 1. b)	

-- Ingrese en ESTCOMPU los datos de los estudiantes de 
-- la carrera ‘Ing. Computacion’ extraidos de la tabla ESTUDIANTE 
-- sin utilizar la clausula VALUES. 

INSERT INTO ESTCOMPU 
    SELECT
        carnet,apellidos,nombres,fechaNac,indice,creditosaprob,fechingreso
	FROM
        ESTUDIANTE
	WHERE
        idcarrera=(
            SELECT idcarrera 
            FROM CARRERA
            WHERE nombre = 'Ing. Computacion'
        )
;

-- Ver los resultados de la inserción

SELECT * FROM ESTCOMPU;
	
--------------------------------------------------------------------------------
-- 1. c)

-- Agregue un nuevo atributo numerico (con dos decimales) 
-- en la tabla CARRERA denominado promedio que va a contener
-- el indice promedio de los estudiantes de cada carrera

ALTER TABLE CARRERA ADD COLUMN promedio NUMERIC(4,2);


-- Verificar la creación

\d CARRERA


--------------------------------------------------------------------------------
-- 1. d)	

-- Actualice el promedio de cada carrera de acuerdo a los indices de
-- los alumnos correspondientes a cada carrera, 
-- usando una subconsulta para la actualización.

UPDATE CARRERA AS c
SET promedio = (
    SELECT AVG(indice)
    FROM ESTUDIANTE AS e
    WHERE c.idcarrera = e.idcarrera
);

-- Ver los resultados de la actualización

SELECT * FROM CARRERA;
	
   
--------------------------------------------------------------------------------
-- 1. e)	

-- Elimine de la tabla CURSA todos aquellos que esten cursando la carrera 
-- ‘Ing. Electrónica’, utilizando una subconsulta para la eliminacion.

DELETE FROM ONLY CURSA AS c 
USING ESTUDIANTE AS e 
WHERE (
    c.carnet=e.carnet AND
    e.idcarrera=(
        SELECT idcarrera 
        FROM CARRERA
        WHERE nombre = 'Ing. Electronica'
    )
);

-- Ver los resultados de la actualización

SELECT * FROM CURSA;
	

--------------------------------------------------------------------------------
-- 2.

-- Cree una vista que contenga el idcarrera, nombre de la carrera,
-- el indice maximo, el numero maximo de creditos aprobados, el indice minimo,
-- el numero minimo de creditos aprobados y el indice promedio.

CREATE OR REPLACE VIEW ESTADISTICAS AS
    SELECT 
       c.idcarrera, c.nombre, 
	   MAX(indice) AS IndiceMaximo, 
	   MAX(creditosaprob) AS NumMaxCredAprob,
	   MIN(indice) AS IndiceMinimo, 
	   MIN(creditosaprob) AS NumMinCredAprob,
	   AVG(indice) AS IndicePromedio
    FROM
        CARRERA AS c, ESTUDIANTE AS e
    WHERE
        c.idcarrera = e.idcarrera
    GROUP BY
        c.idcarrera,c.nombre
;

-- Verificar la creación

\d ESTADISTICAS

-- Ver resultados de la vista

SELECT * FROM ESTADISTICAS;

  
--------------------------------------------------------------------------------
-- 2. a)	
-- Diga el nombre de la carrera que tiene el mayor índice promedio con respecto 
-- a las demás carreras, utilizando la vista anterior.

SELECT nombre
FROM ESTADISTICAS
WHERE IndicePromedio = (
    SELECT MAX(IndicePromedio)
    FROM ESTADISTICAS
);
  
--------------------------------------------------------------------------------
-- 2. b)	
-- Muestre el nombre de la carrera y los datos de los estudiantes cuyo índice 
-- esta por encima del índice promedio de la carrera que estudia.  
-- Utilice la vista creada.

SELECT 
    c.idcarrera, c.nombre, 
    e.carnet,e.apellidos,e.nombres,e.fechaNac,
    e.indice,e.creditosaprob,e.fechingreso
FROM
    ESTADISTICAS as c, ESTUDIANTE AS e
WHERE (
    e.idcarrera = c.idcarrera AND
    e.indice > c.IndicePromedio
);
--------------------------------------------------------------------------------
