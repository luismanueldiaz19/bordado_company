import 'package:flutter/material.dart';

class SelectableItem<T> extends StatelessWidget {
  final T selectedItem;
  final List<T> items;
  final String Function(T) getLabel;
  final Color Function(T) getColor;
  final void Function(T) onChanged;
  final double? width;

  const SelectableItem(
      {super.key,
      required this.selectedItem,
      required this.items,
      required this.getLabel,
      required this.getColor,
      required this.onChanged,
      this.width = 140});

  @override
  Widget build(BuildContext context) {
    final Color currentColor = getColor(selectedItem);
    return Container(
      height: 40,
      width: width,
      decoration: BoxDecoration(
        color: currentColor.withOpacity(0.1),
        border: Border.all(color: currentColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: PopupMenuButton<T>(
        onSelected: onChanged,
        itemBuilder: (context) => items
            .map(
              (item) => PopupMenuItem<T>(
                value: item,
                child: Text(getLabel(item)),
              ),
            )
            .toList(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.circle, size: 12, color: currentColor),
            const SizedBox(width: 8),
            Text(
              getLabel(selectedItem),
              style: TextStyle(fontSize: 14, color: currentColor),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
