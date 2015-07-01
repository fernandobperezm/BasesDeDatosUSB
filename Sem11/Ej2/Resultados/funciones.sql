/*
 *  Archivo: funciones.sql
 *
 *  Contenido:
 *          Funciones del Laboratorio Tema 10
 *
 *  Creado por:
 *          Prof. Leonid TINEO
 *          UNIVERSIDAD SIMÓN BOLÍVAR
 *  Fecha:  22 de noviembre de 2014
 */

--------------------------------------------------------------------------------
/* 
    5.	
    Cree un trigger que actualice el índice y el número de créditos aprobados 
    de un estudiante, cada vez que se actualiza la nota de una asignatura.
*/
CREATE OR REPLACE FUNCTION ActIndiceyCreditos() 
RETURNS TRIGGER AS $ActIndiceyCreditos$
DECLARE 
   c   ASIGNATURA.creditos%TYPE;
   ca  ESTUDIANTE.creditosaprob%TYPE;
   i   ESTUDIANTE.indice%TYPE;
BEGIN

   SELECT creditos INTO c
   FROM ASIGNATURA
   WHERE codasig=NEW.codasig;

   SELECT indice,creditosaprob INTO i,ca
   FROM ESTUDIANTE
   WHERE carnet=NEW.carnet;

   UPDATE ESTUDIANTE SET 
      indice = (i*ca+NEW.nota*c)/(ca+c),
      creditosaprob = ca+c 
   WHERE carnet=NEW.carnet;

   RETURN NEW;

END;
$ActIndiceyCreditos$ LANGUAGE plpgsql;

CREATE TRIGGER ActIndiceyCreditos 
AFTER UPDATE ON CURSA  
FOR EACH ROW 
WHEN (OLD.nota IS NULL AND NEW.nota >= 3)
EXECUTE PROCEDURE ActIndiceyCreditos();

--------------------------------------------------------------------------------
/*
    6.
    Escriba un procedimiento que actualice todas las notas de 
    una asignatura dada de la tabla CURSA y un trimestre dado. 
*/

CREATE OR REPLACE FUNCTION ActualizarNotas(
    codigo ASIGNATURA.codasig%TYPE, 
    tri CURSA.trimestre%TYPE, 
	an CURSA.anio%TYPE
)
RETURNS VOID AS $$
BEGIN
    UPDATE CURSA AS c 
    SET 
        nota = round(4*random())+1
    WHERE
        codasig=codigo AND 
        trimestre=tri AND 
        anio=an;
END;
$$ LANGUAGE plpgsql;


--------------------------------------------------------------------------------
/*
    7. 
    Crear un procedimiento almacenado que inscribe los estudiantes 
    en el trimestre abril-julio 2012 con las asignaturas de su carrera 
    que no habían visto hasta el trimestre enero-marzo 2012 
*/

CREATE OR REPLACE FUNCTION InscribirEstudiantes(
    tri CURSA.trimestre%TYPE, 
	an CURSA.anio%TYPE
)
RETURNS VOID AS $$
DECLARE
    e CURSOR IS 
	    SELECT DISTINCT e1.carnet, a.codasig
        FROM
            ESTUDIANTE AS e1, ASIGNATURA AS a, PERTENECE as p
        WHERE ( 
            e1.idcarrera=p.idcarrera AND 
            a.codasig=p.codasig AND 
            (e1.carnet,a.codasig) NOT IN(
                SELECT carnet, codasig FROM CURSA
            )
        )
    ;
BEGIN
    FOR reg_est IN e LOOP
        IF NOT EXISTS (
            SELECT * FROM SECCION 
            WHERE 
                (codasig,trimestre,anio,nroseccion) 
                = (reg_est.codasig,tri,an,1)
        ) 
        THEN
            INSERT INTO SECCION VALUES (
                reg_est.codasig,tri,an,1
            );
        END IF;

        INSERT INTO CURSA VALUES (
            reg_est.carnet,reg_est.codasig,tri,an,1,'INSCRITO',NULL,NULL
        );
        
    END LOOP;
END;
$$ LANGUAGE plpgsql;


--------------------------------------------------------------------------------
/*
    8.
    Cree una función almacenada que dados el carnet de un estudiante y 
    un trimestre, calcule el número de créditos inscritos en ese trimestre.  
*/

CREATE OR REPLACE FUNCTION NumCreditosInscritos(
    car ESTUDIANTE.carnet%TYPE, 
    tri CURSA.trimestre%TYPE, 
	an CURSA.anio%TYPE
)
RETURNS ASIGNATURA.creditos%TYPE AS $$
DECLARE
    sc ASIGNATURA.creditos%TYPE;
BEGIN
    SELECT SUM(creditos) INTO sc 
    FROM CURSA AS c, ASIGNATURA AS a 
    WHERE (
        c.carnet=car AND 
        c.trimestre=tri AND 
        c.anio=an AND 
        a.codasig=c.codasig
    );
    RETURN sc;
END
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------
