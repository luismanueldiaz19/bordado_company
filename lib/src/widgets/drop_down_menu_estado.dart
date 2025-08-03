import 'package:flutter/material.dart';

class DropDownMenuEstado extends StatefulWidget {
  const DropDownMenuEstado(
      {super.key, required this.onPressed, this.isAdd = false});
  final Function? onPressed;
  final bool? isAdd;

  @override
  State<DropDownMenuEstado> createState() => _DropDownMenuEstadoState();
}

class _DropDownMenuEstadoState extends State<DropDownMenuEstado> {
  String _selectedEstado = 'Activo';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedEstado,
      onChanged: (newValue) {
        setState(() {
          _selectedEstado = newValue.toString();
          widget.onPressed!(_selectedEstado);
        });
      },
      items: widget.isAdd!
          ? const [
              DropdownMenuItem(value: 'Activo', child: Text('Activo')),
              DropdownMenuItem(value: 'Pendiente', child: Text('Pendiente')),
              DropdownMenuItem(value: 'Vencida', child: Text('Vencida')),
            ]
          : const [
              DropdownMenuItem(value: 'Activo', child: Text('Activo')),
              DropdownMenuItem(value: 'Pendiente', child: Text('Pendiente')),
              DropdownMenuItem(value: 'Pagado', child: Text('Pagado')),
              DropdownMenuItem(value: 'Vencida', child: Text('Vencida')),
            ],
      alignment: Alignment.center,
      isExpanded: true,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      style: Theme.of(context).textTheme.labelSmall,
      borderRadius: BorderRadius.circular(5),
    );
  }
}
