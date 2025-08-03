import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/src/datebase/current_data.dart';
import '/src/util/commo_pallete.dart';
import '../../../datebase/methond.dart';
import '../../../datebase/url.dart';
import '../../../screen_print_pdf/apis/pdf_api.dart';
import '../../../util/get_formatted_number.dart';
import '../../../util/helper.dart';
import '../../../widgets/picked_date_widget.dart';
import '../model/report.dart';
import '../model/report_bordado_tirada.dart';
import '../print_bordado/print_bordado_resumen.dart';
import 'view_detalles_producion.dart';

class ResumenStaticordado extends StatefulWidget {
  const ResumenStaticordado({super.key});

  @override
  State<ResumenStaticordado> createState() => _ResumenStaticordadoState();
}

class _ResumenStaticordadoState extends State<ResumenStaticordado> {
  List<BordadoReportTiradas> listReported = [];
  List<BordadoReportTiradas> listTiradas = [];
  List<BordadoReportTiradas> listByMachine = [];
  List<BordadoReportTiradas> listReportedFilter = [];
  String? firstDate = DateTime.now().toString().substring(0, 10);
  String? secondDate = DateTime.now().toString().substring(0, 10);

  bool isLoadingResumen = false;

  Future getbyResumen() async {
    setState(() {
      listReported.clear();
    });
    String url =
        "http://$ipLocal/settingmat/admin/select/select_bordado_tiradas_resumen.php";
    final fecha = {'date1': firstDate, 'date2': secondDate};
    final res = await httpRequestDatabase(url, fecha);
    listReported = bordadoReportTiradasFromJson(res.body);
    listReportedFilter = listReported;
    if (listReportedFilter.isNotEmpty) {
      setState(() {});
      // debugPrint('Buscando reporte .... Listo');
    }
    if (listReported.isNotEmpty) {
      getByMachineResumen();
      getResumenPiezas();
      loadPuntadas();
    }
  }

  Future getByMachineResumen() async {
    String url =
        "http://$ipLocal/settingmat/admin/select/select_bordado_tiradas_resumen_by_machine.php";
    final fecha = {'date1': firstDate, 'date2': secondDate};

    final res = await httpRequestDatabase(url, fecha);
    setState(() {
      listByMachine = bordadoReportTiradasFromJson(res.body);
    });
  }

  Future getTiradas() async {
    listTiradas.clear();
    String url =
        "http://$ipLocal/settingmat/admin/select/select_bordado_tiradas.php";
    final res = await httpRequestDatabase(
        url, {'date1': '$firstDate 00:00:00', 'date2': '$secondDate 23:59:59'});
    listTiradas = bordadoReportTiradasFromJson(res.body);
    if (listTiradas.isNotEmpty) {
      getbyResumen();
    }
  }

  @override
  void initState() {
    getTiradas();
    super.initState();
  }

  void searchingItem(String? data) {
    setState(() {
      listReportedFilter = listReported
          .where((element) =>
              element.fullName!.toUpperCase() == data!.toUpperCase())
          .toList();
      // getResumenOther();
    });
  }

  void searchingMaquina(String? data) {
    setState(() {
      listReportedFilter = listReported
          .where((element) =>
              element.machine!.toUpperCase() == data!.toUpperCase())
          .toList();
      // getResumenOther();
    });
  }

  void normalizarListItem() {
    setState(() {
      listReportedFilter = listReported;
      // getResumenOther();
    });
  }

  Map<String, dynamic> data = {};
  Map<dynamic, dynamic> datosResumen = {};

  Map<dynamic, dynamic> datosResumenPuntada = {};
  Report? report;

  Report? reportPuntada;

  Future getResumenPiezas() async {
    datosResumen = {};
    var machineList =
        BordadoReportTiradas.depurarObjectsMachine(listReportedFilter);
    var empleadoList =
        BordadoReportTiradas.depurarObjectsFullName(listReportedFilter);
    for (var ruta in empleadoList) {
      datosResumen[ruta] = {}; // Inicializa un mapa vacío para cada ruta
      int totalGlobal = 0;
      for (var origen in machineList) {
        var cant = listReportedFilter
            .where((element) =>
                element.machine?.toUpperCase() == origen.toUpperCase() &&
                element.fullName?.toUpperCase() == ruta.toUpperCase())
            .toList();

        int totalPieza = BordadoReportTiradas.calcularTotalPieza(cant);
        totalGlobal += totalPieza;

        datosResumen[ruta][origen] = '$totalPieza';
      }
      datosResumen[ruta]['total'] = totalGlobal.toString();
    }

    ////---------------------divice --------------------------////////
    final Map<String, String> totalGenera = {};
    datosResumen.forEach((key, value) {
      value.forEach((keyLo, val) {
        final totalPieza = listReported
            .where((element) =>
                element.machine?.toUpperCase() == keyLo.toUpperCase())
            .toList()
            .fold<int>(
                0,
                (previousValue, element) =>
                    previousValue + int.parse(element.cantElabored ?? '0'));
        totalGenera[keyLo] = '$totalPieza';
        // print('totalGenera  :$totalGenera');
      });
    });
    datosResumen['Total General'] =
        totalGenera.map((key, value) => MapEntry(key, value.toString()));
    //  await Future.delayed(const Duration(seconds: 2));
    setState(() {
      report = Report.fromJson(datosResumen);
      // print('json -------------Hello------------ : ${report.toJson()}');
    });
  }

  loadPuntadas() {
    datosResumenPuntada = {};
    var machineList =
        BordadoReportTiradas.depurarObjectsMachine(listReportedFilter);
    var empleadoList =
        BordadoReportTiradas.depurarObjectsFullName(listReportedFilter);
    for (var ruta in empleadoList) {
      datosResumenPuntada[ruta] = {}; // Inicializa un mapa vacío para cada ruta
      int totalGlobal = 0;
      for (var origen in machineList) {
        var cant = listReportedFilter
            .where((element) =>
                element.machine?.toUpperCase() == origen.toUpperCase() &&
                element.fullName?.toUpperCase() == ruta.toUpperCase())
            .toList();

        int totalPieza = BordadoReportTiradas.calcularTotalPuntada(cant);
        totalGlobal += totalPieza;

        datosResumenPuntada[ruta][origen] = '$totalPieza';
      }
      datosResumenPuntada[ruta]['total'] = totalGlobal.toString();
    }
    ////---------------------divice --------------------------////////
    final Map<String, String> totalGenera = {};
    datosResumenPuntada.forEach((key, value) {
      value.forEach((keyLo, val) {
        final totalPieza = listReported
            .where((element) =>
                element.machine?.toUpperCase() == keyLo.toUpperCase())
            .toList()
            .fold<int>(
                0,
                (previousValue, element) =>
                    previousValue + int.parse(element.puntada ?? '0'));
        totalGenera[keyLo] = '$totalPieza';
        // print('totalGenera  :$totalGenera');
      });
    });
    datosResumenPuntada['Total General'] =
        totalGenera.map((key, value) => MapEntry(key, value.toString()));

    setState(() {
      reportPuntada = Report.fromJson(datosResumenPuntada);
      // print('json -------------Hello------------ : ${report.toJson()}');
    });
  }

  // ScreenshotController screenshotControllerLineal = ScreenshotController();
  void captureAndSaveScreen(BuildContext context) async {
    try {
      // Capturar la pantalla
      // screenshotController.capture().then((Uint8List? image1) {
      //   if (image1 != null) {
      //     screenshotController2.capture().then((Uint8List? image2) {
      //       if (image2 != null) {
      //         // Guardar la captura en el almacenamiento local del dispositivo.
      //         saveScreenshotToLocalFile(image1, nameFile: 'Imagen_1')
      //             .then((path) async {
      //           // Guardar la captura en el almacenamiento local del dispositivo.
      //           saveScreenshotToLocalFile(image2, nameFile: 'Imagen_2')
      //               .then((path2) async {
      //             final pdfFile = await PrintBordadoResumen.generate(
      //                 path, path2, '$firstDate - $secondDate');
      //             PdfApi.openFile(pdfFile);
      //             // La captura se ha guardado en el 'path' especificado.
      //             // print('Captura guardada en: $path');
      //           }).catchError((error) {
      //             // Ocurrió un error al guardar la captura.
      //             // print('Error al guardar la captura de pantalla: $error');
      //           }); // La captura se ha guardado en el 'path' especificado.
      //           // print('Captura guardada en: $path');
      //         }).catchError((error) {
      //           // Ocurrió un error al guardar la captura.
      //           // print('Error al guardar la captura de pantalla: $error');
      //         });
      //       } else {
      //         // Ocurrió un error al capturar la pantalla.
      //         // print('Error al capturar la pantalla.');
      //       }
      //     }).catchError((onError) {
      //       // print(onError);
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

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: listReported.isEmpty ? Colors.white : null,
      appBar: AppBar(
        title: const Text('Resumen Bordado General'),
        actions: [
          listReportedFilter.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                      onPressed: () => captureAndSaveScreen(context),
                      icon: const Icon(Icons.print)),
                )
              : const SizedBox(),
          Tooltip(
              message: 'Seleccionar Fecha',
              child: Container(
                  margin: const EdgeInsets.only(right: 25),
                  child: IconButton(
                      icon:
                          const Icon(Icons.calendar_month, color: Colors.black),
                      onPressed: () {
                        selectDateRange(context, (date1, date2) {
                          firstDate = date1;
                          secondDate = date2;
                          setState(() {
                            listReported.clear();
                            listTiradas.clear();
                            listByMachine.clear();
                            listReportedFilter.clear();
                          });
                          getTiradas();
                        });
                      }))),
        ],
      ),
      body: listReported.isNotEmpty
          ? Column(
              children: [
                const SizedBox(width: double.infinity, height: 15),
                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('Reportes de Piezas', style: style.labelLarge)),
                listReported.isNotEmpty
                    ? SizedBox(
                        child: ReportFinalWidget(
                            reportedFinal: report!,
                            listTiradas: listTiradas,
                            fecha: '$firstDate - $secondDate'),
                      )
                    : const SizedBox(),
                const Divider(endIndent: 50, indent: 50),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Text('Reportes de Puntadas', style: style.labelLarge)),
                listReported.isNotEmpty
                    ? SizedBox(
                        child: ReportFinalWidget(
                            reportedFinal: reportPuntada!,
                            isPuntada: true,
                            listTiradas: listTiradas,
                            fecha: '$firstDate - $secondDate'),
                      )
                    : const SizedBox(),
                listReported.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 10),
                        child: SizedBox(
                          height: 40,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 35,
                                  color: Colors.white,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'PIEZAS : ${BordadoReportTiradas.calcularTotalPieza(listReportedFilter)}',
                                    style: style.bodySmall
                                        ?.copyWith(color: Colors.green),
                                  ),
                                ),

                                Container(
                                  height: 35,
                                  color: Colors.white,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'PIEZAS MALA : ${BordadoReportTiradas.calcularTotalMala(listReportedFilter)}',
                                    style: style.bodySmall
                                        ?.copyWith(color: Colors.red),
                                  ),
                                ),

                                // var cantPuntada = BordadoResumen.calcularTotalPuntada(items);
                                Container(
                                  height: 35,
                                  color: Colors.white,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  alignment: Alignment.center,
                                  child: Text(
                                      'PUNTADAS : ${getNumFormatedDouble('${BordadoReportTiradas.calcularTotalPuntada(listReportedFilter)}')}',
                                      style: style.bodySmall?.copyWith()),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                identy(context)
              ],
            )
          : Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/buscar.gif',
                        fit: BoxFit.contain, scale: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                          'No hay Estadistica para la fecha seleccionado, click! en el botón calendario para buscar otras fechas disponibles.',
                          textAlign: TextAlign.center,
                          style: style.titleMedium
                              ?.copyWith(color: colorsBlueTurquesa)),
                    ),
                    identy(context)
                  ],
                ),
              ),
            ),
    );
  }
}

class ReportFinalWidget extends StatefulWidget {
  const ReportFinalWidget(
      {super.key,
      required this.reportedFinal,
      this.isPuntada = false,
      this.listTiradas,
      required this.fecha});
  final Report reportedFinal;
  final bool? isPuntada;
  final List<BordadoReportTiradas>? listTiradas;
  final String? fecha;

  @override
  State<ReportFinalWidget> createState() => _ReportFinalWidgetState();
}

class _ReportFinalWidgetState extends State<ReportFinalWidget> {
  show(String value, String machine, {bool? istotal = false}) async {
    if (value == 'Total General') {
      return;
    }
    // print('value : $value  ---- machine : $machine');

    List<BordadoReportTiradas>? localListTiradas = [];
    if (istotal!) {
      localListTiradas = widget.listTiradas
          ?.where((element) =>
              element.fullName?.toUpperCase() == value.toUpperCase())
          .toList();
    } else {
      localListTiradas = widget.listTiradas
          ?.where((element) =>
              element.fullName?.toUpperCase() == value.toUpperCase() &&
              element.machine?.toUpperCase() == machine.toUpperCase())
          .toList();
    }
    await showDialog(
        context: context,
        builder: (context) {
          return GraficsAvgByDayResumenGlobal(
              listTiradas: localListTiradas, fecha: widget.fecha);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: DataTable(
          dataRowMaxHeight: 20,
          dataRowMinHeight: 17,
          horizontalMargin: 10.0,
          headingRowHeight: 20,
          dataRowColor:
              MaterialStateColor.resolveWith((states) => Colors.white38),
          headingRowColor: MaterialStateColor.resolveWith((states) =>
              widget.isPuntada!
                  ? Colors.orange.shade100
                  : Colors.blue.shade100),
          columns: const <DataColumn>[
            DataColumn(label: Text('Empleado')),
            DataColumn(label: Text('TAJIMA -12')),
            DataColumn(label: Text('BARUDAN -1')),
            DataColumn(label: Text('BARUDAN -6')),
            DataColumn(label: Text('TAJIMA -6-A')),
            DataColumn(label: Text('TAJIMA -1')),
            DataColumn(label: Text('Total')),
          ],
          rows: widget.reportedFinal.data.entries.map((entry) {
            final key = entry.key;
            final value = entry.value;
            return DataRow(
              cells: <DataCell>[
                DataCell(Text(key)),
                DataCell(Text(getNumFormatedDouble(value['TAJIMA -12'] ?? '0')),
                    onTap: () => show(key, 'TAJIMA -12')),
                DataCell(Text(getNumFormatedDouble(value['BARUDAN -1'] ?? '0')),
                    onTap: () => show(key, 'BARUDAN -1')),
                DataCell(Text(getNumFormatedDouble(value['BARUDAN -6'] ?? '0')),
                    onTap: () => show(key, 'BARUDAN -6')),
                DataCell(
                    Text(getNumFormatedDouble(value['TAJIMA -6-A'] ?? '0')),
                    onTap: () => show(key, 'TAJIMA -6-A')),
                DataCell(Text(getNumFormatedDouble(value['TAJIMA -1'] ?? '0')),
                    onTap: () => show(key, 'TAJIMA -1')),
                DataCell(Text(getNumFormatedDouble(value['total'] ?? '0')),
                    onTap: () => show(key, 'N/A', istotal: true))
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
