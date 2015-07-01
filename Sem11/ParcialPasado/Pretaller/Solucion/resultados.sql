/*
 *  Archivo: examen02hora34.sql
 *
 *  Autor: Prof. Leonid Tineo
 *
 *  Fecha: 26 de noviembre de 2014
 */

/*
    A.  Mediante una operación de SQL se quiere calcular y almacenar
        el número de asignaturas que tiene cada departamento.
*/
ALTER TABLE DEPARTAMENTO ADD COLUMN
    cantasig NUMERIC(4) DEFAULT 0; -- Cantidad de Asignaturas

UPDATE    DEPARTAMENTO d 
SET cantasig = (
        SELECT    COUNT(*)
        FROM    ASIGNATURA a
        WHERE (
            a.iddepartamento = d.iddepartamento
        )
);

/*
    Para mostrar que se hizo bien la operación,
    luego de la misma ejecute la consulta:
*/
SELECT iddepartamento, cantasig 
FROM DEPARTAMENTO;

/*  
    B.  Dar pares de nombre de carrera y asignatura
	tales que las asignatura pertenece a la carrera
	y todos los estudiantes de la carrera la han cursado
	(sin importar el estado)
*/
SELECT
    k.nombre, a.nomasig
FROM
    CARRERA k, PERTENECE p, ASIGNATURA a
WHERE
	k.idcarrera = p.idcarrera AND
	a.codasig = p.codasig AND
    NOT EXISTS (
        SELECT  * 
        FROM    ESTUDIANTE e
        WHERE
            e.idcarrera = p.idcarrera AND
            NOT EXISTS (
                SELECT  *
                FROM    CURSA c
                WHERE
                    c.carnet = e.carnet AND
                    c.codasig = p.codasig
            )
    )
;
    
/*
    C.  Cree una vista que, para cada departamento, año y trimestre calcule 
        la cantidad total de estudiantes que reprobaron en el departamento
		(este total no discrimina aasiganturas ni secciones, es general)
        Los atributos de la vista serían simplemente
        iddepartamento, año, trimestre y cantidad de reprobados.
*/        
CREATE OR REPLACE VIEW REPROBADOS
AS (
    SELECT
        a.iddepartamento, c.anio, c.trimestre, COUNT(*) AS cantidad
    FROM
        ASIGNATURA a, CURSA c 
    WHERE
        a.codasig = c.codasig AND
        c.estado = 'REPROBADO'
    GROUP BY
        a.iddepartamento, c.anio, c.trimestre
);

/*
    Para mostrar que se hizo bien la operación, 
    luego de la misma ejecute la consulta: 
*/
SELECT * FROM REPROBADOS;


/*
    D.  Haciendo uso de la vista del ejercicio anterior, liste los departamentos
        que tienen el mayor número de estudiantes reprobados en cada trimestre.
        Incluya el nombre del departamento y los atributos de la vista,
		Use el operador IN con una consulta anidada no correlacionada.
*/
SELECT
    d.nomdpto, r.iddepartamento, r.anio, r.trimestre, r.cantidad
FROM
    DEPARTAMENTO d, REPROBADOS r
WHERE
    d.iddepartamento = r.iddepartamento AND
    (r.anio, r.trimestre, r.cantidad) IN (
        SELECT  anio, trimestre, MAX(cantidad)
        FROM    REPROBADOS
        GROUP BY anio, trimestre
    )
;


/*
    E.  Implemente la función maxReprobadas que recibe un trimestre
        (año y mes inicial) y retorna el número máximo de asignaturas 
        reprobadas ese trimestre de entre todos los estudiantes.
        La función no puede hacer uso de vistas ni consultas anidadas. 
*/
CREATE OR REPLACE FUNCTION maxReprobadas (
    pf_trim    SECCION.trimestre%TYPE,
    pf_anio    SECCION.anio%TYPE
) RETURNS NUMERIC AS $$
DECLARE
    reprobadas CURSOR (
        pc_trim    SECCION.trimestre%TYPE,
        pc_anio    SECCION.anio%TYPE
    ) IS (
        SELECT    COUNT(*) AS cantidad
        FROM    CURSA 
        WHERE
            trimestre = pc_trim AND
            anio = pc_anio AND
            estado = 'REPROBADO'
        GROUP BY
            carnet
    );
    v_max    NUMERIC    := 0;
BEGIN
    FOR v_cant IN reprobadas(pf_trim, pf_anio) LOOP
        IF (v_cant.cantidad > v_max) THEN
            v_max := v_cant.cantidad;
        END IF;
    END LOOP;
    RETURN v_max;
END;
$$ LANGUAGE plpgsql;

/*
    Para mostrar que se hizo bien la función, ejecute la consulta
*/
SELECT
    maxReprobadas('ENERO',2011),
    maxReprobadas('ABRIL',2011),
    maxReprobadas('SEPTIEMBRE',2011)
;

/*
    F.	Una asignatura puede cambiar de departamento
        Implemente esta regla: 
        'Cuando ua asignatura cambia de departamento,
        el número total de asignaturas debe actualizarse
        decrementando en el departamento de origen
        aumentando en el departamento destino
*/

CREATE OR REPLACE FUNCTION actualizarCantAsig(
) RETURNS TRIGGER AS $actualizarCantAsig$
BEGIN

    UPDATE  DEPARTAMENTO
    SET     cantasig = cantasig-1 
    WHERE   iddepartamento = OLD.iddepartamento;

    UPDATE  DEPARTAMENTO
    SET     cantasig = cantasig+1 
    WHERE   iddepartamento = NEW.iddepartamento;

	RETURN NEW;
END;
$actualizarCantAsig$ LANGUAGE plpgsql;

CREATE TRIGGER actualizarCantAsig 
AFTER UPDATE OF iddepartamento ON ASIGNATURA 
FOR EACH ROW 
WHEN (NEW.iddepartamento <> OLD.iddepartamento )
EXECUTE PROCEDURE actualizarCantAsig();

/*
    Para probar esta regla, ejecute las instrucciones
*/   
SELECT * FROM DEPARTAMENTO;
UPDATE ASIGNATURA SET iddepartamento = 104 WHERE nomasig LIKE 'Laboratorio%';
SELECT * FROM DEPARTAMENTO;
 
