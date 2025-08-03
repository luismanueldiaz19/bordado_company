// To parse this JSON data, do
//
//     final bordadoTirada = bordadoTiradaFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

List<BordadoTirada> bordadoTiradaFromJson(String str) =>
    List<BordadoTirada>.from(
        json.decode(str).map((x) => BordadoTirada.fromJson(x)));

String bordadoTiradaToJson(List<BordadoTirada> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BordadoTirada {
  String? id;
  String? idUser;
  String? fullName;
  String? idKeyUnique;
  String? numOrden;
  String? nameLogo;
  String? ficha;
  String? cantBad;
  String? cantElabored;
  String? cantOrden;
  String? generalElabored;
  String? fechaStarted;
  String? fechaEnd;
  String? comment;
  String? isPause;
  String? isCalidad;
  String? status;

  BordadoTirada({
    this.id,
    this.idUser,
    this.fullName,
    this.idKeyUnique,
    this.numOrden,
    this.nameLogo,
    this.ficha,
    this.cantBad,
    this.cantElabored,
    this.cantOrden,
    this.generalElabored,
    this.fechaStarted,
    this.fechaEnd,
    this.comment,
    this.isCalidad,
    this.isPause,
    this.status,
  });

  BordadoTirada copyWith({
    String? id,
    String? idUser,
    String? fullName,
    String? idKeyUnique,
    String? numOrden,
    String? nameLogo,
    String? ficha,
    String? cantBad,
    String? cantElabored,
    String? cantOrden,
    String? generalElabored,
    String? fechaStarted,
    String? fechaEnd,
    String? comment,
    String? isCalidad,
    String? status,
  }) =>
      BordadoTirada(
        id: id ?? this.id,
        idUser: idUser ?? this.idUser,
        fullName: fullName ?? this.fullName,
        idKeyUnique: idKeyUnique ?? this.idKeyUnique,
        numOrden: numOrden ?? this.numOrden,
        nameLogo: nameLogo ?? this.nameLogo,
        ficha: ficha ?? this.ficha,
        cantBad: cantBad ?? this.cantBad,
        cantElabored: cantElabored ?? this.cantElabored,
        cantOrden: cantOrden ?? this.cantOrden,
        generalElabored: generalElabored ?? this.generalElabored,
        fechaStarted: fechaStarted ?? this.fechaStarted,
        fechaEnd: fechaEnd ?? this.fechaEnd,
        comment: comment ?? this.comment,
        isCalidad: isCalidad ?? this.isCalidad,
        status: status ?? this.status,
      );

  factory BordadoTirada.fromJson(Map<String, dynamic> json) => BordadoTirada(
        id: json["id"] ?? '0',
        idUser: json["id_user"] ?? '0',
        fullName: json["full_name"] ?? '0',
        idKeyUnique: json["id_key_unique"] ?? '0',
        numOrden: json["num_orden"] ?? '0',
        nameLogo: json["name_logo"] ?? '0',
        ficha: json["ficha"] ?? '0',
        cantBad: json["cant_bad"] ?? '0',
        cantElabored: json["cant_elabored"] ?? '0',
        cantOrden: json["cant_orden"] ?? '0',
        generalElabored: json["general_elabored"] ?? '0',
        fechaStarted: json["fecha_started"] ?? '0',
        fechaEnd: json["fecha_end"] ?? '0',
        comment: json["comment"] ?? '0',
        isCalidad: json["is_calidad"] ?? '0',
        status: json["status"] ?? 't',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "full_name": fullName,
        "id_key_unique": idKeyUnique,
        "num_orden": numOrden,
        "name_logo": nameLogo,
        "ficha": ficha,
        "cant_bad": cantBad,
        "cant_elabored": cantElabored,
        "cant_orden": cantOrden,
        "general_elabored": generalElabored,
        "fecha_started": fechaStarted,
        "fecha_end": fechaEnd,
        "comment": comment,
        "is_calidad": isCalidad,
        "status": status,
      };
  static String getTotalBad(List<BordadoTirada> list) {
    int totalBadpcs = 0;
    for (var element in list) {
      totalBadpcs += int.parse(element.cantBad ?? '0');
    }
    return '$totalBadpcs';
  }

  static String getTotal(List<BordadoTirada> list) {
    int totalElaborad = 0;
    for (var element in list) {
      totalElaborad += int.parse(element.cantElabored ?? '0');
    }
    return '$totalElaborad';
  }

  static String getTotalElaborada(List<BordadoTirada> list) {
    int totalOrdenPcs = 0;
    for (var element in list) {
      totalOrdenPcs += int.parse(element.cantElabored ?? '0');
    }
    return '$totalOrdenPcs';
  }

  static getColorComparar(BordadoTirada local, BordadoTirada item) {
    if (local == item) {
      return Colors.green.shade100;
    }

    return Colors.white;
  }

  static bool validadNumber(String numero) {
    return double.parse(numero) <= 0;
  }
}
