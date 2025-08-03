// To parse this JSON data, do
//
//     final listWorkSublimacion = listWorkSublimacionFromJson(jsonString);

import 'dart:convert';

List<ListWorkSublimacion> listWorkSublimacionFromJson(String str) =>
    List<ListWorkSublimacion>.from(
        json.decode(str).map((x) => ListWorkSublimacion.fromJson(x)));

String listWorkSublimacionToJson(List<ListWorkSublimacion> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListWorkSublimacion {
  String? idListWork;
  String? idDepartListWork;
  String? codeListWork;
  DateTime? dateStartListWork;
  String? dateEndListWork;
  String? idKeyWorkListWork;
  String? registerBy;
  List<Item>? items;

  ListWorkSublimacion({
    this.idListWork,
    this.idDepartListWork,
    this.codeListWork,
    this.dateStartListWork,
    this.dateEndListWork,
    this.idKeyWorkListWork,
    this.registerBy,
    this.items,
  });

  ListWorkSublimacion copyWith({
    String? idListWork,
    String? idDepartListWork,
    String? codeListWork,
    DateTime? dateStartListWork,
    String? dateEndListWork,
    String? idKeyWorkListWork,
    String? registerBy,
    List<Item>? items,
  }) =>
      ListWorkSublimacion(
        idListWork: idListWork ?? this.idListWork,
        idDepartListWork: idDepartListWork ?? this.idDepartListWork,
        codeListWork: codeListWork ?? this.codeListWork,
        dateStartListWork: dateStartListWork ?? this.dateStartListWork,
        dateEndListWork: dateEndListWork ?? this.dateEndListWork,
        idKeyWorkListWork: idKeyWorkListWork ?? this.idKeyWorkListWork,
        items: items ?? this.items,
        registerBy: registerBy ?? this.registerBy,
      );

  factory ListWorkSublimacion.fromJson(Map<String, dynamic> json) =>
      ListWorkSublimacion(
        registerBy: json['register_by'],
        idListWork: json["id_list_work"],
        idDepartListWork: json["id_depart_list_work"],
        codeListWork: json["code_list_work"],
        dateStartListWork: json["date_start_list_work"] == null
            ? null
            : DateTime.parse(json["date_start_list_work"]),
        dateEndListWork: json["date_end_list_work"],
        idKeyWorkListWork: json["id_key_work_list_work"],
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id_list_work": idListWork,
        "register_by": registerBy,
        "id_depart_list_work": idDepartListWork,
        "code_list_work": codeListWork,
        "date_start_list_work": dateStartListWork?.toIso8601String(),
        "date_end_list_work": dateEndListWork,
        "id_key_work_list_work": idKeyWorkListWork,
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Item {
  String? idSublimacionWork;
  String? idDepartSublimacionWork;
  String? codeUserSublimacionWork;
  String? numOrdenSublimacionWork;
  String? typeWorkSublimacionWork;
  String? dateStartSublimacionWork;
  String? dateEndSublimacionWork;
  String? statuSublimacionWork;
  String? fichaSublimacionWork;
  String? cantPiezaSublimacionWork;
  String? cantOrdenSublimacionWork;
  String? nameLogoSublimacionWork;
  String? pFull;
  String? typeWork;
  String? pkt;

  Item({
    this.idSublimacionWork,
    this.idDepartSublimacionWork,
    this.codeUserSublimacionWork,
    this.numOrdenSublimacionWork,
    this.typeWorkSublimacionWork,
    this.dateStartSublimacionWork,
    this.dateEndSublimacionWork,
    this.statuSublimacionWork,
    this.fichaSublimacionWork,
    this.cantPiezaSublimacionWork,
    this.cantOrdenSublimacionWork,
    this.nameLogoSublimacionWork,
    this.pFull,
    this.pkt,
    this.typeWork,
  });

  Item copyWith({
    String? idSublimacionWork,
    String? idDepartSublimacionWork,
    String? codeUserSublimacionWork,
    String? numOrdenSublimacionWork,
    String? typeWorkSublimacionWork,
    String? dateStartSublimacionWork,
    String? dateEndSublimacionWork,
    String? statuSublimacionWork,
    String? fichaSublimacionWork,
    String? cantPiezaSublimacionWork,
    String? cantOrdenSublimacionWork,
    String? nameLogoSublimacionWork,
    String? pFull,
    String? typeWork,
    String? pkt,
  }) =>
      Item(
        idSublimacionWork: idSublimacionWork ?? this.idSublimacionWork,
        idDepartSublimacionWork:
            idDepartSublimacionWork ?? this.idDepartSublimacionWork,
        codeUserSublimacionWork:
            codeUserSublimacionWork ?? this.codeUserSublimacionWork,
        numOrdenSublimacionWork:
            numOrdenSublimacionWork ?? this.numOrdenSublimacionWork,
        typeWorkSublimacionWork:
            typeWorkSublimacionWork ?? this.typeWorkSublimacionWork,
        dateStartSublimacionWork:
            dateStartSublimacionWork ?? this.dateStartSublimacionWork,
        dateEndSublimacionWork:
            dateEndSublimacionWork ?? this.dateEndSublimacionWork,
        statuSublimacionWork: statuSublimacionWork ?? this.statuSublimacionWork,
        fichaSublimacionWork: fichaSublimacionWork ?? this.fichaSublimacionWork,
        cantPiezaSublimacionWork:
            cantPiezaSublimacionWork ?? this.cantPiezaSublimacionWork,
        cantOrdenSublimacionWork:
            cantOrdenSublimacionWork ?? this.cantOrdenSublimacionWork,
        nameLogoSublimacionWork:
            nameLogoSublimacionWork ?? this.nameLogoSublimacionWork,
        pFull: pFull ?? this.pFull,
        pkt: pkt ?? this.pkt,
        typeWork: typeWork ?? this.typeWork,
      );

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        idSublimacionWork: json["id_sublimacion_work"],
        idDepartSublimacionWork: json["id_depart_sublimacion_work"],
        codeUserSublimacionWork: json["code_user_sublimacion_work"],
        numOrdenSublimacionWork: json["num_orden_sublimacion_work"],
        typeWorkSublimacionWork: json["type_work_sublimacion_work"],
        dateStartSublimacionWork: json["date_start_sublimacion_work"],
        dateEndSublimacionWork: json["date_end_sublimacion_work"],
        statuSublimacionWork: json["statu_sublimacion_work"],
        fichaSublimacionWork: json["ficha_sublimacion_work"],
        cantPiezaSublimacionWork: json["cant_pieza_sublimacion_work"],
        cantOrdenSublimacionWork: json["cant_orden_sublimacion_work"],
        nameLogoSublimacionWork: json["name_logo_sublimacion_work"],
        pFull: json["p_full"],
        pkt: json['pkt'],
        typeWork: json["type_work"],
      );

  Map<String, dynamic> toJson() => {
        "id_sublimacion_work": idSublimacionWork,
        "id_depart_sublimacion_work": idDepartSublimacionWork,
        "code_user_sublimacion_work": codeUserSublimacionWork,
        "num_orden_sublimacion_work": numOrdenSublimacionWork,
        "type_work_sublimacion_work": typeWorkSublimacionWork,
        "date_start_sublimacion_work": dateStartSublimacionWork,
        "date_end_sublimacion_work": dateEndSublimacionWork,
        "statu_sublimacion_work": statuSublimacionWork,
        "ficha_sublimacion_work": fichaSublimacionWork,
        "cant_pieza_sublimacion_work": cantPiezaSublimacionWork,
        "cant_orden_sublimacion_work": cantOrdenSublimacionWork,
        "name_logo_sublimacion_work": nameLogoSublimacionWork,
        "p_full": pFull,
        "pkt": pkt,
        "type_work": typeWork,
      };

  static String getTotal(List<Item> collection) {
    double totalOrden = 0.0;

    for (var element in collection) {
      totalOrden += int.parse(element.cantPiezaSublimacionWork.toString());
    }
    return totalOrden.toStringAsFixed(0);
  }

  static bool isFinished(Item item) {
    return item.statuSublimacionWork == 't';
  }

  static bool isFinishedValidator(List<Item> collection) {
    // Verifica si todos los elementos tienen 'N/A' en el campo dateEndSublimacionWork
    return collection
        .every((element) => element.dateEndSublimacionWork != 'N/A');
  }
}
