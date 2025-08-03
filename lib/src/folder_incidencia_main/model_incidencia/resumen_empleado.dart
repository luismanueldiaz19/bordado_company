// To parse this JSON data, do
//
//     final resumenEmpleado = resumenEmpleadoFromJson(jsonString);

import 'dart:convert';

List<ResumenEmpleado> resumenEmpleadoFromJson(String str) =>
    List<ResumenEmpleado>.from(
        json.decode(str).map((x) => ResumenEmpleado.fromJson(x)));

String resumenEmpleadoToJson(List<ResumenEmpleado> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResumenEmpleado {
  String? empleado;
  String? cantidadIncidencias;
  String? departamento;
  String? mes;
  String? costoTotalProductos;

  ResumenEmpleado(
      {this.empleado,
      this.cantidadIncidencias,
      this.departamento,
      this.mes,
      this.costoTotalProductos});

  factory ResumenEmpleado.fromJson(Map<String, dynamic> json) =>
      ResumenEmpleado(
          empleado: json["empleado"],
          cantidadIncidencias: json["cantidad_incidencias"],
          costoTotalProductos: json['costo_total_productos'],
          departamento: json["departamento"],
          mes: json['mes']);

  Map<String, dynamic> toJson() => {
        "empleado": empleado,
        "cantidad_incidencias": cantidadIncidencias,
        "departamento": departamento,
        "mes": mes,
        "costo_total_productos": costoTotalProductos
      };
}
