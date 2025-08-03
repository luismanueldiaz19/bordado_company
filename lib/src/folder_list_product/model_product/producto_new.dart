import 'dart:convert';

// Función para parsear desde el JSON completo (que contiene 'success' y 'productos')
List<Product> productFromJson(String str) {
  final jsonData = json.decode(str);
  if (jsonData['success'] != true) {
    return [];
  }
  return List<Product>.from(
      jsonData['productos'].map((x) => Product.fromJson(x)));
}

// Función para convertir la lista de productos a JSON (solo la lista, no el wrapper)
String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  final String productoId;
  final String rutaImagen;
  final String secuenciaNum;
  final String descripcion;
  final String precioVenta;
  final String precioOferta;
  final String precioMayorista;
  final String linea;
  final String material;
  final String subCategoria;
  final String marca;
  final List<ColorProduct> colores;
  final List<TallaProduct> tallas;

  Product({
    required this.productoId,
    required this.rutaImagen,
    required this.secuenciaNum,
    required this.descripcion,
    required this.precioVenta,
    required this.precioOferta,
    required this.precioMayorista,
    required this.linea,
    required this.material,
    required this.subCategoria,
    required this.marca,
    required this.colores,
    required this.tallas,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productoId: json["producto_id"],
        rutaImagen: json["ruta_imagen"],
        secuenciaNum: json["secuencia_num"],
        descripcion: json["descripcion"],
        precioVenta: json["precio_venta"],
        precioOferta: json["precio_oferta"],
        precioMayorista: json["precio_mayorista"],
        linea: json["linea"],
        material: json["material"],
        subCategoria: json["sub_categoria"],
        marca: json["marca"],
        colores: List<ColorProduct>.from(
            json["colores"].map((x) => ColorProduct.fromJson(x))),
        tallas: List<TallaProduct>.from(
            json["tallas"].map((x) => TallaProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "producto_id": productoId,
        "ruta_imagen": rutaImagen,
        "secuencia_num": secuenciaNum,
        "descripcion": descripcion,
        "precio_venta": precioVenta,
        "precio_oferta": precioOferta,
        "precio_mayorista": precioMayorista,
        "linea": linea,
        "material": material,
        "sub_categoria": subCategoria,
        "marca": marca,
        "colores": List<dynamic>.from(colores.map((x) => x.toJson())),
        "tallas": List<dynamic>.from(tallas.map((x) => x.toJson())),
      };
}

class ColorProduct {
  final String colorId;
  final String nombreColor;
  final String hexCode;

  ColorProduct({
    required this.colorId,
    required this.nombreColor,
    required this.hexCode,
  });

  factory ColorProduct.fromJson(Map<String, dynamic> json) => ColorProduct(
        colorId: json["color_id"],
        nombreColor: json["nombre_color"],
        hexCode: json["hex_code"],
      );

  Map<String, dynamic> toJson() => {
        "color_id": colorId,
        "nombre_color": nombreColor,
        "hex_code": hexCode,
      };
}

class TallaProduct {
  final String tallaId;
  final String nombreTalla;

  TallaProduct({
    required this.tallaId,
    required this.nombreTalla,
  });

  factory TallaProduct.fromJson(Map<String, dynamic> json) => TallaProduct(
        tallaId: json["talla_id"],
        nombreTalla: json["nombre_talla"],
      );

  Map<String, dynamic> toJson() => {
        "talla_id": tallaId,
        "nombre_talla": nombreTalla,
      };
}
