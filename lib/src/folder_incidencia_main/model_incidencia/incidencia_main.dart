// To parse this JSON data, do
//
//     final incidenciaMain = incidenciaMainFromJson(jsonString);

import 'dart:convert';

List<IncidenciaMain> incidenciaMainFromJson(String str) =>
    List<IncidenciaMain>.from(
        json.decode(str).map((x) => IncidenciaMain.fromJson(x)));

String incidenciaMainToJson(List<IncidenciaMain> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IncidenciaMain {
  String? idListIncidencia;
  String? ficha;
  String? numOrden;
  String? logo;
  String? ubicacionQueja;
  String? departmentFind;
  String? whatHapped;
  String? compromiso;
  String? estado;
  String? createdAt;
  String? registedBy;
  String? fechaResuelto;
  List<ListProduct>? listProducts;
  List<ListUsuarioResponsable>? listUsuarioResponsable;
  List<ListImagene>? listImagenes;
  List<ListDepartamentoResponsable>? listDepartamentoResponsable;

  IncidenciaMain({
    this.idListIncidencia,
    this.ficha,
    this.numOrden,
    this.logo,
    this.ubicacionQueja,
    this.departmentFind,
    this.whatHapped,
    this.compromiso,
    this.estado,
    this.createdAt,
    this.registedBy,
    this.fechaResuelto,
    this.listProducts,
    this.listUsuarioResponsable,
    this.listImagenes,
    this.listDepartamentoResponsable,
  });

  factory IncidenciaMain.fromJson(Map<String, dynamic> json) => IncidenciaMain(
        idListIncidencia: json["id_list_incidencia"],
        ficha: json["ficha"],
        numOrden: json["num_orden"],
        logo: json["logo"],
        ubicacionQueja: json["ubicacion_queja"],
        departmentFind: json["department_find"],
        whatHapped: json["what_happed"],
        compromiso: json["compromiso"],
        estado: json["estado"],
        createdAt: json["created_at"],
        registedBy: json["registed_by"],
        fechaResuelto: json["fecha_resuelto"],
        listProducts: json["list_products"] == null
            ? []
            : List<ListProduct>.from(
                json["list_products"]!.map((x) => ListProduct.fromJson(x))),
        listUsuarioResponsable: json["list_usuario_responsable"] == null
            ? []
            : List<ListUsuarioResponsable>.from(
                json["list_usuario_responsable"]!
                    .map((x) => ListUsuarioResponsable.fromJson(x))),
        listImagenes: json["list_imagenes"] == null
            ? []
            : List<ListImagene>.from(
                json["list_imagenes"]!.map((x) => ListImagene.fromJson(x))),
        listDepartamentoResponsable:
            json["list_departamento_responsable"] == null
                ? []
                : List<ListDepartamentoResponsable>.from(
                    json["list_departamento_responsable"]!
                        .map((x) => ListDepartamentoResponsable.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id_list_incidencia": idListIncidencia,
        "ficha": ficha,
        "num_orden": numOrden,
        "logo": logo,
        "ubicacion_queja": ubicacionQueja,
        "department_find": departmentFind,
        "what_happed": whatHapped,
        "compromiso": compromiso,
        "estado": estado,
        "created_at": createdAt,
        "registed_by": registedBy,
        "fecha_resuelto": fechaResuelto,
        "list_products": listProducts == null
            ? []
            : List<dynamic>.from(listProducts!.map((x) => x.toJson())),
        "list_usuario_responsable": listUsuarioResponsable == null
            ? []
            : List<dynamic>.from(
                listUsuarioResponsable!.map((x) => x.toJson())),
        "list_imagenes": listImagenes == null
            ? []
            : List<dynamic>.from(listImagenes!.map((x) => x.toJson())),
        "list_departamento_responsable": listDepartamentoResponsable == null
            ? []
            : List<dynamic>.from(
                listDepartamentoResponsable!.map((x) => x.toJson())),
      };
}

class ListDepartamentoResponsable {
  String? idIncidenciaResponsableDepartment;
  String? departmentResponsable;
  String? createdAt;
  String? idListIncidencia;

  ListDepartamentoResponsable({
    this.idIncidenciaResponsableDepartment,
    this.departmentResponsable,
    this.createdAt,
    this.idListIncidencia,
  });

  factory ListDepartamentoResponsable.fromJson(Map<String, dynamic> json) =>
      ListDepartamentoResponsable(
        idIncidenciaResponsableDepartment:
            json["id_incidencia_responsable_department"],
        departmentResponsable: json["department_responsable"],
        createdAt: json["created_at"],
        idListIncidencia: json["id_list_incidencia"],
      );

  Map<String, dynamic> toJson() => {
        "id_incidencia_responsable_department":
            idIncidenciaResponsableDepartment,
        "department_responsable": departmentResponsable,
        "created_at": createdAt,
        "id_list_incidencia": idListIncidencia,
      };
}

class ListImagene {
  String? idListImagenIncidencia;
  String? imagenPath;
  String? comentario;
  String? createdAt;
  String? idListIncidencia;

  ListImagene({
    this.idListImagenIncidencia,
    this.imagenPath,
    this.comentario,
    this.createdAt,
    this.idListIncidencia,
  });

  factory ListImagene.fromJson(Map<String, dynamic> json) => ListImagene(
        idListImagenIncidencia: json["id_list_imagen_incidencia"],
        imagenPath: json["imagen_path"],
        comentario: json["comentario"],
        createdAt: json["created_at"],
        idListIncidencia: json["id_list_incidencia"],
      );

  Map<String, dynamic> toJson() => {
        "id_list_imagen_incidencia": idListImagenIncidencia,
        "imagen_path": imagenPath,
        "comentario": comentario,
        "created_at": createdAt,
        "id_list_incidencia": idListIncidencia,
      };
}

class ListProduct {
  String? idArticulosIncidencia;
  String? nameProduct;
  int? costo;
  int? cant;
  String? createdAt;
  String? idListIncidencia;

  ListProduct({
    this.idArticulosIncidencia,
    this.nameProduct,
    this.costo,
    this.cant,
    this.createdAt,
    this.idListIncidencia,
  });

  factory ListProduct.fromJson(Map<String, dynamic> json) => ListProduct(
        idArticulosIncidencia: json["id_articulos_incidencia"],
        nameProduct: json["name_product"],
        costo: json["costo"],
        cant: json["cant"],
        createdAt: json["created_at"],
        idListIncidencia: json["id_list_incidencia"],
      );

  Map<String, dynamic> toJson() => {
        "id_articulos_incidencia": idArticulosIncidencia,
        "name_product": nameProduct,
        "costo": costo,
        "cant": cant,
        "created_at": createdAt,
        "id_list_incidencia": idListIncidencia,
      };

  static String getSubtotal(ListProduct item) {
    String value = '0';
    if (item.cant != null && item.costo != null) {
      value = (item.cant! * item.costo!).toStringAsFixed(2);
      return value;
    }
    return value;
  }
}

class ListUsuarioResponsable {
  String? idUsuarioResponsableIncidencia;
  String? fullName;
  String? code;
  String? createdAt;
  String? idListIncidencia;

  ListUsuarioResponsable({
    this.idUsuarioResponsableIncidencia,
    this.fullName,
    this.code,
    this.createdAt,
    this.idListIncidencia,
  });

  factory ListUsuarioResponsable.fromJson(Map<String, dynamic> json) =>
      ListUsuarioResponsable(
        idUsuarioResponsableIncidencia:
            json["id_usuario_responsable_incidencia"],
        fullName: json["full_name"],
        code: json["code"],
        createdAt: json["created_at"],
        idListIncidencia: json["id_list_incidencia"],
      );

  Map<String, dynamic> toJson() => {
        "id_usuario_responsable_incidencia": idUsuarioResponsableIncidencia,
        "full_name": fullName,
        "code": code,
        "created_at": createdAt,
        "id_list_incidencia": idListIncidencia,
      };
}
