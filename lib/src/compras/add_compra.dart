import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../datebase/current_data.dart';
import '../folder_list_product/dialog_get_product.dart';
import '../folder_list_product/model_product/product.dart';
import '../model/purchase.dart';
import '../util/commo_pallete.dart';
import '../util/helper.dart';
import '../widgets/estado_selector.dart';
import 'add_compra_continuos.dart';

class AddCompra extends StatefulWidget {
  const AddCompra({super.key});

  @override
  State createState() => _AddCompraState();
}

class _AddCompraState extends State<AddCompra> {
  // Controladores para los datos de la factura
  final TextEditingController _proveedorController = TextEditingController();
  final TextEditingController controllerCant = TextEditingController();
  final TextEditingController controllerNumFactura = TextEditingController();
  final TextEditingController controllerNote =
      TextEditingController(text: 'Sin nota...');
  // Lista de productos agregados
  List<PurchasesItem> purchasesItems = [];

  Purchases? purchases;

  Product? productSelected;

  Future pickedProduct() async {
    Product? productPicked = await showDialog<Product>(
        context: context,
        builder: (context) {
          return const DialogGetProductos();
        });

    if (productPicked != null) {
      setState(() {
        productSelected = productPicked;
      });
    }
  }

  String estadoSeleccionado = "Pagado";

  void startCompra() {
    setState(() {
      purchases = Purchases(
        proveedor: _proveedorController.text.trim(),
        estado: estadoSeleccionado.toString(),
        fechaCompra: DateTime.now().toIso8601String(),
        purchasesId: '515',
        usuario: currentUsers?.id,
        numFactura: controllerNumFactura.text.trim(),
        nota: controllerNote.text.isNotEmpty
            ? controllerNote.text.trim()
            : 'Sin nota...',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const curve = Curves.elasticInOut;
    // final style = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Registrar Factura")),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: double.infinity),
                buildTextFieldValidator(
                    label: 'Proveedor',
                    controller: _proveedorController,
                    onChanged: (val) => startCompra(),
                    hintText: 'Escribir nombre'),
                buildTextFieldValidator(
                  controller: controllerNumFactura,
                  label: 'Factura',
                  hintText: 'Escribe el número de factura',
                  onChanged: (val) => startCompra(),
                ),
                buildTextFieldValidator(
                    label: 'Nota',
                    hintText: 'Escribe una nota',
                    onChanged: (val) => startCompra(),
                    controller: controllerNote),
                const SizedBox(height: 5),
                SizedBox(
                  width: 250,
                  child: EstadoSelector(
                    initialValue: estadoSeleccionado,
                    onChanged: (String nuevoEstado) {
                      setState(() {
                        estadoSeleccionado = nuevoEstado;

                        startCompra();
                      });
                      print("Estado seleccionado: $nuevoEstado");
                    },
                  ),
                ),
                const SizedBox(height: 15),
                _proveedorController.text.isNotEmpty &&
                        controllerNumFactura.text.isNotEmpty
                    ? BounceInDown(
                        curve: curve,
                        child: customButton(
                            width: 250,
                            onPressed: () {
                              startCompra();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddCompraContinuos(item: purchases)),
                              );
                            },
                            colorText: Colors.white,
                            colors: colorsBlueDeepHigh,
                            textButton: 'Continuar'),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//   // void chooseProduct() async {
//   //   Producto? item = await showDialog<Producto>(
//   //       context: context,
//   //       builder: (_) {
//   //         return const GetDialogProduct();
//   //       });

//   //   if (item != null) {
//   //     setState(() {
//   //       productoPicked = item;
//   //     });
//   //   }
//   // }
// }

// var data = {
//   'estado': 'Pagado',
//   'total': 15000.00,
//   'usuario_id': '',
//   'proveedor': 'N/A',
//   'fecha_compra': '2025-02-07 23:07:22',
//   'item': [
//     {
//       'producto_id': '1',
//       'cantidad': '',
//       'precio_unitario': '',
//       'subtotal': '',
//     }
//   ],
// };




//   String estadoSeleccionado = "Pagado";
//   @override
//   Widget build(BuildContext context) {
//     const curve = Curves.elasticInOut;
//     final style = Theme.of(context).textTheme;
   
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(title: const Text("Registrar Factura")),
//         body: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextFormField(
//                     controller: _proveedorController,
//                     decoration: InputDecoration(labelText: "Proveedor"),
//                     validator: (value) =>
//                         value!.isEmpty ? "Este campo es obligatorio" : null,
//                   ),
//                   SizedBox(height: 20),

//                   SizedBox(
//                     width: double.infinity,
//                     child: EstadoSelector(
//                       initialValue: estadoSeleccionado,
//                       onChanged: (String nuevoEstado) {
//                         setState(() {
//                           estadoSeleccionado = nuevoEstado;
//                         });
//                         print("Estado seleccionado: $nuevoEstado");
//                       },
//                     ),
//                   ),

//                   SizedBox(height: 20),
//                   const Text("Agregar Productos",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       ElevatedButton(
//                           onPressed: _agregarProducto,
//                           child: const Text("Agregar Producto")),
//                       ElevatedButton(
//                           onPressed: pickedProduct,
//                           child: const Text("Buscar Producto")),
//                     ],
//                   ),
//                   TextFormField(
//                     controller: _cantidadController,
//                     decoration: const InputDecoration(labelText: "Cantidad"),
//                     keyboardType:
//                         const TextInputType.numberWithOptions(decimal: true),
//                     inputFormatters: [
//                       FilteringTextInputFormatter.allow(
//                           RegExp(r'^\d{0,5}(\.\d{0,2})?$')),
//                     ],
//                   ),
//                   TextFormField(
//                     controller: _precioUnitarioController,
//                     decoration: const InputDecoration(labelText: "Costo"),
//                     keyboardType:
//                         const TextInputType.numberWithOptions(decimal: true),
//                     inputFormatters: [
//                       FilteringTextInputFormatter.allow(
//                           RegExp(r'^\d{0,5}(\.\d{0,2})?$'))
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   productSelected != null
//                       ? Container(
//                           color: Colors.white,
//                           alignment: Alignment.center,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 15, vertical: 15),
//                           margin: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 5),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                       productSelected?.nombreProducto ?? 'N/A'),
//                                   Text(productSelected?.precio ?? 'N/A'),
//                                 ],
//                               ),
//                               Text(productSelected?.unit ?? 'N/A'),
//                               Text(productSelected?.nombreCategoria ?? 'N/A'),
//                               Text('QTY : ${productSelected?.qty ?? 'N/A'}'),
//                             ],
//                           ),
//                         )
//                       : const SizedBox(),
//                   Divider(),
//                   Text("Productos Agregados",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   Container(
//                     height: 150,
//                     child: ListView.builder(
//                       itemCount: purchasesItems.length,
//                       itemBuilder: (context, index) {
//                         final item = purchasesItems[index];
//                         return ListTile(
//                           title: Text(item.nombreProducto ?? ""),
//                           subtitle: Text(
//                               "Cantidad: ${item.cantidad} - Subtotal: \$${item.subtotal}"),
//                         );
//                       },
//                     ),
//                   ),
//                   // SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _guardarFactura,
//                     child: Text("Guardar Factura"),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }