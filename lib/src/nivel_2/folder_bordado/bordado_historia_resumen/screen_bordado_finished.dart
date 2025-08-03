import 'package:flutter/material.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/model/department.dart';
import '/src/nivel_2/folder_bordado/model/bordado_report.dart';
import '/src/nivel_2/folder_bordado/bordado_tiradas_item/segumiento_tirada.dart';
import '/src/nivel_2/folder_bordado/database_bordado/url_bordado.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/font_style.dart';
import '/src/util/show_mesenger.dart';
import '/src/widgets/loading.dart';
import '../../../datebase/url.dart';
import '../../../util/dialog_confimarcion.dart';
import '../../../util/get_formatted_number.dart';
import '../../../util/helper.dart';

class ScreenBordadoFinished extends StatefulWidget {
  const ScreenBordadoFinished({super.key, this.current});
  final Department? current;

  @override
  State<ScreenBordadoFinished> createState() => _ScreenBordadoFinishedState();
}

class _ScreenBordadoFinishedState extends State<ScreenBordadoFinished> {
  List<BordadoReport> listReported = [];
  List<BordadoReport> listReportedFilter = [];

  List<BordadoReport> listTiradaTotal = [];
  bool isloading = true;
  String? firstDate = DateTime.now().toString().substring(0, 10);
  String? secondDate = DateTime.now().toString().substring(0, 10);
  @override
  void initState() {
    super.initState();
    getTiradasTotalActual();
    getProducionCurrently();
  }

  Future getProducionCurrently() async {
    //t = Terminados
    //f = Activos
    setState(() {
      listReportedFilter.clear();
    });
    String url =
        "http://$ipLocal/settingmat/admin/select/select_bordado_reported_terminados.php";
    final res = await httpRequestDatabase(
        url, {'date1': firstDate, 'date2': secondDate, 'is_finished': 't'});
    listReported = bordadoReportFromJson(res.body);
    listReportedFilter = listReported;
    if (mounted) {
      if (mounted) {
        setState(() {
          isloading = false;
        });
      }
    }
  }

  Future getTiradasTotalActual() async {
    String url =
        "http://$ipLocal/settingmat/admin/select/select_bordado_tirada_total_actual_by_date.php";
    final res = await httpRequestDatabase(
        url, {'date1': firstDate, 'date2': secondDate, 'is_finished': 't'});
    setState(() {
      listTiradaTotal = bordadoReportFromJson(res.body);
    });
  }

///////este eliminar los item de una orden completa///
  Future eliminarBordadoReport(id) async {
    if (validarSupervisor()) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConfirmacionDialog(
            mensaje: '❌❌Esta Seguro de Eliminar❌❌',
            titulo: 'Aviso',
            onConfirmar: () async {
              Navigator.of(context).pop();
              await httpRequestDatabase(
                  deleteBordadoReportedGeneral, {'id': '$id'});
              listReportedFilter.removeWhere((item) => item.id == id);
              getProducionCurrently();
            },
          );
        },
      );
    }
  }

  // ScreenshotController screenshotController = ScreenshotController();
  // ScreenshotController screenshotControllerLineal = ScreenshotController();
  void captureAndSaveScreen(BuildContext context, list) async {
    try {
      // Capturar la pantalla
      // screenshotController.capture().then((Uint8List? image) {
      //   if (image != null) {
      //     // Guardar la captura en el almacenamiento local del dispositivo.
      //     saveScreenshotToLocalFile(image).then((path) async {
      //       final pdfFile =
      //           await PrintMainBordadoTerminado.generate(path, list);
      //       PdfApi.openFile(pdfFile);
      //       // La captura se ha guardado en el 'path' especificado.
      //       // print('Captura guardada en: $path');
      //     }).catchError((error) {
      //       // Ocurrió un error al guardar la captura.
      //       // print('Error al guardar la captura de pantalla: $error');
      //     });
      //   } else {
      //     // Ocurrió un error al capturar la pantalla.
      //     // print('Error al capturar la pantalla.');
      //   }
      // }).catchError((onError) {
      //   // print(onError);
      // });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void normalize() {
    setState(() {
      listReportedFilter = listReported;
    });
  }

  void searchingbyFullname(String val) {
    setState(() {
      listReportedFilter = listReported
          .where(
              (element) => element.fullName?.toUpperCase() == val.toUpperCase())
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final sized = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: sized.height < 600 ? Colors.white : null,
        appBar: AppBar(
          title: const Text('Bordado Terminados'),
          actions: [
            listReportedFilter.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                        onPressed: () =>
                            captureAndSaveScreen(context, listReportedFilter),
                        icon: const Icon(Icons.print)),
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Tooltip(
                message: 'Seleccionar Fecha',
                child: Container(
                  margin: const EdgeInsets.only(right: 1),
                  child: IconButton(
                    icon: const Icon(Icons.calendar_month, color: Colors.black),
                    onPressed: () {
                      selectDateRange(context, (date1, date2) {
                        firstDate = date1;
                        secondDate = date2;
                        getTiradasTotalActual();
                        getProducionCurrently();
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        body: isloading
            ? const Loading(text: 'Buscando Trabajos Terminados')
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(width: double.infinity),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Trabajos Terminados',
                            style: style.headlineSmall?.copyWith(
                                letterSpacing: 1,
                                color: ktejidogrey,
                                fontWeight: FontWeight.w600,
                                fontFamily: fontTenali))),
                    listReportedFilter.isNotEmpty
                        ? SizedBox(
                            height: 250,
                            child: TableModifica(
                              pressReload: () {
                                getTiradasTotalActual();
                                getProducionCurrently();
                              },
                              current: listReportedFilter,
                              pressDelete: (id) => eliminarBordadoReport(id),
                            ),
                          )
                        : const Center(child: Text('No hay Trabajo Actuales')),
                    listReportedFilter.isEmpty
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Container(
                              width: 250,
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Resumen Terminados',
                                        style: style.labelLarge?.copyWith(
                                            letterSpacing: 3,
                                            color: ktejidogrey,
                                            fontFamily: fontBalooPaaji)),
                                  ),
                                  Container(
                                    color: colorsGreyWhite,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(6),
                                    child: Text(
                                        '${BordadoReport.calcularPorcentaje(BordadoReport.calcularTotalPieza(listReportedFilter).toString(), BordadoReport.calcularQTYOrden(listReportedFilter).toString()).toStringAsFixed(2)} %',
                                        style: style.titleMedium?.copyWith(
                                            color: ktejidoBlueOcuro,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Puntadas/Tiradas',
                                        style: style.labelMedium?.copyWith(
                                            letterSpacing: 2,
                                            color: colorsBlueTurquesa,
                                            fontFamily: fontBalooPaaji)),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Tiradas',
                                              style: style.bodySmall),
                                          Text('Puntadas',
                                              style: style.bodySmall),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        children: [
                                          Text(
                                              listTiradaTotal.length.toString(),
                                              style: style.bodySmall?.copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              getNumFormatedDouble(
                                                  BordadoReport.getPuntadas(
                                                          listTiradaTotal)
                                                      .toString()),
                                              style: style.bodySmall?.copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Puntadas Por Piezas',
                                        style: style.labelMedium?.copyWith(
                                            letterSpacing: 2,
                                            color: ktejidogrey,
                                            fontFamily: fontBalooPaaji)),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Puntadas Global',
                                              style: style.bodySmall),
                                          Text('Puntadas Restantes',
                                              style: style.bodySmall),
                                          Text('Puntadas Restantes',
                                              style: style.bodySmall),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        children: [
                                          Text(
                                              getNumFormatedDouble(BordadoReport
                                                      .calcularTotalPuntada(
                                                          listReportedFilter)
                                                  .toString()),
                                              style: style.bodySmall?.copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              getNumFormatedDouble(BordadoReport
                                                      .calcularTotalPuntadaRealizadas(
                                                          listReportedFilter)
                                                  .toString()),
                                              style: style.bodySmall?.copyWith(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              getNumFormatedDouble(BordadoReport.restar(
                                                      BordadoReport
                                                              .calcularTotalPuntada(
                                                                  listReportedFilter)
                                                          .toString(),
                                                      BordadoReport
                                                              .calcularTotalPuntadaRealizadas(
                                                                  listReportedFilter)
                                                          .toString())
                                                  .toString()),
                                              style: style.bodySmall?.copyWith(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                    listReportedFilter.isNotEmpty
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
                                      decoration: const BoxDecoration(
                                          color: Colors.white),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text('Items : ',
                                                  style: style.bodySmall),
                                              const SizedBox(width: 10),
                                              Text(
                                                  listReportedFilter.length
                                                      .toString(),
                                                  style: style.bodySmall
                                                      ?.copyWith(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      height: 35,
                                      decoration: const BoxDecoration(
                                          color: Colors.white),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text('QTY # Orden : ',
                                                  style: style.bodySmall),
                                              const SizedBox(width: 10),
                                              Text(
                                                  BordadoReport.calcularQTYOrden(
                                                          listReportedFilter)
                                                      .toString(),
                                                  style: style.bodySmall
                                                      ?.copyWith(
                                                          color: Colors.brown,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      height: 35,
                                      decoration: const BoxDecoration(
                                          color: Colors.white),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text('QTY Realizadas : ',
                                                  style: style.bodySmall),
                                              const SizedBox(width: 10),
                                              Text(
                                                  BordadoReport
                                                          .calcularTotalPieza(
                                                              listReportedFilter)
                                                      .toString(),
                                                  style: style.bodySmall
                                                      ?.copyWith(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      height: 35,
                                      decoration: const BoxDecoration(
                                          color: Colors.white),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text('QTY Defectuosas : ',
                                                  style: style.bodySmall),
                                              const SizedBox(width: 10),
                                              Text(
                                                  BordadoReport
                                                          .calcularTotalMala(
                                                              listReportedFilter)
                                                      .toString(),
                                                  style: style.bodySmall
                                                      ?.copyWith(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold)),
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
              ));
  }
}

class TableModifica extends StatelessWidget {
  const TableModifica(
      {super.key,
      this.current,
      required this.pressDelete,
      required this.pressReload});
  final List<BordadoReport>? current;
  final Function pressDelete;
  final Function pressReload;

  Color getColor(BordadoReport report) {
    if (report.isPause == 't') {
      return Colors.red.shade100;
    }

    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: SizedBox(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(5),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: DataTable(
              dataRowMaxHeight: 20,
              dataRowMinHeight: 15,
              horizontalMargin: 10.0,
              columnSpacing: 15,
              headingRowHeight: 20,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 205, 208, 221),
                    Color.fromARGB(255, 225, 228, 241),
                    Color.fromARGB(255, 233, 234, 238),
                  ],
                ),
              ),
              border: TableBorder.symmetric(
                  inside: const BorderSide(
                      style: BorderStyle.solid, color: Colors.grey)),
              columns: const [
                DataColumn(label: Text('Tiradas')),
                DataColumn(label: Text('Registros')),
                DataColumn(label: Text('# Ordenes')),
                DataColumn(label: Text('Fichas')),
                DataColumn(label: Text('Logo')),
                DataColumn(label: Text('QTY # Orden')),
                DataColumn(label: Text('QTY Realizadas')),
                DataColumn(label: Text('QTY Defectuosas')),
                DataColumn(label: Text('Puntadas por Pieza')),
                DataColumn(label: Text('Fecha Inicios')),
                DataColumn(label: Text('Fecha Final')),
                DataColumn(label: Text('Maquinas')),
                DataColumn(label: Text('Puntada/Vel.')),
                DataColumn(label: Text('Comentarios')),
                DataColumn(label: Text('Actiones')),
              ],
              rows: current!
                  .map(
                    (item) => DataRow(
                      color: MaterialStateProperty.resolveWith(
                          (states) => Colors.green.shade100),
                      cells: [
                        DataCell(
                            const Text(
                              'Click!',
                              style: TextStyle(
                                  color: ktejidoBlueOcuro,
                                  fontWeight: FontWeight.bold),
                            ), onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (conext) =>
                                      SeguimientoTiradaBordado(item: item)));
                        }),
                        DataCell(
                            SizedBox(
                              width: 100,
                              child: Text(item.fullName ?? '',
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis)),
                            ), onTap: () {
                          utilShowMesenger(context, item.fullName ?? '',
                              title: 'Empleado Registro');
                        }),
                        DataCell(Row(
                          children: [Text(item.numOrden ?? '')],
                        )),
                        DataCell(Text(item.ficha ?? '')),
                        DataCell(
                            SizedBox(
                              width: 100,
                              child: Text(item.nameLogo ?? '',
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis)),
                            ), onTap: () {
                          utilShowMesenger(context, item.nameLogo ?? '',
                              title: 'LOGO');
                        }),
                        DataCell(Text(item.cantOrden ?? '')),
                        DataCell(Text(item.cantElabored ?? '',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text(item.cantBad ?? '')),
                        DataCell(Center(
                          child: Text(
                              getNumFormatedDouble(
                                  BordadoReport.calcularPuntadaPorPieza(item)
                                      .toString()),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ktejidoBlueOcuro.withOpacity(0.8),
                              )),
                        )),
                        DataCell(Text(item.fechaGeneralStarted ?? '')),
                        DataCell(Text(item.fechaGeneralEnd ?? '')),
                        DataCell(Text(item.machine ?? '')),
                        DataCell(Row(children: [
                          Text(item.puntada ?? ''),
                          const Text('--'),
                          Text(item.veloz ?? '')
                        ])),
                        DataCell(
                            SizedBox(
                              width: 50,
                              child: Text(item.comment ?? ''),
                            ), onTap: () {
                          utilShowMesenger(context, item.comment ?? '',
                              title: 'Comentarios');
                        }),
                        DataCell(
                            Text(
                                validarSupervisor() ? 'ELIMINAR' : 'No Suport'),
                            onTap: () => pressDelete(item.id)),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
