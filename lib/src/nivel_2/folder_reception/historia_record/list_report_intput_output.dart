import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../datebase/current_data.dart';
import '../../../datebase/url.dart';
import '../../../model/registed.dart';
import '../../../util/commo_pallete.dart';
import '../../../util/get_formatted_number.dart';
import '../../../util/get_time_relation.dart';
import '/src/datebase/methond.dart';
import '/src/nivel_2/folder_planificacion/url_planificacion/url_planificacion.dart';
import '/src/nivel_2/folder_reception/historia_record/register.dart';
import '/src/widgets/loading.dart';

import '../../../widgets/pick_range_date.dart';

class ListReportInputOutPut extends StatefulWidget {
  const ListReportInputOutPut({super.key});

  @override
  State<ListReportInputOutPut> createState() => _ListReportInputOutPutState();
}

class _ListReportInputOutPutState extends State<ListReportInputOutPut> {
  List<Register> listRecord = [];
  String? firstDate = DateTime.now().toString().substring(0, 10);
  String? secondDate = DateTime.now().toString().substring(0, 10);
  List<ResumeRegister> listResumen = [];
  List<Registed> listRegisted = [];
  @override
  void initState() {
    super.initState();
    getRecord();
    getResumenAnual();
  }

//select_orden_registed_in_out
// List<Registed> registedFromJson(
  void getResumenAnual() async {
    // final res = await httpRequestDatabase(
    //     'http://$ipLocal/settingmat/admin/select/select_orden_registed_in_out.php',
    //     {
    //       'date1': getStartParserAnual(DateTime.now())[0],
    //       'date2': getStartParserAnual(DateTime.now())[1]
    //     });

    // print(res.body);

    // final jsonData = jsonDecode(res.body);
    // if (jsonData['success']) {
    //   setState(() {
    //     listRegisted = registedFromJson(jsonEncode(jsonData['data']));
    //     print(listRegisted.length);
    //   });
    // }
  }

  Future getRecord() async {
    // setState(() {
    //   listRecord.clear();
    //   listResumen.clear();
    // });
    // final res = await httpRequestDatabase(
    //     selectReportEntradaSalidaReceptionByDate,
    //     {'date1': firstDate, 'date2': secondDate});
    // setState(() {
    //   listRecord = registerFromJson(res.body);
    //   getResume();
    // });
  }

  depurarTipoTrabajos(List<Register> list) {
    Set<String> objectoSet =
        list.map((element) => element.userRegister!).toSet();
    List<String> listTake = objectoSet.toList();
    return listTake;
  }

  getResume() {
    var listEmpleado = depurarTipoTrabajos(listRecord);
    String entrada = 'Entradas';
    String salida = 'Salidas';

    for (var empleado in listEmpleado) {
      var totalRegisted = listRecord
          .where((element) =>
              element.userRegister == empleado &&
              element.statu?.toUpperCase() == entrada.toUpperCase())
          .toList();
      var totalDelivery = listRecord
          .where((element) =>
              element.userRegister == empleado &&
              element.statu?.toUpperCase() == salida.toUpperCase())
          .toList();

      listResumen.add(ResumeRegister(
        empleado: empleado,
        entradas: '${totalRegisted.length}',
        salidas: '${totalDelivery.length}',
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Registros y Entregas'), actions: [
        Tooltip(
          message: 'Buscar por fecha',
          child: Container(
            // Agregado un contenedor para ajustar el espacio
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.calendar_month_outlined,
                  color: Colors.black),
              onPressed: () async {
                selectDateRangeNew(context, (date1, date2) {
                  firstDate = date1;
                  secondDate = date2;

                  getRecord();
                  getResumenAnual();
                });
              },
            ),
          ),
        ),
      ]),
      body: Column(
        children: [
          const SizedBox(width: double.infinity, height: 25),
          listRegisted.isNotEmpty
              ? SizedBox(
                  height: 350,
                  child: GraficoResumen(registedData: listRegisted))
              : const SizedBox(),
          const SizedBox(height: 20),
          listResumen.isEmpty
              ? const Expanded(child: Loading(text: 'Cargando ...'))
              : Expanded(
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
                        decoration: const BoxDecoration(color: ktejidoblue),
                        headingTextStyle: const TextStyle(color: Colors.white),
                        columns: const [
                          DataColumn(label: Text('Empleado')),
                          DataColumn(label: Text('Ordenes Registradas')),
                          DataColumn(label: Text('Ordenes Entregadas')),
                        ],
                        rows: [
                          ...listResumen.asMap().entries.map((entry) {
                            int index = entry.key;
                            var report = entry.value;
                            return DataRow(
                              color: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
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
                                DataCell(Text(report.empleado ?? 'N/A')),
                                DataCell(Center(
                                    child: Text(report.entradas ?? 'N/A'))),
                                DataCell(Center(
                                    child: Text(report.salidas ?? 'N/A'))),
                              ],
                            );
                          }),
                          // Fila para mostrar los totales
                          DataRow(
                            cells: [
                              const DataCell(Text('Totales',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white))),
                              DataCell(Center(
                                child: Text(
                                  listResumen
                                      .fold<int>(
                                          0,
                                          (sum, item) =>
                                              sum +
                                              (int.tryParse(
                                                      item.entradas ?? '0') ??
                                                  0))
                                      .toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              )),
                              DataCell(Center(
                                child: Text(
                                  listResumen
                                      .fold<int>(
                                          0,
                                          (sum, item) =>
                                              sum +
                                              (int.tryParse(
                                                      item.salidas ?? '0') ??
                                                  0))
                                      .toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          Text('Total Empleados : ${listResumen.length}',
              style: style.bodySmall
                  ?.copyWith(color: ktejidoblue, fontWeight: FontWeight.w600)),
          identy(context)
        ],
      ),
    );
  }
}

class GraficoResumen extends StatelessWidget {
  const GraficoResumen({super.key, this.registedData});
  final List<Registed>? registedData;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final maxValor = (registedData ?? [])
        .map((e) => [e.entradas ?? 0, e.salidas ?? 0]) // Convertimos nulls a 0
        .expand((e) => e)
        .fold<int>(0, (prev, el) => el > prev ? el : prev);

    // Aumentar 20% al máximo
    final maxEjeY = (maxValor * 1.2).ceil();
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      // child: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 5),
      //   child: SfCartesianChart(
      //     title: ChartTitle(
      //         text: 'Ordenes Registros por Mes',
      //         textStyle: Theme.of(context)
      //             .textTheme
      //             .bodySmall
      //             ?.copyWith(color: colorsBlueDeepHigh)),
      //     tooltipBehavior: TooltipBehavior(enable: true),
      //     legend: const Legend(isVisible: true),
      //     primaryXAxis: CategoryAxis(
      //       title: AxisTitle(
      //           text: 'Mes',
      //           textStyle: Theme.of(context)
      //               .textTheme
      //               .bodySmall
      //               ?.copyWith(color: colorsBlueDeepHigh)),
      //       labelRotation: -25,
      //     ),
      //     primaryYAxis: NumericAxis(
      //       maximum: maxEjeY.toDouble() * 1.2,
      //       title: AxisTitle(
      //         text: 'Cantidades Ordenes',
      //         textStyle: Theme.of(context)
      //             .textTheme
      //             .bodySmall
      //             ?.copyWith(color: colorsBlueDeepHigh),
      //       ),
      //       labelFormat: '{value}',
      //     ),
      //     series: <ColumnSeries<Registed, String>>[
      //       ColumnSeries<Registed, String>(
      //         name: 'Registradas',
      //         color: colorsBlueDeepHigh,
      //         dataSource: registedData ?? [],
      //         width: 0.4, // tamaño de la columna (0.0 a 1.0)
      //         spacing: 0.2, // espacio entre columnas
      //         xValueMapper: (Registed data, _) => data.monthName,
      //         yValueMapper: (Registed data, _) => data.entradas,
      //         markerSettings: const MarkerSettings(isVisible: true),
      //         dataLabelSettings: DataLabelSettings(
      //           isVisible: true,
      //           angle: -68,
      //           margin: const EdgeInsets.only(bottom: 25),
      //           textStyle: style.bodySmall,
      //         ),
      //         dataLabelMapper: (Registed data, _) =>
      //             getNumFormatedDouble('${data.entradas}'),
      //       ),
      //       ColumnSeries<Registed, String>(
      //         color: Colors.green,
      //         name: 'Entregadas',
      //         dataSource: registedData ?? [],
      //         width: 0.4, // tamaño de la columna (0.0 a 1.0)
      //         spacing: 0.2, // espacio entre columnas
      //         xValueMapper: (Registed data, _) => data.monthName,
      //         yValueMapper: (Registed data, _) => data.salidas,
      //         markerSettings: const MarkerSettings(isVisible: true),
      //         dataLabelSettings: DataLabelSettings(
      //           isVisible: true,
      //           angle: -68,
      //           margin: const EdgeInsets.only(bottom: 25),
      //           textStyle: style.bodySmall,
      //         ),
      //         dataLabelMapper: (Registed data, _) =>
      //             getNumFormatedDouble('${data.salidas}'),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

// class GraficoResumen extends StatelessWidget {
//   const GraficoResumen({super.key, this.registedData});
//   final List<Registed>? registedData;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 25),
//         child: SfCartesianChart(
//           title: ChartTitle(
//             text: 'Producción por Mes',
//             textStyle: Theme.of(context)
//                 .textTheme
//                 .bodySmall
//                 ?.copyWith(color: Colors.red),
//           ),
//           tooltipBehavior: TooltipBehavior(enable: true),
//           legend: const Legend(isVisible: true),
//           primaryXAxis: CategoryAxis(
//             title: AxisTitle(
//               text: 'Mes',
//               textStyle: Theme.of(context)
//                   .textTheme
//                   .bodySmall
//                   ?.copyWith(color: Colors.red),
//             ),
//             labelRotation: -25,
//           ),
//           primaryYAxis: NumericAxis(
//             title: AxisTitle(
//               text: 'Producción Total',
//               textStyle: Theme.of(context)
//                   .textTheme
//                   .bodySmall
//                   ?.copyWith(color: Colors.red),
//             ),
//             labelFormat: '{value}',
//           ),
//           series: <SplineSeries<Registed, String>>[
//             SplineSeries<Registed, String>(
//               name: 'Ordenes Registradas',
//               dataSource: registedData ?? [],
//               xValueMapper: (Registed data, _) => data.monthName,
//               yValueMapper: (Registed data, _) => data.entradas,
//               markerSettings: const MarkerSettings(isVisible: true),
//               dataLabelSettings: const DataLabelSettings(isVisible: true),
//             ),
//             SplineSeries<Registed, String>(
//               name: 'Ordenes Entregadas',
//               dataSource: registedData ?? [],
//               xValueMapper: (Registed data, _) => data.monthName,
//               yValueMapper: (Registed data, _) => data.salidas,
//               markerSettings: const MarkerSettings(isVisible: true),
//               dataLabelSettings: const DataLabelSettings(isVisible: true),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
