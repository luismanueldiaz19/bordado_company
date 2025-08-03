// To parse this JSON data, do
//
//     final operationModuloRecord = operationModuloRecordFromJson(jsonString);

import 'dart:convert';

List<OperationModuloRecord> operationModuloRecordFromJson(String str) =>
    List<OperationModuloRecord>.from(
        json.decode(str).map((x) => OperationModuloRecord.fromJson(x)));

String operationModuloRecordToJson(List<OperationModuloRecord> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OperationModuloRecord {
  OperationModuloRecord(
      {this.id,
      this.userDatos,
      this.idModulo,
      this.numOrden,
      this.date,
      this.dateCurrent,
      this.logo,
      this.cantPcs,
      this.cantPunts,
      this.velozMachine,
      this.calida,
      this.timeMachine,
      this.comment,
      this.turn,
      this.tStop,
      this.porcentTimeMiss,
      this.tGeneralTime,
      this.tWorkedTime,
      this.pcsElaborated,
      this.idDentity});

  String? id;
  String? userDatos;
  String? idModulo;
  String? numOrden;
  String? date;
  String? dateCurrent;
  String? logo;
  String? cantPcs;
  String? cantPunts;
  String? velozMachine;
  String? calida;
  String? timeMachine;
  String? comment;
  String? turn;
  String? tStop;
  String? porcentTimeMiss;
  String? tGeneralTime;
  String? tWorkedTime;
  String? pcsElaborated;
  String? idDentity;

  factory OperationModuloRecord.fromJson(Map<String, dynamic> json) =>
      OperationModuloRecord(
          id: json["id"],
          userDatos: json["user_datos"],
          idModulo: json["id_modulo"],
          numOrden: json["num_orden"],
          date: json["date"],
          dateCurrent: json["date_current"],
          logo: json["logo"],
          cantPcs: json["cant_pcs"],
          cantPunts: json["cant_punts"],
          velozMachine: json["veloz_machine"],
          calida: json["calida"],
          timeMachine: json["time_machine"],
          comment: json["comment"],
          turn: json["turn"],
          tStop: json["t_stop"],
          porcentTimeMiss: json["porcent_time_miss"],
          tGeneralTime: json["t_general_time"],
          tWorkedTime: json["t_worked_time"],
          pcsElaborated: json["pcs_elaborated"],
          idDentity: json['id_dentity']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_datos": userDatos,
        "id_modulo": idModulo,
        "num_orden": numOrden,
        "date": date,
        "date_current": dateCurrent,
        "logo": logo,
        "cant_pcs": cantPcs,
        "cant_punts": cantPunts,
        "veloz_machine": velozMachine,
        "calida": calida,
        "time_machine": timeMachine,
        "comment": comment,
        "turn": turn,
        "t_stop": tStop,
        "porcent_time_miss": porcentTimeMiss,
        "t_general_time": tGeneralTime,
        "t_worked_time": tWorkedTime,
        "pcs_elaborated": pcsElaborated,
        "id_dentity": idDentity
      };
}
