// To parse this JSON data, do
//
//     final machineStopRecord = machineStopRecordFromJson(jsonString);

import 'dart:convert';

List<MachineStopRecord> machineStopRecordFromJson(String str) =>
    List<MachineStopRecord>.from(
        json.decode(str).map((x) => MachineStopRecord.fromJson(x)));

String machineStopRecordToJson(List<MachineStopRecord> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MachineStopRecord {
  MachineStopRecord({
    this.id,
    this.idMachine,
    this.date,
    this.idUserStop,
    this.fullName,
    this.firstStop,
    this.idUserSecond,
    this.secondName,
    this.secondStart,
    this.comment,
  });

  String? id;
  String? idMachine;
  String? date;
  String? idUserStop;
  String? fullName;
  String? firstStop;
  String? idUserSecond;
  String? secondName;
  String? secondStart;
  String? comment;

  factory MachineStopRecord.fromJson(Map<String, dynamic> json) =>
      MachineStopRecord(
        id: json["id"],
        idMachine: json["id_machine"],
        date: json["date"],
        idUserStop: json["id_user_stop"],
        fullName: json["full_name"],
        firstStop: json["first_stop"],
        idUserSecond: json["id_user_second"],
        secondName: json["second_name"],
        secondStart: json["second_start"],
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_machine": idMachine,
        "date": date,
        "id_user_stop": idUserStop,
        "full_name": fullName,
        "first_stop": firstStop,
        "id_user_second": idUserSecond,
        "second_name": secondName,
        "second_start": secondStart,
        "comment": comment,
      };
}
