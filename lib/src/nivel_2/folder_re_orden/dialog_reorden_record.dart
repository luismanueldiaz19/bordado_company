import 'package:flutter/material.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/nivel_2/folder_re_orden/model/reorden.dart';
import '/src/util/get_formatted_number.dart';
import '/src/widgets/loading.dart';

import '../../datebase/current_data.dart';

class DialogReOrdenRecord extends StatefulWidget {
  const DialogReOrdenRecord({super.key, required this.numOrden});
  final String numOrden;

  @override
  State<DialogReOrdenRecord> createState() => _DialogReOrdenRecordState();
}

class _DialogReOrdenRecordState extends State<DialogReOrdenRecord> {
  List<ReOrden>? listReOrden = [];

  // Future deleteFrom(ReOrden item) async {
  //   await httpRequestDatabase(deleteReOrden, {'id': item.id});

  //   setState(() {
  //     listReOrden?.remove(item);
  //   });
  // }

  Future getReorden() async {
    final res = await httpRequestDatabase(selectReOrdenByNumOrden,
        {'token': token, 'num_orden': widget.numOrden.toString()});
    listReOrden = reOrdenFromJson(res.body);
    print(res.body);
    if (res.body != '') {
      if (!mounted) {
        return;
      }
      if (listReOrden!.isNotEmpty) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    getReorden();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final sized = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Historial Seguimiento Excesivos')),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          listReOrden!.isNotEmpty
              ? Expanded(
                  child: SizedBox(
                    width: sized.width >= 700 ? sized.width * 0.50 : 350,
                    child: SingleChildScrollView(
                      child: Column(
                        children: listReOrden!
                            .map((item) => Container(
                                  color: Colors.grey.shade50,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item.logo ?? 'N/A',
                                          style: style.labelLarge),
                                      Text('Ficha : ${item.ficha ?? 'N/A'}'),
                                      Text(
                                          'Balance \$ ${getNumFormatedDouble(item.balance ?? 'N/A')}',
                                          style: style.labelLarge
                                              ?.copyWith(color: Colors.green)),
                                      Text(item.infoCliente ?? 'N/A'),
                                      Text(
                                          'Programado : ${item.reorden ?? 'N/A'}',
                                          style: style.labelLarge),
                                      Text(
                                          'Seguimiento Por ${item.usuario ?? 'N/A'}'),

                                      Text(item.comment ?? 'N/A',
                                          style: style.bodySmall
                                              ?.copyWith(color: Colors.red)),
                                      // Row(
                                      //   children: [
                                      //     TextButton(
                                      //       onPressed: () => deleteFrom(item),
                                      //       child: const Text('Eliminar'),
                                      //     ),
                                      //   ],
                                      // )
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                )
              : const Expanded(child: Loading(text: 'Espere .. Buscando ...')),
          listReOrden!.isNotEmpty
              ? Container(
                  height: 35,
                  width: 250,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Total :'),
                          const SizedBox(width: 15),
                          Text('${listReOrden?.length.toString()}',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          identy(context),
        ],
      ),
    );
  }
}
