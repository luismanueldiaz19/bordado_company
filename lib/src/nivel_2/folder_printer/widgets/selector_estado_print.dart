import 'package:flutter/material.dart';

import '../model/printer_plan.dart';

class EstadoSelector extends StatelessWidget {
  final String estadoActual;
  final Function(String nuevoEstado) onChanged;

  EstadoSelector(
      {super.key, required this.estadoActual, required this.onChanged});

  final List<String> estados = [
    'PROCESO',
    'PARADO',
    'RETRASADO',
    'EN ESPERA',
    'URGENTE',
    'PENDIENTE',
    'TERMINADO',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 140,
      decoration: BoxDecoration(
        color: PrinterPlan.getColorByEstado(estadoActual).withOpacity(0.1),
        border: Border.all(color: PrinterPlan.getColorByEstado(estadoActual)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: PopupMenuButton<String>(
        onSelected: onChanged,
        itemBuilder: (context) => estados
            .map((e) => PopupMenuItem<String>(
                  value: e,
                  child: Text(e),
                ))
            .toList(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.circle,
                size: 12, color: PrinterPlan.getColorByEstado(estadoActual)),
            const SizedBox(width: 8),
            Text(estadoActual,
                style: TextStyle(
                  fontSize: 14,
                  color: PrinterPlan.getColorByEstado(estadoActual),
                )),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
