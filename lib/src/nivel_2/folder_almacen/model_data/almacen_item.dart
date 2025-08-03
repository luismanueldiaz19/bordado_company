// To parse this JSON data, do
//
//     final almacenItem = almacenItemFromJson(jsonString);

import 'dart:convert';

List<AlmacenItem> almacenItemFromJson(String str) => List<AlmacenItem>.from(
    json.decode(str).map((x) => AlmacenItem.fromJson(x)));

String almacenItemToJson(List<AlmacenItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AlmacenItem {
  AlmacenItem({
    this.id,
    this.idKeyItem,
    this.nameProducto,
    this.cant,
    this.price,
    this.subtotal,
  });
  String? id;
  String? idKeyItem;
  String? nameProducto;
  String? cant;
  String? price;
  String? subtotal;

  factory AlmacenItem.fromJson(Map<String, dynamic> json) => AlmacenItem(
        id: json["id"],
        idKeyItem: json["id_key_item"],
        nameProducto: json["name_producto"],
        cant: json["cant"],
        price: json["price"],
        subtotal: json['subtotal'],
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? '0',
        "id_key_item": idKeyItem ?? '0',
        "name_producto": nameProducto ?? '0',
        "cant": cant ?? '0',
        "price": price ?? '0',
        "subtotal": subtotal ?? '0',
      };
  static String getSubtotal(AlmacenItem item) {
    try {
      // Convertir las cadenas a double, manejando nulos y excepciones
      double cantidad = double.tryParse(item.cant ?? '0.0') ?? 0.0;
      double precio = double.tryParse(item.price ?? '0.0') ?? 0.0;

      // Calcular el resultado
      double resultado = cantidad * precio;

      // Retornar el resultado con dos decimales
      return resultado.toStringAsFixed(2);
    } catch (e) {
      // Manejo de errores en caso de conversión fallida
      return '0.00'; // Valor por defecto en caso de error
    }
  }

  static String getTotalCost(List<AlmacenItem> collection) {
    double value = 0.0;
    for (var element in collection) {
      value += double.parse(getSubtotal(element) ?? '0.0');
    }

    return value.toStringAsFixed(2);
  }

  static String getTotalPieza(List<AlmacenItem> collection) {
    double value = 0.0;
    for (var element in collection) {
      value += double.parse(element.cant ?? '0.0');
    }

    return value.toStringAsFixed(2);
  }
}
