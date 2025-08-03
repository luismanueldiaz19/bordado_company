import 'package:flutter/material.dart';

void utilShowMesenger(context, String error, {String title = 'Aviso'}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text(title, style: Theme.of(context).textTheme.labelSmall),
        content: SelectableText(error,
            style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cerrar'))
        ],
      ),
    );

void getMensajeWidget(context, String error, {text = 'Aviso'}) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text(text, style: Theme.of(context).textTheme.labelSmall),
        content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.50,
            child: SelectableText(error,
                style: Theme.of(context).textTheme.bodyMedium)),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cerrar'))
        ],
      ),
    );
void showScaffoldMessenger(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              )),
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      action: SnackBarAction(
        label: 'Cerrar',
        textColor: Colors.white,
        onPressed: () {
          if (context.mounted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
        },
      ),
    ),
  );
}
