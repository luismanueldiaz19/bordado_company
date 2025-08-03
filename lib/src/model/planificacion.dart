// To parse this JSON data, do
//
//     final planificacion = planificacionFromJson(jsonString);

import 'dart:convert';

List<Planificacion> planificacionFromJson(String str) =>
    List<Planificacion>.from(
        json.decode(str).map((x) => Planificacion.fromJson(x)));

String planificacionToJson(List<Planificacion> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Planificacion {
  String? id;
  String? nameLogo;
  String? numOrden;
  String? comment;
  String? cant;
  String? ficha;
  String? fechaPlanificado;
  String? fechaStart;
  String? fechaEntrega;
  String? nameDepart;
  String? isEntregado;
  String? isCalidad;
  String? isKeyUnique;
  String? cantElab;

  Planificacion({
    this.id,
    this.nameLogo,
    this.numOrden,
    this.cant,
    this.ficha,
    this.fechaPlanificado,
    this.fechaStart,
    this.fechaEntrega,
    this.nameDepart,
    this.isEntregado,
    this.isCalidad,
    this.isKeyUnique,
    this.comment,
    this.cantElab,
  });

  Planificacion copyWith({
    String? id,
    String? nameLogo,
    String? numOrden,
    String? cant,
    String? ficha,
    String? fechaPlanificado,
    String? fechaStart,
    String? fechaEntrega,
    String? nameDepart,
    String? isEntregado,
    String? isCalidad,
    String? isKeyUnique,
    String? comment,
    String? cantElab,
  }) =>
      Planificacion(
          id: id ?? this.id,
          nameLogo: nameLogo ?? this.nameLogo,
          numOrden: numOrden ?? this.numOrden,
          cant: cant ?? this.cant,
          ficha: ficha ?? this.ficha,
          fechaPlanificado: fechaPlanificado ?? this.fechaPlanificado,
          fechaStart: fechaStart ?? this.fechaStart,
          fechaEntrega: fechaEntrega ?? this.fechaEntrega,
          nameDepart: nameDepart ?? this.nameDepart,
          isEntregado: isEntregado ?? this.isEntregado,
          isCalidad: isCalidad ?? this.isCalidad,
          isKeyUnique: isKeyUnique ?? this.isKeyUnique,
          comment: comment ?? this.comment,
          cantElab: cantElab ?? this.cantElab);

  factory Planificacion.fromJson(Map<String, dynamic> json) => Planificacion(
      id: json["id"],
      nameLogo: json["name_logo"],
      numOrden: json["num_orden"],
      cant: json["cant"],
      ficha: json["ficha"],
      fechaPlanificado: json["fecha_planificado"],
      fechaStart: json["fecha_start"],
      fechaEntrega: json["fecha_entrega"],
      nameDepart: json["name_depart"],
      isEntregado: json["is_entregado"],
      isCalidad: json["is_calidad"],
      isKeyUnique: json["is_key_unique"],
      comment: json['comment'],
      cantElab: json['cant_elab']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name_logo": nameLogo,
        "num_orden": numOrden,
        "cant": cant,
        "ficha": ficha,
        "fecha_planificado": fechaPlanificado,
        "fecha_start": fechaStart,
        "fecha_entrega": fechaEntrega,
        "name_depart": nameDepart,
        "is_entregado": isEntregado,
        "is_calidad": isCalidad,
        "is_key_unique": isKeyUnique,
        "comment": comment,
        "cant_elab": cantElab,
      };
}
