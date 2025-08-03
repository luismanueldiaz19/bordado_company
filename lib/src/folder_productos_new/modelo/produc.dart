import '../../folder_list_product/model_product/producto_new.dart';

class Produc {
  final String? productoId;
  final String secuenciaNum;
  final int? lineaProductoId;
  final int? materialId;
  final int? subCategoriaId;
  final int? marcaId;
  final int? colorId;
  final int? tallaId;
  final String descripcion;
  final int cantidad;
  final double? precioVenta;
  final double? precioOferta;
  final double? precioMayorista;
  final List<ColorProduct> colores;
  final List<TallaProduct> tallas;

  Produc({
    this.productoId,
    this.secuenciaNum = 'N/A',
    this.lineaProductoId,
    this.materialId,
    this.subCategoriaId,
    this.marcaId,
    this.colorId,
    this.tallaId,
    required this.descripcion,
    this.cantidad = 0,
    this.precioVenta,
    this.precioOferta,
    this.precioMayorista,
    required this.colores,
    required this.tallas,
  });

  Map<String, dynamic> toJson() {
    return {
      'producto_id': productoId.toString(),
      'secuencia_num': secuenciaNum.toString(),
      'linea_producto_id': lineaProductoId.toString(),
      'material_id': materialId.toString(),
      'sub_categoria_id': subCategoriaId.toString(),
      'marca_id': marcaId.toString(),
      'color_id': colorId.toString(),
      'talla_id': tallaId.toString(),
      'descripcion': descripcion.toString(),
      'cantidad': cantidad.toString(),
      'precio_venta': precioVenta.toString(),
      'precio_oferta': precioOferta.toString(),
      'precio_mayorista': precioMayorista.toString(),
      "colores": List<dynamic>.from(colores.map((x) => x.toJson())),
      "tallas": List<dynamic>.from(tallas.map((x) => x.toJson())),
    };
  }

  factory Produc.fromJson(Map<String, dynamic> json) {
    return Produc(
      productoId: json['producto_id'],
      secuenciaNum: json['secuencia_num'] ?? 'N/A',
      lineaProductoId: json['linea_producto_id'],
      materialId: json['material_id'],
      subCategoriaId: json['sub_categoria_id'],
      marcaId: json['marca_id'],
      colorId: json['color_id'],
      tallaId: json['talla_id'],
      descripcion: json['descripcion'] ?? '',
      cantidad: json['cantidad'] ?? 0,
      precioVenta: (json['precio_venta'] as num?)?.toDouble(),
      precioOferta: (json['precio_oferta'] as num?)?.toDouble(),
      precioMayorista: (json['precio_mayorista'] as num?)?.toDouble(),
      colores: List<ColorProduct>.from(
          json["colores"].map((x) => ColorProduct.fromJson(x))),
      tallas: List<TallaProduct>.from(
          json["tallas"].map((x) => TallaProduct.fromJson(x))),
    );
  }
  @override
  String toString() => '${this.descripcion ?? 'N/A'}';
}
