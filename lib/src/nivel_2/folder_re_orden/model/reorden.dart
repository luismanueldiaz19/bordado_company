// To parse this JSON data, do
//
//     final reOrden = reOrdenFromJson(jsonString);

import 'dart:convert';

List<ReOrden> reOrdenFromJson(String str) =>
    List<ReOrden>.from(json.decode(str).map((x) => ReOrden.fromJson(x)));

String reOrdenToJson(List<ReOrden> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReOrden {
  String? id;
  String? logo;
  String? numOrden;
  String? ficha;
  String? reorden;
  String? created;
  String? usuario;
  String? comment;
  String? balance;
  String? infoCliente;

  ReOrden({
    this.id,
    this.logo,
    this.numOrden,
    this.ficha,
    this.reorden,
    this.created,
    this.usuario,
    this.comment,
    this.balance,
    this.infoCliente,
  });

  factory ReOrden.fromJson(Map<String, dynamic> json) => ReOrden(
        id: json["id"],
        logo: json["logo"],
        numOrden: json["num_orden"],
        ficha: json["ficha"],
        reorden: json["reorden"],
        created: json["created"],
        usuario: json["usuario"],
        comment: json["comment"],
        balance: json["balance"],
        infoCliente: json["info_cliente"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "logo": logo,
        "num_orden": numOrden,
        "ficha": ficha,
        "reorden": reorden,
        "created": created,
        "usuario": usuario,
        "comment": comment,
        "balance": balance,
        "info_cliente": infoCliente,
      };

  static String getBalanceTotal(List<ReOrden> listss) {
    double value = 0;
    for (var item in listss) {
      value += double.parse(item.balance ?? '0.0');
    }
    return value.toStringAsFixed(2);
  }
}
