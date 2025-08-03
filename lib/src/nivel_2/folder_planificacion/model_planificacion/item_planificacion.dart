// To parse this JSON data, do
//
//     final planificacionItem = planificacionItemFromJson(jsonString);

import 'dart:convert';

List<PlanificacionItem> planificacionItemFromJson(String str) =>
    List<PlanificacionItem>.from(
        json.decode(str).map((x) => PlanificacionItem.fromJson(x)));

String planificacionItemToJson(List<PlanificacionItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlanificacionItem {
  String? id;
  String? numOrden;
  String? nameLogo;
  String? ficha;
  String? isKeyUniqueProduct;
  String? tipoProduct;
  String? cant;
  String? department;
  String? fechaStart;
  String? fechaEnd;
  String? isDone;
  String? isCalidad;
  String? isWorking;
  String? statu;
  String? userDoneOrden;
  String? comment;
  String? priority;

  PlanificacionItem(
      {this.id,
      this.numOrden,
      this.nameLogo,
      this.ficha,
      this.isKeyUniqueProduct,
      this.tipoProduct,
      this.cant,
      this.department,
      this.fechaStart,
      this.fechaEnd,
      this.isDone,
      this.isCalidad,
      this.isWorking,
      this.statu,
      this.userDoneOrden,
      this.comment,
      this.priority});

  PlanificacionItem copyWith({
    String? id,
    String? numOrden,
    String? nameLogo,
    String? ficha,
    String? isKeyUniqueProduct,
    String? tipoProduct,
    String? cant,
    String? department,
    String? fechaStart,
    String? fechaEnd,
    String? isDone,
    String? isCalidad,
    String? isWorking,
    String? statu,
    String? userDoneOrden,
    String? comment,
    String? priority,
  }) =>
      PlanificacionItem(
        id: id ?? this.id,
        numOrden: numOrden ?? this.numOrden,
        nameLogo: nameLogo ?? this.nameLogo,
        ficha: ficha ?? this.ficha,
        isKeyUniqueProduct: isKeyUniqueProduct ?? this.isKeyUniqueProduct,
        tipoProduct: tipoProduct ?? this.tipoProduct,
        cant: cant ?? this.cant,
        department: department ?? this.department,
        fechaStart: fechaStart ?? this.fechaStart,
        fechaEnd: fechaEnd ?? this.fechaEnd,
        isDone: isDone ?? this.isDone,
        isCalidad: isCalidad ?? this.isCalidad,
        isWorking: isWorking ?? this.isWorking,
        statu: statu ?? this.statu,
        userDoneOrden: userDoneOrden ?? this.userDoneOrden,
        comment: comment ?? this.comment,
        priority: priority ?? this.priority,
        //priority
      );

  factory PlanificacionItem.fromJson(Map<String, dynamic> json) =>
      PlanificacionItem(
        id: json["id"],
        numOrden: json["num_orden"],
        nameLogo: json["name_logo"],
        ficha: json["ficha"],
        isKeyUniqueProduct: json["is_key_unique_product"],
        tipoProduct: json["tipo_product"],
        cant: json["cant"],
        department: json["department"],
        fechaStart: json["fecha_start"],
        fechaEnd: json["fecha_end"],
        isDone: json["is_done"],
        isCalidad: json["is_calidad"],
        isWorking: json["is_working"],
        statu: json["statu"],
        userDoneOrden: json["user_done_orden"],
        comment: json["comment"],
        priority: json["priority"] ?? 'normal',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "num_orden": numOrden,
        "name_logo": nameLogo,
        "ficha": ficha,
        "is_key_unique_product": isKeyUniqueProduct,
        "tipo_product": tipoProduct,
        "cant": cant,
        "department": department,
        "fecha_start": fechaStart,
        "fecha_end": fechaEnd,
        "is_done": isDone,
        "is_calidad": isCalidad,
        "is_working": isWorking,
        "statu": statu,
        "user_done_orden": userDoneOrden,
        "comment": comment,
        "priority": priority,
      };

      
  static List<String> getUniqueDepartmentList(List<PlanificacionItem> list) {
    return list.map((element) => element.department!).toSet().toList();
  }

  static List<String> getUniquePriorityList(List<PlanificacionItem> list) {
    return list.map((element) => element.priority!).toSet().toList();
  }

  static List<String> getUniqueNumOrden(List<PlanificacionItem> list) {
    return list.map((element) => element.numOrden!).toSet().toList();
  }

  static String getGetTotal(List<PlanificacionItem> list) {
    double value = 0.0;
    for (var element in list) {
      value += double.parse(element.cant ?? '0.0');
    }
    return value.toStringAsFixed(0);
  }

  static bool comparaTime(DateTime time1) {
    DateTime fecha2 = DateTime.now();
    DateTime soloFecha = DateTime(fecha2.year, fecha2.month, fecha2.day - 1);
    return soloFecha.isBefore(time1);
  }

  // static bool getFinishedOrden(List<PlanificacionItem> item) {
  //   // Recorrer cada elemento en la lista
  //   for (var element in item) {
  //     // Si se encuentra un elemento con isDone igual a 't', retorna false
  //     if (element.isDone != 'f') {
  //       return true; // Detiene el recorrido y retorna false
  //     }
  //   }
  //   // Si no se encontró ningún elemento con isDone igual a 't', retorna true
  //   return false;
  // }

  static bool getIsTrabajando(PlanificacionItem item) {
    return item.isWorking == 'f';
  }

  static bool getIsCalidad(PlanificacionItem item) {
    return item.isCalidad == 'f' && item.isWorking == 't';
  }

  static bool getIsTerminado(PlanificacionItem item) {
    return item.isDone == 'f' && item.isCalidad == 't' && item.isWorking == 't';
  }

  static bool getIsDone(PlanificacionItem item) {
    return item.isDone == 't' && item.isCalidad == 't' && item.isWorking == 't';
  }
}
