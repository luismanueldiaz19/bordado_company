// To parse this JSON data, do
//
//     final reportAdmin = reportAdminFromJson(jsonString);

import 'dart:convert';

List<ReportAdmin> reportAdminFromJson(String str) => List<ReportAdmin>.from(
    json.decode(str).map((x) => ReportAdmin.fromJson(x)));

String reportAdminToJson(List<ReportAdmin> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReportAdmin {
  ReportAdmin(
      {this.id,
      this.idKeyRevision,
      this.date,
      this.dateCurrent,
      this.isWorking,
      this.idReported,
      this.cantWork,
      this.comment,
      this.typeWork,
      this.isAdminCheck});

  String? id;
  String? idKeyRevision;
  String? date;
  String? dateCurrent;
  String? isWorking;
  String? idReported;
  String? typeWork;
  String? comment;
  String? cantWork;
  String? isAdminCheck;

  factory ReportAdmin.fromJson(Map<String, dynamic> json) => ReportAdmin(
      id: json["id"],
      idKeyRevision: json["id_key_revision"],
      date: json["date"],
      dateCurrent: json["date_current"],
      isWorking: json["is_working"],
      idReported: json["id_reported"],
      cantWork: json["cant_work"],
      comment: json["comment"],
      typeWork: json["type_work"],
      isAdminCheck: json['is_admin_check']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_key_revision": idKeyRevision,
        "date": date,
        "date_current": dateCurrent,
        "is_working": isWorking,
        "id_reported": idReported,
        "cant_work": cantWork,
        "comment": comment,
        "type_work": typeWork,
        "is_admin_check": isAdminCheck
      };
}
