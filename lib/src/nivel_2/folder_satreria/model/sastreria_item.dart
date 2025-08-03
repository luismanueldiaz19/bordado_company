// To parse this JSON data, do
//
//     final sastreriaWorkItem = sastreriaWorkItemFromJson(jsonString);

import 'dart:convert';

List<SastreriaWorkItem> sastreriaWorkItemFromJson(String str) =>
    List<SastreriaWorkItem>.from(
        json.decode(str).map((x) => SastreriaWorkItem.fromJson(x)));

String sastreriaWorkItemToJson(List<SastreriaWorkItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SastreriaWorkItem {
  String? id;
  String? idKey;
  String? tipoPieza;
  String? cant;
  String? price;
  String? description;
  String? code;
  String? fullName;
  String? turn;
  String? occupation;
  String? fecha;
  String? numOrden;
  String? comment;

  SastreriaWorkItem({
    this.id,
    this.idKey,
    this.tipoPieza,
    this.cant,
    this.price,
    this.description,
    this.code,
    this.fullName,
    this.turn,
    this.occupation,
    this.fecha,
    this.numOrden,
    this.comment,
  });

  factory SastreriaWorkItem.fromJson(Map<String, dynamic> json) =>
      SastreriaWorkItem(
        id: json["id"],
        idKey: json["id_key"],
        tipoPieza: json["tipo_pieza"],
        cant: json["cant"],
        price: json["price"],
        description: json["description"],
        code: json["code"],
        fullName: json["full_name"],
        turn: json["turn"],
        occupation: json["occupation"],
        fecha: json["fecha"],
        numOrden: json["num_orden"],
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_key": idKey,
        "tipo_pieza": tipoPieza,
        "cant": cant,
        "price": price,
        "description": description,
        "code": code,
        "full_name": fullName,
        "turn": turn,
        "occupation": occupation,
        "fecha": fecha,
        "num_orden": numOrden,
        "comment": comment,
      };
}
