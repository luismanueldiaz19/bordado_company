import 'dart:convert';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/folder_list_product/model_product/product.dart';
import '/src/home.dart';
import '/src/model/department.dart';
import '/src/nivel_2/folder_almacen/model_data/almacen_item.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/get_formatted_number.dart';
import '/src/util/show_mesenger.dart';
import '/src/widgets/loading.dart';
import '/src/widgets/validar_screen_available.dart';

import '../../folder_cliente_company/dialog_get_client.dart';
import '../../folder_cliente_company/model_cliente/cliente.dart';
import '../../folder_list_product/dialog_get_product.dart';
import '../../util/helper.dart';

class AddAlmacenOrden extends StatefulWidget {
  const AddAlmacenOrden({super.key, required this.current});
  final Department current;
  @override
  State<AddAlmacenOrden> createState() => _AddAlmacenOrdenState();
}

class _AddAlmacenOrdenState extends State<AddAlmacenOrden> {
  List<AlmacenItem> listItem = [];
  TextEditingController controllerNumOrden = TextEditingController();
  TextEditingController controllerFicha = TextEditingController();
  TextEditingController controllerCantidad = TextEditingController();
  TextEditingController controllerPrecio = TextEditingController();
  Cliente? clientPicked;

  Product? productPicked;
  bool isLoading = false;
  Random num = Random();
  int numRamdon = 0;

  bool isAddProducto = false;
  bool isIncidencia = false;

  @override
  void initState() {
    super.initState();
    numRamdon = num.nextInt(999999999);
  }

  void chooseClient() async {
    Cliente? client = await showDialog<Cliente>(
        context: context,
        builder: (context) {
          return const DialogGetClients();
        });
    if (client != null) {
      clientPicked = client;
      setState(() {});
    }
  }

  void chooseProduct() async {
    Product? produto = await showDialog<Product>(
        context: context,
        builder: (context) {
          return const DialogGetProductos();
        });
    if (produto != null) {
      productPicked = produto;
      controllerPrecio.text =
          double.parse(produto.priceProduct.toString()).toStringAsFixed(0);
      setState(() {});
    }
  }

  void addItemProduct() {
    if (controllerNumOrden.text.isEmpty ||
        controllerFicha.text.isEmpty ||
        clientPicked == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error campos vacios , favor llenar correctamente.'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (controllerNumOrden.text.isNotEmpty &&
        controllerFicha.text.isNotEmpty &&
        clientPicked != null &&
        controllerCantidad.text.isNotEmpty &&
        controllerPrecio.text.isNotEmpty &&
        productPicked != null) {
      AlmacenItem data = AlmacenItem(
          cant: controllerCantidad.text,
          idKeyItem: numRamdon.toString(),
          nameProducto: productPicked?.nameProducto,
          price: controllerPrecio.text);
      setState(() {
        listItem.add(data);
        controllerCantidad.clear();
        productPicked = null;
        controllerPrecio.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error escribir producto correctamente.'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  terminarOrden(context) async {
    var data2 = {
      'ficha': controllerFicha.text,
      'is_incidencia': isIncidencia.toString().substring(0, 1),
      'num_orden': controllerNumOrden.text,
      'id_depart': widget.current.id,
      'id_key_item': numRamdon.toString(),
      'date_current': DateTime.now().toString().substring(0, 19),
      'cliente': '${clientPicked?.apellido},${clientPicked?.nombre}',
      'code': currentUsers?.code.toString(),
      'list_producto': listItem.map((item) => item.toJson()).toList(),
    };

    print(data2);

    setState(() {
      isLoading = !isLoading;
    });
    final res = await httpEnviaMap(
        'http://$ipLocal/settingmat/admin/insert/insert_almacen_orden.php',
        jsonEncode(data2));
    print('Insert data : $res');
    final response = jsonDecode(res);
    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['message']),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.green,
      ));
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (conext) => const MyHomePage()),
          (route) => false);
    } else {
      setState(() {
        isLoading = !isLoading;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['message']),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const curve = Curves.elasticInOut;
    final style = Theme.of(context).textTheme;
    String textPlain =
        "-Bordados -Serigrafía -Sublimación -Vinil -Uniformes deportivos y empresariales -Promociones y Más";
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar')),
      body: ValidarScreenAvailable(
        windows: isLoading
            ? const Loading(isLoading: true, text: 'Enviando datos..')
            : Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              listItem.isEmpty
                                  ? Expanded(
                                      child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(25.0),
                                          child: Bounce(
                                            curve: curve,
                                            child: const Text('Producto !',
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    color: colorsAd)),
                                          ),
                                        ),
                                        BounceInDown(
                                            curve: curve,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              child: Image.asset(
                                                  'assets/existencias.gif',
                                                  scale: 5),
                                            )),
                                        FadeIn(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: SizedBox(
                                              width: 200,
                                              child: Text(textPlain,
                                                  textAlign: TextAlign.center,
                                                  style: style.bodySmall
                                                      ?.copyWith(
                                                          color: Colors.grey)),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        // customButton(
                                        //     onPressed: () =>
                                        //         methondSend(planificacionProvider),
                                        //     width: 250,
                                        //     colorText: Colors.white,
                                        //     colors: colorsAd,
                                        //     textButton: 'Enviar'),
                                      ],
                                    ))
                                  : Expanded(
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Lista De Articulos',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black54),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(25),
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  child: DataTable(
                                                    dataRowMaxHeight: 20,
                                                    dataRowMinHeight: 15,
                                                    horizontalMargin: 10.0,
                                                    columnSpacing: 15,
                                                    headingRowHeight: 20,
                                                    decoration:
                                                        const BoxDecoration(
                                                            color:
                                                                colorsPuppleOpaco),
                                                    headingTextStyle:
                                                        const TextStyle(
                                                            color:
                                                                Colors.white),
                                                    border: TableBorder.symmetric(
                                                        outside: BorderSide(
                                                            color: Colors
                                                                .grey.shade100,
                                                            style: BorderStyle
                                                                .none),
                                                        inside:
                                                            const BorderSide(
                                                                style:
                                                                    BorderStyle
                                                                        .solid,
                                                                color: Colors
                                                                    .grey)),
                                                    columns: const [
                                                      DataColumn(
                                                          label: Text('ID')),
                                                      DataColumn(
                                                          label:
                                                              Text('Producto')),
                                                      DataColumn(
                                                          label:
                                                              Text('Piezas')),
                                                      DataColumn(
                                                          label:
                                                              Text('Precios')),
                                                      DataColumn(
                                                          label: Text('Total')),
                                                      DataColumn(
                                                          label:
                                                              Text('Remover')),
                                                    ],
                                                    rows: listItem
                                                        .asMap()
                                                        .entries
                                                        .map((entry) {
                                                      int index = entry.key;
                                                      var report = entry.value;
                                                      return DataRow(
                                                        onLongPress: () {
                                                          print(
                                                              report.toJson());
                                                        },
                                                        color:
                                                            MaterialStateProperty
                                                                .resolveWith<
                                                                    Color>(
                                                          (Set<MaterialState>
                                                              states) {
                                                            // Alterna el color de fondo entre gris y blanco
                                                            if (index.isOdd) {
                                                              return Colors.grey
                                                                  .shade300; // Color de fondo gris para filas impares
                                                            }
                                                            return Colors
                                                                .white; // Color de fondo blanco para filas pares
                                                          },
                                                        ),
                                                        cells: [
                                                          DataCell(Text(report
                                                                  .idKeyItem ??
                                                              'N/A')),
                                                          DataCell(
                                                              Text(
                                                                report.nameProducto !=
                                                                            null &&
                                                                        report.nameProducto!.length >
                                                                            15
                                                                    ? '${report.nameProducto!.substring(0, 15)}...'
                                                                    : report.nameProducto ??
                                                                        '',
                                                              ), onTap: () {
                                                            utilShowMesenger(
                                                                context,
                                                                report.nameProducto ??
                                                                    '');
                                                          }),
                                                          DataCell(Text(
                                                              report.cant ??
                                                                  'N/A')),
                                                          DataCell(Text(
                                                              '\$ ${report.price ?? '0.0'}')),
                                                          DataCell(Text(
                                                              '\$ ${getNumFormatedDouble(AlmacenItem.getSubtotal(report))}')),
                                                          DataCell(
                                                              const Text(
                                                                  'Quitar'),
                                                              onTap: () {
                                                            setState(() {
                                                              listItem.remove(
                                                                  report);
                                                            });
                                                          }),
                                                        ],
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Divider(
                                              indent: 50, endIndent: 50),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 25),
                                            child: SizedBox(
                                              height: 35,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text('Articulos : ',
                                                          style:
                                                              style.bodySmall),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                          listItem.length
                                                              .toString(),
                                                          style:
                                                              style.bodySmall),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text('Piezas :',
                                                          style:
                                                              style.bodySmall),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                          getNumFormatedDouble(
                                                              AlmacenItem
                                                                  .getTotalPieza(
                                                                      listItem)),
                                                          style:
                                                              style.bodySmall),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text('Costo :',
                                                          style:
                                                              style.bodySmall),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                          '\$ ${getNumFormatedDouble(AlmacenItem.getTotalCost(listItem))}',
                                                          style:
                                                              style.bodySmall),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          listItem.isNotEmpty
                                              ? Padding(
                                                  padding: const EdgeInsets.all(
                                                      25.0),
                                                  child: ZoomIn(
                                                    curve: Curves.easeInOutExpo,
                                                    child: TextButton(
                                                        onPressed: () =>
                                                            terminarOrden(
                                                                context),
                                                        child: Text(
                                                            'Click ! ,Registrar Orden',
                                                            style: style
                                                                .bodyMedium
                                                                ?.copyWith(
                                                                    color:
                                                                        colorsRed))),
                                                  ),
                                                )
                                              : const SizedBox()
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                listItem.isEmpty
                                    ? Column(
                                        children: [
                                          SlideInLeft(
                                            curve: curve,
                                            child: Container(
                                              color: Colors.white,
                                              height: 50,
                                              width: 250,
                                              child: TextButton.icon(
                                                icon: const Icon(Icons.search,
                                                    color: Colors.black),
                                                label: Text(
                                                    clientPicked != null
                                                        ? clientPicked!.nombre
                                                            .toString()
                                                        : 'Buscar Cliente',
                                                    style: const TextStyle(
                                                        color: Colors.black)),
                                                onPressed: chooseClient,
                                              ),
                                            ),
                                          ),
                                          SlideInRight(
                                            curve: curve,
                                            child: buildTextFieldValidator(
                                                controller: controllerNumOrden,
                                                hintText:
                                                    'Escribir Numero Orden',
                                                label: 'Numero Orden',
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(
                                                          r'^[1-9]\d*$')),
                                                ]),
                                          ),
                                          SlideInLeft(
                                            curve: curve,
                                            child: buildTextFieldValidator(
                                              controller: controllerFicha,
                                              hintText: 'Escribir Ficha',
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                FilteringTextInputFormatter
                                                    .allow(
                                                        RegExp(r'^[1-9]\d*$')),
                                              ],
                                              label: 'Ficha',
                                            ),
                                          ),
                                          SlideInRight(
                                            child: Container(
                                              color: Colors.white,
                                              height: 50,
                                              width: 250,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text('POR INCIDENCIA'),
                                                  const SizedBox(width: 15),
                                                  Checkbox(
                                                      value: isIncidencia,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          isIncidencia =
                                                              !isIncidencia;
                                                        });
                                                      })
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                //  listItem
                                const SizedBox(height: 5),
                                SlideInLeft(
                                  child: Container(
                                    color: Colors.white,
                                    height: 50,
                                    width: 250,
                                    child: TextButton.icon(
                                      icon: const Icon(Icons.search,
                                          color: Colors.black),
                                      label: Text(
                                          productPicked != null
                                              ? productPicked!.nameProducto
                                                  .toString()
                                              : 'Buscar Producto',
                                          style: const TextStyle(
                                              color: Colors.black)),
                                      onPressed: chooseProduct,
                                    ),
                                  ),
                                ),

                                SlideInRight(
                                  curve: curve,
                                  child: buildTextFieldValidator(
                                      controller: controllerCantidad,
                                      hintText: 'Escribir Cantidad',
                                      label: 'Cantidad',
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^[1-9]\d*$')),
                                      ]),
                                ),
                                SlideInLeft(
                                  curve: curve,
                                  child: buildTextFieldValidator(
                                    controller: controllerPrecio,
                                    hintText: 'Escribir Precio',
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^[1-9]\d*$')),
                                    ],
                                    label: 'Precio',
                                  ),
                                ),
                                customButton(
                                    onPressed: addItemProduct,
                                    textButton: listItem.isEmpty
                                        ? 'Comenzar'
                                        : 'Agregar Nuevo',
                                    colorText: Colors.white,
                                    colors: listItem.isEmpty
                                        ? colorsGreenTablas
                                        : colorsAd),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  identy(context)
                ],
              ),
      ),
    );
  }
}
