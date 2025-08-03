import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddTiradaDialog extends StatefulWidget {
  const AddTiradaDialog({super.key});

  @override
  State<AddTiradaDialog> createState() => _AddTiradaDialogState();
}

class _AddTiradaDialogState extends State<AddTiradaDialog> {
  TextEditingController cantElaboredController = TextEditingController();
  TextEditingController cantBadController = TextEditingController();

  @override
  void dispose() {
    cantElaboredController.dispose();
    cantBadController.dispose();
    super.dispose();
  }

  Map<String, dynamic> getValues() {
    return {
      'cant_elabored': cantElaboredController.text.isNotEmpty
          ? cantElaboredController.text
          : '0',
      'cant_bad':
          cantBadController.text.isNotEmpty ? cantBadController.text : '0',
    };
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      title: const Text('Agregar Tirada'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: cantElaboredController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Cantidad elaborada'),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          TextField(
            controller: cantBadController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Cantidad defectuosa'),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (cantBadController.text.isNotEmpty ||
                cantElaboredController.text.isNotEmpty) {
              Navigator.pop(context, getValues());
            } else {
              Navigator.pop(context);
            }
          },
          child: const Text('Insertar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
