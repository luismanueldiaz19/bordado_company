import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/model/users.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/show_mesenger.dart';
import '/src/widgets/custom_app_bar.dart';

class ScreenAddWorkSastreria extends StatefulWidget {
  const ScreenAddWorkSastreria({super.key});

  @override
  State<ScreenAddWorkSastreria> createState() => _ScreenAddWorkSastreriaState();
}

class _ScreenAddWorkSastreriaState extends State<ScreenAddWorkSastreria> {
  TextEditingController controllerOrden = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllertipoPieza = TextEditingController();
  TextEditingController controllerCant = TextEditingController();
  TextEditingController controllerPrecio = TextEditingController();
  bool addItem = false;
  bool isLoading = false;
  List<Product> listItem = [];

  void sendData() async {
    if (controllerOrden.text.isNotEmpty && listItem.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      var num = Random();
      int idKey = num.nextInt(999999999);
      //   $code = $_POST['code'];
      // $num_orden = $_POST['num_orden'];
      // $id_key = $_POST['id_key'];
      var data = {
        'id_key': idKey.toString(),
        'num_orden': controllerOrden.text,
        'code': userChoosed.first.toString()
      };
      final res = await httpRequestDatabase(insertSastreriaWork, data);
      debugPrint(res.body);
      if (res.body == 'good') {
        for (var element in listItem) {
          var itemProduct = {
            'id_key': idKey.toString(),
            'description': element.description,
            'tipo_pieza': element.tipoPieza,
            'cant': element.cantidad,
            'price': element.costo,
          };
          addProductoItem(itemProduct);
        }
        setState(() {
          isLoading = false;
        });
        if (mounted) Navigator.pop(context, true);
      } else {
        setState(() {
          isLoading = false;
        });
        if (mounted) utilShowMesenger(context, 'Error');
      }

      // debugPrint(data.toString());
      // final res = httpRequestDatabase(insertSastreriaWork, data);
    } else {
      utilShowMesenger(context, 'Completar todos los campo');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserAdmin();
  }

  List<Users> userList = [];
  List<Users> userListFilter = [];
  List<String> userChoosed = [];

  Future getUserAdmin() async {
    final res = await httpRequestDatabase(selectUsersAdmin, {'view': 'view'});
    userList = usersFromJson(res.body);

    if (userList.isNotEmpty) {
      for (var element in userList) {
        if (element.occupation == 'Costura') {
          userListFilter.add(element);
        }
      }

      setState(() {});
    }
    // print(res.body);
  }

  addProductoItem(data) async {
    await httpRequestDatabase(insertSastreriaWorkCant, data);
    // print('product ${res.body}');
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    super.dispose();
    controllerOrden.dispose();
    controllerCant.dispose();
    controllerDescription.dispose();
    controllertipoPieza.dispose();
    controllerPrecio.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Agregar Trabajo Sasteria')),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          isLoading
              ? SizedBox(
                  height: size.height * 0.50,
                  width: size.height * 0.50,
                  child: Lottie.asset('animation/loading.json',
                      repeat: true, reverse: true, fit: BoxFit.cover),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ZoomIn(
                      duration: const Duration(milliseconds: 200),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Column(
                          children: [
                            addItem == false
                                ? Column(
                                    children: [
                                      Column(
                                        children: [
                                          userChoosed.isEmpty
                                              ? const Text('Elegir usuario')
                                              : Column(
                                                  children: userChoosed
                                                      .map(
                                                        (e) => Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Chip(
                                                            label: Text(e),
                                                            onDeleted: () {
                                                              userChoosed
                                                                  .remove(e);
                                                              setState(() {});
                                                            },
                                                            deleteIconColor:
                                                                Colors.red,
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                                ),
                                          userListFilter.isEmpty
                                              ? const Text('Not Usuarios')
                                              : Wrap(
                                                  spacing: 8.0,
                                                  runSpacing: 4.0,
                                                  children: userListFilter
                                                      .map((current) => Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                if (userChoosed
                                                                    .isEmpty) {
                                                                  userChoosed.add(
                                                                      current.code ??
                                                                          '');
                                                                  setState(
                                                                      () {});
                                                                }
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        10.0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        gradient:
                                                                            LinearGradient(
                                                                                colors: [
                                                                              colorsBlueTurquesa.withOpacity(0.5),
                                                                              // colorsGreyWhite,
                                                                              colorsPuppleOpaco.withOpacity(0.5)
                                                                            ]),
                                                                        borderRadius:
                                                                            BorderRadius.circular(5)),
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                        '${current.fullName}'),
                                                                    // Text(
                                                                    //     'Code ${current.occupation}'),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ))
                                                      .toList(),
                                                )
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        width: 250,
                                        child: TextField(
                                          controller: controllerOrden,
                                          textInputAction: TextInputAction.next,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            hintText: 'Num Orden',
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.only(left: 15),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (userChoosed.isNotEmpty &&
                                              controllerOrden.text.isNotEmpty) {
                                            setState(() {
                                              addItem = true;
                                            });
                                          } else {
                                            utilShowMesenger(context,
                                                'Elegir el usuario / orden');
                                          }
                                        },
                                        child: const Text('Continuar'),
                                      )
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Text('Orden : ${controllerOrden.text}'),
                                      const SizedBox(height: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        width: 250,
                                        child: TextField(
                                          controller: controllerDescription,
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.text,
                                          decoration: const InputDecoration(
                                            hintText: 'Descripción',
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.only(left: 15),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        width: 250,
                                        child: TextField(
                                          controller: controllertipoPieza,
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.text,
                                          decoration: const InputDecoration(
                                            hintText: 'Tipo Pieza',
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.only(left: 15),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        width: 250,
                                        child: TextField(
                                          controller: controllerCant,
                                          textInputAction: TextInputAction.next,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            hintText: 'Cantidad Pieza',
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.only(left: 15),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        width: 250,
                                        child: TextField(
                                          controller: controllerPrecio,
                                          textInputAction: TextInputAction.next,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            hintText: 'Precio',
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.only(left: 15),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              if (controllerCant
                                                      .text.isNotEmpty &&
                                                  controllerPrecio
                                                      .text.isNotEmpty &&
                                                  controllerDescription
                                                      .text.isNotEmpty &&
                                                  controllertipoPieza
                                                      .text.isNotEmpty) {
                                                setState(() {
                                                  listItem.add(
                                                    Product(
                                                      cantidad:
                                                          controllerCant.text,
                                                      costo:
                                                          controllerPrecio.text,
                                                      description:
                                                          controllerDescription
                                                              .text,
                                                      tipoPieza:
                                                          controllertipoPieza
                                                              .text,
                                                    ),
                                                  );
                                                  controllerCant.clear();
                                                  controllerPrecio.clear();
                                                  controllerDescription.clear();
                                                  controllertipoPieza.clear();
                                                });
                                              } else {
                                                utilShowMesenger(
                                                    context, 'Campos Vacios');
                                              }
                                            },
                                            child: const Text('Agregar'),
                                          ),
                                          const SizedBox(width: 20),
                                          ElevatedButton(
                                            onPressed: () => sendData(),
                                            child: const Text('Enviar'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      SizedBox(
                                        height: 150,
                                        width: double.infinity,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              children: listItem
                                                  .map((product) => Container(
                                                        margin: const EdgeInsets
                                                            .all(15),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color:
                                                                colorsGreyWhite,
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                  blurRadius:
                                                                      1.0,
                                                                  color:
                                                                      colorsPuppleOpaco,
                                                                  offset:
                                                                      Offset(
                                                                          0, 0))
                                                            ]),
                                                        child: Column(
                                                          children: [
                                                            Text(product
                                                                    .description ??
                                                                ''),
                                                            Text(product
                                                                    .tipoPieza ??
                                                                ''),
                                                            Text(
                                                                'Cant : ${product.cantidad ?? ''}'),
                                                            Text(
                                                                '\$ ${product.costo ?? ''}'),
                                                          ],
                                                        ),
                                                      ))
                                                  .toList(),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}

class Product {
  String? description;
  String? tipoPieza;
  String? cantidad;
  String? costo;

  Product({
    this.description,
    this.tipoPieza,
    this.cantidad,
    this.costo,
  });

  Product copyWith({
    String? description,
    String? tipoPieza,
    String? cantidad,
    String? costo,
  }) =>
      Product(
        description: description ?? this.description,
        tipoPieza: tipoPieza ?? this.tipoPieza,
        cantidad: cantidad ?? this.cantidad,
        costo: costo ?? this.costo,
      );
  factory Product.fromJson(Map<String, dynamic> json) => Product(
        description: json["description"],
        tipoPieza: json["tipo_pieza"],
        cantidad: json["cant"],
        costo: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "tipo_pieza": tipoPieza,
        "cant": cantidad,
        "price": costo,
      };
}
