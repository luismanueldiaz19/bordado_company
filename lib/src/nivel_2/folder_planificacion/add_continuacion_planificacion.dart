import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../folder_list_product/dialog_get_product.dart';

import '../../folder_list_product/model_product/product.dart';
import '../../util/get_formatted_number.dart';
import '../folder_insidensia/pages_insidencia.dart/selected_department.dart';
import '/src/datebase/methond.dart';
import '/src/util/commo_pallete.dart';
import '/src/widgets/loading.dart';
import '../../datebase/current_data.dart';
import '../../datebase/url.dart';
import '../../home.dart';
import '../../model/new_orden.dart';
import '../../model/product_new_orden.dart';
import '../../util/helper.dart';
import '../../widgets/validar_screen_available.dart';

class AddContinuacionPlan extends StatefulWidget {
  const AddContinuacionPlan(
      {super.key, required this.item, required this.isClientInterno});
  final NewOrden item;
  final bool? isClientInterno;
  @override
  State<AddContinuacionPlan> createState() => _AddContinuacionPlanState();
}

class _AddContinuacionPlanState extends State<AddContinuacionPlan> {
  List<ProductPlanificaion> listProduct = [];
  bool isLoading = false;
  final controllerCant = TextEditingController();
  void terminarOrden(context) async {
    setState(() {
      isLoading = !isLoading;
    });
    List<ProductNewOrden> listNewOrderProduct = [];
    for (var element in listProduct) {
      ProductNewOrden productNewOrden = ProductNewOrden.fromData(
        isKeyUniqueProduct: widget.item.isKeyUniqueProduct,
        tipoProducto: element.tipoProducto,
        cantProduto: element.cantProduto,
        department: element.department,
        fechaStart: widget.item.fechaStart,
        fechaEnd: widget.item.fechaEntrega,
        priority: widget.item.priority,
        productId: element.productId,
      );
      listNewOrderProduct.add(productNewOrden);
    }
    Map<String, dynamic> data = {
      'user_registro_orden': widget.item.userRegistroOrden,
      'cliente': widget.item.cliente,
      'cliente_telefono': widget.item.clienteTelefono,
      'num_orden': widget.item.numOrden,
      'name_logo': widget.item.nameLogo,
      'ficha': widget.item.ficha,
      'fecha_start': widget.item.fechaStart,
      'fecha_entrega': widget.item.fechaEntrega,
      'is_key_unique_product': widget.item.isKeyUniqueProduct,
      'priority': widget.item.priority,
      'list_producto': listNewOrderProduct.map((item) => item.toMap()).toList(),
    };
    // print('-------------------');
    // print('json : $data');
    final res = await httpEnviaMap(
        'http://$ipLocal/settingmat/admin/insert/insert_new_orden_v2.php',
        jsonEncode(data));
    // print(res);
    final response = jsonDecode(res);
    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['message']),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.green,
      ));
      await Future.delayed(const Duration(seconds: 2));
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

  // void addProductoDialog() async {
  //   final product = await showDialog(
  //       context: context,
  //       builder: ((context) {
  //         return const AddProducto();
  //       }));

  //   if (product != null) {
  //     for (var item in product['list_department']) {
  //       listProduct.add(
  //         ProductPlanificaion(
  //             cantProduto: product['cant'],
  //             tipoProducto: product['product'],
  //             department: item),
  //       );
  //     }
  //     setState(() {});
  //   }
  // }

  void terminarOrdenClienteInterno(context) async {
    setState(() {
      isLoading = !isLoading;
    });
    List<ProductNewOrden> listNewOrderProduct = [];
    for (var element in listProduct) {
      ProductNewOrden productNewOrden = ProductNewOrden.fromData(
        isKeyUniqueProduct: widget.item.isKeyUniqueProduct,
        tipoProducto: element.tipoProducto,
        cantProduto: element.cantProduto,
        department: element.department,
        fechaStart: widget.item.fechaStart,
        fechaEnd: widget.item.fechaEntrega,
        priority: widget.item.priority,
        productId: element.productId,
      );
      listNewOrderProduct.add(productNewOrden);
    }
    Map<String, dynamic> data = {
      'user_registro_orden': widget.item.userRegistroOrden,
      'cliente': widget.item.cliente,
      'cliente_telefono': widget.item.clienteTelefono,
      'num_orden': '0',
      'name_logo': 'N/A',
      'ficha': widget.item.ficha,
      'fecha_start': widget.item.fechaStart,
      'fecha_entrega': widget.item.fechaEntrega,
      'is_key_unique_product': widget.item.isKeyUniqueProduct,
      'priority': widget.item.priority,
      'list_producto': listNewOrderProduct.map((item) => item.toMap()).toList(),
    };
    // print('-------------------');
    // print('json : $data');
    final res = await httpEnviaMap(
        'http://$ipLocal/settingmat/admin/insert/insert_orden_cliente_interno_v2.php',
        jsonEncode(data));
    // print(res);
    final response = jsonDecode(res);
    if (response['success']) {
      // print(response['message']);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['message']),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.green,
      ));
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (conext) => const MyHomePage()),
          (route) => false);
    } else {
      setState(() {
        isLoading = !isLoading;
      });

      // print(response['message']);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['message']),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red,
      ));
    }
  }

  Product? productPicked;
  List listDepartTemp = [];
  bool isReadytoAdd = false;
  void chooseProduct() async {
    Product? produto = await showDialog<Product>(
        context: context,
        builder: (context) {
          return const DialogGetProductos();
        });
    if (produto != null) {
      setState(() {
        listDepartTemp.clear();
        isReadytoAdd = false;
        controllerCant.clear();
        productPicked = produto;
      });
    }
  }

  void elegirDepartmento() async {
    await showDialog(
        context: context,
        builder: (context) {
          return SelectedDepartments(
            pressDepartment: (val) {
              setState(() {
                listDepartTemp = val;

                if (listDepartTemp.contains('Sublimación') &&
                    !listDepartTemp.contains('Plancha/Empaque')) {
                  listDepartTemp.add('Plancha/Empaque');
                }
                if (listDepartTemp.contains('Sublimación') &&
                    !listDepartTemp.contains('Printer')) {
                  listDepartTemp.add('Printer');
                }
                if (listDepartTemp.contains('Serigrafia') &&
                    !listDepartTemp.contains('Plancha/Empaque')) {
                  listDepartTemp.add('Plancha/Empaque');
                }
                print(listDepartTemp);
                isReadytoAdd = true;
              });
            },
          );
        });

    print(
        'Total de departamentos $listDepartTemp y total : ${listDepartTemp.length}');
  }

  void addItem() {
    print('terminar add del item');

    for (var item in listDepartTemp) {
      listProduct.add(
        ProductPlanificaion(
            productId: productPicked!.idProducto,
            cantProduto: controllerCant.text.trim(),
            tipoProducto: productPicked!.nameProducto,
            department: item),
      );
    }
    cleaner();
  }

  void cleaner() {
    setState(() {
      listDepartTemp.clear();
      isReadytoAdd = false;
      controllerCant.clear();
      productPicked = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    controllerCant.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const curve = Curves.elasticInOut;
    final style = Theme.of(context).textTheme;
    String textPlain =
        "-Bordados -Serigrafía -Sublimación -Vinil -Uniformes deportivos y empresariales -Promociones y Más";
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.isClientInterno!
              ? 'Cliente Interno'
              : widget.item.nameLogo ?? 'N/A')),
      body: ValidarScreenAvailable(
        windows: isLoading
            ? const Expanded(
                child: Loading(isLoading: true, text: 'Enviando al servidor'))
            : Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(25),
                            child: Column(
                              children: [
                                const Text(
                                  'Información Orden',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${widget.item.cliente}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: colorsAd,
                                          ),
                                        ),
                                        const Divider(),
                                        Text(
                                            'Tel : ${widget.item.clienteTelefono}',
                                            style:
                                                const TextStyle(fontSize: 14)),
                                        widget.isClientInterno!
                                            ? const SizedBox()
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'Num Orden : ${widget.item.numOrden}',
                                                      style: const TextStyle(
                                                          fontSize: 14)),
                                                  Text(
                                                      'Logo : ${widget.item.nameLogo}',
                                                      style: const TextStyle(
                                                          fontSize: 14)),
                                                ],
                                              ),
                                        Text('Ficha : ${widget.item.ficha}',
                                            style:
                                                const TextStyle(fontSize: 14)),
                                        const Divider(),
                                        Row(
                                          children: [
                                            Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                height: 5,
                                                width: 5,
                                                color: Colors.black),
                                            const Expanded(
                                                child: Text(
                                              'Tu cliente esta primero.',
                                            ))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                height: 5,
                                                width: 5,
                                                color: Colors.black),
                                            const Expanded(
                                                child: Text(
                                              'Tener el control.',
                                            ))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                height: 5,
                                                width: 5,
                                                color: Colors.black),
                                            const Expanded(
                                                child: Text(
                                              'Ahora es mas fácil.',
                                            ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                listProduct.isNotEmpty
                                    ? Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: DataTable(
                                            dataRowMaxHeight: 20,
                                            dataRowMinHeight: 15,
                                            horizontalMargin: 10.0,
                                            columnSpacing: 15,
                                            headingRowHeight: 20,
                                            decoration: const BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 245, 212, 158)),
                                            headingTextStyle: const TextStyle(
                                                color: colorsAd,
                                                fontWeight: FontWeight.bold),
                                            border: TableBorder.symmetric(
                                                outside: BorderSide(
                                                    color: Colors.grey.shade100,
                                                    style: BorderStyle.none),
                                                inside: const BorderSide(
                                                    style: BorderStyle.solid,
                                                    color: Colors.grey)),
                                            columns: const [
                                              DataColumn(
                                                  label: Text('Departamento')),
                                              DataColumn(
                                                  label: Text('Producto')),
                                              DataColumn(
                                                  label: Text('Cantidad')),
                                              DataColumn(label: Text('Quitar')),
                                            ],
                                            rows: listProduct
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                              int index = entry.key;
                                              var report = entry.value;
                                              return DataRow(
                                                color: MaterialStateProperty
                                                    .resolveWith<Color>(
                                                  (Set<MaterialState> states) {
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
                                                  DataCell(Text(
                                                      report.department ??
                                                          'N/A')),
                                                  DataCell(Text(
                                                      report.tipoProducto ??
                                                          'N/A')),
                                                  DataCell(Text(
                                                      report.cantProduto ??
                                                          'N/A')),
                                                  DataCell(const Text('Quitar'),
                                                      onTap: () {
                                                    setState(() {
                                                      listProduct
                                                          .remove(report);
                                                    });
                                                  }),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                listProduct.isNotEmpty
                                    ? widget.isClientInterno!
                                        ? Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: customButton(
                                              onPressed: () =>
                                                  terminarOrdenClienteInterno(
                                                      context),
                                              textButton: 'Orden Interna',
                                              colors: colorsOrange,
                                              width: 250,
                                              colorText: Colors.white,
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(25.0),
                                            child: ZoomIn(
                                              curve: Curves.easeInOutExpo,
                                              child: TextButton(
                                                  onPressed: () =>
                                                      terminarOrden(context),
                                                  child: Text(
                                                      'Click ! ,Registrar Orden',
                                                      style: style.bodyMedium
                                                          ?.copyWith(
                                                              color:
                                                                  colorsRed))),
                                            ),
                                          )
                                    : const SizedBox()
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            child: SingleChildScrollView(
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: Bounce(
                                      curve: curve,
                                      child: Text('Nueva Orden !',
                                          style: style.titleSmall?.copyWith(
                                              fontSize: 15, color: colorsAd)),
                                    ),
                                  ),
                                  BounceInDown(
                                      curve: curve,
                                      child: Image.asset(
                                          'assets/paquete-o-empaquetar.png',
                                          scale: 5)),
                                  FadeIn(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: SizedBox(
                                        width: 200,
                                        child: Text(textPlain,
                                            textAlign: TextAlign.center,
                                            style: style.bodySmall
                                                ?.copyWith(color: Colors.grey)),
                                      ),
                                    ),
                                  ),
                                  // const SizedBox(height: 15),
                                  // customButton(
                                  //     onPressed: () => addProductoDialog(),
                                  //     width: 250,
                                  //     colorText: Colors.white,
                                  //     colors: colorsAd,
                                  //     textButton: 'Agregar Articulo'),

                                  SlideInRight(
                                    curve: curve,
                                    child: Container(
                                        color: Colors.white,
                                        // height: 50,
                                        width: 250,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: ListTile(
                                          title: TextButton(
                                              onPressed: chooseProduct,
                                              child: Text(
                                                  productPicked != null
                                                      ? productPicked!
                                                          .nameProducto
                                                          .toString()
                                                      : 'Buscar productos',
                                                  style: style.bodySmall)),
                                          trailing: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              productPicked != null
                                                  ? Text(
                                                      '\$ ${getNumFormatedDouble(productPicked!.priceProduct.toString())}',
                                                      style: style.labelSmall
                                                          ?.copyWith(
                                                              color: ktejidogrey
                                                                  .withOpacity(
                                                                      0.5),
                                                              fontSize: 12))
                                                  : const SizedBox(),
                                              productPicked != null
                                                  ? Text(
                                                      '${getNumFormatedDouble(productPicked!.stock.toString())} Stock',
                                                      style: style.labelSmall?.copyWith(
                                                          color: Product
                                                                  .validatorStock(
                                                                      productPicked!)
                                                              ? colorsBlueTurquesa
                                                              : colorsRed,
                                                          fontSize: 8))
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        )),
                                  ),

                                  // SlideInLeft(
                                  //   child: Container(
                                  //     color: Colors.white,
                                  //     height: 50,
                                  //     width: 250,
                                  //     child: TextButton.icon(
                                  //       icon: const Icon(Icons.search,
                                  //           color: Colors.black),
                                  //       label: Text(
                                  //           productPicked != null
                                  //               ? productPicked!.nameProduct
                                  //                   .toString()
                                  //               : 'Buscar Producto',
                                  //           style: const TextStyle(
                                  //               color: Colors.black)),
                                  //       onPressed: chooseProduct,
                                  //     ),
                                  //   ),
                                  // ),
                                  SlideInRight(
                                    curve: curve,
                                    child: buildTextFieldValidator(
                                        label: 'Cantidad',
                                        controller: controllerCant,
                                        hintText: 'Escribe la cantidad',
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        onChanged: (val) {
                                          setState(() {});
                                        }),
                                  ),
                                  SlideInLeft(
                                    curve: curve,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: SizedBox(
                                        // color: Colors.white,
                                        height: 50,
                                        width: 250,
                                        // margin: const EdgeInsets.symmetric(
                                        //     vertical: 5),
                                        child: TextButton.icon(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        colorsBlueDeepHigh),
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                  ),
                                                ),
                                                foregroundColor: MaterialStateColor.resolveWith(
                                                    (states) => Colors.black)),
                                            icon: listDepartTemp.isNotEmpty
                                                ? const Icon(Icons.check,
                                                    color: Colors.green)
                                                : const Icon(Icons.badge_outlined,
                                                    color: Colors.white),
                                            label: Text(
                                                listDepartTemp.isNotEmpty
                                                    ? '${listDepartTemp.length} Departamentos'
                                                    : 'Buscar Departamentos',
                                                style: TextStyle(
                                                    color: listDepartTemp.isNotEmpty
                                                        ? Colors.green
                                                        : Colors.white)),
                                            onPressed: elegirDepartmento),
                                      ),
                                    ),
                                  ),
                                  isReadytoAdd && controllerCant.text.isNotEmpty
                                      ? ZoomIn(
                                          child: customButton(
                                            width: 250,
                                            textButton: 'Agregar producto',
                                            onPressed: addItem,
                                            colors: colorsBlueTurquesa,
                                            colorText: Colors.white,
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
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

class ProductPlanificaion {
  String? productId;
  String? tipoProducto;
  String? cantProduto;
  String? department;

  ProductPlanificaion({
    this.productId,
    this.tipoProducto,
    this.cantProduto,
    this.department,
  });
}
