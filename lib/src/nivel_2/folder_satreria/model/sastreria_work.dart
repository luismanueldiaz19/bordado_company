// To parse this JSON data, do
//
//     final sastreriaWork = sastreriaWorkFromJson(jsonString);

import 'dart:convert';

List<SastreriaWork> sastreriaWorkFromJson(String str) =>
    List<SastreriaWork>.from(
        json.decode(str).map((x) => SastreriaWork.fromJson(x)));

String sastreriaWorkToJson(List<SastreriaWork> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SastreriaWork {
  SastreriaWork({
    this.id,
    this.code,
    this.fullName,
    this.fecha,
    this.numOrden,
    this.idKey,
    this.comment,
  });

  String? id;
  String? code;
  String? fullName;
  String? fecha;
  String? numOrden;
  String? idKey;
  String? comment;

  factory SastreriaWork.fromJson(Map<String, dynamic> json) => SastreriaWork(
        id: json["id"],
        code: json["code"],
        fullName: json["full_name"],
        fecha: json["fecha"],
        numOrden: json["num_orden"],
        idKey: json["id_key"],
        comment: json['comment'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "full_name": fullName,
        "fecha": fecha,
        "num_orden": numOrden,
        "id_key": idKey,
        "comment": comment,
      };
}
