// To parse this JSON data, do
//
//     final bordadoReportTiradas = bordadoReportTiradasFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../util/get_time_relation.dart';

List<BordadoReportTiradas> bordadoReportTiradasFromJson(String str) =>
    List<BordadoReportTiradas>.from(
        json.decode(str).map((x) => BordadoReportTiradas.fromJson(x)));

String bordadoReportTiradasToJson(List<BordadoReportTiradas> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BordadoReportTiradas {
  String? id;
  String? idUser;
  String? fullName;
  String? idKeyUnique;
  String? idMachine;
  String? machine;
  String? veloz;
  String? cantElabored;
  String? fechaStarted;
  String? fechaEnd;
  String? comment;
  String? isCalidad;
  String? cantBad;
  String? puntada;
  String? nameLogo;
  String? ficha;
  String? numOrden;
  String? isFinished;
  String? cantOrden;

  BordadoReportTiradas({
    this.id,
    this.idUser,
    this.fullName,
    this.idKeyUnique,
    this.idMachine,
    this.machine,
    this.veloz,
    this.cantElabored,
    this.fechaStarted,
    this.fechaEnd,
    this.comment,
    this.isCalidad,
    this.cantBad,
    this.puntada,
    this.nameLogo,
    this.ficha,
    this.numOrden,
    this.isFinished,
    this.cantOrden,
  });

  factory BordadoReportTiradas.fromJson(Map<String, dynamic> json) =>
      BordadoReportTiradas(
        id: json["id"],
        idUser: json["id_user"],
        fullName: json["full_name"],
        idKeyUnique: json["id_key_unique"],
        idMachine: json["id_machine"],
        machine: json["machine"],
        veloz: json["veloz"],
        cantElabored: json["cant_elabored"],
        fechaStarted: json["fecha_started"],
        fechaEnd: json["fecha_end"],
        comment: json["comment"],
        isCalidad: json["is_calidad"],
        cantBad: json["cant_bad"],
        puntada: json["puntada"],
        nameLogo: json["name_logo"],
        ficha: json["ficha"],
        numOrden: json["num_orden"],
        isFinished: json["is_finished"],
        cantOrden: json["cant_orden"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "full_name": fullName,
        "id_key_unique": idKeyUnique,
        "id_machine": idMachine,
        "machine": machine,
        "veloz": veloz,
        "cant_elabored": cantElabored,
        "fecha_started": fechaStarted,
        "fecha_end": fechaEnd,
        "comment": comment,
        "is_calidad": isCalidad,
        "cant_bad": cantBad,
        "puntada": puntada,
        "name_logo": nameLogo,
        "ficha": ficha,
        "num_orden": numOrden,
        "is_finished": isFinished,
        "cant_orden": cantOrden,
      };

  ///optimizada
  static List<String> depurarObjectsFullName(List<BordadoReportTiradas> list) {
    Set<String> objectoSet = list.map((element) => element.fullName!).toSet();
    List<String> listTake = objectoSet.toList();
    return listTake;
  }

  ///optimizada
  static List<String> depurarObjectsMachine(List<BordadoReportTiradas> list) {
    Set<String> objectoSet = list.map((element) => element.machine!).toSet();
    List<String> listTake = objectoSet.toList();
    return listTake;
  }

  static int calcularTotalPieza(List<BordadoReportTiradas> list) {
    int value = 0;
    for (var element in list) {
      value = value += int.parse(element.cantElabored ?? '0');
    }
    return value;
  }

  static int calcularTotalPuntada(List<BordadoReportTiradas> list) {
    int value = 0;
    for (var element in list) {
      value = value += int.parse(element.puntada ?? '0');
    }
    return value;
  }

  static int calcularTotalMala(List<BordadoReportTiradas> list) {
    int value = 0;
    for (var element in list) {
      value = value += int.parse(element.cantBad ?? '0');
    }
    return value;
  }

  static String getTimeR(List<BordadoReportTiradas> list) {
    Duration sumaDurationTime = const Duration();
    // double minut = 0.0;
    for (var element in list) {
      Duration durationTime = getTimeRelationDuration(
          element.fechaStarted ?? 'N/A', element.fechaEnd ?? 'N/A');

      if (durationTime != 'N/A') {
        sumaDurationTime += durationTime;
      }
    }
    // print('minute  Promedio : $minut');
    return sumaDurationTime.toString().substring(0, 10);
  }

  static getTotalBad(List<BordadoReportTiradas> list) {
    int totalBadpcs = 0;
    for (var element in list) {
      totalBadpcs += int.parse(element.cantBad ?? '0');
    }
    return '$totalBadpcs';
  }

  String getTotal(List<BordadoReportTiradas> list) {
    int totalElaborad = 0;
    for (var element in list) {
      totalElaborad += int.parse(element.cantElabored ?? '0');
    }
    return '$totalElaborad';
  }

  String getTotalElaborada(List<BordadoReportTiradas> list) {
    int totalOrdenPcs = 0;
    for (var element in list) {
      totalOrdenPcs += int.parse(element.cantElabored ?? '0');
    }
    return '$totalOrdenPcs';
  }

  static bool getValidarMalos(BordadoReportTiradas report) {
    if (double.parse(report.cantBad ?? '0') > 0) {
      return true;
    }
    return false;
  }

  static String getTotalPiezaPuntada(
      List<BordadoReportTiradas> list, String fullName, String machine) {
    int total = 0;

    List<BordadoReportTiradas> listLocal = list
        .where((element) =>
            element.fullName!.toUpperCase() == fullName.toUpperCase() &&
            element.machine!.toUpperCase() == machine.toUpperCase())
        .toList();

    for (var element in listLocal) {
      total += int.parse(element.puntada ?? '0');
    }
    return total.toString();
  }

  static String getTotalPieza(
      List<BordadoReportTiradas> list, String fullName, String machine) {
    int total = 0;

    List<BordadoReportTiradas> listLocal = list
        .where((element) =>
            element.fullName!.toUpperCase() == fullName.toUpperCase() &&
            element.machine!.toUpperCase() == machine.toUpperCase())
        .toList();

    for (var element in listLocal) {
      total += int.parse(element.cantElabored ?? '0');
    }
    return total.toString();
  }

  static Color getColor(BordadoReportTiradas report) {
    return Colors.white54;
  }
}
