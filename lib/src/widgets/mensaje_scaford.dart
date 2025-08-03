import 'package:flutter/material.dart';

void scaffoldMensaje({context, Color? background, mjs}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(mjs),
    backgroundColor: background,
    duration: const Duration(milliseconds: 600),
  ));
}
