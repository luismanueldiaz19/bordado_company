import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/src/folder_incidencia_main/model_incidencia/incidencia_main.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/helper.dart';

import '../datebase/methond.dart';
import '../datebase/url.dart';

class EditarProductIncidencia extends StatefulWidget {
  const EditarProductIncidencia({super.key, this.report});
  final ListProduct? report;
  @override
  State<EditarProductIncidencia> createState() =>
      _EditarProductIncidenciaState();
}

class _EditarProductIncidenciaState extends State<EditarProductIncidencia> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController controllerCantidad = TextEditingController();
  TextEditingController controllerCosto = TextEditingController();

  void productPicked(context) async {
    if (nombreController.text.isNotEmpty &&
        controllerCantidad.text.isNotEmpty &&
        controllerCosto.text.isNotEmpty) {
      widget.report?.nameProduct = controllerCantidad.text;
      widget.report?.cant = int.tryParse(controllerCantidad.text);
      widget.report?.costo = int.tryParse(controllerCosto.text);
      await updateArticulo(widget.report!);
      Navigator.pop(context, true);
    }
  }

  Future updateArticulo(ListProduct json) async {
    var data = {
      'id_articulos_incidencia': json.idArticulosIncidencia,
      'name_product': json.nameProduct,
      'costo': json.costo.toString(),
      'cant': json.cant.toString(),
    };
    // print(data);
    await httpRequestDatabase(
        "http://$ipLocal/settingmat/admin/update/update_incidencia_articulos.php",
        data);
  }

  @override
  void initState() {
    super.initState();
    nombreController.text = widget.report!.nameProduct!;
    controllerCantidad.text = widget.report!.cant!.toString();
    controllerCosto.text = widget.report!.costo!.toString();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    const curve = Curves.elasticInOut;
    return AlertDialog(
      title: Text('Editar Producto', style: style.titleMedium),
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
            onPressed: () => productPicked(context),
            textButton: 'Actualizar',
            colorText: Colors.white,
            colors: colorsAd)
      ],
    );
  }
}
