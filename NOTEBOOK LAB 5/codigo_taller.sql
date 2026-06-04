-- POR SI HAY QUE HACER CORRECCIONES

DROP TABLE transacpagos CASCADE CONSTRAINTS;
DROP TABLE prestamo CASCADE CONSTRAINTS;
DROP TABLE telefono_cliente CASCADE CONSTRAINTS;
DROP TABLE email CASCADE CONSTRAINTS;
DROP TABLE cliente CASCADE CONSTRAINTS;
DROP TABLE tipo_prestamo CASCADE CONSTRAINTS;
DROP TABLE profesion CASCADE CONSTRAINTS; 
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
-- Envuelto en bloque para ignorar el error si la secuencia no existe aun
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_id_transaccion';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

CREATE SEQUENCE seq_id_profesion START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE seq_id_cliente START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE seq_id_email START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE seq_id_telefono START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE seq_id_prestamo START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE seq_id_tipo_prestamo START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE seq_id_transaccion START WITH 1 INCREMENT BY 1 NOCYCLE;

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

-- DEFAULT 0 agregado para evitar LOS NULL en prestamos insertados manulmente
ALTER TABLE prestamo
ADD saldoactual NUMBER(15,2) DEFAULT 0 NOT NULL
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

-- DESDE LA LINEA 548 HASTA LA 629 ESTA HECHO CON AYUDA DE IA 



/* Notas:
- DROP TABLE estan entre comentarios por si acaso cometen error de dise;o
- las inserciones se hacen despues de los drops para evitar errores de clave primaria o foranea
- en la parte de secuencias tambien existen drop para evitar errores de secuencia al insertar datos, 
    ya que si se insertan datos y luego se hace un drop de la secuencia, 
    al volver a crearla esta empezara desde 1 y puede generar conflictos con los id ya existentes en las tablas (me paso xd)
- Revisen el readme.md para ver lo que falta


*/


-- Funcion que calcula la edad del cliente a partir de su fecha de nacimiento
-- Es invocada desde el procedimiento de insercion de clientes
CREATE OR REPLACE FUNCTION fn_calcular_edad(
    p_fecha_nacimiento IN DATE
) RETURN NUMBER IS
    v_edad NUMBER;
BEGIN
    v_edad := FLOOR(MONTHS_BETWEEN(SYSDATE, p_fecha_nacimiento) / 12);
    RETURN v_edad;
END fn_calcular_edad;
/

-- Funcion que calcula el interes mensual de un prestamo
-- El interes es mensual: saldo_actual * (tasa_anual / 12 / 100)
-- Es invocada desde el procedimiento de aplicacion de pagos
CREATE OR REPLACE FUNCTION fn_calcular_interes(
    p_saldo_actual  IN NUMBER,
    p_tasa_interes  IN NUMBER
) RETURN NUMBER IS
    v_interes NUMBER;
BEGIN
    v_interes := p_saldo_actual * (p_tasa_interes / 12 / 100);
    RETURN v_interes;
END fn_calcular_interes;
/

/*
PROCEDIMIENTOS 
*/

-- Procedimiento para insertar profesiones
-- Si la profesion ya existe, no hace nada (evita duplicados por nombre_profesion UNIQUE)
CREATE OR REPLACE PROCEDURE sp_insertar_profesion(
    p_nombre_profesion IN profesion.nombre_profesion%TYPE
) IS
BEGIN
    INSERT INTO profesion (id_profesion, nombre_profesion)
    VALUES (seq_id_profesion.NEXTVAL, p_nombre_profesion);
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Profesion ya existe: ' || p_nombre_profesion);
END sp_insertar_profesion;
/

-- Procedimiento para insertar tipos de prestamo
CREATE OR REPLACE PROCEDURE sp_insertar_tipo_prestamo(
    p_nombre_tipo IN tipo_prestamo.nombre_tipo_prestamo%TYPE
) IS
BEGIN
    INSERT INTO tipo_prestamo (id_tipo_prestamo, nombre_tipo_prestamo)
    VALUES (seq_id_tipo_prestamo.NEXTVAL, p_nombre_tipo);
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Tipo de prestamo ya existe: ' || p_nombre_tipo);
END sp_insertar_tipo_prestamo;
/

-- Procedimiento para insertar sucursales
CREATE OR REPLACE PROCEDURE sp_insertar_sucursal(
    p_cod_sucursal    IN sucursal.cod_sucursal%TYPE,
    p_nombre_sucursal IN sucursal.nombre_sucursal%TYPE,
    p_tipo_prestamo   IN sucursal.tipo_prestamo%TYPE,
    p_monto_prestamos IN sucursal.monto_prestamos%TYPE DEFAULT 0
) IS
BEGIN
    INSERT INTO sucursal (cod_sucursal, nombre_sucursal, tipo_prestamo, monto_prestamos)
    VALUES (p_cod_sucursal, p_nombre_sucursal, p_tipo_prestamo, p_monto_prestamos);
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Sucursal ya existe: ' || p_cod_sucursal);
END sp_insertar_sucursal;
/


-- PROCEDIMIENTO INSET CLIENTE INVOKE FN_CALCULAR_EDAD

CREATE OR REPLACE PROCEDURE sp_insertar_cliente(
    p_cedula           IN cliente.cedula%TYPE,
    p_nombre           IN cliente.nombre%TYPE,
    p_apellido         IN cliente.apellido%TYPE,
    p_sexo             IN cliente.sexo%TYPE,
    p_fecha_nacimiento IN cliente.fecha_nacimiento%TYPE,
    p_nombre_profesion IN profesion.nombre_profesion%TYPE,
    p_cod_sucursal     IN cliente.cod_sucursal%TYPE
) IS
    v_id_profesion  profesion.id_profesion%TYPE;
    v_edad          NUMBER;
BEGIN
    -- Obtener el id de la profesion a partir del nombre
    SELECT id_profesion INTO v_id_profesion
    FROM profesion
    WHERE nombre_profesion = p_nombre_profesion;

    -- Calcular la edad usando la funcion
    v_edad := fn_calcular_edad(p_fecha_nacimiento);

    INSERT INTO cliente (
        id_cliente,
        cedula,
        nombre,
        apellido,
        sexo,
        fecha_nacimiento,
        id_profesion,
        edad,
        cod_sucursal
    )
    VALUES (
        seq_id_cliente.NEXTVAL,
        p_cedula,
        p_nombre,
        p_apellido,
        p_sexo,
        p_fecha_nacimiento,
        v_id_profesion,
        v_edad,
        p_cod_sucursal
    );
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Profesion no encontrada: ' || p_nombre_profesion);
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Cliente ya existe con cedula: ' || p_cedula);
END sp_insertar_cliente;
/



--  PROCEDIMIENTO DE INSERCION DE PRESTAMOS
-- Actualiza el monto_prestamos de la sucursal al insertar
-- saldoactual se inicializa igual al monto_aprobado

CREATE OR REPLACE PROCEDURE sp_insertar_prestamo(
    p_cedula_cliente       IN cliente.cedula%TYPE,
    p_nombre_tipo_prestamo IN tipo_prestamo.nombre_tipo_prestamo%TYPE,
    p_num_prestamo         IN prestamo.num_prestamo%TYPE,
    p_fecha_aprobacion     IN prestamo.fecha_aprobacion%TYPE,
    p_monto_aprobado       IN prestamo.monto_aprobado%TYPE,
    p_tasa_interes         IN prestamo.tasa_interes%TYPE,
    p_letra_mensual        IN prestamo.letra_mensual%TYPE,
    p_cod_sucursal         IN prestamo.cod_sucursal%TYPE
) IS
    v_id_cliente      cliente.id_cliente%TYPE;
    v_id_tipo_prestamo tipo_prestamo.id_tipo_prestamo%TYPE;
BEGIN
    -- Resolver id_cliente a partir de la cedula
    SELECT id_cliente INTO v_id_cliente
    FROM cliente
    WHERE cedula = p_cedula_cliente;

    -- Resolver id_tipo_prestamo a partir del nombre
    SELECT id_tipo_prestamo INTO v_id_tipo_prestamo
    FROM tipo_prestamo
    WHERE nombre_tipo_prestamo = p_nombre_tipo_prestamo;

    -- Insertar el prestamo; saldoactual = monto_aprobado, monto_pagado e interespagado inician en 0
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
        saldoactual,
        interespagado,
        cod_sucursal
    )
    VALUES (
        seq_id_prestamo.NEXTVAL,
        v_id_cliente,
        v_id_tipo_prestamo,
        p_num_prestamo,
        p_fecha_aprobacion,
        p_monto_aprobado,
        p_tasa_interes,
        p_letra_mensual,
        0,
        p_monto_aprobado,   -- saldo inicial = monto aprobado
        0,
        p_cod_sucursal
    );

    -- Actualizar el monto acumulado prestado en la sucursal
    UPDATE sucursal
    SET monto_prestamos = monto_prestamos + p_monto_aprobado
    WHERE cod_sucursal = p_cod_sucursal;

    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Cliente o tipo de prestamo no encontrado.');
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Numero de prestamo ya existe: ' || p_num_prestamo);
END sp_insertar_prestamo;
/


-- PROCEDIMIENTO DE INSERCION DE PAGOS (TRANSACPAGOS)
-- Registra el pago recibido en la tabla transaccional
-- No aplica el pago aun pq eso lo hace el cursor 

CREATE OR REPLACE PROCEDURE sp_insertar_pago(
    p_cod_sucursal      IN transacpagos.cod_sucursal%TYPE,
    p_cedula_cliente    IN cliente.cedula%TYPE,
    p_tipo_prestamo     IN transacpagos.tipo_prestamo%TYPE,
    p_fecha_transaccion IN transacpagos.fecha_transaccion%TYPE,
    p_monto_pago        IN transacpagos.monto_pago%TYPE,
    p_usuario           IN transacpagos.usuario%TYPE
) IS
    v_id_cliente cliente.id_cliente%TYPE;
BEGIN
    -- Resolver id_cliente a partir de la cedula
    SELECT id_cliente INTO v_id_cliente
    FROM cliente
    WHERE cedula = p_cedula_cliente;

    INSERT INTO transacpagos (
        cod_sucursal,
        id_transaccion,
        id_cliente,
        tipo_prestamo,
        fecha_transaccion,
        monto_pago,
        fecha_insercion,
        usuario
    )
    VALUES (
        p_cod_sucursal,
        seq_id_transaccion.NEXTVAL,
        v_id_cliente,
        p_tipo_prestamo,
        p_fecha_transaccion,
        p_monto_pago,
        SYSDATE,            -- fecha_insercion se captura automaticamente
        p_usuario
    );
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Cliente no encontrado con cedula: ' || p_cedula_cliente);
END sp_insertar_pago;
/



-- PROCEDIMIENTO CON CURSOR PARA APLICAR PAGOS
-- Recorre transacpagos uno a uno y aplica cada pago al prestamo:
--   1. Calcula el interes mensual con fn_calcular_interes
--   2. Cobra el interes primero del monto pagado
--   3. El remanente se rebaja del saldo del prestamo
--   4. Actualiza monto_prestamos en sucursal (rebaja el capital abonado)
--   5. Marca fechamodificacion y usuario en el prestamo

CREATE OR REPLACE PROCEDURE sp_aplicar_pagos IS

    -- Cursor que trae todos los pagos pendientes de aplicar
    -- Se consideran "pendientes" los que aun no tienen registro de modificacion en prestamo
    -- Para simplificar se procesan todos, en produccion se agregaria una columna "aplicado" en transacpagos
    CURSOR cur_pagos IS
        SELECT
            t.id_transaccion,
            t.id_cliente,
            t.tipo_prestamo,
            t.monto_pago,
            t.cod_sucursal,
            t.usuario
        FROM transacpagos t
        ORDER BY t.id_transaccion;

    -- Variables para el prestamo correspondiente al pago
    v_id_prestamo       prestamo.id_prestamo%TYPE;
    v_saldo_actual      prestamo.saldoactual%TYPE;
    v_tasa_interes      prestamo.tasa_interes%TYPE;
    v_id_tipo_prestamo  tipo_prestamo.id_tipo_prestamo%TYPE;

    -- Variables de calculo
    v_interes_mes       NUMBER;
    v_remanente         NUMBER;
    v_capital_abonado   NUMBER;

BEGIN
    FOR reg IN cur_pagos LOOP

        -- Buscar el prestamo activo del cliente para el tipo de prestamo del pago
        -- Se toma el prestamo con saldo mayor a 0 que coincida con tipo y cliente
        BEGIN
            SELECT
                p.id_prestamo,
                p.saldoactual,
                p.tasa_interes
            INTO
                v_id_prestamo,
                v_saldo_actual,
                v_tasa_interes
            FROM prestamo p
            INNER JOIN tipo_prestamo tp
                ON p.id_tipo_prestamo = tp.id_tipo_prestamo
            WHERE p.id_cliente        = reg.id_cliente
              AND tp.nombre_tipo_prestamo = reg.tipo_prestamo
              AND p.saldoactual        > 0
              AND ROWNUM               = 1;   -- si tiene mas de uno, toma el primero activo

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE(
                    'No se encontro prestamo activo para transaccion: ' || reg.id_transaccion
                );
                CONTINUE;   -- saltar al siguiente pago del cursor
        END;

        -- Calcular interes mensual usando la funcion
        v_interes_mes := fn_calcular_interes(v_saldo_actual, v_tasa_interes);

        -- El interes se cobra primero
        IF reg.monto_pago >= v_interes_mes THEN
            -- Queda remanente para abonar al capital
            v_remanente      := reg.monto_pago - v_interes_mes;
            v_capital_abonado := LEAST(v_remanente, v_saldo_actual); -- no puede rebajar mas del saldo
        ELSE
            -- El pago no alcanza ni para cubrir el interes; todo va a interes
            v_interes_mes    := reg.monto_pago;
            v_capital_abonado := 0;
        END IF;

        -- Actualizar el prestamo
        UPDATE prestamo
        SET
            saldoactual       = saldoactual - v_capital_abonado,
            monto_pagado      = monto_pagado + reg.monto_pago,
            interespagado     = interespagado + v_interes_mes,
            fecha_pago        = SYSDATE,
            fechamodificacion = SYSDATE,
            usuario           = reg.usuario
        WHERE id_prestamo = v_id_prestamo;

        -- Rebajar de monto_prestamos en sucursal solo el capital abonado
        -- (la sucursal lleva lo que la empresa tiene prestado, no los intereses)
        IF v_capital_abonado > 0 THEN
            UPDATE sucursal
            SET monto_prestamos = monto_prestamos - v_capital_abonado
            WHERE cod_sucursal = reg.cod_sucursal;
        END IF;

        DBMS_OUTPUT.PUT_LINE(
            'Transaccion ' || reg.id_transaccion ||
            ' aplicada. Interes: ' || v_interes_mes ||
            ' | Capital abonado: ' || v_capital_abonado
        );

    END LOOP;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error en sp_aplicar_pagos: ' || SQLERRM);
END sp_aplicar_pagos;
/


/* SECCION DE IA HASTA LA LINEA 1088 */
-- SECCION 7: EJEMPLOS DE INVOCACION (para la sustentacion)

-- Habilitar salida de DBMS_OUTPUT en SQL*Plus / SQL Developer
SET SERVEROUTPUT ON;

-- Insertar sucursales
BEGIN
    sp_insertar_sucursal('S1', 'Sucursal Central', 'Personal', 0);
    sp_insertar_sucursal('S2', 'Sucursal Norte',   'Auto',     0);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al insertar sucursales: ' || SQLERRM);
END;
/

-- Insertar clientes (invoca fn_calcular_edad internamente)
BEGIN
    sp_insertar_cliente(
        '8-1023-761', 'Gabriel', 'Gonzalez', 'M',
        TO_DATE('03/03/2005', 'DD/MM/YYYY'), 'Ingeniero de Software', 'S1'
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al insertar cliente: ' || SQLERRM);
END;
/

-- Insertar prestamo (actualiza monto en sucursal)
BEGIN
    sp_insertar_prestamo(
        '8-1023-761', 'Personal', 'PRE-0010',
        TO_DATE('01/06/2026', 'DD/MM/YYYY'), 5000, 7.5, 250, 'S1'
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al insertar prestamo: ' || SQLERRM);
END;
/

-- Registrar pagos en transacpagos (uno por tipo de prestamo)
BEGIN
    -- Pago de prestamo Personal
    sp_insertar_pago(
        'S1', '8-1023-761', 'Personal',
        TO_DATE('04/06/2026', 'DD/MM/YYYY'), 300, 'ADMIN'
    );
    -- Pago de prestamo Auto
    sp_insertar_pago(
        'S2', '8-1023-761', 'Auto',
        TO_DATE('04/06/2026', 'DD/MM/YYYY'), 500, 'ADMIN'
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al insertar pago: ' || SQLERRM);
END;
/

-- Aplicar todos los pagos pendientes con el cursor
BEGIN
    sp_aplicar_pagos;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al aplicar pagos: ' || SQLERRM);
END;
/


CREATE OR REPLACE VIEW vw_estado_prestamos_cliente AS
SELECT
    c.id_cliente,
    c.cedula,
    c.nombre || ' ' || c.apellido AS nombre_completo,
    c.sexo,
    c.edad,
    prf.nombre_profesion,
    s.cod_sucursal,
    s.nombre_sucursal,
    p.id_prestamo,
    p.num_prestamo,
    tp.nombre_tipo_prestamo,
    p.fecha_aprobacion,
    p.monto_aprobado,
    p.tasa_interes,
    p.letra_mensual,
    p.monto_pagado,
    p.interespagado,
    p.saldoactual,
    p.fecha_pago,
    p.fechamodificacion,
    p.usuario,
    CASE
        WHEN p.saldoactual = 0 THEN 'CANCELADO'
        WHEN p.monto_pagado = 0 THEN 'SIN PAGOS'
        ELSE 'ACTIVO'
    END AS estado_prestamo
FROM cliente c
INNER JOIN profesion prf
    ON c.id_profesion = prf.id_profesion
LEFT JOIN sucursal s
    ON c.cod_sucursal = s.cod_sucursal
INNER JOIN prestamo p
    ON c.id_cliente = p.id_cliente
INNER JOIN tipo_prestamo tp
    ON p.id_tipo_prestamo = tp.id_tipo_prestamo;
/

SELECT *
FROM vw_estado_prestamos_cliente
ORDER BY id_cliente, id_prestamo;