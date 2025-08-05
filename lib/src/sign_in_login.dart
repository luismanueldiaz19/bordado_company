import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'services/api_services.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/url.dart';
import '/src/home.dart';
import '/src/model/users.dart';
import '/src/util/commo_pallete.dart';

class SignInLogin extends StatefulWidget {
  const SignInLogin({super.key});

  @override
  State<SignInLogin> createState() => _SignInLoginState();
}

class _SignInLoginState extends State<SignInLogin> {
  final TextEditingController code = TextEditingController(text: '199512');
  final TextEditingController pinCode = TextEditingController(text: '1234');

  final ApiService _apiService = ApiService();
  bool isLoading1 = false;
  Color selectedColor = Colors.white;

  final FocusNode _focusNode = FocusNode();

  Future signIn(context) async {
    if (code.text.isNotEmpty && pinCode.text.isNotEmpty) {
      setState(() {
        isLoading1 = !isLoading1;
      });

      final res = await _apiService.httpEnviaMap(
          'http://$ipLocal/$pathLocal/usuarios/login.php',
          {'code': code.text, "pin_code": pinCode.text});

      // print(res);
      final response = jsonDecode(res);

      if (response['success']) {
        // print(response['data']);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.green,
            duration: const Duration(milliseconds: 500)));
        final usuarioData = jsonEncode(response['data']);
        currentUsers = Users.fromJson(jsonDecode(usuarioData));
        // print(currentUsers?.toJson());
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
            (route) => false);
      } else {
        setState(() {
          isLoading1 = !isLoading1;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.red,
            duration: const Duration(milliseconds: 500)));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    code.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading1
          ? ZoomIn(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.50,
                      width: size.height * 0.50,
                      child: Lottie.asset('animation/login.json',
                          repeat: true, reverse: true, fit: BoxFit.cover),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                // mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 20, width: double.infinity),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: SizedBox(
                        height: size.height * 0.30,
                        child: Image.asset(logoApp, fit: BoxFit.cover)),
                  ),

                  // SizedBox(
                  //     height: size.height * 0.30,
                  //     child: Lottie.asset('animation/login_long.json',
                  //         repeat: true, reverse: true, fit: BoxFit.cover)),
                  SlideInLeft(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1.0)),
                      width: 250,
                      child: TextField(
                        controller: code,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            hintText: 'Codigo',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 15)),
                        onEditingComplete: () {
                          _focusNode.nextFocus();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  SlideInRight(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1.0)),
                      width: 250,
                      child: TextField(
                        focusNode: _focusNode,
                        controller: pinCode,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        onEditingComplete: () => signIn(context),
                        decoration: const InputDecoration(
                          hintText: 'Contraseña',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  BounceInUp(
                    child: SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        // style: styleButton,
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.resolveWith(
                                (states) => colorsAd),
                            shape: WidgetStateProperty.resolveWith((states) =>
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero))),
                        onPressed: () => signIn(context),
                        child: const Text('Iniciar Sección',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  identy(context),
                  // CompositedTransformTarget(
                  //   link: _layerLink,
                  //   child: TextField(
                  //     focusNode: _focusNode,
                  //     controller: _nombreController,
                  //     decoration: InputDecoration(labelText: 'Producto'),
                  //     onChanged: (value) {
                  //       if (value.isEmpty) {
                  //         _overlayEntry?.remove();
                  //         _overlayEntry = null;
                  //       } else {
                  //         _mostrarSugerencias(_nombreController.text);
                  //       }
                  //     },
                  //   ),
                  // ),
                  // SizedBox(height: 10),
                  // TextField(
                  //   controller: _precioController,
                  //   decoration: InputDecoration(labelText: 'Precio'),
                  //   keyboardType: TextInputType.numberWithOptions(decimal: true),
                  // ),
                  // SizedBox(height: 10),
                  // TextField(
                  //   controller: _cantidadController,
                  //   decoration: InputDecoration(labelText: 'Cantidad'),
                  //   keyboardType: TextInputType.number,
                  // ),
                  // SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     final producto = _nombreController.text;
                  //     final precio = _precioController.text;
                  //     final cantidad = _cantidadController.text;
                  //     print(
                  //         'Producto: $producto, Precio: $precio, Cantidad: $cantidad');
                  //   },
                  //   child: Text('Guardar'),
                  // ),
                ],
              ),
            ),
    );
  }

  // OverlayEntry _crearOverlayEntry() {
  //   RenderBox renderBox = context.findRenderObject() as RenderBox;
  //   Size size = renderBox.size;
  //   return OverlayEntry(
  //     builder: (context) => Positioned(
  //       width: size.width - 32,
  //       child: CompositedTransformFollower(
  //         link: _layerLink,
  //         offset: const Offset(0, 50),
  //         showWhenUnlinked: false,
  //         child: Material(
  //           elevation: 4.0,
  //           child: ListView.builder(
  //             padding: EdgeInsets.zero,
  //             shrinkWrap: true,
  //             itemCount: _sugerencias.length,
  //             itemBuilder: (context, index) {
  //               final producto = _sugerencias[index];
  //               return ListTile(
  //                 title: Text(producto.nombre),
  //                 subtitle: Text('\$${producto.precio.toStringAsFixed(2)}'),
  //                 onTap: () {
  //                   _nombreController.text = producto.nombre;
  //                   _precioController.text = producto.precio.toStringAsFixed(2);
  //                   _cantidadController.text = '1';
  //                   _overlayEntry?.remove();
  //                   _overlayEntry = null;
  //                   FocusScope.of(context)
  //                       .requestFocus(FocusNode()); // cierra teclado
  //                 },
  //               );
  //             },
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

// class Producto {
//   final String nombre;
//   final double precio;

//   Producto(this.nombre, this.precio);
// }
