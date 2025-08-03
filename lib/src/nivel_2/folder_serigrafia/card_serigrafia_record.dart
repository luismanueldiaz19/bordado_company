// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '/src/datebase/current_data.dart';
// import '/src/datebase/methond.dart';
// import '/src/datebase/url.dart';
// import '/src/model/department.dart';
// import '/src/nivel_2/folder_insidensia/pages_insidencia.dart/add_incidencia_report_desde_card.dart';
// import '/src/nivel_2/forder_sublimacion/widgets/percent_star.dart';
// import '/src/nivel_2/forder_sublimacion/model_nivel/image_get_path_file.dart';
// import '/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
// import '/src/nivel_2/forder_sublimacion/widgets/show_image.dart';
// import '/src/util/commo_pallete.dart';
// import '/src/util/font_style.dart';
// import 'package:file_picker/file_picker.dart';

// import '../../folder_incidencia_main/add_incidencia_main_desde_work.dart';

// class CardSerigrafiaRecord extends StatefulWidget {
//   const CardSerigrafiaRecord({
//     super.key,
//     required this.current,
//     required this.eliminarPress,
//   });
//   final Sublima current;
//   final Function eliminarPress;

//   @override
//   State<CardSerigrafiaRecord> createState() => _CardSerigrafiaRecordState();
// }

// class _CardSerigrafiaRecordState extends State<CardSerigrafiaRecord> {
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
//   List<ImageGetPathFile> imageGetServer = [];
//   String urlImage =
//       "http://$ipLocal/tejidos/admin/imagen_serigrafia_department/";
//   ////////////////////////

//   String diferentTime(Sublima current) {
//     Duration? diferences;
//     DateTime date1 =
//         DateTime.parse(current.dateStart.toString().substring(0, 19));
//     DateTime date2 =
//         DateTime.parse(current.dateEnd.toString().substring(0, 19));
//     diferences = date2.difference(date1);

//     return diferences.toString().substring(0, 8);
//   }

//   double getPercent() {
//     double percentRelation = 0.0;
//     percentRelation = (double.parse(widget.current.cantPieza.toString()) /
//             double.parse(widget.current.cantOrden.toString())) *
//         100;
//     return percentRelation;
//   }

//   Future obtenerImage() async {
//     // print(Platform.isWindows);
//     if (Platform.isWindows) {
//       return pickeFileWindow();
//     }

//     if (Platform.isAndroid) {
//       return pickedAndroid();
//     }
//   }

//   Future pickedAndroid() async {
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

//   Future sendMulpleImage(List listBase64Imagen) async {
//     setState(() {
//       isLoadingFoto = true;
//     });
//     for (int i = 0; i < listBase64Imagen.length; i++) {
//       await httpRequestDatabase(uploadImagenSerigrafia, {
//         'image': '${listBase64Imagen[i]}',
//         'name': listFilename[i],
//         // 'token': appTOKEN,
//       });
//       insertImageServer(listFilename[i].toString());
//     }
//     // print('Exit Ciclo imagen');
//     setState(() {
//       isLoadingFoto = false;
//       isMultiMedia = false;
//     });
//     getImageServer();
//   }

// /////metodo de insert el path de la imagen //////
//   Future insertImageServer(String path) async {
//     await httpRequestDatabase(insertImagePathFile, {
//       'image_path': path,
//       'id_path': widget.current.id,
//       'date_current': DateTime.now().toString().substring(0, 19),
//     });
//   }

//   Future getImageServer() async {
//     final res = await httpRequestDatabase(
//         selectImagePathFile, {'id_path': widget.current.id});
//     // print('Image del servidor ${res.body}');
//     imageGetServer = imageGetPathFileFromJson(res.body);
//     // print(imageGetServer.length);
//     if (imageGetServer.isNotEmpty) {
//       if (mounted) setState(() {});
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getImageServer();
//   }

//   //////////////is Window picked image ///////
//   ///
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

//   @override
//   Widget build(BuildContext context) {
//     var textSize = 10.0;
//     final size = MediaQuery.of(context).size;
//     // print(size);

//     /////// de 0 a 600
//     if (size.width > 0 && size.width <= 600) {
//       textSize = size.width * 0.020;
//     } else {
//       textSize = 15;
//     }
//     bool isPktReport = false;
//     if (widget.current.nameWork == 'PINTANDO' ||
//         widget.current.nameWork == 'CUADRAR MARCOS') {
//       isPktReport = true;
//     }
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Material(
//         borderRadius: BorderRadius.circular(5.0),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Column(
//             children: [
//               // ElevatedButton(
//               //   onPressed: () {
//               //     showMensenger(context,
//               //         'Informacion id Reporte : ${widget.current.id} -->   orden : ${widget.current.numOrden} \n Cantidad Ordens : ${widget.current.cantOrden} \n  Cantidad Piezaz : ${widget.current.cantPieza} \n Full Piezaz : ${widget.current.dFull}  \n Colors Full Piezaz : ${widget.current.colorfull} \n Colors PKT Piezaz : ${widget.current.colorpkt}');
//               //   },
//               //   child: Text('Ver Informacion'),
//               // ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Expanded(
//                     flex: 4,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 1, vertical: 20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Operario : ${widget.current.fullName.toString()}",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleSmall!
//                                 .copyWith(fontSize: textSize),
//                           ),
//                           Text(
//                             "Logo : ${widget.current.nameLogo.toString()}",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .subtitle2!
//                                 .copyWith(fontSize: textSize),
//                           ),
//                           Text(
//                             "Trabajo : ${widget.current.nameWork.toString()}",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .subtitle1!
//                                 .copyWith(fontSize: textSize),
//                           ),
//                           Row(
//                             children: [
//                               Row(
//                                 children: [
//                                   Text(
//                                     'Orden : ',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodySmall!
//                                         .copyWith(fontSize: textSize),
//                                   ),
//                                   Text(
//                                     widget.current.cantOrden.toString(),
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodySmall!
//                                         .copyWith(
//                                             color: Colors.blueAccent,
//                                             fontSize: textSize),
//                                   ),
//                                 ],
//                               ),
//                               Text(
//                                 ' / ',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodySmall!
//                                     .copyWith(fontSize: textSize),
//                               ),
//                               Row(
//                                 children: [
//                                   Text(
//                                     'Pcs : ',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodySmall!
//                                         .copyWith(fontSize: textSize),
//                                   ),
//                                   Text(
//                                     widget.current.cantPieza.toString(),
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodySmall!
//                                         .copyWith(fontSize: textSize),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                           isPktReport
//                               ? Column(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Text(
//                                           "PKT :  ${widget.current.pkt.toString()}",
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .bodySmall!
//                                               .copyWith(fontSize: textSize),
//                                         ),
//                                         Text(
//                                           ' / ',
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .bodySmall,
//                                         ),
//                                         Text(
//                                           "Full : ${widget.current.dFull.toString()}",
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .bodySmall!
//                                               .copyWith(
//                                                   color: Colors.blueAccent,
//                                                   fontSize: textSize),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 5),
//                                     Row(
//                                       children: [
//                                         Text(
//                                           "Color PKT : ${widget.current.colorpkt.toString()}",
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .bodySmall!
//                                               .copyWith(
//                                                   color: Colors.blueAccent,
//                                                   fontSize: textSize),
//                                         ),
//                                         const SizedBox(width: 15),
//                                         Container(
//                                           width: 15.0,
//                                           height: 15.0,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(4.0),
//                                             gradient: LinearGradient(
//                                               begin: Alignment.topLeft,
//                                               end: Alignment.bottomRight,
//                                               colors: [
//                                                 Colors.primaries[Random()
//                                                     .nextInt(Colors
//                                                         .primaries.length)],
//                                                 Colors.primaries[Random()
//                                                     .nextInt(Colors
//                                                         .primaries.length)],
//                                                 Colors.primaries[Random()
//                                                     .nextInt(Colors
//                                                         .primaries.length)],
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 5),
//                                     Row(
//                                       children: [
//                                         Text(
//                                           "Color Full : ${widget.current.colorfull.toString()}",
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .bodySmall!
//                                               .copyWith(
//                                                   color: Colors.blueAccent,
//                                                   fontSize: textSize),
//                                         ),
//                                         const SizedBox(width: 15),
//                                         Container(
//                                           width: 15.0,
//                                           height: 15.0,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(4.0),
//                                             gradient: LinearGradient(
//                                               begin: Alignment.topLeft,
//                                               end: Alignment.bottomRight,
//                                               colors: [
//                                                 Colors.primaries[Random()
//                                                     .nextInt(Colors
//                                                         .primaries.length)],
//                                                 Colors.primaries[Random()
//                                                     .nextInt(Colors
//                                                         .primaries.length)],
//                                                 Colors.primaries[Random()
//                                                     .nextInt(Colors
//                                                         .primaries.length)],
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 )
//                               : const SizedBox(),
//                           const SizedBox(height: 10),
//                           Row(
//                             children: [
//                               const Icon(
//                                 Icons.timer,
//                                 color: Colors.orange,
//                               ),
//                               Text(
//                                 ' --- ',
//                                 style: Theme.of(context).textTheme.bodySmall,
//                               ),
//                               Text(
//                                 'TimeLog',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodySmall!
//                                     .copyWith(
//                                       color: Colors.orange,
//                                       fontSize: textSize,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 1),
//                           Text(
//                             'Iniciado ${widget.current.dateStart.toString()}',
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyLarge!
//                                 .copyWith(
//                                     color: Colors.teal,
//                                     fontFamily: fontMuseo,
//                                     fontSize: textSize),
//                           ),
//                           Text(
//                             'Finalizado ${widget.current.dateEnd.toString()}',
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyLarge!
//                                 .copyWith(
//                                     color: Colors.redAccent,
//                                     fontFamily: fontMuseo,
//                                     fontSize: textSize),
//                           ),
//                           Text(
//                               diferentTime(widget.current)
//                                   .toString()
//                                   .substring(0, 7),
//                               style: TextStyle(fontSize: textSize)),
//                           const SizedBox(height: 5),
//                           widget.current.statu == 't'
//                               ? Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     const Icon(Icons.check,
//                                         color: colorsGreenLevel),
//                                     const SizedBox(width: 5),
//                                     Text(
//                                       'Calidad Verificada',
//                                       style: TextStyle(
//                                           color: colorsGreenLevel,
//                                           fontWeight: FontWeight.bold,
//                                           fontFamily: fontTenali),
//                                     ),
//                                   ],
//                                 )
//                               : Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     const Icon(Icons.close, color: colorsRed),
//                                     const SizedBox(width: 5),
//                                     Text(
//                                       'Calidad no verificada',
//                                       style: TextStyle(
//                                           color: colorsRed,
//                                           fontWeight: FontWeight.bold,
//                                           fontFamily: fontTenali),
//                                     ),
//                                   ],
//                                 )
//                         ],
//                       ),
//                     ),
//                   ),
//                   imageGetServer.isNotEmpty
//                       ? Expanded(
//                           flex: 2,
//                           child: TextButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (_) => ShowImageFile(
//                                             current: widget.current,
//                                             images: imageGetServer,
//                                             urlImage: urlImage,
//                                           )),
//                                 );
//                               },
//                               child: const Text('Ver Imagen')
//                               // ClipRRect(
//                               //   borderRadius: BorderRadius.circular(15),
//                               //   child: Image.network(
//                               //     '$urlImage${imageGetServer[0].imagePath}',
//                               //     loadingBuilder:
//                               //         (context, child, loadingProgress) {
//                               //       if (loadingProgress == null) return child;
//                               //       return const Center(
//                               //           child: Text('Loading...'));
//                               //     },
//                               //     errorBuilder: (context, error, stackTrace) {
//                               //       return const Text('Error Imagen');
//                               //     },
//                               //     cacheHeight: 70,
//                               //     cacheWidth: 70,
//                               //     fit: BoxFit.fill,
//                               //   ),
//                               // ),
//                               ),
//                         )
//                       : const Expanded(
//                           child: Text(''),
//                         ),
//                   Expanded(
//                     flex: 3,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Num Orden ${widget.current.numOrden.toString()}',
//                           style: Theme.of(context)
//                               .textTheme
//                               .headline6!
//                               .copyWith(fontSize: textSize),
//                         ),
//                         Text(
//                           'Ficha : ${widget.current.ficha.toString()}',
//                           style: Theme.of(context)
//                               .textTheme
//                               .subtitle1!
//                               .copyWith(fontSize: textSize),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               widget.current.nameDepartment.toString(),
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodySmall!
//                                   .copyWith(
//                                       color: Colors.blueAccent,
//                                       fontSize: textSize),
//                             ),
//                           ],
//                         ),
//                         Text(
//                           widget.current.turn.toString(),
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodySmall!
//                               .copyWith(
//                                   color: Colors.black, fontSize: textSize),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             // Text('% ', style: styleTitle),
//                             Text(
//                               '${getPercent().clamp(0, 100).toStringAsFixed(2)} %',
//                               style: TextStyle(
//                                   color: Colors.green,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: textSize),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         currentUsers?.occupation == OptionAdmin.master.name ||
//                                 currentUsers?.occupation ==
//                                     OptionAdmin.admin.name
//                             ? ElevatedButton(
//                                 onPressed: () {
//                                   widget.eliminarPress(widget.current);
//                                 },
//                                 style: ButtonStyle(
//                                     backgroundColor:
//                                         MaterialStateProperty.resolveWith(
//                                             (states) => Colors.red)),
//                                 child: Text(
//                                   'Eliminar',
//                                   style: TextStyle(
//                                       fontSize: textSize, color: Colors.white),
//                                 ),
//                               )
//                             : const SizedBox(),
//                         const SizedBox(height: 10),
//                         imageGetServer.isEmpty
//                             ? isLoadingFoto
//                                 ? const Padding(
//                                     padding: EdgeInsets.only(top: 15),
//                                     child: SizedBox(
//                                       height: 30,
//                                       width: 30,
//                                       child: CircularProgressIndicator(
//                                         color: Colors.red,
//                                       ),
//                                     ),
//                                   )
//                                 : Padding(
//                                     padding: const EdgeInsets.all(1.0),
//                                     child: ElevatedButton.icon(
//                                       icon: isMultiMedia
//                                           ? const Icon(Icons.check_circle,
//                                               color: Colors.white)
//                                           : const Icon(Icons.camera,
//                                               color: Colors.white),
//                                       onPressed: isMultiMedia
//                                           ? () =>
//                                               sendMulpleImage(listBase64Imagen)
//                                           : () => obtenerImage(),
//                                       style: ButtonStyle(
//                                           backgroundColor:
//                                               MaterialStateProperty.resolveWith(
//                                                   (states) => isMultiMedia
//                                                       ? Colors.green
//                                                       : Colors.blueAccent)),
//                                       label: Text(
//                                         isMultiMedia
//                                             ? 'Cargar '
//                                             : 'Agregar Foto',
//                                         style: TextStyle(
//                                             fontSize: textSize,
//                                             color: Colors.white),
//                                       ),
//                                     ),
//                                   )
//                             : const SizedBox()
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     ElevatedButton.icon(
//                       icon: const Icon(Icons.live_help_outlined,
//                           color: Colors.red),
//                       style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.resolveWith(
//                             (states) => Colors.white),
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => AddIncidenciaMainDesdeWork(
//                               orden: widget.current,
//                               pickedDepart: Department(
//                                 nameDepartment: widget.current.nameDepartment,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                       label: const Text(
//                         'Incidencia',
//                         style: TextStyle(color: Colors.black),
//                       ),
//                     ),
//                     // StarRating(percent: getPercent()),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
