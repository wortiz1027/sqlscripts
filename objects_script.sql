/*
 ********************************************************
 *   AUTOR: WILMAN ORTIZ AVARRO
 *   FECHA: 17-SEPT-2018
 *   DESCRIPCION: DEFINICION DE OBJETOS QUE SE USARAN
 *   COMO ENTRADA Y SALIDA DE LOS PROCEDIMIENTOS
 *********************************************************
 */

CREATE OR REPLACE TYPE CabeceraMensaje AS OBJECT (
    tipo VARCHAR2(2),
    codigo VARCHAR2(50),
    descripcion VARCHAR2(256)
);

CREATE OR REPLACE TYPE TipoDocumento AS OBJECT (
    codigo_tipo_documento VARCHAR2(2),
    descrioion_tipo_documento VARCHAR2(256)
);

CREATE OR REPLACE TYPE TipoNotificacion AS OBJECT (
    codigo_tipo_notificacion NUMBER,
    descrioion_tipo_notificacion VARCHAR2(512)
);

CREATE OR REPLACE TYPE Solicitud AS OBJECT (
    consecutivo_solicitud NUMBER,
    numeroSolicitud VARCHAR2(256)
);

CREATE OR REPLACE TYPE RadicarSolicitud AS OBJECT (
    informacionCliente Cliente,
    informacionSolicitud Solicitud,
    valor_solicitud NUMBER,
    solicitud_aprobada VARCHAR2(2),
    auto_aprobada VARCHAR2(2),
    motivo VARCHAR2(512)
);

CREATE OR REPLACE TYPE AutoAprobacion AS OBJECT (
    informacionSolicitud Solicitud,
    esAutoAprobada VARCHAR2(2)
);

CREATE OR REPLACE TYPE Notificaciones AS OBJECT (
    tipo TipoNotificacion,
    plantilla VARCHAR2(512),
    informacionSolicitud Solicitud
);

CREATE OR REPLACE TYPE Cliente AS OBJECT (
    consecutivo_cliente NUMBER,
    numero_documento VARCHAR2(50),
    nombres VARCHAR2(100),
    apellidos VARCHAR2(100),
    direccion VARCHAR2(512),
    telefono NUMBER,
    email VARCHAR2(512),
    documento TipoDocumento
);