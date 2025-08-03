// To parse this JSON data, do
//
//     final printerPlan = printerPlanFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../util/commo_pallete.dart';

List<PrinterPlan> printerPlanFromJson(String str) => List<PrinterPlan>.from(
    json.decode(str).map((x) => PrinterPlan.fromJson(x)));

String printerPlanToJson(List<PrinterPlan> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PrinterPlan {
  final int? printerPlaningId;
  String? boceto;
  int? indexWork;
  String? nombreLogo;
  String? tipoTrabajo;
  int? cantidad;
  String? ficha;
  String? orden;
  String? asignado;
  String? comentario;
  String? estado;
  String? fechaTrabajo;
  String? creadoEn;
  String? nameDepart;
  String? diaSemana;

  PrinterPlan({
    this.printerPlaningId,
    this.boceto,
    this.indexWork,
    this.nombreLogo,
    this.tipoTrabajo,
    this.cantidad,
    this.ficha,
    this.orden,
    this.asignado,
    this.comentario,
    this.estado,
    this.fechaTrabajo,
    this.creadoEn,
    this.nameDepart,
    this.diaSemana,
  });

  factory PrinterPlan.fromJson(Map<String, dynamic> json) => PrinterPlan(
        printerPlaningId: int.tryParse(json["printer_planing_id"]) ?? 0,
        boceto: json["boceto"],
        indexWork: int.tryParse(json["index_work"]) ?? 0,
        nombreLogo: json["nombre_logo"],
        tipoTrabajo: json["tipo_trabajo"],
        cantidad: int.tryParse(json["cantidad"]) ?? 0,
        ficha: json["ficha"],
        orden: json["orden"],
        asignado: json["asignado"],
        comentario: json["comentario"],
        estado: json["estado"],
        fechaTrabajo: json["fecha_trabajo"],
        creadoEn: json["creado_en"],
        nameDepart: json['name_depart'],
        diaSemana: json['dia_semana'],
      );

  Map<String, String> toJson() => {
        "printer_planing_id": printerPlaningId.toString(),
        "boceto": boceto.toString(),
        "index_work": indexWork.toString(),
        "nombre_logo": nombreLogo.toString(),
        "tipo_trabajo": tipoTrabajo.toString(),
        "cantidad": cantidad.toString(),
        "ficha": ficha.toString(),
        "orden": orden.toString(),
        "asignado": asignado.toString(),
        "comentario": comentario.toString(),
        "estado": estado.toString(),
        "fecha_trabajo": fechaTrabajo.toString(),
        "creado_en": creadoEn.toString(),
        "name_depart": nameDepart.toString(),
        "dia_semana": diaSemana.toString(),
      };

  static Color getColorByEstado(String estado) {
    switch (estado.toUpperCase()) {
      case 'PROCESO':
      case 'EN PRODUCCION':
        return Colors.blue;
      case 'PARADO':
        return Colors.orange;
      case 'RETRASADO':
        return Colors.red;
      case 'URGENTE':
        return Colors.green;
      case 'PENDIENTE':
        return Colors.grey;
      case 'EN ESPERA':
        return Colors.grey;
      case 'TERMINADO':
        return Colors.black;
      default:
        return Colors.black;
    }
  }

  // 'Diseño',
  // 'Serigrafia',
  // 'Sastreria',
  // 'Bordado',
  // 'Confección',

  // 'Costura'

  // 🎯 Función de obtención de color
  static Color getColorByDepartment(String estado) {
    switch (estado.toUpperCase()) {
      case 'SUBLIMACIÓN':
      case 'SUBLIMACION': // por si viene sin tilde
        return turquesaSublimado;
      case 'PRINTER':
        return naranjaPrinter;
      case 'SASTRERIA':
        return verdeLimonSastreria;
      case 'CONFECCION':
        return lilaConfeccion;
      case 'BORDADO':
        return amarilloBordado;
      case 'SERIGRAFIA':
        return fucsiaSerigrafia;
      case 'COSTURA':
        return rojoCostura;
      case 'DISENO':
      case 'DISEÑO':
        return rojoCostura;
      default:
        return Colors.orange;
    }
  }

  static List<String> getDepartmentUnique(List<PrinterPlan> list) {
    return list.map((element) => element.nameDepart!).toSet().toList();
  }

  static List<String> getSemanaUnique(List<PrinterPlan> list) {
    return list.map((element) => element.diaSemana!).toSet().toList();
  }

  static List<String> getEstadoUnique(List<PrinterPlan> list) {
    return list.map((element) => element.estado!).toSet().toList();
  }

  static List<String> getFechaUnique(List<PrinterPlan> list) {
    return list.map((element) => element.fechaTrabajo!).toSet().toList();
  }
}
