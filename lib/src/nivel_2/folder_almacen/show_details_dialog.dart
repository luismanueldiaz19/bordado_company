import 'package:flutter/material.dart';
import '/src/nivel_2/folder_almacen/model_data/almacen_data.dart';
import '/src/util/get_formatted_number.dart';

import '../../datebase/methond.dart';
import '../../datebase/url.dart';

class ShowDetailsDialog extends StatefulWidget {
  const ShowDetailsDialog({super.key, this.item});
  final AlmacenData? item;

  @override
  State<ShowDetailsDialog> createState() => _ShowDetailsDialogState();
}

class _ShowDetailsDialogState extends State<ShowDetailsDialog> {
  List<AlmacenData> list = [];

  @override
  void initState() {
    super.initState();
    getItemDetails();
  }

  getItemDetails() async {
    String selectAlmacenItemIdKey =
        "http://$ipLocal/settingmat/admin/select/select_almacen_item_id_key.php";
    //select_almacen_item_id_key
    final res = await httpRequestDatabase(selectAlmacenItemIdKey,
        {'id_key_item': widget.item?.idKeyItem.toString()});
    // print(res.body);
    list = almacenDataFromJson(res.body);
    if (list.isNotEmpty) {
      calcularTotalida(list);
      setState(() {
        isLoading = !isLoading;
      });
    }
  }

  bool isLoading = true;
  int totalPCS = 0;
  int totalCost = 0;

  calcularTotalida(List<AlmacenData> listLocal) {
    totalPCS = 0;
    totalCost = 0;

    for (var item in listLocal) {
      totalPCS += int.parse(item.cant ?? '0');

      totalCost += int.parse(item.cant ?? '0') * int.parse(item.price ?? '0');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Orden Completa',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3)),
          Text(widget.item?.cliente ?? ''),
          isLoading
              ? const Text('Cargando')
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: DataTable(
                    dataRowMaxHeight: 25,
                    dataRowMinHeight: 25,
                    border: TableBorder.symmetric(
                        outside: BorderSide(
                            color: Colors.grey.shade100,
                            style: BorderStyle.none),
                        inside: const BorderSide(
                            style: BorderStyle.solid, color: Colors.red)),
                    columns: const [
                      DataColumn(label: Text('PRODUCTOS')),
                      DataColumn(label: Text('CANTIDAD')),
                      DataColumn(label: Text('COSTOS')),
                    ],
                    rows: list
                        .map((local) => DataRow(cells: [
                              DataCell(Text(local.nameProducto ?? '')),
                              DataCell(Text(local.cant ?? '')),
                              DataCell(Text(local.price ?? '')),
                            ]))
                        .toList(),
                  ),
                ),
          isLoading
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          const Text('TOTAL CANTIDAD: '),
                          Text('$totalPCS',
                              style: const TextStyle(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('TOTAL COSTO '),
                          Text(getNumFormated(int.parse('$totalCost')),
                              style: const TextStyle(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
