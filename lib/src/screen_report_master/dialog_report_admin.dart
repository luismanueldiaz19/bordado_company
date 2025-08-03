import 'package:flutter/material.dart';
import '/src/model/report_admin.dart';
import '/src/util/commo_pallete.dart';

class MyDialog extends StatelessWidget {
  final List<ReportAdmin> dataList;

  const MyDialog({super.key, required this.dataList});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Lista de Trabajos Revisados'),
      content: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Fecha revisó')),
                      DataColumn(label: Text('Tipo de trabajo')),
                      DataColumn(label: Text('Cantidad Trabajo')),
                      DataColumn(label: Text('Comentarios')),
                    ],
                    rows: dataList
                        .map((work) => DataRow(cells: [
                              DataCell(Text(work.date ?? '')),
                              DataCell(Text(work.typeWork ?? '')),
                              DataCell(Text(
                                work.cantWork ?? '',
                                style: const TextStyle(
                                    color: colorsAd,
                                    fontWeight: FontWeight.bold),
                              )),
                              DataCell(Text(work.comment ?? '')),
                            ]))
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
