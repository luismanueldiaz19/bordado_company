// To parse this JSON data, do
//
//     final confeccion = confeccionFromJson(jsonString);

import 'dart:convert';

import '../../../util/get_time_relation.dart';

List<Confeccion> confeccionFromJson(String str) =>
    List<Confeccion>.from(json.decode(str).map((x) => Confeccion.fromJson(x)));

String confeccionToJson(List<Confeccion> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Confeccion {
  Confeccion(
      {this.id,
      this.idUser,
      this.fullName,
      this.turn,
      this.idDepart,
      this.nameDepartment,
      this.numOrden,
      this.ficha,
      this.nameLogo,
      this.tipoTrabajo,
      this.cantPieza,
      this.dateStart,
      this.dateEnd,
      this.date,
      this.statu,
      this.isDelivery,
      this.idUserIsDelivery,
      this.idCalidad,
      this.comment,
      this.semana});

  String? id;
  String? idUser;
  String? fullName;
  String? turn;
  String? idDepart;
  String? nameDepartment;
  String? numOrden;
  String? ficha;
  String? nameLogo;
  String? tipoTrabajo;
  String? cantPieza;
  String? dateStart;
  String? dateEnd;
  String? date;
  String? statu;
  String? isDelivery;
  String? idUserIsDelivery;
  String? idCalidad;
  String? comment;
  String? semana;

  factory Confeccion.fromJson(Map<String, dynamic> json) => Confeccion(
      id: json["id"] ?? '0',
      idUser: json["id_user"] ?? '0',
      fullName: json["full_name"] ?? '0',
      turn: json["turn"] ?? '0',
      idDepart: json["id_depart"] ?? '0',
      nameDepartment: json["name_department"] ?? '0',
      numOrden: json["num_orden"] ?? '0',
      ficha: json["ficha"] ?? '0',
      nameLogo: json["name_logo"] ?? '0',
      tipoTrabajo: json["tipo_trabajo"] ?? '0',
      cantPieza: json["cant_pieza"] ?? '0',
      dateStart: json["date_start"] ?? '0',
      dateEnd: json["date_end"] ?? '0',
      date: json["date"] ?? '0',
      statu: json["statu"] ?? '0',
      isDelivery: json["is_delivery"] ?? '0',
      idUserIsDelivery: json["id_user_is_delivery"] ?? '0',
      idCalidad: json["id_calidad"] ?? '0',
      comment: json['comment'] ?? '0',
      semana: json['semana'] ?? 'N/A');

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "full_name": fullName,
        "turn": turn,
        "id_depart": idDepart,
        "name_department": nameDepartment,
        "num_orden": numOrden,
        "ficha": ficha,
        "name_logo": nameLogo,
        "tipo_trabajo": tipoTrabajo,
        "cant_pieza": cantPieza,
        "date_start": dateStart,
        "date_end": dateEnd,
        "date": date,
        "statu": statu,
        "is_delivery": isDelivery,
        "id_user_is_delivery": idUserIsDelivery,
        "id_calidad": idCalidad,
        "comment": comment,
        "semana": semana,
      };

  static String getTotalListPiezas(List<Confeccion> items) {
    int subTotal = 0;
    for (var item in items) {
      subTotal += int.parse(item.cantPieza ?? '0');
    }
    return subTotal.toString();
  }

  static bool getValidatorCant(Confeccion items) {
    return double.parse(items.cantPieza ?? '0') > 0 ? true : false;
  }

  static String getTimeR(List<Confeccion> list) {
    Duration sumaDurationTime = const Duration();
    // double minut = 0.0;
    for (var element in list) {
      Duration durationTime = getTimeRelationDuration(
          element.dateStart ?? 'N/A', element.dateEnd ?? 'N/A');

      if (durationTime != 'N/A') {
        sumaDurationTime += durationTime;
      }
    }
    // print('minute  Promedio : $minut');
    return sumaDurationTime.toString().substring(0, 10);
  }
}
