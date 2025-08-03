// import 'package:flutter/material.dart';
// import '/src/datebase/current_data.dart';
// import '/src/datebase/methond.dart';
// import '/src/model/department.dart';
// import '/src/nivel_2/folder_confecion/add_trabajo_confecion.dart';
// import '/src/nivel_2/folder_confecion/model/confecion.dart';
// import '/src/nivel_2/folder_confecion/model/url_confecion.dart';
// import '/src/nivel_2/folder_confecion/print_confecion.dart';
// import '/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
// import '/src/screen_print_pdf/apis/pdf_api.dart';
// import '/src/util/get_time_relation.dart';
// import '/src/util/show_mesenger.dart';
// import '../../folder_incidencia_main/add_incidencia_main_desde_work.dart';
// import '../../util/get_formatted_number.dart';
// import '../../widgets/pick_range_date.dart';
// import '../folder_insidensia/pages_insidencia.dart/add_incidencia_report_desde_card.dart';
// import '../folder_reception/file_view_orden.dart';

// class ScreenConfecion extends StatefulWidget {
//   const ScreenConfecion({super.key, this.current});
//   final Department? current;

//   @override
//   State<ScreenConfecion> createState() => _ScreenConfecionState();
// }

// class _ScreenConfecionState extends State<ScreenConfecion> {
//   String? _firstDate = DateTime.now().toString().substring(0, 10);
//   String? _secondDate = DateTime.now().toString().substring(0, 10);
//   List<Confeccion> list = [];
//   List<Confeccion> listFilter = [];

//   String? messaje = 'Cargando... Espere por favor!';

//   @override
//   void initState() {
//     super.initState();

//     getWork();
//   }

//   Future getWork() async {
//     setState(() {
//       messaje = 'Cargando... Espere por favor!';
//       list.clear();
//     });
//     final res = await httpRequestDatabase(selectReportConfeccionDate,
//         {'date1': _firstDate, 'date2': _secondDate});
//     list = confeccionFromJson(res.body);
//     listFilter = [...list];

//     setState(() {
//       if (listFilter.isEmpty) {
//         messaje = 'No hay Reporte!';
//       }
//     });
//   }

//   Future updateEnd(Confeccion data) async {
//     await httpRequestDatabase(updateReportConfeccionDateEnd, {
//       'date_end': DateTime.now().toString().substring(0, 19),
//       'id': data.id
//     });
//     // debugPrint('start_date : --> ${res.body}');
//     final res = await httpRequestDatabase(selectReportConfeccionDate, {
//       'date1': _firstDate,
//       'date2': _secondDate,
//     });
//     list = confeccionFromJson(res.body);
//     setState(() {});
//   }

//   Future deleteFrom(Confeccion data) async {
//     await httpRequestDatabase(
//         deleteReportConfeccion, {'id': data.id.toString()});
//     getWork();
//   }

//   Future updatedComentario(id, comentario) async {
//     await httpRequestDatabase(
//         updateReportConfecionComentario, {'id': id, 'comment': comentario});
//   }

//   void searching(String value) {
//     // print(val);
//     if (value.isNotEmpty) {
//       listFilter = List.from(list
//           .where((x) =>
//               x.ficha!.toUpperCase().contains(value.toUpperCase()) ||
//               x.numOrden!.toUpperCase().contains(value.toUpperCase()) ||
//               x.nameLogo!.toUpperCase().contains(value.toUpperCase()))
//           .toList());
//       setState(() {});
//     } else {
//       listFilter = [...list];
//       setState(() {});
//     }
//   }

//   getTotalListPiezas(List<Confeccion> items) {
//     int subTotal = 0;
//     for (var item in items) {
//       subTotal += int.parse(item.cantPieza ?? '0');
//     }
//     return subTotal;
//   }

// //  TextButton(
// //                                                 onPressed: () {
// //                                                   Navigator.push(
// //                                                       context,
// //                                                       MaterialPageRoute(
// //                                                           builder: (context) =>
// //                                                               DetallesItem(
// //                                                                   item:
// //                                                                       item))).then(
// //                                                       (value) => {
// //                                                             getWork(),
// //                                                           });
// //                                                 },
// //                                                 child: const Text('Reportar'))

//   // item.dateEnd == 'N/A'
//   //     ? TextButton(
//   //         onPressed: () =>
//   //             updateEnd(item),
//   //         child: const Text('Reportar'),
//   //       )
//   //     :

//   //  Padding(
//   //                                               padding: const EdgeInsets.only(
//   //                                                   left: 10),
//   //                                               child: IconButton(
//   //                                                   onPressed: () {
//   //                                                     Navigator.push(
//   //                                                       context,
//   //                                                       MaterialPageRoute(
//   //                                                         builder: (context) =>
//   //                                                             AddComent(pressComent:
//   //                                                                 (comentatio) {
//   //                                                           var coment =
//   //                                                               '${item.comment} --- (Comentario : $comentatio)';
//   //                                                           updatedComentario(
//   //                                                               item.id,
//   //                                                               coment);
//   //                                                           // print(
//   //                                                           //     'El comentario es ${comentatio}');
//   //                                                         }),
//   //                                                       ),
//   //                                                     );
//   //                                                   },
//   //                                                   icon: const Icon(
//   //                                                     Icons.messenger,
//   //                                                     size: 15,
//   //                                                     color: Colors.orange,
//   //                                                   )),
//   //                                             )
//   @override
//   Widget build(BuildContext context) {
//     final style = Theme.of(context).textTheme;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Confección'),
//         actions: [
//           Container(
//             margin: const EdgeInsets.only(right: 10),
//             child: IconButton(
//                 onPressed: () async {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => AddTrabajoConfeccion(
//                               current: widget.current))).then((value) => {
//                         getWork(),
//                       });
//                 },
//                 icon: const Icon(Icons.add)),
//           ),
//           listFilter.isNotEmpty
//               ? Container(
//                   margin: const EdgeInsets.only(right: 25),
//                   child: IconButton(
//                       onPressed: () async {
//                         final pdfFile =
//                             await PdfReportConfecion.generate(listFilter);

//                         PdfApi.openFile(pdfFile);
//                       },
//                       icon: const Icon(Icons.print)),
//                 )
//               : const SizedBox()
//         ],
//       ),
//       body: Column(
//         children: [
//           const SizedBox(width: double.infinity),
//           DateRangeSelectionWidget(
//             press: (date1, date2) {
//               setState(() {
//                 _firstDate = date1;
//                 _secondDate = date2;

//                 getWork();
//               });
//               // getIncidencia(_firstDate, _secondDate);
//             },
//           ),
//           const SizedBox(height: 5),
//           Container(
//             width: 250,
//             color: Colors.white,
//             child: TextField(
//               onChanged: (val) => searching(val),
//               decoration: const InputDecoration(
//                 hintText: 'Buscar',
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.only(left: 15, top: 10),
//                 suffixIcon: Tooltip(message: 'Buscar /Ficha/Orden'),
//               ),
//             ),
//           ),
//           const SizedBox(height: 15),
//           listFilter.isNotEmpty
//               ? Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 50),
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       physics: const BouncingScrollPhysics(),
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.vertical,
//                         physics: const BouncingScrollPhysics(),
//                         child: DataTable(
//                           dataRowMaxHeight: 20,
//                           dataRowMinHeight: 15,
//                           horizontalMargin: 10.0,
//                           columnSpacing: 15,
//                           headingRowHeight: 20,
//                           decoration: const BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 Color.fromARGB(255, 205, 208, 221),
//                                 Color.fromARGB(255, 225, 228, 241),
//                                 Color.fromARGB(255, 233, 234, 238),
//                               ],
//                             ),
//                           ),
//                           border: TableBorder.symmetric(
//                               inside: const BorderSide(
//                                   style: BorderStyle.solid,
//                                   color: Colors.grey)),
//                           dataTextStyle: style.bodySmall,
//                           headingTextStyle: style.titleSmall,
//                           columns: const [
//                             DataColumn(label: Text('#Orden/Fichas')),
//                             DataColumn(label: Text('Logo')),
//                             DataColumn(label: Text('Tipo Trabajos')),
//                             DataColumn(label: Text('Qty Piezas')),
//                             DataColumn(label: Text('Inició')),
//                             DataColumn(label: Text('Terminó')),
//                             DataColumn(label: Text('Tiempo')),
//                             DataColumn(label: Text('Nota')),
//                             DataColumn(label: Text('Acción')),
//                           ],
//                           rows: listFilter
//                               .map((item) => DataRow(
//                                       color: MaterialStateProperty.resolveWith(
//                                           (states) => Colors.white),
//                                       cells: [
//                                         DataCell(
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 Text(item.numOrden ?? ''),
//                                                 const Text(' / '),
//                                                 Text(item.ficha ?? '')
//                                               ],
//                                             ), onTap: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (conext) => FileViewer(
//                                                     numOrden: item.numOrden)),
//                                           );
//                                         }),
//                                         DataCell(Text(item.nameLogo ?? ''),
//                                             onTap: () {
//                                           utilShowMesenger(
//                                               context, item.nameLogo ?? '',
//                                               title: 'LOGO');
//                                         }),
//                                         DataCell(
//                                           Text(item.tipoTrabajo ?? ''),
//                                           onTap: () {
//                                             utilShowMesenger(
//                                                 context, item.tipoTrabajo ?? '',
//                                                 title: 'TIPO TRABAJO');
//                                           },
//                                         ),
//                                         DataCell(Center(
//                                           child: Text(item.cantPieza ?? '',
//                                               textAlign: TextAlign.center,
//                                               style: const TextStyle(
//                                                   fontWeight: FontWeight.bold)),
//                                         )),
//                                         DataCell(Text(item.dateStart ?? 'N/A')),
//                                         DataCell(Text(item.dateEnd ?? 'N/A')),
//                                         DataCell(Text(getTimeRelation(
//                                             item.dateStart ?? 'N/A',
//                                             item.dateEnd ?? 'N/A'))),
//                                         DataCell(
//                                             SizedBox(
//                                                 width: 100,
//                                                 child: Text(item.comment ?? '',
//                                                     maxLines: 1)), onTap: () {
//                                           utilShowMesenger(
//                                               context, item.comment ?? '',
//                                               title: 'Nota');
//                                         }),
//                                         DataCell(TextButton(
//                                           child: const Text('Incidencia'),
//                                           onPressed: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (_) =>
//                                                     AddIncidenciaMainDesdeWork(
//                                                   orden: Sublima(
//                                                       numOrden: item.numOrden,
//                                                       ficha: item.ficha,
//                                                       nameDepartment: widget
//                                                           .current
//                                                           ?.nameDepartment),
//                                                   pickedDepart: Department(
//                                                       nameDepartment:
//                                                           item.nameDepartment),
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         ))
//                                       ]))
//                               .toList(),
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               : Expanded(
//                   child: Center(
//                       child: Text(messaje ?? 'No hay datos',
//                           style: style.titleMedium))),
//           listFilter.isNotEmpty
//               ? Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25),
//                   child: SizedBox(
//                     height: 35,
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: [
//                           Container(
//                             height: 35,
//                             decoration:
//                                 const BoxDecoration(color: Colors.white),
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 20),
//                               child: Center(
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text('Trabajo :', style: style.bodySmall),
//                                     const SizedBox(width: 10),
//                                     Text(listFilter.length.toString(),
//                                         style: style.bodySmall?.copyWith(
//                                             color: Colors.brown,
//                                             fontWeight: FontWeight.bold)),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Container(
//                             height: 35,
//                             decoration:
//                                 const BoxDecoration(color: Colors.white),
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 20),
//                               child: Center(
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text('QTY Pieza :', style: style.bodySmall),
//                                     const SizedBox(width: 10),
//                                     Text(
//                                         getNumFormated(
//                                             getTotalListPiezas(listFilter)),
//                                         style: style.bodySmall?.copyWith(
//                                             color: Colors.green,
//                                             fontWeight: FontWeight.bold)),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 )
//               : const SizedBox(),
//           identy(context)
//         ],
//       ),
//     );
//   }
// }

// // String diferentTime(Confeccion current) {
// //   Duration? diferences;
// //   DateTime date1 =
// //       DateTime.parse(current.dateStart.toString().substring(0, 19));
// //   DateTime date2 = DateTime.parse(current.dateEnd.toString().substring(0, 19));
// //   diferences = date2.difference(date1);

// //   return diferences.toString();
// // }
