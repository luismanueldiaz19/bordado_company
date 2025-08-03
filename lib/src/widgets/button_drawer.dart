import 'package:flutter/material.dart';
import '/src/util/font_style.dart';

class ButtonDrawer extends StatelessWidget {
  const ButtonDrawer({
    super.key,
    required this.icon,
    required this.text,
    required this.press,
    this.colorIcon = Colors.black,
    this.colorText = Colors.black,
  });
  final IconData icon;
  final String? text;
  final Function press;
  final Color colorIcon;
  final Color colorText;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return TextButton.icon(
      onPressed: () => press(),
      icon: Icon(icon, color: colorIcon, size: 19),
      label: Text(
        text ?? 'N/A',
        style: style.bodyMedium
            ?.copyWith(color: colorText, fontFamily: fontBalooPaaji),
        textAlign: TextAlign.center,
      ),
    );
  }
}
