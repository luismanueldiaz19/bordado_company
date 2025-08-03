// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';


List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//  id_product |             name_product             | price_product | created_at | stock | minimo | maximo

class Product {
  String? idProducto;
  String? nameProducto;
  String? priceProduct;
  String? createdAt;
  String? stock;
  String? minimo;
  String? maximo;
  String? priceTwo;
  String? priceThree;
  String? costo;
  String? referencia;
  String? originalPrice; // ← precio original interno

  Product({
    this.idProducto,
    this.nameProducto,
    this.priceProduct,
    this.createdAt,
    this.stock,
    this.minimo,
    this.maximo,
    this.priceTwo,
    this.priceThree,
    this.costo,
    this.referencia,
    this.originalPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        idProducto: json["id_producto"],
        nameProducto: json["name_producto"],
        priceProduct: json["price_product"],
        createdAt: json["created_at"],
        stock: json["stock"],
        minimo: json["minimo"],
        maximo: json["maximo"],
        priceTwo: json["price_two"],
        priceThree: json["price_three"],
        costo: json["costo"],
        referencia: json["referencia"],
      );

  Map<String, dynamic> toJson() => {
        "id_producto": idProducto,
        "name_producto": nameProducto,
        "price_product": priceProduct,
        "created_at": createdAt,
        "stock": stock,
        "minimo": minimo,
        "maximo": maximo,
        "price_two": priceTwo,
        "price_three": priceThree,
        "costo": costo,
        "referencia": referencia,
      };
  static bool validatorStock(Product stock) {
    return double.parse(stock.stock ?? '0.0') > 0.0;
  }

  /// Método para calcular la cantidad que falta para llegar al máximo
  static double getCantidadParaCompletarMaximo(Product item) {
    // // print(item.toJson());

    // final double stockActual = double.parse(item.stock ?? '0') ?? 0.0;

    // // print('stockActual : $stockActual');
    // if (item.minimo == null || item.maximo == null) return 0;

    // if (stockActual < item.minimo!) {
    //   return item.maximo! - stockActual;
    // }
    return 0;
  }

  static bool necesitaReabastecer(Product item) {
    final double stockActual = double.tryParse(item.stock ?? '0') ?? 0.0;

    if (item.minimo == null) return false;

    // return stockActual < item.minimo!;

    return false;
  }

  static List<Product> filtrarProductosQueNecesitanReabastecer(
      List<Product> productos) {
    return productos
        .where((producto) => necesitaReabastecer(producto))
        .toList();
  }

  /// Devuelve el precio correspondiente al tier
}
