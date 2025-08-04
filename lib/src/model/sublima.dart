// To parse this JSON data, do
//
//     final sublima = sublimaFromJson(jsonString);

import 'dart:convert';

List<Sublima> sublimaFromJson(String str) =>
    List<Sublima>.from(json.decode(str).map((x) => Sublima.fromJson(x)));

String sublimaToJson(List<Sublima> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Sublima {
  Sublima({
    this.id,
    this.codeUser,
    this.fullName,
    this.numOrden,
    this.typeWork,
    this.dateStart,
    this.dateEnd,
    this.idDepart,
    this.nameDepartment,
    this.statu,
    this.ficha,
    this.cantPieza,
    this.cantOrden,
    this.nameWork,
    this.turn,
    this.totalOrden,
    this.toTalDiferences,
    this.totalElaborado,
    this.percentRelation,
    this.nameLogo,
    this.pkt,
    this.dFull,
    this.colorfull,
    this.colorpkt,
    this.idKeyWork,
    this.totalTime,
    this.isRating,
    this.rating,
    this.nota,
    this.cantWork,
    this.imagenes,
  });

  String? id;
  String? colorfull;
  String? colorpkt;
  String? codeUser;
  String? fullName;
  String? numOrden;
  String? typeWork;
  String? dateStart;
  String? dateEnd;
  String? idDepart;
  String? nameDepartment;
  String? statu;
  String? ficha;
  String? cantPieza;
  String? cantOrden;
  String? nameWork;
  String? turn;
  String? toTalDiferences;
  String? totalOrden;
  String? totalElaborado;
  String? percentRelation;
  String? nameLogo;
  String? pkt;
  String? dFull;
  String? idKeyWork;
  String? totalTime;
  String? isRating;
  String? rating;
  String? nota;
  String? cantWork;
  List<Imagene>? imagenes;

  factory Sublima.fromJson(Map<String, dynamic> json) => Sublima(
        id: json["id"],
        codeUser: json["code_user"],
        fullName: json["full_name"],
        numOrden: json["num_orden"],
        typeWork: json["type_work"],
        dateStart: json["date_start"],
        dateEnd: json["date_end"],
        idDepart: json["id_depart"],
        nameDepartment: json["name_department"],
        statu: json["statu"],
        ficha: json["ficha"],
        cantPieza: json["cant_pieza"],
        cantOrden: json["cant_orden"],
        nameWork: json['name_work'],
        turn: json['turn'],
        nameLogo: json['name_logo'],
        pkt: json['pkt'],
        dFull: json['p_full'],
        colorfull: json['color_full'],
        colorpkt: json['color_pkt'],
        idKeyWork: json['id_key_work'],
        totalTime: json['total_time'],
        isRating: json['is_rating'],
        rating: json['rating'],
        nota: json['nota'],
        cantWork: json['cant_work'],
        imagenes: json["imagenes"] == null
            ? []
            : List<Imagene>.from(
                json["imagenes"]!.map((x) => Imagene.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? '0',
        "code_user": codeUser ?? '0',
        "full_name": fullName ?? 'N/A',
        "num_orden": numOrden ?? '0',
        "type_work": typeWork ?? 'N/A',
        "date_start": dateStart ?? 'N/A',
        "date_end": dateEnd ?? 'N/A',
        "id_depart": idDepart ?? '0',
        "name_department": nameDepartment ?? 'N/A',
        "statu": statu ?? 'N/A',
        "ficha": ficha ?? '0',
        "cant_pieza": cantPieza ?? '0',
        "cant_orden": cantOrden ?? '0',
        "name_work": typeWork ?? 'N/A',
        'turn': turn ?? 'Turno A',
        "name_logo": nameLogo ?? 'N/A',
        "pkt": pkt ?? '0',
        "p_full": dFull ?? '0',
        "color_full": colorfull ?? '0',
        "color_pkt": colorpkt ?? '0',
        "id_key_work": idKeyWork ?? '0',
        "total_time": totalTime ?? '0',
        "is_rating": isRating ?? 'f',
        "rating": rating ?? '0',
        "nota": nota ?? 'N/A',
        "cant_work": cantWork ?? '0',
        // "imagenes": imagenes == null
        //     ? []
        //     : List<dynamic>.from(imagenes!.map((x) => x.toJson())),
      };
  static bool isRatedWork(Sublima item) {
    return item.isRating == 'f' ? true : false;
  }

  static bool validaQtyOrden(Sublima item, String? value) {
    double orden = double.parse(item.cantOrden ?? '0');
    double request = double.parse(value ?? '0');
    return request <= orden ? false : true;
  }

  static String getTotalOrden(List<Sublima> collection) {
    double totalOrden = 0.0;

    for (var element in collection) {
      totalOrden += int.parse(element.cantOrden.toString());
    }
    return totalOrden.toStringAsFixed(0);
  }

  static String getTotalRealizado(List<Sublima> collection) {
    double totalOrden = 0.0;

    for (var element in collection) {
      totalOrden += int.parse(element.cantPieza.toString());
    }
    return totalOrden.toStringAsFixed(0);
  }

  static List<String> depurarTypeWork(List<Sublima> list) {
    Set<String> objectoSet = list.map((element) => element.nameWork!).toSet();
    return objectoSet.toList();
  }

  static List<String> depurarEmpleados(List<Sublima> list) {
    Set<String> objectoSet = list.map((element) => element.fullName!).toSet();
    return objectoSet.toList();
  }

  static String getTotalPiezaFullByNameWork(
      List<Sublima> collection, String name) {
    final totalOrden = getTotalFull(collection
        .where(
            (element) => element.nameWork?.toUpperCase() == name.toUpperCase())
        .toList());

    return totalOrden;
  }

  static String getTotalPiezaPKTByNameWork(
      List<Sublima> collection, String name) {
    final totalOrden = getTotalPKT(collection
        .where(
            (element) => element.nameWork?.toUpperCase() == name.toUpperCase())
        .toList());

    return totalOrden;
  }

  static String getTotalFull(List<Sublima> collection) {
    double totalOrden = 0.0;

    for (var element in collection) {
      totalOrden += int.parse(element.dFull.toString());
    }
    return totalOrden.toStringAsFixed(0);
  }

  static String getTotalPKT(List<Sublima> collection) {
    double totalOrden = 0.0;

    for (var element in collection) {
      totalOrden += int.parse(element.pkt.toString());
    }
    return totalOrden.toStringAsFixed(0);
  }
}

Map<String, Sublima> sumarCantidades(List<Sublima> lista) {
  Map<String, Sublima> resultado = {};

  for (var sublima in lista) {
    if (resultado.containsKey(sublima.numOrden)) {
      Sublima sublimaExistente = resultado[sublima.numOrden]!;
      int cantPiezaExistente = int.parse(sublimaExistente.cantPieza ?? '0');
      int cantPiezaNueva = int.parse(sublima.cantPieza ?? '0');
      sublimaExistente.cantPieza =
          (cantPiezaExistente + cantPiezaNueva).toString();
      resultado[sublima.numOrden ?? ''] = sublimaExistente;
    } else {
      resultado[sublima.numOrden ?? ''] = sublima;
    }
  }

  return resultado;
}

class ColorPikedWork {
  String? fullName;
  String? c0;
  String? c1;
  String? c2;
  String? c3;
  String? c4;
  String? c5;
  String? c6;

  ColorPikedWork(
      {this.fullName,
      this.c0,
      this.c1,
      this.c2,
      this.c3,
      this.c4,
      this.c5,
      this.c6});
}

class Imagene {
  String? imagePath;

  Imagene({
    this.imagePath,
  });

  factory Imagene.fromJson(Map<String, dynamic> json) => Imagene(
        imagePath: json["image_path"],
      );

  Map<String, dynamic> toJson() => {
        "image_path": imagePath,
      };
}
