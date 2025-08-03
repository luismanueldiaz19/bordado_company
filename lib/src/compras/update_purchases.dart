import 'package:flutter/material.dart';

import '../model/purchase.dart';

// Asume que importaste tu modelo Purchases

class UpdatePurchases extends StatefulWidget {
  final Purchases purchase;
  final Function(Purchases updatedPurchase)? onUpdate;

  const UpdatePurchases({super.key, required this.purchase, this.onUpdate});

  @override
  State<UpdatePurchases> createState() => _UpdatePurchasesState();
}

class _UpdatePurchasesState extends State<UpdatePurchases> {
  late Purchases editablePurchase;

  @override
  void initState() {
    super.initState();
    editablePurchase = Purchases(
      purchasesId: widget.purchase.purchasesId,
      fechaCompra: widget.purchase.fechaCompra,
      usuario: widget.purchase.usuario,
      total: widget.purchase.total,
      estado: widget.purchase.estado,
      proveedor: widget.purchase.proveedor,
      numFactura: widget.purchase.numFactura,
      purchasesItems: widget.purchase.purchasesItems != null
          ? List.from(widget.purchase.purchasesItems!)
          : [],
      nota: widget.purchase.nota,
    );
  }

  void updateField(String? value, String field) {
    setState(() {
      switch (field) {
        case 'usuario':
          editablePurchase.usuario = value;
          break;
        case 'total':
          editablePurchase.total = value;
          break;
        case 'nota':
          editablePurchase.nota = value;
          break;
        // Agrega más campos según sea necesario
      }
    });

    if (widget.onUpdate != null) {
      widget.onUpdate!(editablePurchase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Compra ID: ${editablePurchase.purchasesId ?? 'N/A'}"),
              Text("Fecha: ${editablePurchase.fechaCompra ?? ''}"),
              Text("Proveedor: ${editablePurchase.proveedor ?? ''}"),
              TextFormField(
                initialValue: editablePurchase.usuario,
                decoration: const InputDecoration(labelText: "Usuario"),
                onChanged: (value) => updateField(value, 'usuario'),
              ),
              TextFormField(
                initialValue: editablePurchase.total,
                decoration: const InputDecoration(labelText: "Total"),
                keyboardType: TextInputType.number,
                onChanged: (value) => updateField(value, 'total'),
              ),
              TextFormField(
                initialValue: editablePurchase.nota,
                decoration: const InputDecoration(labelText: "Nota"),
                onChanged: (value) => updateField(value, 'nota'),
              ),
              const SizedBox(height: 10),
              Text("Items: ${editablePurchase.purchasesItems?.length ?? 0}"),
              // Puedes agregar aquí una lista de los items si deseas
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (widget.onUpdate != null) {
                    widget.onUpdate!(editablePurchase);
                  }
                },
                child: const Text("Guardar Cambios"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
