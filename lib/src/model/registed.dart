// To parse this JSON data, do
//
//     final registed = registedFromJson(jsonString);

import 'dart:convert';

List<Registed> registedFromJson(String str) =>
    List<Registed>.from(json.decode(str).map((x) => Registed.fromJson(x)));

String registedToJson(List<Registed> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Registed {
  String? year;
  String? monthName;
  int? entradas;
  int? salidas;

  Registed({
    this.year,
    this.monthName,
    this.entradas,
    this.salidas,
  });

  factory Registed.fromJson(Map<String, dynamic> json) => Registed(
        year: json["year"],
        monthName: json["month_name"],
        entradas: json["entradas"],
        salidas: json["salidas"],
      );

  Map<String, dynamic> toJson() => {
        "year": year,
        "month_name": monthName,
        "entradas": entradas,
        "salidas": salidas,
      };
}
