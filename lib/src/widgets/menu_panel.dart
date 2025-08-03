import 'package:flutter/material.dart';

Padding menuLateral(
    IconData icon, String text, Function onPressed, Color? colors) {
  return Padding(
    padding: const EdgeInsets.only(left: 15),
    child: Row(
      children: [
        Icon(icon, color: colors ?? Colors.black45),
        TextButton(
            onPressed: () => onPressed(),
            child: Text(
              text,
              style: const TextStyle(color: Colors.black45),
            )),
      ],
    ),
  );
}
