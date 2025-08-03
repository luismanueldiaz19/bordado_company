// To parse this JSON data, do
//
//     final machineStop = machineStopFromJson(jsonString);

import 'dart:convert';

List<MachineStop> machineStopFromJson(String str) => List<MachineStop>.from(
    json.decode(str).map((x) => MachineStop.fromJson(x)));

String machineStopToJson(List<MachineStop> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MachineStop {
  MachineStop({
    this.id,
    this.idMachine,
    this.date,
    this.idUserStop,
    this.fullName,
    this.firstStop,
    this.idUserSecond,
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
  String? secondStart;
  String? comment;

  factory MachineStop.fromJson(Map<String, dynamic> json) => MachineStop(
        id: json["id"],
        idMachine: json["id_machine"],
        date: json["date"],
        idUserStop: json["id_user_stop"],
        fullName: json["full_name"],
        firstStop: json["first_stop"],
        idUserSecond: json["id_user_second"],
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
        "second_start": secondStart,
        "comment": comment,
      };
}
