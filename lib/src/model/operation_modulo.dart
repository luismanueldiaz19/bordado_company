// To parse this JSON data, do
//
//     final operationModulo = operationModuloFromJson(jsonString);

import 'dart:convert';

List<OperationModulo> operationModuloFromJson(String str) =>
    List<OperationModulo>.from(
        json.decode(str).map((x) => OperationModulo.fromJson(x)));

String operationModuloToJson(List<OperationModulo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OperationModulo {
  OperationModulo(
      {this.id,
      this.idUser,
      this.fullName,
      this.idModulo,
      this.nameModulo,
      this.cantModulo,
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
      this.idDentity});

  String? id;
  String? idUser;
  String? fullName;
  String? idModulo;
  String? nameModulo;
  String? cantModulo;
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
  String? idDentity;

  factory OperationModulo.fromJson(Map<String, dynamic> json) =>
      OperationModulo(
          id: json["id"],
          idUser: json["id_user"],
          fullName: json["full_name"],
          idModulo: json["id_modulo"],
          nameModulo: json["name_modulo"],
          cantModulo: json["cant_modulo"],
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
          idDentity: json['id_dentity']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "full_name": fullName,
        "id_modulo": idModulo,
        "name_modulo": nameModulo,
        "cant_modulo": cantModulo,
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
        "id_dentity": idDentity
      };
}
