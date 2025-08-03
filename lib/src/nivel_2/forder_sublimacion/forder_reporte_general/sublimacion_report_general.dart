import 'package:flutter/material.dart';
import '/src/screen_print_pdf/apis_orden_record/reports_general_sublimacion.dart';
import '/src/util/show_mesenger.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:lottie/lottie.dart';
import '/src/datebase/methond.dart';
import '/src/model/department.dart';
import '/src/model/type_work.dart';
import '/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
import '/src/nivel_2/forder_sublimacion/url_report_general/url_reportes_generales.dart';
import '/src/screen_print_pdf/apis/pdf_api.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/font_style.dart';
import '/src/widgets/picked_date_widget.dart';

import '../../../widgets/pick_range_date.dart';

class SublimacionReportGeneral extends StatefulWidget {
  const SublimacionReportGeneral(
      {super.key, required this.current, required this.listTypeWork});
  final Department current;
  final List<TypeWork> listTypeWork;
  @override
  State<SublimacionReportGeneral> createState() =>
      _SublimacionReportGeneralState();
}

class _SublimacionReportGeneralState extends State<SublimacionReportGeneral> {
  String? _secondDate = '';
  String? _firstDate = '';
  bool isLoading = true;
  // bool selected = false;
  // List<String> tipoTrabajo = [];
  List<String> nombresUnicos = [];
  List<String> nombreTrajoUnicos = [];
  List<Sublima> usuariosDetacados = [];
  List<Sublima> totalTipoTrabajos = [];
  Map dataReported = {};

  Map dataReportFull = {};
  Map dataReportPKT = {};

  void cargarReport(bool value) {
    isLoading = value;
    setState(() {});
  }

  List<Sublima> listReport = [];
  getReports(date1, date2) async {
    final res = await httpRequestDatabase(
        selectSublimacionReporteGeneral, {'date1': date1, 'date2': date2});
    // print(res.body);
    listReport = sublimaFromJson(res.body);
    if (listReport.isNotEmpty) {
      totalTipoTrabajos.clear();
      usuariosDetacados.clear();
      isLoading = !isLoading;

      tableData.clear();
      tableDataFull.clear();
      tableDataPKT.clear();
      setState(() {});
      ///////////////tomar usuario sin repetir/////////////
      takeUserWithoutRepet();
      ///////////Distribuir la informacion del reporte /////
      simplificarWorkReports();
      ///////////table aparte de la table full/////
      simplificarFull();
      ///////////table aparte de la table PKT/////
      simplificarPKT();
      for (var work in nombreTrajoUnicos) {
        tomarUsuariosDestacados(work);
      }
      listReport.isNotEmpty ? convertirDataEnListString() : null;
      cargarReport(false);
    } else {
      if (mounted) utilShowMesenger(context, 'No hay Reportes');
    }
  }

  @override
  void initState() {
    super.initState();

    // tooltipBehavior = TooltipBehavior(enable: true);
    _firstDate = DateTime.now().toString().substring(0, 10);
    _secondDate = DateTime.now().toString().substring(0, 10);
    verifyTipoTrabajos();
    getReports(_firstDate, _secondDate);
  }

  // waitingAnimation() async {
  //   await Future.delayed(const Duration(seconds: 3));
  //   cargarReport();
  // }

  List<WorkData> _convertData(List<Sublima> userHots) {
    return userHots.map((sublima) {
      return WorkData(
        sublima.fullName ?? 'N/A',
        int.parse(sublima.cantPieza ?? '0'),
        sublima.typeWork ?? 'N/A',
      );
    }).toList();
  }

  String getPocent(int cantPieza, int total) {
    final result = cantPieza / total * 100;
    return result.toStringAsFixed(0);
  }

  Color _getColor(String typeWork) {
    switch (typeWork) {
      case 'Calandra':
        return colorsRedOpaco;
      case 'Empaque':
        return Colors.orange;
      case 'Plancha':
        return colorsBlueTurquesa;
      case 'Horno':
        return Colors.teal;
      case 'Transfer':
        return colorsAd;
      case 'Vinil':
        return colorsPuppleOpaco;
      case 'Sellos':
        return colorsRedVinoHard;
      case 'Sub-Normal':
        return colorsGreenLevel;
      default:
        return Colors.grey;
    }
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////metodo para obtener todo los usuario de la lista sin repetir////////
  void takeUserWithoutRepet() async {
    setState(() {
      dataReported = {};
      dataReportFull = {};
      dataReportPKT = {};
    });
    List<String> uniqueNames = [];
    List<Sublima> users = [...listReport];

    uniqueNames = users.toSet().map((user) => user.fullName ?? 'N/A').toList();

    nombresUnicos = uniqueNames.toSet().toList();

    ///este ciclo for es para agregar los nombre a los tipo de trabajo
    ///por ejemplo Alex {'Calandra':'0'} ////////

    for (var fullName in nombresUnicos) {
      dataReported[fullName] = {nombreTrajoUnicos.first: '0'};
      dataReportFull[fullName] = {nombreTrajoUnicos.first: '0'};
      dataReportPKT[fullName] = {nombreTrajoUnicos.first: '0'};
    }
  }

//////////este metodo toma los tipo de trabajo que esten en la lista///
  void verifyTipoTrabajos() {
    List<String> uniqueWork = [];
    List<TypeWork> listTypeWork = [...widget.listTypeWork];
    uniqueWork =
        listTypeWork.toSet().map((user) => user.typeWork ?? 'N/A').toList();

    nombreTrajoUnicos = uniqueWork.toSet().toList();
    // print('Tabajos unico $nombreTrajoUnicos');
  }

////////////////////////////////////////////////////////////////////////////
  //-------------------------------------------------------------------------//
  //////////////aqui bamo a tomar los trabajo por tipo de trabajo y usuario correspondiente////
  List<Sublima> filtroTipoWorkList(usuario, tipoTrabajo) {
    List<Sublima> listLocal = List.from(listReport
        .where((x) =>
            x.fullName!.toUpperCase().contains(usuario.toUpperCase()) &&
            x.typeWork!.toUpperCase().contains(tipoTrabajo.toUpperCase()))
        .toList());

    return listLocal;
  }
//-------------------------------------------------//

  // () == 'EMPAQUE' ||
  //       widget.current.nameWork?.toUpperCase().trim() == 'CALANDRA' ||
  //       widget.current.nameWork?.toUpperCase().trim() == 'PLANCHA' ||
  //       widget.current.nameWork?.toUpperCase().trim() == 'HORNO' ||
  //       widget.current.nameWork?.toUpperCase().trim() == 'SELLOS') {

  // List dfdv = ['EMPAQUE','CALANDRA','PLANCHA','HORNO','SELLOS'];

  void simplificarWorkReports() {
    ////eligiendo los usuarios ////////////

    for (var fullName in nombresUnicos) {
      ////////////ciclo for de los trabajo para clasificar///////////////
      for (var workName in nombreTrajoUnicos) {
        /////ciclo for para los trabajos agrupado y sumar los dFull ///////////
        List<Sublima> workAgrupado =
            filtroTipoWorkList(fullName.toString(), workName.toString());
        // print('Tamono De la lista ${workAgrupado.length}');
        // print(numWork);
        int value = 0;
        /////////proceder agregar al map nuevo los siguiente
        for (var work in workAgrupado) {
          value += int.parse(work.cantPieza ?? '0');
          // print('Valor sumando ${value}');
        }

        if (nombreTrajoUnicos.last == workName) {
          dataReported[fullName][workName] = value.toString();
          Map sumValues = dataReported[fullName];
          // print('sumValues ${sumValues}');
          Map<String, int> nuevoMapa = {};
          sumValues.forEach((key, value) {
            nuevoMapa[key] = int.parse(value.toString());
          });
          int sum = nuevoMapa.values.reduce((prev, value) => prev + value);

          dataReported[fullName]['Total'] = sum.toString();
        } else {
          dataReported[fullName][workName] = value.toString();
        }
      }
    }
    // print('Data Es:  ${dataReported}');
  }

  ////////////////Simplificarlos PKT Ft Full ///////////

  void simplificarFull() {
    // List numberList = [
    //   'Transfer',
    //   'Vinil',
    //   'Impreción Cortes',
    //   'Sub-Normal',
    //   'DTF'
    // ];
    ////eligiendo los usuarios ////////////
    for (var fullName in nombresUnicos) {
      ////////////ciclo for de los trabajo para clasificar///////////////
      for (var workName in nombreTrajoUnicos) {
        /////ciclo for para los trabajos agrupado y sumar los dFull ///////////
        List<Sublima> workAgrupado =
            filtroTipoWorkList(fullName.toString(), workName.toString());

        // print('Tamono De la lista ${workAgrupado.length}');
        // print(numWork);
        int value = 0;
        /////////proceder agregar al map nuevo los siguiente
        for (var work in workAgrupado) {
          value += int.parse(work.dFull ?? '0');
          // print(
          //     'nombre $fullName tipo de trabajo : $workName con PKT : ${value}');
        }

        if (nombreTrajoUnicos.last == workName) {
          dataReportFull[fullName][workName] = value.toString();
          Map sumValues = dataReportFull[fullName];
          Map<String, int> nuevoMapa = {};
          sumValues.forEach((key, value) {
            nuevoMapa[key] = int.parse(value.toString());
          });
          int sum = nuevoMapa.values.reduce((prev, value) => prev + value);

          dataReportFull[fullName]['Total'] = sum.toString();
        } else {
          dataReportFull[fullName][workName] = value.toString();
        }
      }
    }
    // print('dataReportPKTFull Es:  ${dataReportFull}');
  }

  ////////////////Simplificarlos PKT Ft Full ///////////

  void simplificarPKT() {
    // List numberList = [
    //   'Transfer',
    //   'Vinil',
    //   'Impreción Cortes',
    //   'Sub-Normal',
    //   'DTF'
    // ];

    ////eligiendo los usuarios ////////////
    for (var fullName in nombresUnicos) {
      ////////////ciclo for de los trabajo para clasificar///////////////
      for (var workName in nombreTrajoUnicos) {
        /////ciclo for para los trabajos agrupado y sumar los dFull ///////////
        List<Sublima> workAgrupado =
            filtroTipoWorkList(fullName.toString(), workName.toString());

        // print('Tamono De la lista ${workAgrupado.length}');
        // print(numWork);
        int value = 0;
        /////////proceder agregar al map nuevo los siguiente
        for (var work in workAgrupado) {
          value += int.parse(work.pkt ?? '0');
          // print(
          //     'nombre $fullName tipo de trabajo : $workName con PKT : ${value}');
        }

        if (nombreTrajoUnicos.last == workName) {
          dataReportPKT[fullName][workName] = value.toString();
          Map sumValues = dataReportPKT[fullName];
          Map<String, int> nuevoMapa = {};
          sumValues.forEach((key, value) {
            nuevoMapa[key] = int.parse(value.toString());
          });
          int sum = nuevoMapa.values.reduce((prev, value) => prev + value);

          dataReportPKT[fullName]['Total'] = sum.toString();
        } else {
          dataReportPKT[fullName][workName] = value.toString();
        }
      }
    }
    // print('dataReportPKTFull Es:  ${dataReportPKTFull}');
  }

///////////////////funcion para obtener los usuario mas destacado //////////
  obtenerUsuarioMasDestacado(List<Sublima> lista) {
    int numeroMasAlto = 0;
    Sublima? usuarioMasDestacado;
    int totalPieza = 0;

    for (var item in lista) {
      int cantidadPiezas = int.parse(item.cantPieza ?? '0');
      totalPieza += int.parse(item.cantPieza ?? '0');
      if (cantidadPiezas > numeroMasAlto) {
        numeroMasAlto = cantidadPiezas;
        usuarioMasDestacado = item;
      }
    }

    totalTipoTrabajos.add(Sublima(
      toTalDiferences: totalPieza.toString(),
      typeWork: usuarioMasDestacado?.typeWork,
    ));

    if (lista.isNotEmpty) {
      usuariosDetacados.add(Sublima(
          cantPieza: usuarioMasDestacado?.cantPieza,
          fullName: usuarioMasDestacado?.fullName,
          toTalDiferences: totalPieza.toString(),
          typeWork: usuarioMasDestacado?.typeWork));
    }
  }

  tomarUsuariosDestacados(String nameWork) {
    // print(
    //     'hola usuario destacados En ${nombreTrajoUnicos.first.toUpperCase()}');
    List<Sublima> listLocal = List.from(listReport
        .where(
            (x) => x.typeWork!.toUpperCase().contains(nameWork.toUpperCase()))
        .toList());

    obtenerUsuarioMasDestacado(listLocal);
  }

////////////este metodo convierta la el map de resports a una lista de <String>////////////////////
  List<List<String>> tableData = [];
  List<List<String>> tableDataFull = [];
  List<List<String>> tableDataPKT = [];

  convertirDataEnListString() {
    for (var employee in dataReported.entries) {
      List<String> row = [
        employee.key,
        employee.value['Calandra'].toString(),
        employee.value['Empaque'].toString(),
        employee.value['Plancha'].toString(),
        employee.value['Horno'].toString(),
        employee.value['Transfer'].toString(),
        employee.value['Vinil'].toString(),
        employee.value['Impresión cortes'].toString(),
        employee.value['Sub-Normal'].toString(),
        employee.value['Sellos'].toString(),
        employee.value['DTF'].toString(),
        employee.value['Total'].toString(),
      ];
      tableData.add(row);
    }
    // print('tableData ${tableData}');

    for (var employee in dataReportFull.entries) {
      List<String> row = [
        employee.key,
        employee.value['Calandra'].toString(),
        employee.value['Empaque'].toString(),
        employee.value['Plancha'].toString(),
        employee.value['Horno'].toString(),
        employee.value['Transfer'].toString(),
        employee.value['Vinil'].toString(),
        employee.value['Impresión cortes'].toString(),
        employee.value['Sub-Normal'].toString(),
        employee.value['Sellos'].toString(),
        employee.value['DTF'].toString(),
        employee.value['Total'].toString(),
      ];
      tableDataFull.add(row);
    }
    // print('tableDataFull  ${tableDataFull}');
    for (var employee in dataReportPKT.entries) {
      // Calandra: 0,
      // Empaque: 0
      //, Plancha: 0,
      // Horno: 0,
      //Transfer: 0,
      // Vinil: 0,
      //Sub-Normal: 3,
      // Sellos: 0,
      // DTF: 0,
      // Impresión cortes: 0,
      // Total: 3}

      // print('Employ ${employee}');
      List<String> row = [
        employee.key,
        employee.value['Calandra'].toString(),
        employee.value['Empaque'].toString(),
        employee.value['Plancha'].toString(),
        employee.value['Horno'].toString(),
        employee.value['Transfer'].toString(),
        employee.value['Vinil'].toString(),
        employee.value['Impresión cortes'].toString(),
        employee.value['Sub-Normal'].toString(),
        employee.value['Sellos'].toString(),
        employee.value['DTF'].toString(),
        employee.value['Total'].toString(),
      ];
      tableDataPKT.add(row);
    }
    // print('tableDataPKT  ${tableDataPKT}');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<WorkData> workData = _convertData(usuariosDetacados);
    List<ChartData> chartData = workData.map((work) {
      return ChartData(work.fullName, work.cantPieza, work.typeWork);
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte general Sublimación'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
                icon: const Icon(Icons.calendar_month_outlined,
                    color: Colors.black),
                onPressed: () {
                  selectDateRangeNew(context, (date1, date2) {
                    setState(() {
                      _firstDate = date1.toString();
                      _secondDate = date2.toString();
                    });
                    cargarReport(true);
                    getReports(_firstDate, _secondDate);
                  });
                }),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            isLoading
                ? SizedBox(
                    height: size.height * 0.30,
                    width: size.height * 0.30,
                    child: Lottie.asset('animation/loading.json',
                        repeat: true, reverse: true, fit: BoxFit.cover),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Container(
                          color: Colors.black12,
                          child: SizedBox(
                            height: size.height * 0.25,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                physics: const BouncingScrollPhysics(),
                                child: DataTable(
                                  dataTextStyle: const TextStyle(
                                      fontSize: 12,
                                      color: colorsAd,
                                      fontWeight: FontWeight.bold),
                                  headingTextStyle: const TextStyle(
                                      fontSize: 10,
                                      color: colorsAd,
                                      fontWeight: FontWeight.w600),
                                  dataRowMaxHeight: 20,
                                  dataRowMinHeight: 15,
                                  headingRowHeight: 20,
                                  dividerThickness: 2,
                                  border: TableBorder.symmetric(
                                      outside: BorderSide(
                                          style: BorderStyle.none,
                                          color: colorsBlueTurquesa
                                              .withOpacity(0.5),
                                          width: 2),
                                      inside: const BorderSide(
                                          style: BorderStyle.solid,
                                          color: colorsBlueDeepHigh,
                                          width: 1)),
                                  columns: const [
                                    DataColumn(label: Text('Empleados')),
                                    // DataColumn(label: Text('C-0')),
                                    DataColumn(label: Text('Calandra')),
                                    DataColumn(label: Text('Empaque')),
                                    DataColumn(label: Text('Plancha')),
                                    DataColumn(label: Text('Horno')),
                                    DataColumn(label: Text('Transfer')),
                                    DataColumn(label: Text('Vinil')),
                                    DataColumn(label: Text('Impresión Cortes')),
                                    DataColumn(label: Text('Sub-Normal')),
                                    DataColumn(label: Text('Sellos')),
                                    DataColumn(label: Text('DTF')),
                                    DataColumn(label: Text('Total')),
                                  ],
                                  rows: dataReported.entries
                                      .map<DataRow>((entry) {
                                    List<DataCell> cells = [
                                      DataCell(Text(entry.key)),
                                    ];
                                    entry.value.forEach((day, value) {
                                      cells.add(DataCell(Text(value)));
                                    });
                                    return DataRow(cells: cells);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      totalTipoTrabajos.isEmpty
                          ? const Text('Cargando')
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              child: SizedBox(
                                height: 20,
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    child: Row(
                                      children: totalTipoTrabajos
                                          .map((e) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: SizedBox(
                                                  child: Row(
                                                    children: [
                                                      Text(e.typeWork ?? 'N/A'),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        e.toTalDiferences ??
                                                            'N/A',
                                                        style: const TextStyle(
                                                          color: Colors.brown,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                    )),
                              ),
                            ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const Text('Informacion Pieza Full'),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: SizedBox(
                          // color: Colors.black12,
                          child: SizedBox(
                            height: size.height * 0.30,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                physics: const BouncingScrollPhysics(),
                                child: DataTable(
                                  dataTextStyle: const TextStyle(
                                      fontSize: 12,
                                      color: colorsAd,
                                      fontWeight: FontWeight.bold),
                                  headingTextStyle: const TextStyle(
                                      fontSize: 10,
                                      color: colorsAd,
                                      fontWeight: FontWeight.w600),
                                  dataRowMaxHeight: 20,
                                  dataRowMinHeight: 15,
                                  headingRowHeight: 20,
                                  dividerThickness: 2,
                                  border: TableBorder.symmetric(
                                      outside: BorderSide(
                                          style: BorderStyle.none,
                                          color:
                                              colorsGreenLevel.withOpacity(0.5),
                                          width: 2),
                                      inside: const BorderSide(
                                          style: BorderStyle.solid,
                                          color: colorsGreenLevel,
                                          width: 1)),
                                  columns: const [
                                    DataColumn(label: Text('Empleados')),
                                    DataColumn(label: Text('Calandra')),
                                    DataColumn(label: Text('Empaque')),
                                    DataColumn(label: Text('Plancha')),
                                    DataColumn(label: Text('Horno')),
                                    DataColumn(label: Text('Transfer')),
                                    DataColumn(label: Text('Vinil')),
                                    DataColumn(label: Text('Impresión Cortes')),
                                    DataColumn(label: Text('Sub-Normal')),
                                    DataColumn(label: Text('Sellos')),
                                    DataColumn(label: Text('DTF')),
                                    DataColumn(label: Text('Total')),
                                  ],
                                  rows: dataReportFull.entries
                                      .map<DataRow>((entry) {
                                    List<DataCell> cells = [
                                      DataCell(Text(entry.key)),
                                    ];
                                    entry.value.forEach((day, value) {
                                      cells.add(DataCell(Text(value)));
                                    });
                                    return DataRow(cells: cells);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                      const Text('Informacion Pieza PKT'),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Container(
                          color: Colors.black12,
                          child: SizedBox(
                            height: size.height * 0.30,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                physics: const BouncingScrollPhysics(),
                                child: DataTable(
                                  dataTextStyle: const TextStyle(
                                      fontSize: 12,
                                      color: colorsAd,
                                      fontWeight: FontWeight.bold),
                                  headingTextStyle: const TextStyle(
                                      fontSize: 10,
                                      color: colorsAd,
                                      fontWeight: FontWeight.w600),
                                  dataRowHeight: 20,
                                  headingRowHeight: 20,
                                  dividerThickness: 2,
                                  border: TableBorder.symmetric(
                                      outside: BorderSide(
                                          style: BorderStyle.none,
                                          color: colorsBlueTurquesa
                                              .withOpacity(0.5),
                                          width: 2),
                                      inside: const BorderSide(
                                          style: BorderStyle.solid,
                                          color: colorsRedOpaco,
                                          width: 1)),
                                  columns: const [
                                    DataColumn(label: Text('Empleados')),
                                    DataColumn(label: Text('Calandra')),
                                    DataColumn(label: Text('Empaque')),
                                    DataColumn(label: Text('Plancha')),
                                    DataColumn(label: Text('Horno')),
                                    DataColumn(label: Text('Transfer')),
                                    DataColumn(label: Text('Vinil')),
                                    DataColumn(label: Text('Impresión Cortes')),
                                    DataColumn(label: Text('Sub-Normal')),
                                    DataColumn(label: Text('Sellos')),
                                    DataColumn(label: Text('DTF')),
                                    DataColumn(label: Text('Total')),
                                  ],
                                  rows: dataReportPKT.entries
                                      .map<DataRow>((entry) {
                                    List<DataCell> cells = [
                                      DataCell(Text(entry.key)),
                                    ];
                                    entry.value.forEach((day, value) {
                                      cells.add(DataCell(Text(value)));
                                    });
                                    return DataRow(cells: cells);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      usuariosDetacados.isNotEmpty
                          ? TextButton.icon(
                              icon: const Icon(Icons.print),
                              onPressed: () async {
                                // print(dataReported);
                                List<Sublima>? ranked = usuariosDetacados
                                    .map((e) => Sublima(
                                        fullName: e.fullName ?? 'N/A',
                                        cantPieza: e.cantPieza ?? 'N/A',
                                        typeWork: e.typeWork,
                                        toTalDiferences: e.toTalDiferences,
                                        percentRelation:
                                            "${getPocent(int.parse(e.cantPieza ?? '0'), int.parse(e.toTalDiferences ?? '0'))}%"))
                                    .toList();
                                ;
                                final pdfFile =
                                    await PdReportsGeneralSublimacion.generate(
                                        tableData,
                                        ranked,
                                        totalTipoTrabajos,
                                        {
                                          'firstDate': _firstDate,
                                          'secondDate': _secondDate
                                        },
                                        tableDataFull,
                                        tableDataPKT);

                                PdfApi.openFile(pdfFile);

                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (_) => PrintPDFGenenal(
                                //             current: dataReported)));
                                // final invoice = Invoice(
                                //     customer: const Customer(
                                //       name: 'Tejidos Tropical',
                                //       address: 'Empleados Destacados',
                                //     ),
                                //     info: InvoiceInfo(
                                //         date: '$_firstDate A $_secondDate'),
                                //     head: 'Sublimación',
                                //     listEmpleadoDestacados: usuariosDetacados
                                //         .map((e) => Sublima(
                                //             fullName: e.fullName ?? 'N/A',
                                //             cantPieza: e.cantPieza ?? 'N/A',
                                //             typeWork: e.typeWork,
                                //             toTalDiferences: e.toTalDiferences,
                                //             percentRelation:
                                //                 "${getPocent(int.parse(e.cantPieza ?? '0'), int.parse(e.toTalDiferences ?? '0'))}%"))
                                //         .toList());

                                // final pdfFile =
                                //     await PdfEmpleadoDestacados.generate(invoice);

                                // PdfApi.openFile(pdfFile);
                              },
                              label: Text(
                                'Imprimir',
                                style: TextStyle(fontFamily: fontBalooPaaji),
                              ))
                          : const SizedBox(),
                      const Divider(),
                      const SizedBox(height: 50),
                      SizedBox(
                        height: size.height * 0.50,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              chartData.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Text(
                                        'Empleados mas Destacados',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                                fontSize: 16,
                                                color: Colors.black38,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: fontMetalmania,
                                                letterSpacing: 2.0),
                                      ),
                                    )
                                  : const SizedBox(),
                              Column(
                                children: [
                                  usuariosDetacados.isNotEmpty
                                      ? Column(
                                          children: usuariosDetacados
                                              .map(
                                                (e) => Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20),
                                                      child: Text(
                                                        "${e.typeWork} : ${e.fullName.toString()}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall!
                                                            .copyWith(
                                                                fontSize: 12,
                                                                color:
                                                                    colorsBlueDeepHigh,
                                                                fontFamily:
                                                                    fontBalooPaaji),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'Pcs : ${e.cantPieza}'
                                                                .toString(),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleSmall!
                                                                .copyWith(
                                                                  fontSize: 12,
                                                                  color:
                                                                      colorsPuppleOpaco,
                                                                  fontFamily:
                                                                      fontBalooPaaji,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                          const Text('  '),
                                                          Text(
                                                            'De : ${e.toTalDiferences}'
                                                                .toString(),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleSmall!
                                                                .copyWith(
                                                                  fontSize: 12,
                                                                  color:
                                                                      colorsRedOpaco,
                                                                  fontFamily:
                                                                      fontBalooPaaji,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                          const Text('   '),
                                                          Text(
                                                            "${getPocent(int.parse(e.cantPieza ?? '0'), int.parse(e.toTalDiferences ?? '0'))}%"
                                                                .toString(),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleSmall!
                                                                .copyWith(
                                                                  fontSize: 12,
                                                                  color:
                                                                      colorsPuppleOpaco,
                                                                  fontFamily:
                                                                      fontBalooPaaji,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                              .toList(),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Divider(),
                              const SizedBox(height: 10),
                              // chartData.isNotEmpty
                              //     ? RepaintBoundary(
                              //         child: SfCartesianChart(
                              //           title: ChartTitle(
                              //               text: 'Trabajos realizados'),
                              //           legend: Legend(isVisible: true),
                              //           primaryXAxis: CategoryAxis(),
                              //           primaryYAxis: NumericAxis(),
                              //           tooltipBehavior: TooltipBehavior(
                              //             enable: true,
                              //             builder: (dynamic data,
                              //                 dynamic point,
                              //                 dynamic series,
                              //                 int pointIndex,
                              //                 int seriesIndex) {
                              //               return Container(
                              //                 decoration: BoxDecoration(
                              //                   color: _getColor(data.typeWork)
                              //                       .withOpacity(0.9),
                              //                   borderRadius:
                              //                       BorderRadius.circular(5.0),
                              //                 ),
                              //                 padding:
                              //                     const EdgeInsets.all(5.0),
                              //                 child: Text(data.typeWork,
                              //                     style: const TextStyle(
                              //                         color: Colors.white)),
                              //               );
                              //             },
                              //           ),
                              //           series: <CartesianSeries>[
                              //             ColumnSeries<ChartData, String>(
                              //               dataSource: chartData,
                              //               xValueMapper: (ChartData data, _) =>
                              //                   data.fullName,
                              //               yValueMapper: (ChartData data, _) =>
                              //                   data.cantPieza,
                              //               dataLabelSettings:
                              //                   const DataLabelSettings(
                              //                       isVisible: true),
                              //               color: Colors.blue,
                              //               enableTooltip: true,
                              //               isVisibleInLegend: true,
                              //               name: 'Mostrar',
                              //               pointColorMapper: (data, _) =>
                              //                   _getColor(data.typeWork),
                              //             ),
                              //           ],
                              //         ),
                              //       )
                              //     : const SizedBox(),
                              const SizedBox(height: 10),
                              const Divider(),
                              const SizedBox(height: 10),
                              // chartData.isNotEmpty
                              //     ? RepaintBoundary(
                              //         child: SfCircularChart(
                              //           title: ChartTitle(
                              //               text: 'Trabajos realizados Graf'),
                              //           legend: Legend(isVisible: true),
                              //           tooltipBehavior: TooltipBehavior(
                              //             enable: true,
                              //             builder: (dynamic data,
                              //                 dynamic point,
                              //                 dynamic series,
                              //                 int pointIndex,
                              //                 int seriesIndex) {
                              //               return Container(
                              //                 decoration: BoxDecoration(
                              //                   color: _getColor(data.typeWork)
                              //                       .withOpacity(0.9),
                              //                   borderRadius:
                              //                       BorderRadius.circular(5.0),
                              //                 ),
                              //                 padding:
                              //                     const EdgeInsets.all(5.0),
                              //                 child: Text(data.typeWork,
                              //                     style: const TextStyle(
                              //                         color: Colors.white)),
                              //               );
                              //             },
                              //           ),
                              //           series: <CircularSeries>[
                              //             DoughnutSeries<ChartData, String>(
                              //               dataSource: chartData,
                              //               xValueMapper: (ChartData data, _) =>
                              //                   data.fullName,
                              //               yValueMapper: (ChartData data, _) =>
                              //                   data.cantPieza,
                              //               pointColorMapper: (data, _) =>
                              //                   _getColor(data.typeWork),
                              //               dataLabelSettings:
                              //                   const DataLabelSettings(
                              //                       isVisible: true),
                              //               enableTooltip: true,
                              //             )
                              //           ],
                              //         ),
                              //       )
                              //     : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

// class SublimaProduction extends StatefulWidget {
//   const SublimaProduction(
//       {Key? key,
//       required this.current,
//       this.firstDate,
//       this.secondDate,
//       required this.getTotal,
//       required this.departInfo,
//       required this.userHottes})
//       : super(key: key);
//   final TypeWork current;
//   final String? secondDate;
//   final String? firstDate;
//   final Function getTotal;
//   final Function userHottes;
//   final Department departInfo;

//   @override
//   State<SublimaProduction> createState() => _SublimaProductionState();
// }

// class _SublimaProductionState extends State<SublimaProduction> {
//   List<Sublima> list = [];
//   int totalPieza = 0;
//   Sublima? usuarioDestacado;
//   @override
//   void initState() {
//     super.initState();
//     getReports();
//   }

//   empleadoMasDestacado(listAnatily) {
//     // detacadoItem = obtenerNumeroMasAlto(listAnatily);

//     usuarioDestacado = obtenerUsuarioMasDestacado(listAnatily);
//   }

//   Sublima obtenerUsuarioMasDestacado(List<Sublima> lista) {
//     int numeroMasAlto = 0;
//     Sublima? usuarioMasDestacado;
//     for (var item in lista) {
//       int cantidadPiezas = int.parse(item.cantPieza ?? '0');
//       totalPieza += int.parse(item.cantPieza ?? '0');
//       if (cantidadPiezas > numeroMasAlto) {
//         numeroMasAlto = cantidadPiezas;
//         usuarioMasDestacado = item;
//       }
//     }
//     widget.getTotal(totalPieza);
//     widget.userHottes(
//       Sublima(
//           cantPieza: usuarioMasDestacado?.cantPieza,
//           fullName: usuarioMasDestacado?.fullName,
//           toTalDiferences: totalPieza.toString(),
//           typeWork: usuarioMasDestacado?.typeWork),
//     );
//     // print(usuarioMasDestacado);1
//     return usuarioMasDestacado!;
//   }

//   // int obtenerNumeroMasAlto(List<Sublima> lista) {
//   //   List<int> cantidadesPiezas =
//   //       lista.map<int>((item) => int.parse(item.cantPieza ?? '0')).toList();
//   //   int numeroMasAlto = cantidadesPiezas.reduce((valorAnterior, valorActual) =>
//   //       valorAnterior > valorActual ? valorAnterior : valorActual);
//   //   return numeroMasAlto;
//   // }

//   getReports() async {
//     list = await takeWorkseparedWorkType(
//         widget.firstDate, widget.secondDate, widget.current.typeWork);
//     if (list.isNotEmpty) {
//       empleadoMasDestacado(list);
//     }
//     setState(() {});
//   }

//   takeWorkseparedWorkType(date1, date2, typeW) async {
//     //  listTypeTotal.clear();
//     // list.clear;
//     // setState(() {});
//     List<Sublima>? test = [];
//     final res = await httpRequestDatabase(
//         selectSublimacionWorkFinishedGeneralTypeWork,
//         {'date1': date1, 'date2': date2, 'type_work': typeW});
//     // print('Filter $typeW es :  ${res.body}');
//     test = sublimaFromJson(res.body);

//     return test;
//   }

//   String getPocent(int cantPieza, int total) {
//     final result = cantPieza / total * 100;
//     return result.toStringAsFixed(0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     var textSize = 18.0;
//     final size = MediaQuery.of(context).size;
//     // print(size);

//     // /////// de 0 a 600
//     // if (size.width > 0 && size.width <= 600) {
//     //   textSize = size.width * 0.020;
//     // } else {
//     //   textSize = size.width * 0.020;
//     // }
//     return Container(
//       margin: const EdgeInsets.all(10.0),
//       decoration: BoxDecoration(
//           color: colorsGreyWhite, borderRadius: BorderRadius.circular(15)),
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Text(
//               widget.current.typeWork ?? 'N/A',
//               style: Theme.of(context).textTheme.titleSmall!.copyWith(
//                   fontSize: textSize,
//                   color: Colors.black38,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: fontMetalmania,
//                   letterSpacing: 2.0),
//             ),
//           ),
//           SizedBox(
//             height: 10,
//             width: size.width,
//           ),
//           Column(
//             // crossAxisAlignment: CrossAxisAlignment.start,
//             // mainAxisAlignment: MainAxisAlignment.start,
//             children: list
//                 .map((e) => Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: Text(
//                             "Operario : ${e.fullName.toString()}",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleSmall!
//                                 .copyWith(
//                                     fontSize: 12,
//                                     color: colorsBlueDeepHigh,
//                                     fontFamily: fontBalooPaaji),
//                           ),
//                         ),
//                         const Spacer(),
//                         // Text(
//                         //   e.typeWork ?? 'N/A',
//                         //   style: Theme.of(context)
//                         //       .textTheme
//                         //       .subtitle1!
//                         //       .copyWith(
//                         //           fontSize: textSize, color: colorsAd),
//                         // ),
//                         Row(
//                           children: [
//                             Text(
//                                 '${getPocent(int.parse(e.cantPieza.toString()), totalPieza)} %'),
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => DetailsReport(
//                                       current: e,
//                                       departCurrent: widget.departInfo,
//                                       date1: widget.firstDate,
//                                       date2: widget.secondDate,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 20),
//                                 child: Text(
//                                   e.cantPieza.toString(),
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodySmall!
//                                       .copyWith(
//                                         fontSize: textSize,
//                                         color: colorsPuppleOpaco,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ))
//                 .toList(),
//           ),
//           const Divider(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Text(
//                   'Total :',
//                   style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                         fontSize: 12,
//                         color: Colors.black38,
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Text(
//                   totalPieza.toString(),
//                   style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                         fontSize: 12,
//                         color: Colors.black38,
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//               ),
//             ],
//           ),
//           const Divider(),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Text(
//               'Empleado Destacado',
//               style: Theme.of(context).textTheme.titleSmall!.copyWith(
//                     color: Colors.black38,
//                   ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Text(
//                   usuarioDestacado?.fullName ?? 'N/A',
//                   style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                         color: colorsAd,
//                         fontSize: 12,
//                         fontFamily: fontBalooPaaji,
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//                 Text(
//                   usuarioDestacado?.cantPieza ?? 'N/A',
//                   style: Theme.of(context).textTheme.labelSmall!.copyWith(
//                       color: colorsGreenLevel,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: fontBalooPaaji),
//                 ),
//                 SizedBox(
//                   height: 50,
//                   width: 50,
//                   child: Lottie.asset('animation/fire.json',
//                       repeat: true, reverse: true, fit: BoxFit.cover),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class ChartData {
  ChartData(this.fullName, this.cantPieza, this.typeWork);
  final String fullName;
  final int cantPieza;
  final String typeWork;
}

class WorkData {
  final String fullName;
  final int cantPieza;
  final String typeWork;

  WorkData(this.fullName, this.cantPieza, this.typeWork);
}
