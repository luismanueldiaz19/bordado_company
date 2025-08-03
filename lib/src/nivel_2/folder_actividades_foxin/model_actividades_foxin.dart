// To parse this JSON data, do
//
//     final actividades = actividadesFromJson(jsonString);

import 'dart:convert';

List<Actividades> actividadesFromJson(String str) => List<Actividades>.from(
    json.decode(str).map((x) => Actividades.fromJson(x)));

String actividadesToJson(List<Actividades> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Actividades {
  String? id;
  String? fullName;
  String? idType;
  String? typeName;
  String? nota;
  String? startTime;
  String? endTime;
  String? date;

  Actividades({
    this.id,
    this.fullName,
    this.idType,
    this.typeName,
    this.nota,
    this.startTime,
    this.endTime,
    this.date,
  });

  factory Actividades.fromJson(Map<String, dynamic> json) => Actividades(
        id: json["id"],
        fullName: json["full_name"],
        idType: json["id_type"],
        typeName: json["type_name"],
        nota: json["nota"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "id_type": idType,
        "type_name": typeName,
        "nota": nota,
        "start_time": startTime,
        "end_time": endTime,
        "date": date,
      };
}
