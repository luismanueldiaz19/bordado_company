// To parse this JSON data, do
//
//     final ordenFiles = ordenFilesFromJson(jsonString);

import 'dart:convert';

List<OrdenFiles> ordenFilesFromJson(String str) =>
    List<OrdenFiles>.from(json.decode(str).map((x) => OrdenFiles.fromJson(x)));

String ordenFilesToJson(List<OrdenFiles> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrdenFiles {
  String? idFileOrden;
  String? numOrden;
  String? fileName;
  String? fileType;
  String? filePath;
  String? uploadDate;
  String? nota;

  OrdenFiles({
    this.idFileOrden,
    this.numOrden,
    this.fileName,
    this.fileType,
    this.filePath,
    this.uploadDate,
    this.nota,
  });

  factory OrdenFiles.fromJson(Map<String, dynamic> json) => OrdenFiles(
        idFileOrden: json["id_file_orden"],
        numOrden: json["num_orden"],
        fileName: json["file_name"],
        fileType: json["file_type"],
        filePath: json["file_path"],
        uploadDate: json["upload_date"],
        nota: json["nota"],
      );

  Map<String, dynamic> toJson() => {
        "id_file_orden": idFileOrden,
        "num_orden": numOrden,
        "file_name": fileName,
        "file_type": fileType,
        "file_path": filePath,
        "upload_date": uploadDate,
        "nota": nota,
      };
}
