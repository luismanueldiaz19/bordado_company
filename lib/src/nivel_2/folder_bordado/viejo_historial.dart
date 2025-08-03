import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/nivel_2/folder_bordado/model/bordado_resumen.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/get_formatted_number.dart';
import '/src/util/show_mesenger.dart';
import '/src/widgets/pick_range_date.dart';

import '../../screen_print_pdf/apis/pdf_api.dart';
import '../../util/dialog_confimarcion.dart';
import '../../util/get_time_relation.dart';
import 'database_bordado/url_bordado.dart';
import 'model/bordado_report.dart';
import 'model/report_bordado_tirada.dart';
import 'model/report_final.dart';
import 'print_bordado/print_bordado_historial.dart';

class ViejoHistorial extends StatefulWidget {
  const ViejoHistorial({Key? key}) : super(key: key);

  @override
  State<ViejoHistorial> createState() => _ViejoHistorialState();
}

class _ViejoHistorialState extends State<ViejoHistorial> {
  List<BordadoReportTiradas> listReported = [];
  List<BordadoReportTiradas> listGroupRecored = [];
  List<BordadoReportTiradas> listReportedFilter = [];

  ///for to report
  List<BordadoResumen> listResumen = [];
  List<Map<String, dynamic>> outputList = [];
  ////////////////////////////
  ReporteFinal? reportedFinal;

  ///data initit
  bool isResumenFinal = false;
  bool isLoading = true;
  String? firstDate = '${DateTime.now().toString().substring(0, 10)} 00:00:00';
  String? secondDate = '${DateTime.now().toString().substring(0, 10)} 23:59:59';

  /////////////Parts of Filter
  String empleadoSelected = '';
  String maquinaSelected = '';

  Future getRecord() async {
    setState(() {
      listReported.clear();
      isLoading = true;
      isResumenFinal = false;
      reportedFinal = null;
    });
    final res = await httpRequestDatabase(
        selectBordadoTiradasResumen, {'date1': firstDate, 'date2': secondDate});
    listReported = bordadoReportTiradasFromJson(res.body);

    listReportedFilter = [...listReported];
    getResumen();
    setState(() {});
  }

  ///////este eliminar los item de una orden completa///
  Future eliminarBordadoReport(id) async {
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
            listReported.removeWhere((item) => item.id == id);
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getRecord();
  }

  ///obtener lista de reporte por maquina
  List<BordadoReport> getReportByMachine(List<BordadoReport> inputList, item) {
    var listReportMachine = inputList
        .where(
            (element) => element.machine?.toUpperCase() == item.toUpperCase())
        .toList();

    return listReportMachine;
  }

  List<String> getMaquinaMethond(List<BordadoReport> inputList) {
    List<String> listMaquine = [];
    for (var item in inputList) {
      listMaquine.add(item.machine ?? '');
    }
    Set<String> listStringMaquine = Set.from(listMaquine);

    return listStringMaquine.toList();
  }

  List<String> getUsuarioReportedMethond(List<BordadoReport> inputList) {
    List<String> listMaquine = [];
    for (var item in inputList) {
      listMaquine.add(item.fullName ?? '');
    }
    Set<String> listStringMaquine = Set.from(listMaquine);

    return listStringMaquine.toList();
  }

  getResumen() async {
    listResumen.clear();
    Map<String, Map<String, Map<String, String>>> datos = {};
    var machineList = BordadoReportTiradas.depurarObjectsMachine(listReported);
    var empleadoList =
        BordadoReportTiradas.depurarObjectsFullName(listReported);

    for (var machine in machineList) {
      datos[machine] = {};
      for (var empleado in empleadoList) {
        var listReportEmpleado = listReported
            .where((element) =>
                element.machine?.toUpperCase() == machine.toUpperCase() &&
                element.fullName?.toUpperCase() == empleado.toUpperCase())
            .toList();

        ///total de pieza
        var cantPieza =
            BordadoReportTiradas.calcularTotalPieza(listReportEmpleado);
        var cantPuntada =
            BordadoReportTiradas.calcularTotalPuntada(listReportEmpleado);
        var cantTiempo = BordadoReportTiradas.getTimeR(listReportEmpleado);
        var cantMala =
            BordadoReportTiradas.calcularTotalMala(listReportEmpleado);

        datos[machine]![empleado] = {
          'cant': cantPieza.toString(),
          'puntada': cantPuntada.toString(),
          'tirada': '${listReportEmpleado.length}',
          'time': cantTiempo.toString(),
          'mala': cantMala.toString()
        };
      }
    }

    datos.forEach((machine, empleados) {
      empleados.forEach((empleado, detalles) {
        BordadoResumen resumen = BordadoResumen(
            empleado: empleado,
            maquina: machine,
            pieza: detalles['cant']!,
            puntada: detalles['puntada']!,
            percent: detalles['tirada']!,
            time: detalles['time']!,
            piezaMala: detalles['mala']!,
            tiradas: detalles['tirada']!);
        listResumen.add(resumen);
      });
    });
  }

  searchingEmpleado() {
    setState(() {
      listReportedFilter = listReported
          .where((element) =>
              element.fullName?.toUpperCase() == empleadoSelected.toUpperCase())
          .toList();
    });
  }

  searchingMachine() {
    setState(() {
      listReportedFilter = listReported
          .where((element) =>
              element.machine?.toUpperCase() == maquinaSelected.toUpperCase())
          .toList();
    });
  }

  searchingEmpleadoAndMachine() {
    setState(() {
      listReportedFilter = listReported
          .where((element) =>
              element.fullName?.toUpperCase() ==
                  empleadoSelected.toUpperCase() &&
              element.machine?.toUpperCase() == maquinaSelected.toUpperCase())
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Tiradas De Bordado'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: IconButton(
                icon: const Icon(Icons.print, color: Colors.black),
                onPressed: () async {
                  if (listReportedFilter.isNotEmpty) {
                    if (listReportedFilter.isNotEmpty) {
                      final pdfFile = await PrintBordadoHistorial.generate(
                          listReportedFilter,
                          'Fecha : $firstDate - $secondDate',
                          BordadoReportTiradas()
                              .getTotalElaborada(listReportedFilter),
                          BordadoReportTiradas.getTotalBad(listReportedFilter),
                          getNumFormatedDouble(
                              '${BordadoReportTiradas.calcularTotalPuntada(listReportedFilter)}'),
                          BordadoReportTiradas.getTimeR(listReportedFilter));
                      PdfApi.openFile(pdfFile);
                    }
                  }
                },
              ),
            ),
          ],
          backgroundColor: Colors.transparent),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          DateRangeSelectionWidget(
            press: (date1, date2) {
              setState(() {
                firstDate = date1;
                secondDate = date2;

                getRecord();
              });
              // getIncidencia(_firstDate, _secondDate);
            },
          ),

          listReported.isNotEmpty
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: SizedBox(
                    height: 35,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: BordadoReportTiradas.depurarObjectsFullName(
                                listReported)
                            .map(
                          (item) {
                            return Container(
                              color: empleadoSelected == item
                                  ? Colors.blue.shade100
                                  : Colors.white,
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        empleadoSelected = item;

                                        searchingEmpleado();
                                      },
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty
                                              .resolveWith((states) =>
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.zero))),
                                      child: Text(item)),
                                  empleadoSelected == item
                                      ? TextButton(
                                          onPressed: () {
                                            setState(() {
                                              maquinaSelected = '';
                                              empleadoSelected = '';
                                              listReportedFilter = listReported;
                                            });
                                          },
                                          child: const Center(
                                            child: Icon(Icons.close,
                                                color: Colors.red, size: 15),
                                          ))
                                      : const SizedBox()
                                ],
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          // const SizedBox(height: 10),
          listReported.isNotEmpty
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: SizedBox(
                    height: 35,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: BordadoReportTiradas.depurarObjectsMachine(
                                listReportedFilter)
                            .map(
                          (item) {
                            return Container(
                              color: maquinaSelected == item
                                  ? Colors.orange.shade100
                                  : Colors.white,
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        print('Emplead es $empleadoSelected');
                                        maquinaSelected = item;
                                        if (empleadoSelected.isEmpty) {
                                          searchingMachine();
                                        } else {
                                          searchingEmpleadoAndMachine();
                                        }
                                      },
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty
                                              .resolveWith((states) =>
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.zero))),
                                      child: Text(item)),
                                  maquinaSelected == item
                                      ? TextButton(
                                          onPressed: () {
                                            maquinaSelected = '';
                                            setState(() {
                                              if (empleadoSelected.isEmpty) {
                                                listReportedFilter =
                                                    listReported;
                                              }
                                            });
                                          },
                                          child: const Center(
                                            child: Icon(Icons.close,
                                                color: Colors.red, size: 15),
                                          ))
                                      : const SizedBox()
                                ],
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          const SizedBox(height: 10),
          listReportedFilter.isNotEmpty
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        child: DataTable(
                          dataRowMaxHeight: 25,
                          dataRowMinHeight: 20,
                          columnSpacing: 15,
                          headingRowHeight: 20,
                          dataTextStyle: style.bodySmall,
                          headingTextStyle: style.titleSmall,
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
                              inside: const BorderSide(color: Colors.grey)),
                          columns: const [
                            DataColumn(label: Text('Tiradas')),
                            DataColumn(label: Text('Empleados')),
                            DataColumn(label: Text('# Orden')),
                            DataColumn(label: Text('Fichas')),
                            DataColumn(label: Text('Logo')),
                            DataColumn(label: Text('Qty Orden')),
                            DataColumn(label: Text('Qty Realizado')),
                            DataColumn(label: Text('Qty Defectuosa')),
                            DataColumn(label: Text('Fecha Inicio')),
                            DataColumn(label: Text('Fecha Terminado')),
                            DataColumn(label: Text('Tiempos')),
                            DataColumn(label: Text('Maquinas')),
                            DataColumn(label: Text('Puntadas/Vel.')),
                            DataColumn(label: Text('Comentarios')),
                            DataColumn(label: Text('Acciones')),
                          ],
                          rows: listReportedFilter
                              .map(
                                (item) => DataRow(
                                  color: MaterialStateProperty.resolveWith(
                                      (states) => getColor(item)),
                                  cells: [
                                    DataCell(Text(item.id ?? 'N/A',
                                        style: const TextStyle(
                                            color: Colors.black))),
                                    DataCell(Row(children: [
                                      Text(
                                          item.fullName
                                              .toString()
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis)),
                                    ])),
                                    DataCell(Text(item.numOrden ?? '')),
                                    DataCell(Text(item.ficha ?? '')),
                                    DataCell(
                                        SizedBox(
                                          width: 100,
                                          child: Text(item.nameLogo ?? '',
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                        ), onTap: () {
                                      utilShowMesenger(
                                          context, item.nameLogo ?? '',
                                          title: 'LOGO');
                                    }),
                                    DataCell(Text(item.cantOrden ?? '')),
                                    DataCell(Text(
                                      item.cantElabored ?? '',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                    DataCell(Text(item.cantBad ?? '')),
                                    DataCell(Text(item.fechaStarted ?? '')),
                                    DataCell(Text(item.fechaEnd ?? '')),
                                    DataCell(Text(
                                      getTimeRelation(
                                          item.fechaStarted ?? 'N/A',
                                          item.fechaEnd ?? 'N/A'),
                                      style: const TextStyle(
                                          color: Colors.indigo,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    DataCell(Text(item.machine ?? '')),
                                    DataCell(Row(children: [
                                      Text(item.puntada ?? ''),
                                      const Text('--'),
                                      Text(item.veloz ?? '')
                                    ])),
                                    DataCell(
                                        SizedBox(
                                          width: 50,
                                          child: Text(item.comment ?? '',
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                        ), onTap: () {
                                      utilShowMesenger(
                                          context, item.comment ?? '',
                                          title: 'Comentarios');
                                    }),
                                    DataCell(
                                      Text('Eliminar',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(color: colorsRed)),
                                      onTap: () =>
                                          eliminarBordadoReport(item.id),
                                    )
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                )
              : const Center(
                  child: Text('No hay Historial'),
                ),
          listReportedFilter.isNotEmpty
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: SizedBox(
                    height: 40,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BounceInDown(
                              duration: const Duration(milliseconds: 500),
                              child: Container(
                                  height: 35,
                                  color: Colors.white,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  alignment: Alignment.center,
                                  child: Text(
                                      'Tiradas : ${listReportedFilter.length}',
                                      style: style.bodySmall))),
                          BounceInDown(
                            duration: const Duration(milliseconds: 500),
                            child: Container(
                              height: 35,
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              alignment: Alignment.center,
                              child: Text(
                                  'PIEZAS : ${BordadoReportTiradas().getTotalElaborada(listReportedFilter)}',
                                  style: style.bodySmall
                                      ?.copyWith(color: Colors.green)),
                            ),
                          ),
                          BounceInDown(
                            duration: const Duration(milliseconds: 700),
                            child: Container(
                              height: 35,
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              alignment: Alignment.center,
                              child: Text(
                                'PIEZAS MALA : ${BordadoReportTiradas.getTotalBad(listReportedFilter)}',
                                style: style.bodySmall
                                    ?.copyWith(color: Colors.red),
                              ),
                            ),
                          ),
                          // var cantPuntada = BordadoResumen.calcularTotalPuntada(items);
                          BounceInDown(
                            duration: const Duration(milliseconds: 900),
                            child: Container(
                              height: 35,
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              alignment: Alignment.center,
                              child: Text(
                                  'PUNTADAS GENERAL : ${getNumFormatedDouble('${BordadoReportTiradas.calcularTotalPuntada(listReportedFilter)}')}',
                                  style: style.bodySmall?.copyWith()),
                            ),
                          ),
                          // var cantPuntada = BordadoResumen.calcularTotalPuntada(items);
                          BounceInDown(
                            duration: const Duration(milliseconds: 1100),
                            child: Container(
                              height: 35,
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              alignment: Alignment.center,
                              child: Text(
                                  'TIEMPO GENERAL : ${BordadoReportTiradas.getTimeR(listReportedFilter)}',
                                  style: style.bodySmall?.copyWith()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          identy(context),
        ],
      ),
    );
  }
}

Color getColor(BordadoReportTiradas report) {
  return Colors.green.shade100;
}

class MachineReport {
  String machineName;
  List<Map<String, Map<String, String>>> reports;

  MachineReport({required this.machineName, required this.reports});

  Map<String, dynamic> toJson() {
    return {
      machineName: reports,
    };
  }
}
