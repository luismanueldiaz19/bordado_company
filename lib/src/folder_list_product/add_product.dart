// import 'dart:convert';

// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '/src/util/commo_pallete.dart';
// import '/src/util/helper.dart';

// import '../datebase/methond.dart';
// import '../datebase/url.dart';

// class AddProduct extends StatefulWidget {
//   const AddProduct({super.key});
//   @override
//   State<AddProduct> createState() => _AddProductState();
// }

// class _AddProductState extends State<AddProduct> {
//   TextEditingController controllerProducto = TextEditingController();

//   TextEditingController controllerPrecio = TextEditingController();

//   Future<void> addItemProduct() async {
//     if (controllerProducto.text.isEmpty || controllerPrecio.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           backgroundColor: Colors.red,
//           content: Text('Campos vacio!'),
//           duration: Duration(seconds: 1)));
//       return;
//     }

//     var data = {
//       'name_product': controllerProducto.text.toUpperCase(),
//       'price_product': controllerPrecio.text
//     };
//     String url = "http://$ipLocal/settingmat/admin/insert/insert_product.php";
//     final res = await httpRequestDatabase(url, data);
//     // print(res.body);
//     var response = jsonDecode(res!.body);
//     if (response['success']) {
//       controllerProducto.clear();
//       controllerPrecio.clear();
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.green,
//           content: Text(response['message']),
//           duration: const Duration(seconds: 1)));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.red,
//           content: Text(response['message']),
//           duration: const Duration(seconds: 1)));
//     }
//     // list = usuarioPermissionsFromJson(res.body);
//     // listFilter = list;
//     // setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     const curve = Curves.elasticInOut;
//     final style = Theme.of(context).textTheme;
//     String textPlain =
//         "-Bordados -Serigrafía -Sublimación -Vinil -Uniformes deportivos y empresariales -Promociones y Más";
//     return Scaffold(
//       appBar: AppBar(title: const Text('Agregar Producto')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             children: [
//               const SizedBox(width: double.infinity),
//               SlideInLeft(
//                 curve: curve,
//                 child: buildTextFieldValidator(
//                   controller: controllerProducto,
//                   hintText: 'Escribir Nombre Producto',
//                   label: 'Producto',
//                 ),
//               ),
//               SlideInRight(
//                 curve: curve,
//                 child: buildTextFieldValidator(
//                     controller: controllerPrecio,
//                     hintText: 'Escribir Precio',
//                     inputFormatters: [
//                       FilteringTextInputFormatter.digitsOnly,
//                       FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*$')),
//                     ],
//                     label: 'Precio'),
//               ),
//               const SizedBox(height: 10),
//               customButton(
//                   onPressed: addItemProduct,
//                   textButton: 'Agregar Producto',
//                   colorText: Colors.white,
//                   colors: colorsGreenTablas)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
