class OrdenItem {
  String? ordenItemsId;
  String? listOrdenesId;
  int? idProducto;
  double? cant;
  String? detallesProductos;
  String? nota;
  String? estadoProduccion;
  String? precioFinal;
  String? fechaItemCreacion;

  OrdenItem({
    this.ordenItemsId,
    this.listOrdenesId,
    this.idProducto,
    this.cant,
    this.detallesProductos,
    this.nota,
    this.estadoProduccion,
    this.fechaItemCreacion,
    this.precioFinal,
  });

  Map<String, dynamic> toJson() {
    return {
      "orden_items_id": ordenItemsId,
      "list_ordenes_id": listOrdenesId,
      "id_producto": idProducto,
      "cant": cant,
      "precio_final": precioFinal,
      "detalles_productos": detallesProductos,
      "nota": nota,
      "estado_produccion": estadoProduccion,
      "fecha_item_creacion": fechaItemCreacion,
    };
  }

  factory OrdenItem.fromJson(Map<String, dynamic> json) => OrdenItem(
        ordenItemsId: json["orden_items_id"],
        idProducto: int.tryParse(json["id_producto"]) ?? 0,
        cant: double.tryParse(json["cant"]),
        precioFinal: json["precio_final"].toString(),
        detallesProductos: json["detalles_productos"],
        nota: json["nota"],
        estadoProduccion: json["estado_produccion"],
        fechaItemCreacion: json["fecha_item_creacion"],
      );
}


// {
            // "num_orden": "11",
            // "list_ordenes_id": "11",
            // "fecha_creacion": "2025-08-03",
            // "fecha_entrega": "2025-08-08",
            // "estado_general": "EN PRODUCCION",
            // "estado_entrega": "PENDIENTE",
            // "estado_prioritario": "EMERGENCIA",
            // "ficha": "262",
            // "observaciones": "N/A",
            // "name_logo": "FACEBOOOK",
            // "usuario_id": "1",