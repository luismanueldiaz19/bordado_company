// To parse this JSON data, do
//
//     final productIncidencia = productIncidenciaFromJson(jsonString);

import 'dart:convert';

List<ProductIncidencia> productIncidenciaFromJson(String str) =>
    List<ProductIncidencia>.from(
        json.decode(str).map((x) => ProductIncidencia.fromJson(x)));

String productIncidenciaToJson(List<ProductIncidencia> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductIncidencia {
  ProductIncidencia({
    this.id,
    this.idKey,
    this.product,
    this.cant,
    this.cost,
    this.date,
  });

  String? id;
  String? idKey;
  String? product;
  String? cant;
  String? cost;
  String? date;

  factory ProductIncidencia.fromJson(Map<String, dynamic> json) =>
      ProductIncidencia(
        id: json["id"],
        idKey: json["id_key"],
        product: json["product"],
        cant: json["cant"],
        cost: json["cost"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_key": idKey,
        "product": product,
        "cant": cant,
        "cost": cost,
        "datee": date,
      };
}
