import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '/src/datebase/current_data.dart';
import '/src/nivel_2/folder_planificacion/model_planificacion/item_planificacion.dart';
import '/src/nivel_2/folder_planificacion/url_planificacion/url_planificacion.dart';
import '/src/screen_print_pdf/apis/pdf_api.dart';
import '/src/util/get_formatted_number.dart';
import '/src/util/helper.dart';
import '/src/util/show_mesenger.dart';
import '../../../datebase/methond.dart';
import '../../../util/commo_pallete.dart';
import '../../../widgets/pick_range_date.dart';
import '../folder_print_planificacion/print_planificacion.dart';

class ScreenRecordPlanificacion extends StatefulWidget {
  const ScreenRecordPlanificacion({super.key});

  @override
  State<ScreenRecordPlanificacion> createState() =>
      _ScreenRecordPlanificacionState();
}

class _ScreenRecordPlanificacionState extends State<ScreenRecordPlanificacion> {
  String? _firstDate = DateTime.now().toString().substring(0, 10);
  String? _secondDate = DateTime.now().toString().substring(0, 10);
  List<PlanificacionItem> listRecord = [];
  List<PlanificacionItem> listRecordFilter = [];
  List<String> _options = [];
  String departmentSelected = '';
  @override
  void initState() {
    super.initState();
    _firstDate = DateTime.now().toString().substring(0, 10);
    _secondDate = DateTime.now().toString().substring(0, 10);
    getRecord('t', _firstDate, _secondDate);
  }

  Future getRecord(String isDone, date1, date2) async {
    final res = await httpRequestDatabase(
        selectProductoPlanificacionLastRecordByDate,
        {'is_done': isDone, 'date1': date1, 'date2': date2});
    listRecord = planificacionItemFromJson(res.body);
    listRecordFilter = listRecord;
    _options = PlanificacionItem.getUniqueDepartmentList(listRecord);
    setState(() {});
  }

  void _searchingFilter(String val) {
    if (departmentSelected.isNotEmpty) {
      // Filtrar por búsqueda (val) y por el departamento seleccionado
      listRecordFilter = listRecord.where((x) {
        // Condiciones para la búsqueda por ficha, numOrden o nameLogo
        final matchesSearch =
            x.ficha!.toUpperCase().contains(val.toUpperCase()) ||
                x.numOrden!.toUpperCase().contains(val.toUpperCase()) ||
                x.nameLogo!.toUpperCase().contains(val.toUpperCase());

        // Condición para el filtro por departamento
        final matchesDepartment =
            x.department!.toUpperCase() == departmentSelected.toUpperCase();

        // Ambas condiciones deben ser verdaderas
        return matchesSearch && matchesDepartment;
      }).toList();
    } else {
      // Si no hay departamento seleccionado, solo filtrar por la búsqueda
      if (val.isNotEmpty) {
        listRecordFilter = listRecord.where((x) {
          return x.ficha!.toUpperCase().contains(val.toUpperCase()) ||
              x.numOrden!.toUpperCase().contains(val.toUpperCase()) ||
              x.nameLogo!.toUpperCase().contains(val.toUpperCase());
        }).toList();
      } else {
        // Si no hay búsqueda ni filtro, mostrar la lista completa
        listRecordFilter = listRecord;
      }
    }
    setState(() {});
  }

  // String getTotalCant(List<PlanificacionItem> list) {
  //   int total = 0;
  //   for (var item in list) {
  //     total += int.parse(item.cant ?? '0');
  //   }

  //   return total.toString();
  // }

  normalizar() {
    setState(() {
      departmentSelected = '';
      listRecordFilter = listRecord;
    });
  }

  searchingArea(value) {
    departmentSelected = value;
    setState(() {
      listRecordFilter = List.from(listRecord
          .where(
              (x) => x.department!.toUpperCase().contains(value.toUpperCase()))
          .toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    const shadow =
        BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 10);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Planificación'),
        actions: [
          Tooltip(
            message: 'Quitar filtro',
            child: IconButton(
                icon: Icon(
                    departmentSelected.isEmpty
                        ? Icons.filter_alt_outlined
                        : Icons.filter_alt_off_outlined,
                    color: departmentSelected.isNotEmpty
                        ? Colors.red
                        : Colors.black),
                onPressed: normalizar),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
                icon: const Icon(Icons.calendar_month_outlined,
                    color: Colors.black),
                onPressed: () {
                  selectDateRangeNew(context, (date1, date2) {
                    setState(() {
                      _firstDate = date1.toString();
                      _secondDate = date2.toString();
                      listRecordFilter.clear();
                    });
                    getRecord('t', _firstDate, _secondDate);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
                icon: const Icon(Icons.print_outlined, color: Colors.black),
                onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Se esta programando esta parte!'),
                      duration: Duration(seconds: 1),
                      backgroundColor: Colors.red,
                    ),
                  );
                  // if (listRecordFilter.isNotEmpty) {
                  //   final pdfFile = await PdfPlanificacion.generate(
                  //       listRecordFilter, _firstDate, _secondDate);
                  //   PdfApi.openFile(pdfFile);
                  // }
                }),
          ),
          Container(
            // Agregado un contenedor para ajustar el espacio
            margin: const EdgeInsets.only(right: 16),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                // Aquí puedes manejar la opción seleccionada
                // print('Opción seleccionada: $value');
                if (value.toUpperCase() == 'TERMINADO') {
                  setState(() {
                    listRecordFilter = List.from(listRecord
                        .where((x) => x.isDone!.toUpperCase().contains('T'))
                        .toList());
                  });
                } else {
                  setState(() {
                    listRecordFilter = List.from(listRecord
                        .where((x) => x.isDone!.toUpperCase().contains('F'))
                        .toList());
                  });
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 'Terminado',
                    child: Text('Terminado'),
                  ),
                  const PopupMenuItem(
                    value: 'Global',
                    child: Text('Global'),
                  ),
                ];
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          BounceInDown(
            curve: Curves.elasticInOut,
            child: buildTextFieldValidator(
                onChanged: (val) => _searchingFilter(val),
                hintText: 'Escribir Algo!',
                label: 'Buscar'),
          ),
          SizedBox(
            height: 60,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: PlanificacionItem.getUniqueDepartmentList(listRecord)
                    .map((value) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: departmentSelected == value
                                  ? colorsBlueTurquesa
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: const [shadow]),
                          child: TextButton(
                            child: Text(value,
                                style: TextStyle(
                                    color: departmentSelected == value
                                        ? Colors.white
                                        : colorsAd)),
                            onPressed: () {
                              searchingArea(value);
                            },
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          listRecordFilter.isNotEmpty
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
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
                          decoration:
                              const BoxDecoration(color: colorsGreenTablas),
                          headingTextStyle: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          border: TableBorder.symmetric(
                              outside: BorderSide(
                                  color: Colors.grey.shade100,
                                  style: BorderStyle.none),
                              inside: const BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.grey)),
                          columns: [
                            DataColumn(
                                label: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Departamentos'),
                                listRecord.isEmpty
                                    ? const SizedBox()
                                    : PopupMenuButton<String>(
                                        icon: Icon(Icons.arrow_drop_down,
                                            size: style.bodyLarge?.fontSize,
                                            color: Colors.white),
                                        iconSize: 20,
                                        onSelected: (String value) {
                                          searchingArea(value);
                                        },
                                        itemBuilder: (BuildContext context) {
                                          return _options
                                              .map<PopupMenuEntry<String>>(
                                                  (String value) {
                                            return PopupMenuItem<String>(
                                              value: value,
                                              height: 20,
                                              child: Text(value),
                                            );
                                          }).toList();
                                        },
                                      )
                              ],
                            )),
                            const DataColumn(label: Text('Estado')),
                            const DataColumn(label: Text('Num Orden')),
                            const DataColumn(label: Text('Fichas')),
                            const DataColumn(label: Text('Logo')),
                            const DataColumn(label: Text('Producto')),
                            const DataColumn(label: Text('Cant')),
                            const DataColumn(label: Text('Comentario')),
                            const DataColumn(label: Text('Fecha Entrega')),
                          ],
                          rows: listRecordFilter.asMap().entries.map((entry) {
                            int index = entry.key;
                            var item = entry.value;
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
                                DataCell(Text(item.department ?? '')),
                                DataCell(
                                  onTap: () {
                                    utilShowMesenger(context, item.statu ?? '',
                                        title: 'STATU');
                                  },
                                  SizedBox(
                                    width: 50,
                                    child: Text(
                                      item.statu ?? '',
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                ),
                                DataCell(Text(item.numOrden ?? '')),
                                DataCell(
                                  onTap: () {
                                    utilShowMesenger(context, item.ficha ?? '',
                                        title: 'FICHA');
                                  },
                                  SizedBox(
                                    width: 50,
                                    child: Text(
                                      item.ficha ?? '',
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  onTap: () {
                                    utilShowMesenger(
                                        context, item.nameLogo ?? '',
                                        title: 'LOGO');
                                  },
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      item.nameLogo ?? '',
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  onTap: () {
                                    utilShowMesenger(
                                        context, item.tipoProduct ?? '',
                                        title: 'TYPO TRABAJOS');
                                  },
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      item.tipoProduct ?? '',
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                ),
                                DataCell(Text(item.cant ?? '')),
                                DataCell(
                                  SizedBox(
                                    width: 150,
                                    child: GestureDetector(
                                      onTap: () {
                                        utilShowMesenger(
                                            context, item.comment ?? '');
                                      },
                                      child: Text(
                                        item.comment ?? '',
                                        style: const TextStyle(
                                            color: Colors.teal,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Text(item.fechaEnd ?? '')),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                )
              : Expanded(
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
                ),
          listRecordFilter.isNotEmpty
              ? SizedBox(
                  height: 35,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          height: 35,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Total : ', style: style.bodySmall),
                                  const SizedBox(width: 10),
                                  Text(listRecordFilter.length.toString(),
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
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Cant :', style: style.bodySmall),
                                  const SizedBox(width: 10),
                                  Text(
                                      getNumFormatedDouble(
                                          PlanificacionItem.getGetTotal(
                                              listRecordFilter)),
                                      style: style.bodySmall?.copyWith(
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
                )
              : const SizedBox(),
          identy(context)
        ],
      ),
    );
  }
}

class TableModifica extends StatelessWidget {
  const TableModifica({super.key, this.current});
  final List<PlanificacionItem>? current;

  Color getColor(PlanificacionItem planificacion) {
    if (planificacion.statu == onProducion) {
      return Colors.cyan.shade100;
    }
    if (planificacion.statu == onEntregar) {
      return Colors.orangeAccent.shade100;
    }
    if (planificacion.statu == onParada) {
      return Colors.redAccent.shade200;
    }
    if (planificacion.statu == onProceso) {
      return Colors.teal.shade200;
    }
    if (planificacion.statu == onFallo) {
      return Colors.black54;
    }
    if (planificacion.statu == onDone) {
      return Colors.green.shade200;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
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
                outside: BorderSide(
                    color: Colors.grey.shade100, style: BorderStyle.none),
                inside: const BorderSide(
                    style: BorderStyle.solid, color: Colors.grey)),
            columns: const [
              DataColumn(label: Text('Departamento')),
              DataColumn(label: Text('Estado')),
              DataColumn(label: Text('Num Orden')),
              DataColumn(label: Text('Fichas')),
              DataColumn(label: Text('Logo')),
              DataColumn(label: Text('Producto')),
              DataColumn(label: Text('Cant'), numeric: true),
              DataColumn(label: Text('Comentario')),
              DataColumn(label: Text('Fecha Entrega')),
            ],
            rows: current!
                .map(
                  (item) => DataRow(
                    selected: true,
                    color: MaterialStateProperty.resolveWith(
                        (states) => getColor(item)),
                    cells: [
                      DataCell(Text(item.department ?? '')),
                      DataCell(
                        onTap: () {
                          utilShowMesenger(context, item.statu ?? '',
                              title: 'STATU');
                        },
                        SizedBox(
                          width: 50,
                          child: Text(
                            item.statu ?? '',
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                      DataCell(Text(item.numOrden ?? '')),
                      DataCell(
                        onTap: () {
                          utilShowMesenger(context, item.ficha ?? '',
                              title: 'FICHA');
                        },
                        SizedBox(
                          width: 50,
                          child: Text(
                            item.ficha ?? '',
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                      DataCell(
                        onTap: () {
                          utilShowMesenger(context, item.nameLogo ?? '',
                              title: 'LOGO');
                        },
                        SizedBox(
                          width: 100,
                          child: Text(
                            item.nameLogo ?? '',
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                      DataCell(
                        onTap: () {
                          utilShowMesenger(context, item.tipoProduct ?? '',
                              title: 'TYPO TRABAJOS');
                        },
                        SizedBox(
                          width: 100,
                          child: Text(
                            item.tipoProduct ?? '',
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                      DataCell(Text(item.cant ?? '')),
                      DataCell(
                        SizedBox(
                          width: 150,
                          child: GestureDetector(
                            onTap: () {
                              utilShowMesenger(context, item.comment ?? '');
                            },
                            child: Text(
                              item.comment ?? '',
                              style: const TextStyle(
                                  color: Colors.teal,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ),
                      ),
                      DataCell(Text(item.fechaEnd ?? '')),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
