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
    PROCEDURE generar_solicitud (estado OUT CabeceraMensaje, infoSolicitud OUT Solicitud);

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
      BEGIN
          SELECT ROUND(DBMS_RANDOM.VALUE(10000000, 999999999)) numero
          INTO numero_aleatorio
          FROM DUAL;

          RETURN CONCAT(base_numero_solicitud, numero_aleatorio);
      END; -- generar_ramdon

    PROCEDURE generar_solicitud (estado OUT CabeceraMensaje, infoSolicitud OUT Solicitud) AS
        numero_solicitud VARCHAR2(256);
        ID_SOLICITUD T01_SOLICITUDES.CONS_SOLICITUD%TYPE;
      BEGIN
        numero_solicitud := generar_ramdon();

        INSERT INTO T01_SOLICITUDES (NUMERO_SOLICITUD) VALUES (numero_solicitud) RETURNING CONS_SOLICITUD INTO ID_SOLICITUD;

        COMMIT;

        infoSolicitud := Solicitud(ID_SOLICITUD, numero_solicitud);
        estado := CabeceraMensaje('OK', '000', 'Solicitud generada exitosamente');
        EXCEPTION
            WHEN OTHERS THEN
                 estado := CabeceraMensaje('ER', '111', CONCAT('Error generando la solicitud - ', SQLCODE || ' - ' || SQLERRM));
                 ROLLBACK;
      END; -- generar_solicitud

     PROCEDURE radicar_solicitud (radicar IN RadicarSolicitud, estado OUT CabeceraMensaje) AS
      BEGIN
          estado := CabeceraMensaje('OK', '000', 'La solicitud se ha radicado exitosamente');
      EXCEPTION
        WHEN OTHERS THEN
             estado := CabeceraMensaje('ER', '222', CONCAT('Error radicando la solicitud - ', SQLCODE || ' - ' || SQLERRM));
             ROLLBACK;
      END; -- radicar_solicitud

    PROCEDURE aprobacion_automatica (aprobacion IN AutoAprobacion, estado OUT CabeceraMensaje) AS
      BEGIN
          estado := CabeceraMensaje('OK', '000', 'Aprobacion automatixa generada exitosamente');
      EXCEPTION
        WHEN OTHERS THEN
             estado := CabeceraMensaje('ER', '222', CONCAT('Error en la aprobacion automatica - ', SQLCODE || ' - ' || SQLERRM));
             ROLLBACK;
      END; -- aprobacion_automatica

    PROCEDURE enviar_notificacion (notificacion IN Notificaciones, estado OUT CabeceraMensaje) AS
      BEGIN
           estado := CabeceraMensaje('OK', '000', 'Notificacion enviada exitosamente');
      EXCEPTION
        WHEN OTHERS THEN
             estado := CabeceraMensaje('ER', '333', CONCAT('Error enviando la notificacion - ', SQLCODE || ' - ' || SQLERRM));
             ROLLBACK;
      END; -- enviar_notificacion

END bpm_credit_process;
/