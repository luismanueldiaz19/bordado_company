// To parse this JSON data, do
//
//     final incidencia = incidenciaFromJson(jsonString);

import 'dart:convert';

List<Incidencia> incidenciaFromJson(String str) =>
    List<Incidencia>.from(json.decode(str).map((x) => Incidencia.fromJson(x)));

String incidenciaToJson(List<Incidencia> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Incidencia {
  Incidencia({
    this.id,
    this.depart,
    this.numOrden,
    this.ficha,
    this.queja,
    this.whatcause,
    this.whycause,
    this.solucionwhat,
    this.productos,
    this.costoparts,
    this.cantbad,
    this.departResponsed,
    this.usersResponsed,
    this.idKeyImage,
    this.userCreated,
    this.dateCurrent,
    this.date,
    this.isFinished,
    this.nameClose,
    this.logo,
  });

  String? id;
  String? depart;
  String? numOrden;
  String? ficha;
  String? queja;
  String? whatcause;
  String? whycause;
  String? solucionwhat;
  String? productos;
  String? costoparts;
  String? cantbad;
  String? departResponsed;
  String? usersResponsed;
  String? idKeyImage;
  String? userCreated;
  String? dateCurrent;
  String? date;
  String? isFinished;
  String? nameClose;
  String? logo;

  factory Incidencia.fromJson(Map<String, dynamic> json) => Incidencia(
        id: json["id"],
        depart: json["depart"],
        numOrden: json["num_orden"],
        ficha: json["ficha"],
        queja: json["queja"],
        whatcause: json["whatcause"],
        whycause: json["whycause"],
        solucionwhat: json["solucionwhat"],
        productos: json["productos"],
        costoparts: json["costoparts"],
        cantbad: json["cantbad"],
        departResponsed: json["depart_responsed"],
        usersResponsed: json["users_responsed"],
        idKeyImage: json["id_key_image"],
        userCreated: json["user_created"],
        dateCurrent: json["date_current"],
        date: json["date"],
        isFinished: json["is_finished"],
        nameClose: json["name_close"],
        logo: json['logo'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "depart": depart,
        "num_orden": numOrden,
        "ficha": ficha,
        "queja": queja,
        "whatcause": whatcause,
        "whycause": whycause,
        "solucionwhat": solucionwhat,
        "productos": productos,
        "costoparts": costoparts,
        "cantbad": cantbad,
        "depart_responsed": departResponsed,
        "users_responsed": usersResponsed,
        "id_key_image": idKeyImage,
        "user_created": userCreated,
        "date_current": dateCurrent,
        "date": date,
        "is_finished": isFinished,
        "name_close": nameClose,
        "logo": logo
      };
}
