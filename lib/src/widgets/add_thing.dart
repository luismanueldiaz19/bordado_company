import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddThing extends StatefulWidget {
  const AddThing(
      {super.key,
      this.title = 'Escribir tipo de trabajo',
      this.hintText = 'hintText'});
  final String? title;
  final String? hintText;

  @override
  State<AddThing> createState() => _AddThingState();
}

class _AddThingState extends State<AddThing> {
  TextEditingController value = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title ?? 'N/A'),
      content: TextField(
        onEditingComplete: () {
          if (value.text.isNotEmpty) {
            // _sendJobToServer(jobController.text);
            Navigator.of(context).pop(value.text);
          }
        },
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: value,
        decoration: InputDecoration(hintText: widget.hintText ?? 'N/A'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (value.text.isNotEmpty) {
              // _sendJobToServer(jobController.text);
              Navigator.of(context).pop(value.text);
            }
          },
          child: const Text('Enviar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
