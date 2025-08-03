class InventoryEntryItem {
  final int idProduct;
  final double quantity;
  final String note;
  final String numFactura;
  final String registedBy;
  final String nameProduct;

  InventoryEntryItem({
    required this.idProduct,
    required this.quantity,
    this.note = '',
    this.numFactura = 'N/A',
    this.registedBy = 'N/A',
    this.nameProduct = 'N/A',
  });

  Map<String, dynamic> toJson() => {
        'id_product': idProduct,
        'quantity': quantity,
        'note': note,
        'num_factura': numFactura,
        'registed_by': registedBy,
        'name_product': nameProduct,
      };
}
