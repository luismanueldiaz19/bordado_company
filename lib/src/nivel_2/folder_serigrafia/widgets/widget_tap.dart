



import 'package:flutter/material.dart';

import '../../../util/commo_pallete.dart';
import '../../../util/font_style.dart';

class MyWidgetTap extends StatelessWidget {
  const MyWidgetTap({super.key, this.text, this.label});
  final String? text;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.copyWith(
        titleSmall: TextStyle(fontFamily: fontMuseo),
        bodySmall: TextStyle(fontFamily: fontBalooPaaji));
    return Container(
      margin: const EdgeInsets.all(5),
      width: 60,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 233, 234, 238),
          borderRadius: BorderRadius.circular(2),
          boxShadow: const [
            BoxShadow(
                blurRadius: 1,
                color: ktejidoBlueOcuro,
                offset: Offset(1, 5),
                spreadRadius: -2)
          ]),
      child: Column(
        children: [
          Text(label ?? 'N/A',
              style: style.labelSmall?.copyWith(color: Colors.black45)),
          Text(text ?? 'N/A',
              style: style.labelMedium?.copyWith(color: ktejidoBlueOcuro)),
        ],
      ),
    );
  }
}
