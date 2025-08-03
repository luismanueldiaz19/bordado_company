import 'package:flutter/material.dart';
import '/src/datebase/methond.dart';
import '/src/util/commo_pallete.dart';

import '../../../datebase/current_data.dart';
import '../../../datebase/url.dart';
import '../../../screen_print_pdf/apis/pdf_api.dart';
import '../../../util/get_time_relation.dart';
import '../../../util/show_mesenger.dart';
import '../../../widgets/loading.dart';
import '../../forder_sublimacion/model_nivel/sublima.dart';
import 'print_viewer_resumen.dart';

class MyWidgetViewerSerigrafiaResumen extends StatefulWidget {
  const MyWidgetViewerSerigrafiaResumen({super.key, required this.data});
  final Map<String, dynamic>? data;

  @override
  State<MyWidgetViewerSerigrafiaResumen> createState() =>
      _MyWidgetViewerSerigrafiaResumenState();
}

class _MyWidgetViewerSerigrafiaResumenState
    extends State<MyWidgetViewerSerigrafiaResumen> {
  List<Sublima> list = [];
  List<Sublima> listFilter = [];
  // Future<String> saveScreenshotToLocalFile(Uint8List image) async {
  //   var directory = await getTemporaryDirectory();
  //   File file = File('${directory.path}/screenshot.png');
  //   await file.writeAsBytes(image);
  //   return file.path;
  // }

  // Future eliminarBordadoReport(id) async {
  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return ConfirmacionDialog(
  //         mensaje: '❌ Esta Seguro de Eliminar ❌',
  //         titulo: 'Aviso',
  //         onConfirmar: () async {
  //           Navigator.of(context).pop();
  //           await httpRequestDatabase(
  //               deleteBordadoReportedGeneral, {'id': '$id'});
  //           widget.listTiradas!.removeWhere((item) => item.id == id);
  //         },
  //       );
  //     },
  //   );
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('inited : ${widget.data}');
    getInfor();
  }

  Future getInfor() async {
    String url =
        "http://$ipLocal/settingmat/admin/select/select_serigrafia_viewer.php";
    final res = await httpRequestDatabase(url, widget.data!);

    print('Body Request ${res.body}');
    list = sublimaFromJson(res.body);
    listFilter = list;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final sized = MediaQuery.of(context).size;
    final style = Theme.of(context).textTheme;
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Cerrar')),
        ),
        SizedBox(
          width: 150,
          child: ElevatedButton.icon(
              icon: const Icon(Icons.print, color: Colors.white, size: 16),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => colorsBlueTurquesa),
                shape: MaterialStateProperty.resolveWith(
                  (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              onPressed: () async {
                // PrintViewerResumen
                final pdfFile = await PrintViewerResumen.generate(
                  listFilter,
                );
                PdfApi.openFile(pdfFile);
              },
              label: const Text('Imprimir',
                  style: TextStyle(color: Colors.white))),
        ),
      ],
      title: Center(
          child: Text('Información',
              style: Theme.of(context).textTheme.bodyLarge)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: double.infinity),
          listFilter.isNotEmpty
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        child: DataTable(
                          dataRowMaxHeight: 20,
                          dataRowMinHeight: 15,
                          headingRowColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.blue.shade100),
                          headingRowHeight: 20,
                          border: TableBorder.symmetric(
                              inside: const BorderSide(color: Colors.grey)),
                          headingTextStyle: style.labelLarge,
                          dataTextStyle: style.bodyMedium,
                          columns: const [
                            DataColumn(label: Text('Trabajos')),
                            DataColumn(label: Text('Empleado')),
                            DataColumn(label: Text('#Orden / Fichas')),
                            DataColumn(label: Text('Logo')),
                            DataColumn(label: Text('Cant Orden')),
                            DataColumn(label: Text('Elaborado')),
                            DataColumn(label: Text('Full')),
                            DataColumn(label: Text('PKT')),
                            DataColumn(label: Text('C.Full')),
                            DataColumn(label: Text('C.PKT')),
                            DataColumn(label: Text('Started')),
                            DataColumn(label: Text('End')),
                            DataColumn(label: Text('Timer')),
                          ],
                          rows: listFilter
                              .map(
                                (item) => DataRow(
                                  color: MaterialStateProperty.resolveWith(
                                      (states) => Colors.white),
                                  cells: [
                                    DataCell(Text(item.typeWork ?? 'N/A')),
                                    DataCell(Text(item.fullName ?? 'N/A')),
                                    DataCell(Text(
                                        '${item.numOrden ?? ''} - ${item.ficha ?? ''}',
                                        textAlign: TextAlign.justify)),
                                    DataCell(
                                        Text(item.nameLogo ?? '',
                                            textAlign: TextAlign.center,
                                            maxLines: 1), onTap: () {
                                      utilShowMesenger(
                                          context, item.nameLogo ?? '',
                                          title: 'LOGO');
                                    }),
                                    DataCell(Center(
                                        child: Text(item.cantOrden ?? ''))),
                                    DataCell(Center(
                                        child: Text(item.cantPieza ?? '',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: ktejidoBlueOcuro)))),
                                    DataCell(Text(item.dFull ?? 'N/A')),
                                    DataCell(Text(item.pkt ?? 'N/A')),
                                    DataCell(Text(item.colorfull ?? 'N/A')),
                                    DataCell(Text(item.colorpkt ?? 'N/A')),
                                    DataCell(Text(item.dateStart ?? '')),
                                    DataCell(Text(item.dateEnd ?? '')),
                                    DataCell(Text(
                                        getTimeRelation(item.dateStart ?? 'N/A',
                                            item.dateEnd ?? 'N/A'),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: ktejidoBlueOcuro)))
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                )
              : const Expanded(
                  child: Loading(text: 'Buscando detalles ... espere.')),
          listFilter.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SizedBox(
                    height: 35,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            height: 35,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Piezas : ', style: style.bodySmall),
                                    const SizedBox(width: 10),
                                    Text(Sublima.getTotalRealizado(listFilter),
                                        style: style.bodySmall?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 35,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Pieza Full :',
                                        style: style.bodySmall),
                                    const SizedBox(width: 10),
                                    Text(Sublima.getTotalFull(listFilter),
                                        style: style.bodySmall?.copyWith(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 35,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Pieza PKT :', style: style.bodySmall),
                                    const SizedBox(width: 10),
                                    Text(Sublima.getTotalPKT(listFilter),
                                        style: style.bodySmall
                                            ?.copyWith(color: Colors.black)),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          identy(context)
        ],
      ),
    );
  }
}
