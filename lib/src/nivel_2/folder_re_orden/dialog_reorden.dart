import 'package:flutter/material.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/nivel_2/folder_re_orden/model/reorden.dart';

import '../../util/get_formatted_number.dart';

class DialogReOrden extends StatefulWidget {
  const DialogReOrden({super.key, this.listReOrden});
  final List<ReOrden>? listReOrden;

  @override
  State<DialogReOrden> createState() => _DialogReOrdenState();
}

class _DialogReOrdenState extends State<DialogReOrden> {
  Future deleteFrom(ReOrden item) async {
    await httpRequestDatabase(deleteReOrden, {'id': item.id});
    // print(res.body);
    setState(() {
      widget.listReOrden?.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Aviso Entregas', style: style.titleLarge),
                const Icon(Icons.notifications_none)
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: widget.listReOrden!
                    .map((item) => Container(
                          color: Colors.grey.shade50,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.logo ?? 'N/A', style: style.labelLarge),
                              Text('Ficha : ${item.ficha ?? 'N/A'}'),
                              Text(
                                  'Balance \$ ${getNumFormatedDouble(item.balance ?? 'N/A')}',
                                  style: style.labelLarge
                                      ?.copyWith(color: Colors.green)),
                              Text(item.infoCliente ?? 'N/A'),
                              Text('Programado : ${item.reorden ?? 'N/A'}',
                                  style: style.labelLarge),
                              Text('Seguimiento Por ${item.usuario ?? 'N/A'}'),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () => deleteFrom(item),
                                    child: const Text('Eliminar'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
