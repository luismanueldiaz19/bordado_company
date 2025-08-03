//select_trabajo_diseno_by_date

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/nivel_2/folder_diseno/model_diseno/atencion_cliente.dart';
import '/src/screen_print_pdf/apis/pdf_api.dart';
import '/src/util/show_mesenger.dart';
import '/src/widgets/custom_app_bar.dart';
import '/src/widgets/picked_date_widget.dart';

import '../folder_print_diseno/print_trabajos_disenos.dart';

class ScreenTrabajosDiseno extends StatefulWidget {
  const ScreenTrabajosDiseno({Key? key}) : super(key: key);

  @override
  State<ScreenTrabajosDiseno> createState() => _ScreenTrabajosDisenoState();
}

class _ScreenTrabajosDisenoState extends State<ScreenTrabajosDiseno> {
  String? firstDate = DateTime.now().toString().substring(0, 10);
  String? secondDate = DateTime.now().toString().substring(0, 10);
  List<AtencionCliente> listTrabajoDisenos = [];
  List<AtencionCliente> listTrabajoDisenosFilter = [];
  Future getAntencion() async {
    String selectTrabajoDisenoByDate =
        "http://$ipLocal/settingmat/admin/select/select_trabajo_diseno_by_date.php";

    // select_atencion_cliente_diseno_by_date
    final res = await httpRequestDatabase(
        selectTrabajoDisenoByDate, {'date1': firstDate, 'date2': secondDate});
    // print(res.body);
    listTrabajoDisenos = atencionClienteFromJson(res.body);
    listTrabajoDisenosFilter = [...listTrabajoDisenos];
    calcular(listTrabajoDisenosFilter);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    firstDate = DateTime.now().toString().substring(0, 10);
    secondDate = DateTime.now().toString().substring(0, 10);
    getAntencion();
  }

  ///////este eliminar los item de una orden completa///
  Future eliminarOrden(id) async {
    String deleteTrabajoDiseno =
        "http://$ipLocal/settingmat/admin/delete/delete_trabajo_diseno.php";

    await httpRequestDatabase(deleteTrabajoDiseno, {'id': '$id'});
    getAntencion();
  }

  void searchingFilter(String val) {
    // print(val);
    if (val.isNotEmpty) {
      listTrabajoDisenosFilter = List.from(listTrabajoDisenos
          .where((x) =>
              x.ficha!.toUpperCase().contains(val.toUpperCase()) ||
              x.logo!.toUpperCase().contains(val.toUpperCase()) ||
              x.userRegistered!.toUpperCase().contains(val.toUpperCase()) ||
              x.numOrden!.toUpperCase().contains(val.toUpperCase()) ||
              x.typeWorked!.toUpperCase().contains(val.toUpperCase()))
          .toList());
      calcular(listTrabajoDisenosFilter);
      setState(() {});
    } else {
      listTrabajoDisenosFilter = [...listTrabajoDisenos];
      calcular(listTrabajoDisenosFilter);
      setState(() {});
    }
  }

  int totalPcs = 0;
  calcular(List<AtencionCliente> localList) {
    totalPcs = 0;

    for (var element in localList) {
      totalPcs += int.parse(element.cantidad ?? '0');
    }
  }

  @override
  Widget build(BuildContext context) {
    final sized = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Historial Trabajos de Diseños'),
          const SizedBox(height: 10),
          FadeIn(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10.0)),
              width: 250,
              child: TextField(
                onChanged: (val) => searchingFilter(val),
                decoration: const InputDecoration(
                  hintText: 'Buscar',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15, top: 10),
                  suffixIcon: Tooltip(
                    message: 'Buscar por ficha/userRegistered/Orden/typeWorked',
                    child: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              TextButton(
                  onPressed: () async {
                    var dateee = await showDatePickerCustom(context: context);
                    firstDate = dateee.toString();
                    // print(_firstDate);
                    setState(() {});
                  },
                  child: Text(firstDate ?? 'N/A')),
              const SizedBox(width: 20),
              const Text('Entre', style: TextStyle(fontSize: 17)),
              const SizedBox(width: 20),
              TextButton(
                  onPressed: () async {
                    var dateee = await showDatePickerCustom(context: context);
                    secondDate = dateee.toString();
                    getAntencion();
                    setState(() {});
                  },
                  child: Text(secondDate ?? 'N/A')),
              const SizedBox(width: 15),
            ],
          ),
          const SizedBox(height: 10),
          listTrabajoDisenos.isNotEmpty
              ? Expanded(
                  child: TableModifica(
                    current: listTrabajoDisenosFilter,
                    pressDelete: (id) => eliminarOrden(id),
                  ),
                )
              : const Center(child: Text('No hay datos')),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total PCS Orden : $totalPcs',
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Total Trabajos : ${listTrabajoDisenosFilter.length}',
                    style: const TextStyle(
                        color: Colors.brown, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          listTrabajoDisenosFilter.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: ElevatedButton.icon(
                      icon: const Icon(Icons.print),
                      onPressed: () async {
                        final pdfFile = await PdfTrabajosDisenos.generate(
                            listTrabajoDisenosFilter);

                        PdfApi.openFile(pdfFile);
                      },
                      label: const Text('Imprimir')),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}

class TableModifica extends StatelessWidget {
  const TableModifica({Key? key, this.current, required this.pressDelete})
      : super(key: key);
  final List<AtencionCliente>? current;
  final Function pressDelete;

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
              DataColumn(label: Text('LOGO')),
              DataColumn(label: Text('Num Orden')),
              DataColumn(label: Text('Ficha')),
              DataColumn(label: Text('Cant')),
              DataColumn(label: Text('Tipo')),
              DataColumn(label: Text('Empezó')),
              DataColumn(label: Text('Termino')),
              DataColumn(label: Text('Promedio')),
              DataColumn(label: Text('Empleado')),
              DataColumn(label: Text('Comentario')),
            ],
            rows: current!
                .map(
                  (item) => DataRow(
                    selected: true,
                    color: MaterialStateProperty.resolveWith(
                        (states) => Colors.white),
                    cells: [
                      DataCell(
                          SizedBox(
                              width: 150,
                              child: Text(item.logo ?? '',
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis))),
                          onTap: () {
                        utilShowMesenger(context, item.logo ?? '',
                            title: 'LOGO');
                      }),
                      DataCell(Row(
                        children: [
                          Text(item.numOrden ?? ''),
                          currentUsers?.occupation == OptionAdmin.admin.name ||
                                  currentUsers?.occupation ==
                                      OptionAdmin.master.name ||
                                  currentUsers?.occupation ==
                                      OptionAdmin.boss.name
                              ? TextButton(
                                  child: const Text(
                                    'Eliminar',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () => pressDelete(item.id))
                              : const SizedBox(),
                        ],
                      )),
                      DataCell(Text(item.ficha ?? '')),
                      DataCell(Text(item.cantidad ?? '',
                          style: const TextStyle(
                              color: Colors.brown,
                              fontWeight: FontWeight.bold))),
                      DataCell(
                          SizedBox(
                              width: 70,
                              child: Text(item.typeWorked ?? '',
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis))),
                          onTap: () {
                        utilShowMesenger(context, item.typeWorked ?? '',
                            title: 'Detalles');
                      }),
                      DataCell(Text(item.dateStart ?? '',
                          style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold))),
                      DataCell(Text(item.dateEnd ?? '',
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold))),
                      DataCell(Text(diferentTime(item),
                          style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold))),
                      DataCell(Text(item.userRegistered ?? '')),
                      DataCell(
                          SizedBox(
                              width: 100,
                              child: Text(item.comment ?? 'N/A',
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis))),
                          onTap: () {
                        utilShowMesenger(context, item.comment ?? '',
                            title: 'comment');
                      }),
                      // DataCell(
                      //     SizedBox(
                      //       width: 150,
                      //       child: Text(
                      //         item.comment ?? '',
                      //         style: const TextStyle(
                      //             overflow: TextOverflow.ellipsis),
                      //       ),
                      //     ), onTap: () {
                      //   showMensenger(context, item.descripcion ?? '',
                      //       title: 'Comentario');
                      // }),
                      // DataCell(
                      //     Row(
                      //       children: [
                      //         SizedBox(
                      //           width: 150,
                      //           child: Text(
                      //             item.typeWorked ?? '',
                      //             style: const TextStyle(
                      //                 color: Colors.black,
                      //                 fontWeight: FontWeight.bold,
                      //                 overflow: TextOverflow.ellipsis),
                      //           ),
                      //         ),
                      // currentUsers?.occupation ==
                      //             OptionAdmin.admin.name ||
                      //         currentUsers?.occupation ==
                      //             OptionAdmin.master.name ||
                      //         currentUsers?.occupation ==
                      //             OptionAdmin.boss.name
                      //     ? TextButton(
                      //         child: const Text(
                      //           'Eliminar',
                      //           style: TextStyle(color: Colors.red),
                      //         ),
                      //         onPressed: () => pressDelete(item.id))
                      //     : const SizedBox(),
                      //       ],
                      //     ), onTap: () {
                      //   showMensenger(context, item.typeWorked ?? '',
                      //       title: 'Tipo de trabajos');
                      // }),
                      // DataCell(Text(item.dateStart ?? '',
                      //     style: const TextStyle(
                      //         color: Colors.blue,
                      //         fontWeight: FontWeight.bold))),
                      // DataCell(Text(item.dateEnd ?? '',
                      //     style: const TextStyle(
                      //         color: Colors.red, fontWeight: FontWeight.bold))),
                      // DataCell(Text(diferentTime(item),
                      //     style: const TextStyle(
                      //         color: Colors.green,
                      //         fontWeight: FontWeight.bold))),
                      // DataCell(
                      //   SizedBox(
                      //       width: 70, child: Text(item.userRegistered ?? '')),
                      //   onTap: () {
                      //     showMensenger(context, item.userRegistered ?? '',
                      //         title: 'Empleado');
                      //   },
                      // ),
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

String diferentTime(AtencionCliente current) {
  Duration? diferences;
  DateTime date1 =
      DateTime.parse(current.dateStart.toString().substring(0, 19));
  DateTime date2 = DateTime.parse(current.dateEnd.toString().substring(0, 19));
  diferences = date2.difference(date1);

  return diferences.toString();
}
