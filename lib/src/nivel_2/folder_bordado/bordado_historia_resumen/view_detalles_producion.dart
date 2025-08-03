import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

import '/src/datebase/current_data.dart';
import '/src/util/commo_pallete.dart';

import '../../../datebase/methond.dart';
import '../../../screen_print_pdf/apis/pdf_api.dart';
import '../../../util/dialog_confimarcion.dart';
import '../../../util/get_formatted_number.dart';
import '../../../util/get_time_relation.dart';
import '../../../util/show_mesenger.dart';
import '../../../widgets/loading.dart';
import '../model/report_bordado_tirada.dart';
import '../print_bordado/print_bordado_historial.dart';
import '../database_bordado/url_bordado.dart';

class GraficsAvgByDayResumenGlobal extends StatefulWidget {
  const GraficsAvgByDayResumenGlobal(
      {super.key, this.listTiradas, required this.fecha});
  final List<BordadoReportTiradas>? listTiradas;
  final String? fecha;

  @override
  State<GraficsAvgByDayResumenGlobal> createState() =>
      _GraficsAvgByDayResumenGlobalState();
}

class _GraficsAvgByDayResumenGlobalState
    extends State<GraficsAvgByDayResumenGlobal> {
  Future<String> saveScreenshotToLocalFile(Uint8List image) async {
    var directory = await getTemporaryDirectory();
    File file = File('${directory.path}/screenshot.png');
    await file.writeAsBytes(image);
    return file.path;
  }

  Future eliminarBordadoReport(id) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmacionDialog(
          mensaje: '❌ Esta Seguro de Eliminar ❌',
          titulo: 'Aviso',
          onConfirmar: () async {
            Navigator.of(context).pop();
            await httpRequestDatabase(
                deleteBordadoReportedGeneral, {'id': '$id'});
            widget.listTiradas!.removeWhere((item) => item.id == id);
          },
        );
      },
    );
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
                if (widget.listTiradas!.isNotEmpty) {
                  final pdfFile = await PrintBordadoHistorial.generate(
                      widget.listTiradas!,
                      'Fecha : ${widget.fecha}',
                      BordadoReportTiradas()
                          .getTotalElaborada(widget.listTiradas!),
                      BordadoReportTiradas.getTotalBad(widget.listTiradas!),
                      getNumFormatedDouble(
                          '${BordadoReportTiradas.calcularTotalPuntada(widget.listTiradas!)}'),
                      BordadoReportTiradas.getTimeR(widget.listTiradas!));
                  PdfApi.openFile(pdfFile);
                }
              },
              label: const Text('Imprimir',
                  style: TextStyle(color: Colors.white))),
        ),
      ],
      title: Center(
          child: Text('Información',
              style: Theme.of(context).textTheme.titleLarge)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: double.infinity),
          widget.listTiradas!.isNotEmpty
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
                            DataColumn(label: Text('Maquina')),
                            DataColumn(label: Text('Empleado')),
                            DataColumn(label: Text('#Orden / Fichas')),
                            DataColumn(label: Text('Logo')),
                            DataColumn(label: Text('Cant Orden')),
                            DataColumn(label: Text('Elaborado')),
                            DataColumn(label: Text('C.Malo')),
                            DataColumn(label: Text('Started')),
                            DataColumn(label: Text('End')),
                            DataColumn(label: Text('Timer')),
                            DataColumn(label: Text('Eliminar')),
                          ],
                          rows: widget.listTiradas!
                              .map(
                                (item) => DataRow(
                                  color: MaterialStateProperty.resolveWith(
                                      (states) =>
                                          BordadoReportTiradas.getColor(item)),
                                  cells: [
                                    DataCell(Text(item.machine ?? '')),
                                    DataCell(Text(item.fullName ?? 'N/A')),
                                    DataCell(Center(
                                      child: Text(
                                          '${item.numOrden ?? ''} - ${item.ficha ?? ''}'),
                                    )),

                                    DataCell(
                                        Text(
                                          item.nameLogo ?? '',
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                        ), onTap: () {
                                      utilShowMesenger(
                                          context, item.nameLogo ?? '',
                                          title: 'LOGO');
                                    }),
                                    DataCell(Center(
                                        child: Text(item.cantOrden ?? ''))),
                                    DataCell(Center(
                                        child: Text(item.cantElabored ?? ''))),
                                    DataCell(
                                      BordadoReportTiradas.getValidarMalos(item)
                                          ? Container(
                                              alignment: Alignment.center,
                                              // margin: EdgeInsets.all(2),
                                              // padding: EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  color: Colors.red),
                                              child: Text(item.cantBad ?? '0',
                                                  style: const TextStyle(
                                                      color: Colors.white)),
                                            )
                                          : Center(
                                              child: Text(item.cantBad ?? '0')),
                                    ),
                                    DataCell(Text(item.fechaStarted ?? '')),
                                    DataCell(Text(item.fechaEnd ?? '')),
                                    DataCell(Text(getTimeRelation(
                                        item.fechaStarted ?? 'N/A',
                                        item.fechaEnd ?? 'N/A'))),

                                    // DataCell(Row(
                                    //   children: [
                                    //     Text(item.puntada ?? ''),
                                    //     const Text('--'),
                                    //     Text(item.veloz ?? '')
                                    //   ],
                                    // )),
                                    // DataCell(
                                    //     SizedBox(
                                    //       width: 50,
                                    //       child: Text(item.comment ?? '',
                                    //           style: const TextStyle(
                                    //               overflow:
                                    //                   TextOverflow.ellipsis)),
                                    //     ), onTap: () {
                                    //   utilShowMesenger(
                                    //       context, item.comment ?? '',
                                    //       title: 'Comentarios');
                                    // }),
                                    DataCell(
                                        Text(validatorUser()
                                            ? 'Eliminar'
                                            : 'Not Support'),
                                        onTap: validatorUser()
                                            ? () =>
                                                eliminarBordadoReport(item.id)
                                            : null),
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
          widget.listTiradas!.isNotEmpty
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
                                    Text(
                                        BordadoReportTiradas()
                                            .getTotalElaborada(
                                                widget.listTiradas!),
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
                                    Text('Pieza Malas.',
                                        style: style.bodySmall),
                                    const SizedBox(width: 10),
                                    Text(
                                        BordadoReportTiradas.getTotalBad(
                                            widget.listTiradas!),
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
                                    Text('Puntada Genl :',
                                        style: style.bodySmall),
                                    const SizedBox(width: 10),
                                    Text(
                                        getNumFormatedDouble(
                                            BordadoReportTiradas
                                                    .calcularTotalPuntada(
                                                        widget.listTiradas!)
                                                .toString()),
                                        style: style.bodySmall
                                            ?.copyWith(color: Colors.black)),
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
                                    Text('Tiempo Genl:',
                                        style: style.bodySmall),
                                    const SizedBox(width: 10),
                                    Text(
                                        BordadoReportTiradas.getTimeR(
                                            widget.listTiradas!),
                                        style: style.bodySmall
                                            ?.copyWith(color: Colors.black)),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
