-- POR SI HAY QUE HACER CORRECCIONES

DROP TABLE prestamo CASCADE CONSTRAINTS;
DROP TABLE telefono_cliente CASCADE CONSTRAINTS;
DROP TABLE email CASCADE CONSTRAINTS;
DROP TABLE cliente CASCADE CONSTRAINTS;
DROP TABLE tipo_prestamo CASCADE CONSTRAINTS;
DROP TABLE profesion CASCADE CONSTRAINTS; 
DROP TABLE transacpagos CASCADE CONSTRAINTS;
DROP TABLE sucursal CASCADE CONSTRAINTS;

-- La creacion de la tabla profesion se hace antes que cliente por la dependencia de la clave foranea
CREATE TABLE profesion (
    id_profesion NUMBER PRIMARY KEY,
    nombre_profesion VARCHAR2(50) NOT NULL UNIQUE
);
--   tipo_prestamo se hace antes que prestamo por la misma razon
CREATE TABLE tipo_prestamo (
    id_tipo_prestamo NUMBER PRIMARY KEY,
    nombre_tipo_prestamo VARCHAR2(50) NOT NULL UNIQUE
);

CREATE TABLE cliente (
    id_cliente NUMBER PRIMARY KEY,
    cedula VARCHAR2(25) NOT NULL UNIQUE,
    nombre VARCHAR2(50) NOT NULL,
    apellido VARCHAR2(50) NOT NULL,
    sexo VARCHAR2(2) NOT NULL CHECK (sexo IN ('M', 'F')),
    fecha_nacimiento DATE NOT NULL,
    id_profesion NUMBER NOT NULL,
    CONSTRAINT fk_profesion FOREIGN KEY (id_profesion)
        REFERENCES profesion(id_profesion)
);

CREATE TABLE email (
    id_email NUMBER PRIMARY KEY,
    email VARCHAR2(100) NOT NULL UNIQUE,
    tipo_email VARCHAR2(20) NOT NULL CHECK (tipo_email IN ('Personal', 'Trabajo', 'Academico')),
    id_cliente NUMBER NOT NULL,
    CONSTRAINT fk_cliente_email FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente)
);

CREATE TABLE telefono_cliente (
    id_telefono NUMBER PRIMARY KEY,
    numero_telefono VARCHAR2(20) NOT NULL UNIQUE,
    tipo_telefono VARCHAR2(20) NOT NULL 
        CHECK (tipo_telefono IN ('Personal', 'Residencial', 'Conyugal', 'Familiar')),
    id_cliente NUMBER NOT NULL,
    FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente)
);

CREATE TABLE prestamo (
    id_prestamo NUMBER PRIMARY KEY,
    id_cliente NUMBER NOT NULL,
    id_tipo_prestamo NUMBER NOT NULL,
    num_prestamo VARCHAR2(20) NOT NULL UNIQUE,
    fecha_aprobacion DATE NOT NULL,
    monto_aprobado NUMBER NOT NULL
        CHECK (monto_aprobado > 0),
    tasa_interes NUMBER NOT NULL
        CHECK (tasa_interes >= 0 AND tasa_interes <= 100),
    letra_mensual NUMBER NOT NULL
        CHECK (letra_mensual > 0),
    monto_pagado NUMBER NOT NULL,
    fecha_pago DATE,

    CONSTRAINT fk_cliente_prestamo FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente),
    CONSTRAINT fk_tipo_prestamo FOREIGN KEY (id_tipo_prestamo)
        REFERENCES tipo_prestamo(id_tipo_prestamo) 
);

/*
CREATE SEQUENCE seq_id_profesion START WITH 1 INCREMENT BY 1 NOCYCLE; --TABLA PROFESION
CREATE SEQUENCE seq_id_cliente START WITH 1 INCREMENT BY 1 NOCYCLE; --TABLA CLIENTE
CREATE SEQUENCE seq_id_email START WITH 1 INCREMENT BY 1 NOCYCLE; --TABLA EMAIL
CREATE SEQUENCE seq_id_telefono START WITH 1 INCREMENT BY 1 NOCYCLE; --TABLA TELEFONO
CREATE SEQUENCE seq_id_prestamo START WITH 1 INCREMENT BY 1 NOCYCLE; --TABLA PRESTAMO
CREATE SEQUENCE seq_id_tipo_prestamo START WITH 1 INCREMENT BY 1 NOCYCLE; --TABLA TIPO_PRESTAMO
*/

-- DELETE INSERTS

DELETE FROM prestamo;
DELETE FROM telefono_cliente;
DELETE FROM email;
DELETE FROM cliente;
DELETE FROM tipo_prestamo;
DELETE FROM profesion;
-- aqui metan los delete from para las tablas nuevas

-- DROP SECUENCES
DROP SEQUENCE seq_id_profesion;
DROP SEQUENCE seq_id_cliente;
DROP SEQUENCE seq_id_email;
DROP SEQUENCE seq_id_telefono;
DROP SEQUENCE seq_id_prestamo;
DROP SEQUENCE seq_id_tipo_prestamo;
DROP SEQUENCE seq_id_transaccion; -- SECUENCIA PARA TRANSACCIONES DE PAGO

CREATE SEQUENCE seq_id_profesion START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE seq_id_cliente START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE seq_id_email START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE seq_id_telefono START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE seq_id_prestamo START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE seq_id_tipo_prestamo START WITH 1 INCREMENT BY 1 NOCYCLE;

COMMIT;

-- INSERCIONES PROFESION

INSERT INTO profesion (id_profesion, nombre_profesion)
VALUES (seq_id_profesion.NEXTVAL, 'Ingeniero de Software');

INSERT INTO profesion (id_profesion, nombre_profesion)
VALUES (seq_id_profesion.NEXTVAL, 'Contador');

INSERT INTO profesion (id_profesion, nombre_profesion)
VALUES (seq_id_profesion.NEXTVAL, 'Administrador');

INSERT INTO profesion (id_profesion, nombre_profesion)
VALUES (seq_id_profesion.NEXTVAL, 'Abogado');

INSERT INTO profesion (id_profesion, nombre_profesion)
VALUES (seq_id_profesion.NEXTVAL, 'Docente');

-- INSERCIONES TIPO_PRESTAMO


INSERT INTO tipo_prestamo (id_tipo_prestamo, nombre_tipo_prestamo)
VALUES (seq_id_tipo_prestamo.NEXTVAL, 'Personal');

INSERT INTO tipo_prestamo (id_tipo_prestamo, nombre_tipo_prestamo)
VALUES (seq_id_tipo_prestamo.NEXTVAL, 'Auto');

INSERT INTO tipo_prestamo (id_tipo_prestamo, nombre_tipo_prestamo)
VALUES (seq_id_tipo_prestamo.NEXTVAL, 'Hipoteca');

INSERT INTO tipo_prestamo (id_tipo_prestamo, nombre_tipo_prestamo)
VALUES (seq_id_tipo_prestamo.NEXTVAL, 'Garantizado con ahorros');

-- INSERCIONES CLIENTE

INSERT INTO cliente (
    id_cliente, cedula, nombre, apellido, sexo, fecha_nacimiento, id_profesion
)
VALUES (
    seq_id_cliente.NEXTVAL,
    '8-1023-761',
    'Gabriel',
    'Gonzalez',
    'M',
    TO_DATE('03/03/2005', 'DD/MM/YYYY'),
    (
        SELECT id_profesion
        FROM profesion
        WHERE nombre_profesion = 'Ingeniero de Software'
    )
);

INSERT INTO cliente (
    id_cliente, cedula, nombre, apellido, sexo, fecha_nacimiento, id_profesion
)
VALUES (
    seq_id_cliente.NEXTVAL,
    'E-8-199982',
    'Yongsheng',
    'Du',
    'M',
    TO_DATE('02/02/2005', 'DD/MM/YYYY'),
    (
        SELECT id_profesion
        FROM profesion
        WHERE nombre_profesion = 'Ingeniero de Software'
    )
);

INSERT INTO cliente (
    id_cliente, cedula, nombre, apellido, sexo, fecha_nacimiento, id_profesion
)
VALUES (
    seq_id_cliente.NEXTVAL,
    '8-1030-1204',
    'Kevin',
    'Pan',
    'M',
    TO_DATE('10/04/2005', 'DD/MM/YYYY'),
    (
        SELECT id_profesion
        FROM profesion
        WHERE nombre_profesion = 'Contador'
    )
);

INSERT INTO cliente (
    id_cliente, cedula, nombre, apellido, sexo, fecha_nacimiento, id_profesion
)
VALUES (
    seq_id_cliente.NEXTVAL,
    '3-754-534',
    'David',
    'Qiu',
    'M',
    TO_DATE('15/06/2004', 'DD/MM/YYYY'),
    (
        SELECT id_profesion
        FROM profesion
        WHERE nombre_profesion = 'Administrador'
    )
);

INSERT INTO cliente (
    id_cliente, cedula, nombre, apellido, sexo, fecha_nacimiento, id_profesion
)
VALUES (
    seq_id_cliente.NEXTVAL,
    'E-8-220963',
    'Jenifer',
    'Albornoz',
    'F',
    TO_DATE('20/08/2005', 'DD/MM/YYYY'),
    (
        SELECT id_profesion
        FROM profesion
        WHERE nombre_profesion = 'Docente'
    )
);

COMMIT;

-- INSERCIONES EMAIL

INSERT INTO email (
    id_email, email, tipo_email, id_cliente
)
VALUES (
    seq_id_email.NEXTVAL, 'gabriel.personal@gmail.com', 'Personal', 1
);

INSERT INTO email (
    id_email, email, tipo_email, id_cliente
)
VALUES (
    seq_id_email.NEXTVAL, 'gabriel@utp.ac.pa', 'Academico', 1
);

INSERT INTO email (
    id_email, email, tipo_email, id_cliente
)
VALUES (
    seq_id_email.NEXTVAL, 'yongsheng.personal@gmail.com', 'Personal', 2
);

INSERT INTO email (
    id_email, email, tipo_email, id_cliente
)
VALUES (
    seq_id_email.NEXTVAL, 'kevin.trabajo@empresa.com', 'Trabajo', 3
);

INSERT INTO email (
    id_email, email, tipo_email, id_cliente
)
VALUES (
    seq_id_email.NEXTVAL, 'david@utp.ac.pa', 'Academico', 4
);

INSERT INTO email (
    id_email, email, tipo_email, id_cliente
)
VALUES (
    seq_id_email.NEXTVAL, 'jenifer.personal@gmail.com', 'Personal', 5
);

-- INSERCIONES TELEFONO_CLIENTE

INSERT INTO telefono_cliente (
    id_telefono, numero_telefono, tipo_telefono, id_cliente
)
VALUES (
    seq_id_telefono.NEXTVAL, '6000-1111', 'Personal', 1
);

INSERT INTO telefono_cliente (
    id_telefono, numero_telefono, tipo_telefono, id_cliente
)
VALUES (
    seq_id_telefono.NEXTVAL, '230-1111', 'Residencial', 1
);

INSERT INTO telefono_cliente (
    id_telefono, numero_telefono, tipo_telefono, id_cliente
)
VALUES (
    seq_id_telefono.NEXTVAL, '6000-2222', 'Personal', 2
);

INSERT INTO telefono_cliente (
    id_telefono, numero_telefono, tipo_telefono, id_cliente
)
VALUES (
    seq_id_telefono.NEXTVAL, '6000-3333', 'Familiar', 3
);

INSERT INTO telefono_cliente (
    id_telefono, numero_telefono, tipo_telefono, id_cliente
)
VALUES (
    seq_id_telefono.NEXTVAL, '6000-4444', 'Conyugal', 4
);

INSERT INTO telefono_cliente (
    id_telefono, numero_telefono, tipo_telefono, id_cliente
)
VALUES (
    seq_id_telefono.NEXTVAL, '6000-5555', 'Personal', 5
);

-- INSERCIONES PRESTAMO 

INSERT INTO prestamo (
    id_prestamo,
    id_cliente,
    id_tipo_prestamo,
    num_prestamo,
    fecha_aprobacion,
    monto_aprobado,
    tasa_interes,
    letra_mensual,
    monto_pagado,
    fecha_pago
)
VALUES (
    seq_id_prestamo.NEXTVAL,
    (
        SELECT id_cliente
        FROM cliente
        WHERE cedula = '8-1023-761'
    ),
    (
        SELECT id_tipo_prestamo
        FROM tipo_prestamo
        WHERE nombre_tipo_prestamo = 'Personal'
    ),
    'PRE-0001',
    TO_DATE('10/05/2026', 'DD/MM/YYYY'),
    5000.00,
    7.50,
    250.00,
    500.00,
    TO_DATE('20/05/2026', 'DD/MM/YYYY')
);

INSERT INTO prestamo (
    id_prestamo,
    id_cliente,
    id_tipo_prestamo,
    num_prestamo,
    fecha_aprobacion,
    monto_aprobado,
    tasa_interes,
    letra_mensual,
    monto_pagado,
    fecha_pago
)
VALUES (
    seq_id_prestamo.NEXTVAL,
    (
        SELECT id_cliente
        FROM cliente
        WHERE cedula = '8-1023-761'
    ),
    (
        SELECT id_tipo_prestamo
        FROM tipo_prestamo
        WHERE nombre_tipo_prestamo = 'Auto'
    ),
    'PRE-0002',
    TO_DATE('12/05/2026', 'DD/MM/YYYY'),
    12000.00,
    8.25,
    450.00,
    0.00,
    NULL
);

INSERT INTO prestamo (
    id_prestamo,
    id_cliente,
    id_tipo_prestamo,
    num_prestamo,
    fecha_aprobacion,
    monto_aprobado,
    tasa_interes,
    letra_mensual,
    monto_pagado,
    fecha_pago
)
VALUES (
    seq_id_prestamo.NEXTVAL,
    (
        SELECT id_cliente
        FROM cliente
        WHERE cedula = 'E-8-199982'
    ),
    (
        SELECT id_tipo_prestamo
        FROM tipo_prestamo
        WHERE nombre_tipo_prestamo = 'Garantizado con ahorros'
    ),
    'PRE-0003',
    TO_DATE('15/05/2026', 'DD/MM/YYYY'),
    3000.00,
    5.75,
    180.00,
    180.00,
    TO_DATE('25/05/2026', 'DD/MM/YYYY')
);

INSERT INTO prestamo (
    id_prestamo,
    id_cliente,
    id_tipo_prestamo,
    num_prestamo,
    fecha_aprobacion,
    monto_aprobado,
    tasa_interes,
    letra_mensual,
    monto_pagado,
    fecha_pago
)
VALUES (
    seq_id_prestamo.NEXTVAL,
    (
        SELECT id_cliente
        FROM cliente
        WHERE cedula = '8-1030-1204'
    ),
    (
        SELECT id_tipo_prestamo
        FROM tipo_prestamo
        WHERE nombre_tipo_prestamo = 'Hipoteca'
    ),
    'PRE-0004',
    TO_DATE('18/05/2026', 'DD/MM/YYYY'),
    85000.00,
    6.50,
    950.00,
    950.00,
    TO_DATE('28/05/2026', 'DD/MM/YYYY')
);

INSERT INTO prestamo (
    id_prestamo,
    id_cliente,
    id_tipo_prestamo,
    num_prestamo,
    fecha_aprobacion,
    monto_aprobado,
    tasa_interes,
    letra_mensual,
    monto_pagado,
    fecha_pago
)
VALUES (
    seq_id_prestamo.NEXTVAL,
    (
        SELECT id_cliente
        FROM cliente
        WHERE cedula = '3-754-534'
    ),
    (
        SELECT id_tipo_prestamo
        FROM tipo_prestamo
        WHERE nombre_tipo_prestamo = 'Personal'
    ),
    'PRE-0005',
    TO_DATE('20/05/2026', 'DD/MM/YYYY'),
    2500.00,
    9.00,
    150.00,
    0.00,
    NULL
);

INSERT INTO prestamo (
    id_prestamo,
    id_cliente,
    id_tipo_prestamo,
    num_prestamo,
    fecha_aprobacion,
    monto_aprobado,
    tasa_interes,
    letra_mensual,
    monto_pagado,
    fecha_pago
)
VALUES (
    seq_id_prestamo.NEXTVAL,
    (
        SELECT id_cliente
        FROM cliente
        WHERE cedula = 'E-8-220963'
    ),
    (
        SELECT id_tipo_prestamo
        FROM tipo_prestamo
        WHERE nombre_tipo_prestamo = 'Auto'
    ),
    'PRE-0006',
    TO_DATE('22/05/2026', 'DD/MM/YYYY'),
    10000.00,
    8.00,
    400.00,
    400.00,
    TO_DATE('30/05/2026', 'DD/MM/YYYY')
);

COMMIT;


SELECT 
    pr.id_prestamo,
    c.cedula,
    c.nombre,
    c.apellido,
    tp.nombre_tipo_prestamo,
    pr.num_prestamo,
    pr.fecha_aprobacion,
    pr.monto_aprobado,
    pr.tasa_interes,
    pr.letra_mensual,
    pr.monto_pagado,
    pr.fecha_pago
FROM prestamo pr
INNER JOIN cliente c
    ON pr.id_cliente = c.id_cliente
INNER JOIN tipo_prestamo tp
    ON pr.id_tipo_prestamo = tp.id_tipo_prestamo
ORDER BY pr.id_prestamo;


-- EDICIONES CORRECCIONES 
-- EDICIONES CORRECCIONES 
-- EDICIONES CORRECCIONES 
-- EDICIONES CORRECCIONES 

-- DESDE LA LINEA 548 HASTA LA 643 ESTA HECHO CON AYUDA DE IA 

-- AGREGAR EDAD A CLIENTE
ALTER TABLE cliente
    ADD edad NUMBER;

/* funcion para calcular la edad a partir de la fecha de nacimiento y la fecha actual 
UPDATE cliente
SET edad = FLOOR(MONTHS_BETWEEN(SYSDATE, fecha_nacimiento) / 12);
*/ 


/* Agregar una tabla al modelo fisico que almacene las sucursales de la 
empresa la financiera con las restricciones correspondientes */

-- 2. Crear tabla de sucursales
-- CREAR TABLA SUCURSAL SEGUN EL ENUNCIADO
CREATE TABLE sucursal (
    cod_sucursal VARCHAR2(2) PRIMARY KEY,
    nombre_sucursal VARCHAR2(50) NOT NULL UNIQUE,
    tipo_prestamo VARCHAR2(50) NOT NULL,
    monto_prestamos NUMBER(15,2) DEFAULT 0 NOT NULL
        CHECK (monto_prestamos >= 0)
);


-- AGREGAR CODIGO DE SUCURSAL A CLIENTE
ALTER TABLE cliente
ADD cod_sucursal VARCHAR2(2);

ALTER TABLE cliente
ADD CONSTRAINT fk_cliente_sucursal FOREIGN KEY (cod_sucursal)
    REFERENCES sucursal(cod_sucursal);

-- AGREGAR CODIGO DE SUCURSAL A PRESTAMO
ALTER TABLE prestamo
ADD cod_sucursal VARCHAR2(2);

ALTER TABLE prestamo
ADD CONSTRAINT fk_prestamo_sucursal FOREIGN KEY (cod_sucursal)
    REFERENCES sucursal(cod_sucursal);

    ALTER TABLE prestamo
ADD saldoactual NUMBER(15,2)
    CHECK (saldoactual >= 0);

ALTER TABLE prestamo
ADD interespagado NUMBER(15,2) DEFAULT 0 NOT NULL
    CHECK (interespagado >= 0);

ALTER TABLE prestamo
    ADD fechamodificacion DATE;

ALTER TABLE prestamo
    ADD usuario VARCHAR2(50);


CREATE TABLE transacpagos (
    cod_sucursal VARCHAR2(2) NOT NULL,
    id_transaccion NUMBER PRIMARY KEY,
    id_cliente NUMBER NOT NULL,
    tipo_prestamo VARCHAR2(50) NOT NULL,
    fecha_transaccion DATE NOT NULL,
    monto_pago NUMBER(15,2) NOT NULL
        CHECK (monto_pago > 0),
    fecha_insercion DATE DEFAULT SYSDATE NOT NULL,
    usuario VARCHAR2(50) NOT NULL,

    CONSTRAINT fk_transac_sucursal FOREIGN KEY (cod_sucursal)
        REFERENCES sucursal(cod_sucursal),

    CONSTRAINT fk_transac_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente)
);

-- SECUENCIA PARA TRANSACCIONES DE PAGO
CREATE SEQUENCE seq_id_transaccion
START WITH 1
INCREMENT BY 1
NOCYCLE;


-- DESDE LA LINEA 548 HASTA LA 643 ESTA HECHO CON AYUDA DE IA 



/* Notas:
- DROP TABLE estan entre comentarios por si acaso cometen error de dise;o
- las inserciones se hacen despues de los drops para evitar errores de clave primaria o foranea
- en la parte de secuencias tambien existen drop para evitar errores de secuencia al insertar datos, 
    ya que si se insertan datos y luego se hace un drop de la secuencia, 
    al volver a crearla esta empezara desde 1 y puede generar conflictos con los id ya existentes en las tablas (me paso xd)




*/