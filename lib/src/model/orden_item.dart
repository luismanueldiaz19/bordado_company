class OrdenItem {
  String? ordenItemsId;
  String? listOrdenesId;
  int? idProducto;
  int? cant;
  String? detallesProductos;
  String? nota;
  String? estadoProduccion;
  DateTime? fechaItemCreacion;

  OrdenItem({
    this.ordenItemsId,
    this.listOrdenesId,
    this.idProducto,
    this.cant,
    this.detallesProductos,
    this.nota,
    this.estadoProduccion,
    this.fechaItemCreacion,
  });

  Map<String, dynamic> toJson() {
    return {
      "orden_items_id": ordenItemsId,
      "list_ordenes_id": listOrdenesId,
      "id_producto": idProducto,
      "cant": cant,
      "detalles_productos": detallesProductos,
      "nota": nota,
      "estado_produccion": estadoProduccion,
      "fecha_item_creacion": fechaItemCreacion?.toIso8601String(),
    };
  }
}
