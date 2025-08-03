import 'package:flutter/material.dart';

import '../folder_list_product/model_product/product.dart';
import '../util/get_formatted_number.dart';
import '../util/helper.dart';

class EntradaInventario extends StatefulWidget {
  const EntradaInventario({super.key});

  @override
  State createState() => _EntradaInventarioState();
}

class _EntradaInventarioState extends State<EntradaInventario> {
  // StockServer compraServer = StockServer();
  String date1 = DateTime.now().toString().substring(0, 10);
  String date2 = DateTime.now().toString().substring(0, 10);

  List<Product> listPurchaseFilter = [];
  List<Product> listPurchase = [];
  Future getCompras() async {
    // listPurchase = await compraServer.getStockInput(date1, date2);
    // listPurchaseFilter = listPurchase;
    // setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCompras();
  }

  void filterProducto(String filter) {
    if (filter.isNotEmpty) {
      listPurchaseFilter = listPurchase
          .where((element) => element.nameProducto!
              .toUpperCase()
              .contains(filter.toUpperCase()))
          .toList();
    } else {
      listPurchaseFilter = listPurchase;
    }

    setState(() {});
  }

  //select_purchases
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Entradas'),
          actions: [
            IconButton(
                onPressed: () async {
                  await selectDateRange(context, (fecha1, fecha2) {
                    date1 = fecha1;
                    date2 = fecha2;
                    getCompras();
                  });
                },
                icon: const Icon(Icons.calendar_month)),
            Padding(
                padding: const EdgeInsets.only(right: 25),
                child: IconButton(
                    onPressed: () async {}, icon: const Icon(Icons.print)))
          ],
        ),
        body: Column(
          children: [
            const SizedBox(width: double.infinity),
            buildTextFieldValidator(
                label: 'Buscar', onChanged: (filter) => filterProducto(filter)),
            listPurchaseFilter.isEmpty
                ? Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/logo_app_sin_fondo.png',
                              scale: 2),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('No hay datos...',
                                  style: style.bodySmall))
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
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
                              decoration:
                                  const BoxDecoration(color: Colors.brown),
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
                                DataColumn(label: Text('Nombre del producto')),
                                DataColumn(label: Text('Cantidad')),
                                DataColumn(label: Text('Precio')),
                                DataColumn(label: Text('Subtotal')),
                                DataColumn(label: Text('Fecha')),
                              ],
                              rows: listPurchaseFilter
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                int index = entry.key;
                                Product item = entry.value;
                                return DataRow(
                                  color:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (states) {
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
                                    DataCell(Text(item.nameProducto ?? 'N/A')),
                                    DataCell(Center(
                                      child: Text(getNumFormatedDouble(
                                          item.stock ?? '0.0')),
                                    )),
                                    DataCell(Center(
                                      child: Text(
                                          '\$ ${getNumFormatedDouble(item.priceProduct.toString())}'),
                                    )),
                                    DataCell(Center(
                                      child: Text(
                                          '\$ ${getNumFormatedDouble('0')}'),
                                    )),
                                    DataCell(Text('')),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(
                height: 60,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Items :',
                                style: TextStyle(color: Colors.black54)),
                            const SizedBox(width: 10),
                            Text(listPurchase.length.toString(),
                                style: style.bodySmall
                                    ?.copyWith(color: Colors.black54))
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Qty :',
                                style: TextStyle(color: Colors.black54)),
                            const SizedBox(width: 10),
                            Text(getNumFormatedDouble('0.0'),
                                style: style.bodySmall
                                    ?.copyWith(color: Colors.black54))
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('SubTotal :',
                                style: TextStyle(color: Colors.black54)),
                            const SizedBox(width: 10),
                            Text('\$ ${getNumFormatedDouble('0.0')}',
                                style: style.bodySmall
                                    ?.copyWith(color: Colors.green))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // identy(context)
          ],
        ),
      ),
    );
  }
}
