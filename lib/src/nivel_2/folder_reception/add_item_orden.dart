import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/util/commo_pallete.dart';
import '/src/widgets/validar_screen_available.dart';
import '../../datebase/url.dart';
import '../../folder_product/add_product.dart';
import '../../model/product_new_orden.dart';
import '../../util/helper.dart';
import '../../widgets/loading.dart';
import '../folder_planificacion/add_continuacion_planificacion.dart';
import '../folder_planificacion/model_planificacion/planificacion_last.dart';
import '../folder_planificacion/url_planificacion/url_planificacion.dart';

class AddItemOrden extends StatefulWidget {
  const AddItemOrden({super.key, required this.item});
  final PlanificacionLast item;

  @override
  State<AddItemOrden> createState() => _AddItemOrdenState();
}

class _AddItemOrdenState extends State<AddItemOrden> {
  bool isLoading = false;
  List<ProductPlanificaion> listProduct = [];

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
      );
      listNewOrderProduct.add(productNewOrden);
    }

    Map<String, dynamic> data = {
      'list_producto': listNewOrderProduct.map((item) => item.toMap()).toList(),
    };

    // print('-------------------');

    final res = await httpEnviaMap(
        'http://$ipLocal/settingmat/admin/insert/insert_new_producto_to_orden.php',
        jsonEncode(data));
    // print(res);
    final response = jsonDecode(res);
    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['message']),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ));
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pop(context, true);
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

  void addProductoDialog() async {
    final product = await showDialog(
        context: context,
        builder: ((context) {
          return const AddProducto();
        }));

    if (product != null) {
      // var item = [];
      // print('Producto : $product');
      for (var item in product['list_department']) {
        listProduct.add(
          ProductPlanificaion(
              cantProduto: product['cant'],
              tipoProducto: product['product'],
              department: item),
        );
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    const curve = Curves.elasticInOut;
    final style = Theme.of(context).textTheme;
    String textPlain =
        "-Bordados -Serigrafía -Sublimación -Vinil -Uniformes deportivos y empresariales -Promociones y Más";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar producto'),
      ),
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
                                        Text(
                                            'Num Orden : ${widget.item.numOrden}',
                                            style:
                                                const TextStyle(fontSize: 14)),
                                        Text('Ficha : ${widget.item.ficha}',
                                            style:
                                                const TextStyle(fontSize: 14)),
                                        Text('Logo : ${widget.item.nameLogo}',
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
                                    : const SizedBox()
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Bounce(
                                    curve: curve,
                                    child: const Text('Nuevo Producto !',
                                        style: TextStyle(
                                            fontSize: 24, color: colorsAd)),
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
                                const SizedBox(height: 15),
                                customButton(
                                    onPressed: () => addProductoDialog(),
                                    width: 250,
                                    colorText: Colors.white,
                                    colors: colorsAd,
                                    textButton: 'Agregar Articulo'),
                                listProduct.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.all(25.0),
                                        child: ZoomIn(
                                          curve: Curves.easeInOutExpo,
                                          child: TextButton(
                                              onPressed: () =>
                                                  terminarOrden(context),
                                              child: Text(
                                                  'Click ! ,Registrar Productos',
                                                  style: style.bodyMedium
                                                      ?.copyWith(
                                                          color: colorsRed))),
                                        ),
                                      )
                                    : const SizedBox()
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
