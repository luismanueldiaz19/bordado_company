import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/src/datebase/current_data.dart';
import '/src/model/department.dart';
import '/src/nivel_2/folder_bordado/bordado_orden_main/add_report_bordado.dart';
import '/src/nivel_2/folder_bordado/bordado_historia_resumen/resumen_static_bordado.dart';
import '/src/nivel_2/folder_bordado/model/bordado_report.dart';
import '/src/nivel_2/folder_bordado/bordado_historia_resumen/screen_bordado_finished.dart';
import '/src/nivel_2/folder_bordado/bordado_tiradas_item/segumiento_tirada.dart';
import '/src/nivel_2/folder_bordado/viejo_historial.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/font_style.dart';
import '/src/util/show_mesenger.dart';
import '../../../datebase/methond.dart';
import '../../../screen_print_pdf/apis/pdf_api.dart';
import '../../../util/dialog_confimarcion.dart';
import '../../../util/get_formatted_number.dart';
import '../../folder_reception/file_view_orden.dart';
import '../bordado_historia_resumen/searching_orden_bordado.dart';
import '../print_bordado/print_main_bordado.dart';
import '../provider/provider_bordado.dart';

class ScreenBordado extends StatefulWidget {
  const ScreenBordado({super.key, this.current});
  final Department? current;

  @override
  State<ScreenBordado> createState() => _ScreenBordadoState();
}

class _ScreenBordadoState extends State<ScreenBordado> {
  // List<BordadoReport> listReported = [];
  // List<BordadoReport> listTiradaTotal = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProvideBordado>(context, listen: false)
          .getProducionCurrently();
    });
  }

  ///select_bordado_tirada_total_actual

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
              Provider.of<ProvideBordado>(context, listen: false)
                  .eliminarBordadoReport(id);
            },
          );
        },
      );
    }
  }

  // ScreenshotController screenshotControllerLineal = ScreenshotController();
  void captureAndSaveScreen(BuildContext context, list) async {
    try {
      // Capturar la pantalla
      // screenshotController.capture().then((Uint8List? image) {
      //   if (image != null) {
      //     // Guardar la captura en el almacenamiento local del dispositivo.
      //     saveScreenshotToLocalFile(image).then((path) async {
      //       final pdfFile = await PrintMainBordado.generate(path, list);
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

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    // final sized = MediaQuery.of(context).size;
    final provider = Provider.of<ProvideBordado>(context, listen: true);

    return Scaffold(
        backgroundColor: provider.listReported.isEmpty ? Colors.white : null,
        appBar: AppBar(
          title: const Text('Bordado'),
          actions: [
            Tooltip(
              message: 'Historia Trabajos',
              child: Container(
                margin: const EdgeInsets.only(right: 15),
                child: IconButton(
                  icon: const Icon(Icons.calendar_month_outlined,
                      color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ViejoHistorial()),
                    );
                  },
                ),
              ),
            ),
            //ViejoHistorial
            Tooltip(
              message: 'Buscar Trabajo Realizado',
              child: Container(
                margin: const EdgeInsets.only(right: 15),
                child: IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchingOrdenBordado()),
                    );
                  },
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(right: 25),
                child: IconButton(
                    icon: const Icon(Icons.print),
                    onPressed: () =>
                        captureAndSaveScreen(context, provider.listReported))),
            // PopupMenuButton<String>(
            //   color: Colors.white,
            //   icon: Icon(Icons.adaptive.more, color: Colors.black),
            //   onSelected: (value) {
            //     if (value == 'trabajo') {
            //     } else if (value == 'maquina') {
            //       showDialog(
            //           context: context,
            //           builder: (_) {
            //             return const AddMachinesBordados();
            //           }).then((value) => {getProducionCurrently()});
            //     }
            //   },
            //   itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            //     const PopupMenuItem<String>(
            //       value: 'trabajo',
            //       child: Text('AGREGAR TRABAJOS',
            //           style: TextStyle(color: Colors.green)),
            //     ),
            //     const PopupMenuItem<String>(
            //       value: 'maquina',
            //       child: Text('AGREGAR MAQUINA',
            //           style: TextStyle(color: Colors.red)),
            //     ),
            //   ],
            // ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(width: double.infinity),
              provider.listReported.isEmpty
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Trabajos Activos',
                          style: style.headlineSmall?.copyWith(
                              letterSpacing: 1,
                              color: ktejidogrey,
                              fontWeight: FontWeight.w600,
                              fontFamily: fontTenali))),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Quiere ver los trabajos terminado?',
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ScreenBordadoFinished()),
                            );
                          },
                          child: const Text('Click Aqui!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: ktejidoblue)),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ResumenStaticordado()));
                            },
                            child: const Text('Resumen Aqui!',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: ktejidoBlueOcuro)))
                      ],
                    ),
                  ),
                ),
              ),
              provider.listReported.isNotEmpty
                  ? SizedBox(
                      height: 175,
                      child: TableModifica(
                        current: provider.listReported,
                        pressDelete: (id) => eliminarBordadoReport(id),
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/conocimiento.gif', scale: 4),
                        Text('No Encontramos Trabajos Activos !.',
                            style: style.labelMedium?.copyWith(fontSize: 16))
                      ],
                    ),
              provider.listReported.isEmpty
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        width: 250,
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Resumen Activo',
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
                                  '${BordadoReport.calcularPorcentaje(BordadoReport.calcularTotalPieza(provider.listReported).toString(), BordadoReport.calcularQTYOrden(provider.listReported).toString()).toStringAsFixed(2)} %',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Tiradas', style: style.bodySmall),
                                    Text('Puntadas', style: style.bodySmall),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  children: [
                                    Text(
                                        provider.listTiradaTotal.length
                                            .toString(),
                                        style: style.bodySmall?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        getNumFormatedDouble(
                                            BordadoReport.getPuntadas(
                                                    provider.listTiradaTotal)
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        getNumFormatedDouble(
                                            BordadoReport.calcularTotalPuntada(
                                                    provider.listReported)
                                                .toString()),
                                        style: style.bodySmall?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        getNumFormatedDouble(BordadoReport
                                                .calcularTotalPuntadaRealizadas(
                                                    provider.listReported)
                                            .toString()),
                                        style: style.bodySmall?.copyWith(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        getNumFormatedDouble(BordadoReport.restar(
                                                BordadoReport
                                                        .calcularTotalPuntada(
                                                            provider
                                                                .listReported)
                                                    .toString(),
                                                BordadoReport
                                                        .calcularTotalPuntadaRealizadas(
                                                            provider
                                                                .listReported)
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
              Padding(
                padding: const EdgeInsets.all(25),
                child: SizedBox(
                  width: 150,
                  child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return const AddReportBordado();
                            });
                      },
                      style: styleButton,
                      child: const Text('Agregar nuevo',
                          style: TextStyle(color: Colors.white))),
                ),
              ),
              provider.listReported.isNotEmpty
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
                                            provider.listReported.length
                                                .toString(),
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
                                                    provider.listReported)
                                                .toString(),
                                            style: style.bodySmall?.copyWith(
                                                color: Colors.brown,
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
                                            BordadoReport.calcularTotalPieza(
                                                    provider.listReported)
                                                .toString(),
                                            style: style.bodySmall?.copyWith(
                                                color: Colors.green,
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
                                            BordadoReport.calcularTotalMala(
                                                    provider.listReported)
                                                .toString(),
                                            style: style.bodySmall?.copyWith(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold)),
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
  const TableModifica({Key? key, this.current, required this.pressDelete})
      : super(key: key);
  final List<BordadoReport>? current;
  final Function pressDelete;

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
                DataColumn(label: Text('Maquinas')),
                DataColumn(label: Text('Puntada/Vel.')),
                DataColumn(label: Text('Comentarios')),
                DataColumn(label: Text('Actiones')),
              ],
              rows: current!
                  .map(
                    (item) => DataRow(
                      color: MaterialStateProperty.resolveWith(
                          (states) => getColor(item)),
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
                        DataCell(Text(item.numOrden ?? ''), onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (conext) =>
                                    FileViewer(numOrden: item.numOrden)),
                          );
                        }),
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
                        DataCell(Center(child: Text(item.cantOrden ?? ''))),
                        DataCell(Center(
                            child: Text(item.cantElabored ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)))),
                        DataCell(Center(child: Text(item.cantBad ?? ''))),
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
                        DataCell(Text(item.machine ?? '')),
                        DataCell(Row(
                          children: [
                            Text(item.puntada ?? ''),
                            const Text('--'),
                            Text(item.veloz ?? '')
                          ],
                        )),
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
