class ColorProducto {
  final String colorId;
  final String nombreColor;
  final String hexCode;

  ColorProducto({
    required this.colorId,
    required this.nombreColor,
    required this.hexCode,
  });

  factory ColorProducto.fromJson(Map<String, dynamic> json) {
    return ColorProducto(
      colorId: json['color_id'],
      nombreColor: json['nombre_color'],
      hexCode: json['hex_code'],
    );
  }
}

class TallaProducto {
  final String tallaId;
  final String nombreTalla;

  TallaProducto({
    required this.tallaId,
    required this.nombreTalla,
  });

  factory TallaProducto.fromJson(Map<String, dynamic> json) {
    return TallaProducto(
      tallaId: json['talla_id'],
      nombreTalla: json['nombre_talla'],
    );
  }
}

class Producto {
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
  final List<ColorProducto> colores;
  final List<TallaProducto> tallas;

  Producto({
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

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      productoId: json['producto_id'],
      rutaImagen: json['ruta_imagen'],
      secuenciaNum: json['secuencia_num'],
      descripcion: json['descripcion'],
      precioVenta: json['precio_venta'],
      precioOferta: json['precio_oferta'],
      precioMayorista: json['precio_mayorista'],
      linea: json['linea'],
      material: json['material'],
      subCategoria: json['sub_categoria'],
      marca: json['marca'],
      colores: (json['colores'] as List)
          .map((e) => ColorProducto.fromJson(e))
          .toList(),
      tallas: (json['tallas'] as List)
          .map((e) => TallaProducto.fromJson(e))
          .toList(),
    );
  }
}
