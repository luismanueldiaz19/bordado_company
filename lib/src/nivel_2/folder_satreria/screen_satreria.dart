import 'package:flutter/material.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/model/department.dart';
import '/src/nivel_2/folder_confecion/model/url_confecion.dart';
import '/src/nivel_2/folder_satreria/model/sastreria_item.dart';
import '/src/nivel_2/folder_satreria/print_santreria/print_reporte_sastreria.dart';
import '/src/nivel_2/folder_satreria/screen_add_work_sastreria.dart';
import '/src/screen_print_pdf/apis/pdf_api.dart';
import '/src/util/get_formatted_number.dart';
import '../../widgets/pick_range_date.dart';
import 'model/factura_item_sastreria.dart';

class ScreenSatreria extends StatefulWidget {
  const ScreenSatreria({super.key, required this.currentDepart});
  final Department? currentDepart;
  @override
  State<ScreenSatreria> createState() => _ScreenSatreriaState();
}

class _ScreenSatreriaState extends State<ScreenSatreria> {
  String? _secondDate = DateTime.now().toString().substring(0, 10);
  String? _firstDate = DateTime.now().toString().substring(0, 10);

  @override
  void initState() {
    super.initState();

    getWork();
  }

  final Map<String, List<SastreriaWorkItem>> groupedItems = {};
  List<SastreriaWorkItem> listSatreria = [];

  Future getWork() async {
    groupedItems.clear();
    final res = await httpRequestDatabase(selectSastreriaWorkCantItemFull,
        {'date1': _firstDate, 'date2': _secondDate});
    listSatreria = sastreriaWorkItemFromJson(res.body);
    for (final jsonData in listSatreria) {
      final idKey = jsonData.idKey as String;
      final item = SastreriaWorkItem(
        id: jsonData.id as String,
        idKey: idKey,
        tipoPieza: jsonData.tipoPieza as String,
        cant: jsonData.cant ?? '0',
        price: jsonData.price ?? '0',
        description: jsonData.description as String,
        code: jsonData.code as String,
        fullName: jsonData.fullName as String,
        turn: jsonData.turn as String,
        occupation: jsonData.occupation as String,
        fecha: jsonData.fecha as String,
        numOrden: jsonData.numOrden as String,
        comment: jsonData.comment as String,
      );
      groupedItems.putIfAbsent(idKey, () => <SastreriaWorkItem>[]);
      groupedItems[idKey]!.add(item);
    }
    groupedItems.entries.map((entry) {
      final idKey = entry.key;
      final items = entry.value;
      final cliente = items[0].fullName;
      final numeroFactura = idKey; // Número de factura basado en "id_key"

      return Factura(
        numeroFactura: numeroFactura,
        fechaEmision: DateTime.now(),
        cliente: cliente ?? 'N/A',
        items: items,
      );
    }).toList();
    setState(() {});
  }

  Future deleteFrom(id) async {
    setState(() {
      listSatreria.clear();
    });
    await httpRequestDatabase(deleteSastreriaWork, {'id': id});

    getWork();
  }

  getTotalList(List<SastreriaWorkItem> items) {
    int subTotal = 0;
    for (var item in items) {
      subTotal += int.parse(item.cant ?? '0') * int.parse(item.price ?? '0');
    }
    return subTotal;
  }

  getTotalListPiezas(List<SastreriaWorkItem> items) {
    int subTotal = 0;
    for (var item in items) {
      subTotal += int.parse(item.cant ?? '0');
    }
    return subTotal;
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sastreria Otros Eventos'),
        actions: [
          Container(
            margin: const EdgeInsets.only(top: 20, right: 25),
            child: IconButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScreenAddWorkSastreria(),
                    ),
                  ).then((value) {
                    getWork();
                  });
                },
                icon: const Icon(Icons.add_box_outlined)),
          ),
          listSatreria.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.only(top: 20, right: 25),
                  child: IconButton(
                      onPressed: () async {
                        final pdfFile =
                            await PdfReportSastreria.generate(listSatreria);

                        PdfApi.openFile(pdfFile);
                      },
                      icon: const Icon(Icons.print)),
                )
              : const SizedBox()
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
                getWork();
              });
              // getIncidencia(_firstDate, _secondDate);
            },
          ),
          const SizedBox(height: 5),

          // Expanded(
          //     child: ListView.builder(
          //         itemCount: listSatreria.length,
          //         itemBuilder: (context, index) {
          //           SastreriaWorkItem current = listSatreria[index];
          //           return Container(
          //             width: 250,
          //             color: Colors.lightBlue,
          //             margin: const EdgeInsets.symmetric(vertical: 5),
          //             child: Column(children: [
          //               Text('Empleado/a: \n${current.code.toString()}'),
          //               Text(current.numOrden ?? 'N/A',
          //                   style: style.titleMedium),
          //               Text(current.description ?? 'N/A',
          //                   style: style.titleMedium),
          //               Text(current.cant ?? 'N/A', style: style.titleMedium),
          //               Text(current.price ?? 'N/A', style: style.titleMedium),
          //               Text(current.tipoPieza ?? 'N/A',
          //                   style: style.titleMedium)
          //             ]),
          //           );
          //         })),

          Expanded(
            child: SizedBox(
              width: 450,
              child: ListView.builder(
                itemCount: groupedItems.length,
                itemBuilder: (context, index) {
                  final idKey = groupedItems.keys.elementAt(index);
                  final items = groupedItems[idKey]!;

                  // Crear el DataTable para los elementos de la factura
                  final dataTable = SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(bottom: 25),
                    child: DataTable(
                      dataTextStyle:
                          const TextStyle(fontSize: 10, color: Colors.black),
                      headingTextStyle:
                          const TextStyle(fontSize: 10, color: Colors.black),
                      dataRowMaxHeight: 15,
                      dataRowMinHeight: 10,
                      columnSpacing: 25,
                      columns: const [
                        DataColumn(label: Text('DESTALLES')),
                        DataColumn(label: Text('TIPO')),
                        DataColumn(label: Text('CANTIDAD')),
                        DataColumn(label: Text('PRECIO')),
                        DataColumn(label: Text('TOTAL')),
                      ],
                      rows: items.map((item) {
                        return DataRow(cells: [
                          DataCell(Text('${item.description}',
                              style: const TextStyle(color: Colors.brown))),
                          DataCell(Text('${item.tipoPieza}')),
                          DataCell(Text('${item.cant}')),
                          DataCell(Text('\$${item.price}')),
                          DataCell(Text(
                              '\$ ${getNumFormated(getTotalItem(item))}',
                              style: style.bodySmall?.copyWith(
                                  color: Colors.green, fontSize: 10))),
                        ]);
                      }).toList(),
                    ),
                  );

                  return Container(
                    color: Colors.grey.shade300,
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text('Num Orden : ${items[0].numOrden}',
                            style: style.titleMedium),
                        Text('Empleado : ${items[0].fullName}',
                            style:
                                style.bodySmall?.copyWith(color: Colors.brown)),
                        dataTable,
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sub Total : ',
                                style: style.bodyMedium?.copyWith(),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '\$ ${getNumFormated(getTotalItemSubTotal(items))}',
                                style: style.bodyMedium?.copyWith(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 35,
                  width: 150,
                  color: Colors.white,
                  child: Center(
                      child: Text('ORDENES : ${listSatreria.length}',
                          style: style.bodySmall?.copyWith())),
                ),
                const SizedBox(width: 5),
                Container(
                  height: 35,
                  width: 150,
                  color: Colors.white,
                  child: Center(
                      child: Text(
                          'CANT PIEZAS : ${getNumFormated(getTotalListPiezas(listSatreria))}',
                          style: style.bodySmall?.copyWith())),
                ),
                const SizedBox(width: 5),
                Container(
                  height: 35,
                  width: 150,
                  color: Colors.white,
                  child: Center(
                      child: Text(
                          '\$ ${getNumFormated(getTotalList(listSatreria))}',
                          style:
                              style.titleSmall?.copyWith(color: Colors.green))),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  int getTotalItem(SastreriaWorkItem item) {
    return int.parse(item.cant ?? '0') * int.parse(item.price ?? '0');
  }

  int getTotalItemSubTotal(List<SastreriaWorkItem> items) {
    int subTotal = 0;
    for (var item in items) {
      subTotal += int.parse(item.cant ?? '0') * int.parse(item.price ?? '0');
    }
    return subTotal.toInt();
  }
}
