import 'orden_item.dart';

class Orden {
  String? listOrdenesId;
  int? idCliente;
  String? estadoPrioritario;
  String? estadoGeneral;
  String? nameLogo;
  String? numOrden;
  String? ficha;
  String? observaciones;
  DateTime? fechaCreacion;
  DateTime? fechaEntrega;
  String? estadoEntrega;
  String? usuarioId;
  List<OrdenItem>? items;

  Orden({
    this.listOrdenesId,
    this.idCliente,
    this.estadoPrioritario,
    this.estadoGeneral,
    this.nameLogo,
    this.numOrden,
    this.ficha,
    this.observaciones,
    this.fechaCreacion,
    this.fechaEntrega,
    this.estadoEntrega,
    this.usuarioId,
    this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      "list_ordenes_id": listOrdenesId,
      "id_cliente": idCliente,
      "estado_prioritario": estadoPrioritario,
      "estado_general": estadoGeneral,
      "name_logo": nameLogo,
      "num_orden": numOrden,
      "ficha": ficha,
      "observaciones": observaciones,
      "fecha_creacion": fechaCreacion?.toIso8601String(),
      "fecha_entrega": fechaEntrega?.toIso8601String(),
      "estado_entrega": estadoEntrega,
      "usuario_id": usuarioId,
      "items": items?.map((item) => item.toJson()).toList(),
    };
  }
}
