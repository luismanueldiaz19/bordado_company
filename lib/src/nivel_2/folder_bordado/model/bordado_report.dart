// To parse this JSON data, do
//
//     final bordadoReport = bordadoReportFromJson(jsonString);

import 'dart:convert';

import '/src/util/get_time_relation.dart';

List<BordadoReport> bordadoReportFromJson(String str) =>
    List<BordadoReport>.from(
        json.decode(str).map((x) => BordadoReport.fromJson(x)));

String bordadoReportToJson(List<BordadoReport> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BordadoReport {
  String? id;
  String? idKeyUnique;
  String? userWorked;
  String? fullName;
  String? turn;
  String? type;
  String? nameLogo;
  String? numOrden;
  String? ficha;
  String? cantElabored;
  String? cantOrden;
  String? puntada;
  String? idMachine;
  String? machine;
  String? statu;
  String? veloz;
  String? fechaGeneralStarted;
  String? fechaGeneralEnd;
  String? isPause;
  String? comment;
  String? cantBad;
  String? isFinished;

  BordadoReport({
    this.id,
    this.idKeyUnique,
    this.userWorked,
    this.fullName,
    this.turn,
    this.type,
    this.nameLogo,
    this.numOrden,
    this.ficha,
    this.cantElabored,
    this.cantOrden,
    this.puntada,
    this.idMachine,
    this.machine,
    this.statu,
    this.veloz,
    this.fechaGeneralStarted,
    this.fechaGeneralEnd,
    this.isPause,
    this.comment,
    this.cantBad,
    this.isFinished,
  });

  BordadoReport copyWith({
    String? id,
    String? idKeyUnique,
    String? userWorked,
    String? fullName,
    String? turn,
    String? type,
    String? nameLogo,
    String? numOrden,
    String? ficha,
    String? cantElabored,
    String? cantOrden,
    String? puntada,
    String? idMachine,
    String? machine,
    String? statu,
    String? veloz,
    String? fechaGeneralStarted,
    String? fechaGeneralEnd,
    String? isPause,
    String? comment,
    String? cantBad,
    String? isFinished,
  }) =>
      BordadoReport(
        id: id ?? this.id,
        idKeyUnique: idKeyUnique ?? this.idKeyUnique,
        userWorked: userWorked ?? this.userWorked,
        fullName: fullName ?? this.fullName,
        turn: turn ?? this.turn,
        type: type ?? this.type,
        nameLogo: nameLogo ?? this.nameLogo,
        numOrden: numOrden ?? this.numOrden,
        ficha: ficha ?? this.ficha,
        cantElabored: cantElabored ?? this.cantElabored,
        cantOrden: cantOrden ?? this.cantOrden,
        puntada: puntada ?? this.puntada,
        idMachine: idMachine ?? this.idMachine,
        machine: machine ?? this.machine,
        statu: statu ?? this.statu,
        veloz: veloz ?? this.veloz,
        fechaGeneralStarted: fechaGeneralStarted ?? this.fechaGeneralStarted,
        fechaGeneralEnd: fechaGeneralEnd ?? this.fechaGeneralEnd,
        isPause: isPause ?? this.isPause,
        comment: comment ?? this.comment,
        cantBad: cantBad ?? this.cantBad,
        isFinished: isFinished ?? this.isFinished,
      );

  factory BordadoReport.fromJson(Map<String, dynamic> json) => BordadoReport(
        id: json["id"],
        idKeyUnique: json["id_key_unique"],
        userWorked: json["user_worked"],
        fullName: json["full_name"],
        turn: json["turn"],
        type: json["type"],
        nameLogo: json["name_logo"],
        numOrden: json["num_orden"],
        ficha: json["ficha"],
        cantElabored: json["cant_elabored"],
        cantOrden: json["cant_orden"],
        puntada: json["puntada"],
        idMachine: json["id_machine"],
        machine: json["machine"],
        statu: json["statu"],
        veloz: json["veloz"],
        fechaGeneralStarted: json["fecha_general_started"],
        fechaGeneralEnd: json["fecha_general_end"],
        isPause: json["is_pause"],
        comment: json["comment"],
        cantBad: json["cant_bad"],
        isFinished: json["is_finished"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_key_unique": idKeyUnique,
        "user_worked": userWorked,
        "full_name": fullName,
        "turn": turn,
        "type": type,
        "name_logo": nameLogo,
        "num_orden": numOrden,
        "ficha": ficha,
        "cant_elabored": cantElabored,
        "cant_orden": cantOrden,
        "puntada": puntada,
        "id_machine": idMachine,
        "machine": machine,
        "statu": statu,
        "veloz": veloz,
        "fecha_general_started": fechaGeneralStarted,
        "fecha_general_end": fechaGeneralEnd,
        "is_pause": isPause,
        "comment": comment,
        "cant_bad": cantBad,
        "is_finished": isFinished,
      };

  ///optimizada
  static List<String> depurarObjectsFullName(List<BordadoReport> list) {
    Set<String> objectoSet = list.map((element) => element.fullName!).toSet();
    List<String> listTake = objectoSet.toList();
    return listTake;
  }

  ///optimizada
  static List<String> depurarObjectsMachine(List<BordadoReport> list) {
    Set<String> objectoSet = list.map((element) => element.machine!).toSet();
    List<String> listTake = objectoSet.toList();
    return listTake;
  }

  static int calcularQTYOrden(List<BordadoReport> list) {
    int value = 0;
    for (var element in list) {
      value = value += int.parse(element.cantOrden ?? '0');
    }
    return value;
  }

  static int calcularTotalPieza(List<BordadoReport> list) {
    int value = 0;
    for (var element in list) {
      value = value += int.parse(element.cantElabored ?? '0');
    }
    return value;
  }

  static int calcularTotalPuntada(List<BordadoReport> list) {
    int value = 0;
    for (var element in list) {
      value += int.parse(element.puntada ?? '0') *
          int.parse(element.cantOrden ?? '0');
    }
    return value;
  }

  static int getPuntadas(List<BordadoReport> list) {
    int value = 0;
    for (var element in list) {
      value += int.parse(element.puntada ?? '0');
    }
    return value;
  }

  static int calcularTotalPuntadaRealizadas(List<BordadoReport> list) {
    int value = 0;
    for (var element in list) {
      value += int.parse(element.puntada ?? '0') *
          int.parse(element.cantElabored ?? '0');
    }
    return value;
  }

  static int calcularTotalMala(List<BordadoReport> list) {
    int value = 0;
    for (var element in list) {
      value = value += int.parse(element.cantBad ?? '0');
    }
    return value;
  }

  static int calcularPuntadaPorPieza(BordadoReport item) {
    int value = 0;

    value =
        int.parse(item.cantElabored ?? '0') * int.parse(item.puntada ?? '0');

    return value;
  }

  static String getTimeR(List<BordadoReport> list) {
    Duration sumaDurationTime = const Duration();
    // double minut = 0.0;
    for (var element in list) {
      Duration durationTime = getTimeRelationDuration(
          element.fechaGeneralStarted ?? 'N/A',
          element.fechaGeneralEnd ?? 'N/A');

      if (durationTime != 'N/A') {
        sumaDurationTime += durationTime;
      }
    }
    // print('minute  Promedio : $minut');
    return sumaDurationTime.toString().substring(0, 10);
  }

  static double calcularPorcentaje(String valor1, String valor2) {
    // Convertir los valores de texto a números
    double num1 = double.tryParse(valor1) ??
        0; // Si no se puede convertir, se asigna cero
    double num2 = double.tryParse(valor2) ??
        0; // Si no se puede convertir, se asigna cero

    // Calcular el porcentaje
    double porcentaje = (num1 / num2) * 100;

    // Validar si el porcentaje es infinito
    if (porcentaje.isInfinite) {
      print('Error: El porcentaje es infinito');
      return 0.0;
    }

    // Devolver el resultado
    return porcentaje;
  }

  static double restar(String valor1, String valor2) {
    // Convertir los valores de texto a números
    double num1 = double.tryParse(valor1) ??
        0; // Si no se puede convertir, se asigna cero
    double num2 = double.tryParse(valor2) ??
        0; // Si no se puede convertir, se asigna cero

    // Realizar la resta
    double resultado = num1 - num2;

    // Devolver el resultado
    return resultado;
  }
}
