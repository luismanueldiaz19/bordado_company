import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
import '../model/users.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/folder_incidencia_main/detail_incidencia.dart';
import '/src/nivel_2/folder_insidensia/model/incidencia.dart';
import '/src/nivel_2/folder_insidensia/print_insidencia/print_insidencia_general.dart';
import '/src/nivel_2/folder_reception/file_view_orden.dart';
import '/src/screen_print_pdf/apis/pdf_api.dart';
import '/src/util/commo_pallete.dart';

import '/src/util/helper.dart';
import '/src/util/show_mesenger.dart';

import '../folder_print_services/print_incidencia.dart';
import '../widgets/pick_range_date.dart';
import 'model_incidencia/incidencia_main.dart';
import 'model_incidencia/resumen_empleado.dart';

class HomeIncidenciaResueltos extends StatefulWidget {
  const HomeIncidenciaResueltos({super.key});

  @override
  State<HomeIncidenciaResueltos> createState() =>
      _HomeIncidenciaResueltosState();
}

class _HomeIncidenciaResueltosState extends State<HomeIncidenciaResueltos> {
  String? _secondDate = DateTime.now().toString().substring(0, 10);
  String? _firstDate = DateTime.now().toString().substring(0, 10);
  List<Incidencia> list = [];
  List<Incidencia> listFilter = [];

  List<String> urls = [
    "http://$ipLocal/settingmat/admin/select/select_resume_incidencia_por_empleado.php",
    "http://$ipLocal/settingmat/admin/select/select_resume_incidencia_por_departamento.php",
    "http://$ipLocal/settingmat/admin/select/select_resume_incidencia_por_mes.php",
    "http://$ipLocal/settingmat/admin/select/select_resume_incidencia_productos_por_mes.php",
    "http://$ipLocal/settingmat/admin/select/select_resume_incidencia_productos_por_usuario.php",
    "http://$ipLocal/settingmat/admin/select/select_incidencia_test.php",
  ];

  bool isShow = false;
  bool isFinished = false;

  @override
  void initState() {
    super.initState();

    _firstDate = DateTime.now().toString().substring(0, 10);
    _secondDate = DateTime.now().toString().substring(0, 10);
    getIncidenciaMain(context);
    // getIncidencia();
    getIncidenciaPorEmpleado();
    getIncidenciaPorDepartamento();
    getIncidenciaPorMes();
    getIncidenciaProductoPorMes();
    getIncidenciaProductoPorEmpleado();
  }

  // Future getIncidencia() async {
  //   String url =
  //       "http://$ipLocal/settingmat/admin/select/select_incidencia_test_by_date_resuelto.php";
  //   final res = await httpRequestDatabase(url,
  //       {'estado': 'no resuelto', 'date1': _firstDate, 'date2': _secondDate});
  //   // var response = jsonDecode(res.body);
  //   // print(jsonEncode(response['body']));
  // }

  List<ResumenEmpleado> lisEmpleado = [];
  List<ResumenEmpleado> lisPorDepartamento = [];
  List<ResumenEmpleado> lisPorMes = [];
  List<ResumenEmpleado> listProductoPorMes = [];
  List<ResumenEmpleado> listProductoPorEmpleado = [];

  Future getIncidenciaPorEmpleado() async {
    String url = urls[0];
    final res = await httpRequestDatabase(url,
        {'estado': 'no resuelto', 'date1': _firstDate, 'date2': _secondDate});

    var response = jsonDecode(res.body);

    if (response['success']) {
      print(jsonEncode(response['body']));
      lisEmpleado = resumenEmpleadoFromJson(jsonEncode(response['body']));
    }
  }

  Future getIncidenciaPorDepartamento() async {
    String url = urls[1];
    final res = await httpRequestDatabase(url,
        {'estado': 'no resuelto', 'date1': _firstDate, 'date2': _secondDate});

    var response = jsonDecode(res.body);

    if (response['success']) {
      print(jsonEncode(response['body']));
      lisPorDepartamento =
          resumenEmpleadoFromJson(jsonEncode(response['body']));
    }
  }

  Future getIncidenciaPorMes() async {
    String url = urls[2];
    final res = await httpRequestDatabase(url,
        {'estado': 'no resuelto', 'date1': _firstDate, 'date2': _secondDate});

    var response = jsonDecode(res.body);

    if (response['success']) {
      print(jsonEncode(response['body']));
      lisPorMes = resumenEmpleadoFromJson(jsonEncode(response['body']));
    }
  }

  Future getIncidenciaProductoPorMes() async {
    String url = urls[3];
    final res = await httpRequestDatabase(url,
        {'estado': 'no resuelto', 'date1': _firstDate, 'date2': _secondDate});

    var response = jsonDecode(res.body);
    // print(res.body);
    if (response['success']) {
      print(jsonEncode(response['body']));
      listProductoPorMes =
          resumenEmpleadoFromJson(jsonEncode(response['body']));
    }
  }

  Future getIncidenciaProductoPorEmpleado() async {
    String url = urls[4];
    final res = await httpRequestDatabase(url,
        {'estado': 'no resuelto', 'date1': _firstDate, 'date2': _secondDate});

    var response = jsonDecode(res.body);
    // print(res.body);
    if (response['success']) {
      print(jsonEncode(response['body']));
      listProductoPorEmpleado =
          resumenEmpleadoFromJson(jsonEncode(response['body']));
    }
    setState(() {});
  }

  Future deleteFromIncidencia(context, idListIncidencia) async {
    //delete_incidencia_completa
    String? url =
        "http://$ipLocal/settingmat/admin/delete/delete_incidencia_completa.php";
    final res = await httpRequestDatabase(
        url, {'id_list_incidencia': idListIncidencia});

    final data = jsonDecode(res.body);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(data['message']),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red,
      ),
    );
    await getIncidenciaMain(context);
  }

  void searchingFilter(String val) {
    // print(val);
    if (val.isNotEmpty) {
      listMainFilter = List.from(listMain
          .where((x) =>
              x.ficha!.toUpperCase().contains(val.toUpperCase()) ||
              x.departmentFind!.toUpperCase().contains(val.toUpperCase()) ||
              x.numOrden!.toUpperCase().contains(val.toUpperCase()))
          .toList());
      setState(() {});
    } else {
      listMainFilter = listMain;

      setState(() {});
    }
  }

  List<IncidenciaMain> listMain = [];
  List<IncidenciaMain> listMainFilter = [];

  Future getIncidenciaMain(context) async {
    setState(() {
      listMain.clear();
      listFilter.clear();
      lisEmpleado.clear();
      listProductoPorEmpleado.clear();
      lisPorDepartamento.clear();
      lisPorMes.clear();
      listProductoPorMes.clear();
    });
    var estado = "resuelto";
    String? url =
        "http://$ipLocal/settingmat/admin/select/select_incidencia_test_by_date.php?estado=$estado&date1=$_firstDate&date2=$_secondDate";

    final res = await httpRequestDatabaseGET(url);
    // print(res.body);
    if (res != null) {
      var response = jsonDecode(res.body);
      // print(res.body);
      if (response['success']) {
        listMain = incidenciaMainFromJson(jsonEncode(response['body']));
        listMainFilter = listMain;
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(response['message']),
            duration: const Duration(seconds: 1)));
      }
    }

    // list = usuarioPermissionsFromJson(res.body);
    // listFilter = list;
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Departamento Incidencias'),
        backgroundColor: Colors.transparent,
        actions: [
          Tooltip(
              message: 'Quitar Filtro',
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list_off_sharp))),
          Tooltip(
              message: 'Buscar en Fecha',
              child: IconButton(
                  onPressed: () {
                    selectDateRangeNew(context, (date1, date2) {
                      setState(() {
                        _firstDate = date1.toString();
                        _secondDate = date2.toString();
                      });
                      getIncidenciaMain(context);
                      // getIncidencia();
                      getIncidenciaPorEmpleado();
                      getIncidenciaPorDepartamento();
                      getIncidenciaPorMes();
                      getIncidenciaProductoPorMes();
                      getIncidenciaProductoPorEmpleado();
                    });
                  },
                  icon: const Icon(Icons.calendar_month))),
          Container(
              margin: const EdgeInsets.only(right: 25),
              child: IconButton(
                icon: const Icon(Icons.print, color: Colors.black),
                onPressed: () async {
                  if (listFilter.isNotEmpty) {
                    final pdfFile = await PdfIncidenciaGeneral.generate(
                        listFilter, _firstDate, _secondDate);
                    PdfApi.openFile(pdfFile);
                  }
                },
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(width: double.infinity),
            buildTextFieldValidator(
                label: 'Buscar',
                onChanged: (val) => searchingFilter(val),
                hintText: 'Buscar'),
            listMainFilter.isEmpty
                ? SizedBox(
                    height: size.height * 0.50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BounceInDown(
                          curve: Curves.elasticInOut,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child:
                                  Image.asset('assets/no_find.jpg', scale: 10)),
                        ),
                        const SizedBox(height: 10),
                        SlideInLeft(
                          curve: Curves.elasticInOut,
                          child: const Text('No hay datos..',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  )
                : SizedBox(
                    height: size.height * 0.40,
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Padding(
                        padding: const EdgeInsets.all(25),
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
                              headingRowHeight: 25,
                              decoration:
                                  const BoxDecoration(color: colorsGreenLevel),
                              headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              border: TableBorder.symmetric(
                                  outside: BorderSide(
                                      color: Colors.grey.shade100,
                                      style: BorderStyle.none),
                                  inside: const BorderSide(
                                      style: BorderStyle.solid,
                                      color: Colors.grey)),
                              columns: const [
                                DataColumn(label: Text('PDF')),
                                DataColumn(label: Text('Ver Detalles')),
                                DataColumn(label: Text('Encontrado por')),
                                DataColumn(label: Text('Num Orden')),
                                DataColumn(label: Text('Ficha')),
                                DataColumn(label: Text('Logo')),
                                DataColumn(label: Text('Causa')),
                                DataColumn(label: Text('Compromiso')),
                                DataColumn(
                                    label: Text('Empleados Responsable')),
                                DataColumn(label: Text('Depart Responsable')),
                                DataColumn(label: Text('Creado en')),
                                DataColumn(label: Text('Resuelto en')),
                                DataColumn(label: Text('Registrado por')),
                                DataColumn(label: Text('Eliminar'))
                              ],
                              rows: listMainFilter.asMap().entries.map((entry) {
                                int index = entry.key;
                                var report = entry.value;
                                return DataRow(
                                  color:
                                      MaterialStateProperty.resolveWith<Color>(
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
                                    DataCell(
                                        const Text('Pdf',
                                            style: TextStyle(
                                                color: colorsAd,
                                                fontWeight: FontWeight.w500)),
                                        onTap: () async {
                                      final doc =
                                          await PrintIncidencia.generate(
                                              report);
                                      await PdfApi.openFile(doc);
                                    }),
                                    DataCell(
                                        const Text('Click !',
                                            style: TextStyle(
                                                color: colorsAd,
                                                fontWeight: FontWeight.w500)),
                                        onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailIncidencia(
                                                    report: report)),
                                      );
                                    }),
                                    DataCell(
                                        Text(report.departmentFind ?? 'N/A')),
                                    DataCell(Text(report.numOrden ?? 'N/A'),
                                        onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FileViewer(
                                                  numOrden: report.numOrden)));
                                    }),
                                    DataCell(Text(report.ficha ?? 'N/A')),
                                    DataCell(
                                        Text(report.logo != null &&
                                                report.logo!.length > 15
                                            ? '${report.logo!.substring(0, 15)}...'
                                            : report.logo ?? ''), onTap: () {
                                      utilShowMesenger(
                                          context, report.logo ?? '');
                                    }),
                                    DataCell(
                                        Text(
                                          report.whatHapped != null &&
                                                  report.whatHapped!.length > 15
                                              ? '${report.whatHapped!.substring(0, 15)}...'
                                              : report.whatHapped ?? '',
                                          style: TextStyle(
                                              color: Colors.red.shade300),
                                        ), onTap: () {
                                      utilShowMesenger(
                                          context, report.whatHapped ?? '');
                                    }),
                                    DataCell(
                                        Text(report.compromiso != null &&
                                                report.compromiso!.length > 30
                                            ? '${report.compromiso!.substring(0, 30)}...'
                                            : report.compromiso ?? ''),
                                        onTap: () {
                                      utilShowMesenger(
                                          context, report.compromiso ?? '');
                                    }),
                                    DataCell(
                                        Center(
                                          child: Text(report
                                              .listUsuarioResponsable!.length
                                              .toString()),
                                        ),
                                        onTap: () => viewUsuario(context,
                                            report.listUsuarioResponsable!)),
                                    DataCell(
                                        Center(
                                          child: Text(report
                                              .listDepartamentoResponsable!
                                              .length
                                              .toString()),
                                        ),
                                        onTap: () => viewDepartment(
                                            context,
                                            report
                                                .listDepartamentoResponsable!)),
                                    DataCell(Text(report.createdAt ?? 'N/A')),
                                    DataCell(
                                        Text(report.fechaResuelto ?? 'N/A')),
                                    DataCell(Text(report.registedBy ?? 'N/A')),
                                    hasPermissionUsuario(
                                            currentUsers!.listPermission!,
                                            "incidencia",
                                            "eliminar")
                                        ? DataCell(const Text('Eliminar'),
                                            onTap: () => deleteFromIncidencia(
                                                context,
                                                report.idListIncidencia))
                                        : const DataCell(Text('Sin Permiso')),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            SizedBox(
              height: 250,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // ChartGetMesIncidencia
                      lisPorMes.isNotEmpty
                          ? ChartGetMesIncidencia(items: lisPorMes)
                          : const SizedBox(),
                      const SizedBox(width: 10),
                      lisPorDepartamento.isNotEmpty
                          ? ChartGet(items: lisPorDepartamento)
                          : const SizedBox(),
                      const SizedBox(width: 10),
                      lisEmpleado.isNotEmpty
                          ? ChartGetEmpleado(items: lisEmpleado)
                          : const SizedBox(),
                      const SizedBox(width: 10),
                      listProductoPorMes.isNotEmpty
                          ? ChartGetGasto(items: listProductoPorMes)
                          : const SizedBox(),
                      const SizedBox(width: 10),
                      listProductoPorEmpleado.isNotEmpty
                          ? ChartGetGastoPorEmpleado(
                              items: listProductoPorEmpleado)
                          : const SizedBox(),
                    ],
                  ),
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

class ChartGet extends StatelessWidget {
  const ChartGet({super.key, this.items});

  final List<ResumenEmpleado>? items;
  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      curve: Curves.elasticInOut,
      child: Container(
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 10)
        ]),

        width: 450, // Ajusta el ancho del gráfico
        // child: SfCartesianChart(
        //   primaryXAxis: const CategoryAxis(),
        //   primaryYAxis: const NumericAxis(),
        //   tooltipBehavior: TooltipBehavior(enable: true),

        //   // Leyenda personalizada
        //   legend: const Legend(
        //     isVisible: true,
        //     position: LegendPosition.top, // Posición de la leyenda
        //     textStyle: TextStyle(
        //       fontSize: 14,
        //       color: Colors.black,
        //     ),
        //     title: LegendTitle(
        //         text: 'Incid. departamentos',
        //         textStyle:
        //             TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        //   ),

        //   series: <CartesianSeries<ResumenEmpleado, String>>[
        //     ColumnSeries<ResumenEmpleado, String>(
        //       dataSource: items,
        //       xValueMapper: (ResumenEmpleado data, _) {
        //         return data.departamento != null &&
        //                 data.departamento!.isNotEmpty
        //             ? data.departamento!
        //             : 'N/A';
        //       },
        //       yValueMapper: (ResumenEmpleado data, _) {
        //         return (double.tryParse(data.cantidadIncidencias ?? '0') ?? 0)
        //             .round();
        //       },

        //       // Cambiar el ancho de las columnas
        //       width: 0.3, // Ajusta el grosor de las columnas (entre 0 y 1)

        //       // Colores personalizados para cada columna
        //       pointColorMapper: (ResumenEmpleado data, _) {
        //         return (double.tryParse(data.cantidadIncidencias ?? '0') ?? 0) >
        //                 50
        //             ? Colors
        //                 .red // Columna roja si las incidencias son mayores a 50
        //             : Colors
        //                 .green; // Columna verde si son menores o iguales a 50
        //       },

        //       // Nombre para la leyenda
        //       name: 'Departamentos',

        //       // Color base para las columnas (si no se usa pointColorMapper)
        //       color: const Color.fromRGBO(8, 142, 255, 1),

        //       // Configuración de etiquetas
        //       dataLabelSettings: const DataLabelSettings(
        //         isVisible: true,
        //         textStyle: TextStyle(fontSize: 12),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}

class ChartGetEmpleado extends StatelessWidget {
  const ChartGetEmpleado({super.key, this.items});

  final List<ResumenEmpleado>? items;
  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      curve: Curves.elasticInOut,
      child: Container(
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 10)
        ]),

        width: 450, // Ajusta el ancho del gráfico
        // child: SfCartesianChart(
        //   primaryXAxis: const CategoryAxis(),
        //   primaryYAxis: const NumericAxis(),
        //   tooltipBehavior: TooltipBehavior(enable: true),

        //   // Leyenda personalizada
        //   legend: const Legend(
        //     isVisible: true,
        //     position: LegendPosition.top, // Posición de la leyenda
        //     textStyle: TextStyle(
        //       fontSize: 14,
        //       color: Colors.black,
        //     ),
        //     title: LegendTitle(
        //         text: 'Incid. Empleado',
        //         textStyle:
        //             TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        //   ),

        //   series: <CartesianSeries<ResumenEmpleado, String>>[
        //     ColumnSeries<ResumenEmpleado, String>(
        //       dataSource: items,
        //       xValueMapper: (ResumenEmpleado data, _) {
        //         return data.empleado != null && data.empleado!.isNotEmpty
        //             ? data.empleado!
        //             : 'N/A';
        //       },
        //       yValueMapper: (ResumenEmpleado data, _) {
        //         return (double.tryParse(data.cantidadIncidencias ?? '0') ?? 0)
        //             .round();
        //       },

        //       // Cambiar el ancho de las columnas
        //       width: 0.3, // Ajusta el grosor de las columnas (entre 0 y 1)

        //       // Colores personalizados para cada columna
        //       pointColorMapper: (ResumenEmpleado data, _) {
        //         return (double.tryParse(data.cantidadIncidencias ?? '0') ?? 0) >
        //                 3
        //             ? Colors
        //                 .red // Columna roja si las incidencias son mayores a 50
        //             : Colors
        //                 .blue; // Columna verde si son menores o iguales a 50
        //       },

        //       // Nombre para la leyenda
        //       name: 'Empleados',

        //       // Color base para las columnas (si no se usa pointColorMapper)
        //       color: const Color.fromARGB(255, 255, 94, 8),

        //       // Configuración de etiquetas
        //       dataLabelSettings: const DataLabelSettings(
        //         isVisible: true,
        //         textStyle: TextStyle(fontSize: 12),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}

class ChartGetGasto extends StatelessWidget {
  const ChartGetGasto({super.key, this.items});

  final List<ResumenEmpleado>? items;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 10)
      ]),

      width: 450, // Ajusta el ancho del gráfico
      // child: SfCartesianChart(
      //   primaryXAxis: const CategoryAxis(),
      //   primaryYAxis: const NumericAxis(),
      //   tooltipBehavior: TooltipBehavior(enable: true),

      //   // Leyenda personalizada
      //   legend: const Legend(
      //     isVisible: true,
      //     position: LegendPosition.top, // Posición de la leyenda
      //     textStyle: TextStyle(
      //       fontSize: 14,
      //       color: Colors.black,
      //     ),
      //     title: LegendTitle(
      //         text: 'Costo mes incidencias',
      //         textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      //   ),

      //   series: <CartesianSeries<ResumenEmpleado, String>>[
      //     ColumnSeries<ResumenEmpleado, String>(
      //       dataSource: items,
      //       xValueMapper: (ResumenEmpleado data, _) {
      //         return data.mes != null && data.mes!.isNotEmpty
      //             ? data.mes!
      //             : 'N/A';
      //       },
      //       yValueMapper: (ResumenEmpleado data, _) {
      //         return (double.tryParse(data.costoTotalProductos ?? '0') ?? 0)
      //             .round();
      //       },

      //       // Cambiar el ancho de las columnas
      //       width: 0.3, // Ajusta el grosor de las columnas (entre 0 y 1)

      //       // Colores personalizados para cada columna
      //       pointColorMapper: (ResumenEmpleado data, _) {
      //         return (double.tryParse(data.costoTotalProductos ?? '0') ?? 0) >
      //                 3500
      //             ? Colors
      //                 .red // Columna roja si las incidencias son mayores a 50
      //             : Colors.blue; // Columna verde si son menores o iguales a 50
      //       },

      //       // Nombre para la leyenda
      //       name: 'Costo',

      //       // Color base para las columnas (si no se usa pointColorMapper)
      //       color: const Color.fromARGB(255, 255, 94, 8),

      //       // Configuración de etiquetas
      //       dataLabelSettings: const DataLabelSettings(
      //         isVisible: true,
      //         textStyle: TextStyle(fontSize: 12),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

class ChartGetGastoPorEmpleado extends StatelessWidget {
  const ChartGetGastoPorEmpleado({super.key, this.items});

  final List<ResumenEmpleado>? items;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 10)
      ]),

      width: 450, // Ajusta el ancho del gráfico
      // child: SfCartesianChart(
      //   primaryXAxis: const CategoryAxis(),
      //   primaryYAxis: const NumericAxis(),
      //   tooltipBehavior: TooltipBehavior(enable: true),

      //   // Leyenda personalizada
      //   legend: const Legend(
      //     isVisible: true,
      //     position: LegendPosition.top, // Posición de la leyenda
      //     textStyle: TextStyle(
      //       fontSize: 14,
      //       color: Colors.black,
      //     ),
      //     title: LegendTitle(
      //         text: 'Empleado costo incidencias',
      //         textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      //   ),

      //   series: <CartesianSeries<ResumenEmpleado, String>>[
      //     ColumnSeries<ResumenEmpleado, String>(
      //       dataSource: items,
      //       xValueMapper: (ResumenEmpleado data, _) {
      //         return data.empleado != null && data.empleado!.isNotEmpty
      //             ? data.empleado!
      //             : 'N/A';
      //       },
      //       yValueMapper: (ResumenEmpleado data, _) {
      //         return (double.tryParse(data.costoTotalProductos ?? '0') ?? 0)
      //             .round();
      //       },

      //       // Cambiar el ancho de las columnas
      //       width: 0.3, // Ajusta el grosor de las columnas (entre 0 y 1)

      //       // Colores personalizados para cada columna
      //       pointColorMapper: (ResumenEmpleado data, _) {
      //         return (double.tryParse(data.costoTotalProductos ?? '0') ?? 0) >
      //                 3500
      //             ? Colors
      //                 .red // Columna roja si las incidencias son mayores a 50
      //             : Colors.blue; // Columna verde si son menores o iguales a 50
      //       },

      //       // Nombre para la leyenda
      //       name: 'Costo',

      //       // Color base para las columnas (si no se usa pointColorMapper)
      //       color: const Color.fromARGB(255, 255, 94, 8),

      //       // Configuración de etiquetas
      //       dataLabelSettings: const DataLabelSettings(
      //         isVisible: true,
      //         textStyle: TextStyle(fontSize: 12),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

class ChartGetMesIncidencia extends StatelessWidget {
  const ChartGetMesIncidencia({super.key, this.items});

  final List<ResumenEmpleado>? items;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 10)
      ]),

      width: 450, // Ajusta el ancho del gráfico
      // child: SfCartesianChart(
      //   primaryXAxis: const CategoryAxis(),
      //   primaryYAxis: const NumericAxis(),
      //   tooltipBehavior: TooltipBehavior(enable: true),

      //   // Leyenda personalizada
      //   legend: const Legend(
      //     isVisible: true,
      //     position: LegendPosition.top, // Posición de la leyenda
      //     textStyle: TextStyle(
      //       fontSize: 14,
      //       color: Colors.black,
      //     ),
      //     title: LegendTitle(
      //         text: 'Incidencias mensuales',
      //         textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      //   ),

      //   series: <CartesianSeries<ResumenEmpleado, String>>[
      //     ColumnSeries<ResumenEmpleado, String>(
      //       dataSource: items,
      //       xValueMapper: (ResumenEmpleado data, _) {
      //         return data.mes != null && data.mes!.isNotEmpty
      //             ? data.mes!
      //             : 'N/A';
      //       },
      //       yValueMapper: (ResumenEmpleado data, _) {
      //         return (double.tryParse(data.cantidadIncidencias ?? '0') ?? 0)
      //             .round();
      //       },

      //       // Cambiar el ancho de las columnas
      //       width: 0.3, // Ajusta el grosor de las columnas (entre 0 y 1)

      //       // Colores personalizados para cada columna
      //       pointColorMapper: (ResumenEmpleado data, _) {
      //         return (double.tryParse(data.cantidadIncidencias ?? '0') ?? 0) > 5
      //             ? Colors
      //                 .red // Columna roja si las incidencias son mayores a 50
      //             : Colors.blue; // Columna verde si son menores o iguales a 50
      //       },

      //       // Nombre para la leyenda
      //       name: 'Incidencias',

      //       // Color base para las columnas (si no se usa pointColorMapper)
      //       color: const Color.fromARGB(255, 109, 17, 228),

      //       // Configuración de etiquetas
      //       dataLabelSettings: const DataLabelSettings(
      //         isVisible: true,
      //         textStyle: TextStyle(fontSize: 12),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
