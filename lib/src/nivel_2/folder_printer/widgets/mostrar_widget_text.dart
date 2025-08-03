import 'package:flutter/material.dart';

Future<String?> mostrarDialogoTexto(
  BuildContext context, {
  required String identificador,
  String? valorInicial,
}) async {
  final TextEditingController controller =
      TextEditingController(text: valorInicial);

  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text(identificador,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Escribe aquí...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  );
}
