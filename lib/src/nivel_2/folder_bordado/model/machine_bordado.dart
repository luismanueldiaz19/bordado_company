// To parse this JSON data, do
//
//     final machineBordado = machineBordadoFromJson(jsonString);

import 'dart:convert';

List<MachineBordado> machineBordadoFromJson(String str) =>
    List<MachineBordado>.from(
        json.decode(str).map((x) => MachineBordado.fromJson(x)));

String machineBordadoToJson(List<MachineBordado> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MachineBordado {
  String? idMachine;
  String? machine;
  String? veloz;
  String? statu;

  MachineBordado({
    this.idMachine,
    this.machine,
    this.veloz,
    this.statu,
  });

  MachineBordado copyWith({
    String? idMachine,
    String? machine,
    String? veloz,
    String? statu,
  }) =>
      MachineBordado(
        idMachine: idMachine ?? this.idMachine,
        machine: machine ?? this.machine,
        veloz: veloz ?? this.veloz,
        statu: statu ?? this.statu,
      );

  factory MachineBordado.fromJson(Map<String, dynamic> json) => MachineBordado(
        idMachine: json["id_machine"],
        machine: json["machine"],
        veloz: json["veloz"],
        statu: json["statu"],
      );

  Map<String, dynamic> toJson() => {
        "id_machine": idMachine,
        "machine": machine,
        "veloz": veloz,
        "statu": statu,
      };
}
