import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/helper.dart';

import '../nivel_2/folder_insidensia/pages_insidencia.dart/selected_department.dart';

class AddProducto extends StatefulWidget {
  const AddProducto({super.key});

  @override
  State<AddProducto> createState() => _AddProductoState();
}

class _AddProductoState extends State<AddProducto> {
  final nombreController = TextEditingController();
  final controllerCantidad = TextEditingController();
  var listDepartment = [];

  void productPicked() async {
    if (nombreController.text.isNotEmpty &&
        controllerCantidad.text.isNotEmpty &&
        listDepartment.isNotEmpty) {
      var product = {
        'product': nombreController.text,
        'cant': controllerCantidad.text,
        'list_department': listDepartment,
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
            SlideInLeft(
              curve: curve,
              child: Container(
                color: Colors.white,
                height: 50,
                width: 250,
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: TextButton.icon(
                  icon: const Icon(Icons.home_max_sharp, color: Colors.black),
                  label: const Text('Departamentos',
                      style: TextStyle(color: Colors.black)),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return SelectedDepartments(
                          pressDepartment: (val) {
                            setState(() {
                              listDepartment = val;
                              // print('List Element : $listDepartment');
                              if (listDepartment.contains('Sublimación') &&
                                  !listDepartment.contains('Plancha/Empaque')) {
                                listDepartment.add('Plancha/Empaque');
                              }
                              if (listDepartment.contains('Sublimación') &&
                                  !listDepartment.contains('Printer')) {
                                listDepartment.add('Printer');
                              }
                              if (listDepartment.contains('Serigrafia') &&
                                  !listDepartment.contains('Plancha/Empaque')) {
                                listDepartment.add('Plancha/Empaque');
                              }
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            listDepartment.isNotEmpty
                ? Expanded(
                    child: SizedBox(
                      width: 250,
                      child: ListView.builder(
                        itemCount: listDepartment.length,
                        itemBuilder: (context, index) {
                          final depart = listDepartment[index];
                          return Row(
                            children: [
                              Text(depart),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      listDepartment.remove(depart);
                                    });
                                  },
                                  icon: Icon(Icons.close,
                                      color: Colors.red,
                                      size: style.bodyMedium?.fontSize))
                            ],
                          );
                        },
                      ),
                    ),
                  )
                : const SizedBox()
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
