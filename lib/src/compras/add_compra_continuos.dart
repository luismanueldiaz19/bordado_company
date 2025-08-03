import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../datebase/current_data.dart';
import '../datebase/methond.dart';
import '../datebase/url.dart';
import '../model/purchase.dart';

import '../util/commo_pallete.dart';
import '../util/get_formatted_number.dart';
import '../util/helper.dart';
import '../widgets/loading.dart';
import 'get_dialog_product.dart';

class AddCompraContinuos extends StatefulWidget {
  const AddCompraContinuos({super.key, this.item});
  final Purchases? item;

  @override
  State createState() => _AddCompraContinuosState();
}

class _AddCompraContinuosState extends State<AddCompraContinuos> {
  List<PurchasesItem> listPurchase = [];
  Purchases? factura;
  bool isLoading = false;
  Future pickedProduct() async {
    List<PurchasesItem>? productPicked = await showDialog<List<PurchasesItem>>(
        context: context,
        builder: (context) {
          return const GetDialogProductOther();
        });

    if (productPicked != null && productPicked.isNotEmpty) {
      for (var element in productPicked) {
        listPurchase.add(element);
      }
      setState(() {});
    } else {
      print('no hay lista de productos');
    }
  }

  @override
  void initState() {
    super.initState();
    factura = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    const curve = Curves.elasticInOut;
    final style = Theme.of(context).textTheme;
    String textPlain = "- Bordados | Serigrafía | Sublimación y Más";
    return Scaffold(
      appBar: AppBar(title: const Text('Continuación de Factura')),
      body: isLoading
          ? const Loading(
              imagen: 'assets/facturacion_electronica.png',
              text: 'Enviando factura a la nube...')
          : Column(
              children: [
                const SizedBox(width: double.infinity),
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
                                    fontSize: 24, color: Colors.blueAccent)),
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
                        factura != null
                            ? Text(factura?.proveedor ?? '')
                            : const SizedBox(),
                        const SizedBox(height: 15),
                        customButton(
                            onPressed: pickedProduct,
                            width: 250,
                            colorText: Colors.white,
                            colors: colorsAd,
                            textButton: 'Agregar Articulo'),
                        listPurchase.isEmpty
                            ? Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                          'assets/logo_app_sin_fondo.png',
                                          scale: 5),
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              'No hay lista de productos...',
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
                                          decoration: const BoxDecoration(
                                              color: colorsAd),
                                          headingTextStyle: const TextStyle(
                                              color: Colors.white),
                                          border: TableBorder.symmetric(
                                              outside: BorderSide(
                                                  color: Colors.grey.shade100,
                                                  style: BorderStyle.none),
                                              inside: const BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: Colors.grey)),
                                          columns: [
                                            DataColumn(
                                                label: Text(
                                                    'Nombre del producto')),
                                            DataColumn(label: Text('Cantidad')),
                                            DataColumn(label: Text('Precio')),
                                            DataColumn(label: Text('Subtotal')),
                                            DataColumn(label: Text('Eliminar')),
                                          ],
                                          rows: listPurchase
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            int index = entry.key;
                                            PurchasesItem item = entry.value;
                                            return DataRow(
                                              color: MaterialStateColor
                                                  .resolveWith(
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
                                                DataCell(Text(
                                                    item.nameProduct ?? 'N/A')),
                                                DataCell(Center(
                                                  child: Text(
                                                      getNumFormatedDouble(
                                                          item.cantidad ??
                                                              '0.0')),
                                                )),
                                                DataCell(Center(
                                                  child: Text(
                                                      '\$ ${getNumFormatedDouble(item.precioUnitario ?? '0.0')}'),
                                                )),
                                                DataCell(Center(
                                                  child: Text(
                                                      '\$ ${getNumFormatedDouble(item.subtotal ?? '0.0')}'),
                                                )),
                                                DataCell(
                                                    const Center(
                                                      child: Text('Quitar'),
                                                    ), onTap: () {
                                                  setState(() {
                                                    listPurchase.remove(item);
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
                              ),
                        listPurchase.isNotEmpty
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: SizedBox(
                                  height: 60,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text('Items :',
                                                  style: TextStyle(
                                                      color: Colors.black54)),
                                              const SizedBox(width: 10),
                                              Text(
                                                  listPurchase.length
                                                      .toString(),
                                                  style: style.bodySmall
                                                      ?.copyWith(
                                                          color:
                                                              Colors.black54))
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
                                              boxShadow: []),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text('Qty :',
                                                  style: TextStyle(
                                                      color: Colors.black54)),
                                              const SizedBox(width: 10),
                                              Text(
                                                  getNumFormatedDouble(
                                                      PurchasesItem.getTotalQty(
                                                          listPurchase)),
                                                  style: style.bodySmall
                                                      ?.copyWith(
                                                          color:
                                                              Colors.black54))
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
                                              boxShadow: []),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text('SubTotal :',
                                                  style: TextStyle(
                                                      color: Colors.black54)),
                                              const SizedBox(width: 10),
                                              Text(
                                                  '\$ ${getNumFormatedDouble(PurchasesItem.getTotalCant(listPurchase))}',
                                                  style: style.bodySmall
                                                      ?.copyWith(
                                                          color: Colors.green))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        listPurchase.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: ZoomIn(
                                  curve: Curves.easeInOutExpo,
                                  child: customButton(
                                      onPressed: _guardarFactura,
                                      width: 250,
                                      colorText: Colors.white,
                                      colors: colorsAd,
                                      textButton: 'Click ! ,Registrar Factura'),
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Future _guardarFactura() async {
    setState(() {
      isLoading = true;
    });
    // CompraServer compraServer = CompraServer();
    //insert_purchases_2
    factura = Purchases(
        purchasesId: '111515',
        fechaCompra: DateTime.now().toString().substring(0, 19),
        usuario: currentUsers?.fullName,
        proveedor: widget.item?.proveedor,
        total: listPurchase
            .fold(0.0,
                (sum, item) => sum + (double.tryParse(item.subtotal!) ?? 0.0))
            .toStringAsFixed(2),
        estado: widget.item?.estado,
        purchasesItems: listPurchase,
        nota: widget.item?.nota,
        numFactura: widget.item?.numFactura);
    // print(factura?.toJson());
    String jsonFactura = json.encode(factura?.toJson());
    // 📌 Aquí puedes enviar `jsonFactura` a tu API
    print(jsonFactura);
    String response = await addComprar(jsonFactura);
    await Future.delayed(const Duration(seconds: 2));
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.toUpperCase()), backgroundColor: Colors.green));
    setState(() {
      isLoading = false;
      listPurchase.clear();
    });
  }

  Future<String> addComprar(dynamic jsonLocal) async {
    final res = await httpEnviaMap(
        'http://$ipLocal/settingmat/admin/insert/insert_purchases.php',
        jsonLocal);
    final dataJson = json.decode(res);
    if (dataJson['success']) {
      return dataJson['message'];
    } else {
      return dataJson['message'];
    }
  }
}
