CREATE TABLE DEPARTAMENTO(
    nomDep  VARCHAR(12) NOT NULL,
    cntEmp  NUMERIC(2) NULL,
    CONSTRAINT PK_DEPARTAMENTO PRIMARY KEY (nomDep)
);

CREATE TABLE TRABAJADOR(
    cedEmp  NUMERIC(8)  NOT NULL,
    nomEmp  VARCHAR(30) NOT NULL,
    apeEmp  VARCHAR(30) NOT NULL,
    fchNac  DATE        NOT NULL,
    telHab  CHAR(11)    NOT NULL,
    telCel  CHAR(11)    NULL,
    dirEmp  VARCHAR(50) NOT NULL,
    nomDep  VARCHAR(12) NOT NULL,
    CONSTRAINT PK_TRABAJADOR PRIMARY KEY(cedEmp),
    CONSTRAINT FK_TRABAJADOR__DEPARTAMENTO FOREIGN KEY(nomDep) REFERENCES DEPARTAMENTO,
    CONSTRAINT EXP_fchNac_TRABAJADOR CHECK(AGE(fchNac) > '18 years')
);

CREATE TABLE HIJO(
    cedEmp  NUMERIC(8)  NOT NULL,
    nomHjo  VARCHAR(30) NOT NULL,
    fchNac  DATE        NOT NULL,
    CONSTRAINT PK_F_NAC_HIJOS PRIMARY KEY(cedEmp,nomHjo,fchNac),
    CONSTRAINT FK_F_NAC_HIJOS__TRABAJADOR FOREIGN KEY(cedEmp) REFERENCES TRABAJADOR,
	CONSTRAINT EXP_fchNac_HIJO CHECK(CURRENT_DATE - fchNac > 0)
);

CREATE TABLE HORARIO(
    diaSem  VARCHAR(10) NOT NULL,
    turDia  VARCHAR(10) NOT NULL,
    hraIni  CHAR(5) NOT NULL,
    hraFin  CHAR(5) NOT NULL,
    CONSTRAINT PK_HORARIO PRIMARY KEY(diaSem,turDia),
    CONSTRAINT DOM_hra CHECK(TO_NUMBER(SUBSTR(hraIni,1,2),'FM99') < TO_NUMBER(SUBSTR(hraFin,1,2),'FM99'))
);

CREATE TABLE PLANIFICACION(
    fchIni  DATE        NOT NULL,
    fchFin  DATE        NOT NULL,
    cedEmp  NUMERIC(8)  NOT NULL,
    CONSTRAINT PK_PLANIFICACION PRIMARY KEY(fchIni,fchFin,cedEmp),
    CONSTRAINT FK_PLANIFICACION__TRABAJADOR FOREIGN KEY(cedEmp) REFERENCES TRABAJADOR,
    CONSTRAINT DOM_fecha CHECK(fchFin-FchIni=6)
);
    
CREATE TABLE INCLUYE(
    fchIni  DATE        NOT NULL,
    fchFin  DATE        NOT NULL,
    cedEmp  NUMERIC(8)  NOT NULL,
    diaSem  VARCHAR(10) NOT NULL,
    turDia  VARCHAR(10) NOT NULL,
    cmpldo  CHAR    NOT NULL,
    CONSTRAINT PK_INCLUYE PRIMARY KEY(fchIni,fchFin,cedEmp,diaSem,turDia),
    CONSTRAINT FK_INCLUYE_PLANIFICACION FOREIGN KEY(fchIni,fchFin,cedEmp) REFERENCES PLANIFICACION,
    CONSTRAINT FK_INCLUYE_HORARIO FOREIGN KEY(diaSem,turDia) REFERENCES HORARIO,
    CONSTRAINT DOM_cmpldo CHECK(cmpldo IN('0','1')),
    CONSTRAINT DOM_fch CHECK(fchFin - fchIni=6)
);

CREATE TABLE ESTABLECE(
    nomDep  VARCHAR(12) NOT NULL,
    diaSem  VARCHAR(10) NOT NULL,
    turDia  VARCHAR(12) NOT NULL,
    tarifa  NUMERIC(6)  NOT NULL,
    CONSTRAINT PK_ESTABLECE PRIMARY KEY(nomDep,diaSem,turDia),
    CONSTRAINT FK_ESTABLECE__HORARIO FOREIGN KEY (diaSem,turDia) REFERENCES HORARIO,
    CONSTRAINT FK_ESTABLECE__DEPARTAMENTO FOREIGN KEY (nomDep) REFERENCES DEPARTAMENTO
);

CREATE TABLE PAGO(
    recibo  NUMERIC(8) NOT NULL,
    fchPgo  DATE NOT NULL,
    mtoPgo  NUMERIC(9,2) NULL,
    fchIni  DATE NOT NULL,
    fchFin  DATE NOT NULL,
    cedEmp  NUMERIC(8) NOT NULL,
    CONSTRAINT PK_PAGO PRIMARY KEY (recibo),
    CONSTRAINT FK_PAGO__PLANIFICA FOREIGN KEY (fchIni,fchFin,cedEmp) REFERENCES PLANIFICACION
);