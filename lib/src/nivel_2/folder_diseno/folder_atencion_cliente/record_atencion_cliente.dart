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

import '../folder_print_diseno/print_atencion_cliente.dart';

class RecordAtencionCliente extends StatefulWidget {
  const RecordAtencionCliente({Key? key}) : super(key: key);

  @override
  State<RecordAtencionCliente> createState() => _RecordAtencionClienteState();
}

class _RecordAtencionClienteState extends State<RecordAtencionCliente> {
  String? firstDate = DateTime.now().toString().substring(0, 10);
  String? secondDate = DateTime.now().toString().substring(0, 10);
  List<AtencionCliente> listAtencion = [];
  List<AtencionCliente> listAtencionFilter = [];
  Future getAntencion() async {
    String selectAtencionClienteDisenoByDate =
        "http://$ipLocal/settingmat/admin/select/select_atencion_cliente_diseno_by_date.php";

    // select_atencion_cliente_diseno_by_date
    final res = await httpRequestDatabase(selectAtencionClienteDisenoByDate,
        {'date1': firstDate, 'date2': secondDate});
    listAtencion = atencionClienteFromJson(res.body);
    listAtencionFilter = [...listAtencion];
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
    String deleteAtencionClienteDiseno =
        "http://$ipLocal/settingmat/admin/delete/delete_atencion_cliente_diseno.php";

    await httpRequestDatabase(deleteAtencionClienteDiseno, {'id': '$id'});
    getAntencion();
  }

  void searchingFilter(String val) {
    // print(val);
    if (val.isNotEmpty) {
      listAtencionFilter = List.from(listAtencion
          .where((x) =>
              x.descripcion!.toUpperCase().contains(val.toUpperCase()) ||
              x.userRegistered!.toUpperCase().contains(val.toUpperCase()) ||
              x.typeWorked!.toUpperCase().contains(val.toUpperCase()))
          .toList());

      setState(() {});
    } else {
      listAtencionFilter = [...listAtencion];

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Historial de Atencion Clientes'),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              TextButton(
                  onPressed: () async {
                    var dateee = await showDatePickerCustom(context: context);
                    firstDate = dateee.toString();

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
                    message: 'Buscar por Client/Telefono/Orden/Logo',
                    child: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Total Trabajos : ${listAtencionFilter.length}',
            style: const TextStyle(
                color: Colors.brown, fontWeight: FontWeight.w500, fontSize: 16),
          ),
          listAtencionFilter.isNotEmpty
              ? Expanded(
                  child: TableModifica(
                    current: listAtencionFilter,
                    pressDelete: (id) => eliminarOrden(id),
                  ),
                )
              : const Center(child: Text('No hay datos')),
          listAtencionFilter.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: ElevatedButton.icon(
                      icon: const Icon(Icons.print),
                      onPressed: () async {
                        final pdfFile = await PdfAtencionCliente.generate(
                            listAtencionFilter);

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
              DataColumn(label: Text('Descripcion/LOGO')),
              DataColumn(label: Text('Tipo')),
              DataColumn(label: Text('Empezó')),
              DataColumn(label: Text('Termino')),
              DataColumn(label: Text('Promedio')),
              DataColumn(label: Text('Empleado')),
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
                            child: Text(
                              item.descripcion ?? '',
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ), onTap: () {
                        utilShowMesenger(context, item.descripcion ?? '',
                            title: 'Descripción/LOGO');
                      }),
                      DataCell(
                          Row(
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(
                                  item.typeWorked ?? '',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              currentUsers?.occupation ==
                                          OptionAdmin.admin.name ||
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
                          ), onTap: () {
                        utilShowMesenger(context, item.typeWorked ?? '',
                            title: 'Tipo de trabajos');
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
                      DataCell(
                          SizedBox(
                              width: 70,
                              child: Text(item.userRegistered ?? '')),
                          onTap: () {
                        utilShowMesenger(context, item.userRegistered ?? '',
                            title: 'Empleado');
                      }),
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
