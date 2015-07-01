/*
 *  Archivo: consultas.sql
 *
 *  Contenido:
 *          Consultas del Laboratorio Tema 10, ítem 4 
 *
 *  Modificado por:
 *          Prof. Leonid TINEO
 *          UNIVERSIDAD SIMÓN BOLÍVAR
 *  Fecha:  22 de noviembre de 2014
 */

--------------------------------------------------------------------------------
/* 
    4. a)	Diga el nombre de la carrera que tiene 
    el mayor número de créditos aprobados con respecto a las demás carreras 
    (sin utilizar la vista creada anteriormente)
*/

SELECT nombre
FROM CARRERA
WHERE idcarrera IN(
    SELECT idcarrera 
    FROM ESTUDIANTE 
	WHERE creditosaprob >= ALL (
        SELECT creditosaprob 
        FROM ESTUDIANTE    
    )
);	

--------------------------------------------------------------------------------
/*
    4. b)	Diga el apellido y nombre de los estudiantes cuyo índice está 
    por encima del índice promedio de la carrera que estudia, 
    utilizando una subconsulta correlacionada. 
*/

SELECT
    apellidos, nombres
FROM
    ESTUDIANTE AS e1
WHERE indice > (
     SELECT AVG(indice) 
     FROM ESTUDIANTE AS e2
	 WHERE e1.idcarrera=e2.idcarrera
);

--------------------------------------------------------------------------------
/*
    4. c)	Muestre los datos de los estudiantes que estudian la misma carrera y 
    tienen la misma fecha de ingreso que 
    el estudiante con mayor índice de la carrera, 
    ordenado descendentemente por índice académico. 
    Utilice subconsultas y la cláusula IN 
*/	 

SELECT * FROM ESTUDIANTE
WHERE (idcarrera,fechingreso) IN (
    SELECT idcarrera,fechingreso 
    FROM ESTUDIANTE 
    WHERE (idcarrera,indice) IN (
       SELECT idcarrera,MAX(indice)
       FROM ESTUDIANTE
       GROUP BY idcarrera
    )
);

--------------------------------------------------------------------------------
/*
    4. d)	Dé los datos de los estudiantes que han cursado 
    con el Prof. Pedro Pérez todas las materias que dicta el Prof. Pedro Pérez
*/

-- Versión 1

SELECT * FROM ESTUDIANTE AS e
WHERE NOT EXISTS(
    SELECT *
    FROM DICTA AS d,PROFESOR AS p
    WHERE (
        d.ciprof = p.ciprof AND 
        p.apellidos='Perez' AND 
        p.nombres='Pedro' AND 
        NOT EXISTS (
            SELECT * 
            FROM CURSA AS c
            WHERE 
                c.carnet=e.carnet AND 
                c.codasig=d.codasig AND 
                d.ciprof=p.ciprof
	    )
    )
);
	
-- Versión 2

SELECT * FROM ESTUDIANTE AS e
WHERE NOT EXISTS (
    SELECT d1.codasig 
    FROM DICTA AS d1,PROFESOR AS P 
    WHERE (
        d1.ciprof = p.ciprof AND 
        p.apellidos='Perez' AND 
        p.nombres='Pedro'
    )
    EXCEPT( 
        SELECT c.codasig 
        FROM CURSA AS c, PROFESOR AS p, DICTA AS d2
        WHERE (
            c.carnet=e.carnet AND 
            c.codasig=d2.codasig AND 
            d2.ciprof=p.ciprof AND 
            p.apellidos='Perez' AND 
            p.nombres='Pedro'
        )
	)
);
--------------------------------------------------------------------------------
