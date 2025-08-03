// To parse this JSON data, do
//
//     final typeWorks = typeWorksFromJson(jsonString);

import 'dart:convert';

List<TypeWorks> typeWorksFromJson(String str) =>
    List<TypeWorks>.from(json.decode(str).map((x) => TypeWorks.fromJson(x)));

String typeWorksToJson(List<TypeWorks> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TypeWorks {
  String? idTypeWorkSastreria;
  String? nameTypeWork;
  String? imageTypeWork;
  String? areaWorkSastreria;

  TypeWorks({
    this.idTypeWorkSastreria,
    this.nameTypeWork,
    this.imageTypeWork,
    this.areaWorkSastreria,
  });

  factory TypeWorks.fromJson(Map<String, dynamic> json) => TypeWorks(
        idTypeWorkSastreria: json["id_type_work_sastreria"] ?? '0',
        nameTypeWork: json["name_type_work"] ?? 'N/A',
        imageTypeWork: json["image_type_work"] ?? 'N/A',
        areaWorkSastreria: json["area_work_sastreria"] ?? 'N/A',
      );

  Map<String, dynamic> toJson() => {
        "id_type_work_sastreria": idTypeWorkSastreria ?? '0',
        "name_type_work": nameTypeWork ?? 'N/A',
        "image_type_work": imageTypeWork ?? 'N/A',
        "area_work_sastreria": areaWorkSastreria ?? 'N/A',
      };
}
