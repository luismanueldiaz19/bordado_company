// To parse this JSON data, do
//
//     final machine = machineFromJson(jsonString);

import 'dart:convert';

List<Machine> machineFromJson(String str) =>
    List<Machine>.from(json.decode(str).map((x) => Machine.fromJson(x)));

String machineToJson(List<Machine> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Machine {
  Machine({
    this.id,
    this.numberMachine,
    this.idModulo,
    this.nameModulo,
    this.isStop,
    this.statu,
    this.serial,
    this.modelo,
    this.fabricante,
    this.year,
  });

  String? id;
  String? numberMachine;
  String? idModulo;
  String? nameModulo;
  String? isStop;
  String? statu;
  String? serial;
  String? modelo;
  String? fabricante;
  String? year;

  factory Machine.fromJson(Map<String, dynamic> json) => Machine(
        id: json["id"],
        numberMachine: json["number_machine"],
        idModulo: json["id_modulo"],
        nameModulo: json["name_modulo"],
        isStop: json["is_stop"],
        statu: json["statu"],
        serial: json["serial"],
        modelo: json["modelo"],
        fabricante: json["fabricante"],
        year: json["year"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "number_machine": numberMachine,
        "id_modulo": idModulo,
        "name_modulo": nameModulo,
        "is_stop": isStop,
        "statu": statu,
        "serial": serial,
        "modelo": modelo,
        "fabricante": fabricante,
        "year": year,
      };
}
