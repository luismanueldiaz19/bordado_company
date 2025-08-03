import 'dart:convert';

import 'package:bordado_company/src/datebase/current_data.dart';
import 'package:flutter/material.dart';

import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/util/get_formatted_number.dart';

import '../util/commo_pallete.dart';
import '../util/helper.dart';
import 'add_product_dialog.dart';
import 'model_product/product.dart';

class DialogGetProductos extends StatefulWidget {
  const DialogGetProductos({super.key});

  @override
  State<DialogGetProductos> createState() => _DialogGetProductosState();
}

class _DialogGetProductosState extends State<DialogGetProductos> {
  List<Product> listClients = [];
  List<Product> listClientsFilter = [];

  Product? entregadorCurrent;

  Future getProducto() async {
    // debugPrint('Get Cliente ..... Esperes ...');
    String url = "http://$ipLocal/$pathLocal/productos/get_productos.php";
    final res = await httpRequestDatabaseGET(url);
    // print(res?.body);
    if (res != null) {
      final data = jsonDecode(res.body);
      if (data['success']) {
        // print(jsonEncode(data['productos']));
        listClients = productFromJson(jsonEncode(data['productos']));
        listClientsFilter = listClients;
      } else {
        context.mounted
            ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(data['message']),
                duration: const Duration(seconds: 1)))
            : null;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getProducto();
  }

  _seachingItem(String value) {
    if (value.isNotEmpty) {
      setState(() {
        listClientsFilter = listClients
            .where((element) => element.nameProducto!
                .toUpperCase()
                .contains(value.toUpperCase()))
            .toList();
      });
    } else {
      setState(() {
        listClientsFilter = listClients;
      });
    }
  }

// Para mostrar el diálogo:
  void mostrarAgregarClienteDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddProductDialog();
      },
    ).then((value) {
      if (value != null) {
        getProducto();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final sized = MediaQuery.sizeOf(context);
    // Función auxiliar
    Widget buildPriceText(String price, {VoidCallback? onPressed}) {
      return TextButton(
        onPressed: onPressed,
        child: Text(
          '\$ ${getNumFormatedDouble(price)}',
          style: style.labelSmall?.copyWith(
            color: colorsBlueTurquesaOther.withAlpha(128),
            fontSize: 12,
          ),
        ),
      );
    }

    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 10,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Elegir el producto', style: style.labelLarge),
          buildTextFieldValidator(
              onChanged: (val) => _seachingItem(val),
              hintText: 'Buscar producto',
              label: 'Buscar',
              color: Colors.white),
          Tooltip(
            message: 'add nuevo producto!',
            child: IconButton(
              onPressed: () => mostrarAgregarClienteDialog(context),
              icon: const Icon(Icons.add),
            ),
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: const Text('Cancelar', style: TextStyle(color: Colors.red))),
        customButton(
          width: 150,
          colorText: Colors.white,
          colors: colorsAd,
          textButton: 'Elegir',
          onPressed: () {
            Navigator.pop(context, entregadorCurrent);
          },
        )
      ],
      content: SizedBox(
        height: sized.height * 0.50,
        child: Column(
          children: [
            const SizedBox(height: 10),
            listClientsFilter.isNotEmpty
                ? Expanded(
                    child: SizedBox(
                      width: sized.width * 0.50,
                      child: ListView.builder(
                        itemCount: listClientsFilter.length,
                        itemBuilder: (context, index) {
                          Product item = listClientsFilter[index];

                          return Container(
                            color: entregadorCurrent == item
                                ? Colors.blue.shade100
                                : Colors.white,
                            width: sized.width * 0.50,
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    entregadorCurrent == item
                                        ? ktejidoBlueOcuro.withValues(
                                            alpha: 0.1)
                                        : Colors.white),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  entregadorCurrent = item;
                                });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item.nameProducto ?? 'N/A',
                                          style: style.labelSmall),
                                      Text('${(item.stock.toString())} Stock',
                                          style: style.labelSmall?.copyWith(
                                              color:
                                                  Product.validatorStock(item)
                                                      ? colorsBlueTurquesa
                                                      : colorsRed,
                                              fontSize: 8)),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Row(
                                      spacing: 10,
                                      children: [
                                        buildPriceText(
                                            item.priceProduct.toString(),
                                            onPressed: () {
                                          entregadorCurrent = item;
                                          if (entregadorCurrent != null) {
                                            entregadorCurrent!.originalPrice =
                                                item.priceProduct;
                                            Navigator.pop(
                                                context, entregadorCurrent);
                                          }
                                        }),
                                        buildPriceText(item.priceTwo.toString(),
                                            onPressed: () {
                                          entregadorCurrent = item;
                                          if (entregadorCurrent != null) {
                                            entregadorCurrent!.originalPrice =
                                                item.priceTwo;
                                            Navigator.pop(
                                                context, entregadorCurrent);
                                          }
                                        }),
                                        buildPriceText(
                                            item.priceThree.toString(),
                                            onPressed: () {
                                          entregadorCurrent = item;
                                          if (entregadorCurrent != null) {
                                            entregadorCurrent!.originalPrice =
                                                item.priceThree;
                                            Navigator.pop(
                                                context, entregadorCurrent);
                                          }
                                        }),
                                        // buildPriceText(item.costo.toString()),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : const Center(child: Text('No hay producto')),
          ],
        ),
      ),
    );
  }
}
