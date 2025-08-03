// To parse this JSON data, do
//
//     final atencionCliente = atencionClienteFromJson(jsonString);

import 'dart:convert';

List<AtencionCliente> atencionClienteFromJson(String str) =>
    List<AtencionCliente>.from(
        json.decode(str).map((x) => AtencionCliente.fromJson(x)));

String atencionClienteToJson(List<AtencionCliente> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AtencionCliente {
  String? id;
  String? logo;
  String? cantidad;
  String? comment;
  String? descripcion;
  String? typeWorked;
  String? dateStart;
  String? dateEnd;
  String? userRegistered;
  String? ficha;
  String? numOrden;

  AtencionCliente({
    this.id,
    this.cantidad,
    this.comment,
    this.descripcion,
    this.typeWorked,
    this.dateStart,
    this.dateEnd,
    this.userRegistered,
    this.ficha,
    this.numOrden,
    this.logo,
  });

  AtencionCliente copyWith({
    String? id,
    String? cantidad,
    String? comment,
    String? descripcion,
    String? typeWorked,
    String? dateStart,
    String? dateEnd,
    String? userRegistered,
    String? ficha,
    String? numOrden,
    String? logo,
  }) =>
      AtencionCliente(
        id: id ?? this.id,
        descripcion: descripcion ?? this.descripcion,
        typeWorked: typeWorked ?? this.typeWorked,
        dateStart: dateStart ?? this.dateStart,
        dateEnd: dateEnd ?? this.dateEnd,
        userRegistered: userRegistered ?? this.userRegistered,
        cantidad: cantidad ?? this.cantidad,
        comment: comment ?? this.comment,
        ficha: ficha ?? this.ficha,
        numOrden: numOrden ?? this.numOrden,
        logo: logo ?? this.logo,
      );

  factory AtencionCliente.fromJson(Map<String, dynamic> json) =>
      AtencionCliente(
        id: json["id"],
        descripcion: json["descripcion"],
        typeWorked: json["type_worked"],
        dateStart: json["date_start"],
        dateEnd: json["date_end"],
        userRegistered: json["user_registered"],
        cantidad: json['cantidad'],
        comment: json['comment'],
        ficha: json['ficha'],
        numOrden: json['num_orden'],
        logo: json['logo'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cantidad": cantidad,
        "comment": comment,
        "descripcion": descripcion,
        "type_worked": typeWorked,
        "date_start": dateStart,
        "date_end": dateEnd,
        "user_registered": userRegistered,
        "ficha": ficha,
        "num_orden": numOrden,
        "logo": logo
      };
}
