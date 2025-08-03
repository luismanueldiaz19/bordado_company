import '/src/nivel_2/folder_satreria/model/sastreria_item.dart';

class Factura {
  final String numeroFactura;
  final DateTime fechaEmision;
  final String cliente;
  final List<SastreriaWorkItem> items;

  Factura({
    required this.numeroFactura,
    required this.fechaEmision,
    required this.cliente,
    required this.items,
  });
}
