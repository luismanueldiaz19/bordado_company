// To parse this JSON data, do
//
//     final nivel = nivelFromJson(jsonString);

import 'dart:convert';

List<Nivel> nivelFromJson(String str) =>
    List<Nivel>.from(json.decode(str).map((x) => Nivel.fromJson(x)));

String nivelToJson(List<Nivel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Nivel {
  Nivel({
    this.id,
    this.nameNivel,
    this.date,
    this.statu,
  });

  String? id;
  String? nameNivel;
  String? date;
  String? statu;

  factory Nivel.fromJson(Map<String, dynamic> json) => Nivel(
        id: json["id"],
        nameNivel: json["name_nivel"],
        date: json["date"],
        statu: json["statu"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name_nivel": nameNivel,
        "date": date,
        "statu": statu,
      };
}
