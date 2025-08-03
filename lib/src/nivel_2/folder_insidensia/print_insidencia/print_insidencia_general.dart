import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import '/src/nivel_2/folder_insidensia/model/product_incidencia.dart';
import '/src/screen_print_pdf/apis/pdf_api.dart';
import '../model/incidencia.dart';

class PdfIncidenciaGeneral {
  PdfIncidenciaGeneral();

  static Future<File> generate(
      List<Incidencia> listIncidenciaUsers, date1, date2) async {
    final image = MemoryImage(
        (await rootBundle.load('assets/logo_app.png')).buffer.asUint8List());
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildPaymentInfoRowImagen('Resumen General Incidencias', image),
        Text('( $date1 A $date2 ) para un total ${listIncidenciaUsers.length}'),

        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        // pw.Column(
        //     children: listWidgets
        //         .map(
        //           (e) => Container(
        //             child: Row(
        //               children: [
        //                 Text(
        //                   e.key,
        //                   style: const TextStyle(),
        //                 ),
        //                 Text(
        //                   e.value.toString(),
        //                   style: const TextStyle(),
        //                 )
        //               ],
        //             ),
        //           ),
        //         )
        //         .toList()),

        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [],
          ),
        ]),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        tableProducts(listIncidenciaUsers),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),

        buildPaymentInfoRow('Resumen por Empleados : ', ''),
        SizedBox(height: 1 * PdfPageFormat.cm / 3),
        tableUsers(listIncidenciaUsers),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        buildPaymentInfoRow('Resumen por Departamentos : ', ''),
        SizedBox(height: 1 * PdfPageFormat.cm / 3),
        tableDepartmento(listIncidenciaUsers),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1 * PdfPageFormat.cm),
            // SizedBox(height: 300, width: 400, child: pdfImageWidget),
            SizedBox(height: 1 * PdfPageFormat.cm),
            buildPaymentInfoRow('Gerencia: ', '---------------------'),
            SizedBox(height: 0.2 * PdfPageFormat.cm),
            buildPaymentInfoRow('Supervisor: ', '---------------------'),
            SizedBox(height: 0.2 * PdfPageFormat.cm),
            buildPaymentInfoRow('Operador: ', '---------------------'),

            SizedBox(height: 1 * PdfPageFormat.cm),
            buildPaymentInfoRow('Comentario : ', ''),
            // SizedBox(height: 2 * PdfPageFormat.cm),
          ],
        ),
      ],
      // footer: (context) => buildFooter(service),
    ));

    return PdfApi.saveDocument(
        name:
            'Reporte_genera_incidencias_${DateTime.now().toString().substring(0, 10)}_.pdf',
        pdf: pdf);
  }

  static Widget tableProducts(List<Incidencia> listProduct) {
    final headers = [
      'Department',
      'num Orden',
      'Logo',
      'Ficha',
      'Motivo',
      'Resp. Depart',
      'Resp. Users',
      'Fecha'
    ];

    final data = listProduct
        .map((producto) => [
              producto.depart,
              producto.numOrden,
              producto.logo,
              producto.ficha,
              producto.whycause,
              producto.departResponsed,
              producto.usersResponsed,
              producto.date,
            ])
        .toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: const TableBorder(
        // top: BorderSide(color: PdfColors.brown),
        horizontalInside: BorderSide(color: PdfColors.brown),
      ),

      // defaultColumnWidth: const IntrinsicColumnWidth(flex: 2),
      headerAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerLeft,
        4: Alignment.centerLeft,
        5: Alignment.centerLeft,
        6: Alignment.centerLeft,
        7: Alignment.centerLeft,
      },
      tableWidth: TableWidth.max,
      columnWidths: const {
        0: FlexColumnWidth(15),
        1: FlexColumnWidth(15),
        2: FlexColumnWidth(15),
        3: FlexColumnWidth(15),
        4: FlexColumnWidth(50),
        5: FlexColumnWidth(15),
        6: FlexColumnWidth(15),
        7: FlexColumnWidth(15),
      },
      cellStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 5),
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 5),
      headerDecoration: const BoxDecoration(
        color: PdfColors.grey100,
      ),
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerLeft,
        4: Alignment.centerLeft,
        5: Alignment.centerLeft,
        6: Alignment.centerLeft,
        7: Alignment.centerLeft,
      },
    );
  }

  static Widget tableUsers(List<Incidencia> listIncidenciaUsers) {
    Map<String, int> countMap = {};

    for (var incidencia in listIncidenciaUsers) {
      if (countMap.containsKey(incidencia.usersResponsed ?? '')) {
        countMap[incidencia.usersResponsed ?? ''] =
            countMap[incidencia.usersResponsed ?? '']! + 1;
      } else {
        countMap[incidencia.usersResponsed ?? ''] = 1;
      }
    }

    List<MapEntry<String, int>> getCountMapEntries(Map<String, int> countMap) {
      return countMap.entries.toList();
    }

    final listWidgets = getCountMapEntries(countMap);
    final headers = [
      'Empleados',
      'Cantidad',
    ];

    final data = listWidgets
        .map((producto) => [
              producto.key.toString(),
              producto.value,
            ])
        .toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: const TableBorder(
        // top: BorderSide(color: PdfColors.brown),
        horizontalInside: BorderSide(color: PdfColors.brown),
      ),

      // defaultColumnWidth: const IntrinsicColumnWidth(flex: 2),
      headerAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
      },
      tableWidth: TableWidth.max,

      cellStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      headerDecoration: const BoxDecoration(
        color: PdfColors.grey100,
      ),
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
      },
    );
  }

  static Widget tableDepartmento(List<Incidencia> listIncidenciaUsers) {
    Map<String, int> countMap = {};
    for (var incidencia in listIncidenciaUsers) {
      if (countMap.containsKey(incidencia.depart)) {
        countMap[incidencia.depart ?? ''] = countMap[incidencia.depart]! + 1;
      } else {
        countMap[incidencia.depart ?? ''] = 1;
      }
    }

    List<MapEntry<String, int>> getCountMapEntries(Map<String, int> countMap) {
      return countMap.entries.toList();
    }

    final listWidgets = getCountMapEntries(countMap);
    final headers = [
      'Departamentos',
      'Cantidad',
    ];

    final data = listWidgets
        .map((producto) => [
              producto.key.toString(),
              producto.value,
            ])
        .toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: const TableBorder(
        // top: BorderSide(color: PdfColors.brown),
        horizontalInside: BorderSide(color: PdfColors.blue),
      ),

      // defaultColumnWidth: const IntrinsicColumnWidth(flex: 2),
      headerAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
      },
      tableWidth: TableWidth.max,

      cellStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      headerDecoration: const BoxDecoration(
        color: PdfColors.grey100,
      ),
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
      },
    );
  }

  static Widget buildTotal(List<ProductIncidencia> listProduct) {
    int totalProduct = 0;
    int totalCost = 0;
    for (var item in listProduct) {
      int importe = 0;
      totalProduct += int.parse(item.cant ?? '0');
      importe = int.parse(item.cant ?? '0') * int.parse(item.cost ?? '0');
      totalCost += importe;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'Totales Unidades : $totalProduct',
          style:
              TextStyle(fontWeight: FontWeight.bold, color: PdfColors.blue700),
        ),
        Text(
          'Totales Costos : $totalCost',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  static Widget buildPaymentInfoRowImagen(String label, image) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image(image, height: 100, width: 100),
          SizedBox(width: 50),
          Text(
            label,
            style: TextStyle(
                // fontSize: 16.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
          SizedBox(width: 50),
        ],
      ),
    );
  }

  static Widget buildFooter(Incidencia invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Design by LuDeveloper', style: const TextStyle(fontSize: 7)),
        ],
      );

  static Widget buildPaymentInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
          ),
          Text(
            value,
            style: const TextStyle(
                // fontSize: 16.0,
                ),
          ),
        ],
      ),
    );
  }
}
