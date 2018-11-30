-- --------------------------------------
-- SYSTEM BUGS MANAGEMENT
-- AUTOR  : WILMAN ALBERTO ORTIZ NAVARRO
-- E-MAIL : WORTIZ@GMAIL.COM
-- FECHA  : 27-11-2018
-- --------------------------------------

-- --------------------------------------
-- ELIMINAR TABLAS
-- --------------------------------------
DROP TABLE GRUPO               CASCADE CONSTRAINTS;
DROP TABLE DESTINATARIO        CASCADE CONSTRAINTS;
DROP TABLE TIPO_NOTIFICACION   CASCADE CONSTRAINTS;
DROP TABLE PLANTILLA           CASCADE CONSTRAINTS;
DROP TABLE TIPO_EXCEPCION      CASCADE CONSTRAINTS;
DROP TABLE ORIGEN              CASCADE CONSTRAINTS;
DROP TABLE INFORMACION         CASCADE CONSTRAINTS;
DROP TABLE EXCEPCION           CASCADE CONSTRAINTS;
DROP TABLE DETALLE_EXCEPCION   CASCADE CONSTRAINTS;

-- --------------------------------------
-- ELIMINAR SECUENCIAS
-- --------------------------------------
DROP SEQUENCE SQ_GRUPO;
DROP SEQUENCE SQ_DESTINATARIO;
DROP SEQUENCE SQ_TIPO_NOTIFICACION;
DROP SEQUENCE SQ_PLANTILLA;
DROP SEQUENCE SQ_TIPO_EXCEPCION;
DROP SEQUENCE SQ_ORIGEN;
DROP SEQUENCE SQ_INFORMACION;
DROP SEQUENCE SQ_EXCEPCION;
DROP SEQUENCE SQ_DETALLE_EXCEPCION;

-- --------------------------------------
-- TABLAS PARAMETRICAS
-- --------------------------------------
CREATE TABLE GRUPO (
    ID_GRUPO    NUMBER NOT NULL,
    CODIGO      VARCHAR2(100) NOT NULL,
    DESCRIPCION VARCHAR2(512) NOT NULL
);

CREATE TABLE DESTINATARIO (
    ID_DESTINATARIO NUMBER NOT NULL,
    ID_GRUPO        NUMBER NOT NULL,
    EMAILS          VARCHAR2(512) NOT NULL    
);

CREATE TABLE TIPO_NOTIFICACION (
    ID_TIPO_NOTIFICACION NUMBER NOT NULL,
    CODIGO               VARCHAR2(100) NOT NULL,
    DESCRIPCION          VARCHAR2(512) NOT NULL    
);

CREATE TABLE PLANTILLA (
    ID_PLANTILLA NUMBER NOT NULL,
    CODIGO        VARCHAR2(100) NOT NULL,
    PLANTILLA     VARCHAR2(4000) NOT NULL
);

CREATE TABLE TIPO_EXCEPCION (
    ID_TIPO_EXCEPCION NUMBER NOT NULL,
    CODIGO            VARCHAR2(100) NOT NULL,
    DESCRIPCION       VARCHAR2(512) NOT NULL
);

CREATE TABLE ORIGEN (
    ID_ORIGEN   NUMBER NOT NULL,
    CODIGO      VARCHAR2(100) NOT NULL,
    DESCRIPCION VARCHAR2(100) NOT NULL
);

-- --------------------------------------
-- TABLAS DE NEGOCIO
-- --------------------------------------
CREATE TABLE INFORMACION (
    ID_INFORMACION NUMBER NOT NULL,
    CODIGO         VARCHAR2(100) NOT NULL,
    TIPO           VARCHAR2(100) NOT NULL,
    CLASE          VARCHAR2(256) NOT NULL,
    METODO         VARCHAR2(256) NOT NULL
);

CREATE TABLE EXCEPCION (
    ID_EXCEPCION NUMBER NOT NULL,    
    CODIGO       VARCHAR2(512)  NOT NULL,
    FECHA        VARCHAR2(512)  NOT NULL,
    CAUSA        VARCHAR2(100)  NOT NULL,
    CLASE        VARCHAR2(100)  NOT NULL,
    LOCALIZACION VARCHAR2(100)  NOT NULL,
    MENSAJE      VARCHAR2(2000) NOT NULL,
    TRAZA        VARCHAR2(4000) NOT NULL
);

CREATE TABLE DETALLE_EXCEPCION (
    ID_EXCEPCIONS        NUMBER NOT NULL,    
    ID_TIPO_EXCEPCION    NUMBER NOT NULL,
    ID_ORIGEN            NUMBER NOT NULL,
    ID_INFORMACION       NUMBER NOT NULL,
    ID_EXCEPCION         NUMBER NOT NULL,
    ID_TIPO_NOTIFICACION NUMBER NOT NULL,
    ID_DESTINATARIO      NUMBER NOT NULL,
    ID_PLANTILLA         NUMBER NOT NULL
);

-- --------------------------------------
-- CONSTRAINTS
-- --------------------------------------
-- PRIMARIES KEYS
ALTER TABLE GRUPO               ADD CONSTRAINT PK_GRUPO               PRIMARY KEY (ID_GRUPO);
ALTER TABLE DESTINATARIO        ADD CONSTRAINT PK_DESTINATARIO        PRIMARY KEY (ID_DESTINATARIO);
ALTER TABLE TIPO_NOTIFICACION   ADD CONSTRAINT PK_TIPO_NOTIFICACION   PRIMARY KEY (ID_TIPO_NOTIFICACION);
ALTER TABLE PLANTILLA           ADD CONSTRAINT PK_PLANTILLA           PRIMARY KEY (ID_PLANTILLA);
ALTER TABLE TIPO_EXCEPCION      ADD CONSTRAINT PK_TIPO_EXCEPCION      PRIMARY KEY (ID_TIPO_EXCEPCION);
ALTER TABLE ORIGEN              ADD CONSTRAINT PK_ORIGEN              PRIMARY KEY (ID_ORIGEN);
ALTER TABLE INFORMACION         ADD CONSTRAINT PK_INFORMACION         PRIMARY KEY (ID_INFORMACION);
ALTER TABLE EXCEPCION           ADD CONSTRAINT PK_EXCEPCION           PRIMARY KEY (ID_EXCEPCION);
ALTER TABLE DETALLE_EXCEPCION   ADD CONSTRAINT PK_DETALLE_EXCEPCION   PRIMARY KEY (ID_EXCEPCIONS, ID_TIPO_EXCEPCION, ID_ORIGEN, ID_INFORMACION, ID_EXCEPCION, ID_TIPO_NOTIFICACION, ID_DESTINATARIO);

-- FOREIGNS KEYS
ALTER TABLE DESTINATARIO      ADD CONSTRAINT FK_GRUPO          FOREIGN KEY (ID_GRUPO)          REFERENCES GRUPO (ID_GRUPO);

ALTER TABLE DETALLE_EXCEPCION ADD CONSTRAINT FK_TIPO_EXCEPCION    FOREIGN KEY (ID_TIPO_EXCEPCION)    REFERENCES TIPO_EXCEPCION (ID_TIPO_EXCEPCION);
ALTER TABLE DETALLE_EXCEPCION ADD CONSTRAINT FK_ORIGEN            FOREIGN KEY (ID_ORIGEN)            REFERENCES ORIGEN (ID_ORIGEN);
ALTER TABLE DETALLE_EXCEPCION ADD CONSTRAINT FK_INFORMACION       FOREIGN KEY (ID_INFORMACION)       REFERENCES INFORMACION (ID_INFORMACION);
ALTER TABLE DETALLE_EXCEPCION ADD CONSTRAINT FK_EXCEPCION         FOREIGN KEY (ID_EXCEPCION)         REFERENCES EXCEPCION (ID_EXCEPCION);
ALTER TABLE DETALLE_EXCEPCION ADD CONSTRAINT FK_DESTINATARIO      FOREIGN KEY (ID_DESTINATARIO)      REFERENCES DESTINATARIO (ID_DESTINATARIO);
ALTER TABLE DETALLE_EXCEPCION ADD CONSTRAINT FK_TIPO_NOTIFICACION FOREIGN KEY (ID_TIPO_NOTIFICACION) REFERENCES TIPO_NOTIFICACION (ID_TIPO_NOTIFICACION);
ALTER TABLE DETALLE_EXCEPCION ADD CONSTRAINT FK_ID_PLANTILLA      FOREIGN KEY (ID_PLANTILLA)         REFERENCES PLANTILLA (ID_PLANTILLA);
-- UNIQUES KEYS
ALTER TABLE PLANTILLA         ADD CONSTRAINT UK_PLANTILLA         UNIQUE (CODIGO);
ALTER TABLE ORIGEN            ADD CONSTRAINT UK_ORIGEN            UNIQUE (CODIGO);
ALTER TABLE TIPO_NOTIFICACION ADD CONSTRAINT UK_TIPO_NOTIFICACION UNIQUE (CODIGO);
ALTER TABLE TIPO_EXCEPCION    ADD CONSTRAINT UK_TIPO_EXCEPCION    UNIQUE (CODIGO);

-- INDICES
CREATE INDEX INX_BUG_FECHA  ON EXCEPCION(FECHA);
CREATE INDEX INX_BUG_CODIGO ON EXCEPCION(CODIGO);

-- --------------------------------------
-- SECUENCIAS
-- --------------------------------------
CREATE SEQUENCE SQ_GRUPO             INCREMENT BY 1 START WITH 1 MAXVALUE 999999999999999999999 MINVALUE 1;
CREATE SEQUENCE SQ_DESTINATARIO      INCREMENT BY 1 START WITH 1 MAXVALUE 999999999999999999999 MINVALUE 1;
CREATE SEQUENCE SQ_TIPO_NOTIFICACION INCREMENT BY 1 START WITH 1 MAXVALUE 999999999999999999999 MINVALUE 1;
CREATE SEQUENCE SQ_PLANTILLA         INCREMENT BY 1 START WITH 1 MAXVALUE 999999999999999999999 MINVALUE 1;
CREATE SEQUENCE SQ_TIPO_EXCEPCION    INCREMENT BY 1 START WITH 1 MAXVALUE 999999999999999999999 MINVALUE 1;
CREATE SEQUENCE SQ_ORIGEN            INCREMENT BY 1 START WITH 1 MAXVALUE 999999999999999999999 MINVALUE 1;
CREATE SEQUENCE SQ_INFORMACION       INCREMENT BY 1 START WITH 1 MAXVALUE 999999999999999999999 MINVALUE 1;
CREATE SEQUENCE SQ_EXCEPCION         INCREMENT BY 1 START WITH 1 MAXVALUE 999999999999999999999 MINVALUE 1;
CREATE SEQUENCE SQ_DETALLE_EXCEPCION INCREMENT BY 1 START WITH 1 MAXVALUE 999999999999999999999 MINVALUE 1;

-- --------------------------------------
-- TRIGGERS
-- --------------------------------------
CREATE OR REPLACE TRIGGER TRG_GRUPO BEFORE INSERT ON GRUPO
 FOR EACH ROW
 BEGIN
    IF (:NEW.ID_GRUPO IS NULL) THEN
        SELECT SQ_GRUPO.NEXTVAL INTO :NEW.ID_GRUPO
        FROM DUAL;
    END IF;
 END;
/

CREATE OR REPLACE TRIGGER TRG_DESTINATARIO BEFORE INSERT ON DESTINATARIO
 FOR EACH ROW
 BEGIN
    IF (:NEW.ID_DESTINATARIO IS NULL) THEN
        SELECT SQ_DESTINATARIO.NEXTVAL INTO :NEW.ID_DESTINATARIO
        FROM DUAL;
    END IF;
 END;
/

CREATE OR REPLACE TRIGGER TRG_TIPO_NOTIFICACION BEFORE INSERT ON TIPO_NOTIFICACION
 FOR EACH ROW
 BEGIN
    IF (:NEW.ID_TIPO_NOTIFICACION IS NULL) THEN
        SELECT SQ_TIPO_NOTIFICACION.NEXTVAL INTO :NEW.ID_TIPO_NOTIFICACION
        FROM DUAL;
    END IF;
 END;
/

CREATE OR REPLACE TRIGGER TRG_PLANTILLA BEFORE INSERT ON PLANTILLA
 FOR EACH ROW
 BEGIN
    IF (:NEW.ID_PLANTILLA IS NULL) THEN
        SELECT SQ_PLANTILLA.NEXTVAL INTO :NEW.ID_PLANTILLA
        FROM DUAL;
    END IF;
 END;
/

CREATE OR REPLACE TRIGGER TRG_TIPO_EXCEPCION BEFORE INSERT ON TIPO_EXCEPCION
 FOR EACH ROW
 BEGIN
    IF (:NEW.ID_TIPO_EXCEPCION IS NULL) THEN
        SELECT SQ_TIPO_EXCEPCION.NEXTVAL INTO :NEW.ID_TIPO_EXCEPCION
        FROM DUAL;
    END IF;
 END;
/

CREATE OR REPLACE TRIGGER TRG_ORIGEN BEFORE INSERT ON ORIGEN
 FOR EACH ROW
 BEGIN
    IF (:NEW.ID_ORIGEN IS NULL) THEN
        SELECT SQ_ORIGEN.NEXTVAL INTO :NEW.ID_ORIGEN
        FROM DUAL;
    END IF;
 END;
/

CREATE OR REPLACE TRIGGER TRG_INFORMACION BEFORE INSERT ON INFORMACION
 FOR EACH ROW
 BEGIN
    IF (:NEW.ID_INFORMACION IS NULL) THEN
        SELECT SQ_INFORMACION.NEXTVAL INTO :NEW.ID_INFORMACION
        FROM DUAL;
    END IF;
 END;
/

CREATE OR REPLACE TRIGGER TRG_EXCEPCION BEFORE INSERT ON EXCEPCION
 FOR EACH ROW
 BEGIN
    IF (:NEW.ID_EXCEPCION IS NULL) THEN
        SELECT SQ_EXCEPCION.NEXTVAL INTO :NEW.ID_EXCEPCION
        FROM DUAL;
    END IF;
 END;
/

CREATE OR REPLACE TRIGGER TRG_DETALLE_EXCEPCION BEFORE INSERT ON DETALLE_EXCEPCION
 FOR EACH ROW
 BEGIN
    IF (:NEW.ID_EXCEPCIONS IS NULL) THEN
        SELECT SQ_DETALLE_EXCEPCION.NEXTVAL INTO :NEW.ID_EXCEPCIONS
        FROM DUAL;
    END IF;
 END;
/

-- --------------------------------------
-- ENABLE TRIGGERS
-- --------------------------------------
ALTER TRIGGER TRG_GRUPO             ENABLE;
ALTER TRIGGER TRG_DESTINATARIO      ENABLE;
ALTER TRIGGER TRG_TIPO_NOTIFICACION ENABLE;
ALTER TRIGGER TRG_PLANTILLA         ENABLE;
ALTER TRIGGER TRG_TIPO_EXCEPCION    ENABLE;
ALTER TRIGGER TRG_ORIGEN            ENABLE;
ALTER TRIGGER TRG_INFORMACION       ENABLE;
ALTER TRIGGER TRG_EXCEPCION         ENABLE;
ALTER TRIGGER TRG_DETALLE_EXCEPCION ENABLE;

-- --------------------------------------
-- INSERTS PARAMETRICAS
-- --------------------------------------
INSERT INTO GRUPO (CODIGO, DESCRIPCION) VALUES ('DEV-1','WORTIZ@SOAINT.COM, JPERALTA@SOAINT.COM');
INSERT INTO GRUPO (CODIGO, DESCRIPCION) VALUES ('QA-1' ,'EFRANCO@SOAINT.COM, JTORRES@SOAINT.OM');
INSERT INTO GRUPO (CODIGO, DESCRIPCION) VALUES ('PRD-1','CGUZMAN@SOAINT.COM, DCHAVARRO@SOAINT.COM');

INSERT INTO DESTINATARIO (EMAILS, ID_GRUPO) VALUES ('WORTIZ@SOAINT.COM, JPERALTA@SOAINT.COM',1);
INSERT INTO DESTINATARIO (EMAILS, ID_GRUPO) VALUES ('EFRANCO@SOAINT.COM, JTORRES@SOAINT.OM',2);
INSERT INTO DESTINATARIO (EMAILS, ID_GRUPO) VALUES ('CGUZMAN@SOAINT.COM, DCHAVARRO@SOAINT.COM',3);

INSERT INTO TIPO_NOTIFICACION (CODIGO, DESCRIPCION) VALUES ('SMS', 'MENSAJE DE TEXTO');
INSERT INTO TIPO_NOTIFICACION (CODIGO, DESCRIPCION) VALUES ('EMAIL', 'CORREO ELECTRONICO');
INSERT INTO TIPO_NOTIFICACION (CODIGO, DESCRIPCION) VALUES ('SLACK', 'SLACK');

INSERT INTO TIPO_EXCEPCION (CODIGO, DESCRIPCION) VALUES ('NULL-01', 'NullPointerException');
INSERT INTO TIPO_EXCEPCION (CODIGO, DESCRIPCION) VALUES ('NUMBER-01', 'NumberFormatException');
INSERT INTO TIPO_EXCEPCION (CODIGO, DESCRIPCION) VALUES ('ARGUMENT-01', 'IllegalArgumentException');
INSERT INTO TIPO_EXCEPCION (CODIGO, DESCRIPCION) VALUES ('RUNTIME-01', 'RuntimeException');
INSERT INTO TIPO_EXCEPCION (CODIGO, DESCRIPCION) VALUES ('STATE-01', 'IllegalStateException');
INSERT INTO TIPO_EXCEPCION (CODIGO, DESCRIPCION) VALUES ('SUCHMETHOD-01', 'NoSuchMethodException');
INSERT INTO TIPO_EXCEPCION (CODIGO, DESCRIPCION) VALUES ('CLASSCAST-01', 'ClassCastException');
INSERT INTO TIPO_EXCEPCION (CODIGO, DESCRIPCION) VALUES ('EXCEPTION-01', 'Exception');
INSERT INTO TIPO_EXCEPCION (CODIGO, DESCRIPCION) VALUES ('PARSE-01', 'ParseException');
INSERT INTO TIPO_EXCEPCION (CODIGO, DESCRIPCION) VALUES ('INVOKE-01', 'InvocationTargetException');

INSERT INTO ORIGEN (CODIGO, DESCRIPCION) VALUES ('ARTF-01', 'ARTEFACTO');
INSERT INTO ORIGEN (CODIGO, DESCRIPCION) VALUES ('FRAG-01', 'FRAGMENTO');
INSERT INTO ORIGEN (CODIGO, DESCRIPCION) VALUES ('PAGE-01', 'PANTALLA');

INSERT INTO PLANTILLA (CODIGO, PLANTILLA) VALUES ('SMS-01', utl_raw.cast_to_raw('Excepcion: %s \n
                                                                                  Fecha: %s \n
                                                                                  Descripcion: %s'));
                                                                                  
INSERT INTO PLANTILLA (CODIGO, PLANTILLA) VALUES ('EMAIL-01', '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> ' ||
                                                    '<html xmlns="http://www.w3.org/1999/xhtml"> ' ||
                                                    '	<head> ' ||
                                                    '		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> ' ||
                                                    '		<title>System Bug Management</title> ' ||
                                                    '		<meta name="viewport" content="width=device-width, initial-scale=1.0"/>  ' ||
                                                    '	</head>	 ' ||
                                                    '	<body style="margin: 0; padding: 0;">  ' ||
                                                    '		<table border="0" cellpadding="0" cellspacing="0" width="100%"> ' ||
                                                    '			<tr> ' ||
                                                    '			 <td> ' ||
                                                    '				<table align="center" border="0" cellpadding="0" cellspacing="0" width="600" style="border-collapse: collapse;"> ' ||
                                                    '					<tr> ' ||
                                                    '						<td align="center" bgcolor="#70bbd9" style="padding: 30px 0 30px 0; color: white; font-family: Arial, sans-serif; font-size: 24px;"> ' ||
                                                    '							<img src="images/h1.gif" alt="System Bug Management" width="300" height="50" style="display: block;" /> ' ||
                                                    '						</td> ' ||
                                                    '					</tr> ' ||
                                                    '					<tr> ' ||
                                                    '						<td bgcolor="#ffffff" style="padding: 40px 30px 40px 30px;"> ' ||
                                                    '							<table border="0" cellpadding="0" cellspacing="0" width="100%"> ' ||
                                                    '								<tr> ' ||
                                                    '								 <td style="color: #153643; font-family: Arial, sans-serif; font-size: 24px;"> ' ||
                                                    '								  Titulo de la excepcion ' ||
                                                    '								 </td> ' ||
                                                    '								</tr> ' ||
                                                    '								<tr> ' ||
                                                    '								 <td style="padding: 20px 0 30px 0; font-family: Arial, sans-serif; font-size: 14px;"> ' ||
                                                    '								  leve descripcion de la excepcion ' ||
                                                    '								 </td> ' ||
                                                    '								</tr> ' ||
                                                    '								<tr> ' ||
                                                    '								 <td> ' ||
                                                    '								  <table border="0" cellpadding="0" cellspacing="0" width="100%" style="font-family: Arial, sans-serif; font-size: 14px;"> ' ||
                                                    '										<tr> ' ||
                                                    '											<td width="260"> ' ||
                                                    '												<table border="0" cellpadding="0" cellspacing="0" width="100%"> ' ||
                                                    '												  <tr> ' ||
                                                    '												   <td width="30%"  style="padding: 5px;"> ' ||
                                                    '													atributo 1: ' ||
                                                    '												   </td> ' ||
                                                    '												   <td style="padding: 5px;"> ' ||
                                                    '													descripcion atributo 1 ' ||
                                                    '												   </td> ' ||
                                                    '												  </tr>  ' ||
                                                    '												  <tr> ' ||
                                                    '												   <td width="30%"  style="padding: 5px;"> ' ||
                                                    '													atributo 2: ' ||
                                                    '												   </td> ' ||
                                                    '												   <td style="padding: 5px;"> ' ||
                                                    '													descripcion atributo 2 ' ||
                                                    '												   </td> ' ||
                                                    '												  </tr> ' ||
                                                    '												  <tr> ' ||
                                                    '												   <td width="30%"  style="padding: 5px;"> ' ||
                                                    '													atributo 3: ' ||
                                                    '												   </td> ' ||
                                                    '												   <td style="padding: 5px;"> ' ||
                                                    '													descripcion atributo 3 ' ||
                                                    '												   </td> ' ||
                                                    '												  </tr> ' ||
                                                    '												  <tr> ' ||
                                                    '												   <td width="30%"  style="padding: 5px;"> ' ||
                                                    '													atributo 4: ' ||
                                                    '												   </td> ' ||
                                                    '												   <td style="padding: 5px;"> ' ||
                                                    '													descripcion atributo 4 ' ||
                                                    '												   </td> ' ||
                                                    '												  </tr> ' ||
                                                    '												  <tr> ' ||
                                                    '												   <td style="padding: 5px;" colspan="2"> ' ||
                                                    '														atributo 5 ' ||
                                                    '												   </td> ' ||												   
                                                    '												  </tr> ' ||
                                                    '												  <tr> ' ||
                                                    '												   <td style="padding: 5px;" colspan="2"> ' ||
                                                    '														Traza de la excepcion ' ||
                                                    '												   </td> ' ||											   
                                                    '												  </tr> ' ||												  
                                                    '												</table> ' ||
                                                    '											</td> ' ||											
                                                    '										</tr> ' ||
                                                    '									</table> ' ||
                                                    '								 </td> ' ||
                                                    '								</tr> ' ||
                                                    '							</table> ' ||						 
                                                    '						</td> ' ||
                                                    '					</tr> ' ||
                                                    '					<tr> ' ||
                                                    '						<td bgcolor="#ee4c50" align="center" style="color: white; font-family: Arial, sans-serif; font-size: 24px; padding: 20px 0 20px 0;"> ' ||
                                                    '							Soaint Software ' ||
                                                    '						</td> ' ||
                                                    '					</tr> ' ||
                                                    '				</table> ' ||
                                                    '			 </td> ' ||
                                                    '			</tr> ' ||
                                                    '		</table>' ||
                                                    '	</body> ' ||
                                                    '</html> ');

INSERT INTO PLANTILLA (CODIGO, PLANTILLA) VALUES ('SLACK-01', '{ ' ||
                                                               '    "text": "Ligera descripcion de la excepcion", ' ||
                                                               '    "username": "GESTION DE BUGS", ' ||
                                                               '    "mrkdwn": true, ' ||
                                                               '	 "icon_url": "http://icons.iconarchive.com/icons/diversity-avatars/avatars/256/robot-01-icon.png", ' ||
                                                               '    "attachments": [ ' ||
                                                               '        { ' ||
                                                               '            "fallback": "Required plain-text summary of the attachment.", ' ||
                                                               '            "color": "#930000", ' ||
                                                               '            "pretext": "Informacion del origen", ' ||
                                                               '            "author_name": "Bugs Bot", ' ||
                                                               '            "author_link": "http://localhost:8888", ' ||
                                                               '            "author_icon": "http://icons.iconarchive.com/icons/diversity-avatars/avatars/256/robot-01-icon.png", ' ||
                                                               '            "title": "Slack API Documentation", ' ||
                                                               '            "title_link": "http://localhost:8888", ' ||
                                                               '            "text": "Detalle de la excepcion", ' ||
                                                               '            "fields": [ ' ||
                                                               '                { ' ||
                                                               '                    "title": "Priority", ' ||
                                                               '                    "value": "High", ' ||
                                                               '                    "short": false ' ||
                                                               '                } ' ||
                                                               '            ], ' ||
                                                               '            "image_url": "http://icons.iconarchive.com/icons/diversity-avatars/avatars/256/robot-01-icon.png", ' ||
                                                               '            "thumb_url": "http://icons.iconarchive.com/icons/diversity-avatars/avatars/256/robot-01-icon.png", ' ||
                                                               '            "footer": "System Management Bug API", ' ||
                                                               '            "footer_icon": "https://platform.slack-edge.com/img/default_application_icon.png", ' ||
                                                               '            "ts": 123456789 ' ||
                                                               '        } ' ||
                                                               '    ] ' ||
                                                               '} ');

COMMIT;