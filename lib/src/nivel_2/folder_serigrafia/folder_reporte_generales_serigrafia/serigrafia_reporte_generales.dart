import 'package:flutter/material.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/model/department.dart';
import '/src/model/type_work.dart';
import '/src/nivel_2/folder_serigrafia/folder_reporte_generales_serigrafia/viewer_serigrafia_resumen.dart';
import '/src/nivel_2/folder_serigrafia/url_general_serigrafia/url_general_serigrafia.dart';
import '/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
import '/src/screen_print_pdf/apis/pdf_api.dart';
import '/src/nivel_2/folder_serigrafia/print_serigrafia/reports_general_serigrafia.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/show_mesenger.dart';
import '/src/widgets/loading.dart';
import '../../../datebase/url.dart';
import '../../../util/helper.dart';
import '../../forder_sublimacion/widgets/percent_star.dart';

class SerigrafiaReporteGenerales extends StatefulWidget {
  const SerigrafiaReporteGenerales(
      {super.key, required this.current, required this.listTypeWork});
  final Department current;
  final List<TypeWork> listTypeWork;
  @override
  State<SerigrafiaReporteGenerales> createState() =>
      _SerigrafiaReporteGeneralesState();
}

class _SerigrafiaReporteGeneralesState
    extends State<SerigrafiaReporteGenerales> {
  String? _secondDate = DateTime.now().toString().substring(0, 10);
  String? _firstDate = DateTime.now().toString().substring(0, 10);
  bool isLoading = true;
  List<Sublima> listRanked = [];
  // bool selected = false;
  ////////variable de usuario sin repetir que se encuentran en los resportes///////
  List<String> nombresUnicos = [];
  /////////variale de trabajos unico///////////
  List<String> nombreTrajoUnicos = [];
  List<Sublima> totalTipoTrabajos = [];

  List<Sublima> listColorGot = []; //lista de colores disponible para Full y PKT
  ////lista unica para los colores ///
  List<String> workNameList = ['PINTANDO', 'CUADRAR MARCOS'];

  List<Sublima> listReport = [];
  Map dataReported = {};

  ////////////este metodo convierta la el map de resports a una lista de <String>////////////////////
  List<List<String>> tableData = [];
  List<List<String>> tableDataFullPintado = [];
  List<List<String>> tableDataPKTPintado = [];
  List<List<String>> tableDataFullCuadrar = [];
  List<List<String>> tableDataPKTCuadrar = [];

  ///////////variable full and PKt por colors de PINTANDO WorkName //////////
  Map dataFullPintando = {};
  Map dataPktPintando = {};

  ///////////variable full and PKt por colors de CUADRAR MARCO WorkName //////////
  Map dataFullCuadrarMarcos = {};
  Map dataPktCuadrarMarcos = {};

  // void cargarReport() {
  //   isLoading = !isLoading;
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    getRankingUsuario();
    verifyTipoTrabajos();
    getReports(_firstDate, _secondDate);
  }

  getReports(date1, date2) async {
    final res = await httpRequestDatabase(
        selectSerigrafiaWorkFinishedReportGeneral,
        {'date1': date1, 'date2': date2});
    // print('Report : ${res.body}');
    listReport = sublimaFromJson(res.body);
    if (listReport.isNotEmpty) {
      totalTipoTrabajos.clear();
      dataFullPintando = {};
      dataFullCuadrarMarcos = {};
      dataPktCuadrarMarcos = {};
      dataPktPintando = {};
      listColorGot.clear();
      takeUserWithoutRepet();
      simplificarWorkReports();
      getReportFullColor();
      // await Future.delayed(const Duration(seconds: 2));
      for (var work in nombreTrajoUnicos) {
        tomarUsuariosDestacados(work);
      }
      await Future.delayed(const Duration(seconds: 5));
      convertirDataEnListString();
      waitingAnimation();
    } else {
      if (mounted) utilShowMesenger(context, 'No hay Reportes');
    }
  }

  waitingAnimation() async {
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) {
      return;
    }

    setState(() {
      isLoading = false;
    });
  }

  int totalPieza = 0;
  // List<Sublima> userHots = [];

  String getPocent(int cantPieza, int total) {
    final result = cantPieza / total * 100;
    return result.toStringAsFixed(0);
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////metodo para obtener todo los usuario de la lista sin repetir////////
  void takeUserWithoutRepet() async {
    dataFullPintando = {};
    dataPktPintando = {};
    dataFullCuadrarMarcos = {};
    dataPktCuadrarMarcos = {};

    List<String> uniqueNames = [];
    List<Sublima> users = [...listReport];

    uniqueNames = users.toSet().map((user) => user.fullName ?? 'N/A').toList();
    nombresUnicos = uniqueNames.toSet().toList();

    ///este ciclo for es para agregar los nombre a los tipo de trabajo
    ///por ejemplo Alex {'Calandra':'0'} ////////
    for (var fullName in nombresUnicos) {
      dataReported[fullName] = {nombreTrajoUnicos.first: '0'};
      dataFullPintando[fullName] = {1: '0'};
      dataPktPintando[fullName] = {1: '0'};
      dataFullCuadrarMarcos[fullName] = {1: '0'};
      dataPktCuadrarMarcos[fullName] = {1: '0'};
      // dataReportFull[fullName] = {nombreTrajoUnicos.first: '0'};
      // dataReportPKT[fullName] = {nombreTrajoUnicos.first: '0'};
    }
    // print('dataReported : ${dataReported}');
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

//////////////-------------------------------------------/////////////////////////
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
    // print('Informa General Es:  $dataReported');
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

  //////////////metodo para tomar los colores Full por tipo de trabajos///////
  void obtenerFullPorColoresPintado(nameWork) {
    List numberList = [1, 2, 3, 4, 5, 6, 7];

    ////eligiendo los usuarios ////////////
    for (var userElement in nombresUnicos) {
      ////////////ciclo for de los trabajo para clasificar///////////////
      for (var indexList in numberList) {
        /////ciclo for para los trabajos agrupado y sumar los dFull ///////////

        List<Sublima> workAgrupado = fitrarColorFull(
            indexList.toString(), userElement.toString(), nameWork);
        int value = 0;

        /////////proceder agregar al map nuevo los siguiente
        for (var work in workAgrupado) {
          value += int.parse(work.dFull ?? '0');
        }

        if (indexList == 7) {
          Map sumValues = dataFullPintando[userElement];

          // Map<String, String> miMapa = {'1': '10', '2': '20', '3': '30'};

          Map<int, int> nuevoMapa = {};

          sumValues.forEach((key, value) {
            nuevoMapa[int.parse(key.toString())] = int.parse(value.toString());
          });

          int sum = nuevoMapa.values.reduce((prev, value) => prev + value);

          // print('variable ${sumValues}');

          dataFullPintando[userElement][indexList] = sum.toString();
        } else {
          dataFullPintando[userElement][indexList] = value.toString();
        }
      }
    }

    // print('Full Colore Por Usuario es :   $dataFull');
  }

  //////////////metodo para tomar los colores PKT por tipo de trabajos///////
  void obtenerPKTPorColoresPintado(nameWork) {
    List numberList = [1, 2, 3, 4, 5, 6, 7];

    ////eligiendo los usuarios ////////////
    for (var userElement in nombresUnicos) {
      ////////////ciclo for de los trabajo para clasificar///////////////
      for (var indexList in numberList) {
        /////ciclo for para los trabajos agrupado y sumar los dFull ///////////

        List<Sublima> workAgrupado = fitrarColoPKT(
            indexList.toString(), userElement.toString(), nameWork);
        int value = 0;

        /////////proceder agregar al map nuevo los siguiente
        for (var work in workAgrupado) {
          value += int.parse(work.pkt ?? '0');
        }

        if (indexList == 7) {
          Map sumValues = dataPktPintando[userElement];

          // Map<String, String> miMapa = {'1': '10', '2': '20', '3': '30'};

          Map<int, int> nuevoMapa = {};

          sumValues.forEach((key, value) {
            nuevoMapa[int.parse(key.toString())] = int.parse(value.toString());
          });

          int sum = nuevoMapa.values.reduce((prev, value) => prev + value);

          // print('variable ${sumValues}');

          dataPktPintando[userElement][indexList] = sum.toString();
        } else {
          dataPktPintando[userElement][indexList] = value.toString();
        }
      }
    }

    // print('dataPkt Colore Por Usuario es :   $dataPkt');
  }

////////////// filtrar todo los trabajo y revisar cuales tiene full  por colores De Pintando////////////
  List<Sublima> fitrarColorFull(String val, String name, String work) {
    // print('val: $val, name: $name, work : $work');
    // print('Lista clasificada ${listColorGot.length}');
    // print(
    //     'index 0 Current FullName ${listColorGot.first.fullName} colorFull ${listColorGot.first.colorfull} work : ${listColorGot.first.nameWork}');
    // print('Val ${val}');
    // print('name ${name}');
    // print('work ${work}');
    List<Sublima> listLocal = List.from(listColorGot
        .where((x) =>
            x.typeWork!.toUpperCase().contains(work.toUpperCase()) &&
            x.colorfull!.toUpperCase().contains(val.toUpperCase()) &&
            x.fullName!.toUpperCase().contains(name.toUpperCase()))
        .toList());

    // print('Retorno : ${listColorGot.length}');

    return listLocal;
  }

////////////// filtrar todo los trabajo y revisar cuales tiene pkt por colores Pintado////////////
  List<Sublima> fitrarColoPKT(String val, String name, String work) {
    List<Sublima> listLocal = List.from(listColorGot
        .where((x) =>
            x.typeWork!.toUpperCase().contains(work.toUpperCase()) &&
            x.colorpkt!.toUpperCase().contains(val.toUpperCase()) &&
            x.fullName!.toUpperCase().contains(name.toUpperCase()))
        .toList());

    return listLocal;
  }

/////////////api para obtener lo tres tipos de trabajo sumado de full y pkt
  Future getReportFullColor() async {
    List<Sublima> listColor = [];
    // print('workNameList : ${workNameList}');
    for (var elementName in workNameList) {
      listColor = await takeWorkseparedWorkTypeColorFull(
          _firstDate, _secondDate, elementName);
      // print('Work $elementName');
      // print('listColor length ${listColor.length}');
      // print('Listado de usuario :');
      for (var resqued in listColor) {
        // print(resqued.fullName);
        listColorGot.add(resqued);
      }
      // print('Listado Fin:');
    }

    // print('Total de trabajo de colores Obtenido ${listColorGot.length}');
    obtenerFullPorColoresPintado('PINTANDO');
    obtenerPKTPorColoresPintado('PINTANDO');
    obtenerFullPorColoresCUADRARMARCOS('CUADRAR MARCOS');
    obtenerPKTColoresPintadoCUADRARMARCOS('CUADRAR MARCOS');
  }

////api resquest ////
  takeWorkseparedWorkTypeColorFull(date1, date2, typeW) async {
    List<Sublima>? testColor = [];
    final res = await httpRequestDatabase(selectSerigrafiaPickColorFull,
        {'date1': date1, 'date2': date2, 'type_work': typeW});
    // print('FilterColors $typeW es :  ${res.body}');
    testColor = sublimaFromJson(res.body);
    return testColor;
  }

  ////////////////////////////////////////////////////////////////////////////
  //-------------------------------------------------------------------------//

  //////////////metodo para tomar los colores Full por tipo de trabajos CUADRAR MARCOS///////
  void obtenerFullPorColoresCUADRARMARCOS(nameWork) {
    List numberList = [1, 2, 3, 4, 5, 6, 7];

    ////eligiendo los usuarios ////////////
    for (var userElement in nombresUnicos) {
      ////////////ciclo for de los trabajo para clasificar///////////////
      for (var indexList in numberList) {
        /////ciclo for para los trabajos agrupado y sumar los dFull ///////////

        List<Sublima> workAgrupado = fitrarColorFull(
            indexList.toString(), userElement.toString(), nameWork);
        int value = 0;

        /////////proceder agregar al map nuevo los siguiente
        for (var work in workAgrupado) {
          value += int.parse(work.dFull ?? '0');
        }

        if (indexList == 7) {
          Map sumValues = dataFullCuadrarMarcos[userElement];

          // Map<String, String> miMapa = {'1': '10', '2': '20', '3': '30'};

          Map<int, int> nuevoMapa = {};

          sumValues.forEach((key, value) {
            nuevoMapa[int.parse(key.toString())] = int.parse(value.toString());
          });

          int sum = nuevoMapa.values.reduce((prev, value) => prev + value);

          // print('variable ${sumValues}');

          dataFullCuadrarMarcos[userElement][indexList] = sum.toString();
        } else {
          dataFullCuadrarMarcos[userElement][indexList] = value.toString();
        }
      }
    }

    // print('dataFullCuadrarMarcos Por Usuario es :   $dataFullCuadrarMarcos');
  }

  //////////////metodo para tomar los colores PKT por tipo de trabajos CUADRAR MARCOS///////
  void obtenerPKTColoresPintadoCUADRARMARCOS(nameWork) {
    List numberList = [1, 2, 3, 4, 5, 6, 7];

    ////eligiendo los usuarios ////////////
    for (var userElement in nombresUnicos) {
      ////////////ciclo for de los trabajo para clasificar///////////////
      for (var indexList in numberList) {
        /////ciclo for para los trabajos agrupado y sumar los dFull ///////////

        List<Sublima> workAgrupado = fitrarColoPKT(
            indexList.toString(), userElement.toString(), nameWork);
        int value = 0;

        /////////proceder agregar al map nuevo los siguiente
        for (var work in workAgrupado) {
          value += int.parse(work.pkt ?? '0');
        }

        if (indexList == 7) {
          Map sumValues = dataPktCuadrarMarcos[userElement];

          // Map<String, String> miMapa = {'1': '10', '2': '20', '3': '30'};

          Map<int, int> nuevoMapa = {};

          sumValues.forEach((key, value) {
            nuevoMapa[int.parse(key.toString())] = int.parse(value.toString());
          });

          int sum = nuevoMapa.values.reduce((prev, value) => prev + value);

          // print('variable ${sumValues}');

          dataPktCuadrarMarcos[userElement][indexList] = sum.toString();
        } else {
          dataPktCuadrarMarcos[userElement][indexList] = value.toString();
        }
      }
    }

    // print('dataPkt Colore Por Usuario es :   $dataPkt');
  }

///////----------------------------------------------/////////////////
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

  ///////////////////////
  convertirDataEnListString() {
    for (var employee in dataReported.entries) {
      List<String> row = [
        employee.key,
        employee.value['PINTANDO'].toString(),
        employee.value['QUEMADO'].toString(),
        employee.value['HORNO'].toString(),
        employee.value['CUADRAR MARCOS'].toString(),
        employee.value['BORRAR MARCOS'].toString(),
        employee.value['PLANCHANDO'].toString(),
        employee.value['EMPAQUE'].toString(),
        employee.value['Total'].toString(),
      ];
      tableData.add(row);
    }
    for (var employee in dataFullPintando.entries) {
      List<String> row = [
        employee.key,
        employee.value[1].toString(),
        employee.value[2].toString(),
        employee.value[3].toString(),
        employee.value[4].toString(),
        employee.value[5].toString(),
        employee.value[6].toString(),
        employee.value[7].toString(),
      ];
      tableDataFullPintado.add(row);
    }
    // print('tableDataFull  ${tableDataFull}');
    for (var employee in dataPktPintando.entries) {
      // print('ROW  employee.value : ${employee.value}');
      List<String> row = [
        employee.key,
        employee.value[1].toString(),
        employee.value[2].toString(),
        employee.value[3].toString(),
        employee.value[4].toString(),
        employee.value[5].toString(),
        employee.value[6].toString(),
        employee.value[7].toString(),
      ];
      tableDataPKTPintado.add(row);
    }
    // print('tableDataPKT  ${tableDataPKT}');

    for (var employee in dataFullCuadrarMarcos.entries) {
      // print('ROW  employee.value : ${employee.value}');
      List<String> row = [
        employee.key,
        employee.value[1].toString(),
        employee.value[2].toString(),
        employee.value[3].toString(),
        employee.value[4].toString(),
        employee.value[5].toString(),
        employee.value[6].toString(),
        employee.value[7].toString(),
      ];
      tableDataFullCuadrar.add(row);
    }
    /////////-----------------------//
    // print('tableDataPKT  ${tableDataPKT}');

    for (var employee in dataPktCuadrarMarcos.entries) {
      // print('ROW  employee.value : ${employee.value}');
      List<String> row = [
        employee.key,
        employee.value[1].toString(),
        employee.value[2].toString(),
        employee.value[3].toString(),
        employee.value[4].toString(),
        employee.value[5].toString(),
        employee.value[6].toString(),
        employee.value[7].toString(),
      ];
      tableDataPKTCuadrar.add(row);
    }
  }

  Future getRankingUsuario() async {
    String url =
        "http://$ipLocal/settingmat/admin/select/select_serigrafia_ranking_usuario.php";
    final res = await httpRequestDatabase(
        url, {'date1': _firstDate, 'date2': _secondDate});
    listRanked = sublimaFromJson(res.body);
  }

  /////Ver select_serigrafia_viewer
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final style = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen Serigrafia'),
        actions: [
          IconButton(
              onPressed: () async {
                final pdfFile = await PdfReportsGeneralSerigrafia.generate(
                    tableData,
                    totalTipoTrabajos,
                    '$_firstDate - $_secondDate',
                    tableDataFullPintado,
                    tableDataPKTPintado,
                    tableDataFullCuadrar,
                    tableDataPKTCuadrar);

                PdfApi.openFile(pdfFile);
              },
              icon: const Icon(Icons.print)),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
                onPressed: () {
                  selectDateRange(context, (date1, date2) {
                    _firstDate = date1;
                    _secondDate = date2;
                    getRankingUsuario();
                    setState(() {
                      isLoading = true;
                    });
                    getReports(_firstDate, _secondDate);
                  });
                },
                icon: const Icon(Icons.calendar_month)),
          )
        ],
      ),
      body: isLoading
          ? Loading(isLoading: isLoading)
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: listRanked
                              .map(
                                (e) => SizedBox(
                                  width: 225,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                        backgroundColor: ktejidoblueOpaco,
                                        child: Text(
                                            e.fullName
                                                .toString()
                                                .substring(0, 1),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                    color: Colors.white))),
                                    title: Tooltip(
                                        message: e.fullName.toString(),
                                        child: Text(e.fullName ?? 'N/A',
                                            maxLines: 1)),
                                    subtitle: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        StarRating(
                                            percent:
                                                int.parse(e.rating ?? '0')),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: DataTable(
                        dataRowMaxHeight: 20,
                        dataRowMinHeight: 15,
                        horizontalMargin: 10.0,
                        columnSpacing: 15,
                        headingRowHeight: 20,
                        headingTextStyle: style.bodySmall,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 205, 208, 221),
                              Color.fromARGB(255, 225, 228, 241),
                              Color.fromARGB(255, 233, 234, 238),
                            ],
                          ),
                        ),
                        columns: const [
                          DataColumn(label: Text('Empleados')),
                          DataColumn(label: Text('PINTANDO')),
                          DataColumn(label: Text('QUEMADO')),
                          DataColumn(label: Text('HORNO')),
                          DataColumn(label: Text('CUADRAR MARCOS')),
                          DataColumn(label: Text('BORRAR MARCOS')),
                          DataColumn(label: Text('PLANCHANDO')),
                          DataColumn(label: Text('EMPAQUE')),
                          DataColumn(label: Text('Total'))
                        ],
                        rows: dataReported.entries.map<DataRow>(
                          (entry) {
                            List<DataCell> cells = [
                              DataCell(Text(entry.key)),
                            ];
                            entry.value.forEach((day, value) {
                              cells.add(DataCell(TextButton(
                                  onPressed: () async {
                                    print(
                                        'Tipo de trabajo :$day de ${entry.key}');
                                    var data = {
                                      'date1': _firstDate,
                                      'date2': _secondDate,
                                      'full_name': entry.key,
                                      'type_work': day.toString().toUpperCase()
                                    };
                                    print('data : $data');
                                    await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return MyWidgetViewerSerigrafiaResumen(
                                              data: data);
                                        });
                                    // print('entry.key /: ${entry.key}');
                                    // print();
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (_) =>
                                    //         SerigrafiaDetallesReportGeneral(
                                    //       current: widget.current,
                                    //       userName: entry.key,
                                    //       firstDate: _firstDate,
                                    //       secondDate: _secondDate,
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  child: Text(value))));
                            });
                            return DataRow(
                                cells: cells,
                                color: MaterialStateColor.resolveWith(
                                    (states) => Colors.white));
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  totalTipoTrabajos.isEmpty
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: SizedBox(
                            height: 20,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                  children: totalTipoTrabajos.map((e) {
                                    return Container(
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
                                              Text(e.typeWork ?? '-',
                                                  style: style.bodySmall),
                                              const SizedBox(width: 10),
                                              Text(e.toTalDiferences ?? '0',
                                                  style: style.bodySmall
                                                      ?.copyWith(
                                                          color: Colors.brown,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                )),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: SizedBox(
                      height: 350,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 200,
                            width: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset('assets/serigrafia.jpg',
                                  fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('PIEZAS FULL PINTADO',
                                  style: style.labelLarge),
                              SizedBox(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      dataRowMaxHeight: 20,
                                      dataRowMinHeight: 15,
                                      horizontalMargin: 10.0,
                                      columnSpacing: 15,
                                      headingRowHeight: 20,
                                      headingRowColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => const Color.fromARGB(
                                                      255, 252, 144, 98)
                                                  .withOpacity(0.3)),
                                      columns: const [
                                        DataColumn(label: Text('Nombre')),
                                        // DataColumn(label: Text('C-0')),
                                        DataColumn(label: Text('C-1')),
                                        DataColumn(label: Text('C-2')),
                                        DataColumn(label: Text('C-3')),
                                        DataColumn(label: Text('C-4')),
                                        DataColumn(label: Text('C-5')),
                                        DataColumn(label: Text('C-6')),
                                        DataColumn(label: Text('Total')),
                                      ],
                                      rows: dataFullPintando.entries
                                          .map<DataRow>((entry) {
                                        List<DataCell> cells = [
                                          DataCell(Text(entry.key)),
                                        ];
                                        entry.value.forEach((day, value) {
                                          cells.add(DataCell(Text(value)));
                                        });
                                        return DataRow(
                                            cells: cells,
                                            color:
                                                MaterialStateColor.resolveWith(
                                                    (states) => Colors.white));
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                              Text('PIEZAS PKT PINTANDO',
                                  style: style.labelLarge),
                              SizedBox(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      dataRowMaxHeight: 20,
                                      dataRowMinHeight: 15,
                                      horizontalMargin: 10.0,
                                      columnSpacing: 15,
                                      headingRowHeight: 20,
                                      headingRowColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => const Color.fromARGB(
                                                      255, 252, 144, 98)
                                                  .withOpacity(0.3)),
                                      columns: const [
                                        DataColumn(label: Text('Nombre')),
                                        // DataColumn(label: Text('C-0')),
                                        DataColumn(label: Text('C-1')),
                                        DataColumn(label: Text('C-2')),
                                        DataColumn(label: Text('C-3')),
                                        DataColumn(label: Text('C-4')),
                                        DataColumn(label: Text('C-5')),
                                        DataColumn(label: Text('C-6')),
                                        DataColumn(label: Text('Total')),
                                      ],
                                      rows: dataPktPintando.entries
                                          .map<DataRow>((entry) {
                                        List<DataCell> cells = [
                                          DataCell(Text(entry.key)),
                                        ];
                                        entry.value.forEach((day, value) {
                                          cells.add(DataCell(Text(value)));
                                        });
                                        return DataRow(
                                            cells: cells,
                                            color:
                                                MaterialStateColor.resolveWith(
                                                    (states) => Colors.white));
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: SizedBox(
                      height: 350,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 200,
                            width: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset('assets/MARCOS.jpg',
                                  fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('CUADRAR MARCOS PIEZAS FULL',
                                  style: style.labelLarge),
                              SizedBox(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      dataRowMaxHeight: 20,
                                      dataRowMinHeight: 15,
                                      horizontalMargin: 10.0,
                                      columnSpacing: 15,
                                      headingRowHeight: 20,
                                      headingRowColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => const Color.fromARGB(
                                                      255, 242, 192, 106)
                                                  .withOpacity(0.3)),
                                      columns: const [
                                        DataColumn(label: Text('Nombre')),
                                        // DataColumn(label: Text('C-0')),
                                        DataColumn(label: Text('C-1')),
                                        DataColumn(label: Text('C-2')),
                                        DataColumn(label: Text('C-3')),
                                        DataColumn(label: Text('C-4')),
                                        DataColumn(label: Text('C-5')),
                                        DataColumn(label: Text('C-6')),
                                        DataColumn(label: Text('Total')),
                                      ],
                                      rows: dataFullCuadrarMarcos.entries
                                          .map<DataRow>((entry) {
                                        List<DataCell> cells = [
                                          DataCell(Text(entry.key)),
                                        ];
                                        entry.value.forEach((day, value) {
                                          cells.add(DataCell(Text(value)));
                                        });
                                        return DataRow(
                                            cells: cells,
                                            color:
                                                MaterialStateColor.resolveWith(
                                                    (states) => Colors.white));
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                              Text('CUADRAR MARCOS PIEZAS PKT',
                                  style: style.labelLarge),
                              SizedBox(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      dataRowMaxHeight: 20,
                                      dataRowMinHeight: 15,
                                      horizontalMargin: 10.0,
                                      columnSpacing: 15,
                                      headingRowHeight: 20,
                                      headingRowColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => const Color.fromARGB(
                                                      255, 242, 192, 106)
                                                  .withOpacity(0.3)),
                                      columns: const [
                                        DataColumn(label: Text('Nombre')),
                                        // DataColumn(label: Text('C-0')),
                                        DataColumn(label: Text('C-1')),
                                        DataColumn(label: Text('C-2')),
                                        DataColumn(label: Text('C-3')),
                                        DataColumn(label: Text('C-4')),
                                        DataColumn(label: Text('C-5')),
                                        DataColumn(label: Text('C-6')),
                                        DataColumn(label: Text('Total')),
                                      ],
                                      rows: dataPktCuadrarMarcos.entries
                                          .map<DataRow>((entry) {
                                        List<DataCell> cells = [
                                          DataCell(Text(entry.key)),
                                        ];
                                        entry.value.forEach((day, value) {
                                          cells.add(DataCell(Text(value)));
                                        });
                                        return DataRow(
                                            cells: cells,
                                            color:
                                                MaterialStateColor.resolveWith(
                                                    (states) => Colors.white));
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  identy(context),
                ],
              ),
            ),
    );
  }
}

// class SerigraProduction extends StatefulWidget {
//   const SerigraProduction(
//       {Key? key,
//       required this.current,
//       this.firstDate,
//       this.secondDate,
//       required this.departInfo,
//       required this.getTotal,
//       required this.userHottes})
//       : super(key: key);
//   final TypeWork current;
//   final String? secondDate;
//   final String? firstDate;
//   final Function getTotal;
//   final Function userHottes;
//   final Department departInfo;

//   @override
//   State<SerigraProduction> createState() => _SerigraProductionState();
// }

// class _SerigraProductionState extends State<SerigraProduction> {
//   List<Sublima> list = [];
//   List<Sublima> listColor = [];
//   List<Sublima> listTakenColor = [];
//   List regla = [0, 1, 2, 3, 4, 5, 6];
//   int totalPieza = 0;
//   Sublima? usuarioDestacado;
//   @override
//   void initState() {
//     super.initState();

//     getReports();
//     print('inited');
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
//     listColor = await takeWorkseparedWorkTypeColorFull(
//         widget.firstDate, widget.secondDate, widget.current.typeWork);
//     // print('List Colors${listColor.length}');

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
//         selectSerigrafiaWorkFinishedGeneralByTypeWorkTest,
//         {'date1': date1, 'date2': date2, 'type_work': typeW});
//     // print('Filter $typeW es :  ${res.body}');
//     test = sublimaFromJson(res.body);

//     return test;
//   }

//   takeWorkseparedWorkTypeColorFull(date1, date2, typeW) async {
//     List<Sublima>? testColor = [];
//     final res = await httpRequestDatabase(selectSerigrafiaPickColorFull,
//         {'date1': date1, 'date2': date2, 'type_work': typeW});
//     // print('FilterColors $typeW es :  ${res.body}');
//     testColor = sublimaFromJson(res.body);
//     return testColor;
//   }

//   String getPocent(int cantPieza, int total) {
//     final result = cantPieza / total * 100;
//     return result.toStringAsFixed(0);
//   }

//   List<String> uniqueNames = [];
//   List<String> nombresUnicos = [];

//   void tomaruser() async {
//     List<Sublima> users = [...listColor];
//     uniqueNames = users.toSet().map((user) => user.fullName ?? 'N/A').toList();

//     nombresUnicos = uniqueNames.toSet().toList();
//     // print(nombresUnicos);
//     for (var eleme in nombresUnicos) {
//       // print('Agregando a $eleme');
//       dataFull[eleme] = {1: '0'};
//       dataPkt[eleme] = {1: '0'};
//       // print('usuario Agregado a $dataFull');
//       // await Future.delayed(const Duration(milliseconds: 300));
//     }
//     print('dataFull ${dataFull}');
//   }

//   void simplificarFull() {
//     List numberList = [1, 2, 3, 4, 5, 6, 7];
//     ////eligiendo los usuarios ////////////
//     for (var userElement in nombresUnicos) {
//       ////////////ciclo for de los trabajo para clasificar///////////////
//       for (var numWork in numberList) {
//         /////ciclo for para los trabajos agrupado y sumar los dFull ///////////

//         List<Sublima> workAgrupado =
//             fitrarColorFull(numWork.toString(), userElement.toString());

//         int value = 1;

//         /////////proceder agregar al map nuevo los siguiente
//         for (var work in workAgrupado) {
//           value += int.parse(work.dFull ?? '0');
//         }

//         if (numWork == 7) {
//           Map sumValues = dataFull[userElement];

//           // Map<String, String> miMapa = {'1': '10', '2': '20', '3': '30'};

//           Map<int, int> nuevoMapa = {};

//           sumValues.forEach((key, value) {
//             nuevoMapa[int.parse(key.toString())] = int.parse(value.toString());
//           });

//           int sum = nuevoMapa.values.reduce((prev, value) => prev + value);

//           // print('variable ${sumValues}');

//           dataFull[userElement][numWork] = sum.toString();
//         } else {
//           dataFull[userElement][numWork] = value.toString();
//         }
//       }
//     }
//     // print('Data Es:  ${dataFull}');
//   }

//   void simplificarPkt() {
//     List numberList = [1, 2, 3, 4, 5, 6, 7];
//     ////eligiendo los usuarios ////////////
//     for (var userElement in nombresUnicos) {
//       ////////////ciclo for de los trabajo para clasificar///////////////
//       for (var numWork in numberList) {
//         /////ciclo for para los trabajos agrupado y sumar los dFull ///////////
//         List<Sublima> workAgrupado =
//             fitrarColoPKT(numWork.toString(), userElement.toString());
//         // print('Tamono De la lista ${workAgrupado.length}');
//         // print(numWork);
//         int value = 0;
//         /////////proceder agregar al map nuevo los siguiente
//         for (var work in workAgrupado) {
//           value += int.parse(work.pkt ?? '0');
//           // print('Valor sumando ${value}');
//         }
//         if (numWork == 7) {
//           Map sumValues = dataPkt[userElement];

//           // Map<String, String> miMapa = {'1': '10', '2': '20', '3': '30'};

//           Map<int, int> nuevoMapa = {};

//           sumValues.forEach((key, value) {
//             nuevoMapa[int.parse(key.toString())] = int.parse(value.toString());
//           });

//           int sum = nuevoMapa.values.reduce((prev, value) => prev + value);

//           // print('variable ${sumValues}');

//           dataPkt[userElement][numWork] = sum.toString();
//         } else {
//           dataPkt[userElement][numWork] = value.toString();
//         }
//       }
//     }
//     // print('Data Es:  ${dataFull}');
//   }

//   List<Sublima> fitrarListName(val) {
//     List<Sublima> listLocal = List.from(listColor
//         .where((x) => x.fullName!.toUpperCase().contains(val.toUpperCase()))
//         .toList());

//     return listLocal;
//   }

//   List<Sublima> fitrarColorFull(val, name) {
//     List<Sublima> listLocal = List.from(listColor
//         .where((x) =>
//             x.colorfull!.toUpperCase().contains(val.toUpperCase()) &&
//             x.fullName!.toUpperCase().contains(name.toUpperCase()))
//         .toList());

//     return listLocal;
//   }

//   List<Sublima> fitrarColoPKT(val, name) {
//     List<Sublima> listLocal = List.from(listColor
//         .where((x) =>
//             x.colorpkt!.toUpperCase().contains(val.toUpperCase()) &&
//             x.fullName!.toUpperCase().contains(name.toUpperCase()))
//         .toList());

//     return listLocal;
//   }

//   @override
//   Widget build(BuildContext context) {
//     var textSize = 18.0;
//     final size = MediaQuery.of(context).size;
//     const styleText = TextStyle(fontSize: 13);
//     if (widget.current.typeWork == 'PINTANDO' ||
//         widget.current.typeWork == 'CUADRAR MARCOS' ||
//         widget.current.typeWork == 'BORRAR MARCOS') {
//       tomaruser();
//       simplificarFull();
//       simplificarPkt();
//       // print(listColor.length);
//       // print('----------- Full ----------------');
//       // for (var element in listColor) {
//       //   print(
//       //       'usuario : ${element.fullName} , DFull:  ${element.dFull}  con cantColor : ${element.colorfull} mas Pieza ${element.cantPieza}');
//       // }
//       // print('-----------PKT----------------');
//       // for (var element in listColor) {
//       //   print(
//       //       'usuario : ${element.fullName} , DFull:  ${element.pkt}  con cantColor : ${element.colorpkt} mas Pieza ${element.cantPieza}');
//       // }
//     }
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
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//             child: SizedBox(
//               child: Table(
//                 border: TableBorder.all(),
//                 textDirection: TextDirection.ltr,
//                 columnWidths: const {
//                   0: FlexColumnWidth(5),
//                   1: FlexColumnWidth(2),
//                   2: FlexColumnWidth(3),
//                   3: FlexColumnWidth(2),
//                   4: FlexColumnWidth(2),
//                   5: FlexColumnWidth(2),
//                   6: FlexColumnWidth(3),
//                   7: FlexColumnWidth(3),
//                 },
//                 children: [
//                   TableRow(
//                     decoration: BoxDecoration(color: colorsAd.withOpacity(0.1)),
//                     children: [
//                       const TableCell(
//                           child: Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Text('Operario', style: styleText),
//                       )),
//                       TableCell(
//                           child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('Per %',
//                             style:
//                                 styleText.copyWith(color: colorsBlueTurquesa)),
//                       )),
//                       const TableCell(
//                           child: Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Text('Cant', style: styleText),
//                       )),
//                       const TableCell(
//                           child: Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Text('Full Color', style: styleText),
//                       )),
//                       // TableCell(
//                       //     child: Padding(
//                       //   padding: EdgeInsets.all(8.0),
//                       //   child: Text('Color', style: styleText),
//                       // )),
//                       const TableCell(
//                           child: Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Text('PKT', style: styleText),
//                       )),
//                       // TableCell(
//                       //     child: Padding(
//                       //   padding: EdgeInsets.all(8.0),
//                       //   child: Text('Color', style: styleText),
//                       // )),

//                       const TableCell(
//                           child: Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Text('Tiempo', style: styleText),
//                       )),
//                     ],
//                   ),
//                   for (var operario in list)
//                     TableRow(
//                       children: [
//                         TableCell(
//                             child: Text(operario.fullName ?? '',
//                                 style: styleText)),
//                         TableCell(
//                             child: Padding(
//                           padding: const EdgeInsets.only(left: 3),
//                           child: Text(
//                               '${getPocent(int.parse(operario.cantPieza ?? ''), totalPieza)} %',
//                               style: styleText.copyWith(
//                                   color: colorsBlueTurquesa,
//                                   fontWeight: FontWeight.bold)),
//                         )),
//                         TableCell(
//                             child: Padding(
//                           padding: const EdgeInsets.only(left: 3),
//                           child:
//                               Text(operario.cantPieza ?? '', style: styleText),
//                         )),
//                         TableCell(
//                             child: Padding(
//                           padding: const EdgeInsets.only(left: 3),
//                           child: Text(operario.dFull ?? '', style: styleText),
//                         )),
//                         // TableCell(
//                         //     child: Padding(
//                         //   padding: const EdgeInsets.only(left: 3),
//                         //   child:
//                         //       Text(operario.colorfull ?? '', style: styleText),
//                         // )),
//                         TableCell(
//                             child: Padding(
//                           padding: const EdgeInsets.only(left: 3),
//                           child:
//                               Text(operario.pkt.toString(), style: styleText),
//                         )),
//                         // TableCell(
//                         //     child: Padding(
//                         //   padding: const EdgeInsets.only(left: 3),
//                         //   child: Text(operario.colorpkt.toString(),
//                         //       style: styleText),
//                         // )),

//                         TableCell(
//                             child: Padding(
//                           padding: const EdgeInsets.only(left: 3),
//                           child:
//                               Text(operario.totalTime ?? '', style: styleText),
//                         )),
//                       ],
//                     ),
//                   TableRow(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('Total',
//                             style: styleText.copyWith(
//                                 fontWeight: FontWeight.bold)),
//                       ),
//                       const SizedBox(),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('$totalPieza',
//                             style: styleText.copyWith(
//                                 fontWeight: FontWeight.bold)),
//                       ),
//                       const SizedBox(),
//                       // const SizedBox(),
//                       // const SizedBox(),
//                       const SizedBox(),

//                       const SizedBox(),
//                     ],
//                   ),
//                   TableRow(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(5.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Text('Empleado \nDestacado',
//                                 style: styleText),
//                             Text(usuarioDestacado?.fullName ?? 'N/A',
//                                 style: styleText.copyWith(
//                                     fontWeight: FontWeight.bold,
//                                     color: colorsPuppleOpaco)),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(usuarioDestacado?.cantPieza ?? 'N/A',
//                             style: styleText.copyWith(
//                                 fontWeight: FontWeight.bold)),
//                       ),
//                       const SizedBox(),
//                       const SizedBox(),
//                       // const SizedBox(),
//                       // SizedBox(
//                       //   height: 50,

//                       const SizedBox(),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           widget.current.typeWork == 'PINTANDO' ||
//                   widget.current.typeWork == 'CUADRAR MARCOS' ||
//                   widget.current.typeWork == 'BORRAR MARCOS'
//               ? Column(
//                   children: [
//                     const Divider(),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const [
//                         Text(
//                           'Pieza por cantidad de colores FULL',
//                           style: TextStyle(
//                               color: colorsBlueDeepHigh,
//                               fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: DataTable(
//                         dataTextStyle: const TextStyle(
//                             fontSize: 10,
//                             color: colorsAd,
//                             fontWeight: FontWeight.bold),
//                         headingTextStyle: const TextStyle(
//                             fontSize: 10,
//                             color: colorsAd,
//                             fontWeight: FontWeight.w600),
//                         dataRowHeight: 15,
//                         columns: const [
//                           DataColumn(label: Text('Nombre')),
//                           // DataColumn(label: Text('C-0')),
//                           DataColumn(label: Text('C-1')),
//                           DataColumn(label: Text('C-2')),
//                           DataColumn(label: Text('C-3')),
//                           DataColumn(label: Text('C-4')),
//                           DataColumn(label: Text('C-5')),
//                           DataColumn(label: Text('C-6')),
//                           DataColumn(label: Text('Total')),
//                         ],
//                         rows: dataFull.entries.map<DataRow>((entry) {
//                           List<DataCell> cells = [
//                             DataCell(Text(entry.key)),
//                           ];
//                           entry.value.forEach((day, value) {
//                             cells.add(DataCell(Text(value)));
//                           });
//                           return DataRow(cells: cells);
//                         }).toList(),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     const Divider(),
//                     const SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const [
//                         Text(
//                           'Pieza por cantidad de colores PKT',
//                           style: TextStyle(
//                               color: colorsBlueDeepHigh,
//                               fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: DataTable(
//                         dataTextStyle: const TextStyle(
//                             fontSize: 10,
//                             color: colorsAd,
//                             fontWeight: FontWeight.bold),
//                         headingTextStyle: const TextStyle(
//                             fontSize: 10,
//                             color: colorsAd,
//                             fontWeight: FontWeight.w600),
//                         dataRowHeight: 15,
//                         columns: const [
//                           DataColumn(label: Text('Nombre')),
//                           // DataColumn(label: Text('C-0')),
//                           DataColumn(label: Text('C-1')),
//                           DataColumn(label: Text('C-2')),
//                           DataColumn(label: Text('C-3')),
//                           DataColumn(label: Text('C-4')),
//                           DataColumn(label: Text('C-5')),
//                           DataColumn(label: Text('C-6')),
//                           DataColumn(label: Text('Total')),
//                         ],
//                         rows: dataPkt.entries.map<DataRow>((entry) {
//                           List<DataCell> cells = [
//                             DataCell(Text(entry.key)),
//                           ];
//                           entry.value.forEach((day, value) {
//                             cells.add(DataCell(Text(value)));
//                           });
//                           return DataRow(cells: cells);
//                         }).toList(),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                   ],
//                 )
//               : const SizedBox()
//         ],
//       ),
//     );
//   }
// }

class Clasificacion {
  final int color;
  final int count;
  final int dFullSum;
  final List<String>? fullNames;

  Clasificacion(
      {required this.color,
      required this.count,
      required this.dFullSum,
      this.fullNames});

  @override
  String toString() {
    return 'Hay colorfull $color para un total de $count dFull con el fullName correspondiente:\n${fullNames?.join('\n')}\nLa suma de los dFull es $dFullSum\n';
  }
}

class ClasificacionesTable extends StatelessWidget {
  final List<Clasificacion> clasificaciones;

  ClasificacionesTable({required this.clasificaciones});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(children: [
          TableCell(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Nombre'),
          )),
          TableCell(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('C-1,2,3,4,5,6'),
          )),
          TableCell(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Veces'),
          )),
          TableCell(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Pieza'),
          )),
        ]),
        ...clasificaciones.map((clasificacion) {
          return TableRow(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: TableCell(
                  child: Text('${clasificacion.fullNames?.join(',')}')),
            ),
            TableCell(
                child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text('${clasificacion.color}'),
            )),
            TableCell(
                child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text('${clasificacion.count}'),
            )),
            TableCell(
                child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text('${clasificacion.dFullSum}'),
            )),
          ]);
        }).toList(),
      ],
    );
  }
}
