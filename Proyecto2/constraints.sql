/*
 * Universidad Simón Bolívar.
 * Departamento de Computación y Tecnología de la Información.
 * Asignatura: Laboratorio de Bases de Datos I.
 * Estudiantes:
 * 		Br. Fernando Pérez, carné: 12-11152.
 *		Br. Leslie Rodrigues, carné: 10-10613.
 *
 * Archivo: constraints.sql
 * Descripción: script de sql para añadir los constraints necesarios a los
 * atributos de las tablas ya creadas.
 * Última modificación: 22-05-2015.
 */
 
 -----------------------------------------------------------------------------
 -----------------------------------------------------------------------------
 ------- Las siguientes son constraints de claves primarias ------------------
 -----------------------------------------------------------------------------
 -----------------------------------------------------------------------------
ALTER TABLE ADMINISTRATIVO
	 ADD CONSTRAINT PK_ADMINISTRATIVO PRIMARY KEY (A_CEDULA);
	 
ALTER TABLE BONO_SABATINO
	ADD CONSTRAINT PK_BONO_SABATINO PRIMARY KEY (B_MONTO);
	
ALTER TABLE CARGO
	ADD CONSTRAINT PK_CARGO PRIMARY KEY (CAR_SUELDO_BASE);
	
ALTER TABLE CAMBIO
	ADD CONSTRAINT PK_CAMBIO PRIMARY KEY (CAM_RECIBO);

ALTER TABLE CATEGORIA
	ADD CONSTRAINT PK_CATEGORIA PRIMARY KEY (CAT_SUELDO_BASE);
	
ALTER TABLE CLIENTE
	ADD CONSTRAINT PK_CLIENTE PRIMARY KEY (CL_CEDULA);
	
ALTER TABLE COMPRA
	ADD CONSTRAINT PK_COMPRA PRIMARY KEY (COM_NRO_FACTURA,COM_RIF_TIENDA);
	
ALTER TABLE DEPENDIENTE
	ADD CONSTRAINT PK_DEPENDIENTE PRIMARY KEY (D_NUMERO_DEPENDIENTE);
	
ALTER TABLE EJEMPLAR
	ADD CONSTRAINT PK_EJEMPLAR PRIMARY KEY (E_NUMERO_INVENTRIO);

ALTER TABLE EJEMPLAR_NUEVO
	ADD CONSTRAINT PK_EJEMPLAR_NUEVO PRIMARY KEY (E_N_NUMERO_INVENTARIO);
	
ALTER TABLE EJEMPLAR_USADO
	ADD CONSTRAINT PK_EJEMPLAR_USADO PRIMARY KEY (E_U_NUMERO_INVENTARIO);
	
ALTER TABLE EMPLEADO
	ADD CONSTRAINT PK_EMPLEADO PRIMARY KEY (EM_CEDULA);
	
ALTER TABLE ENTREGA
	ADD CONSTRAINT PK_ENTREGA PRIMARY KEY (ENEN_PROVEEDOR,EN_PRODUCTO_NUEVO, EN_FACTURA, EN_RIF_PROVEEDORA);
	
ALTER TABLE ES_FAMILIAR
	ADD CONSTRAINT PK_ES_FAMILIAR PRIMARY KEY (ES_F_EMPLEADO, ES_F_DEPENDIENTE);
	I
ALTER TABLE FACTURA
	ADD CONSTRAINT PK_FACTURA PRIMARY KEY (F_NUMERO_FACTURA, F_RIF_EMPRESA);
	
ALTER TABLE LISTA_DE_PRECIOS
	ADD CONSTRAINT PK_LISTA_DE_PRECIOS PRIMARY KEY (L_P_PRECIO);
	
ALTER TABLE NUEVO
	ADD CONSTRAINT PK_NUEVO PRIMARY KEY (N_IDENTIFICADOR);

ALTER TABLE ORDEN
	ADD CONSTRAINT PK_ORDEN PRIMARY KEY (O_NUMERO);
	
ALTER TABLE PIDE
	ADD CONSTRAINT PK_PIDE PRIMARY KEY (PI_NRO_PEDIDO);
	
ALTER TABLE PRIMA
	ADD CONSTRAINT PK_PRIMA PRIMARY KEY (PRI_MONTO);
	
ALTER TABLE PRODUCTO
	ADD CONSTRAINT PK_PRODUCTO PRIMARY KEY (PROD_IDENTIFICADOR);
	
ALTER TABLE PROVEEDOR
	ADD CONSTRAINT PK_PROVEEDOR PRIMARY KEY (PROV_RIF);
	
ALTER TABLE RECIBO
	ADD CONSTRAINT PK_RECIBO PRIMARY KEY (R_NUMERO_RECIBO);
	
ALTER TABLE SE_INCLUYE
	ADD CONSTRAINT PK_SE_INCLUYE PRIMARY KEY (S_I_ORDEN,S_I_PRODUCTO);
	
ALTER TABLE TELEFONO_EMPLEADO
	ADD CONSTRAINT PK_TELEFONO_EMPLEADO PRIMARY KEY (T_E_CEDULA, T_E_NUMERO);
	
ALTER TABLE USADO
	ADD CONSTRAINT PK_USADO PRIMARY KEY (U_IDENTIFICADOR);
	
ALTER TABLE VENDEDOR
	ADD CONSTRAINT PK_VENDEDOR PRIMARY KEY (VEN_CEDULA);
	
ALTER TABLE VENTA
	ADD CONSTRAINT PK_VENTA PRIMARY KEY (V_RECIBO);
	
	
 -----------------------------------------------------------------------------
 -----------------------------------------------------------------------------
 ------- Las siguientes son constraints de claves foráneas  ------------------
 -----------------------------------------------------------------------------
 -----------------------------------------------------------------------------
ALTER TABLE ADMINISTRATIVO
	 ADD CONSTRAINT FK_ADMINISTRATIVO_CEDULA FOREIGN KEY (A_CEDULA) REFERENCES EMPLEADO;
	 
ALTER TABLE ADMINISTRATIVO	
	 ADD CONSTRAINT FK_ADMINISTRATIVO_SUELDO FOREIGN KEY (A_SUELDO_BASE) REFERENCES CARGO;
	 

ALTER TABLE CAMBIO
	ADD CONSTRAINT FK_CAMBIO_RECIBO FOREIGN KEY (CAM_RECIBO) REFERENCES RECIBO;
	
ALTER TABLE CAMBIO
	ADD CONSTRAINT FK_CAMBIO_CLIENTE FOREIGN KEY (CAM_CLIENTE) REFERENCES CLIENTE;
	
ALTER TABLE CAMBIO
	ADD CONSTRAINT FK_CAMBIO_EJEMPLAR_CL FOREIGN KEY (CAM_EJEMPLAR_CLIENTE) REFERENCES EJEMPLAR_USADO;
	
ALTER TABLE CAMBIO
	ADD CONSTRAINT FK_CAMBIO_EJEMPLAR_TI FOREIGN KEY (CAM_EJEMPLAR_TIENDA) REFERENCES EJEMPLAR_USADO;
	
ALTER TABLE CAMBIO
	ADD CONSTRAINT FK_CAMBIO_VENDEDOR FOREIGN KEY (CAM_VENDEDOR) REFERENCES VENDEDOR;
	

ALTER TABLE COMPRA
	ADD CONSTRAINT FK_COMPRA_FACTURA FOREIGN KEY (COM_NRO_FACTURA,COM_RIF_TIENDA) REFERENCES FACTURA;

ALTER TABLE COMPRA
	ADD CONSTRAINT FK_COMPRA_CLIENTE FOREIGN KEY (COM_CLIENTE) REFERENCES CLIENTE;
	
ALTER TABLE COMPRA
	ADD CONSTRAINT FK_COMPRA_VENDEDOR FOREIGN KEY (COM_VENDEDOR) REFERENCES VENDEDOR;
	
ALTER TABLE COMPRA
	ADD CONSTRAINT FK_COMPRA_EJEMPLAR FOREIGN KEY (COM_EJEMPLAR) REFERENCES EJEMPLAR;
	
	
ALTER TABLE DEPENDIENTE
	ADD CONSTRAINT FK_DEPENDIENTE FOREIGN KEY (D_PRIMA) REFERENCES PRIMA;
	

ALTER TABLE EJEMPLAR_NUEVO
	ADD CONSTRAINT FK_EJEMPLAR_NUEVO_NUM_INV FOREIGN KEY (E_N_NUMERO_INVENTARIO) REFERENCES EJEMPLAR;
	
ALTER TABLE EJEMPLAR_NUEVO
	ADD CONSTRAINT FK_EJEMPLAR_NUEVO_INF_PROD FOREIGN KEY (E_N_INFORMACION_PRODUCTO) REFERENCES NUEVO;
	
	
ALTER TABLE EJEMPLAR_USADO
	ADD CONSTRAINT FK_EJEMPLAR_USADO_NUM_INV FOREIGN KEY (E_U_NUMERO_INVENTARIO) REFERENCES EJEMPLAR;
	
ALTER TABLE EJEMPLAR_USADO
	ADD CONSTRAINT FK_EJEMPLAR_USADO_INF_PROD FOREIGN KEY (E_U_INFORMACION_PRODUCTO) REFERENCES USADO;
	
	
ALTER TABLE ENTREGA
	ADD CONSTRAINT FK_ENTREGA_PROVEEDOR FOREIGN KEY (EN_PROVEEDOR) REFERENCES PROVEEDOR;

ALTER TABLE ENTREGA
	ADD CONSTRAINT FK_ENTREGA_PROD FOREIGN KEY (EN_PRODUCTO_NUEVO) REFERENCES NUEVO;
	
ALTER TABLE ENTREGA
	ADD CONSTRAINT FK_ENTREGA_FACTURA FOREIGN KEY (EN_FACTURA, EN_RIF_PROVEEDORA) REFERENCES FACTURA;
	
			
ALTER TABLE ES_FAMILIAR
	ADD CONSTRAINT FK_ES_FAMILIAR_EMP FOREIGN KEY (ES_F_EMPLEADO) REFERENCES EMPLEADO;
	
ALTER TABLE ES_FAMILIAR
	ADD CONSTRAINT FK_ES_FAMILIAR_DEP FOREIGN KEY (ES_F_DEPENDIENTE) REFERENCES DEPENDIENTE;
		
	
ALTER TABLE NUEVO
	ADD CONSTRAINT FK_NUEVO FOREIGN KEY (N_IDENTIFICADOR) REFERENCES PRODUCTO;
	

ALTER TABLE ORDEN
	ADD CONSTRAINT FK_ORDEN FOREIGN KEY (O_PROVEEDOR) REFERENCES PROVEEDOR;
	
	
ALTER TABLE PIDE
	ADD CONSTRAINT FK_PIDE_PROD FOREIGN KEY (PI_PRODUCTO) REFERENCES PRODUCTO;

ALTER TABLE PIDE
	ADD CONSTRAINT FK_PIDE_CLIENTE FOREIGN KEY (PI_CLIENTE) REFERENCES CLIENTE;
		
	
ALTER TABLE SE_INCLUYE
	ADD CONSTRAINT FK_SE_INCLUYE_ORDEN FOREIGN KEY (S_I_ORDEN) REFERENCES ORDEN;
	
	
ALTER TABLE SE_INCLUYE
	ADD CONSTRAINT FK_SE_INCLUYE_PROD FOREIGN KEY (S_I_PRODUCTO) REFERENCES PRODUCTO;
	
	
ALTER TABLE TELEFONO_EMPLEADO
	ADD CONSTRAINT FK_TELEFONO_EMPLEADO FOREIGN KEY (T_E_CEDULA) REFERENCES EMPLEADO;
	
	
ALTER TABLE USADO
	ADD CONSTRAINT FK_USADO FOREIGN KEY (U_IDENTIFICADOR) REFERENCES PRODUCTO;
	
	
ALTER TABLE VENDEDOR
	ADD CONSTRAINT FK_VENDEDOR_CED FOREIGN KEY (VEN_CEDULA) REFERENCES EMPLEADO;
	
ALTER TABLE VENDEDOR
	ADD CONSTRAINT FK_VENDEDOR_SUELDO FOREIGN KEY (VEN_SUELDO_BASE) REFERENCES CATEGORIA;
	
	
ALTER TABLE VENTA
	ADD CONSTRAINT FK_VENTA_RECIBO FOREIGN KEY (V_RECIBO) REFERENCES RECIBO;
 	
ALTER TABLE VENTA
	ADD CONSTRAINT FK_VENTA_CLIENTE FOREIGN KEY (V_CLIENTE) REFERENCES CLIENTE;
	
ALTER TABLE VENTA
	ADD CONSTRAINT FK_VENTA_VENDEDOR FOREIGN KEY (V_VENDEDOR) REFERENCES VENDEDOR;
	
ALTER TABLE VENTA
	ADD CONSTRAINT FK_VENTA_EJEMPLAR FOREIGN KEY (V_EJEMPLAR_USADO_VENTA) REFERENCES EJEMPLAR_USADO;
	
	
 -----------------------------------------------------------------------------
 -----------------------------------------------------------------------------
 ------- Las siguientes son constraints de dominio  ------------------
 -----------------------------------------------------------------------------
 -----------------------------------------------------------------------------
 ALTER TABLE ADMINISTRATIVO
	 ADD CONSTRAINT FK_ADMINISTRATIVO_CEDULA FOREIGN KEY (A_CEDULA) REFERENCES EMPLEADO;
	 
ALTER TABLE ADMINISTRATIVO	
	 ADD CONSTRAINT FK_ADMINISTRATIVO_SUELDO FOREIGN KEY (A_SUELDO_BASE) REFERENCES CARGO;
	 

ALTER TABLE CAMBIO
	ADD CONSTRAINT FK_CAMBIO_RECIBO FOREIGN KEY (CAM_RECIBO) REFERENCES RECIBO;
	
ALTER TABLE CAMBIO
	ADD CONSTRAINT FK_CAMBIO_CLIENTE FOREIGN KEY (CAM_CLIENTE) REFERENCES CLIENTE;
	
ALTER TABLE CAMBIO
	ADD CONSTRAINT FK_CAMBIO_EJEMPLAR_CL FOREIGN KEY (CAM_EJEMPLAR_CLIENTE) REFERENCES EJEMPLAR_USADO;
	
ALTER TABLE CAMBIO
	ADD CONSTRAINT FK_CAMBIO_EJEMPLAR_TI FOREIGN KEY (CAM_EJEMPLAR_TIENDA) REFERENCES EJEMPLAR_USADO;
	
ALTER TABLE CAMBIO
	ADD CONSTRAINT FK_CAMBIO_VENDEDOR FOREIGN KEY (CAM_VENDEDOR) REFERENCES VENDEDOR;
	

ALTER TABLE COMPRA
	ADD CONSTRAINT FK_COMPRA_FACTURA FOREIGN KEY (COM_NRO_FACTURA,COM_RIF_TIENDA) REFERENCES FACTURA;

ALTER TABLE COMPRA
	ADD CONSTRAINT FK_COMPRA_CLIENTE FOREIGN KEY (COM_CLIENTE) REFERENCES CLIENTE;
	
ALTER TABLE COMPRA
	ADD CONSTRAINT FK_COMPRA_VENDEDOR FOREIGN KEY (COM_VENDEDOR) REFERENCES VENDEDOR;
	
ALTER TABLE COMPRA
	ADD CONSTRAINT FK_COMPRA_EJEMPLAR FOREIGN KEY (COM_EJEMPLAR) REFERENCES EJEMPLAR;
	
	
ALTER TABLE DEPENDIENTE
	ADD CONSTRAINT FK_DEPENDIENTE FOREIGN KEY (D_PRIMA) REFERENCES PRIMA;
	

ALTER TABLE EJEMPLAR_NUEVO
	ADD CONSTRAINT FK_EJEMPLAR_NUEVO_NUM_INV FOREIGN KEY (E_N_NUMERO_INVENTARIO) REFERENCES EJEMPLAR;
	
ALTER TABLE EJEMPLAR_NUEVO
	ADD CONSTRAINT FK_EJEMPLAR_NUEVO_INF_PROD FOREIGN KEY (E_N_INFORMACION_PRODUCTO) REFERENCES NUEVO;
	
	
ALTER TABLE EJEMPLAR_USADO
	ADD CONSTRAINT FK_EJEMPLAR_USADO_NUM_INV FOREIGN KEY (E_U_NUMERO_INVENTARIO) REFERENCES EJEMPLAR;
	
ALTER TABLE EJEMPLAR_USADO
	ADD CONSTRAINT FK_EJEMPLAR_USADO_INF_PROD FOREIGN KEY (E_U_INFORMACION_PRODUCTO) REFERENCES USADO;
	
	
ALTER TABLE ENTREGA
	ADD CONSTRAINT FK_ENTREGA_PROVEEDOR FOREIGN KEY (EN_PROVEEDOR) REFERENCES PROVEEDOR;

ALTER TABLE ENTREGA
	ADD CONSTRAINT FK_ENTREGA_PROD FOREIGN KEY (EN_PRODUCTO_NUEVO) REFERENCES NUEVO;
	
ALTER TABLE ENTREGA
	ADD CONSTRAINT FK_ENTREGA_FACTURA FOREIGN KEY (EN_FACTURA, EN_RIF_PROVEEDORA) REFERENCES FACTURA;
	
			
ALTER TABLE ES_FAMILIAR
	ADD CONSTRAINT FK_ES_FAMILIAR_EMP FOREIGN KEY (ES_F_EMPLEADO) REFERENCES EMPLEADO;
	
ALTER TABLE ES_FAMILIAR
	ADD CONSTRAINT FK_ES_FAMILIAR_DEP FOREIGN KEY (ES_F_DEPENDIENTE) REFERENCES DEPENDIENTE;
		
	
ALTER TABLE NUEVO
	ADD CONSTRAINT FK_NUEVO FOREIGN KEY (N_IDENTIFICADOR) REFERENCES PRODUCTO;
	

ALTER TABLE ORDEN
	ADD CONSTRAINT FK_ORDEN FOREIGN KEY (O_PROVEEDOR) REFERENCES PROVEEDOR;
	
	
ALTER TABLE PIDE
	ADD CONSTRAINT FK_PIDE_PROD FOREIGN KEY (PI_PRODUCTO) REFERENCES PRODUCTO;

ALTER TABLE PIDE
	ADD CONSTRAINT FK_PIDE_CLIENTE FOREIGN KEY (PI_CLIENTE) REFERENCES CLIENTE;
		
	
ALTER TABLE SE_INCLUYE
	ADD CONSTRAINT FK_SE_INCLUYE_ORDEN FOREIGN KEY (S_I_ORDEN) REFERENCES ORDEN;
	
	
ALTER TABLE SE_INCLUYE
	ADD CONSTRAINT FK_SE_INCLUYE_PROD FOREIGN KEY (S_I_PRODUCTO) REFERENCES PRODUCTO;
	
	
ALTER TABLE TELEFONO_EMPLEADO
	ADD CONSTRAINT FK_TELEFONO_EMPLEADO FOREIGN KEY (T_E_CEDULA) REFERENCES EMPLEADO;
	
	
ALTER TABLE USADO
	ADD CONSTRAINT FK_USADO FOREIGN KEY (U_IDENTIFICADOR) REFERENCES PRODUCTO;
	
	
ALTER TABLE VENDEDOR
	ADD CONSTRAINT FK_VENDEDOR_CED FOREIGN KEY (VEN_CEDULA) REFERENCES EMPLEADO;
	
ALTER TABLE VENDEDOR
	ADD CONSTRAINT FK_VENDEDOR_SUELDO FOREIGN KEY (VEN_SUELDO_BASE) REFERENCES CATEGORIA;
	
	
ALTER TABLE VENTA
	ADD CONSTRAINT FK_VENTA_RECIBO FOREIGN KEY (V_RECIBO) REFERENCES RECIBO;
 	
ALTER TABLE VENTA
	ADD CONSTRAINT FK_VENTA_CLIENTE FOREIGN KEY (V_CLIENTE) REFERENCES CLIENTE;
	
ALTER TABLE VENTA
	ADD CONSTRAINT FK_VENTA_VENDEDOR FOREIGN KEY (V_VENDEDOR) REFERENCES VENDEDOR;
	
ALTER TABLE VENTA
	ADD CONSTRAINT FK_VENTA_EJEMPLAR FOREIGN KEY (V_EJEMPLAR_USADO_VENTA) REFERENCES EJEMPLAR_USADO;
