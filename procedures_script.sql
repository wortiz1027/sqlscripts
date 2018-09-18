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
    PROCEDURE generar_solicitud (numSolicitud OUT numero_solicitud);

    -- PROCEDIMIENTO PARA RADICAR SOLICITUD
    PROCEDURE radicar_solicitud;

    -- PROCEDIMIENTO PARA APROBACION AUTOMATICA
    PROCEDURE aprobar_solicitud;

    -- PROCEDIMIENTO PARA ENVIAR NOTIFICACIONES
    PROCEDURE enviar_notificacion;

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

    PROCEDURE generar_solicitud (numSolicitud OUT numero_solicitud) AS
    BEGIN
      numeroSolicitud := generar_ramdon();

      INSERT INTO T01_SOLICITUDES (NUMERO_SOLICITUD) VALUES (numeroSolicitud);

      EXCEPTION
          WHEN OTHERS THEN

    END; -- generar_solicitud
END bpm_credit_process;
/