// To parse this JSON data, do
//
//     final modulo = moduloFromJson(jsonString);

import 'dart:convert';

List<Modulo> moduloFromJson(String str) =>
    List<Modulo>.from(json.decode(str).map((x) => Modulo.fromJson(x)));

String moduloToJson(List<Modulo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Modulo {
  Modulo({
    this.id,
    this.nameModulo,
    this.cantModulo,
    this.statu,
  });

  String? id;
  String? nameModulo;
  String? cantModulo;
  String? statu;

  factory Modulo.fromJson(Map<String, dynamic> json) => Modulo(
        id: json["id"],
        nameModulo: json["name_modulo"],
        cantModulo: json["cant_modulo"],
        statu: json["statu"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name_modulo": nameModulo,
        "cant_modulo": cantModulo,
        "statu": statu,
      };
}
