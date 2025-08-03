// To parse this JSON data, do
//
//     final planificacionLast = planificacionLastFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../datebase/current_data.dart';

List<PlanificacionLast> planificacionLastFromJson(String str) =>
    List<PlanificacionLast>.from(
        json.decode(str).map((x) => PlanificacionLast.fromJson(x)));

String planificacionLastToJson(List<PlanificacionLast> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlanificacionLast {
  String? id;
  String? userRegistroOrden;
  String? userEntregaOrden;
  String? cliente;
  String? clienteTelefono;
  String? nameLogo;
  String? numOrden;
  String? ficha;
  String? fechaStart;
  String? fechaEntrega;
  String? isEntregado;
  String? comment;
  String? isKeyUniqueProduct;
  String? dateDelivered;
  String? statu;
  String? balance;
  String? llamada;
  String? isValidateBalance;
  String? priority;

  PlanificacionLast(
      {this.id,
      this.userRegistroOrden,
      this.userEntregaOrden,
      this.cliente,
      this.clienteTelefono,
      this.nameLogo,
      this.numOrden,
      this.ficha,
      this.fechaStart,
      this.fechaEntrega,
      this.isEntregado,
      this.comment,
      this.isKeyUniqueProduct,
      this.dateDelivered,
      this.statu,
      this.balance,
      this.llamada,
      this.isValidateBalance,
      this.priority});


  factory PlanificacionLast.fromJson(Map<String, dynamic> json) =>
      PlanificacionLast(
          id: json["id"],
          userRegistroOrden: json["user_registro_orden"],
          userEntregaOrden: json["user_entrega_orden"],
          cliente: json["cliente"],
          clienteTelefono: json["cliente_telefono"],
          nameLogo: json["name_logo"],
          numOrden: json["num_orden"],
          ficha: json["ficha"],
          fechaStart: json["fecha_start"],
          fechaEntrega: json["fecha_entrega"],
          isEntregado: json["is_entregado"],
          comment: json["comment"],
          isKeyUniqueProduct: json["is_key_unique_product"],
          dateDelivered: json['date_delivered'],
          statu: json['statu'],
          balance: json['balance'],
          llamada: json['llamada'],
          isValidateBalance: json['is_validate_balance'],
          priority: json['priority'] ?? 'normal');

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_registro_orden": userRegistroOrden,
        "user_entrega_orden": userEntregaOrden,
        "cliente": cliente,
        "cliente_telefono": clienteTelefono,
        "name_logo": nameLogo,
        "num_orden": numOrden,
        "ficha": ficha,
        "fecha_start": fechaStart,
        "fecha_entrega": fechaEntrega,
        "is_entregado": isEntregado,
        "comment": comment,
        "is_key_unique_product": isKeyUniqueProduct,
        "date_delivered": dateDelivered,
        "statu": statu,
        "balance": balance,
        "llamada": llamada,
        "is_validate_balance": isValidateBalance,
        "priority": priority ?? 'normal'
      };


 static String totalOrdenEntregar(List<PlanificacionLast> list) {
    var listll = List.from(list
        .where((x) => x.statu!.toUpperCase() == onEntregar.toUpperCase())
        .toList());

    return listll.length.toString();
  }

  ///obtener quien registra la orden
  static List<String> depurarRegistradorOrden(List<PlanificacionLast> list) {
    Set<String> objectoSet =
        list.map((element) => element.userRegistroOrden!).toSet();
    return objectoSet.toList();
  }

  ///obtener quien registra la orden
  static List<String> depurraEstadoOrden(List<PlanificacionLast> list) {
    Set<String> objectoSet = list.map((element) => element.statu!).toSet();
    return objectoSet.toList();
  }

  static bool comparaTime(DateTime time1) {
    // Creamos las dos fechas a comparar
    DateTime fecha2 = DateTime.now();
    DateTime soloFecha = DateTime(fecha2.year, fecha2.month, fecha2.day - 1);
    if (soloFecha.isAfter(time1)) {
      return true;
    } else {
      return false;
    }
  }

  static Color getColorIsBalancePaid(PlanificacionLast planificacion) {
    return planificacion.isValidateBalance == 't'
        ? Colors.blueAccent
        : Colors.black;
  }

  static Color getColor(PlanificacionLast planificacion) {
    if (planificacion.statu == onProducion) {
      return Colors.cyan.shade100;
    }
    if (planificacion.statu == onEntregar) {
      return Colors.orange.shade100;
    }
    if (planificacion.statu == onParada) {
      return Colors.redAccent.shade200;
    }
    if (planificacion.statu == onProceso) {
      return Colors.teal.shade200;
    }
    if (planificacion.statu == onFallo) {
      return Colors.black54;
    }
    if (planificacion.statu == onDone) {
      return Colors.green.shade200;
    }
    return Colors.white;
  }

  static bool getColorsAtradas(PlanificacionLast listss) {
    return PlanificacionLast.comparaTime(
                DateTime.parse(listss.fechaEntrega ?? '')) &&
            listss.statu?.toUpperCase() != onEntregar.toUpperCase()
        ? false
        : true;
  }

  static String getBalanceTotal(List<PlanificacionLast> listss) {
    double value = 0;
    for (var item in listss) {
      value += double.parse(item.balance ?? '0.0');
    }
    return value.toStringAsFixed(2);
  }

  static List<PlanificacionLast> getTotalAtrasadaList(
      List<PlanificacionLast> listss) {
    List<PlanificacionLast> value = [];
    for (var item in listss) {
      if (PlanificacionLast.comparaTime(
              DateTime.parse(item.fechaEntrega ?? '')) &&
          item.statu?.toUpperCase() != onEntregar.toUpperCase()) {
        value.add(item);
      }
    }
    return value;
  }
  static  String getTotalAtrasada(List<PlanificacionLast> listss) {
    int value = 0;
    for (var item in listss) {
      if (PlanificacionLast.comparaTime(
              DateTime.parse(item.fechaEntrega ?? '')) &&
          item.statu?.toUpperCase() != onEntregar.toUpperCase()) {
        value++;
      }
    }
    return value.toString();
  }

}
