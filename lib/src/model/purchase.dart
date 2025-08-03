// To parse this JSON data, do
//
//     final purchases = purchasesFromJson(jsonString);

import 'dart:convert';

List<Purchases> purchasesFromJson(String str) =>
    List<Purchases>.from(json.decode(str).map((x) => Purchases.fromJson(x)));

String purchasesToJson(List<Purchases> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Purchases {
  String? purchasesId;
  String? fechaCompra;
  String? usuario;
  String? proveedor;
  String? numFactura;
  String? total;
  String? estado;
  String? nota;

  List<PurchasesItem>? purchasesItems;

  Purchases(
      {this.purchasesId,
      this.fechaCompra,
      this.usuario,
      this.total,
      this.estado,
      this.purchasesItems,
      this.proveedor,
      this.numFactura,
      this.nota});

  factory Purchases.fromJson(Map<String, dynamic> json) => Purchases(
        purchasesId: json["purchases_id"],
        fechaCompra: json["fecha_compra"],
        usuario: json["usuario"],
        total: json["total"],
        estado: json["estado"],
        proveedor: json['proveedor'],
        numFactura: json['num_factura'],
        purchasesItems: json["purchases_items"] == null
            ? []
            : List<PurchasesItem>.from(
                json["purchases_items"]!.map((x) => PurchasesItem.fromJson(x))),
        nota: json['nota'],
      );

  Map<String, dynamic> toJson() => {
        "purchases_id": purchasesId ?? '151',
        "fecha_compra": fechaCompra,
        "usuario": usuario,
        "total": total,
        "estado": estado,
        "proveedor": proveedor,
        "num_factura": numFactura,
        "purchases_items": purchasesItems == null
            ? []
            : List<dynamic>.from(purchasesItems!.map((x) => x.toJson())),
        "nota": nota,
      };

  static String getTotalCant(List<Purchases> collection) {
    double totalOrden = 0.0;

    for (var element in collection) {
      double? subtotal = double.tryParse(element.total.toString());
      totalOrden += subtotal ?? 0.0; // Si subtotal es null, suma 0
    }

    return totalOrden.toStringAsFixed(2);
  }
}

class PurchasesItem {
  String? purchaseDetailid;
  String? idProduct;
  String? nameProduct;
  String? cantidad;
  String? precioUnitario;
  String? subtotal;

  PurchasesItem({
    this.purchaseDetailid,
    this.idProduct,
    this.nameProduct,
    this.cantidad,
    this.precioUnitario,
    this.subtotal,
  });

  factory PurchasesItem.fromJson(Map<String, dynamic> json) => PurchasesItem(
        purchaseDetailid: json["purchase_detail_id"],
        idProduct: json["id_product"],
        nameProduct: json["name_product"],
        cantidad: json["cantidad"],
        precioUnitario: json["precio_unitario"],
        subtotal: json["subtotal"],
      );

  Map<String, dynamic> toJson() => {
        "purchase_detail_id": purchaseDetailid,
        "id_product": idProduct,
        "name_product": nameProduct,
        "cantidad": cantidad,
        "precio_unitario": precioUnitario,
        "subtotal": subtotal,
      };
  static String getTotalCant(List<PurchasesItem> collection) {
    double totalOrden = 0.0;

    for (var element in collection) {
      double? subtotal = double.tryParse(element.subtotal.toString());
      totalOrden += subtotal ?? 0.0; // Si subtotal es null, suma 0
    }

    return totalOrden.toStringAsFixed(2);
  }

  static String getTotalQty(List<PurchasesItem> collection) {
    double totalOrden = 0.0;

    for (var element in collection) {
      double? subtotal = double.tryParse(element.cantidad.toString());
      totalOrden += subtotal ?? 0.0; // Si subtotal es null, suma 0
    }

    return totalOrden.toStringAsFixed(2);
  }
}
