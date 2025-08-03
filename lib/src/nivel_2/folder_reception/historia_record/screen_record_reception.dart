import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/nivel_2/folder_reception/print_reception/print_reception_orden.dart';
import '/src/screen_print_pdf/apis/pdf_api.dart';
import '/src/util/show_mesenger.dart';
import '/src/widgets/loading.dart';
import '../../../model/users.dart';
import '../../../util/commo_pallete.dart';
import '../../../util/helper.dart';
import '../../../widgets/pick_range_date.dart';
import '../../folder_planificacion/model_planificacion/planificacion_last.dart';
import '../../folder_planificacion/url_planificacion/url_planificacion.dart';
import '../file_view_orden.dart';
import '../seguimiento_orden.dart';

class ScreenRecordReception extends StatefulWidget {
  const ScreenRecordReception({super.key});

  @override
  State<ScreenRecordReception> createState() => _ScreenRecordReceptionState();
}

class _ScreenRecordReceptionState extends State<ScreenRecordReception> {
  String? _firstDate = DateTime.now().toString().substring(0, 10);
  String? _secondDate = DateTime.now().toString().substring(0, 10);

  @override
  void initState() {
    super.initState();
    _firstDate = DateTime.now().toString().substring(0, 10);
    _secondDate = DateTime.now().toString().substring(0, 10);
    getRecord('t', _firstDate, _secondDate);
  }

  List<PlanificacionLast> listRecord = [];
  List<PlanificacionLast> listRecordFilter = [];

  Future getRecord(String isDone, date1, date2) async {
    final res = await httpRequestDatabase(selectPlanificacionLastRecordByDate,
        {'is_entregado': isDone, 'date1': date1, 'date2': date2});
    listRecord = planificacionLastFromJson(res.body);
    listRecordFilter = [...listRecord];
    setState(() {});
  }

  Future getRecordByDelirery(String isDone, date1, date2) async {
    final res = await httpRequestDatabase(
        selectPlanificacionLastRecordDeliveredByDate,
        {'is_entregado': isDone, 'date1': date1, 'date2': date2});
    listRecord = planificacionLastFromJson(res.body);
    listRecordFilter = [...listRecord];
    setState(() {});
  }

  Future getRecordByDateCreated(String isDone, date1, date2) async {
    final res = await httpRequestDatabase(
        selectPlanificacionLastRecordFechaStartByDate,
        {'is_entregado': isDone, 'date1': date1, 'date2': date2});
    listRecord = planificacionLastFromJson(res.body);
    listRecordFilter = [...listRecord];
    setState(() {});
  }

  void _searchingFilter(String val) {
    // print(val);
    if (val.isNotEmpty) {
      listRecordFilter = List.from(listRecord
          .where((x) =>
              x.cliente!.toUpperCase().contains(val.toUpperCase()) ||
              x.clienteTelefono!.toUpperCase().contains(val.toUpperCase()) ||
              x.numOrden!.toUpperCase().contains(val.toUpperCase()) ||
              x.userEntregaOrden!.toUpperCase().contains(val.toUpperCase()) ||
              x.userRegistroOrden!.toUpperCase().contains(val.toUpperCase()) ||
              x.nameLogo!.toUpperCase().contains(val.toUpperCase()) ||
              x.ficha!.toUpperCase().contains(val.toUpperCase()))
          .toList());

      setState(() {});
    } else {
      listRecordFilter = [...listRecord];

      setState(() {});
    }
  }

///////este eliminar los item de una orden completa///
  Future eliminarOrden(id) async {
    shomMjs(mjs) => utilShowMesenger(context, mjs);
    final res = await httpRequestDatabase(
        deleteProductoPlanificacionLastRecord, {'id': '$id'});
    // print(res.body);
    if (res.body.toString().contains('good')) {
      listRecordFilter.removeWhere((item) => item.id == id);
      setState(() {});
    } else {
      shomMjs('Tiene que eliminar los producto que existen de esta orden');
    }
  }

  // Función para actualizar el estado de los checkboxes
  void _handleCheckboxChange(String type, bool value) {
    setState(() {
      if (type == 'delivered') {
        isDelivered = value;
        isDateCreated =
            !value; // Desmarcar "Fecha Registradas" si se marca "Entregada a la fecha"
        if (isDelivered) {
          getRecordByDelirery('t', _firstDate, _secondDate);
        } else {
          getRecord('t', _firstDate, _secondDate);
        }
      } else if (type == 'created') {
        isDateCreated = value;
        isDelivered =
            !value; // Desmarcar "Entregada a la fecha" si se marca "Fecha Registradas"
        if (isDateCreated) {
          getRecordByDateCreated('t', _firstDate, _secondDate);
        }
      }
    });
  }

  bool isDelivered = false;
  bool isDateCreated = false;
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Saquetas Entregadas'),
        actions: [
          Tooltip(
              message: 'Buscar en Fecha',
              child: IconButton(
                  onPressed: () {
                    selectDateRangeNew(context, (date1, date2) {
                      setState(() {
                        _firstDate = date1.toString();
                        _secondDate = date2.toString();
                        isDateCreated = false;
                        isDelivered = false;
                      });

                      getRecord('t', _firstDate, _secondDate);
                      setState(() {});
                    });
                  },
                  icon: const Icon(Icons.calendar_month))),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: const Icon(Icons.print, color: Colors.black),
              onPressed: () async {
                if (listRecordFilter.isNotEmpty) {
                  final pdfFile = await PdfReceptionOrdenes.generate(
                      listRecordFilter, _firstDate, _secondDate, '0', '0');

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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BounceInDown(
                curve: Curves.elasticInOut,
                child: Row(
                  children: [
                    const Text('Entrega'),
                    Checkbox(
                      value: isDelivered,
                      onChanged: (val) {
                        _handleCheckboxChange('delivered', val!);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              BounceInUp(
                curve: Curves.elasticInOut,
                child: Row(
                  children: [
                    const Text('Registro'),
                    Checkbox(
                      value: isDateCreated,
                      onChanged: (val) {
                        _handleCheckboxChange('created', val!);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SlideInLeft(
            curve: Curves.elasticInOut,
            child: buildTextFieldValidator(
              onChanged: (val) => _searchingFilter(val),
              hintText: 'Escribir Algo!',
              label: 'Buscar',
            ),
          ),
          listRecordFilter.isNotEmpty
              ? Expanded(
                  child: TableModifica(
                    current: listRecordFilter,
                    delete: (id) => eliminarOrden(id),
                  ),
                )
              : const Expanded(
                  child: Center(
                    child: Loading(
                      isLoading: false,
                      text: 'No hay datos...',
                    ),
                  ),
                ),
          listRecord.isNotEmpty
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
                                  Text('Orden : ', style: style.bodySmall),
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
                                  Text('Piezas :', style: style.bodySmall),
                                  const SizedBox(width: 10),
                                  Text('N/A',
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
  const TableModifica({super.key, this.current, required this.delete});

  final List<PlanificacionLast>? current;
  final Function delete;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: DataTable(
            dataRowMaxHeight: 25,
            dataRowMinHeight: 15,
            horizontalMargin: 10.0,
            columnSpacing: 15,
            headingRowHeight: 25,
            decoration: const BoxDecoration(color: colorsGreenTablas),
            headingTextStyle: const TextStyle(color: Colors.white),
            border: TableBorder.symmetric(
                outside: BorderSide(
                    color: Colors.grey.shade100, style: BorderStyle.none),
                inside: const BorderSide(
                    style: BorderStyle.solid, color: Colors.grey)),
            columns: const [
              DataColumn(label: Text('Created Orden')),
              DataColumn(label: Text('Num Orden')),
              DataColumn(label: Text('Fichas')),
              DataColumn(label: Text('Logo')),
              DataColumn(label: Text('Cliente')),
              DataColumn(label: Text('Cliente Telefono')),
              DataColumn(label: Text('Fecha Creación')),
              DataColumn(label: Text('Fecha de entrega')),
              DataColumn(label: Text('Seguimiento')),
              DataColumn(label: Text('Entregador/a')),
              DataColumn(label: Text('Comment')),
              DataColumn(label: Text('Entrega Ficha')),
              DataColumn(label: Text('Eliminar')),
            ],
            rows: current!.asMap().entries.map((entry) {
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
                  DataCell(const Center(child: Text('Click!')), onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (conext) => SeguimientoOrden(item: item)));
                  }),
                  DataCell(Text(item.userRegistroOrden ?? '')),
                  DataCell(Center(child: Text(item.numOrden ?? '')), onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (conext) =>
                              FileViewer(numOrden: item.numOrden)),
                    );
                  }),
                  DataCell(Center(child: Text(item.ficha ?? ''))),
                  DataCell(Text(item.nameLogo ?? '')),
                  DataCell(Text(item.cliente ?? '')),
                  DataCell(Text(item.clienteTelefono ?? '')),
                  DataCell(Text(item.fechaStart ?? '')),
                  DataCell(Text(item.fechaEntrega ?? '')),
                  DataCell(Text(item.userEntregaOrden ?? '')),
                  DataCell(
                      SizedBox(
                        width: 100,
                        child: Text(
                          item.comment ?? '',
                          style:
                              const TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                      ), onTap: () {
                    utilShowMesenger(context, item.comment ?? '');
                  }),
                  DataCell(Text(item.dateDelivered ?? '')),
                  DataCell(hasPermissionUsuario(
                          currentUsers!.listPermission!, "admin", "eliminar")
                      ? TextButton(
                          onPressed: () => delete(item.id),
                          child: const Text('Eliminar'))
                      : const Text('Sin Permiso')),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );

    // SizedBox(
    //   child: SingleChildScrollView(
    //     padding: const EdgeInsets.all(25),
    //     scrollDirection: Axis.horizontal,
    //     physics: const BouncingScrollPhysics(),
    //     child: SingleChildScrollView(
    //       scrollDirection: Axis.vertical,
    //       physics: const BouncingScrollPhysics(),
    //       child: DataTable(
    //         dataRowMaxHeight: 20,
    //         dataRowMinHeight: 15,
    //         horizontalMargin: 10.0,
    //         columnSpacing: 15,
    //         decoration: const BoxDecoration(
    //           gradient: LinearGradient(
    //             colors: [
    //               Color.fromARGB(255, 205, 208, 221),
    //               Color.fromARGB(255, 225, 228, 241),
    //               Color.fromARGB(255, 233, 234, 238),
    //             ],
    //           ),
    //         ),
    //         border: TableBorder.symmetric(
    //             inside: const BorderSide(
    //                 style: BorderStyle.solid, color: Colors.grey)),
    //         columns: const [
    //           DataColumn(label: Text('Created Orden')),
    //           DataColumn(label: Text('Numero Orden')),
    //           DataColumn(label: Text('Fichas')),
    //           DataColumn(label: Text('Logo')),
    //           DataColumn(label: Text('Cliente')),
    //           DataColumn(label: Text('Cliente Telefono')),
    //           DataColumn(label: Text('Fecha Creación')),
    //           DataColumn(label: Text('Fecha de entrega')),
    //           DataColumn(label: Text('Seguimiento')),
    //           DataColumn(label: Text('Entregador/a')),
    //           DataColumn(label: Text('Comment')),
    //           DataColumn(label: Text('Entrega Ficha')),
    //         ],
    //         rows: current!
    //             .map(
    //               (item) => DataRow(
    //                 color: MaterialStateProperty.resolveWith(
    //                     (states) => getColor(item)),
    //                 cells: [
    //                   DataCell(Text(item.userRegistroOrden ?? '')),
    //                   DataCell(Row(
    //                     children: [
    //                       Text(item.numOrden ?? ''),
    //                       currentUsers?.occupation == OptionAdmin.master.name ||
    //                               currentUsers?.occupation ==
    //                                   OptionAdmin.admin.name
    //                           ? TextButton(
    //                               onPressed: () => delete(item.id),
    //                               child: const Text('Eliminar'))
    //                           : const SizedBox()
    //                     ],
    //                   )),
    //                   DataCell(Text(item.ficha ?? '')),
    //                   DataCell(Text(item.nameLogo ?? '')),
    //                   DataCell(Text(item.cliente ?? '')),
    //                   DataCell(Text(item.clienteTelefono ?? '')),
    //                   DataCell(Text(item.fechaStart ?? '')),
    //                   DataCell(Text(item.fechaEntrega ?? '')),
    //                   DataCell(TextButton(
    //                     onPressed: () {
    //                       Navigator.push(
    //                           context,
    //                           MaterialPageRoute(
    //                               builder: (conext) =>
    //                                   SeguimientoOrdenRecord(item: item)));
    //                     },
    //                     child: const Text('CLICK!'),
    //                   )),
    //                   DataCell(Text(item.userEntregaOrden ?? '')),
    //                   DataCell(
    //                       SizedBox(
    //                         width: 100,
    //                         child: Text(
    //                           item.comment ?? '',
    //                           style: const TextStyle(
    //                               overflow: TextOverflow.ellipsis),
    //                         ),
    //                       ), onTap: () {
    //                     utilShowMesenger(context, item.comment ?? '');
    //                   }),
    //                   DataCell(Text(item.dateDelivered ?? '')),
    //                 ],
    //               ),
    //             )
    //             .toList(),
    //       ),
    //     ),
    //   ),
    // );
  }
}

bool comparaTime(DateTime time1) {
  // Creamos las dos fechas a comparar
  // DateTime fecha1 = DateTime(2022, 5, 1);
  DateTime fecha2 = DateTime.now();
  DateTime soloFecha = DateTime(fecha2.year, fecha2.month, fecha2.day - 1);
  // debugPrint('Fecha de Entrega es : $soloFecha comparar con $fecha2');
  // print('La fecha soloFecha $soloFecha');
  if (soloFecha.isBefore(time1)) {
    // print(true);
    return true;
  } else {
    // print(false);
    return false;
  }

// // Comparamos las fechas
  // if (time1.isAfter(soloFecha)) {
  //   print('Ya se cumplio la fecha');
  //   print(true);
  //   return true;
  // }
  // return false;
}

class MyDropdownMenu extends StatefulWidget {
  const MyDropdownMenu({super.key, required this.pressSearching});
  final Function pressSearching;

  @override
  State<MyDropdownMenu> createState() => _MyDropdownMenuState();
}

class _MyDropdownMenuState extends State<MyDropdownMenu> {
  String _selectedOption =
      'Pendientes y por Entregar'; // Opción seleccionada inicialmente

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedOption,
      onChanged: (String? newValue) {
        setState(() {
          _selectedOption = newValue!;
          widget.pressSearching(_selectedOption);
        });
      },
      items: <String>[
        'Pendientes y por Entregar',
        'Entregadas',
        'Por Entregar',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
