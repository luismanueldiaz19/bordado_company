import 'dart:convert';

List<ImageGetPathFile> imageGetPathFileFromJson(String str) =>
    List<ImageGetPathFile>.from(
        json.decode(str).map((x) => ImageGetPathFile.fromJson(x)));

String imageSublimacionToJson(List<ImageGetPathFile> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ImageGetPathFile {
  ImageGetPathFile({
    this.id,
    this.imagePath,
    this.idPath,
    this.date,
    this.dateCurrent,
  });

  String? id;
  String? imagePath;
  String? idPath;
  String? date;
  String? dateCurrent;

  factory ImageGetPathFile.fromJson(Map<String, dynamic> json) =>
      ImageGetPathFile(
        id: json["id"],
        imagePath: json["image_path"],
        idPath: json["id_path"],
        date: json["date"],
        dateCurrent: json["date_current"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image_path": imagePath,
        "id_path": idPath,
        "date": date,
        "date_current": dateCurrent,
      };
}
