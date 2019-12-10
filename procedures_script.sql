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
    FUNCTION generar_ramdon (limite1 IN NUMBER, limite2 IN NUMBER) RETURN VARCHAR2;

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
	
	FUNCTION generar_ramdon(limite1 IN NUMBER, limite2 IN NUMBER) RETURN VARCHAR2 AS
        numero_aleatorio NUMBER;
      BEGIN
          SELECT ROUND(DBMS_RANDOM.VALUE(limite1, limite2)) numero
          INTO numero_aleatorio
          FROM DUAL;

          RETURN CONCAT(base_numero_solicitud, numero_aleatorio);
      END; -- generar_ramdon

    PROCEDURE generar_solicitud (estado OUT CabeceraMensaje, infoSolicitud OUT Solicitud) AS
        numero_solicitud VARCHAR2(256);
        ID_SOLICITUD T01_SOLICITUDES.CONS_SOLICITUD%TYPE;
      BEGIN
        numero_solicitud := generar_ramdon(10000000, 999999999);

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
		ID_CLIENTE   T02_CLIENTES.CONS_CLIENTE%TYPE;
		ID_SOLICITUD T01_SOLICITUDES.CONS_SOLICITUD%TYPE;
      BEGIN
		  -- TODO consultar el consecutivo de solicitud en T01_SOLICITUDES
		  SELECT CONS_SOLICITUD INTO ID_SOLICITUD
		  FROM T01_SOLICITUDES
		  WHERE NUMERO_SOLICITUD = radicar.informacionSolicitud.consecutivo_solicitud;
		  
		  IF (SQL%ROWCOUNT = 0) THEN
			RAISE NO_DATA_FOUND;
		  END IF;
		  
		  -- TODO guardar informacion en T02_CLIENTES		  
		  INSERT INTO T02_CLIENTES(NUM_DOCUMENTO, NOMBRES, APELLIDOS, DIRECCION, TELEFONO, EMAIL, TIPO_DOCUMENTO) 
		         VALUES (radicar.informacionCliente.numero_documento, 
				         radicar.informacionCliente.nombres, 
						 radicar.informacionCliente.apellidos,
						 radicar.informacionCliente.direccion,
						 radicar.informacionCliente.telefono,
						 radicar.informacionCliente.email,
						 radicar.informacionCliente.documento.codigo_tipo_documento) RETURNING CONS_CLIENTE INTO ID_CLIENTE;
		  COMMIT;
		  
	      -- TODO guardar datos en T03_INFO_SOLICITUD 
		  INSERT INTO T03_INFO_SOLICITUD(CONS_SOLICITUD, CONS_CLIENTE, VALOR_SOLICITUD, SOLICITUD_APROBADA, AUTO_APROBADA, MOTIVO) 
		         VALUES (ID_SOLICITUD, 
				         ID_CLIENTE, 
						 radicar.valor_solicitud, 
						 radicar.solicitud_aprobada, 
						 radicar.auto_aprobada, 
						 radicar.motivo);
		  COMMIT;
		  
          estado := CabeceraMensaje('OK', '000', 'La solicitud se ha radicado exitosamente');
      EXCEPTION
		WHEN NO_DATA_FOUND THEN
			estado := CabeceraMensaje('ER', '-20001', CONCAT('Solicitud no encontrada - ', SQLCODE || ' - ' || SQLERRM));
			RAISE_APPLICATION_ERROR(-20001, 'Solicitud no encontrada!');
        WHEN OTHERS THEN
            estado := CabeceraMensaje('ER', '222', CONCAT('Error radicando la solicitud - ', SQLCODE || ' - ' || SQLERRM));
            ROLLBACK;
      END; -- radicar_solicitud

    PROCEDURE aprobacion_automatica (aprobacion IN OUT AutoAprobacion, estado OUT CabeceraMensaje) AS
		numeroAleatorio   VARCHAR2(256);
		mensajeAprobacion VARCHAR2(256);
		esAprobacion      VARCHAR2(10);
		codigoAprobacion  VARCHAR2(2);
		codigoMensaje     VARCHAR2(5);
	  BEGIN
		  numeroAleatorio := generar_ramdon(1, 10);
		  
		  IF (numeroAleatorio < 5) THEN
			  esAprobacion      := 'false';
			  codigoAprobacion  := 'ER';
			  codigoMensaje     := '001';
			  mensajeAprobacion := 'Error generando la aprobacion automatica';
		  ELSE
			  esAprobacion      := 'true';
			  codigoAprobacion  := 'OK';
			  codigoMensaje     := '000';
			  mensajeAprobacion := 'Aprobacion automatica generada exitosamente';
		  END IF;
		  
		  UPDATE T03_INFO_SOLICITUD
		  SET AUTO_APROBADA = esAprobacion
		  WHERE CONS_SOLICITUD = aprobacion;
		  
		  COMMIT;
		  
          estado := CabeceraMensaje(codigoAprobacion, codigoMensaje, mensajeAprobacion);
      EXCEPTION
        WHEN OTHERS THEN
             estado := CabeceraMensaje('ER', '222', CONCAT('Error en la aprobacion automatica - ', SQLCODE || ' - ' || SQLERRM));
             ROLLBACK;
      END; -- aprobacion_automatica

    PROCEDURE enviar_notificacion (notificacion IN Notificaciones, estado OUT CabeceraMensaje) AS
		DESCRIPCION T06_TIPO_NOTIFICACION.DESC_TIPO_NOTIFICACION%TYPE;
		MENSAJE     T06_TIPO_NOTIFICACION.PLANTILLA_NOTIFICACION%TYPE;
	  BEGIN
		   -- TODO Consultar tipo de notificacion
		   SELECT DESC_TIPO_NOTIFICACION, PLANTILLA_NOTIFICACION INTO DESCRIPCION, MENSAJE
		   FROM T06_TIPO_NOTIFICACION
		   WHERE DESC_TIPO_NOTIFICACION = notificacion.tipo.codigo_tipo_notificacion;
			
		   INSERT INTO T04_NOTIFICACIONES(CONS_SOLICITUD,CONS_TIPO_NOTIFICACION, MENSAJE_NOTIVICACION) 
		          VALUES (notificacion.informacionSolicitud.consecutivo_solicitud, notificacion.tipo.codigo_tipo_notificacion, notificacion.plantilla);
		   COMMIT;	  
           estado := CabeceraMensaje('OK', '000', 'Notificacion enviada exitosamente');
      EXCEPTION
        WHEN OTHERS THEN
             estado := CabeceraMensaje('ER', '333', CONCAT('Error enviando la notificacion - ', SQLCODE || ' - ' || SQLERRM));
             ROLLBACK;
      END; -- enviar_notificacion

END bpm_credit_process;
/
