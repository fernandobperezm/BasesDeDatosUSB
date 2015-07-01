/*
 *  Archivo: estSchema.sql
 *
 *  Contenido:
 *          Scrit de creación de la base de datos de estudiantes.
 *
 *  Creado por:
 *          Prof. Edna RUCKHAUS
 *          UNIVERSIDAD SIMÓN BOLÍVAR
 *  Fecha:  24 de Octubre de 2010
 *
 *  Modificado por:
 *          Prof. Leonid TINEO
 *          UNIVERSIDAD SIMÓN BOLÍVAR
 *  Fecha:  12 de noviembre de 2012
 */
 

/*  Definicion de tablas, sus claves primarias y restricciones de nulidad  */

CREATE TABLE ESTUDIANTE(
        carnet         VARCHAR(7)   NOT NULL,
        apellidos      VARCHAR(30)  NOT NULL,
        nombres        VARCHAR(30)  NOT NULL,
        fechaNac       DATE         NOT NULL,
        indice         NUMERIC(4,2) NULL,
        creditosaprob  NUMERIC(3)   NULL,
        idcarrera      NUMERIC(4)   NOT NULL,
        fechingreso    DATE         NOT NULL,
        CONSTRAINT PK_ESTUDIANTE PRIMARY KEY(carnet)
);

CREATE TABLE CURSA(
        carnet VARCHAR(7) NOT NULL,
        codasig CHAR(6) NOT NULL,
        trimestre VARCHAR(10) NOT NULL,
        anio NUMERIC(4) NOT NULL,
        nroseccion    NUMERIC(2) NOT NULL,
        estado VARCHAR(10) NOT NULL,
        causa VARCHAR(30), 
        nota NUMERIC(1),
        CONSTRAINT PK_CURSA PRIMARY KEY (carnet,codasig,trimestre,anio,nroseccion)
);

CREATE TABLE SECCION(
        codasig CHAR(6) NOT NULL,
        trimestre VARCHAR(10) NOT NULL,
        anio NUMERIC(4) NOT NULL,
        nroseccion    NUMERIC(2) NOT NULL,
        CONSTRAINT PK_SECCION PRIMARY KEY (codasig,trimestre,anio,nroseccion)
);

CREATE TABLE DICTA(
        ciprof NUMERIC(8) NOT NULL,
        codasig CHAR(6) NOT NULL,
        trimestre VARCHAR(10) NOT NULL,
        anio NUMERIC(4) NOT NULL,
        nroseccion    NUMERIC(2) NOT NULL,
        nroinscritos NUMERIC(2) NOT NULL,
        nrorechazados NUMERIC(2) NOT NULL, 
        CONSTRAINT PK_DICTA PRIMARY KEY (ciprof,codasig,trimestre,anio,nroseccion)
);

CREATE TABLE PROFESOR(
        ciprof         NUMERIC(8)   NOT NULL,
        apellidos      VARCHAR(30)  NOT NULL,
        nombres        VARCHAR(30)  NOT NULL,
        fechaNac       DATE         NOT NULL,
        cargo          VARCHAR(10)  NOT NULL,
        fechingreso    DATE         NOT NULL,
        iddepartamento VARCHAR(3)  NOT NULL,
        CONSTRAINT PK_PROFESOR PRIMARY KEY(ciprof)
);

CREATE TABLE DEPARTAMENTO (
        iddepartamento VARCHAR(3) NOT NULL, 
        nomdpto VARCHAR(50),
        CONSTRAINT PK_DEPARTAMENTO PRIMARY KEY(iddepartamento)
);

CREATE TABLE ASIGNATURA(
        codasig CHAR(6) NOT NULL,
        nomasig VARCHAR(50) NOT NULL,
        creditos NUMERIC(2) NOT NULL,
        horassem NUMERIC(2) NOT NULL,
        iddepartamento VARCHAR(3) NOT NULL,
        tipo  VARCHAR(12) NOT NULL,
        CONSTRAINT PK_ASIGNATURA PRIMARY KEY(codasig)
);

CREATE TABLE PERTENECE(
        codasig CHAR(6) NOT NULL,
        idcarrera NUMERIC(4) NOT NULL,
        tipopensum    VARCHAR(12),
        CONSTRAINT PK_PERTENECE PRIMARY KEY (codasig, idcarrera)
);

CREATE TABLE CARRERA(
    idcarrera NUMERIC(4) NOT NULL, 
    nombre VARCHAR(25) NOT NULL,
    idcoordinacion VARCHAR(3) NOT NULL,
    CONSTRAINT PK_CARRERA PRIMARY KEY(idcarrera)
);

CREATE TABLE COORDINACION (
        idcoordinacion VARCHAR(3) NOT NULL, 
        nomcoord VARCHAR(50),
        CONSTRAINT PK_COORDINACION PRIMARY KEY(idcoordinacion)
);

/* Declaracion de las claves foraneas de las relaciones en el esquema */

/* Claves foraneas de la relacion ESTUDIANTE */
ALTER TABLE ESTUDIANTE ADD 
    CONSTRAINT FK_ESTUDIANTE_CARRERA FOREIGN KEY (idcarrera) 
        REFERENCES CARRERA;

/* Claves foraneas de la relacion CURSA */
ALTER TABLE CURSA ADD 
    CONSTRAINT FK_CURSA_ESTUDIANTE FOREIGN KEY (carnet) 
        REFERENCES ESTUDIANTE;
ALTER TABLE CURSA ADD 
    CONSTRAINT FK_CURSA_SECCION FOREIGN KEY (codasig,trimestre,anio,nroseccion)
        REFERENCES SECCION;

/* Claves foraneas de la relacion SECCION */
ALTER TABLE SECCION ADD 
    CONSTRAINT FK_SECCION_ASIGNATURA FOREIGN KEY (codasig) 
        REFERENCES ASIGNATURA;

/* Claves foraneas de la relacion DICTA */
ALTER TABLE DICTA ADD 
    CONSTRAINT FK_DICTA_PROFESOR FOREIGN KEY (ciprof) 
        REFERENCES PROFESOR;
ALTER TABLE DICTA ADD 
    CONSTRAINT FK_DICTA_SECCION FOREIGN KEY (codasig,trimestre,anio,nroseccion)
        REFERENCES SECCION;

/* Claves foraneas de la relacion PROFESOR */
ALTER TABLE PROFESOR ADD 
    CONSTRAINT FK_PROFESOR_DEPARTAMENTO FOREIGN KEY (iddepartamento) 
        REFERENCES DEPARTAMENTO;

/* Claves foraneas de la relacion ASIGNATURA */
ALTER TABLE ASIGNATURA ADD 
    CONSTRAINT FK_ASIGNATURA_DEPARTAMENTO FOREIGN KEY (iddepartamento) 
        REFERENCES DEPARTAMENTO;

/* Claves foraneas de la relacion PERTENECE */
ALTER TABLE PERTENECE ADD 
    CONSTRAINT FK_PERTENECE_ASIGNATURA FOREIGN KEY (codasig) 
        REFERENCES ASIGNATURA;
ALTER TABLE PERTENECE ADD 
    CONSTRAINT FK_PERTENECE_CARRERA FOREIGN KEY (idcarrera) 
        REFERENCES CARRERA;

/* Claves foraneas de la relacion CARRERA */
ALTER TABLE CARRERA ADD 
    CONSTRAINT FK_CARRERA_COORDINACION FOREIGN KEY (idcoordinacion) 
        REFERENCES COORDINACION;
