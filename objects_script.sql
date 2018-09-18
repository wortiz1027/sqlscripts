/*
 ********************************************************
 *   AUTOR: WILMAN ORTIZ AVARRO
 *   FECHA: 17-SEPT-2018
 *   DESCRIPCION: DEFINICION DE OBJETOS QUE SE USARAN
 *   COMO ENTRADA Y SALIDA DE LOS PROCEDIMIENTOS
 *********************************************************
 */

CREATE OR REPLACE TYPE cabecera_mensaje AS OBJECT (
    tipo VARCHAR2(2),
    codigo VARCHAR2(50),
    descripcion varchar2(256)
);

CREATE OR REPLACE TYPE numero_solicitud AS OBJECT (
    cabecera   cabecera_mensaje,
    numeroSolicitud numeroSolicitud
);