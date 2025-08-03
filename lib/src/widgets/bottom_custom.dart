import 'package:flutter/material.dart';

import '../util/commo_pallete.dart';

class BottomCustom extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color colorButton;
  final double? width;
  const BottomCustom(
      {super.key,
      this.width = 200,
      required this.onPressed,
      this.text = 'Iniciar Sección',
      this.colorButton = colorsBlueTurquesaOther});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 35,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorButton, // Azul oscuro como en la imagen
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          elevation: 3,
        ),
        onPressed: onPressed,
        child: Text(text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                letterSpacing: 1.4,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
