import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../datebase/current_data.dart';
import '../../screen_print_pdf/apis/pdf_api.dart';
import '../../util/get_time_relation.dart';
import 'model_actividades_foxin.dart';

class PdfActividadesFoxin {
  PdfActividadesFoxin();

  static Future<File> generate(
      List<Actividades> listActividades, Map totales, date1, date2) async {
    final image =
        MemoryImage((await rootBundle.load(logoApp)).buffer.asUint8List());

    // // Agregar la imagen al PDF
    // final Uint8List imageBytes = File(path).readAsBytesSync();
    // final pdfWidgets.MemoryImage imageGrafics = pdfWidgets.MemoryImage(
    //   imageBytes,
    // );

    final pdf = Document();
    const style = TextStyle(fontSize: 8);
    pdf.addPage(MultiPage(
      build: (context) => [
        buildPaymentInfoRowImagen(
            'REPORTE DE ACTIVIDADES', image, date1, date2),
        // SizedBox(height: 1 * PdfPageFormat.cm / 2),
        // Text('$date1 A $date2'),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(currentEmpresa.nombreEmpresa ?? ''),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentEmpresa.adressEmpressa ?? '',
                    style: TextStyle(fontSize: 9)),
                Row(
                  children: [
                    Text('TEL: ${currentEmpresa.telefonoEmpresa ?? ''}',
                        style: style),
                    SizedBox(width: 5),
                    Text('CEL: ${currentEmpresa.celularEmpresa ?? ''}',
                        style: style),
                    SizedBox(width: 5),
                    Text('OFICINA: ${currentEmpresa.oficinaEmpres ?? ''}',
                        style: style),
                  ],
                ),
                Text('RNC : ${currentEmpresa.rncEmpresa ?? ''}', style: style),
                // Text('DESPACHADOR /A : ${currentUser?.fullName ?? ''}',
                //         style: style),
              ],
            ),
          ],
        ),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        tableProducts(listActividades),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        Column(
          children: [
            Row(
              children: [
                Text('TOTAL ACTIVIDADES :', style: style.copyWith(fontSize: 6)),
                SizedBox(width: 5),
                Text(totales['activ'].toString(),
                    style: style.copyWith(
                        fontSize: 6,
                        color: PdfColors.black,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                Text('TOTAL TIEMPOS :', style: style.copyWith(fontSize: 6)),
                SizedBox(width: 5),
                Text(totales['tiempo'].toString(),
                    style: style.copyWith(
                        color: PdfColors.black,
                        fontSize: 6,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                Text('TOTAL EFICIENIA :', style: style.copyWith(fontSize: 6)),
                SizedBox(width: 5),
                Text(totales['efect'].toString(),
                    style: style.copyWith(
                        color: PdfColors.green,
                        fontSize: 6,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),

        SizedBox(height: 1 * PdfPageFormat.cm / 2),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1 * PdfPageFormat.cm),
            // SizedBox(height: 300, width: 400, child: pdfImageWidget),
            SizedBox(height: 1 * PdfPageFormat.cm),
            buildPaymentInfoRow('Comentario : ', ''),
          ],
        ),
      ],
      // footer: (context) => buildFooter(service),
    ));

    return PdfApi.saveDocument(
        name:
            'REPORTES_ACTIVIDADES_${DateTime.now().toString().substring(0, 10)}_.pdf',
        pdf: pdf);
  }

  static Widget tableProducts(List<Actividades> listProduct) {
    final headers = [
      'EMPLEADOS',
      'TAREAS',
      'QUE REALIZÓ?',
      'COMENZÓ',
      'TERMINÓ',
      'TIEMPO',
      'FECHAS'
    ];

    final data = listProduct
        .map((producto) => [
              producto.fullName?.toUpperCase(),
              producto.typeName?.toUpperCase(),
              producto.nota.toString().toUpperCase(),
              producto.startTime?.toUpperCase(),
              producto.endTime,
              getTimeRelation(
                  producto.startTime ?? 'N/A', producto.endTime ?? 'N/A'),
              producto.date?.toUpperCase(),
            ])
        .toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: const TableBorder(
        // top: BorderSide(color: PdfColors.brown),
        horizontalInside: BorderSide(color: PdfColors.brown100),
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
        0: FlexColumnWidth(15),
        1: FlexColumnWidth(15),
        2: FlexColumnWidth(30),
        3: FlexColumnWidth(15),
        4: FlexColumnWidth(15),
        5: FlexColumnWidth(15),
        6: FlexColumnWidth(15)
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
        8: Alignment.centerLeft,
        9: Alignment.centerLeft,
      },
    );
  }

  static Widget buildPaymentInfoRowImagen(
      String label, image, String date1, String date2) {
    final style = TextStyle(fontSize: 8);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image(image, height: 100, width: 100),
          SizedBox(width: 50),
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                      color: PdfColors.blue, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('DESDE', style: style),
                      SizedBox(width: 2),
                      Text(date1.toUpperCase(),
                          style: style.copyWith(color: PdfColors.red)),
                      SizedBox(width: 2),
                      Text('HASTA', style: style),
                      SizedBox(width: 2),
                      Text(date2.toUpperCase(),
                          style: style.copyWith(color: PdfColors.green)),
                    ])
              ])
        ],
      ),
    );
  }

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
