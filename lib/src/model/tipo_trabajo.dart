import 'dart:convert';

List<TipoTrabajo> tipoTrabajoFromJson(String str) => List<TipoTrabajo>.from(
    json.decode(str).map((x) => TipoTrabajo.fromJson(x)));

String tipoTrabajoToJson(List<TipoTrabajo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TipoTrabajo {
  String? tipoTrabajoId;
  String? nameTrabajo;
  String? areaTrabajo;
  String? indexOrden;
  String? urlImagen;
  String? createdAt;
  List<Campo>? campos;

  TipoTrabajo({
    this.tipoTrabajoId,
    this.nameTrabajo,
    this.areaTrabajo,
    this.indexOrden,
    this.urlImagen,
    this.createdAt,
    this.campos,
  });

  factory TipoTrabajo.fromJson(Map<String, dynamic> json) => TipoTrabajo(
        tipoTrabajoId: json["tipo_trabajo_id"],
        nameTrabajo: json["name_trabajo"],
        areaTrabajo: json["area_trabajo"],
        indexOrden: json["index_orden"],
        urlImagen: json["url_imagen"],
        createdAt: json["created_at"],
        campos: json["campos"] == null
            ? []
            : List<Campo>.from(json["campos"].map((x) => Campo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tipo_trabajo_id": tipoTrabajoId,
        "name_trabajo": nameTrabajo,
        "area_trabajo": areaTrabajo,
        "index_orden": indexOrden,
        "url_imagen": urlImagen,
        "created_at": createdAt,
        "campos": campos == null
            ? []
            : List<dynamic>.from(campos!.map((x) => x.toJson())),
      };
  @override
  String toString() => nameTrabajo ?? 'N/A';
}

class Campo {
  String? campoId;
  String? hojaProduccionCamposId;
  String? nombreCampo;
  String? tipoDato;
  String? cant;
  String? cantOrden;

  Campo({
    this.campoId,
    this.nombreCampo,
    this.tipoDato,
    this.cant,
    this.cantOrden,
    this.hojaProduccionCamposId,
  });

  factory Campo.fromJson(Map<String, dynamic> json) => Campo(
        campoId: json["campo_id"],
        nombreCampo: json["nombre_campo"],
        tipoDato: json["tipo_dato"],
        cant: json['cant'],
        hojaProduccionCamposId: json["hoja_produccion_campos_id"],
        cantOrden: json['cant_orden'],
      );

  Map<String, dynamic> toJson() => {
        "campo_id": campoId,
        "nombre_campo": nombreCampo,
        "tipo_dato": tipoDato,
        "cant": cant,
        "cant_orden": cantOrden,
        "hoja_produccion_campos_id": hojaProduccionCamposId,
      };
}
