import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import '/src/screen_print_pdf/apis/pdf_api.dart';
import '/src/util/get_formatted_number.dart';
// import 'package:pdf/widgets.dart' as pdfWidgets;

import '../model_planificacion/item_planificacion.dart';

class PdfPlanificacion {
  PdfPlanificacion();

  static Future<File> generate(
      List<PlanificacionItem> listPlani, date1, date2) async {
    final image = MemoryImage(
        (await rootBundle.load('assets/logo_app.png')).buffer.asUint8List());

    // // Agregar la imagen al PDF
    // final Uint8List imageBytes = File(path).readAsBytesSync();
    // final pdfWidgets.MemoryImage imageGrafics = pdfWidgets.MemoryImage(
    //   imageBytes,
    // );

    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildPaymentInfoRowImagen('PLANIFICACION SEMANAL', image),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),

        Text('$date1 A $date2'),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [],
          ),
        ]),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        tableProducts(listPlani),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 25,
              decoration: const BoxDecoration(color: PdfColors.grey100),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Row(
                    children: [
                      Text('TOTAL ORDEN : ',
                          style: const TextStyle(fontSize: 8)),
                      SizedBox(width: 15),
                      Text('${listPlani.length}',
                          style: TextStyle(
                              color: PdfColors.brown,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 15),
            Container(
              height: 25,
              decoration: const BoxDecoration(color: PdfColors.grey100),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Row(
                    children: [
                      Text('TOTAL PIEZA: ',
                          style: const TextStyle(fontSize: 8)),
                      SizedBox(width: 15),
                      Text(getNumFormated(int.parse(getTotalCant(listPlani))),
                          style: TextStyle(
                              color: PdfColors.black,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        // SizedBox(height: 1 * PdfPageFormat.cm / 2),
        // buildPaymentInfoRow('Graphical summary', ''),
        // SizedBox(height: 1 * PdfPageFormat.cm / 3),
        // Image(imageGrafics),
        // tableDepartmento(listIncidenciaUsers),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1 * PdfPageFormat.cm),
            // SizedBox(height: 300, width: 400, child: pdfImageWidget),
            SizedBox(height: 1 * PdfPageFormat.cm),
            buildPaymentInfoRow('Firma :', '---------------------'),

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
            'Planificacion_documento_${DateTime.now().toString().substring(0, 10)}_.pdf',
        pdf: pdf);
  }

  static Widget tableProducts(List<PlanificacionItem> listProduct) {
    final headers = [
      'DEPARTMENTOS',
      'ESTADOS',
      'ORDEN-FICHA',
      'LOGO',
      'DETALLES',
      'CANT',
      'FECHA ENTG',
    ];

    final data = listProduct
        .map((producto) => [
              producto.department?.toUpperCase(),
              producto.statu?.toUpperCase(),
              '${producto.numOrden} - ${producto.ficha}',
              producto.nameLogo?.toUpperCase(),
              producto.tipoProduct?.toUpperCase(),
              getNumFormated(int.parse(producto.cant ?? '0')),
              producto.fechaEnd,
            ])
        .toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: const TableBorder(
        // top: BorderSide(color: PdfColors.brown),
        horizontalInside: BorderSide(color: PdfColors.blue),
      ),
      headerAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerLeft,
        4: Alignment.centerLeft,
        5: Alignment.centerLeft,
        6: Alignment.centerLeft,
      },
      tableWidth: TableWidth.max,
      columnWidths: const {
        0: FlexColumnWidth(22),
        1: FlexColumnWidth(12),
        2: FlexColumnWidth(13),
        3: FlexColumnWidth(20),
        4: FlexColumnWidth(25),
        5: FlexColumnWidth(8),
        6: FlexColumnWidth(13),
      },
      cellStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 6),
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

  static String getTotalCant(List<PlanificacionItem> list) {
    int total = 0;
    for (var item in list) {
      total += int.parse(item.cant ?? '0');
    }

    return total.toString();
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
            label.toUpperCase(),
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

  // static Widget buildFooter() => Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Text('Design by LuDeveloper', style: const TextStyle(fontSize: 7)),
  //       ],
  //     );

  static Widget buildPaymentInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.toUpperCase(),
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
