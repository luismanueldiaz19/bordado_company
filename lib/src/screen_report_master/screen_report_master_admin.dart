// import 'dart:math';

// import 'package:flutter/material.dart';
// import '/src/datebase/current_data.dart';
// import '/src/datebase/methond.dart';
// import '/src/datebase/url.dart';
// import '/src/model/report_admin.dart';
// import '/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
// import '/src/screen_report_master/add_report_item_admin.dart';
// import '/src/screen_report_master/dialog_report_admin.dart';
// import '/src/util/commo_pallete.dart';
// import '/src/widgets/custom_app_bar.dart';

// class ScreenReportMaster extends StatefulWidget {
//   const ScreenReportMaster({Key? key, this.list, this.isReport = false})
//       : super(key: key);
//   final List<Sublima>? list;
//   final bool? isReport;
//   @override
//   State<ScreenReportMaster> createState() => _ScreenReportMasterState();
// }

// class _ScreenReportMasterState extends State<ScreenReportMaster> {
//   List<DateTime> listaFechas = [];

//   DateTime fechaActual = DateTime.now();

//   Future inserDate() async {
//     // while (fechaActual.year == DateTime.now().year && fechaActual.month <= 12) {
//     listaFechas.add(fechaActual);
//     Random num = Random();
//     final res = await httpRequestDatabase(insertRevisionReported, {
//       'id_key_revision': num.nextInt(999999999).toString(),
//       'date_current': fechaActual.toString().substring(0, 10),
//       'is_working': 't',
//     });
//     print(res.body);
//     // await Future.delayed(const Duration(milliseconds: 200));

//     // if (fechaActual.month == 12 && fechaActual.day == 31) {
//     //   break;
//     // }

//     // fechaActual = fechaActual.add(const Duration(days: 1));
//     // id_key_revision, , is_working
//     // }
//     // print('Dias Restante del year ${listaFechas.length}');
//     // print('List year ${listaFechas}');
//   }

//   List<ReportAdmin> list = [];
//   List<ReportAdmin> listFilter = [];
//   Future getReported(date1, date2) async {
//     final res = await httpRequestDatabase(selectRevisionReportedByDate, {
//       'date1': date1,
//       'date2': date2,
//     });
//     print(res.body);
//     list = reportAdminFromJson(res.body);
//     listFilter = [...list];
//     if (listFilter.isNotEmpty) {
//       // filterList('f');
//       setState(() {});
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getReported(dateActual.toString().substring(0, 10),
//         dateActual?.add(const Duration(days: 0)).toString().substring(0, 10));
//   }

//   bool compareDate(String dateLocal) {
//     String fechaVencimientoString =
//         dateLocal; // fecha de vencimiento en formato de cadena

//     DateTime fechaVencimiento = DateTime.parse(
//         fechaVencimientoString); // convierte la cadena a un objeto DateTime

//     DateTime fechaActual = dateActual!;

//     if (fechaActual.isAfter(fechaVencimiento)) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future deleteFrom(id) async {
//     final res =
//         await httpRequestDatabase(deleteRevisionReported, {'id': '$id'});

//     if (res.body.toString() == 'good') {
//       list.removeWhere((element) => element.id == id);
//       setState(() {});
//     }
//   }

//   Future updateLaborable(id, value, index) async {
//     final res = await httpRequestDatabase(
//         updateRevisionReportedLaborable, {'id': '$id', 'is_working': '$value'});
//     // $is_working = $_POST['is_working'];
//     //               $id = $_POST['id'];
//     // print(res.body);
//     if (res.body.toString() == 'good') {
//       // list.removeWhere((element) => element.id == id);

//       // var item = list.where((element) => element.id == id);
//       list.elementAt(index).isWorking = value;
//       setState(() {});
//     }
//   }

//   Future updatedFrom(id) async {
//     ///is_working, id , id_reported
//     final res = await httpRequestDatabase(updateRevisionReportedIsRepoted, {
//       'is_working': 't',
//       'id_reported': 't',
//       'id': id.toString(),
//     });
//     // print('updatedFrom :   ${res.body}');
//     if (res.body == 'good') {
//       getReported(dateActual.toString().substring(0, 10),
//           dateActual?.add(const Duration(days: 0)).toString().substring(0, 10));
//     }
//   }

//   Future showReportAdmin(ReportAdmin idRevision) async {
//     //id_key_revision
//     // print(currentUsers?.id);
//     final res = await httpRequestDatabase(selectRevisionReportedItemsIdkey,
//         {'id_key_revision': idRevision.idKeyRevision.toString()});
//     // print(res.body);
//     if (currentUsers?.id == '2') {
//       await httpRequestDatabase(updateRevisionReportedIsAdminCheck,
//           {'id': idRevision.id.toString(), 'is_admin_check': 't'});
//     }
//     // print('Check ${resCheck.body}');

//     List<ReportAdmin> list = reportAdminFromJson(res.body);
//     if (list.isNotEmpty) {
//       if (mounted) {
//         await showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return MyDialog(dataList: list);
//             });
//       }
//     }
//   }

//   // String _selectedOption = 'Sin Revisar'; // opción seleccionada por defecto
//   // void filterList(String value) {
//   //   if (value.isNotEmpty) {
//   //     listFilter = list
//   //         .where((item) =>
//   //             item.idReported.toString().toLowerCase() == value.toLowerCase() &&
//   //             item.idReported.toString().toLowerCase() == value.toLowerCase())
//   //         .toList();
//   //     setState(() {});
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           const AppBarCustom(title: 'Revisiones De Supervisores'),
//           const SizedBox(height: 10),
//           currentUsers?.id == '1'
//               ? TextButton(
//                   onPressed: () => inserDate(),
//                   child: const Text('Generar Reportes'),
//                 )
//               : const SizedBox(),
//           // Text(
//           //   'Fecha Actual ${dateActual.toString().substring(0, 10)}',
//           //   style: const TextStyle(
//           //       fontSize: 20,
//           //       fontFamily: '',
//           //       fontStyle: FontStyle.italic,
//           //       fontWeight: FontWeight.w600),
//           // ),
//           // Container(
//           //   height: 35,
//           //   decoration: BoxDecoration(
//           //     borderRadius: BorderRadius.circular(5),
//           //   ),
//           //   padding: const EdgeInsets.symmetric(horizontal: 16),
//           //   child: DropdownButton<String>(
//           //     // focusColor: colorsPuppleOpaco.withOpacity(0.6),
//           //     dropdownColor: colorsGreyWhite,
//           //     value: _selectedOption,
//           //     icon: const Icon(Icons.arrow_drop_down),
//           //     iconSize: 24,
//           //     elevation: 16,
//           //     style: const TextStyle(color: Colors.black),
//           //     underline: Container(
//           //       height: 2,
//           //       color: Colors.transparent,
//           //     ),
//           //     onChanged: (String? newValue) {
//           //       setState(() {
//           //         _selectedOption = newValue!;
//           //         if (_selectedOption == 'Sin Revisar') {
//           //           filterList('f');
//           //         } else {
//           //           filterList('t');
//           //         }
//           //       });
//           //     },
//           //     items: <String>['Sin Revisar', 'Revisado']
//           //         .map<DropdownMenuItem<String>>((String value) {
//           //       return DropdownMenuItem<String>(
//           //         value: value,
//           //         child: Text(value),
//           //       );
//           //     }).toList(),
//           //   ),
//           // ),
//           const SizedBox(height: 10),
//           Expanded(
//             child: ListView.builder(
//               itemCount: listFilter.length,
//               itemBuilder: (BuildContext context, int index) {
//                 ReportAdmin current = listFilter[index];
//                 // print(current.isAdminCheck);
//                 return adminTest(current, index, context);
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   // Container adminWorkReport(
//   //     ReportAdmin current, int index, BuildContext context) {
//   //   return Container(
//   //     margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
//   //     decoration: BoxDecoration(
//   //       color: colorsGreyWhite,
//   //       borderRadius: BorderRadius.circular(10.0),
//   //       boxShadow: [
//   //         BoxShadow(
//   //           color: colorsAd.withOpacity(0.3),
//   //           spreadRadius: 2,
//   //           blurRadius: 5,
//   //           offset: const Offset(0, 3),
//   //         ),
//   //       ],
//   //     ),
//   //     child: Column(
//   //       children: [
//   //         ListTile(
//   //           title: Text("Reporte Ala Fecha con el id: ${current.id}"),
//   //           subtitle: Column(
//   //             crossAxisAlignment: CrossAxisAlignment.start,
//   //             children: [
//   //               Row(
//   //                 children: [
//   //                   Text("Fecha: ${current.dateCurrent}"),
//   //                   const SizedBox(width: 10),
//   //                   Icon(
//   //                     Icons.public_off,
//   //                     size: 12,
//   //                     color: compareDate(current.dateCurrent ?? '')
//   //                         ? Colors.red
//   //                         : Colors.green,
//   //                   ),
//   //                   current.idReported == 't'
//   //                       ? IconButton(
//   //                           onPressed: () => showReportAdmin(current),
//   //                           icon: const Icon(Icons.double_arrow_rounded))
//   //                       : const SizedBox(),
//   //                   current.idReported == 't'
//   //                       ? const Text('Realizado')
//   //                       : const SizedBox()
//   //                 ],
//   //               ),
//   //               compareDate(current.dateCurrent ?? '')
//   //                   ? Row(
//   //                       children: [
//   //                         const Text("Reporta"),
//   //                         const SizedBox(width: 10),
//   //                         Text(
//   //                           current.idReported == 'f'
//   //                               ? 'Sin Reportar'
//   //                               : 'Realizado',
//   //                           style: TextStyle(
//   //                               color: current.idReported == 'f'
//   //                                   ? Colors.red
//   //                                   : Colors.green),
//   //                         ),
//   //                       ],
//   //                     )
//   //                   : const SizedBox(),
//   //               Row(
//   //                 children: [
//   //                   const Text("Statu"),
//   //                   const SizedBox(width: 10),
//   //                   TextButton(
//   //                     onPressed: () {
//   //                       updateLaborable(current.id,
//   //                           current.isWorking == 't' ? 'f' : 't', index);
//   //                     },
//   //                     child: Text(
//   //                       current.isWorking == 't' ? 'Laborable' : 'No Laborable',
//   //                       style: TextStyle(
//   //                           color: current.isWorking == 't'
//   //                               ? Colors.green
//   //                               : colorsAd),
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //               current.isWorking == 'f'
//   //                   ? currentUsers?.occupation == OptionAdmin.master.name
//   //                       ? Padding(
//   //                           padding: const EdgeInsets.all(8.0),
//   //                           child: TextButton.icon(
//   //                               icon: const Icon(Icons.close,
//   //                                   color: colorsRedOpaco),
//   //                               onPressed: () =>
//   //                                   deleteFrom(current.id.toString()),
//   //                               label: const Text(
//   //                                 'Delete',
//   //                                 style: TextStyle(color: colorsRedOpaco),
//   //                               )),
//   //                         )
//   //                       : const SizedBox()
//   //                   : const SizedBox()
//   //             ],
//   //           ),
//   //         ),
//   //         const Divider(),
//   //         compareDate(current.dateCurrent ?? '')
//   //             ? Padding(
//   //                 padding: const EdgeInsets.all(8.0),
//   //                 child: Center(
//   //                   child: Column(
//   //                     children: const [
//   //                       Icon(
//   //                         Icons.lock,
//   //                         color: Colors.red,
//   //                         size: 30,
//   //                       ),
//   //                       Text(
//   //                         'Bloqueado',
//   //                         style: TextStyle(fontWeight: FontWeight.w600),
//   //                       )
//   //                     ],
//   //                   ),
//   //                 ),
//   //               )
//   //             : widget.isReport ?? false
//   //                 ? Padding(
//   //                     padding: const EdgeInsets.all(20.0),
//   //                     child: SizedBox(
//   //                       // width: 150,
//   //                       child: ElevatedButton(
//   //                           onPressed: () {
//   //                             Navigator.push(
//   //                               context,
//   //                               MaterialPageRoute(
//   //                                 builder: (conext) => AddReportItemMaster(
//   //                                     list: widget.list ?? [],
//   //                                     current: current),
//   //                               ),
//   //                             );
//   //                           },
//   //                           child: const Text('Reportar a la fecha')),
//   //                     ),
//   //                   )
//   //                 : const SizedBox(),
//   //         Padding(
//   //           padding: const EdgeInsets.all(8.0),
//   //           child: TextButton.icon(
//   //               icon: const Icon(Icons.fingerprint_sharp,
//   //                   color: colorsPuppleOpaco),
//   //               onPressed: () => updatedFrom(current.id.toString()),
//   //               label: const Text(
//   //                 'Terminar',
//   //                 style: TextStyle(color: colorsPuppleOpaco),
//   //               )),
//   //         )
//   //       ],
//   //     ),
//   //   );
//   // }

//   Container adminTest(ReportAdmin current, int index, BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
//       decoration: BoxDecoration(
//         color: colorsGreyWhite,
//         borderRadius: BorderRadius.circular(10.0),
//         boxShadow: [
//           BoxShadow(
//             color: colorsAd.withOpacity(0.3),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           ListTile(
//             title: const Text("Reporte Ala Fecha"),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 isNormal(current, index)
//                 // : compareDate(current.dateCurrent ?? '')
//                 //     ? isBlocked(current, index)
//                 //     : isNormal(current, index),
//               ],
//             ),
//           ),
//           current.isAdminCheck == 't'
//               ? const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Text('Revisador Administrador'),
//                 )
//               : const SizedBox()
//         ],
//       ),
//     );
//   }

//   // Column isBlocked(ReportAdmin current, index) {
//   //   return Column(
//   //     crossAxisAlignment: CrossAxisAlignment.start,
//   //     children: [
//   //       Row(
//   //         children: [
//   //           Text("Fecha: ${current.dateCurrent}"),
//   //           const SizedBox(width: 10),
//   //           Icon(
//   //             Icons.public_off,
//   //             size: 12,
//   //             color: compareDate(current.dateCurrent ?? '')
//   //                 ? Colors.red
//   //                 : Colors.green,
//   //           ),
//   //           current.idReported == 't'
//   //               ? IconButton(
//   //                   onPressed: () => showReportAdmin(current),
//   //                   icon: const Icon(Icons.remove_red_eye))
//   //               : const SizedBox(),
//   //           current.idReported == 't'
//   //               ? const Text('Realizado')
//   //               : const SizedBox()
//   //         ],
//   //       ),
//   //       compareDate(current.dateCurrent ?? '')
//   //           ? Row(
//   //               children: [
//   //                 const Text("Reporta"),
//   //                 const SizedBox(width: 10),
//   //                 Text(
//   //                   current.idReported == 'f' ? 'Sin Reportar' : 'Realizado',
//   //                   style: TextStyle(
//   //                       color: current.idReported == 'f'
//   //                           ? Colors.red
//   //                           : Colors.green),
//   //                 ),
//   //               ],
//   //             )
//   //           : const SizedBox(),
//   //       Row(
//   //         children: [
//   //           const Text("Statu"),
//   //           const SizedBox(width: 10),
//   //           TextButton(
//   //             onPressed: () {
//   //               updateLaborable(
//   //                   current.id, current.isWorking == 't' ? 'f' : 't', index);
//   //             },
//   //             child: Text(
//   //               current.isWorking == 't' ? 'Laborable' : 'No Laborable',
//   //               style: TextStyle(
//   //                   color: current.isWorking == 't' ? Colors.green : colorsAd),
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //       const Divider(),
//   //       current.idReported == 'f'
//   //           ? Row(
//   //               children: [
//   //                 widget.isReport ?? false
//   //                     ? Padding(
//   //                         padding: const EdgeInsets.all(20.0),
//   //                         child: SizedBox(
//   //                           // width: 150,
//   //                           child: ElevatedButton(
//   //                               onPressed: () {
//   //                                 Navigator.push(
//   //                                   context,
//   //                                   MaterialPageRoute(
//   //                                     builder: (conext) => AddReportItemMaster(
//   //                                         list: widget.list ?? [],
//   //                                         current: current),
//   //                                   ),
//   //                                 );
//   //                               },
//   //                               child: const Text('Reportar')),
//   //                         ),
//   //                       )
//   //                     : const SizedBox(),
//   //                 widget.isReport ?? false
//   //                     ? Padding(
//   //                         padding: const EdgeInsets.all(8.0),
//   //                         child: TextButton.icon(
//   //                             icon: const Icon(Icons.fingerprint_sharp,
//   //                                 color: colorsPuppleOpaco),
//   //                             onPressed: () =>
//   //                                 updatedFrom(current.id.toString()),
//   //                             label: const Text(
//   //                               'Terminar',
//   //                               style: TextStyle(color: colorsPuppleOpaco),
//   //                             )),
//   //                       )
//   //                     : const SizedBox(),
//   //                 current.isWorking == 'f'
//   //                     ? Padding(
//   //                         padding: const EdgeInsets.all(8.0),
//   //                         child: TextButton.icon(
//   //                             icon: const Icon(Icons.close,
//   //                                 color: colorsRedOpaco),
//   //                             onPressed: () =>
//   //                                 deleteFrom(current.id.toString()),
//   //                             label: const Text(
//   //                               'Delete',
//   //                               style: TextStyle(color: colorsRedOpaco),
//   //                             )),
//   //                       )
//   //                     : const SizedBox()
//   //               ],
//   //             )
//   //           : const SizedBox(),
//   //       // Padding(
//   //       //   padding: const EdgeInsets.all(8.0),
//   //       //   child: Center(
//   //       //     child: Column(
//   //       //       children: const [
//   //       //         Icon(
//   //       //           Icons.lock,
//   //       //           color: Colors.red,
//   //       //           size: 30,
//   //       //         ),
//   //       //         Text(
//   //       //           'Bloqueado',
//   //       //           style: TextStyle(fontWeight: FontWeight.w600),
//   //       //         )
//   //       //       ],
//   //       //     ),
//   //       //   ),
//   //       // )
//   //     ],
//   //   );
//   // }

//   Column isNormal(ReportAdmin current, index) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Text("Fecha: ${current.dateCurrent}"),
//             const SizedBox(width: 10),
//             Icon(
//               Icons.public_off,
//               size: 12,
//               color: current.idReported == 't'
//                   ? Colors.green
//                   : compareDate(current.dateCurrent ?? '')
//                       ? Colors.red
//                       : Colors.green,
//             ),
//             TextButton.icon(
//               label: const Text('Ver', style: TextStyle(color: colorsAd)),
//               onPressed: () => showReportAdmin(current),
//               icon: const Icon(Icons.remove_red_eye, color: colorsAd),
//             )
//           ],
//         ),
//         Row(
//           children: [
//             const Text("Reportar"),
//             const SizedBox(width: 10),
//             Text(
//               current.idReported == 'f' ? 'Sin Reportar' : 'Realizado',
//               style: TextStyle(
//                   color: current.idReported == 'f' ? Colors.red : Colors.green),
//             ),
//           ],
//         ),
//         Row(
//           children: [
//             const Text("Statu"),
//             const SizedBox(width: 10),
//             current.idReported == 't'
//                 ? Text(current.isWorking == 't' ? 'Laborable' : 'No Laborable',
//                     style: const TextStyle(
//                         color: Colors.brown, fontWeight: FontWeight.bold))
//                 : TextButton(
//                     onPressed: () {
//                       updateLaborable(current.id,
//                           current.isWorking == 't' ? 'f' : 't', index);
//                     },
//                     child: Text(
//                       current.isWorking == 't' ? 'Laborable' : 'No Laborable',
//                       style: TextStyle(
//                           color: current.isWorking == 't'
//                               ? Colors.green
//                               : colorsAd),
//                     ),
//                   ),
//           ],
//         ),
//         const Divider(),
//         Row(
//           children: [
//             currentUsers?.occupation == OptionAdmin.master.name ||
//                     currentUsers?.occupation == OptionAdmin.boss.name ||
//                     currentUsers?.occupation == OptionAdmin.admin.name
//                 ? Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextButton.icon(
//                       icon: const Icon(Icons.fingerprint_sharp,
//                           color: colorsPuppleOpaco),
//                       onPressed: () => updatedFrom(current.id.toString()),
//                       label: const Text(
//                         'Terminar',
//                         style: TextStyle(color: colorsPuppleOpaco),
//                       ),
//                     ),
//                   )
//                 : const SizedBox(),
//             currentUsers?.occupation == OptionAdmin.master.name ||
//                     currentUsers?.occupation == OptionAdmin.boss.name ||
//                     currentUsers?.occupation == OptionAdmin.admin.name
//                 ? Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextButton.icon(
//                         icon: const Icon(Icons.close, color: colorsRedOpaco),
//                         onPressed: () => deleteFrom(current.id.toString()),
//                         label: const Text(
//                           'Delete',
//                           style: TextStyle(color: colorsRedOpaco),
//                         )),
//                   )
//                 : const SizedBox(),
//             widget.isReport ?? false
//                 ? Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: SizedBox(
//                       // width: 150,
//                       child: ElevatedButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (conext) => AddReportItemMaster(
//                                     list: widget.list ?? [], current: current),
//                               ),
//                             );
//                           },
//                           child: const Text('Reportar')),
//                     ),
//                   )
//                 : const SizedBox()
//           ],
//         ),
//       ],
//     );
//   }
// }
