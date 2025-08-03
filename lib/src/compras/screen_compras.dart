import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../datebase/current_data.dart';
import '../datebase/methond.dart';
import '../datebase/url.dart';
import '../model/purchase.dart';
import '../util/get_formatted_number.dart';
import '../util/helper.dart';
import '../widgets/card_purchase.dart';
import '../widgets/loading.dart';
import '../widgets/validar_screen_available.dart';
import 'add_compra.dart';

class ScreenCompras extends StatefulWidget {
  const ScreenCompras({super.key});

  @override
  State createState() => _ScreenComprasState();
}

class _ScreenComprasState extends State<ScreenCompras> {
  // CompraServer compraServer = CompraServer();
  String date1 = DateTime.now().toString().substring(0, 10);
  String date2 = DateTime.now().toString().substring(0, 10);

  List<Purchases> listPurchaseFilter = [];
  List<Purchases> listPurchase = [];

  Future getCompras() async {
    listPurchase = await getCompraList(date1, date2);
    listPurchaseFilter = listPurchase;
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCompras();
  }

  void filterProducto(String filter) {
    if (filter.isNotEmpty) {
      listPurchaseFilter = listPurchase
          .where((element) =>
              element.proveedor!.toUpperCase().contains(filter.toUpperCase()) ||
              element.estado!.toUpperCase().contains(filter.toUpperCase()))
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
    const curve = Curves.elasticInOut;
    String textPlain = "- Bordados | Serigrafía | Sublimación y Más";
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Compras a Inventario'),
          actions: [
            IconButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddCompra()));
                },
                icon: const Icon(Icons.add)),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                onPressed: () async {
                  await selectDateRange(context, (fecha1, fecha2) {
                    date1 = fecha1;
                    date2 = fecha2;
                    getCompras();
                  });
                },
                icon: const Icon(Icons.calendar_month),
              ),
            ),
            // Padding(
            //     padding: const EdgeInsets.only(right: 5),
            //     child: IconButton(
            //         onPressed: () async {
            //           // if (listFilter.isNotEmpty) {
            //           //   final doc = await PdfPrintGasto.generate(listFilter);
            //           //   await PdfApi.openFile(doc);
            //           // }
            //         },
            //         icon: const Icon(Icons.print)))
          ],
        ),
        body: ValidarScreenAvailable(
          mobile: Column(
            children: [
              const SizedBox(width: double.infinity),
              buildTextFieldValidator(
                  label: 'Buscar',
                  onChanged: (filter) => filterProducto(filter)),
              listPurchaseFilter.isEmpty
                  ? const LoadingNew(
                      imagen: 'assets/logo_app_sin_fondo.png',
                      text: 'No hay compras')
                  : Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: listPurchaseFilter.length,
                        itemBuilder: (context, index) {
                          Purchases purchases = listPurchaseFilter[index];
                          return PurchaseCard(purchase: purchases);
                        },
                      ),
                    ),
              listPurchaseFilter.isEmpty
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: SizedBox(
                        height: 60,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: const BoxDecoration(
                                    color: Colors.white, boxShadow: [shadow]),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Compras :',
                                        style:
                                            TextStyle(color: Colors.black54)),
                                    const SizedBox(width: 10),
                                    Text(listPurchaseFilter.length.toString(),
                                        style: style.bodySmall
                                            ?.copyWith(color: Colors.black54))
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: const BoxDecoration(
                                    color: Colors.white, boxShadow: [shadow]),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('SubTotal :',
                                        style:
                                            TextStyle(color: Colors.black54)),
                                    const SizedBox(width: 10),
                                    Text(
                                        '\$ ${getNumFormatedDouble(Purchases.getTotalCant(listPurchaseFilter))}',
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
              identy(context)
            ],
          ),
          windows: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    listPurchaseFilter.isEmpty
                        ? const LoadingNew(
                            imagen: 'assets/logo_app_sin_fondo.png',
                            text: 'No hay compras')
                        : Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: listPurchaseFilter.length,
                              itemBuilder: (context, index) {
                                Purchases purchases = listPurchaseFilter[index];
                                return PurchaseCard(purchase: purchases);
                              },
                            ),
                          ),
                    listPurchaseFilter.isEmpty
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: SizedBox(
                              height: 60,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [shadow]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text('Compras :',
                                              style: TextStyle(
                                                  color: Colors.black54)),
                                          const SizedBox(width: 10),
                                          Text(
                                              listPurchaseFilter.length
                                                  .toString(),
                                              style: style.bodySmall?.copyWith(
                                                  color: Colors.black54))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [shadow]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text('SubTotal :',
                                              style: TextStyle(
                                                  color: Colors.black54)),
                                          const SizedBox(width: 10),
                                          Text(
                                              '\$ ${getNumFormatedDouble(Purchases.getTotalCant(listPurchaseFilter))}',
                                              style: style.bodySmall?.copyWith(
                                                  color: Colors.green))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    identy(context)
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTextFieldValidator(
                        label: 'Buscar',
                        onChanged: (filter) => filterProducto(filter)),
                    SlideInRight(
                        curve: curve,
                        child: Image.asset('assets/paquete-o-empaquetar.png',
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Purchases>> getCompraList(date1, date2) async {
    final res = await httpRequestDatabase(
        'http://$ipLocal/settingmat/admin/select/select_purchases.php', {
      'date1': date1,
      'date2': date2,
    });

    // print(res.body);

    final dataJson = json.decode(res.body);
    if (dataJson['success']) {
      return purchasesFromJson(json.encode(dataJson['body']));
    }
    return [];
  }
}
