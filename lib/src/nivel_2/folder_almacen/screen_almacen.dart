import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/model/department.dart';
import '/src/nivel_2/folder_almacen/add_almacen_orden.dart';
import '/src/nivel_2/folder_almacen/model_data/almacen_data.dart';
import '/src/nivel_2/folder_almacen/show_details_dialog.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/get_formatted_number.dart';
import '/src/util/show_mesenger.dart';

import '../../util/helper.dart';
import '../../widgets/pick_range_date.dart';
import '../folder_reception/file_view_orden.dart';

class ScreenAlmacen extends StatefulWidget {
  const ScreenAlmacen({super.key, required this.current});
  final Department current;

  @override
  State<ScreenAlmacen> createState() => _ScreenAlmacenState();
}

class _ScreenAlmacenState extends State<ScreenAlmacen> {
  String? _secondDate = DateTime.now().toString().substring(0, 10);
  String? _firstDate = DateTime.now().toString().substring(0, 10);
  List<AlmacenData> list = [];
  List<AlmacenData> listFilter = [];

  Future getDataAlmacen() async {
    String selectAlmacenByDate1 =
        "http://$ipLocal/settingmat/admin/select/select_almacen_item_get.php";
    final res = await httpRequestDatabase(
        selectAlmacenByDate1, {'date1': _firstDate, 'date2': _secondDate});
    list = almacenDataFromJson(res.body);
    listFilter = list;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDataAlmacen();
  }

  // List<AlmacenData> listFilterExample = [];

  void getListIncidencia(value) {
    setState(() {
      listFilter = AlmacenData.getTotalListIsIncidencia(list, value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Almacen'),
        actions: [
          Tooltip(
              message: 'Quitar Filtro',
              child: IconButton(
                  onPressed: normalizar,
                  icon: const Icon(Icons.filter_list_off_sharp))),
          Tooltip(
              message: 'Buscar en Fecha',
              child: IconButton(
                  onPressed: () {
                    selectDateRangeNew(context, (date1, date2) {
                      setState(() {
                        _firstDate = date1.toString();
                        _secondDate = date2.toString();
                        list.clear();
                      });
                      getDataAlmacen();
                    });
                  },
                  icon: const Icon(Icons.calendar_month))),
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () async {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddAlmacenOrden(current: widget.current)))
                    .then((value) {
                  getDataAlmacen();
                });
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          SlideInLeft(
            curve: Curves.elasticInOut,
            child: buildTextFieldValidator(
              onChanged: (val) => searchingFilter(val),
              hintText: 'Escribir Algo!',
              label: 'Buscar',
            ),
          ),
          listFilter.isNotEmpty
              ? Expanded(
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
                          dataRowMinHeight: 15,
                          horizontalMargin: 10.0,
                          columnSpacing: 15,
                          headingRowHeight: 25,
                          decoration: const BoxDecoration(color: colorsOrange),
                          headingTextStyle:
                              const TextStyle(color: Colors.white),
                          border: TableBorder.symmetric(
                              outside: BorderSide(
                                  color: Colors.grey.shade100,
                                  style: BorderStyle.none),
                              inside: const BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.grey)),
                          columns: const [
                            DataColumn(label: Text('Ficha')),
                            DataColumn(label: Text('Orden')),
                            DataColumn(label: Text('Nombre Producto')),
                            DataColumn(label: Text('Cantidad')),
                            DataColumn(label: Text('Precios')),
                            DataColumn(label: Text('Total')),
                            DataColumn(label: Text('Cliente')),
                            DataColumn(label: Text('Fecha')),
                            DataColumn(label: Text('Empleado')),
                            DataColumn(label: Text('Motivo Salida')),
                          ],
                          rows: listFilter.asMap().entries.map((entry) {
                            int index = entry.key;
                            AlmacenData item = entry.value;
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
                                DataCell(Center(child: Text(item.ficha ?? '')),
                                    onTap: () =>
                                        filterOnlyFicha(item.ficha ?? 'N/A'),
                                    onDoubleTap: normalizar),
                                DataCell(
                                  Row(
                                    children: [
                                      Text(item.numOrden ?? ''),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (conext) =>
                                                      FileViewer(
                                                          numOrden:
                                                              item.numOrden)),
                                            );
                                          },
                                          child: const Text('Click !'))
                                    ],
                                  ),
                                  onTap: () =>
                                      filterOnlyOrden(item.numOrden ?? 'N/A'),
                                  onDoubleTap: normalizar,
                                ),
                                DataCell(
                                    Text(
                                      item.nameProducto != null &&
                                              item.nameProducto!.length > 15
                                          ? '${item.nameProducto!.substring(0, 15)}...'
                                          : item.nameProducto ?? '',
                                    ), onTap: () {
                                  utilShowMesenger(
                                      context, item.nameProducto ?? '');
                                }),
                                DataCell(Center(child: Text(item.cant ?? ''))),
                                DataCell(Text(
                                    '\$ ${getNumFormatedDouble(item.price ?? '0.0')}')),
                                DataCell(Text(
                                    '\$ ${getNumFormatedDouble(item.resultado ?? '0.0')}')),
                                DataCell(Text(
                                  item.cliente != null &&
                                          item.cliente!.length > 25
                                      ? '${item.cliente!.substring(0, 25)}...'
                                      : item.cliente ?? '',
                                )),
                                DataCell(Text(item.dateCurrent ?? '')),
                                DataCell(Text(item.fullName ?? '')),
                                DataCell(
                                  Center(
                                    child: Text(item.isIncidencia == 'f'
                                        ? 'Normal'
                                        : 'Por Incidencia'),
                                  ),
                                  onTap: () => getListIncidencia(
                                      item.isIncidencia.toString()),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                )
              : const Expanded(child: Center(child: Text('No hay Data'))),
          listFilter.isNotEmpty
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
                                  Text('Items : ', style: style.bodySmall),
                                  const SizedBox(width: 10),
                                  Text(listFilter.length.toString(),
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
                                  Text('Piezas. : ', style: style.bodySmall),
                                  const SizedBox(width: 10),
                                  Text(
                                      getNumFormatedDouble(
                                          AlmacenData.getTotal(listFilter)),
                                      style: style.bodySmall?.copyWith(
                                          color: Colors.black54,
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
                                  Text('Costo :', style: style.bodySmall),
                                  const SizedBox(width: 10),
                                  Text(
                                      getNumFormatedDouble(
                                          AlmacenData.getTotalCost(listFilter)),
                                      style: style.bodySmall?.copyWith(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
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

  showDetails(AlmacenData item) async {
    showDialog(
      context: context,
      builder: (_) {
        return ShowDetailsDialog(item: item);
      },
    );
  }

  void searchingFilter(String val) {
    if (val.isNotEmpty) {
      listFilter = List.from(list
          .where((x) =>
              x.ficha!.toUpperCase().contains(val.toUpperCase()) ||
              x.cliente!.toUpperCase().contains(val.toUpperCase()) ||
              x.fullName!.toUpperCase().contains(val.toUpperCase()) ||
              x.numOrden!.toUpperCase().contains(val.toUpperCase()))
          .toList());
      setState(() {});
    } else {
      listFilter = list;
      setState(() {});
    }
  }

  void normalizar() {
    setState(() {
      listFilter = list;
    });
  }

  void filterOnlyFicha(String val) {
    setState(() {
      listFilter = List.from(list
          .where((x) => x.ficha!.toUpperCase() == val.toUpperCase())
          .toList());
    });
  }

  void filterOnlyOrden(String val) {
    setState(() {
      listFilter = List.from(list
          .where((x) => x.numOrden!.toUpperCase() == val.toUpperCase())
          .toList());
    });
  }
}
