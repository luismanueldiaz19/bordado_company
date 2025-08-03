// To parse this JSON data, do
//
//     final imagenSerigrafia = imagenSerigrafiaFromJson(jsonString);

import 'dart:convert';

List<ImagenSerigrafia> imagenSerigrafiaFromJson(String str) =>
    List<ImagenSerigrafia>.from(
        json.decode(str).map((x) => ImagenSerigrafia.fromJson(x)));

String imagenSerigrafiaToJson(List<ImagenSerigrafia> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ImagenSerigrafia {
  String? idSerigrafiaImagenPath;
  String? idSerigrafiaWorkFinished;
  String? namePath;
  String? created;

  ImagenSerigrafia({
    this.idSerigrafiaImagenPath,
    this.idSerigrafiaWorkFinished,
    this.namePath,
    this.created,
  });

  factory ImagenSerigrafia.fromJson(Map<String, dynamic> json) =>
      ImagenSerigrafia(
        idSerigrafiaImagenPath: json["id_serigrafia_imagen_path"],
        idSerigrafiaWorkFinished: json["id_serigrafia_work_finished"],
        namePath: json["name_path"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id_serigrafia_imagen_path": idSerigrafiaImagenPath,
        "id_serigrafia_work_finished": idSerigrafiaWorkFinished,
        "name_path": namePath,
        "created": created,
      };
}
