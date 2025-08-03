import 'dart:convert';

import 'package:flutter/material.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/nivel_2/folder_insidensia/model/product_incidencia.dart';
import '/src/nivel_2/folder_insidensia/pages_insidencia.dart/editting_incidencias_fordel/editting_incidencia.dart';
import '/src/nivel_2/folder_insidensia/model/incidencia.dart';
import '/src/nivel_2/folder_insidensia/print_insidencia/print_insidencia_solo.dart';
import '/src/screen_print_pdf/apis/pdf_api.dart';
import '/src/util/commo_pallete.dart';
import '/src/widgets/custom_app_bar.dart';

class DetallesCard extends StatefulWidget {
  final Incidencia current;

  const DetallesCard({super.key, required this.current});

  @override
  State<DetallesCard> createState() => _DetallesCardState();
}

class _DetallesCardState extends State<DetallesCard> {
  List<ProductIncidencia> listProduct = [];
  int totalUnits = 0;
  int totalCosts = 0;
  calcular() {
    totalUnits = 0;
    totalCosts = 0;
    int multiplo = 0;
    for (var element in listProduct) {
      multiplo =
          int.parse(element.cant ?? '0') * int.parse(element.cost ?? '0');
      totalCosts += multiplo;
      totalUnits += int.parse(element.cost ?? '0');
    }
    // print('Ya se calculo');
    // widget.calcularTotal(totalUnits, totalCosts);
  }

  Future getDataProductItem() async {
    final res = await httpRequestDatabase(selectProductCostInsidencia,
        {'id_key': widget.current.idKeyImage.toString()});
    // print('product : ${res.body}');
    listProduct = productIncidenciaFromJson(res.body);
    calcular();
    if (listProduct.isNotEmpty) {
      if (mounted) {
        setState(() {});
      }
    }
  }

  List listImagenLocal = [];
  List<String> listImagenUrl = [];
  @override
  void initState() {
    super.initState();
    getDataProductItem();
    getImage();
  }

  String urlImage =
      "http://$ipLocal/settingmat/admin/imagen_incidencia_sublimacion/";

  Future getImage() async {
    final res = await httpRequestDatabase(selectImagePathFileIncidencia,
        {'id_key_image': widget.current.idKeyImage});
    listImagenLocal = json.decode(res.body) as List;
    if (listImagenLocal.isNotEmpty) {
      for (var element in listImagenLocal) {
        listImagenUrl.add("$urlImage${element['image_path']}");
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> pasos = widget.current.whatcause.toString().split(", ");

    List<TableRow> rows = [];

    for (int i = 0; i < pasos.length; i++) {
      rows.add(
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  (i + 1).toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  pasos[i].trim(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detalles de la Incidencia')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: SizedBox(
                child: Stack(
                  children: [
                    Positioned(
                      right: 20,
                      top: 20,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset(
                          widget.current.isFinished == 'f'
                              ? 'assets/not_verified.png'
                              : 'assets/verified.png',
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Logo : ${widget.current.logo} ",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(
                                "Detalles de la orden : ${widget.current.numOrden}",
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                "Ficha :  ${widget.current.ficha}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        listImagenLocal.isEmpty
                            ? SizedBox(
                                height: 180,
                                width: MediaQuery.of(context).size.width * 0.80,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Text("Cargardo imagen ...")],
                                ))
                            : SizedBox(
                                height: 180,
                                width: MediaQuery.of(context).size.width * 0.80,
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: listImagenLocal
                                        .map(
                                          (e) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25),
                                            child: SizedBox(
                                              height: 150,
                                              width: 150,
                                              child: SizedBox(
                                                height: 150,
                                                width: 150,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Image.network(
                                                      '$urlImage${e['image_path']}',
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                        const Divider(),
                        ListTile(
                          title: Row(
                            children: [
                              Text("Departamento: ${widget.current.depart}"),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Fecha creación : ${widget.current.date} 🕔"),
                              Text(
                                "Fecha Solución : ${widget.current.dateCurrent} 🕔",
                                style: const TextStyle(color: colorsGreenLevel),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title: Text("Queja: ${widget.current.queja}"),
                          subtitle:
                              Text("Causa: 📣 ${widget.current.whatcause} 📣"),
                        ),
                        const Divider(),
                        Container(
                          height: 200,
                          padding: const EdgeInsets.all(16.0),
                          child: ListView(
                            children: [
                              Table(
                                border: TableBorder.all(),
                                children: [
                                  TableRow(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                    ),
                                    children: const [
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Paso',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Por Que?',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ...rows,
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title:
                              const Text("Problemas ocurridos y responsables"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('❌ ${widget.current.whycause.toString()} ❌'),
                              Text(
                                "Responsable : 👉${widget.current.usersResponsed}👈",
                                style: const TextStyle(
                                  color: colorsPuppleOpaco,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text("Compromiso/Solución"),
                          subtitle: Text("✅ ${widget.current.solucionwhat} ✅"),
                        ),
                        const Divider(),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Productos',
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: 160,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: listProduct
                                    .map((item) => DatosCard(datos: item))
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Totales Unidades : $totalUnits',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 201, 195, 232)),
                            ),
                            Text(
                              'Totales Costos : $totalCosts',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorsBlueDeepHigh),
                            ),
                          ],
                        ),
                        const Divider(),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Acciones',
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              const SizedBox(
                                  width: 10), // Espacio entre botones
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    // currentUsers?.occupation ==
                                    //             OptionAdmin.master.name ||
                                    //         currentUsers?.occupation ==
                                    //             OptionAdmin.admin.name
                                    //     ? Navigator.push(
                                    //         context,
                                    //         MaterialPageRoute(
                                    //           builder: (context) =>
                                    //               EdittingIncidencia(
                                    //                   current:
                                    //                       widget.current,
                                    //                   listProduct:
                                    //                       listProduct),
                                    //         ),
                                    //       )
                                    //     : () {};
                                  },
                                  child: const Text(
                                    'Detalles',
                                    style: TextStyle(
                                        fontSize: 16, // Tamaño del texto
                                        fontWeight: FontWeight.bold, // Negrita
                                        color: colorsBlueDeepHigh),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Espacio entre botones
                              //$urlImage${listImagenLocal.first['image_path']}
                              Expanded(
                                child: TextButton(
                                  onPressed: () async {
                                    final pdfFile =
                                        await PdfDetallesCard.generate(
                                            widget.current,
                                            listProduct,
                                            listImagenUrl);
                                    PdfApi.openFile(pdfFile);
                                  },
                                  child: const Text('Imprimir'),
                                ),
                              ), // Espacio entre botones
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            identy(context)
          ],
        ),
      ),
    );
  }
}

class DatosCard extends StatelessWidget {
  final ProductIncidencia datos;

  const DatosCard({super.key, required this.datos});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('ID: ${datos.id}'),
            // const SizedBox(height: 8),
            // Text('ID Key: ${datos.idKey}'),
            const SizedBox(height: 8),
            Text('Producto: ${datos.product}'),
            const SizedBox(height: 8),
            Text('Cantidad: ${datos.cant}'),
            const SizedBox(height: 8),
            Text(
              'Costo: \$${datos.cost}',
              style: const TextStyle(color: colorsPuppleOpaco),
            ),
            const SizedBox(height: 8),
            Text('Fecha: ${datos.date}'),
          ],
        ),
      ),
    );
  }
}
