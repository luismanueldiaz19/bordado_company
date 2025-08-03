// To parse this JSON data, do
//
//     final reanudarOrden = reanudarOrdenFromJson(jsonString);

import 'dart:convert';

List<ReanudarOrden> reanudarOrdenFromJson(String str) =>
    List<ReanudarOrden>.from(
        json.decode(str).map((x) => ReanudarOrden.fromJson(x)));

String reanudarOrdenToJson(List<ReanudarOrden> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReanudarOrden {
  ReanudarOrden({
    this.id,
    this.idUser,
    this.fullName,
    this.idModulo,
    this.nameModulo,
    this.numOrden,
    this.date,
    this.dateCurrent,
    this.logo,
    this.turn,
    this.idDentity,
    this.cantPcs,
    this.cantPunts,
    this.velozMachine,
  });

  String? id;
  String? idUser;
  String? fullName;
  String? idModulo;
  String? nameModulo;
  String? numOrden;
  String? date;
  String? dateCurrent;
  String? logo;
  String? turn;
  String? idDentity;
  String? cantPcs;
  String? cantPunts;
  String? velozMachine;

  factory ReanudarOrden.fromJson(Map<String, dynamic> json) => ReanudarOrden(
        id: json["id"],
        idUser: json["id_user"],
        fullName: json["full_name"],
        idModulo: json["id_modulo"],
        nameModulo: json["name_modulo"],
        numOrden: json["num_orden"],
        date: json["date"],
        dateCurrent: json["date_current"],
        logo: json["logo"],
        turn: json["turn"],
        idDentity: json["id_dentity"],
        cantPcs: json["cant_pcs"],
        cantPunts: json["cant_punts"],
        velozMachine: json["veloz_machine"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "full_name": fullName,
        "id_modulo": idModulo,
        "name_modulo": nameModulo,
        "num_orden": numOrden,
        "date": date,
        "date_current": dateCurrent,
        "logo": logo,
        "turn": turn,
        "id_dentity": idDentity,
        "cant_pcs": cantPcs,
        "cant_punts": cantPunts,
        "veloz_machine": velozMachine,
      };
}
