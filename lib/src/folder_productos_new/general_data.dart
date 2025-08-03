class GeneralData {
  List<Talla> tallas;
  List<ColorModel> colores;
  List<Marca> marcas;
  List<MaterialModel> materiales;
  final List<LineaProducto>? lineaProduct;
  final List<SubCategoria>? subCategoria;

  GeneralData({
    required this.tallas,
    required this.colores,
    required this.marcas,
    required this.materiales,
    this.lineaProduct,
    this.subCategoria,
  });

  factory GeneralData.fromJson(Map<String, dynamic> json) {
    return GeneralData(
      tallas: (json['tallas'] as List).map((e) => Talla.fromJson(e)).toList(),
      colores:
          (json['colores'] as List).map((e) => ColorModel.fromJson(e)).toList(),
      marcas: (json['marcas'] as List).map((e) => Marca.fromJson(e)).toList(),
      materiales: (json['materiales'] as List)
          .map((e) => MaterialModel.fromJson(e))
          .toList(),
      lineaProduct: (json['linea'] as List)
          .map((e) => LineaProducto.fromJson(e))
          .toList(),
      subCategoria: (json['categoria'] as List)
          .map((e) => SubCategoria.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tallas': tallas.map((e) => e.toJson()).toList(),
      'colores': colores.map((e) => e.toJson()).toList(),
      'marcas': marcas.map((e) => e.toJson()).toList(),
      'materiales': materiales.map((e) => e.toJson()).toList(),
      'linea': lineaProduct?.map((e) => e.toJson()).toList(),
      'categoria': subCategoria?.map((e) => e.toJson()).toList(),
    };
  }
}

class Talla {
  final int tallaId;
  final String nombreTalla;

  Talla({
    required this.tallaId,
    required this.nombreTalla,
  });

  factory Talla.fromJson(Map<String, dynamic> json) {
    return Talla(
      tallaId: int.tryParse(json['talla_id']) ?? 0,
      nombreTalla: json['nombre_talla'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'talla_id': tallaId,
      'nombre_talla': nombreTalla,
    };
  }
}

class ColorModel {
  final int colorId;
  final String nombreColor;
  final String hexCode;

  ColorModel({
    required this.colorId,
    required this.nombreColor,
    required this.hexCode,
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      colorId: int.tryParse(json['color_id']) ?? 0,
      nombreColor: json['nombre_color'],
      hexCode: json['hex_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'color_id': colorId,
      'nombre_color': nombreColor,
      'hex_code': hexCode,
    };
  }
}

class Marca {
  final int marcaId;
  final String nameMarca;

  Marca({
    required this.marcaId,
    required this.nameMarca,
  });

  factory Marca.fromJson(Map<String, dynamic> json) {
    return Marca(
      marcaId: int.tryParse(json['marca_id']) ?? 0,
      nameMarca: json['name_marca'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'marca_id': marcaId,
      'name_marca': nameMarca,
    };
  }
}

class MaterialModel {
  final int materialId;
  final String nameMaterial;

  MaterialModel({
    required this.materialId,
    required this.nameMaterial,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      materialId: int.tryParse(json['material_id']) ?? 0,
      nameMaterial: json['name_material'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'material_id': materialId,
      'name_material': nameMaterial,
    };
  }
}

class LineaProducto {
  final int? lineaProductoId;
  final String? nameProducto;
  final String? rutaImagen;

  LineaProducto({
    this.lineaProductoId,
    this.nameProducto,
    this.rutaImagen,
  });

  factory LineaProducto.fromJson(Map<String, dynamic> json) {
    return LineaProducto(
      lineaProductoId: int.tryParse(json['linea_producto_id']) ?? 0,
      nameProducto: json['name_producto'],
      rutaImagen: json['ruta_imagen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'material_id': lineaProductoId,
      'name_material': nameProducto,
      'ruta_imagen': rutaImagen
    };
  }
}

class SubCategoria {
  int? id; // Puede ser null cuando estás agregando
  String name;

  SubCategoria({this.id, required this.name});

  // Para convertir desde JSON
  factory SubCategoria.fromJson(Map<String, dynamic> json) {
    return SubCategoria(
      id: int.tryParse(json['sub_categoria_id']) ?? 0,
      name: json['name_sub_categoria'],
    );
  }

  // Para convertir a JSON (por ejemplo, para enviar al backend)
  Map<String, dynamic> toJson() {
    return {
      'sub_categoria_id': id,
      'name_sub_categoria': name,
    };
  }

  @override
  String toString() {
    return name;
  }
}
