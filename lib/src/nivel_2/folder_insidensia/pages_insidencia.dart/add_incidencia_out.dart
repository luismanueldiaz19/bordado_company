// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/material.dart';
// import '/src/nivel_2/folder_insidensia/pages_insidencia.dart/add_incidencia_report_desde_card.dart';
// import '/src/nivel_2/folder_insidensia/pages_insidencia.dart/selected_department.dart';
// import '/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
// import '/src/util/show_mesenger.dart';

// class AddIncidenciaOut extends StatefulWidget {
//   const AddIncidenciaOut({super.key});

//   @override
//   State<AddIncidenciaOut> createState() => _AddIncidenciaOutState();
// }

// class _AddIncidenciaOutState extends State<AddIncidenciaOut> {
//   List choosed = [];
//   late TextEditingController ficha;

//   late TextEditingController orden;
//   late TextEditingController logo;

//   @override
//   void initState() {
//     super.initState();
//     ficha = TextEditingController();
//     orden = TextEditingController();
//     logo = TextEditingController();
//   }

//   @override
//   void dispose() {
//     //  _TODO_implement_dispose
//     super.dispose();
//     ficha.dispose();
//     orden.dispose();
//     logo.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(title: const Text('Agregar Incidencia OLD')),
//       body: Column(
//         children: [
//           const SizedBox(width: double.infinity),
//           choosed.isNotEmpty
//               ? SizedBox(
//                   height: 50,
//                   width: 300,
//                   child: ListView(
//                     physics: const BouncingScrollPhysics(),
//                     scrollDirection: Axis.horizontal,
//                     children: choosed
//                         .map((e) => Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 15),
//                               child: Chip(
//                                 label: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 15),
//                                   child: Text(e),
//                                 ),
//                               ),
//                             ))
//                         .toList(),
//                   ),
//                 )
//               : const SizedBox(),
//           choosed.isEmpty
//               ? Padding(
//                   padding: const EdgeInsets.all(25.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       const Text('De que? departamentos viene!'),
//                       TextButton(
//                         onPressed: () async {
//                           await showDialog(
//                               context: context,
//                               builder: (context) {
//                                 return SelectedDepartments(
//                                   pressDepartment: (val) {
//                                     setState(() {
//                                       choosed = val;
//                                     });
//                                   },
//                                 );
//                               });
//                         },
//                         child: const Text('Elegir'),
//                       )
//                     ],
//                   ),
//                 )
//               : const SizedBox(),
//           BounceInRight(
//             duration: const Duration(milliseconds: 300),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(
//                   10.0,
//                 ),
//               ),
//               width: size.width * 0.75,
//               child: TextField(
//                 textInputAction: TextInputAction.next,
//                 controller: logo,
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   labelText: 'Logo',
//                   contentPadding: EdgeInsets.only(left: 10),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 5),
//           BounceInRight(
//             duration: const Duration(milliseconds: 300),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(
//                   10.0,
//                 ),
//               ),
//               width: size.width * 0.75,
//               child: TextField(
//                 textInputAction: TextInputAction.next,
//                 controller: orden,
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   labelText: 'Num Orden',
//                   contentPadding: EdgeInsets.only(left: 10),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 5),
//           BounceInRight(
//             duration: const Duration(milliseconds: 300),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(
//                   10.0,
//                 ),
//               ),
//               width: size.width * 0.75,
//               child: TextField(
//                 textInputAction: TextInputAction.next,
//                 controller: ficha,
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   labelText: 'Ficha',
//                   contentPadding: EdgeInsets.only(left: 10),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 15),
//           SizedBox(
//               width: MediaQuery.of(context).size.width * 0.70,
//               child: ElevatedButton(
//                   onPressed: () {
//                     if (choosed.isNotEmpty &&
//                         orden.text.isNotEmpty &&
//                         ficha.text.isNotEmpty &&
//                         logo.text.isNotEmpty) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => AddIncidenciaSublimacion(
//                             current: Sublima(
//                                 nameLogo: logo.text,
//                                 numOrden: orden.text,
//                                 ficha: ficha.text,
//                                 nameDepartment: choosed[0]),
//                           ),
//                         ),
//                       );
//                     } else {
//                       utilShowMesenger(context, 'Error');
//                     }
//                   },
//                   child: const Text('Continuar'))),
//         ],
//       ),
//     );
//   }
// }
