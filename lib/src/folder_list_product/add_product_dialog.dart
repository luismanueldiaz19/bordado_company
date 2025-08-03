import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/src/util/commo_pallete.dart';
import '../datebase/methond.dart';
import '../datebase/url.dart';
import '../util/helper.dart';

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  TextEditingController controllerProducto = TextEditingController();
  TextEditingController controllerPrecio = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController minimoController = TextEditingController();
  TextEditingController maximoController = TextEditingController();
  TextEditingController priceTwoController = TextEditingController();
  TextEditingController priceThreeController = TextEditingController();

  TextEditingController costoController = TextEditingController();
  TextEditingController referenciaController = TextEditingController();
  Future<void> addItemProduct() async {
    if (controllerProducto.text.isEmpty ||
        controllerPrecio.text.isEmpty ||
        stockController.text.isEmpty ||
        minimoController.text.isEmpty ||
        maximoController.text.isEmpty ||
        priceTwoController.text.isEmpty ||
        priceThreeController.text.isEmpty ||
        costoController.text.isEmpty ||
        referenciaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Campos vacio!'),
          duration: Duration(seconds: 1)));
      return;
    }
// id_product |             name_product             | price_product | created_at | stock | minimo | maximo
//
    var data = {
      'name_product': controllerProducto.text.trim().toUpperCase(),
      'price_product': controllerPrecio.text.trim(),
      'stock': stockController.text.trim(),
      'minimo': minimoController.text.trim(),
      'maximo': maximoController.text.trim(),
      'price_two': priceTwoController.text.trim(),
      'price_three': priceThreeController.text.trim(),
      'referencia': referenciaController.text.trim(),
      'costo': costoController.text.trim(),
    };

    String url = "http://$ipLocal/settingmat/admin/insert/insert_product.php";
    final res = await httpRequestDatabase(url, data);

    var response = jsonDecode(res!.body);
    if (response['success']) {
      controllerProducto.clear();
      controllerPrecio.clear();
      minimoController.clear();
      maximoController.clear();
      stockController.clear();
      priceTwoController.clear();
      priceThreeController.clear();
      context.mounted
          ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text(response['message']),
              duration: const Duration(seconds: 1)))
          : null;
      context.mounted ? Navigator.pop(context, true) : null;
    } else {
      context.mounted
          ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(response['message']),
              duration: const Duration(seconds: 1)))
          : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return AlertDialog(
      title: Text('Agregar producto', style: style.labelLarge),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: double.infinity),
            SlideInRight(
              curve: Curves.elasticInOut,
              child: buildTextFieldValidator(
                controller: controllerProducto,
                hintText: 'Escribir Nombre Producto',
                label: 'Producto',
              ),
            ),
            SlideInLeft(
              curve: Curves.elasticInOut,
              child: buildTextFieldValidator(
                controller: referenciaController,
                hintText: 'Escribir Referencia',
                label: 'Referencia Producto',
              ),
            ),
            SlideInRight(
              curve: Curves.elasticInOut,
              child: buildTextFieldValidator(
                  controller: costoController,
                  hintText: 'Escribir \$ Costo',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*$')),
                  ],
                  label: 'Costo Producto \$'),
            ),
            SlideInLeft(
              curve: Curves.elasticInOut,
              child: buildTextFieldValidator(
                  controller: controllerPrecio,
                  hintText: 'Escribir Precio 1',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*$')),
                  ],
                  label: 'Precio 1'),
            ),
            SlideInRight(
              curve: Curves.elasticInOut,
              child: buildTextFieldValidator(
                  controller: priceTwoController,
                  hintText: 'Escribir Precio 2',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*$')),
                  ],
                  label: 'Precio 2'),
            ),
            SlideInLeft(
              curve: Curves.elasticInOut,
              child: buildTextFieldValidator(
                  controller: priceThreeController,
                  hintText: 'Escribir Precio 3',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*$')),
                  ],
                  label: 'Precio 3'),
            ),
            SlideInRight(
                curve: Curves.elasticInOut,
                child: buildTextFieldValidator(
                    controller: stockController,
                    hintText: 'Escribir Disponibilidad',
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*$')),
                    ],
                    label: 'En Inventario')),
            SlideInLeft(
              curve: Curves.elasticInOut,
              child: buildTextFieldValidator(
                  controller: minimoController,
                  hintText: 'Escribir Minimo',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  label: 'Minimo'),
            ),
            SlideInRight(
              curve: Curves.elasticInOut,
              child: buildTextFieldValidator(
                  controller: maximoController,
                  hintText: 'Escribir Maximo',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  label: 'Maximo'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
        ),
        customButton(
            width: 150,
            onPressed: addItemProduct,
            textButton: 'Agregar',
            colorText: Colors.white,
            colors: colorsGreenTablas)
      ],
    );
  }
}
