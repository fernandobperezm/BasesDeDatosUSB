/*
 *  Archivo: TallerDos.sql
 *
 *  Autor: Prof. Leonid Tineo
 *
 *  Fecha: 26 de junio de 2014
 */

/*
    A.  Mediante una operaci�n de SQL se quiere volver a calcular y almacenar
        el valor correcto del �ndice acad�mico de los estudiantes. 
        S�lo se consideran cursos con estado �APROBADO� o �REPROBADO�.
*/
 
UPDATE    ESTUDIANTE e 
SET indice = (
        SELECT    SUM(c.nota*a.creditos)/ SUM(a.creditos)
        FROM    CURSA c, ASIGNATURA a
        WHERE
            e.carnet = c.carnet AND c.codasig = a.codasig AND
            (c.estado = 'APROBADO' OR c.estado = 'REPROBADO')
);

/*
    Para mostrar que se hizo bien la operaci�n,
    luego de la misma ejecute la consulta:
*/
SELECT 'despues' AS momento, carnet, indice 
FROM ESTUDIANTE;

/*  
    B.  Para todos los estudiantes que hayan aprobado 
        todas las asignaturas de su carrera, 
        dar el carnet, apellido, nombre, �ndice acad�mico, 
        c�digo y nombre de la carrera.
*/
SELECT
    e.carnet, e.apellidos, e.nombres, e.indice, e.idcarrera, k.nombre
FROM
    ESTUDIANTE e, CARRERA k
WHERE
	k.idcarrera = e.idcarrera AND
    NOT EXISTS (
        SELECT    * 
        FROM    PERTENECE p
        WHERE
            p.idcarrera = e.idcarrera AND
            NOT EXISTS (
                SELECT    *
                FROM    CURSA c
                WHERE
                    c.carnet = e.carnet AND
                    c.codasig = p.codasig AND
                    c.estado = 'APROBADO'
            )
    )
;
    
/*
    C.  Cree una vista que, para cada asignatura, calcule 
        la cantidad de reprobados en el trimestre enero-marzo 2011.
        Los atributos de la vista ser�an simplemente
        el c�digo y el n�mero de reprobados.
*/        
CREATE OR REPLACE VIEW REPROBADOS
AS (
    SELECT    codasig, COUNT(*) AS cantidad
    FROM    CURSA 
    WHERE
        trimestre = 'ENERO' AND anio = 2011 AND
		estado = 'REPROBADO'
    GROUP BY
        codasig
);

/*
    Para mostrar que se hizo bien la operaci�n, 
    luego de la misma ejecute la consulta: 
*/
SELECT * FROM REPROBADOS;

/*
    D.  Haciendo uso de la vista del ejercicio anterior, liste las asignaturas
        que tienen el mayor n�mero de estudiantes reprobados en ese trimestre.
        Incluya, adem�s de los atributos de la vista, 
        el nombre de la asignatura y del departamento a que corresponde �sta.
*/
SELECT
    r.codasig, r.cantidad, a.nomasig, d.nomdpto
FROM
    REPROBADOS r, ASIGNATURA a, DEPARTAMENTO d
WHERE
    r.codasig = a.codasig AND
    a.iddepartamento = d.iddepartamento AND
    r.cantidad = (
        SELECT    MAX(cantidad)
        FROM    REPROBADOS
    )
;

/*
    E.  Implemente la funci�n maxAprobados que recibe un trimestre
        (a�o y mes inicial) y retorna el n�mero m�ximo de aprobados 
        de entre todas las asignaturas de ese trimestre.
        La funci�n no puede hacer uso de vistas ni consultas anidadas. 
*/
CREATE OR REPLACE FUNCTION maxAprobados (
    pf_trim    SECCION.trimestre%TYPE,
    pf_anio    SECCION.anio%TYPE
) RETURNS NUMERIC AS $$
DECLARE
    aprobados CURSOR (
        pc_trim    SECCION.trimestre%TYPE,
        pc_anio    SECCION.anio%TYPE
    ) IS (
        SELECT    COUNT(*) AS cantidad
        FROM    CURSA 
        WHERE
            trimestre = pc_trim AND
			anio = pc_anio AND
			estado = 'APROBADO'
        GROUP BY
            codasig
    );
    v_max    NUMERIC    := 0;
BEGIN
    FOR v_cant IN aprobados(pf_trim, pf_anio) LOOP
        IF (v_cant.cantidad > v_max) THEN
            v_max := v_cant.cantidad;
        END IF;
    END LOOP;
    RETURN v_max;
END;
$$ LANGUAGE plpgsql;

/*
    Para mostrar que se hizo bien la operaci�n, 
    luego de la misma ejecute la consulta
*/
SELECT
    maxAprobados('ENERO',2011),
    maxAprobados('ABRIL',2011),
    maxAprobados('SEPTIEMBRE',2011)
;

/*
    F.	Implemente esta regla: 
        �Cuando un estudiante aprueba una asignatura, si la ten�a reprobada, 
        queda sin efecto la nota del trimestre m�s reciente en que la reprob��.
        El estado debe cambiar de �REPROBADO� a �SIN EFECTO�.
*/
CREATE OR REPLACE FUNCTION ordinal (
    pf_trim    SECCION.trimestre%TYPE
) RETURNS NUMERIC AS $$
BEGIN
    IF (pf_trim = 'ENERO') THEN
        RETURN 1;
    ELSIF (pf_trim = 'ABRIL') THEN
        RETURN 2;
    ELSIF (pf_trim = 'JULIO') THEN
        RETURN 3;
    ELSIF (pf_trim = 'SEPTIEMBRE') THEN
        RETURN 4;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION notaSinEfecto(
) RETURNS TRIGGER AS $notaSinEfecto$
BEGIN
    UPDATE CURSA c1
    SET estado = 'SIN EFECTO' 
    WHERE 
        c1.carnet = NEW.carnet AND
        c1.codasig = NEW.codasig AND
        c1.estado = 'REPROBADO' AND
        NOT EXISTS (
            SELECT    * 
            FROM    CURSA c2
            WHERE 
                c2.carnet = NEW.carnet AND
                c2.codasig = NEW.codasig AND
                c2.estado = 'REPROBADO' AND(
                    c2.anio > c1.anio OR ( 
                        c2.anio = c1.anio AND 
                        ordinal(c1.trimestre) < ordinal(c2.trimestre)
                    )
                )
        )            
    ;
	RETURN NEW;
END;
$notaSinEfecto$ LANGUAGE plpgsql;

CREATE TRIGGER notaSinEfecto 
AFTER INSERT OR UPDATE OF estado ON CURSA 
FOR EACH ROW 
WHEN (NEW.estado = 'APROBADO')
EXECUTE PROCEDURE notaSinEfecto();

/*
    Para probar esta regla, actualice el estado de materias cursadas 
    en el trimestre enero-marzo 2012, mediante la operaci�n: 
*/    
UPDATE CURSA 
SET estado = 'APROBADO'
WHERE 
	trimestre = 'ENERO' AND 
	anio = '2012' AND
	nota >= 3
;

/*
    Para mostrar que se hizo bien la operaci�n, 
    luego de la misma ejecute la consulta:
*/
SELECT * 
FROM CURSA
WHERE 
	estado = 'SIN EFECTO'
;
