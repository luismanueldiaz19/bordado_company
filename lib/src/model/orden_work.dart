// To parse this JSON data, do
//
//     final ordenWork = ordenWorkFromJson(jsonString);

import 'dart:convert';

import 'tipo_trabajo.dart';

List<OrdenWork> ordenWorkFromJson(String str) =>
    List<OrdenWork>.from(json.decode(str).map((x) => OrdenWork.fromJson(x)));

String ordenWorkToJson(List<OrdenWork> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

//
class OrdenWork {
  String? hojaProduccionId;

  String? startDate;
  dynamic endDate;
  String? createdAt;
  String? estadoHoja;
  String? fullName;
  String? usuarioId;
  String? ordenItemsId;
  String? tipoTrabajoId;
  String? observacionesHoja;

  String? campoId;
  String? nameTrabajo;
  String? urlImagen;
  String? areaTrabajo;
  String? nombreCampo;
  String? cantOrden;
  String? tipoDato;
  String? numOrden;
  String? ficha;
  String? nameLogo;
  String? idCliente;
  String? nombreCliente;
  String? idDepart;
  String? nameDepartment;
  List<Campo>? campos;

  OrdenWork({
    this.hojaProduccionId,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.estadoHoja,
    this.fullName,
    this.usuarioId,
    this.ordenItemsId,
    this.tipoTrabajoId,
    this.observacionesHoja,
    this.campoId,
    this.nameTrabajo,
    this.urlImagen,
    this.areaTrabajo,
    this.nombreCampo,
    this.cantOrden,
    this.tipoDato,
    this.numOrden,
    this.ficha,
    this.nameLogo,
    this.idCliente,
    this.nombreCliente,
    this.idDepart,
    this.nameDepartment,
    this.campos,
  });

  factory OrdenWork.fromJson(Map<String, dynamic> json) => OrdenWork(
        hojaProduccionId: json["hoja_produccion_id"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        createdAt: json["created_at"],
        estadoHoja: json["estado_hoja"],
        fullName: json["full_name"],
        usuarioId: json["usuario_id"],
        ordenItemsId: json["orden_items_id"],
        tipoTrabajoId: json["tipo_trabajo_id"],
        observacionesHoja: json["observaciones_hoja"],
        campoId: json["campo_id"],
        nameTrabajo: json["name_trabajo"],
        urlImagen: json["url_imagen"],
        areaTrabajo: json["area_trabajo"],
        nombreCampo: json["nombre_campo"],
        cantOrden: json["cant_orden"],
        tipoDato: json["tipo_dato"],
        numOrden: json["num_orden"],
        ficha: json["ficha"],
        nameLogo: json["name_logo"],
        idCliente: json["id_cliente"],
        nombreCliente: json["nombre_cliente"],
        idDepart: json["id_depart"],
        nameDepartment: json["name_department"],
        campos: json["campos"] == null
            ? []
            : List<Campo>.from(json["campos"].map((x) => Campo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "hoja_produccion_id": hojaProduccionId,
        "start_date": startDate,
        "end_date": endDate,
        "created_at": createdAt,
        "estado_hoja": estadoHoja,
        "full_name": fullName,
        "usuario_id": usuarioId,
        "orden_items_id": ordenItemsId,
        "tipo_trabajo_id": tipoTrabajoId,
        "observaciones_hoja": observacionesHoja,
        "campo_id": campoId,
        "name_trabajo": nameTrabajo,
        "url_imagen": urlImagen,
        "area_trabajo": areaTrabajo,
        "nombre_campo": nombreCampo,
        "cant_orden": cantOrden,
        "tipo_dato": tipoDato,
        "num_orden": numOrden,
        "ficha": ficha,
        "name_logo": nameLogo,
        "id_cliente": idCliente,
        "nombre_cliente": nombreCliente,
        "id_depart": idDepart,
        "name_department": nameDepartment,
        "campos": campos == null
            ? []
            : List<dynamic>.from(campos!.map((x) => x.toJson())),
      };

  static List<String> depurarEmpleados(List<OrdenWork> list) {
    return list.map((element) => element.fullName!).toSet().toList();
  }

  static List<String> depurarTypeWork(List<OrdenWork> list) {
    return list.map((element) => element.nameTrabajo!).toSet().toList();
  }
}
