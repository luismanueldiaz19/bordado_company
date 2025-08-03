import 'package:flutter/material.dart';
import '/src/util/commo_pallete.dart';

import '../../model/product_incidencia.dart';

class ProductForm extends StatefulWidget {
  final ProductIncidencia? product;

  const ProductForm({Key? key, this.product}) : super(key: key);

  @override
  State createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cantController;
  late TextEditingController _costController;
  late TextEditingController _productionController;
  var data = {};

  @override
  void initState() {
    super.initState();
    _cantController =
        TextEditingController(text: widget.product?.cant.toString());
    _costController =
        TextEditingController(text: widget.product?.cost.toString());
    _productionController =
        TextEditingController(text: widget.product?.product.toString());
  }

  @override
  void dispose() {
    _cantController.dispose();
    _costController.dispose();
    _productionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Actualizar Formulario',
              style: TextStyle(fontWeight: FontWeight.w500, color: colorsAd),
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _cantController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor ingrese una cantidad';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _costController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Costo'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor ingrese un costo';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _productionController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Producción'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor ingrese una producción';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Color de fondo

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6), // Borde redondeado
            ),

            padding: const EdgeInsets.symmetric(
                vertical: 10, horizontal: 20), // Espaciado interno
          ),
          child: const Text('Cancelar'),
          onPressed: () {
            data = {
              'cant': _cantController.text,
              'cost': _costController.text,
              'product': _productionController.text,
            };
            Navigator.of(context).pop(data);
          },
        ),
        TextButton(
          child: const Text('Aceptar'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              setState(() {
                data = {
                  'cant': _cantController.text,
                  'cost': _costController.text,
                  'product': _productionController.text,
                };
              });
              Navigator.of(context).pop(data);
            }
          },
        ),
      ],
    );
  }
}

// AlertDialog(
//       title: const Text('Selecciona los Departamentos'),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: widget.department.map((depart) {
//             bool isSelected = selectedDepartment.contains(depart);
//             return CheckboxListTile(
//               title: Text(depart),
//               value: isSelected,
//               onChanged: (bool? value) {
//                 setState(() {
//                   if (value == true) {
//                     selectedDepartment.add(depart);
//                   } else {
//                     selectedDepartment.remove(depart);
//                   }
//                 });
//               },
//             );
//           }).toList(),
//         ),
//       ),
//       actions: [
//         TextButton(
//           child: const Text('Cancelar'),
//           onPressed: () {
//             Navigator.of(context).pop([]);
//           },
//         ),
//         TextButton(
//           child: const Text('Aceptar'),
//           onPressed: () {
//             Navigator.of(context).pop(selectedDepartment);
//           },
//         ),
//       ],
//     );
