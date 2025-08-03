// import 'package:flutter/material.dart';
// import '/src/datebase/methond.dart';
// import '/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
// import '/src/util/commo_pallete.dart';

// import '../../datebase/url.dart';
// import '../../model/department.dart';
// import '../../widgets/picked_date_widget.dart';
// import '../forder_sublimacion/widgets/percent_star.dart';

// class MyWidgetResumenSerigrafia extends StatefulWidget {
//   const MyWidgetResumenSerigrafia({super.key, required this.current});
//   final Department current;

//   @override
//   State<MyWidgetResumenSerigrafia> createState() =>
//       _MyWidgetResumenSerigrafiaState();
// }

// class _MyWidgetResumenSerigrafiaState extends State<MyWidgetResumenSerigrafia> {
//   String? _secondDate = DateTime.now().toString().substring(0, 10);
//   String? _firstDate = DateTime.now().toString().substring(0, 10);
//   List<Sublima> listRanked = [];

//   List<Sublima> listFull = [];
//   //select_serigrafia_ranking_usuario

//   Future getRankingUsuario() async {
//     String url =
//         "http://$ipLocal/settingmat/admin/select/select_serigrafia_ranking_usuario.php";
//     final res = await httpRequestDatabase(
//         url, {'date1': _firstDate, 'date2': _secondDate});
//     listRanked = sublimaFromJson(res.body);
//     setState(() {});
//   }

//   Future get() async {
//     String url =
//         "http://$ipLocal/settingmat/admin/select/select_serigrafia_get_full.php";
//     final res = await httpRequestDatabase(
//         url, {'date1': _firstDate, 'date2': _secondDate});

//     //   print('Get Full ${res.body}');
//     listFull = sublimaFromJson(res.body);
//     // takeUserWithoutRepet();
//     setState(() {});
//   }

//   List dataReported = [];

//   @override
//   void initState() {
//     super.initState();

//     getRankingUsuario();
//     get();
//   }

//   void takeUserWithoutRepet() async {
//     dataReported.clear();
//     List<String> nombresUnicos = Sublima.depurarEmpleados(listFull);
//     List<String> trabajoUnicos = Sublima.depurarTypeWork(listFull);
//     print('nombresUnicos : $nombresUnicos');
//     print('nombresUnicos : $trabajoUnicos');

//     for (var fullName in nombresUnicos) {
//       final userMap = <String, dynamic>{};
//       userMap[fullName] = {};

//       for (var workText in trabajoUnicos) {
//         userMap[fullName]![workText] = {
//           'PKT': Sublima.getTotalPiezaPKTByNameWork(listFull, workText),
//           'FULL': Sublima.getTotalPiezaFullByNameWork(listFull, workText),
//         };
//       }

//       dataReported.add(userMap);
//     }
//     print('dataReported ${dataReported}');

//     // print(data);

//     ///este ciclo for es para agregar los nombre a los tipo de trabajo
//     ///por ejemplo Alex {'Calandra':'0'} ////////

//     // for (var fullName in nombresUnicos) {
//     //   dataReported[fullName] = {};
//     //   for (var workText in trabajoUnicos) {
//     //     dataReported[fullName]![workText] =
//     //         Sublima.getTotalPiezaByNameWork(listFull, workText);
//     //     // dataReportFull[fullName] = {nombreTrajoUnicos.first: '0'};
//     //     // dataReportPKT[fullName] = {nombreTrajoUnicos.first: '0'};
//     //   }
//     // }
//     // print('dataReported : $dataReported');
//     // print('runtimeType : ${dataReported.runtimeType}');
//   }

//   // final data = [
//   //   {
//   //     'LUDEVELOPER': {
//   //       'PINTANDO': {'PKT': '0', 'FULL': '12'},
//   //       'QUEMADO': {'PKT': '0', 'FULL': '20'},
//   //     },
//   //     'JOSE': {
//   //       'PINTANDO': {'PKT': '0', 'FULL': '12'},
//   //       'QUEMADO': {'PKT': '0', 'FULL': '20'},
//   //     }
//   //   }
//   // ];
//   // print(data.runtimeType);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Resumen ${widget.current.nameDepartment}'),
//         actions: [],
//       ),
//       body: Column(
//         children: [
//           Column(
//             children: listRanked
//                 .map(
//                   (e) => ListTile(
//                     leading: CircleAvatar(
//                         backgroundColor: ktejidoblueOpaco,
//                         child: Text(e.fullName.toString().substring(0, 1),
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodySmall
//                                 ?.copyWith(color: Colors.white))),
//                     title: Text(e.fullName ?? 'N/A'),
//                     subtitle: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         StarRating(percent: int.parse(e.rating ?? '0')),
//                       ],
//                     ),
//                     trailing: IconButton(
//                       onPressed: () {
//                         setState(() {
//                           dataReported.clear();
//                         });
//                       },
//                       icon: const Icon(Icons.recommend_outlined),
//                     ),
//                   ),
//                 )
//                 .toList(),
//           ),
//           // DataTable(
//           //   dataRowMaxHeight: 20,
//           //   dataRowMinHeight: 15,
//           //   horizontalMargin: 10.0,
//           //   columnSpacing: 15,
//           //   headingRowHeight: 20,
//           //   decoration: const BoxDecoration(
//           //     gradient: LinearGradient(
//           //       colors: [
//           //         Color.fromARGB(255, 205, 208, 221),
//           //         Color.fromARGB(255, 225, 228, 241),
//           //         Color.fromARGB(255, 233, 234, 238),
//           //       ],
//           //     ),
//           //   ),
//           //   border: TableBorder.symmetric(
//           //       inside: const BorderSide(
//           //           style: BorderStyle.solid, color: Colors.grey)),
//           //   columns: const [
//           //     DataColumn(label: Text('Empleado')),
//           //     DataColumn(label: Text('Tipo Trabajo')),
//           //     DataColumn(label: Text('PKT')),
//           //     DataColumn(label: Text('Color PKT')),
//           //     DataColumn(label: Text('Full')),
//           //     DataColumn(label: Text('Color Full')),
//           //   ],
//           //   rows: listFull
//           //       .map((item) => DataRow(
//           //               color: MaterialStateProperty.all(Colors.white),
//           //               cells: [
//           //                 DataCell(Text(item.fullName ?? 'N/A')),
//           //                 DataCell(Text(item.nameWork ?? 'N/A')),
//           //                 DataCell(Text(item.pkt ?? 'N/A')),
//           //                 DataCell(Text(item.colorpkt ?? 'N/A')),
//           //                 DataCell(Text(item.dFull ?? 'N/A')),
//           //                 DataCell(Text(item.colorfull ?? 'N/A')),
//           //               ]))
//           //       .toList(),
//           // ),
//           // Table(
//           //   border: TableBorder.all(),
//           //   children: [
//           //     TableRow(
//           //       children: [
//           //         TableCell(child: Text('Usuario')),
//           //         for (var entry in dataReported)
//           //           for (var user in entry.keys)
//           //             for (var job in entry[user].keys)
//           //               TableCell(child: Text(job)),
//           //       ],
//           //     ),
//           //     for (var entry in dataReported)
//           //       TableRow(
//           //         children: [
//           //           TableCell(child: Text(entry.keys.first)),
//           //           for (var user in entry.keys)
//           //             for (var jobData in entry[user].values)
//           //               TableCell(
//           //                 child: Text(
//           //                     'PKT: ${jobData['PKT']}, FULL: ${jobData['FULL']}'),
//           //               ),
//           //         ],
//           //       ),
//           //   ],
//           // ),

//           // dataReported.isEmpty
//           //     ? const Text('No hay datos')
//           //     : Expanded(
//           //         child: SizedBox(
//           //           child: Table(
//           //             border: TableBorder.all(),
//           //             children: [
//           //               TableRow(
//           //                 children: [
//           //                   const TableCell(child: Text('Usuario')),
//           //                   for (var entry in dataReported)
//           //                     for (var user in entry.keys)
//           //                       for (var job in entry[user].keys)
//           //                         TableCell(child: Text(job)),
//           //                 ],
//           //               ),
//           //               for (var entry in dataReported)
//           //                 TableRow(
//           //                   children: [
//           //                     TableCell(child: Text(entry.keys.first)),
//           //                     for (var user in entry.keys)
//           //                       for (var jobData in entry[user].values)
//           //                         TableCell(
//           //                           child: Text(
//           //                               'PKT: ${jobData['PKT']}, FULL: ${jobData['FULL']}'),
//           //                         ),
//           //                   ],
//           //                 ),
//           //             ],
//           //           ),
//           //         ),
//           //       ),

//           // Padding(
//           //   padding: const EdgeInsets.all(15.0),
//           //   child: DataTable(
//           //     dataRowMaxHeight: 20,
//           //     dataRowMinHeight: 15,
//           //     horizontalMargin: 10.0,
//           //     columnSpacing: 15,
//           //     headingRowHeight: 20,
//           //     decoration: const BoxDecoration(
//           //       gradient: LinearGradient(
//           //         colors: [
//           //           Color.fromARGB(255, 205, 208, 221),
//           //           Color.fromARGB(255, 225, 228, 241),
//           //           Color.fromARGB(255, 233, 234, 238)
//           //         ],
//           //       ),
//           //     ),
//           //     border: TableBorder.symmetric(
//           //         inside: const BorderSide(
//           //             style: BorderStyle.solid, color: Colors.grey)),
//           //     columns: const [
//           //       DataColumn(label: Text('EMPLEADO')),
//           //       DataColumn(label: Text('PINTANDO')),
//           //       DataColumn(label: Text('QUEMADO')),
//           //       DataColumn(label: Text('CUADRAR MARCOS')),
//           //       DataColumn(label: Text('BORRAR MARCOS')),
//           //       DataColumn(label: Text('PLANCHANDO')),
//           //       DataColumn(label: Text('TOTAL')),
//           //     ],
//           //     rows: dataReported.entries.map<DataRow>(
//           //       (entry) {
//           //         List<DataCell> cells = [
//           //           DataCell(Text(entry.key)),
//           //         ];
//           //         entry.value.forEach((day, value) {
//           //           cells.add(DataCell(
//           //               TextButton(onPressed: () {}, child: Text(value))));
//           //         });
//           //         return DataRow(cells: cells);
//           //       },
//           //     ).toList(),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }
