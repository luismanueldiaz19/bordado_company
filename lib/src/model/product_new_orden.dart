class ProductNewOrden {
  String? isKeyUniqueProduct;
  String? tipoProducto;
  String? productId;
  String? cantidad;
  String? department;
  String? fechaStart;
  String? fechaEnd;
  String? priority;

  // Constructor
  ProductNewOrden({
    this.isKeyUniqueProduct,
    this.tipoProducto,
    this.cantidad,
    this.department,
    this.fechaStart,
    this.fechaEnd,
    this.priority,
    this.productId,
  });

  // Método de fábrica para crear una instancia a partir de los datos proporcionados
  factory ProductNewOrden.fromData({
    String? isKeyUniqueProduct,
    String? tipoProducto,
    String? cantProduto,
    String? department,
    String? fechaStart,
    String? fechaEnd,
    String? priority,
    String? productId,
  }) {
    return ProductNewOrden(
      isKeyUniqueProduct: isKeyUniqueProduct?.toString(),
      tipoProducto: tipoProducto?.toString(),
      cantidad: cantProduto,
      department: department?.toString(),
      fechaStart: fechaStart?.toString(),
      fechaEnd: fechaEnd?.toString(),
      priority: priority.toString(),
      productId: productId.toString(),
    );
  }

  // Método para convertir la clase a un Map
  Map<String, String> toMap() {
    return {
      'is_key_unique_product': isKeyUniqueProduct ?? '0',
      'tipo_product': tipoProducto ?? 'N/A',
      'cant': cantidad ?? '0',
      'department': department ?? 'N/A',
      'fecha_start': fechaStart ?? 'N/A',
      'fecha_end': fechaEnd ?? 'N/A',
      'priority': priority ?? 'Normal',
      'id_product': productId ?? '0'
    };
  }
}
