import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../datebase/methond.dart';
import '../datebase/url.dart';
import '../folder_list_product/model_product/product.dart';
import '../model/purchase.dart';
import '../util/helper.dart';
import '../widgets/loading.dart';

class GetDialogProductOther extends StatefulWidget {
  const GetDialogProductOther({super.key});

  @override
  State createState() => _GetDialogProductState();
}

class _GetDialogProductState extends State<GetDialogProductOther> {
  List<Product> listClients = [];
  List<Product> listClientsFilter = [];
  @override
  void initState() {
    getProductos();
    super.initState();
  }

  Future getProductos() async {
    // debugPrint('Get Cliente ..... Esperes ...');
    String url =
        "http://$ipLocal/settingmat/admin/select/select_list_product.php";
    final res = await httpRequestDatabaseGET(url);
    // print(res?.body);
    if (res != null) {
      final data = jsonDecode(res.body);
      if (data['success']) {
        listClients = productFromJson(jsonEncode(data['body']));
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

  // Producto? productoSelected;

  final List<PurchasesItem> listPurchase = [];

  void filterProducto(String filter) {
    if (filter.isNotEmpty) {
      listClientsFilter = listClients
          .where((element) =>
              element.nameProducto!
                  .toUpperCase()
                  .contains(filter.toUpperCase()) ||
              element.referencia!.toUpperCase().contains(filter.toUpperCase()))
          .toList();
    } else {
      listClientsFilter = listClients;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final sized = MediaQuery.sizeOf(context);
    // final provideWatch = context.watch<ProviderProductos>();
    // final providerRead = context.read<ProviderProductos>();
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 10,
      actions: [
        Wrap(
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 100,
              child: TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Cancelar',
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.of(context)
                      .pop(null); // Devuelve falso si se cancela
                },
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 100,
              child: TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Aceptar',
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  if (listPurchase.isNotEmpty) {
                    Navigator.of(context)
                        .pop(listPurchase); // Devuelve true si se acepta
                  } else {
                    // Devuelve falso si se cancela
                    Navigator.of(context).pop(null);
                  }
                },
              ),
            ),
          ],
        )
      ],
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.sizeOf(context).height * 0.90,
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              width: 350,
              child: buildTextFieldValidator(
                  onChanged: (val) => filterProducto(val),
                  hintText: 'Buscar producto',
                  label: 'Buscar'),
            ),
            const SizedBox(height: 10),
            listClientsFilter.isNotEmpty
                ? PaginatedDataTable(
                    header: Text('Lista de productos', style: style.bodySmall),
                    columns: const [
                      DataColumn(label: Text('Nombre de productos')),
                      DataColumn(label: Text('Cantidad')),
                      DataColumn(label: Text('Precios')),
                    ],
                    source: ProductTableSource(listClientsFilter, addItem),
                    rowsPerPage: 10, // Puedes permitir cambiarlo con Dropdown
                    columnSpacing: 20,
                    showCheckboxColumn: false,
                  )
                : const Loading(
                    imagen: 'assets/paquete-o-empaquetar.png',
                    text: 'No hay productos...',
                  ),
          ],
        ),
      ),
    );
  }

  void addItem(Product item, TextEditingController precioController,
      TextEditingController cantController) {
    if (precioController.text.isNotEmpty && cantController.text.isNotEmpty) {
      listPurchase.add(
        PurchasesItem(
          purchaseDetailid: DateTime.now().millisecondsSinceEpoch.toString(),
          cantidad: cantController.text,
          precioUnitario: precioController.text,
          idProduct: item.idProducto,
          nameProduct: item.nameProducto,
          subtotal: (double.parse(precioController.text) *
                  double.parse(cantController.text))
              .toStringAsFixed(2),
        ),
      );
      // print('listPurchase : ${listPurchase.length}');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Agregado!'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.green));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error,Tiene que escribir pouches o displays!'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.red));
    }
  }

  // void addItem(TextEditingController precioController,
  //     TextEditingController cantController, Product item) {
  //   if (precioController.text.isNotEmpty && cantController.text.isNotEmpty) {
  //     listPurchase.add(
  //       PurchasesItem(
  //         purchaseDetailsId: DateTime.now().millisecondsSinceEpoch.toString(),
  //         cantidad: cantController.text,
  //         precioUnitario: precioController.text,
  //         productoId: item.idProduct,
  //         nombreProducto: item.nameProduct,
  //         subtotal: (double.parse(precioController.text) *
  //                 double.parse(cantController.text))
  //             .toStringAsFixed(2),
  //       ),
  //     );
  //     print('listPurchase : ${listPurchase.length}');
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('Agregado!'),
  //         duration: Duration(seconds: 1),
  //         backgroundColor: Colors.green));
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('Error,Tiene que escribir pouches o displays!'),
  //         duration: Duration(seconds: 1),
  //         backgroundColor: Colors.red));
  //   }
  // }
}

class ProductTableSource extends DataTableSource {
  final List<Product> products;
  final Function(Product, TextEditingController, TextEditingController)
      onSelect;

  ProductTableSource(this.products, this.onSelect);

  @override
  DataRow getRow(int index) {
    if (index >= products.length) return const DataRow(cells: []);
    final product = products[index];

    final precioController = TextEditingController(text: '0.00');
    final cantController = TextEditingController();
    final cantFocus = FocusNode();
    final precioFocus = FocusNode();

    return DataRow.byIndex(
      index: index,
      color: MaterialStateColor.resolveWith(
          (states) => index.isOdd ? Colors.grey.shade300 : Colors.white),
      cells: [
        DataCell(Text(product.nameProducto ?? 'N/A')),
        DataCell(TextField(
          controller: cantController,
          decoration: const InputDecoration(hintText: 'cantidad'),
          focusNode: cantFocus,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d{0,5}(\.\d{0,2})?$')),
          ],
          onSubmitted: (_) {
            FocusScope.of(cantFocus.context!).requestFocus(precioFocus);
          },
        )),
        DataCell(TextField(
          controller: precioController,
          focusNode: precioFocus,
          decoration: const InputDecoration(hintText: 'precio'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d{0,5}(\.\d{0,2})?$')),
          ],
          onSubmitted: (_) {
            onSelect(product, precioController, cantController);
            FocusScope.of(precioFocus.context!).requestFocus(cantFocus);
            cantController.clear(); // Opcional
            precioController.text = '0.00';
          },
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => products.length;

  @override
  int get selectedRowCount => 0;
}
