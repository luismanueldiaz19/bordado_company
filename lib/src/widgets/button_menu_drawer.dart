import 'package:flutter/material.dart';

class MyWidgetButton extends StatelessWidget {
  const MyWidgetButton(
      {super.key,
      this.onPressed,
      this.textButton,
      this.icon = Icons.person,
      this.colorIcon = Colors.black54});
  final Function()? onPressed;
  final String? textButton;
  final IconData? icon;
  final Color colorIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
            style: ButtonStyle(
              shape: MaterialStateProperty.resolveWith(
                (states) => const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero),
              ),
              // backgroundColor: MaterialStateProperty.resolveWith(
              //     (states) => Colors.grey.shade200),
            ),
            onPressed: onPressed,
            icon: Icon(icon,
                size: Theme.of(context).textTheme.bodySmall?.fontSize,
                color: colorIcon),
            label: Text(textButton ?? 'N/A',
                style: Theme.of(context).textTheme.bodySmall)),
      ),
    );
  }
}
