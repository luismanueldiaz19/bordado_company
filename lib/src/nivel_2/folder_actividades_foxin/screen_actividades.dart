import 'dart:convert';

import 'package:flutter/material.dart';
import '/src/nivel_2/folder_actividades_foxin/print_actividades.dart';

import '../../datebase/current_data.dart';
import '../../datebase/methond.dart';
import '../../datebase/url.dart';
import '../../screen_print_pdf/apis/pdf_api.dart';
import '../../util/dialog_confimarcion.dart';
import '../../util/get_time_relation.dart';
import '../../util/show_mesenger.dart';
import '../../widgets/pick_range_date.dart';
import '../../widgets/picked_date_widget.dart';
import 'model_actividades_foxin.dart';

class ScreenActividades extends StatefulWidget {
  const ScreenActividades({super.key});

  @override
  State<ScreenActividades> createState() => _ScreenActividadesState();
}

class _ScreenActividadesState extends State<ScreenActividades> {
  String? _firstDate = DateTime.now().toString().substring(0, 10);
  String? _secondDate = DateTime.now().toString().substring(0, 10);
  List<Actividades> listActividades = [];
  List<Actividades> listActividadesFilter = [];
  String typeNameLocal = '';
  List listType = [];
  getActividades() async {
    String selectActividadesDaysFoxin =
        'http://$ipLocal/settingmat/admin/select/select_actividades_days.php';
    final res = await httpRequestDatabase(selectActividadesDaysFoxin,
        {'date1': _firstDate, 'date2': _secondDate});
    listActividades = actividadesFromJson(res.body);
    listActividadesFilter = [...listActividades];
    depurarCategories(listActividadesFilter);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getTipoActividades();
    getActividades();
  }

  Future getTipoActividades() async {
    String selectTypeActividadesDaysFoxin =
        'http://$ipLocal/settingmat/admin/select/select_type_actividades_days.php';
    final res = await httpRequestDatabase(
        selectTypeActividadesDaysFoxin, {'view': 'view'});

    // print(res.body);
    listType = json.decode(res.body) as List;
    setState(() {});
  }

  Future deleteFrom(context, id) async {
    String deleteActividadesDaysFoxin =
        'http://$ipLocal/settingmat/admin/delete/delete_actividades_days.php';

    showDialog(
        context: context,
        builder: (_) {
          return ConfirmacionDialog(
            mensaje: eliminarMjs,
            onConfirmar: () async {
              await httpRequestDatabase(deleteActividadesDaysFoxin, {'id': id});
              Navigator.pop(context);
            },
            titulo: 'Aviso',
          );
        }).then((value) {
      getActividades();
    });
  }

  Future updateEndTime(context, Actividades item, bool isStart) async {
    // updateActividadesDaysEndTime
    String updateActividadesDaysEndTimeFoxin =
        'http://$ipLocal/settingmat/admin/update/update_actividades_days_end_time.php';
    //     $end_time = $_POST['end_time'];
    // $start_time = $_POST['start_time'];
    // $id = $_POST['id'];

    showDialog(
        context: context,
        builder: (_) {
          return ConfirmacionDialog(
            mensaje: actionMjs,
            onConfirmar: () async {
              var dataStart = {
                'id': item.id,
                'end_time': 'N/A',
                'start_time': DateTime.now().toString().substring(0, 19),
              };
              var dataEnd = {
                'id': item.id,
                'end_time': DateTime.now().toString().substring(0, 19),
                'start_time': item.startTime,
              };
              await httpRequestDatabase(updateActividadesDaysEndTimeFoxin,
                  isStart ? dataStart : dataEnd);
              Navigator.pop(context);
            },
            titulo: 'Aviso',
          );
        }).then((value) {
      getActividades();
    });
  }

  List<String> categoriesList = [];
  String chipCategories = '';

  depurarCategories(List<Actividades> list) {
    Set<String> fullNameList = list.map((element) => element.fullName!).toSet();
    List<String> listName = fullNameList.toList();
    return listName;
  }

  String getTimeR(List<Actividades> list) {
    Duration sumaDurationTime = const Duration();
    // double minut = 0.0;
    for (var element in list) {
      Duration durationTime = getTimeRelationDuration(
          element.startTime ?? 'N/A', element.endTime ?? 'N/A');

      if (durationTime != 'N/A') {
        sumaDurationTime += durationTime;
      }
    }
    // print('minute  Promedio : $minut');
    return sumaDurationTime.toString().substring(0, 10);
  }

  String eficiencia(List<Actividades> list) {
    Duration sumaDurationTime = Duration();

    for (var element in list) {
      Duration durationTime = getTimeRelationDuration(
          element.startTime ?? 'N/A', element.endTime ?? 'N/A');
      // print(durationTime);

      if (durationTime != 'N/A') {
        sumaDurationTime += durationTime;
      }
    }

    double efficiency = (sumaDurationTime.inSeconds / (8 * 3600)) * 100;
    print('Efficiency : $efficiency %');

    return efficiency.toStringAsFixed(2);
  }

  void _showCommentDialog(BuildContext context, Actividades item) {
    final TextEditingController _commentController =
        TextEditingController(text: item.nota.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enviar un comentario'),
          content: TextField(
            controller: _commentController,
            decoration: InputDecoration(hintText: 'Escribe tu comentario aquí'),
            maxLines: 3,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Enviar'),
              onPressed: () async {
                String updateActividadesDaysNotaFoxin =
                    'http://$ipLocal/settingmat/admin/update/update_actividades_days_nota.php';
                String comment = _commentController.text;

                await httpRequestDatabase(updateActividadesDaysNotaFoxin,
                    {'id': item.id, 'nota': comment});
                if (mounted) Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((value) {
      getActividades();
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge;

    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.only(top: 20, left: 16),
          child: const BackButton(),
        ),
        title: Container(
          margin: const EdgeInsets.only(top: 25, right: 16),
          child: const Text('Actividades diarias'),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          Container(
            margin: const EdgeInsets.only(top: 25, right: 25),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return const DialogActividades();
                  },
                ).then((value) {
                  getActividades();
                });
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 25, right: 25),
            child: IconButton(
              icon: const Icon(Icons.print, color: Colors.black),
              onPressed: () async {
                if (listActividadesFilter.isNotEmpty) {
                  final pdfFile = await PdfActividadesFoxin.generate(
                      listActividadesFilter,
                      {
                        'activ': '${listActividadesFilter.length}',
                        'tiempo': getTimeR(listActividadesFilter),
                        'efect': '${eficiencia(listActividadesFilter)} %'
                      },
                      _firstDate,
                      _secondDate);

                  PdfApi.openFile(pdfFile);
                }
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          DateRangeSelectionWidget(
            press: (date1, date2) {
              _firstDate = date1.toString();
              _secondDate = date2.toString();
              getActividades();
            },
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     const SizedBox(width: 10),
          //     TextButton(
          //         onPressed: () async {
          //           var dateee = await showDatePickerCustom(context: context);
          //           _firstDate = dateee.toString();
          //           // print(_firstDate);
          //           setState(() {});
          //         },
          //         child: Text(_firstDate ?? 'N/A')),
          //     const SizedBox(width: 20),
          //     const Text('Entre', style: TextStyle(fontSize: 17)),
          //     const SizedBox(width: 20),
          //     TextButton(
          //         onPressed: () async {
          //           var dateee = await showDatePickerCustom(context: context);
          //           _secondDate = dateee.toString();
          //           getActividades();
          //           setState(() {});
          //         },
          //         child: Text(_secondDate ?? 'N/A')),
          //   ],
          // ),

          const SizedBox(height: 5),
          listType.isNotEmpty
              ? SizedBox(
                  height: 30,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: listType
                          .map(
                            (catego) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                height: 30,
                                color: typeNameLocal.toUpperCase() ==
                                        catego['type_name']
                                            .toString()
                                            .toUpperCase()
                                    ? Colors.red
                                    : Colors.blue,
                                child: Row(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          typeNameLocal = '';
                                          typeNameLocal = catego['type_name']
                                              .toString()
                                              .toUpperCase();
                                          listActividadesFilter = List.from(
                                              listActividades
                                                  .where((x) =>
                                                      x.typeName!
                                                          .toUpperCase() ==
                                                      typeNameLocal
                                                          .toUpperCase())
                                                  .toList());
                                          setState(() {});
                                        },
                                        child: Text(
                                          catego['type_name'],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        )),
                                    typeNameLocal.toUpperCase() ==
                                            catego['type_name']
                                                .toString()
                                                .toUpperCase()
                                        ? IconButton(
                                            onPressed: () {
                                              setState(() {
                                                typeNameLocal = '';
                                                listActividadesFilter =
                                                    List.from(listActividades);
                                              });
                                            },
                                            icon: const Icon(Icons.close,
                                                color: Colors.white))
                                        : const SizedBox()
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                )
              : const SizedBox(),
          listActividadesFilter.isNotEmpty
              ? Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(25),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      child: DataTable(
                        dataRowMaxHeight: 40,
                        dataRowMinHeight: 40,
                        horizontalMargin: 5.0,
                        columnSpacing: 15,
                        border: TableBorder.symmetric(
                            inside: const BorderSide(
                                style: BorderStyle.solid, color: Colors.grey)),
                        columns: const [
                          DataColumn(label: Text('EMPLEADOS')),
                          DataColumn(label: Text('TAREAS')),
                          DataColumn(label: Text('QUE REALIZÓ?')),
                          DataColumn(label: Text('COMENZÓ')),
                          DataColumn(label: Text('TERMINÓ')),
                          DataColumn(label: Text('TIEMPO')),
                          DataColumn(label: Text('FECHAS')),
                        ],
                        rows: listActividadesFilter
                            .map(
                              (item) => DataRow(
                                cells: [
                                  DataCell(
                                    TextButton(
                                      onPressed: () {
                                        listActividadesFilter = List.from(
                                            listActividades
                                                .where((x) =>
                                                    x.fullName!.toUpperCase() ==
                                                    item.fullName
                                                        .toString()
                                                        .toUpperCase())
                                                .toList());
                                        setState(() {});
                                      },
                                      child: Text(item.fullName ?? '',
                                          style: style?.copyWith(
                                              color: Colors.blue)),
                                    ),
                                  ),
                                  DataCell(Row(
                                    children: [
                                      Text(item.typeName ?? '',
                                          style: style?.copyWith()),
                                      validatorUser()
                                          ? TextButton(
                                              onPressed: () =>
                                                  deleteFrom(context, item.id),
                                              child: Text('ELIMINAR',
                                                  style: style?.copyWith(
                                                      color: Colors.red)))
                                          : const SizedBox()
                                    ],
                                  )),
                                  DataCell(
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: 250,
                                            child: Text(item.nota ?? '',
                                                style: style?.copyWith(
                                                    overflow: TextOverflow
                                                        .ellipsis))),
                                        IconButton(
                                            onPressed: () {
                                              _showCommentDialog(context, item);
                                            },
                                            icon: const Icon(Icons.edit_note,
                                                color: Colors.teal))
                                      ],
                                    ),
                                    onTap: () {
                                      getMensajeWidget(
                                          context, item.nota!.toUpperCase(),
                                          text: 'NOTA');
                                    },
                                  ),
                                  DataCell(
                                    Text(item.startTime ?? '',
                                        style: style?.copyWith(
                                            color: Colors.green)),
                                    onTap: () =>
                                        updateEndTime(context, item, true),
                                  ),
                                  DataCell(TextButton(
                                    onPressed: () =>
                                        updateEndTime(context, item, false),
                                    child: Text(item.endTime ?? '',
                                        style:
                                            style?.copyWith(color: Colors.red)),
                                  )),
                                  DataCell(
                                    Text(
                                        getTimeRelation(item.startTime ?? 'N/A',
                                            item.endTime ?? 'N/A'),
                                        style: style?.copyWith(
                                            color: Colors.blue.shade200)),
                                  ),
                                  DataCell(Text(item.date ?? '',
                                      style: style?.copyWith(
                                          color: Colors.black))),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                )
              : const Expanded(
                  child: Center(child: Text('No Hay Actividades'))),
          listActividadesFilter.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: SizedBox(
                    height: 30,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const SizedBox(width: 15),
                          Container(
                            height: 70,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Row(
                                  children: [
                                    const Text('TOTAL ACTIVIDADES :'),
                                    const SizedBox(width: 15),
                                    Text('${listActividadesFilter.length}',
                                        style: const TextStyle(
                                            color: Colors.brown,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Container(
                            height: 70,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Row(
                                  children: [
                                    const Text('TOTAL TIEMPOS :'),
                                    const SizedBox(width: 15),
                                    Text(getTimeR(listActividadesFilter),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Container(
                            height: 70,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Row(
                                  children: [
                                    const Text('TOTAL EFICIENIA :'),
                                    const SizedBox(width: 15),
                                    Text(
                                        '${eficiencia(listActividadesFilter)} %',
                                        style: const TextStyle(
                                            color: Colors.green,
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
          categoriesList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: SizedBox(
                    height: 35,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: categoriesList
                            .map(
                              (catego) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  height: 35,
                                  color: chipCategories.toUpperCase() ==
                                          catego.toUpperCase()
                                      ? Colors.red
                                      : Colors.blue,
                                  child: Row(
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            chipCategories = '';
                                            chipCategories = catego.toString();
                                            listActividadesFilter = List.from(
                                                listActividades
                                                    .where((x) =>
                                                        x.fullName!
                                                            .toUpperCase() ==
                                                        chipCategories
                                                            .toUpperCase())
                                                    .toList());
                                            setState(() {});
                                          },
                                          child: Text(
                                            catego,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )),
                                      chipCategories.toUpperCase() ==
                                              catego.toUpperCase()
                                          ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  chipCategories = '';
                                                  listActividadesFilter =
                                                      List.from(
                                                          listActividades);
                                                });
                                              },
                                              icon: const Icon(Icons.close,
                                                  color: Colors.white))
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class DialogActividades extends StatefulWidget {
  const DialogActividades({super.key});

  @override
  State<DialogActividades> createState() => _DialogActividadesState();
}

class _DialogActividadesState extends State<DialogActividades> {
  String idType = '';
  TextEditingController notaController = TextEditingController();

  Future getTipoActividades() async {
    String selectTypeActividadesDaysFoxin =
        'http://$ipLocal/settingmat/admin/select/select_type_actividades_days.php';
    List listType = [];
    final res = await httpRequestDatabase(
        selectTypeActividadesDaysFoxin, {'view': 'view'});
    listType = json.decode(res.body) as List;
    // print(listType.runtimeType);
    return listType;
  }

  sendData(context) async {
    String insertActividadesDaysFoxin =
        'http://$ipLocal/settingmat/admin/insert/insert_actividades_days.php';
    if (notaController.text.isNotEmpty && idType != '') {
      var data = {
        'full_name': currentUsers?.fullName ?? 'N/A',
        'id_type': idType,
        'nota': notaController.text.isNotEmpty ? notaController.text : 'N/A',
        'start_time': DateTime.now().toString().substring(0, 19)
      };
      await httpRequestDatabase(insertActividadesDaysFoxin, data);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 250,
            child: Container(
              margin: const EdgeInsets.all(5.0),
              color: Colors.white,
              child: FutureBuilder(
                future: getTipoActividades(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(child: LinearProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text('Error al cargar los datos');
                  } else {
                    return DropDownMenuActividades(
                      unidadesMedida: snapshot.data,
                      onChanged: (newValue) {
                        // print(
                        //     'Aquí puedes utilizar newValue en tu formulario');
                        // print(newValue?.idUnidadMedida);
                        idType = newValue!;
                        // Aquí puedes utilizar newValue en tu formulario
                      },
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(
            width: 250,
            child: Container(
              margin: const EdgeInsets.all(5.0),
              color: Colors.white,
              child: TextField(
                controller: notaController,
                decoration: const InputDecoration(
                    hintText: 'Nota Actividad',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15, top: 10)),
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: ElevatedButton(
                onPressed: () => sendData(context),
                child: const Text('Enviar')),
          )
        ],
      ),
    );
  }
}

class DropDownMenuActividades extends StatefulWidget {
  const DropDownMenuActividades(
      {super.key, required this.onChanged, required this.unidadesMedida});

  final void Function(String? idType) onChanged;

  final List? unidadesMedida;
  @override
  State<DropDownMenuActividades> createState() =>
      _DropDownMenuActividadesState();
}

class _DropDownMenuActividadesState extends State<DropDownMenuActividades> {
  String? selectedValue; // Valor inicial

  @override
  void initState() {
    super.initState();
    selectedValue = widget.unidadesMedida?[0]['id'].toString();
    widget.onChanged(selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      onChanged: (val) {
        setState(() {
          selectedValue = val;
          widget.onChanged(val);
        });
      },
      items: widget.unidadesMedida?.map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem<String>(
          value: value['id'],
          child: Text(value['type_name']),
        );
      }).toList(),
    );
  }
}
