// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'package:animate_do/animate_do.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import '/src/datebase/current_data.dart';
// import '/src/datebase/methond.dart';
// import '/src/datebase/url.dart';
// import '/src/home.dart';
// import '/src/nivel_2/folder_insidensia/model/product_incidencia.dart';
// import '/src/nivel_2/folder_insidensia/pages_insidencia.dart/selected_department.dart';
// import '/src/nivel_2/folder_insidensia/pages_insidencia.dart/selected_users_responsable.dart';
// import '/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
// import '/src/util/commo_pallete.dart';
// import '/src/util/font_style.dart';
// import '/src/util/show_mesenger.dart';
// import '/src/widgets/custom_app_bar.dart';

// class AddIncidenciaSublimacion extends StatefulWidget {
//   const AddIncidenciaSublimacion({super.key, required this.current});
//   final Sublima current;

//   @override
//   State<AddIncidenciaSublimacion> createState() =>
//       _AddIncidenciaSublimacionState();
// }

// class _AddIncidenciaSublimacionState extends State<AddIncidenciaSublimacion> {
//   late TextEditingController whatCause;
//   late TextEditingController whyCause;
//   late TextEditingController solucionWhat;
//   List<String> fivePorque = [];
//   List<String> categoriesQuejas = ['Externa', 'Interna', 'Sin Definir'];
//   late String _selectedCategory;
// // late TextEditingController name;
//   int indexPorque = 1;
//   @override
//   void initState() {
//     super.initState();
//     _selectedCategory = 'Externa';
//     whatCause = TextEditingController();
//     whyCause = TextEditingController();
//     solucionWhat = TextEditingController();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     whatCause.dispose();
//     whyCause.dispose();
//     solucionWhat.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // var textSize = 10.0;
//     final size = MediaQuery.of(context).size;
//     // print(size);

//     /////// de 0 a 600
//     if (size.width > 0 && size.width <= 600) {
//       //  textSize = size.width * 0.020;
//     } else {
//       //    textSize = size.width * 0.035;
//     }
//     final style = Theme.of(context).textTheme;
//     return Scaffold(
//       appBar: AppBar(title: const Text('Agregar Incidencia')),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           children: [
//             fivePorque.isEmpty
//                 ? const Text("")
//                 : Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: SizedBox(
//                       height: 65,
//                       width: size.width * 0.85,
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         physics: const BouncingScrollPhysics(),
//                         child: Row(
//                           children: fivePorque
//                               .map((e) => Container(
//                                   margin: const EdgeInsets.all(5.0),
//                                   padding: const EdgeInsets.all(15.0),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(3.0),
//                                     color: colorsAd,
//                                   ),
//                                   child: Text(
//                                     e,
//                                     style:
//                                         const TextStyle(color: colorsGreyWhite),
//                                   )))
//                               .toList(),
//                         ),
//                       ),
//                     ),
//                   ),
//             BounceInRight(
//               duration: const Duration(milliseconds: 300),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade200,
//                   borderRadius: BorderRadius.circular(
//                     10.0,
//                   ),
//                 ),
//                 width: size.width * 0.75,
//                 child: TextField(
//                   textInputAction: TextInputAction.next,
//                   controller: whyCause,
//                   decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     labelText: 'Que paso?',
//                     contentPadding: EdgeInsets.only(left: 10),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             indexPorque > 5
//                 ? const SizedBox()
//                 : Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       BounceInRight(
//                         duration: const Duration(milliseconds: 300),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade200,
//                             borderRadius: BorderRadius.circular(
//                               10.0,
//                             ),
//                           ),
//                           width: size.width * 0.69,
//                           child: TextField(
//                             onEditingComplete: () {
//                               if (indexPorque <= 5) {
//                                 if (whatCause.text.isNotEmpty) {
//                                   fivePorque.add(
//                                       '$indexPorque-Por Que?  ${whatCause.text}  ');

//                                   setState(() {
//                                     indexPorque++;
//                                     whatCause.clear();
//                                   });
//                                 } else {
//                                   utilShowMesenger(
//                                       context, 'Escribir el porque');
//                                 }
//                               } else {
//                                 utilShowMesenger(
//                                     context, 'Ya existe 5 Porque?');
//                               }
//                             },
//                             controller: whatCause,
//                             decoration: const InputDecoration(
//                               border: InputBorder.none,
//                               labelText: 'Por que ?',
//                               contentPadding: EdgeInsets.only(left: 10),
//                             ),
//                           ),
//                         ),
//                       ),
//                       TextButton(
//                           onPressed: () {
//                             if (indexPorque <= 5) {
//                               if (whatCause.text.isNotEmpty) {
//                                 fivePorque.add(
//                                     '$indexPorque-Por Que?  ${whatCause.text}  ');

//                                 setState(() {
//                                   indexPorque++;
//                                   whatCause.clear();
//                                 });
//                               } else {
//                                 utilShowMesenger(context, 'Escribir el porque');
//                               }
//                             } else {
//                               utilShowMesenger(context, 'Ya existe 5 Porque?');
//                             }
//                           },
//                           child: const Text('add'))
//                     ],
//                   ),
//             const SizedBox(height: 15),
//             BounceInRight(
//               duration: const Duration(milliseconds: 300),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade200,
//                   borderRadius: BorderRadius.circular(
//                     10.0,
//                   ),
//                 ),
//                 width: size.width * 0.75,
//                 child: TextField(
//                   textInputAction: TextInputAction.done,
//                   controller: solucionWhat,
//                   onEditingComplete: () {
//                     if (whatCause.text.isNotEmpty &&
//                         whyCause.text.isNotEmpty &&
//                         solucionWhat.text.isNotEmpty) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => ContinuousIncidenciaSublimacion(
//                                   current: {
//                                     'queja': _selectedCategory,
//                                     'whatCause': whatCause.text,
//                                     'whyCause': whyCause.text,
//                                     'solucionWhat': solucionWhat.text
//                                   },
//                                   currentOrden: widget.current,
//                                 )),
//                       );
//                     } else {
//                       utilShowMesenger(context, 'Campo vacios');
//                     }
//                   },
//                   decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     labelText: 'Solución / Compromiso?',
//                     contentPadding: EdgeInsets.only(left: 10),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 const Text('Queja : '),
//                 DropdownButton<String>(
//                   value: _selectedCategory,
//                   items: categoriesQuejas.map((category) {
//                     return DropdownMenuItem<String>(
//                       value: category,
//                       child: Text(category),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedCategory = value.toString();
//                     });
//                   },
//                 ),
//               ],
//             ),
//             BounceInRight(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 50.0),
//                 child: TextButton.icon(
//                   onPressed: () {
//                     if (fivePorque.isNotEmpty &&
//                         whyCause.text.isNotEmpty &&
//                         solucionWhat.text.isNotEmpty) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => ContinuousIncidenciaSublimacion(
//                                   current: {
//                                     'queja': _selectedCategory,
//                                     'whatCause': fivePorque.join(','),
//                                     'whyCause': whyCause.text,
//                                     'solucionWhat': solucionWhat.text
//                                   },
//                                   currentOrden: widget.current,
//                                 )),
//                       );
//                     } else {
//                       utilShowMesenger(context, 'Campo vacios');
//                     }
//                   },
//                   icon: const Icon(Icons.arrow_right_alt_outlined,
//                       color: Colors.white),
//                   label: Text(
//                     'Continual',
//                     style: TextStyle(
//                         color: Colors.white, fontFamily: fontBalooPaaji),
//                   ),
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.resolveWith(
//                         (states) => Colors.green),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CantPieza {
//   String? cant;
//   String? precio;
//   String? producto;
//   CantPieza({this.cant, this.precio, this.producto});
// }

// class ContinuousIncidenciaSublimacion extends StatefulWidget {
//   const ContinuousIncidenciaSublimacion(
//       {Key? key, required this.current, required this.currentOrden})
//       : super(key: key);
//   final Map current;
//   final Sublima currentOrden;
//   @override
//   State<ContinuousIncidenciaSublimacion> createState() =>
//       _ContinuousIncidenciaSublimacionState();
// }

// class _ContinuousIncidenciaSublimacionState
//     extends State<ContinuousIncidenciaSublimacion> {
//   late TextEditingController productos;
//   late TextEditingController cantBad;
//   List choosed = [];
//   List choosedResponsable = [];
//   ////////////Multi Imagen/////
//   List<File> listFile = [];
//   List<String> listBase64Imagen = [];

//   /// en usos
//   List<String> listFilename = [];
//   final ImagePicker _picker = ImagePicker();
//   /////////////////////////

//   /////los validator de image Picked
//   bool isMultiMedia = false;
//   bool isLoadingFoto = false;
//   bool idSendingData = false;
//   // List<ImageSublimacion> imageGetServer = [];
//   // uploadimagenIncidenciaSublimacion
//   String urlImage =
//       "http://$ipLocal/settingmat/admin/imagen_incidencia_sublimacion/";
//   ////////////////////////
//   var numRamdo = Random();
//   int? key;
//   @override
//   void initState() {
//     super.initState();

//     key = numRamdo.nextInt(999999999);
//     productos = TextEditingController();
//     cantBad = TextEditingController();
//   }

//   Future obtenerImage() async {
//     final List<XFile> image = await _picker.pickMultiImage(imageQuality: 80);
//     for (var element in image) {
//       // base64Image = base64Encode(file.readAsBytesSync());
//       // print('path de la imahgen ${element.path}');
//       listFile.add(File(element.path));
//       // print('Archivo : ${element.path}');
//       File localfile = File(element.path);
//       String localName = localfile.path.split('/').last;
//       // print('localName $localName');
//       listBase64Imagen.add(base64Encode(localfile.readAsBytesSync()));
//       listFilename.add(localName);
//       // await Future.delayed(const Duration(milliseconds: 100));
//     }
//     isMultiMedia = true;
//     setState(() {});
//   }

//   Future sendMulpleImage(List listBase64Imagen, String idkey) async {
//     int index = 0;

//     for (var item in listBase64Imagen) {
//       // print('Item es $item');
//       upLoadImagenServer(index, idkey);
//       index++;
//     }
//   }

//   Future upLoadImagenServer(int index, idkey) async {
//     final res = await httpRequestDatabase(uploadimagenIncidenciaSublimacion,
//         {'image': listBase64Imagen[index], 'name': listFilename[index]});

//     insertImageServer(listFilename[index].toString(), idkey);
//     print('Subiendo la imagen index:  $index  :  ${res.body}');
//     await Future.delayed(const Duration(seconds: 5));
//   }

//   /////metodo de insert el path de la imagen //////
//   Future insertImageServer(String path, String key) async {
//     await httpRequestDatabase(insertImagePathFileIncidencia, {
//       'image_path': path,
//       'id_key_image': key,
//       'date_current': DateTime.now().toString().substring(0, 19),
//     });
//   }

//   Future sendData() async {
//     if (listProductoIncidencia.isNotEmpty) {
//       setState(() {
//         idSendingData = true;
//       });

//       var resultadoDepartment = choosed.join(", ");
//       var resultadoUsuarios = choosedResponsable.join(", ");

//       var data = {
//         'logo': widget.currentOrden.nameLogo,
//         'depart': widget.currentOrden.nameDepartment,
//         'ficha': widget.currentOrden.ficha,
//         'num_orden': widget.currentOrden.numOrden,
//         'queja': widget.current['queja'],
//         'whatcause': widget.current['whatCause'],
//         'whycause': widget.current['whyCause'],
//         'solucionwhat': widget.current['solucionWhat'],
//         'productos': 'nada',
//         'cantbad': '1',
//         'depart_responsed': resultadoDepartment,
//         'users_responsed': resultadoUsuarios,
//         'id_key_image': key.toString(),
//         'user_created': currentUsers?.fullName,
//         'date_current': DateTime.now().toString().substring(0, 19),
//       };
//       await httpRequestDatabase(insertReportIncidencia, data);
//       // print('insertReportIncidencia : ${res.body}');
//       sendMulpleImage(listBase64Imagen, '$key');
//       await Future.delayed(const Duration(seconds: 5));
//       for (var element in listProductoIncidencia) {
//         await httpRequestDatabase(insertProductCostInsidencia, {
//           'id_key': key.toString(),
//           'product': element.product,
//           'cant': element.cant,
//           'cost': element.cost,
//         });
//       }

//       setState(() {
//         idSendingData = false;
//       });
//       // if (mounted) showMensenger(context, 'Listo todo reportado');
//       if (mounted) {
//         Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (conext) => const MyHomePage()),
//             (route) => false);
//       }
//     } else {
//       utilShowMesenger(context, 'No hay producto registrado');
//     }
//   }

//   FilePickerResult? result;

//   Future pickeFileWindow() async {
//     result = await FilePicker.platform.pickFiles(
//         allowMultiple: true,
//         dialogTitle: 'Select a file for our App',
//         type: FileType.custom,
//         allowedExtensions: [
//           'jpg',
//           'png',
//         ]);

//     if (result == null) return;

//     for (PlatformFile file in result!.files) {
//       File localfile = File(file.path!);
//       String localName = file.name;
//       // print('localName $localName');
//       listBase64Imagen.add(base64Encode(localfile.readAsBytesSync()));
//       listFilename.add(localName);
//       // print('Archivo : $listFilename');
//     }
//     isMultiMedia = true;
//     setState(() {});
//   }

//   List<ProductIncidencia> listProductoIncidencia = [];

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: idSendingData
//           ? const Center(
//               child: Text('Reportando ...'),
//             )
//           : SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 children: [
//                   const AppBarCustom(title: 'Continuar'),
//                   const SizedBox(height: 20),
//                   choosed.isNotEmpty
//                       ? SizedBox(
//                           height: 50,
//                           width: 300,
//                           child: ListView(
//                             physics: const BouncingScrollPhysics(),
//                             scrollDirection: Axis.horizontal,
//                             children: choosed
//                                 .map((e) => Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 15),
//                                       child: Chip(
//                                         label: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 15),
//                                           child: Text(e),
//                                         ),
//                                       ),
//                                     ))
//                                 .toList(),
//                           ),
//                         )
//                       : const SizedBox(),
//                   choosed.isEmpty
//                       ? Padding(
//                           padding: const EdgeInsets.all(25.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               const Text('Departamentos Responsables'),
//                               TextButton(
//                                 onPressed: () async {
//                                   await showDialog(
//                                       context: context,
//                                       builder: (context) {
//                                         return SelectedDepartments(
//                                           pressDepartment: (val) {
//                                             setState(() {
//                                               choosed = val;
//                                             });
//                                           },
//                                         );
//                                       });
//                                 },
//                                 child: const Text('Elegir'),
//                               )
//                             ],
//                           ),
//                         )
//                       : const SizedBox(),
//                   const SizedBox(height: 15),
//                   choosedResponsable.isEmpty
//                       ? Padding(
//                           padding: const EdgeInsets.all(25.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               const Text('Trajadores Responsables'),
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           SelectedUsersReponsable(
//                                         pressDepartment: (val) {
//                                           setState(() {
//                                             choosedResponsable = val;
//                                           });
//                                         },
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 child: const Text('Elegir'),
//                               )
//                             ],
//                           ),
//                         )
//                       : const SizedBox(),
//                   choosedResponsable.isNotEmpty
//                       ? SizedBox(
//                           height: 50,
//                           width: 300,
//                           child: ListView(
//                             physics: const BouncingScrollPhysics(),
//                             scrollDirection: Axis.horizontal,
//                             children: choosedResponsable
//                                 .map((e) => Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 15),
//                                       child: Chip(
//                                         label: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 15),
//                                           child: Text(e),
//                                         ),
//                                       ),
//                                     ))
//                                 .toList(),
//                           ),
//                         )
//                       : const SizedBox(),
//                   const SizedBox(height: 15),
//                   BounceInRight(
//                     duration: const Duration(milliseconds: 300),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade200,
//                         borderRadius: BorderRadius.circular(
//                           10.0,
//                         ),
//                       ),
//                       width: size.width * 0.75,
//                       child: TextField(
//                         textInputAction: TextInputAction.next,
//                         controller: productos,
//                         decoration: const InputDecoration(
//                           border: InputBorder.none,
//                           labelText: 'Producto',
//                           contentPadding: EdgeInsets.only(left: 10),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   BounceInRight(
//                     duration: const Duration(milliseconds: 300),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade200,
//                         borderRadius: BorderRadius.circular(
//                           10.0,
//                         ),
//                       ),
//                       width: size.width * 0.75,
//                       child: TextField(
//                         textInputAction: TextInputAction.next,
//                         controller: cantBad,
//                         keyboardType: TextInputType.number,
//                         onEditingComplete: () {
//                           if (productos.text.isNotEmpty &&
//                               cantBad.text.isNotEmpty) {
//                             ProductIncidencia product = ProductIncidencia(
//                               cant: cantBad.text,
//                               cost: '0',
//                               idKey: key.toString(),
//                               product: productos.text,
//                             );

//                             setState(() {
//                               listProductoIncidencia.add(product);
//                               productos.clear();
//                               cantBad.clear();
//                             });
//                           } else {
//                             utilShowMesenger(
//                                 context, 'Campos productos vacios');
//                           }
//                         },
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly
//                         ],
//                         decoration: const InputDecoration(
//                           border: InputBorder.none,
//                           labelText: 'Pieza mala',
//                           contentPadding: EdgeInsets.only(left: 10),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   ElevatedButton(
//                       onPressed: () {
//                         if (productos.text.isNotEmpty &&
//                             cantBad.text.isNotEmpty) {
//                           ProductIncidencia product = ProductIncidencia(
//                             cant: cantBad.text,
//                             cost: '0',
//                             idKey: key.toString(),
//                             product: productos.text,
//                           );

//                           setState(() {
//                             listProductoIncidencia.add(product);
//                             productos.clear();
//                             cantBad.clear();
//                           });
//                         } else {
//                           utilShowMesenger(context, 'Campos productos vacios');
//                         }
//                       },
//                       child: const Text('Agregar producto')),
//                   const SizedBox(height: 15),
//                   listProductoIncidencia.isNotEmpty
//                       ? SizedBox(
//                           height: 100,
//                           width: size.width * 0.90,
//                           child: SingleChildScrollView(
//                             physics: const BouncingScrollPhysics(),
//                             scrollDirection: Axis.horizontal,
//                             child: Row(
//                               children: listProductoIncidencia
//                                   .map((producto) => Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 20, vertical: 10),
//                                         child: Column(
//                                           children: [
//                                             Text(producto.product ?? 'N/A'),
//                                             Text(producto.cant ?? 'N/A'),
//                                             IconButton(
//                                                 onPressed: () {
//                                                   setState(() {
//                                                     listProductoIncidencia
//                                                         .remove(producto);
//                                                   });
//                                                 },
//                                                 icon: const Icon(Icons.close,
//                                                     color: Colors.red))
//                                           ],
//                                         ),
//                                       ))
//                                   .toList(),
//                             ),
//                           ),
//                         )
//                       : const SizedBox(),
//                   const SizedBox(height: 15),
//                   listProductoIncidencia.isNotEmpty
//                       ? BounceInDown(
//                           child: Material(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15.0),
//                           child: SizedBox(
//                             height: 100,
//                             width: 200,
//                             child: TextButton.icon(
//                               label: isMultiMedia
//                                   ? const Text('Correcto',
//                                       style: TextStyle(color: Colors.green))
//                                   : const Text('Foto'),
//                               icon: isMultiMedia
//                                   ? const Icon(
//                                       Icons.check_circle,
//                                       color: Colors.green,
//                                     )
//                                   : const Icon(Icons.camera),
//                               onPressed: Platform.isWindows
//                                   ? () => pickeFileWindow()
//                                   : () => obtenerImage(),
//                             ),
//                           ),
//                         ))
//                       : const SizedBox(),
//                   const SizedBox(height: 15),
//                   listProductoIncidencia.isNotEmpty
//                       ? BounceInRight(
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 50.0),
//                             child: SizedBox(
//                               width: 250,
//                               child: TextButton(
//                                 onPressed: isMultiMedia
//                                     ? () => sendData()
//                                     : () {
//                                         utilShowMesenger(context, 'Incompleto');
//                                       },
//                                 style: ButtonStyle(
//                                   backgroundColor:
//                                       MaterialStateProperty.resolveWith(
//                                           (states) => Colors.green),
//                                 ),
//                                 child: Text(
//                                   isMultiMedia ? 'Enviar ' : 'No Completo',
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontFamily: fontBalooPaaji),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         )
//                       : const SizedBox(),
//                 ],
//               ),
//             ),
//     );
//   }
// }
