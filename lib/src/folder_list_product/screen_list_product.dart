import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screen_print_pdf/apis/pdf_api.dart';
import '../util/debounce.dart';
import '../util/helper.dart';
import '../util/show_mesenger.dart';
import '/src/datebase/current_data.dart';
import '/src/folder_list_product/model_product/product.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/get_formatted_number.dart';
import '../datebase/methond.dart';
import '../datebase/url.dart';
import '../model/users.dart';
import '../util/dialog_confimarcion.dart';
import 'add_product_dialog.dart';
import 'printers/print_list_product.dart';

class ScreenListProduct extends StatefulWidget {
  const ScreenListProduct({super.key});

  @override
  State<ScreenListProduct> createState() => _ScreenListProductState();
}

class _ScreenListProductState extends State<ScreenListProduct> {
  List<Product> list = [];
  List<Product> listFilter = [];
  Debounce? debounce = Debounce(duration: const Duration(milliseconds: 500));
  bool _isPriceAscending =
      true; // Estado para controlar la dirección de la ordenación
  int _limit = 350;
  int _offset = 0;
  String _search = '';
  int _totalPaginas = 1;

  int get totalPaginas => _totalPaginas;
  int get paginaActual => (_offset ~/ _limit) + 1;
  Future getListProduct({int? limit, int? offset, String? search}) async {
    debounce ??= Debounce(duration: const Duration(milliseconds: 500));
    list.clear();
    listFilter.clear();
    _limit = limit ?? _limit;
    _offset = offset ?? _offset;
    _search = search ?? _search;
    String url =
        "http://$ipLocal/$pathLocal/productos/get_productos.php?filtro=$_search&limit=$_limit&offset=$_offset";
    final res = await httpRequestDatabaseGET(url);
    if (res == null) {
      return;
    }

    // final body = jsonDecode(res.body);
    final data = jsonDecode(res.body);
    if (data['success']) {
      list = productFromJson(jsonEncode(data['productos']));
      listFilter = list;
      _totalPaginas = data['total'] ?? 1;
    } else {
      list.clear();
      listFilter.clear();
    }
    if (!context.mounted) return;
    debounce?.call(() {
      setState(() {});
    });
  }

  void siguientePagina() {
    if (_offset + _limit < _totalPaginas * _limit) {
      _offset += _limit;
      getListProduct();
    }
  }

  void anteriorPagina() {
    if (_offset - _limit >= 0) {
      _offset -= _limit;
      getListProduct();
    }
  }

  void buscarCliente(String texto) {
    Debounce debounce = Debounce(duration: const Duration(milliseconds: 500));
    debounce.call(() {
      _offset = 0; // Reiniciar a la primera página
      getListProduct(search: texto);
    });
  }

  @override
  void initState() {
    getListProduct();
    super.initState();
  }

// Para mostrar el diálogo:
  void mostrarAgregarProductDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddProductDialog();
      },
    ).then((value) {
      if (value != null) {
        getListProduct();
      }
    });
  }

  Future eliminarProduct(Product item) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmacionDialog(
          mensaje: '❌ Esta seguro de eliminar este producto ? ❌',
          titulo: 'Alerta',
          onConfirmar: () async {
            Navigator.of(context).pop();
            String url =
                "http://$ipLocal/settingmat/admin/delete/delete_product.php";
            await httpRequestDatabase(url, {'id_product': item.idProducto});
            setState(() {
              listFilter.remove(item);
            });
          },
        );
      },
    );
  }

  editarProduct(Product item) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController =
            TextEditingController(text: item.nameProducto);
        TextEditingController priceController =
            TextEditingController(text: item.priceProduct.toString());
        TextEditingController stockController =
            TextEditingController(text: item.stock.toString());
        TextEditingController minimoController =
            TextEditingController(text: item.minimo.toString());
        TextEditingController maximoController =
            TextEditingController(text: item.maximo.toString());

        TextEditingController priceTwoController =
            TextEditingController(text: item.priceTwo.toString());
        TextEditingController priceThreeController =
            TextEditingController(text: item.priceThree.toString());

        TextEditingController costoController =
            TextEditingController(text: item.costo.toString());
        TextEditingController referenciaController =
            TextEditingController(text: item.referencia.toString());

        return AlertDialog(
          title: const Text('Editar Producto', style: TextStyle(fontSize: 16)),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildTextFieldValidator(
                    label: 'Referencia Producto', controller: nameController),
                buildTextFieldValidator(
                    label: 'Nombre Producto', controller: referenciaController),
                buildTextFieldValidator(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+(\.\d{0,2})?$'))
                    ],
                    keyboardType: TextInputType.number,
                    label: 'Costo',
                    controller: costoController),
                buildTextFieldValidator(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+(\.\d{0,2})?$'))
                    ],
                    keyboardType: TextInputType.number,
                    label: 'Precio 1',
                    controller: priceController),
                buildTextFieldValidator(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+(\.\d{0,2})?$'))
                    ],
                    keyboardType: TextInputType.number,
                    label: 'Precio 2',
                    controller: priceTwoController),
                buildTextFieldValidator(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+(\.\d{0,2})?$'))
                    ],
                    keyboardType: TextInputType.number,
                    label: 'Precio 3',
                    controller: priceThreeController),
                buildTextFieldValidator(
                    controller: minimoController,
                    hintText: 'Escribir Minimo',
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    label: 'Minimo'),
                buildTextFieldValidator(
                    controller: maximoController,
                    hintText: 'Escribir Maximo',
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    label: 'Maximo'),
                buildTextFieldValidator(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+(\.\d{0,2})?$'))
                    ],
                    keyboardType: TextInputType.number,
                    label: 'Disponibilidad',
                    controller: stockController,
                    onEditingComplete: () async {
                      if (nameController.text.isEmpty) {
                        showScaffoldMessenger(
                            context, 'Nombre vacio', Colors.red);
                        return;
                      }
                      if (priceController.text.isEmpty) {
                        showScaffoldMessenger(
                            context, 'Precio vacio', Colors.red);
                        return;
                      }

                      String url =
                          "http://$ipLocal/settingmat/admin/update/update_product.php";
                      final res = await httpRequestDatabase(url, {
                        'id_product': item.idProducto,
                        'name_product':
                            nameController.text.toUpperCase().trim(),
                        'price_product': priceController.text.trim(),
                        'stock': stockController.text.trim(),
                        'minimo': minimoController.text.trim(),
                        'maximo': maximoController.text.trim(),
                        'price_two': priceTwoController.text.trim(),
                        'price_three': priceThreeController.text.trim(),
                        'costo': costoController.text.trim(),
                        'referencia': referenciaController.text.trim(),
                      });

                      setState(() {
                        item.nameProducto = nameController.text;
                        item.priceProduct = priceController.text;
                      });
                      if (!context.mounted) {
                        return; // ✅ Verificamos que el widget siga activo
                      }
                      showScaffoldMessenger(
                          context,
                          jsonDecode(res.body)['message'],
                          Colors.black87); // Puedes usar el mensaje real
                      Navigator.of(context).pop();
                      getListProduct();
                    }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isEmpty) {
                  showScaffoldMessenger(context, 'Nombre vacio', Colors.red);
                  return;
                }
                if (priceController.text.isEmpty) {
                  showScaffoldMessenger(context, 'Precio vacio', Colors.red);
                  return;
                }
                String url =
                    "http://$ipLocal/settingmat/admin/update/update_product.php";
                final res = await httpRequestDatabase(url, {
                  'id_product': item.idProducto,
                  'name_product': nameController.text.toUpperCase().trim(),
                  'price_product': priceController.text.trim(),
                  'stock': stockController.text.trim(),
                  'minimo': minimoController.text.trim(),
                  'maximo': maximoController.text.trim(),
                  'price_two': priceTwoController.text.trim(),
                  'price_three': priceThreeController.text.trim(),
                  'costo': costoController.text.trim(),
                  'referencia': referenciaController.text.trim(),
                });
                setState(() {
                  item.nameProducto = nameController.text;
                  item.priceProduct = priceController.text;
                });
                if (!context.mounted) {
                  return; // ✅ Verificamos que el widget siga activo
                }
                showScaffoldMessenger(context, jsonDecode(res.body)['message'],
                    Colors.black87); // Puedes usar el mensaje real
                Navigator.of(context).pop();
                getListProduct();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // void applyFilter(String value) {
  //   debounce ??= Debounce(duration: const Duration(milliseconds: 500));
  //   debounce!.call(() {
  //     setState(() {
  //       listFilter = list
  //           .where((element) => element.nameProduct!
  //               .toLowerCase()
  //               .contains(value.toLowerCase()))
  //           .toList();
  //     });
  //   });
  // }

  void imprimirInventario() async {
    final doc = await PrintListProduct.generate(listFilter);
    await PdfApi.openFile(doc);
  }

  void applyClear() {
    debounce ??= Debounce(duration: const Duration(milliseconds: 200));
    debounce!.call(() {
      setState(() {
        listFilter = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    const curve = Curves.elasticInOut;
    String textPlain =
        "-Bordados -Serigrafía -Sublimación -Vinil -Uniformes deportivos y empresariales -Promociones y Más";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos $nameApp'),
        actions: [
          hasPermissionUsuario(currentUsers!.listPermission!, "admin", "crear")
              ? Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Tooltip(
                    message: 'add nuevo producto!',
                    child: IconButton(
                        onPressed: () => mostrarAgregarProductDialog(context),
                        icon: const Icon(Icons.person_add_alt_1_outlined)),
                  ),
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.only(right: 0),
            child: Tooltip(
              message: 'Clean!',
              child: IconButton(
                  onPressed: () => applyClear(),
                  icon: const Icon(Icons.filter_alt_off_outlined)),
            ),
          ),
          listFilter.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Tooltip(
                    message: 'Imprimir',
                    child: IconButton(
                        onPressed: () => imprimirInventario(),
                        icon: const Icon(Icons.print_outlined)),
                  ),
                )
              : const SizedBox(),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          buildTextFieldValidator(
              label: 'Buscar producto',
              hintText: 'Buscar producto',
              onChanged: (value) => buscarCliente(value)),
          const SizedBox(width: double.infinity, height: 10),
          listFilter.isEmpty
              ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BounceInDown(
                        curve: curve,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child:
                              Image.asset('assets/existencias.gif', scale: 5),
                        ),
                      ),
                      FadeIn(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: 200,
                            child: Text('No hay Datos. ...',
                                textAlign: TextAlign.center,
                                style: style.bodySmall
                                    ?.copyWith(color: Colors.grey)),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        child: DataTable(
                          dataRowMaxHeight: 25,
                          dataRowMinHeight: 20,
                          horizontalMargin: 10.0,
                          columnSpacing: 15,
                          headingRowHeight: 30,
                          decoration: const BoxDecoration(color: ktejidoblue),
                          headingTextStyle:
                              const TextStyle(color: Colors.white),
                          border: TableBorder.symmetric(
                              outside: BorderSide(
                                  color: Colors.grey.shade100,
                                  style: BorderStyle.none),
                              inside: const BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.grey)),
                          columns: [
                            const DataColumn(label: Text('Editar')),
                            const DataColumn(label: Text('# Ref.')),
                            const DataColumn(label: Text('Nombre producto')),
                            const DataColumn(label: Text('Costo')),
                            const DataColumn(label: Text('En Inventario')),
                            const DataColumn(label: Text('Pedir')),
                            DataColumn(
                              label: Row(
                                children: [
                                  const Text('Precio 1'),
                                  const SizedBox(width: 5),
                                  Icon(
                                    _isPriceAscending
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                _sortByPrice();
                              },
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  const Text('Precio 2'),
                                  const SizedBox(width: 5),
                                  Icon(
                                    _isPriceAscending
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                _sortByPrice1();
                              },
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  const Text('Precio 3'),
                                  const SizedBox(width: 5),
                                  Icon(
                                    _isPriceAscending
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                _sortByPrice2();
                              },
                            ),
                            const DataColumn(label: Text('Eliminar')),
                          ],
                          rows: listFilter.asMap().entries.map((entry) {
                            int index = entry.key;
                            var report = entry.value;
                            return DataRow(
                              color: MaterialStateProperty.resolveWith<Color>(
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
                                hasPermissionUsuario(
                                        currentUsers!.listPermission!,
                                        "inventario",
                                        "actualizar")
                                    ? DataCell(const Text('Editar'),
                                        onTap: () => editarProduct(report))
                                    : const DataCell(Text('Sin Permiso')),
                                DataCell(Text(report.referencia ?? 'N/A')),
                                DataCell(Text(report.nameProducto ?? 'N/A')),
                                hasPermissionUsuario(
                                        currentUsers!.listPermission!,
                                        "admin",
                                        "eliminar")
                                    ? DataCell(Text(
                                        '\$ ${getNumFormatedDouble(report.costo ?? '0.0')}'))
                                    : const DataCell(Text('Costo')),
                                DataCell(Center(
                                    child: Text(report.stock ?? '0.0',
                                        style: TextStyle(
                                            color:
                                                Product.validatorStock(report)
                                                    ? colorsBlueDeepHigh
                                                    : colorsRedOpaco
                                                        .withOpacity(0.4),
                                            fontWeight: FontWeight.w500)))),
                                DataCell(
                                    Center(
                                      child: Tooltip(
                                        message:
                                            'Minimo : ${report.minimo}, Maximo : ${report.maximo}',
                                        child: Text(
                                          Product.getCantidadParaCompletarMaximo(
                                                  report)
                                              .toString(),
                                          style: TextStyle(
                                              color:
                                                  Product.necesitaReabastecer(
                                                          report)
                                                      ? Colors.red
                                                      : Colors.black),
                                        ),
                                      ),
                                    ), onTap: () {
                                  listFilter = Product
                                      .filtrarProductosQueNecesitanReabastecer(
                                          list);
                                  setState(() {});
                                }),
                                DataCell(Center(
                                    child: Text(
                                        '\$ ${getNumFormatedDouble(report.priceProduct.toString())}'))),
                                DataCell(Center(
                                    child: Text(
                                        '\$ ${getNumFormatedDouble(report.priceTwo.toString())}'))),
                                DataCell(Center(
                                    child: Text(
                                        '\$ ${getNumFormatedDouble(report.priceThree.toString())}'))),
                                DataCell(
                                    hasPermissionUsuario(
                                            currentUsers!.listPermission!,
                                            "admin",
                                            "eliminar")
                                        ? const Text('Eliminar')
                                        : const Text('Sin Permiso'),
                                    onTap: () => eliminarProduct(report)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: paginaActual > 1 ? anteriorPagina : null,
              ),
              Text('Página $paginaActual de $totalPaginas'),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: paginaActual < totalPaginas ? siguientePagina : null,
              ),
            ],
          ),
          Text('Cantidad de productos: ${listFilter.length}',
              style: style.bodySmall?.copyWith(color: Colors.grey)),
          identy(context)
        ],
      ),
    );
  } // Función para ordenar la lista por precio

  void _sortByPrice() {
    setState(() {
      _isPriceAscending =
          !_isPriceAscending; // Alterna entre ascendente y descendente
      listFilter.sort((a, b) {
        if (_isPriceAscending) {
          return a.priceProduct!.compareTo(b.priceProduct!); // Orden ascendente
        } else {
          return b.priceProduct!
              .compareTo(a.priceProduct!); // Orden descendente
        }
      });
    });
  }

  void _sortByPrice1() {
    setState(() {
      _isPriceAscending =
          !_isPriceAscending; // Alterna entre ascendente y descendente
      listFilter.sort((a, b) {
        if (_isPriceAscending) {
          return a.priceTwo!.compareTo(b.priceTwo!); // Orden ascendente
        } else {
          return b.priceTwo!.compareTo(a.priceTwo!); // Orden descendente
        }
      });
    });
  }

  void _sortByPrice2() {
    setState(() {
      _isPriceAscending =
          !_isPriceAscending; // Alterna entre ascendente y descendente
      listFilter.sort((a, b) {
        if (_isPriceAscending) {
          return a.priceThree!.compareTo(b.priceThree!); // Orden ascendente
        } else {
          return b.priceThree!.compareTo(a.priceThree!); // Orden descendente
        }
      });
    });
  }
}




// select_inventory_outputs.php