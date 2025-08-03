import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/helper.dart';

class AddProductIncidencia extends StatefulWidget {
  const AddProductIncidencia({super.key});

  @override
  State<AddProductIncidencia> createState() => _AddProductIncidenciaState();
}

class _AddProductIncidenciaState extends State<AddProductIncidencia> {
  final nombreController = TextEditingController();
  final controllerCantidad = TextEditingController();
  final controllerCosto = TextEditingController();

  void productPicked() async {
    if (nombreController.text.isNotEmpty &&
        controllerCantidad.text.isNotEmpty) {
      var product = {
        'product': nombreController.text,
        'cant': controllerCantidad.text,
        'costo': controllerCosto.text.isNotEmpty ? controllerCosto.text : '0.0',
      };

      Navigator.pop(context, product);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    const curve = Curves.elasticInOut;
    return AlertDialog(
      title: Text('Agregar Producto', style: style.titleMedium),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SlideInLeft(
              curve: curve,
              child: buildTextFieldValidator(
                controller: nombreController,
                hintText: 'Escribir Producto',
                label: 'Producto  *',
              ),
            ),
            SlideInRight(
              curve: curve,
              child: buildTextFieldValidator(
                controller: controllerCantidad,
                hintText: 'Escribir Cantidad',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*$')),
                ],
                label: 'Cantidad',
              ),
            ),
            SlideInRight(
              curve: curve,
              child: buildTextFieldValidator(
                controller: controllerCosto,
                hintText: 'Escribir Costo',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*$')),
                ],
                label: 'Costo',
              ),
            ),
          ]),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancelar', style: TextStyle(color: Colors.red))),
        customButton(
            width: 125,
            onPressed: productPicked,
            textButton: 'Agregar',
            colorText: Colors.white,
            colors: colorsAd)
      ],
    );
  }
}
