// To parse this JSON data, do
//
//     final tirada = tiradaFromJson(jsonString);

import 'dart:convert';

List<Tirada> tiradaFromJson(String str) =>
    List<Tirada>.from(json.decode(str).map((x) => Tirada.fromJson(x)));

String tiradaToJson(List<Tirada> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tirada {
  Tirada({
    this.id,
    this.idUser,
    this.fullName,
    this.turn,
    this.occupation,
    this.idModulo,
    this.cantModulo,
    this.nameModulo,
    this.numOrden,
    this.cantOrden,
    this.logo,
    this.cantBad,
    this.cantTirada,
    this.tStop,
    this.eficiencia,
    this.deficiencia,
    this.tGeneralTime,
    this.tWorkedTime,
    this.date,
    this.dateCurrent,
    this.statu,
    this.comment,
    this.imagePath,
    this.idDentity,
  });

  String? id;
  String? idUser;
  String? fullName;
  String? turn;
  String? occupation;
  String? idModulo;
  String? cantModulo;
  String? nameModulo;
  String? numOrden;
  String? cantOrden;
  String? logo;
  String? cantBad;
  String? cantTirada;
  String? tStop;
  String? eficiencia;
  String? deficiencia;
  String? tGeneralTime;
  String? tWorkedTime;
  String? date;
  String? dateCurrent;
  String? statu;
  String? comment;
  String? imagePath;
  String? idDentity;

  factory Tirada.fromJson(Map<String, dynamic> json) => Tirada(
        id: json["id"],
        idUser: json["id_user"],
        fullName: json["full_name"],
        turn: json["turn"],
        occupation: json["occupation"],
        idModulo: json["id_modulo"],
        cantModulo: json["cant_modulo"],
        nameModulo: json["name_modulo"],
        numOrden: json["num_orden"],
        cantOrden: json["cant_orden"],
        logo: json["logo"],
        cantBad: json["cant_bad"],
        cantTirada: json["cant_tirada"],
        tStop: json["t_stop"],
        eficiencia: json["eficiencia"],
        deficiencia: json["deficiencia"],
        tGeneralTime: json["t_general_time"],
        tWorkedTime: json["t_worked_time"],
        date: json["date"],
        dateCurrent: json["date_current"],
        statu: json["statu"],
        comment: json["comment"],
        imagePath: json["image_path"],
        idDentity: json["id_dentity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "full_name": fullName,
        "turn": turn,
        "occupation": occupation,
        "id_modulo": idModulo,
        "cant_modulo": cantModulo,
        "name_modulo": nameModulo,
        "num_orden": numOrden,
        "cant_orden": cantOrden,
        "logo": logo,
        "cant_bad": cantBad,
        "cant_tirada": cantTirada,
        "t_stop": tStop,
        "eficiencia": eficiencia,
        "deficiencia": deficiencia,
        "t_general_time": tGeneralTime,
        "t_worked_time": tWorkedTime,
        "date": date,
        "date_current": dateCurrent,
        "statu": statu,
        "comment": comment,
        "image_path": imagePath,
        "id_dentity": idDentity,
      };
}
