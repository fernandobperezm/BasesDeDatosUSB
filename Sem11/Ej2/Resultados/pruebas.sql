/*
 *  Archivo: pruebas.sql
 *
 *  Contenido:
 *          Pruebas de las funciones del Laboratorio Tema 10
 *
 *  Creado por:
 *          Prof. Leonid TINEO
 *          UNIVERSIDAD SIMÓN BOLÍVAR
 *  Fecha:  22 de noviembre de 2014
 */

--------------------------------------------------------------------------------
/* 
    5.	
    Prueba de trigger que actualice el índice y el número de créditos aprobados 
    de un estudiante, cada vez que se actualiza la nota de una asignatura.
    6.
    Prueba de procedimiento que actualice todas las notas de 
    una asignatura dada de la tabla CURSA y un trimestre dado. 
*/

-- Colocar en NULL las notas para poder activar luego el trigger

UPDATE CURSA SET nota = NULL;

-- Veamos las notas e índice de los estudiantes que cursan 'AA0001'

SELECT e.carnet,e.indice,e.creditosaprob,c.codasig,c.trimestre,c.anio,c.nota
FROM ESTUDIANTE AS e, CURSA AS c 
WHERE e.carnet = c.carnet AND c.codasig='AA0001';

-- Llamamos al procedimiento para colocar notas aleatorias

SELECT ActualizarNotas ('AA0001','ENERO',2012);

-- Veamos las notas e índice de los estudiantes que cursan 'AA0001'
-- Observaremos que se ejecutó el trigger

SELECT e.carnet,e.indice,e.creditosaprob,c.codasig,c.trimestre,c.anio,c.nota
FROM ESTUDIANTE AS e, CURSA AS c 
WHERE e.carnet = c.carnet AND c.codasig='AA0001';

--------------------------------------------------------------------------------

/*
    7. 
    Prueba de procedimiento almacenado que inscribe los estudiantes 
    en el trimestre abril-julio 2012 con las asignaturas de su carrera 
    que no habían visto hasta el trimestre enero-marzo 2012 
*/

-- Veamos que no hay estudiantes cursando 'ABRIL' 2012

SELECT * FROM CURSA WHERE trimestre='ABRIL' AND anio=2012;

-- Llamamos al procedimiento para inscribir estudiantes
SELECT InscribirEstudiantes('ABRIL',2012);

-- Veamos que ahora hay estudiantes cursando 'ABRIL' 2012
SELECT * FROM CURSA WHERE trimestre='ABRIL' AND anio=2012;


--------------------------------------------------------------------------------

/*
    8.
    Prueba de función almacenada que dados el carnet de un estudiante y 
    un trimestre, calcule el número de créditos inscritos en ese trimestre.  
*/

-- Llamamos a la función NumCreditosInscritos
SELECT carnet, NumCreditosInscritos(carnet,'ENERO',2012)
FROM ESTUDIANTE;
 
--------------------------------------------------------------------------------
