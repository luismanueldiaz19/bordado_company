import 'package:flutter/material.dart';

class MyWidgetTotalItem extends StatelessWidget {
  const MyWidgetTotalItem(
      {super.key, required this.icon, required this.message, this.total});
  final IconData icon;
  final String? message;
  final String? total;
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return Tooltip(
      message: message,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.white),
        child: Column(
          children: [
            Icon(icon, size: style.titleMedium!.fontSize),
            Text(total ?? '0', style: style.bodyMedium),
          ],
        ),
      ),
    );
  }
}
