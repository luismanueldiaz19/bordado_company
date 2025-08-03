// To parse this JSON data, do
//
//     final typeWork = typeWorkFromJson(jsonString);

import 'dart:convert';

List<TypeWork> typeWorkFromJson(String str) =>
    List<TypeWork>.from(json.decode(str).map((x) => TypeWork.fromJson(x)));

String typeWorkToJson(List<TypeWork> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TypeWork {
  TypeWork({
    this.id,
    this.typeWork,
    this.imagePath,
  });

  String? id;
  String? typeWork;
  String? imagePath;

  factory TypeWork.fromJson(Map<String, dynamic> json) => TypeWork(
        id: json["id"],
        typeWork: json["type_work"],
        imagePath: json["image_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type_work": typeWork,
        "image_path": imagePath,
      };
}
