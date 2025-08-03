import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddComentario extends StatefulWidget {
  const AddComentario(
      {super.key,
      this.text = 'Agregar Comentario',
      this.inputFormatters,
      this.textFielName = 'Comentario',
      this.textInputType = TextInputType.text});
  final String? text;
  final String? textFielName;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType textInputType;
  @override
  State<AddComentario> createState() => _AddComentarioState();
}

class _AddComentarioState extends State<AddComentario> {
  TextEditingController comment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      title: BounceInDown(
        child: Text(
          widget.text ?? 'Agregar Comentario',
          style: const TextStyle(fontSize: 16),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ZoomIn(
            duration: const Duration(milliseconds: 300),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              width: 250,
              child: TextField(
                textInputAction: TextInputAction.done,
                inputFormatters: widget.inputFormatters,
                controller: comment,
                keyboardType: widget.textInputType,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: widget.textFielName,
                  contentPadding: const EdgeInsets.only(left: 10),
                ),
                onEditingComplete: () {
                  Navigator.of(context).pop(comment.text);
                  comment.clear();
                },
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Enviar'),
          onPressed: () {
            if (comment.text.isNotEmpty) {
              Navigator.of(context).pop(comment.text);
              comment.clear();
            }
          },
        ),
      ],
    );
  }
}
