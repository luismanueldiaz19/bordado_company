// import 'dart:convert';
// import 'package:flutter/material.dart';
// import '/src/datebase/current_data.dart';
// import '/src/datebase/methond.dart';
// import '/src/datebase/url.dart';
// import '/src/home.dart';
// import '/src/nivel_2/folder_insidensia/pages_insidencia.dart/editting_incidencias_fordel/editting_dialog_product.dart';
// import '/src/nivel_2/folder_insidensia/model/incidencia.dart';
// import '/src/util/commo_pallete.dart';

// import '/src/widgets/custom_app_bar.dart';
// import '/src/util/dialog_confimarcion.dart';

// import '../../model/product_incidencia.dart';

// class EdittingIncidencia extends StatefulWidget {
//   const EdittingIncidencia(
//       {super.key, required this.listProduct, required this.current});
//   final Incidencia current;
//   final List<ProductIncidencia> listProduct;
//   @override
//   State<EdittingIncidencia> createState() => _EdittingIncidenciaState();
// }

// class _EdittingIncidenciaState extends State<EdittingIncidencia> {
//   List list = [];
//   bool isloadingImage = true;
//   late TextEditingController? cant;

//   String urlImage =
//       "http://$ipLocal/settingmat/admin/imagen_incidencia_sublimacion/";
//   Future getImageNetWork() async {
//     final res = await httpRequestDatabase(selectImagePathFileIncidencia,
//         {'id_key_image': widget.current.idKeyImage});
//     // print(res.body);
//     list = json.decode(res.body) as List;
//     // print(list);
//     if (list.isNotEmpty) {
//       setState(() {
//         isloadingImage = false;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     cant = TextEditingController();
//     // detallesProductUpdate = widget.current.productos.toString();
//     getImageNetWork();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     cant?.dispose();
//   }

//   Future updateReport(data) async {
//     await httpRequestDatabase(updateReportIncidencia, data);
//     // print(res.body);
//     if (mounted) {
//       Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (conext) => const MyHomePage()),
//           (route) => false);
//     }
//   }

//   // Future<String?> updateCost() => showDialog<String?>(
//   //       context: context,
//   //       builder: (context) => AlertDialog(
//   //         title: const Text('Costos'),
//   //         content: Column(
//   //           mainAxisSize: MainAxisSize.min,
//   //           children: [
//   //             Container(
//   //               decoration: BoxDecoration(
//   //                   color: Colors.grey[300],
//   //                   borderRadius: BorderRadius.circular(15.0)),
//   //               child: TextField(
//   //                 controller: cant,
//   //                 textInputAction: TextInputAction.none,
//   //                 keyboardType: TextInputType.number,
//   //                 onEditingComplete: submitOutput,
//   //                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//   //                 decoration: const InputDecoration(
//   //                     contentPadding: EdgeInsets.symmetric(horizontal: 20),
//   //                     border: InputBorder.none,
//   //                     hintText: 'Costo'),
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //         actions: [
//   //           TextButton(
//   //               onPressed: () {
//   //                 Navigator.pop(context);
//   //               },
//   //               child: const Text('Cerrar')),
//   //           ElevatedButton(
//   //               onPressed: submitOutput, child: const Text('Confirmar'))
//   //         ],
//   //       ),
//   //     );

//   void dialogFormUpdated(ProductIncidencia product) async {
//     var productEdited = await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return ProductForm(product: product);
//       },
//     );
//     if (productEdited != null) {
//       // Haz algo con los departamentos seleccionados
//       // // _departmentsSelected = selectedDepartments;
//       // print(product);
//       await httpRequestDatabase(updateProductCostInsidenciaall, {
//         'cost': productEdited['cost'],
//         'product': productEdited['product'],
//         'cant': productEdited['cant'],
//         'id': product.id,
//       });

//       // print(res.body);

//       var item = widget.listProduct
//           .firstWhere((elemento) => elemento.id == product.id);
//       item.cost = productEdited['cost'];
//       item.product = productEdited['product'];
//       item.cant = productEdited['cant'];
//       setState(() {});

//       // print(selectedDepartment);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           children: [
//             const AppBarCustom(title: 'Detalles de Incidencia'),
//             isloadingImage
//                 ? SizedBox(
//                     height: 180,
//                     width: MediaQuery.of(context).size.width * 0.80,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const [Text("Cargardo imagen ...")],
//                     ),
//                   )
//                 : SizedBox(
//                     height: 180,
//                     width: MediaQuery.of(context).size.width * 0.80,
//                     child: SingleChildScrollView(
//                       physics: const BouncingScrollPhysics(),
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: list
//                             .map(
//                               (e) => Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 25),
//                                 child: SizedBox(
//                                   height: 150,
//                                   width: 150,
//                                   child: SizedBox(
//                                     height: 150,
//                                     width: 150,
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(15),
//                                       child: Image.network(
//                                           '$urlImage${e['image_path']}',
//                                           fit: BoxFit.cover),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             )
//                             .toList(),
//                       ),
//                     ),
//                   ),
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Orden ${widget.current.numOrden ?? 'N/A'}'),
//                   const SizedBox(width: 15),
//                   Text(
//                     'Ficha ${widget.current.ficha ?? 'N/A'}',
//                     style: const TextStyle(
//                         color: colorsPuppleOpaco, fontWeight: FontWeight.w500),
//                   ),
//                   const SizedBox(width: 15),
//                   widget.current.isFinished.toString() == 'f'
//                       ? TextButton.icon(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor:
//                                 colorsPuppleOpaco, // Color de fondo

//                             shape: RoundedRectangleBorder(
//                               borderRadius:
//                                   BorderRadius.circular(6), // Borde redondeado
//                             ),

//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 10,
//                                 horizontal: 20), // Espaciado interno
//                           ),
//                           onPressed: () async {
//                             await showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return ConfirmacionDialog(
//                                   mensaje:
//                                       '❌❌Esta seguro de cerrar esta incidencia y reportarla como solucionada❌❌',
//                                   titulo: 'Aviso',
//                                   onConfirmar: () {
//                                     Navigator.of(context).pop();
//                                     // print('Correcto');
//                                     var data = {
//                                       'solucionwhat':
//                                           '${widget.current.solucionwhat} -- Verificado por ${currentUsers?.fullName}  Fecha : ${DateTime.now().toString().substring(0, 19)}',
//                                       'costoparts': '100',
//                                       'productos': 'Nada',
//                                       'name_close': currentUsers?.fullName,
//                                       'id': widget.current.id,
//                                       'date_current': DateTime.now()
//                                           .toString()
//                                           .substring(0, 19)
//                                     };
//                                     // print(data);
//                                     updateReport(data);
//                                   },
//                                 );
//                               },
//                             );
//                           },
//                           icon: const Icon(
//                             Icons.close,
//                             color: Colors.white,
//                           ),
//                           label: const Text(
//                             'Marcar Resuelto',
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                           ),
//                         )
//                       : const SizedBox(),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 200,
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: widget.listProduct
//                       .map(
//                         (datos) => Card(
//                           elevation: 2,
//                           child: Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const SizedBox(height: 8),
//                                 Text('Producto: ${datos.product}'),
//                                 const SizedBox(height: 8),
//                                 Text('Cantidad: ${datos.cant}'),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'Costo: \$${datos.cost}',
//                                   style:
//                                       const TextStyle(color: colorsPuppleOpaco),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text('Fecha: ${datos.date}'),
//                                 const SizedBox(height: 8),
//                                 OutlinedButton(
//                                   onPressed: () async {
//                                     dialogFormUpdated(datos);
//                                     // if (value!.isEmpty) {
//                                     //   return;
//                                     // }
//                                     // print(value);
//                                     // updateCantida(value, datos.id);
//                                     // cant?.clear();
//                                   },
//                                   child: const Text('Actualizar'),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),

//                         // Row(
//                         //   children: [
//                         //     Text(e.id ?? 'N/A'),
//                         //     const SizedBox(width: 10),
//                         //     Text('Product : ${e.product ?? 'N/A'}'),
//                         //     const SizedBox(width: 10),
//                         //     Text('Cant ${e.cant ?? 'N/A'}'),
//                         //     const SizedBox(width: 10),
//                         //     Text('\$${e.cost ?? 'N/A'}'),
//                         //     const SizedBox(width: 10),
//                         //     Text(
//                         //         '\$${int.parse(e.cost ?? 'N/A') * int.parse(e.cant ?? 'N/A')}'),
//                         //     TextButton.icon(
//                         //         onPressed: () async {
//                         //           final value = await updateCost();
//                         //           if (value!.isEmpty) {
//                         //             return;
//                         //           }
//                         //           // print(value);
//                         //           updateCantida(value, e.id);
//                         //           cant?.clear();
//                         //         },
//                         //         icon: const Icon(
//                         //           Icons.edit,
//                         //           size: 10,
//                         //         ),
//                         //         label: const Text(
//                         //           'Actualizar',
//                         //           style: TextStyle(fontSize: 10),
//                         //         ))
//                         //   ],
//                         // ),
//                       )
//                       .toList(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
