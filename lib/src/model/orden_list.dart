// To parse this JSON data, do
//
//     final ordenList = ordenListFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

import '../folder_cliente_company/model_cliente/cliente.dart';
import 'orden_item.dart';

List<OrdenList> ordenListFromJson(String str) =>
    List<OrdenList>.from(json.decode(str).map((x) => OrdenList.fromJson(x)));

String ordenListToJson(List<OrdenList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrdenList {
  String? planificacionWorkId;
  String? nameDepartment;
  String? ficha;
  String? numOrden;
  String? nameLogo;
  String? fechaEntrega;
  String? estadoPrioritario;
  String? idCliente;
  String? nombre;
  String? nameProducto;
  String? cant;
  String? detallesProductos;
  String? ordenItemsId;
  dynamic nota;
  String? estadoProduccion;
  String? fechaItemCreacion;
  String? idDepart;
  String? estadoPlanificacionWork;

  String? listOrdenesId;
  String? fechaCreacion;
  String? estadoGeneral;
  String? estadoEntrega;
  String? observaciones;
  String? usuarioId;
  String? fullName;
  Cliente? cliente;

  List<OrdenItem>? ordenItem;

  OrdenList({
    this.planificacionWorkId,
    this.nameDepartment,
    this.ficha,
    this.numOrden,
    this.nameLogo,
    this.fechaEntrega,
    this.estadoPrioritario,
    this.idCliente,
    this.nombre,
    this.nameProducto,
    this.cant,
    this.detallesProductos,
    this.ordenItemsId,
    this.nota,
    this.estadoProduccion,
    this.fechaItemCreacion,
    this.idDepart,
    this.estadoPlanificacionWork,
    this.listOrdenesId,
    this.fechaCreacion,
    this.estadoGeneral,
    this.estadoEntrega,
    this.observaciones,
    this.usuarioId,
    this.cliente,
    this.ordenItem,
    this.fullName,
  });

  factory OrdenList.fromJson(Map<String, dynamic> json) => OrdenList(
        planificacionWorkId: json["planificacion_work_id"],
        nameDepartment: json["name_department"],
        ficha: json["ficha"],
        numOrden: json['num_orden'],
        nameLogo: json["name_logo"],
        fechaEntrega: json["fecha_entrega"],
        estadoPrioritario: json["estado_prioritario"],
        idCliente: json["id_cliente"],
        nombre: json["nombre"],
        nameProducto: json["name_producto"],
        cant: json["cant"],
        detallesProductos: json["detalles_productos"],
        ordenItemsId: json["orden_items_id"],
        nota: json["nota"],
        estadoProduccion: json["estado_produccion"],
        fechaItemCreacion: json["fecha_item_creacion"],
        idDepart: json["id_depart"],
        estadoPlanificacionWork: json["estado_planificacion_work"],
        listOrdenesId: json["list_ordenes_id"],
        fechaCreacion: json["fecha_creacion"],
        estadoGeneral: json["estado_general"],
        estadoEntrega: json["estado_entrega"],
        observaciones: json["observaciones"],
        usuarioId: json["usuario_id"],
        fullName: json['full_name'],
        cliente:
            json["cliente"] == null ? null : Cliente.fromJson(json["cliente"]),
        ordenItem: json["orden_item"] == null
            ? []
            : List<OrdenItem>.from(
                json["orden_item"]!.map((x) => OrdenItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "planificacion_work_id": planificacionWorkId,
        "name_department": nameDepartment,
        "ficha": ficha,
        "num_orden": numOrden,
        "name_logo": nameLogo,
        "fecha_entrega": fechaEntrega,
        "estado_prioritario": estadoPrioritario,
        "id_cliente": idCliente,
        "nombre": nombre,
        "name_producto": nameProducto,
        "cant": cant,
        "detalles_productos": detallesProductos,
        "orden_items_id": ordenItemsId,
        "nota": nota,
        "estado_produccion": estadoProduccion,
        "fecha_item_creacion": fechaItemCreacion,
        "id_depart": idDepart,
        "estado_planificacion_work": estadoPlanificacionWork,
        "list_ordenes_id": listOrdenesId,
        "fecha_creacion": fechaCreacion,
        "estado_general": estadoGeneral,
        "estado_entrega": estadoEntrega,
        "observaciones": observaciones,
        "usuario_id": usuarioId,
        "cliente": cliente?.toJson(),
        "full_name": fullName,
        "orden_item": ordenItem == null
            ? []
            : List<dynamic>.from(ordenItem!.map((x) => x.toJson())),
      };

  static List<String> getUniqueDepartmentList(List<OrdenList> list) {
    return list.map((element) => element.nameDepartment!).toSet().toList();
  }

  static List<String> getUniquePriorityList(List<OrdenList> list) {
    return list.map((element) => element.estadoPrioritario!).toSet().toList();
  }

  static List<String> getUniqueNumOrden(List<OrdenList> list) {
    return list.map((element) => element.numOrden!).toSet().toList();
  }

  static String getGetTotal(List<OrdenList> list) {
    double value = 0.0;
    for (var element in list) {
      value += double.parse(element.cant ?? '0.0');
    }
    return value.toStringAsFixed(0);
  }

  static Color getColor(OrdenList planificacion) {
    // if (planificacion.estadoGeneral == onProducion) {
    //   return Colors.cyan.shade100;
    // }
    // if (planificacion.statu == onEntregar) {
    //   return Colors.orange.shade100;
    // }
    // if (planificacion.statu == onParada) {
    //   return Colors.redAccent.shade200;
    // }
    // if (planificacion.statu == onProceso) {
    //   return Colors.teal.shade200;
    // }
    // if (planificacion.statu == onFallo) {
    //   return Colors.black54;
    // }
    // if (planificacion.statu == onDone) {
    //   return Colors.green.shade200;
    // }
    return Colors.white;
  }
}
