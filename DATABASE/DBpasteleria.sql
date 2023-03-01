USE master
GO

IF DB_ID ('PASTELERIA') IS NOT NULL
	DROP DATABASE PASTELERIA
GO

CREATE DATABASE PASTELERIA
GO

USE PASTELERIA
GO

CREATE TABLE PERSONAS
(
	idpersona		INT IDENTITY(1,1) PRIMARY KEY,
	apellidos		VARCHAR(40)		NOT NULL,
	nombres			VARCHAR(40)		NOT NULL,
	dni				CHAR(8)			NOT NULL,
	direccion		VARCHAR(100)	NULL,
	telefono		CHAR(9)			NULL,
	email			VARCHAR(100)	NULL,
	CONSTRAINT uk_dni_per UNIQUE (dni),
	CONSTRAINT ck_dni_per CHECK (dni LIKE('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')),
	CONSTRAINT ck_telefono_per CHECK (telefono LIKE('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
)
GO

CREATE TABLE EMPRESAS
(
	idempresa			INT IDENTITY(1,1) PRIMARY KEY,
	razonSocial			VARCHAR(80)		NOT NULL,
	ruc					CHAR(11)		NOT NULL,
	direccion			VARCHAR(100)	NULL,
	telefono			CHAR(9)			NULL,
	email				VARCHAR(100)	NULL,
	CONSTRAINT uk_ruc_emp UNIQUE (ruc),
	CONSTRAINT ck_telefono_emp CHECK (telefono LIKE('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')),
	CONSTRAINT ck_ruc_emp CHECK (ruc LIKE ('[1-2][0,5-7][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
)
GO

CREATE TABLE ROLES
(
	idrol			INT IDENTITY(1,1) PRIMARY KEY,
	rol					VARCHAR(20)		NOT NULL,
	CONSTRAINT uk_rol UNIQUE (rol)
)
GO

CREATE TABLE USUARIOS
(
	idusuario			INT IDENTITY(1,1) PRIMARY KEY,
	idpersona			INT				NOT NULL,
	idrol				INT				NOT NULL,
	nombreusuario		VARCHAR(30) 	NOT NULL,
	claveacceso			VARCHAR(200) 	NOT NULL,
	fechaalta			DATE			NOT NULL DEFAULT GETDATE(),
	fechabaja			DATE			NULL,
	estado				BIT				NOT NULL DEFAULT 1,
	CONSTRAINT fk_idpersona_usu FOREIGN KEY (idpersona) REFERENCES PERSONAS(idpersona),
	CONSTRAINT fk_idrol_usu FOREIGN KEY (idrol) REFERENCES ROLES(idrol),
	CONSTRAINT uk_nombreusu_usu UNIQUE (nombreusuario)
)
GO

------------------

CREATE TABLE CATEGORIAS 
(
	idcategoria			INT IDENTITY(1,1) PRIMARY KEY,
	categoria			VARCHAR(50) 	NOT NULL,
	CONSTRAINT uk_categoria_cat UNIQUE(categoria)
)
GO

CREATE TABLE PRODUCTOS
(	
	idproducto			INT IDENTITY(1,1) PRIMARY KEY,
	idcategoria			INT 			NOT NULL,
	nombreproducto		VARCHAR(40) 	NOT NULL,
	descripcion			VARCHAR(100) 	NULL,
	fechaelaboracion	DATETIME 		NOT NULL DEFAULT GETDATE(),
	precio				DECIMAL(7,2) 	NOT NULL,
	stock				TINYINT 		NOT NULL,
	estado				BIT 			NOT NULL DEFAULT 1,
	CONSTRAINT fk_idcategoria_pro FOREIGN KEY (idcategoria) REFERENCES categorias (idcategoria),
	CONSTRAINT ck_precio_pro CHECK (precio > 0),
)
GO

CREATE TABLE TIPO_PAGOS
(
	idtipopago			INT IDENTITY(1,1) PRIMARY KEY,
	tipopago			VARCHAR(30) 	NOT NULL,
	CONSTRAINT uk_tipopago_tip UNIQUE(tipopago)
)
GO

CREATE TABLE VENTAS
(
	idventa				INT IDENTITY(1,1) PRIMARY KEY,
	idusuario			INT 			NOT NULL,
	idpersona			INT 			NULL,
	idempresa			INT 			NULL,
	idtipopago			INT			 	NOT NULL,
	tipodocumento 		CHAR(1)	 		NOT NULL, -- B = Boleta F = Factura
	nrodocumento		CHAR(10) 		NOT NULL,
	fechaventa			DATETIME 		NOT NULL DEFAULT GETDATE(),
	estado				BIT 			NOT NULL DEFAULT 1,
	CONSTRAINT fk_idusuario_ven FOREIGN KEY (idusuario) REFERENCES usuarios (idusuario),
	CONSTRAINT fk_idpersona_ven FOREIGN KEY (idpersona) REFERENCES personas (idpersona),
	CONSTRAINT fk_idempresa_ven FOREIGN KEY (idempresa) REFERENCES empresas (idempresa),
	CONSTRAINT fk_idpago_ven FOREIGN KEY (idtipopago) REFERENCES tipo_pagos (idtipopago),
	CONSTRAINT ck_tipdoc_ven CHECK (tipodocumento IN('B', 'F')),
	CONSTRAINT ck_numdoc_ven CHECK (nrodocumento LIKE('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
)
GO

CREATE TABLE DETALLE_VENTAS
(
	iddetventa			INT IDENTITY(1,1) PRIMARY KEY,
	idventa				INT				NOT NULL,
	idproducto			INT 			NOT NULL,
	cantidad			TINYINT 		NOT NULL,
	precioventa			DECIMAL(7,2) 	NOT NULL,
	CONSTRAINT fk_idventa_det FOREIGN KEY (idventa) REFERENCES ventas (idventa),
	CONSTRAINT fk_idproducto_det FOREIGN KEY (idproducto) REFERENCES productos (idproducto),
	CONSTRAINT ck_precio_det CHECK (precioventa >= 0),
)
GO

-- INYECCIONES A LAS TABLAS

-- PERSONAS
INSERT INTO PERSONAS (apellidos, nombres, dni, direccion, telefono, email) VALUES
	('Tasayco Pachas', 'Patricia', '76364011','av rosales 258', '990004142', 'tasaycopatricia@gmail.com'),
	('Atuncar Gutierrez', 'Carlos', '76364012',null, null, 'agcarlos@gmail.com'),
	('Neyra Luna', 'Liliana', '76364013','calle lima 520', '990004143', 'lilineyra12@gmail.com'),
	('Felipa Pachas', 'Andrew', '76364014',null, '990004144', null),
	('Abregu Sotelo', 'Yuli', '76364015','pasaje santa rita 140', null, 'yulisotelo@gmail.com')
GO

-- EMPRESAS
INSERT INTO EMPRESAS(razonSocial, ruc, direccion, telefono, email) VALUES
	('AGROLIGHT PERU S.A.C.','20552103816',  NULL, '999999999', 'AGROLIGHT@GMAIL.COM'),
	('AGROSORIA E.I.R.L','20538856674',  NULL, '999999999', 'AGROSORIA@GMAIL.COM'),
	( 'AGRINOVA DEL PERU S.R.L','20553856451', NULL, '999999999', 'AGRINOVA@GMAIL.COM'),
	('BI GRAND CONFECCIONES S.A.C.', '20480316259', NULL, '999999999', 'BIGRANDCONFECCIONES@GMAIL.COM')
GO

-- ROLES
INSERT INTO ROLES(rol) VALUES
	('Administrador'),
	('Empleado')
GO

-- USUARIOS
INSERT INTO USUARIOS (idpersona, idrol, nombreusuario, claveacceso) VALUES
	(1,2,'PATRICIA', '123456'),
	(3,1,'LILIANA', '123456')
GO

-- CATEGORIAS
INSERT INTO CATEGORIAS (categoria) VALUES
	('Postres'),
	('Pasteles'),
	('Bizcochos'),
	('Galletas'),
	('Vegetarianos')
GO
INSERT INTO CATEGORIAS (categoria) VALUES
	('Bocaditos')
GO

-- PRODUCTOS
INSERT INTO PRODUCTOS (idcategoria, nombreproducto, descripcion, precio, stock) VALUES
	(2, 'Mini Torta', 'Chocolate, cremam volteada', 45.0, 6),
	(3, 'Queque', NULL, 2.0, 12),
	(4, 'ChocoChip', 'Chocolate con pecas', 1.5, 20),
	(1, 'Arroz con leche', NULL, 5.0, 20),
	(1, 'Gelatina', 'Con flan', 2.0, 15)
GO
INSERT INTO PRODUCTOS (idcategoria, nombreproducto, descripcion, precio, stock) VALUES
	(1, 'brownie', 'porcion bañado en chocolate con pecanas', 3.5, 9),
	(1, 'pye de manzana', 'Porción', 3.50, 12),
	(1, 'chessecake', 'Porcion sabor a maracuya', 6.50, 15),
	(1, 'torta de galleta', 'Porcion, sabor chocolate y vainilla', 3.50, 20),
	(1, 'Torta de chocolate', 'Porcion, Rellena y bañada con fudge', 6, 12),
	(2, 'Torta tres leches', 'torta de 1/2 kg',65.00 , 4),
	(2, 'Torta de chocolate', 'torta de 1/2 kg', 68.00, 4),
	(2, 'Torta selva negra', 'Torta de 1/2 kg', 58, 4),
	(2, 'carrot cake', 'Torta de 1/2 kg', 58, 12),
	(2, 'Pye de manzana', 'Tamaño mediano', 6, 12),
	(6, 'Pitipanes', '25 unidades',23, 2),
	(6, 'cocadas', '25 unidades', 18, 3),
	(6, 'piernitas y alitas', '25 unidades', 35, 3),
	(6, 'empanadas de pollo', '25 unidades', 22, 5)
GO

-- TIPO_PAGOS
INSERT INTO TIPO_PAGOS (tipopago) VALUES
	('Yape'),
	('Efectivo'),
	('Tarjeta'),
	('Plim')
GO

-- VENTAS
INSERT INTO VENTAS (idusuario, idpersona, idempresa, idtipopago, tipodocumento, nrodocumento) VALUES
	(2, 1, NULL, 1, 'B', '0000000001'),
	(1, NULL, 1, 2, 'B', '0000000002'),
	(1, 4, NULL, 4, 'F', '0000000003'),
	(1, 3, NULL, 4, 'B', '0000000004'),
	(1, 2, NULL, 1, 'B', '0000000005')
GO

-- DETALLE_VENTAS
INSERT INTO DETALLE_VENTAS (idventa, idproducto, cantidad, precioventa) VALUES
	(1, 2, 3, 1.5),
	(1, 3, 5, 20.0),
	(1, 1, 6, 45.0),
	(1, 3, 8, 1.5),
	(1, 4, 2, 5.0),
	(2, 2, 4, 2.0),
	(2, 3, 1, 1.5),
	(2, 4, 1, 5.0),
	(2, 5, 10, 2.0),
	(2, 1, 1, 45.5),
	(2, 2, 1, 1.0),
	(3, 5, 1, 2.0),
	(3, 4, 10, 5.0),
	(3, 1, 1, 45.5),
	(3, 1, 1, 45.5),
	(3, 2, 6, 2.0),
	(3, 2, 2, 2.0),
	(4, 3, 6, 1.5),
	(4, 2, 7, 2.0),
	(4, 5, 4, 2.0),
	(4, 1, 1, 45.5),
	(4, 2, 10, 2.0),
	(4, 2, 10, 2.0),
	(4, 1, 1, 45.5),
	(4, 1, 1, 45.5),
	(5, 5, 11, 2.0),
	(5, 4, 20, 5.0),
	(5, 3, 6, 1.5),
	(5, 1, 2, 45.5),
	(5, 2, 2, 2.0),
	(5, 5, 4, 2.0)
GO

SELECT * FROM PRODUCTOS;