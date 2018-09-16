-- SCHEMA CREDIT
-- AUTOR: WILMAN ORTIZ
-- FECHA: 15 SEPTIEMBRE 2018

-- ELIMINAR TABLAS
DROP TABLE T01_SOLICITUDES       CASCADE CONSTRAINTS;
DROP TABLE T02_CLIENTES          CASCADE CONSTRAINTS;
DROP TABLE T03_INFO_SOLICITUD    CASCADE CONSTRAINTS;
DROP TABLE T04_NOTIFICACIONES    CASCADE CONSTRAINTS;
DROP TABLE T05_TIPO_DOCUMENTO    CASCADE CONSTRAINTS;
DROP TABLE T06_TIPO_NOTIFICACION CASCADE CONSTRAINTS;

-- ELIMINAR SECUENCIAS
DROP SEQUENCE SQ_SOLICITUDES;
DROP SEQUENCE SQ_CLIENTES;
DROP SEQUENCE SQ_INFO_SOLICITUD;
DROP SEQUENCE SQ_NOTIFICACIONES;
DROP SEQUENCE SQ_TIPO_DOCUMENTO;
DROP SEQUENCE SQ_TIPO_SOLICITUD;

-- CREANDO TABLAS
CREATE TABLE T01_SOLICITUDES (
       CONS_SOLICITUD   NUMBER  NOT NULL,
       NUMERO_SOLICITUD VARCHAR2(256) NOT NULL
);

CREATE TABLE T02_CLIENTES (
       CONS_CLIENTE   NUMBER NOT NULL,
       NUM_DOCUMENTO  NUMBER NOT NULL,
       NOMBRES        VARCHAR2(100),
       APELLIDOS      VARCHAR2(100),
       DIRECCION      VARCHAR2(512),
       TELEFONO       NUMBER,
       EMAIL          VARCHAR2(256),
       TIPO_DOCUMENTO NUMBER
);

CREATE TABLE T03_INFO_SOLICITUD (
       CONS_INFO_SOLICITUD NUMBER NOT NULL,
       CONS_SOLICITUD      NUMBER NOT NULL,
       CONS_CLIENTE        NUMBER NOT NULL,
       VALOR_SOLICITUD     NUMBER NOT NULL,
       SOLICITUD_APROBADA  VARCHAR2(2) NOT NULL,
       MOTIVO              VARCHAR2(512)
);

CREATE TABLE T04_NOTIFICACIONES (
       CONS_NOTIFICACIONES NUMBER NOT NULL,
       CONS_SOLICITUD NUMBER NOT NULL,
       CONS_TIPO_NOTIFICACION NUMBER NOT NULL,
       PLANTILLA_NOTIVICACION VARCHAR2(2000)
);

CREATE TABLE T05_TIPO_DOCUMENTO (
       CONS_TIPO_DOCUMENTO NUMBER NOT NULL,
       DESC_TIPO_DOCUMENTO VARCHAR2(512)
);

CREATE TABLE T06_TIPO_NOTIFICACION (
       CONS_TIPO_NOTIFICACION NUMBER NOT NULL,
       DESC_TIPO_NOTIFICACION VARCHAR2(512)
);

-- APLICANDO CONSTRAINT
ALTER TABLE T01_SOLICITUDES       ADD CONSTRAINT PK_SOLICITUD         PRIMARY KEY (CONS_SOLICITUD);
ALTER TABLE T02_CLIENTES          ADD CONSTRAINT PK_CLIENTE           PRIMARY KEY (CONS_CLIENTE);
ALTER TABLE T03_INFO_SOLICITUD    ADD CONSTRAINT PK_INFO_SOLICITUD    PRIMARY KEY (CONS_INFO_SOLICITUD, CONS_SOLICITUD, CONS_CLIENTE);
ALTER TABLE T04_NOTIFICACIONES    ADD CONSTRAINT PK_NOTIFICACIONES    PRIMARY KEY (CONS_NOTIFICACIONES);
ALTER TABLE T05_TIPO_DOCUMENTO    ADD CONSTRAINT PK_TIPO_DOCUMENTO    PRIMARY KEY (CONS_TIPO_DOCUMENTO);
ALTER TABLE T06_TIPO_NOTIFICACION ADD CONSTRAINT PK_TIPO_NOTIFICACION PRIMARY KEY (CONS_TIPO_NOTIFICACION);

ALTER TABLE T01_SOLICITUDES ADD CONSTRAINT UK_NUMERO_SOLICITUD UNIQUE (NUMERO_SOLICITUD);
ALTER TABLE T02_CLIENTES    ADD CONSTRAINT UK_NUMERO_DOCUMENTO UNIQUE (NUM_DOCUMENTO);

ALTER TABLE T02_CLIENTES       ADD CONSTRAINT FK_TIPO_DOCUMENTO    FOREIGN KEY (TIPO_DOCUMENTO)         REFERENCES T05_TIPO_DOCUMENTO (CONS_TIPO_DOCUMENTO);
ALTER TABLE T04_NOTIFICACIONES ADD CONSTRAINT FK_TIPO_NOTIFICACION FOREIGN KEY (CONS_TIPO_NOTIFICACION) REFERENCES T06_TIPO_NOTIFICACION (CONS_TIPO_NOTIFICACION);
ALTER TABLE T04_NOTIFICACIONES ADD CONSTRAINT FK_SOLICITUD         FOREIGN KEY (CONS_SOLICITUD)         REFERENCES T01_SOLICITUDES (CONS_SOLICITUD);
ALTER TABLE T03_INFO_SOLICITUD ADD CONSTRAINT FK_NUMERO_SOLICITUD  FOREIGN KEY (CONS_SOLICITUD)         REFERENCES T01_SOLICITUDES (CONS_SOLICITUD);
ALTER TABLE T03_INFO_SOLICITUD ADD CONSTRAINT FK_CLIENTE           FOREIGN KEY (CONS_CLIENTE)           REFERENCES T02_CLIENTES (CONS_CLIENTE);

-- CREANDO SECUENCIAS
CREATE SEQUENCE SQ_SOLICITUDES    INCREMENT BY 1 START WITH 1 MAXVALUE 999999999999999999999 MINVALUE 1;
CREATE SEQUENCE SQ_CLIENTES       INCREMENT BY 1 START WITH 1 MAXVALUE 999999999999999999999 MINVALUE 1;
CREATE SEQUENCE SQ_INFO_SOLICITUD INCREMENT BY 1 START WITH 1 MAXVALUE 999999999999999999999 MINVALUE 1;
CREATE SEQUENCE SQ_NOTIFICACIONES INCREMENT BY 1 START WITH 1 MAXVALUE 999999999999999999999 MINVALUE 1;
CREATE SEQUENCE SQ_TIPO_DOCUMENTO INCREMENT BY 1 START WITH 1 MAXVALUE 999999999999999999999 MINVALUE 1;
CREATE SEQUENCE SQ_TIPO_SOLICITUD INCREMENT BY 1 START WITH 1 MAXVALUE 999999999999999999999 MINVALUE 1;

-- CREANDO TRIGGERS
CREATE OR REPLACE TRIGGER TRG_SOLICITUDES BEFORE INSERT ON T01_SOLICITUDES
 FOR EACH ROW
 BEGIN
    IF (:NEW.CONS_SOLICITUD IS NULL) THEN
        SELECT SQ_SOLICITUDES.NEXTVAL INTO :NEW.CONS_SOLICITUD
        FROM DUAL;
    END IF;
 END;
/

CREATE OR REPLACE TRIGGER TRG_CLIENTES BEFORE INSERT ON T02_CLIENTES
 FOR EACH ROW
 BEGIN
    IF (:NEW.CONS_CLIENTE IS NULL) THEN
        SELECT SQ_CLIENTES.NEXTVAL INTO :NEW.CONS_CLIENTE
        FROM DUAL;
    END IF;
 END;
/

CREATE OR REPLACE TRIGGER TRG_INFO_SOLICITUD BEFORE INSERT ON T03_INFO_SOLICITUD
 FOR EACH ROW
 BEGIN
    IF (:NEW.CONS_INFO_SOLICITUD IS NULL) THEN
        SELECT SQ_INFO_SOLICITUD.NEXTVAL INTO :NEW.CONS_INFO_SOLICITUD
        FROM DUAL;
    END IF;
 END;
/

CREATE OR REPLACE TRIGGER TRG_NOTIFICACIONES BEFORE INSERT ON T04_NOTIFICACIONES
 FOR EACH ROW
 BEGIN
    IF (:NEW.CONS_NOTIFICACIONES IS NULL) THEN
        SELECT SQ_NOTIFICACIONES.NEXTVAL INTO :NEW.CONS_NOTIFICACIONES
        FROM DUAL;
    END IF;
 END;
/

CREATE OR REPLACE TRIGGER TRG_TIPO_DOCUMENTO BEFORE INSERT ON T05_TIPO_DOCUMENTO
 FOR EACH ROW
 BEGIN
    IF (:NEW.CONS_TIPO_DOCUMENTO IS NULL) THEN
        SELECT SQ_TIPO_DOCUMENTO.NEXTVAL INTO :NEW.CONS_TIPO_DOCUMENTO
        FROM DUAL;
    END IF;
 END;
/

CREATE OR REPLACE TRIGGER TRG_TIPO_NOTIFICACION BEFORE INSERT ON T06_TIPO_NOTIFICACION
 FOR EACH ROW
 BEGIN
    IF (:NEW.CONS_TIPO_NOTIFICACION IS NULL) THEN
        SELECT SQ_TIPO_SOLICITUD.NEXTVAL INTO :NEW.CONS_TIPO_NOTIFICACION
        FROM DUAL;
    END IF;
 END;
/

-- HABILITANDO TRIGGERS
ALTER TRIGGER TRG_SOLICITUDES       ENABLE;
ALTER TRIGGER TRG_CLIENTES          ENABLE;
ALTER TRIGGER TRG_INFO_SOLICITUD    ENABLE;
ALTER TRIGGER TRG_NOTIFICACIONES    ENABLE;
ALTER TRIGGER TRG_TIPO_DOCUMENTO    ENABLE;
ALTER TRIGGER TRG_TIPO_NOTIFICACION ENABLE;

-- INSERTS TABLAS PARAMETRICAS
INSERT INTO T05_TIPO_DOCUMENTO (DESC_TIPO_DOCUMENTO) VALUES ('TARJETA DE IDENTIDAD');
INSERT INTO T05_TIPO_DOCUMENTO (DESC_TIPO_DOCUMENTO) VALUES ('CEDULA');
INSERT INTO T05_TIPO_DOCUMENTO (DESC_TIPO_DOCUMENTO) VALUES ('CEDULA EXTRANJERIA');
INSERT INTO T05_TIPO_DOCUMENTO (DESC_TIPO_DOCUMENTO) VALUES ('PASAPORTE');
INSERT INTO T05_TIPO_DOCUMENTO (DESC_TIPO_DOCUMENTO) VALUES ('REGISTRO CIVIL');

INSERT INTO T06_TIPO_NOTIFICACION (DESC_TIPO_NOTIFICACION) VALUES ('E-MAIL');
INSERT INTO T06_TIPO_NOTIFICACION (DESC_TIPO_NOTIFICACION) VALUES ('TELEFONO');
INSERT INTO T06_TIPO_NOTIFICACION (DESC_TIPO_NOTIFICACION) VALUES ('SMS');
INSERT INTO T06_TIPO_NOTIFICACION (DESC_TIPO_NOTIFICACION) VALUES ('CHAT');