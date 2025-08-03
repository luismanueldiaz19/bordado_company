import 'package:flutter/material.dart';

class ConfirmacionDialog extends StatelessWidget {
  final String titulo;
  final String mensaje;
  final Function() onConfirmar;

  const ConfirmacionDialog(
      {super.key,
      required this.titulo,
      required this.mensaje,
      required this.onConfirmar});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      title: Text(titulo, style: style.labelLarge),
      content: Text(mensaje),
      actions: <Widget>[
        SimpleDialogOption(
          child: const Text("Cancelar"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        SimpleDialogOption(
            onPressed: onConfirmar, child: const Text("Confirmar")),
      ],
    );
  }
}
