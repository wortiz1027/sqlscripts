/*
 ********************************************************
 *   AUTOR: WILMAN ORTIZ AVARRO
 *   FECHA: 17-SEPT-2018
 *   DESCRIPCION: PAQUETE QUE CONTIENE LAS FUNCIONES
 *   Y PROCEDIMIENTOS PARA REALIZAR LA GESTION DE UNA
 *   SOLICITUD...
 *********************************************************
 */
CREATE OR REPLACE PACKAGE bpm_credit_process AS

    -- DEFINICION DE CONSTATES
    base_numero_solicitud CONSTANT VARCHAR2(2) := '1-';

    -- FUNCION QUE GENERA EL NUMERO DE SOLICITUD
    FUNCTION generar_ramdon RETURN VARCHAR2;

    -- PROCEDIMIENTO QUE GUARDA EL NUMERO DE SOLICTUD
    PROCEDURE generar_solicitud (estado OUT CabeceraMensaje, solicitud OUT Solicitud);

    -- PROCEDIMIENTO PARA RADICAR SOLICITUD
    PROCEDURE radicar_solicitud (radicar IN RadicarSolicitud, estado OUT CabeceraMensaje);

    -- PROCEDIMIENTO PARA APROBACION AUTOMATICA
    PROCEDURE aprobacion_automatica (aprobacion IN AutoAprobacion, estado OUT CabeceraMensaje);

    -- PROCEDIMIENTO PARA ENVIAR NOTIFICACIONES
    PROCEDURE enviar_notificacion (notificacion IN Notificaciones, estado OUT CabeceraMensaje);

END bpm_credit_process;
/

CREATE OR REPLACE PACKAGE BODY bpm_credit_process AS

    FUNCTION generar_ramdon RETURN VARCHAR2 AS
        numero_aleatorio NUMBER;
        numero_solicitud VARCHAR2(256);
      BEGIN
          SELECT ROUND(DBMS_RANDOM.VALUE(10000000, 999999999)) numero
          INTO numero_aleatorio
          FROM DUAL;

          RETURN CONCAT(base_numero_solicitud, TO_CHAR(numero_aleatorio));
      END; -- generar_ramdon

    PROCEDURE generar_solicitud (estado OUT CabeceraMensaje, solicitud OUT Solicitud) AS
      BEGIN
        numeroSolicitud := generar_ramdon();

        INSERT INTO T01_SOLICITUDES (NUMERO_SOLICITUD) VALUES (numeroSolicitud);

        COMMIT;

        -- TODO Falta consecutivo generado
        solicitud := Solicitud(numeroSolicitud);
        estado := CabeceraMensaje('OK', '000', 'Solicitud generada exitosamente');
        EXCEPTION
            WHEN OTHERS THEN
                 estado := CabeceraMensaje('ER', '111', CONCAT('Error generando la solicitud - ', SQLCODE, ' - ', SQLERRM));
                 ROLLBACK;
      END; -- generar_solicitud

    PROCEDURE aprobacion_automatica (aprobacion IN AutoAprobacion, estado OUT CabeceraMensaje) AS
      BEGIN
      END; -- radicar_solicitud

    PROCEDURE enviar_notificacion (notificacion IN Notificaciones, estado OUT CabeceraMensaje) AS
      BEGIN
      END; -- radicar_solicitud

END bpm_credit_process;
/