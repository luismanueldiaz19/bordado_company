// To parse this JSON data, do
//
//     final almacenData = almacenDataFromJson(jsonString);

import 'dart:convert';

List<AlmacenData> almacenDataFromJson(String str) => List<AlmacenData>.from(
    json.decode(str).map((x) => AlmacenData.fromJson(x)));

String almacenDataToJson(List<AlmacenData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AlmacenData {
  AlmacenData(
      {this.id,
      this.ficha,
      this.idDepart,
      this.code,
      this.fullName,
      this.turn,
      this.cliente,
      this.nameDepartment,
      this.nivel,
      this.numOrden,
      this.description,
      this.idKeyItem,
      this.date,
      this.dateCurrent,
      this.cant,
      this.price,
      this.nameProducto,
      this.resultado,
      this.isIncidencia});

  String? id;
  String? ficha;
  String? idDepart;
  String? code;
  String? fullName;
  String? turn;
  String? cliente;
  String? nameDepartment;
  String? nivel;
  String? numOrden;
  String? description;
  String? idKeyItem;
  String? date;
  String? dateCurrent;
  String? price;
  String? cant;
  String? nameProducto;
  String? resultado;
  String? isIncidencia;

  factory AlmacenData.fromJson(Map<String, dynamic> json) => AlmacenData(
        id: json["id"],
        ficha: json["ficha"],
        idDepart: json["id_depart"],
        code: json["code"],
        fullName: json["full_name"],
        turn: json["turn"],
        cliente: json["cliente"],
        nameDepartment: json["name_department"],
        nivel: json["nivel"],
        numOrden: json["num_orden"],
        description: json["description"],
        idKeyItem: json["id_key_item"],
        date: json["date"],
        dateCurrent: json["date_current"],
        cant: json['cant'],
        price: json['price'],
        nameProducto: json['name_producto'],
        resultado: json['resultado'],
        isIncidencia: json['is_incidencia'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ficha": ficha,
        "id_depart": idDepart,
        "code": code,
        "full_name": fullName,
        "turn": turn,
        "cliente": cliente,
        "name_department": nameDepartment,
        "nivel": nivel,
        "num_orden": numOrden,
        "description": description,
        "id_key_item": idKeyItem,
        "date": date,
        "date_current": dateCurrent,
        "price": price,
        "cant": cant,
        "name_producto": nameProducto,
        "resultado": resultado,
        "is_incidencia": isIncidencia
      };

  static String getTotal(List<AlmacenData> collection) {
    double value = 0.0;
    for (var element in collection) {
      value += double.parse(element.cant ?? '0.0');
    }

    return value.toStringAsFixed(2);
  }

  static String getTotalCost(List<AlmacenData> collection) {
    double value = 0.0;
    for (var element in collection) {
      value += double.parse(element.resultado ?? '0.0');
    }

    return value.toStringAsFixed(2);
  }

  static List<AlmacenData> getTotalListIsIncidencia(
      List<AlmacenData> collection, String value) {
    List<AlmacenData> itemList = [];
    for (var element in collection) {
      if (element.isIncidencia?.toLowerCase() == value.toLowerCase()) {
        itemList.add(element);
      }
    }

    return itemList;
  }
}
