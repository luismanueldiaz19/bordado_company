class NewOrden {
  String? userRegistroOrden;
  String? cliente;
  String? clienteTelefono;
  String? numOrden;
  String? nameLogo;
  String? ficha;
  String? fechaStart;
  String? fechaEntrega;
  String? isKeyUniqueProduct;
  String? priority;

  // Constructor
  NewOrden({
    this.userRegistroOrden,
    this.cliente,
    this.clienteTelefono,
    this.numOrden,
    this.nameLogo,
    this.ficha,
    this.fechaStart,
    this.fechaEntrega,
    this.isKeyUniqueProduct,
    this.priority,
  });

  // Método para crear una nueva instancia desde los datos proporcionados
  factory NewOrden.fromData({
    required String? currentUsersFullName,
    required String? clientApellido,
    required String? clientNombre,
    required String? clientTelefono,
    required String numOrdenText,
    required String nameLogoText,
    required String fichaText,
    required String fechaStartText,
    required String fechaEntregaText,
    required String uniqueKeyProduct,
    required String priority,
  }) {
    return NewOrden(
      userRegistroOrden: currentUsersFullName?.toString(),
      cliente: '${clientApellido?.toString()},${clientNombre?.toString()}',
      clienteTelefono: clientTelefono?.toString(),
      numOrden: numOrdenText.toString(),
      nameLogo: nameLogoText.toString(),
      ficha: fichaText.toString(),
      fechaStart: fechaStartText.toString(),
      fechaEntrega: fechaEntregaText.toString(),
      isKeyUniqueProduct: uniqueKeyProduct.toString(),
      priority: priority.toString(),
    );
  }

  // Método para convertir la clase a un Map (útil para enviar como JSON o almacenar)
  Map<String, dynamic> toMap() {
    return {
      'user_registro_orden': userRegistroOrden,
      'cliente': cliente,
      'cliente_telefono': clienteTelefono,
      'num_orden': numOrden,
      'name_logo': nameLogo,
      'ficha': ficha,
      'fecha_start': fechaStart,
      'fecha_entrega': fechaEntrega,
      'is_key_unique_product': isKeyUniqueProduct,
      'priority': priority,
    };
  }
}
