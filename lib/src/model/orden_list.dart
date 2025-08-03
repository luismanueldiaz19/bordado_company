// To parse this JSON data, do
//
//     final ordenList = ordenListFromJson(jsonString);

import 'dart:convert';

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
}
