import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/nivel_2/folder_insidensia/model/incidencia.dart';
import '/src/nivel_2/folder_insidensia/pages_insidencia.dart/detalles_card.dart';
import '/src/nivel_2/folder_insidensia/print_insidencia/print_insidencia_general.dart';
import '/src/screen_print_pdf/apis/pdf_api.dart';
import '/src/util/font_style.dart';
import '/src/util/show_mesenger.dart';
import '../../widgets/pick_range_date.dart';

class HomeIncidenciaResueltosViejo extends StatefulWidget {
  const HomeIncidenciaResueltosViejo({super.key});

  @override
  State<HomeIncidenciaResueltosViejo> createState() =>
      _HomeIncidenciaResueltosViejoState();
}

class _HomeIncidenciaResueltosViejoState
    extends State<HomeIncidenciaResueltosViejo> {
  String? _secondDate = '';
  String? _firstDate = '';
  List<Incidencia> list = [];
  List<Incidencia> listFilter = [];

  bool isShow = false;
  bool isFinished = false;

  @override
  void initState() {
    super.initState();
    _firstDate = DateTime.now().toString().substring(0, 10);
    _secondDate = DateTime.now().toString().substring(0, 10);
    getIncidencia(_firstDate, _secondDate);
  }

  Future getIncidencia(date1, date2) async {
    list.clear();
    listFilter.clear();
    setState(() {});
    final res = await httpRequestDatabase(selectReportIncidenciaByDate,
        {'is_finished': 't', 'date1': '$date1', 'date2': '$date2'});

    list = incidenciaFromJson(res.body);
    listFilter = [...list];
    if (list.isNotEmpty) {
      setState(() {});
    }
  }

  Future deleteFromIncidencia(id, imageKey) async {
    var data = {
      'id': id,
      'id_key_image': imageKey,
    };

    await httpRequestDatabase(deleteImageIncidencia, data);
    list.removeWhere((element) => element.id == id);

    // print('index ${id}');
    // print(list.length);
    setState(() {});
    // getIncidencia(_firstDate, _secondDate);
  }

  void searchingFilter(String val) {
    // print(val);
    if (val.isNotEmpty) {
      listFilter = List.from(list
          .where((x) =>
              x.departResponsed!.toUpperCase().contains(val.toUpperCase()) ||
              x.usersResponsed!.toUpperCase().contains(val.toUpperCase()) ||
              x.depart!.toUpperCase().contains(val.toUpperCase()))
          .toList());
      setState(() {});
    } else {
      listFilter = [...list];

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Departamento Incidencias'),
        actions: [
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
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          DateRangeSelectionWidget(
            press: (date1, date2) {
              setState(() {
                _firstDate = date1;
                _secondDate = date2;
              });
              getIncidencia(_firstDate, _secondDate);
            },
          ),
          const SizedBox(height: 5),
          FadeIn(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              width: 223,
              child: TextField(
                onChanged: (val) => searchingFilter(val),
                decoration: const InputDecoration(
                  hintText: 'Buscar',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15, top: 10),
                  suffixIcon: Tooltip(
                    message: 'Buscar por Depart/usuarios',
                    child: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 25,
            width: 200,
            color: Colors.white,
            alignment: Alignment.center,
            child: Text(
              'Total Incidencias :  ${listFilter.length}',
              style: style.bodySmall
                  ?.copyWith(color: Colors.brown, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          listFilter.isEmpty
              ? Center(
                  child: SizedBox(
                      child: Text('No hay Incidencia', style: style.bodySmall)),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: DataTable(
                          dataRowMaxHeight: 20,
                          dataRowMinHeight: 15,
                          horizontalMargin: 10.0,
                          columnSpacing: 15,
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
                                  style: BorderStyle.solid,
                                  color: Colors.grey)),
                          columns: const [
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('Department')),
                            DataColumn(label: Text('num Orden')),
                            DataColumn(label: Text('Logo')),
                            DataColumn(label: Text('Ficha')),
                            DataColumn(label: Text('Motivo')),
                            DataColumn(label: Text('Resp. Depart')),
                            DataColumn(label: Text('Resp. Users')),
                            DataColumn(label: Text('Fecha')),
                          ],
                          rows: listFilter
                              .map(
                                (data) => DataRow(
                                  cells: [
                                    DataCell(Text('${data.id}')),
                                    DataCell(Text('${data.depart}')),
                                    DataCell(Row(
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => DetallesCard(
                                                      current: data),
                                                ),
                                              );
                                            },
                                            child: Text('${data.numOrden}')),
                                        const SizedBox(width: 10),
                                        currentUsers?.occupation.toString() ==
                                                    OptionAdmin.admin.name ||
                                                currentUsers?.occupation
                                                        .toString() ==
                                                    OptionAdmin.master.name
                                            ? IconButton(
                                                onPressed: () {
                                                  deleteFromIncidencia(
                                                      data.id, data.idKeyImage);
                                                  setState(() {
                                                    listFilter.remove(data);
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                  size: 10,
                                                ))
                                            : const SizedBox(),
                                      ],
                                    )),
                                    DataCell(
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            '${data.logo}',
                                            style: const TextStyle(
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ), onTap: () {
                                      utilShowMesenger(context, '${data.logo}',
                                          title: 'LOGO');
                                    }),
                                    DataCell(Text('${data.ficha}')),
                                    DataCell(
                                        SizedBox(
                                          width: 100,
                                          child: Text('${data.whycause}',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontFamily: fontTenali,
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                        ), onTap: () {
                                      utilShowMesenger(
                                          context, '${data.whycause}',
                                          title: 'Motivo');
                                    }),
                                    DataCell(Text('${data.departResponsed}')),
                                    DataCell(
                                        SizedBox(
                                            width: 70,
                                            child: Text(
                                                '${data.usersResponsed}',
                                                style: const TextStyle(
                                                    overflow: TextOverflow
                                                        .ellipsis))),
                                        onTap: () {
                                      utilShowMesenger(
                                          context, '${data.usersResponsed}',
                                          title: 'Responsable');
                                    }),
                                    DataCell(Text('${data.date}')),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
          const SizedBox(height: 10),
          Text('Reportes Incidencia',
              style: style.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(child: IncidenciaTableUser(list: listFilter)),
          const SizedBox(height: 20),
          Expanded(child: IncidenciaTable(list: listFilter)),
        ],
      ),
    );
  }
}

class IncidenciaTable extends StatelessWidget {
  final List<Incidencia> list;

  const IncidenciaTable({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    Map<String, int> countMap = {};
    for (var incidencia in list) {
      if (countMap.containsKey(incidencia.depart)) {
        countMap[incidencia.depart ?? ''] = countMap[incidencia.depart]! + 1;
      } else {
        countMap[incidencia.depart ?? ''] = 1;
      }
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: DataTable(
        dataRowMaxHeight: 20,
        dataRowMinHeight: 15,
        horizontalMargin: 10.0,
        columnSpacing: 15,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 221, 216, 205),
              Color.fromARGB(255, 241, 236, 225),
              Color.fromARGB(255, 233, 234, 238),
            ],
          ),
        ),
        border: TableBorder.symmetric(
            inside:
                const BorderSide(style: BorderStyle.solid, color: Colors.grey)),
        columns: const [
          DataColumn(label: Text('Departamentos')),
          DataColumn(label: Text('Cantidad')),
        ],
        rows: countMap.entries
            .map((e) => DataRow(cells: [
                  DataCell(Text(e.key)),
                  DataCell(Text('${e.value}')),
                ]))
            .toList(),
      ),
    );
  }
}

class IncidenciaTableUser extends StatelessWidget {
  final List<Incidencia> list;

  const IncidenciaTableUser({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, int> countMap = {};
    for (var incidencia in list) {
      if (countMap.containsKey(incidencia.usersResponsed ?? '')) {
        countMap[incidencia.usersResponsed ?? ''] =
            countMap[incidencia.usersResponsed ?? '']! + 1;
      } else {
        countMap[incidencia.usersResponsed ?? ''] = 1;
      }
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: DataTable(
        dataRowMaxHeight: 20,
        dataRowMinHeight: 15,
        horizontalMargin: 10.0,
        columnSpacing: 15,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 221, 205, 211),
              Color.fromARGB(255, 241, 225, 239),
              Color.fromARGB(255, 233, 234, 238),
            ],
          ),
        ),
        border: TableBorder.symmetric(
            inside:
                const BorderSide(style: BorderStyle.solid, color: Colors.grey)),
        columns: const [
          DataColumn(label: Text('Empleados')),
          DataColumn(label: Text('Cantidad')),
        ],
        rows: countMap.entries
            .map((e) => DataRow(cells: [
                  DataCell(
                      SizedBox(
                          width: 200,
                          child: Text(e.key,
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis))),
                      onTap: () {
                    utilShowMesenger(context, e.key, title: 'Empleados');
                  }),
                  DataCell(Text(e.value.toString()))
                ]))
            .toList(),
      ),
    );
  }
}
