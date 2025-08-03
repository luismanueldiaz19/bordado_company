import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import '/src/datebase/current_data.dart';

import '../../../screen_print_pdf/apis/pdf_api.dart';
import '../../../util/get_formatted_number.dart';
import '../model/sastreria_item.dart';

class PdfReportSastreria {
  PdfReportSastreria();

  static Future<File> generate(List<SastreriaWorkItem> listPlani) async {
    final image = MemoryImage(
        (await rootBundle.load('assets/logo_app.png')).buffer.asUint8List());

    // // Agregar la imagen al PDF
    // final Uint8List imageBytes = File(path).readAsBytesSync();
    // final pdfWidgets.MemoryImage imageGrafics = pdfWidgets.MemoryImage(
    //   imageBytes,
    // );

    final pdf = Document();
    const style = TextStyle(fontSize: 8);
    pdf.addPage(MultiPage(
      build: (context) => [
        buildPaymentInfoRowImagen('REPORTE SASTRERIAS', image),
        // SizedBox(height: 1 * PdfPageFormat.cm / 2),
        // Text('$date1 A $date2'),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tejido Tropical'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('C. Beller #78, Puerto Plata 57000',
                    style: const TextStyle(fontSize: 9)),
                Row(
                  children: [
                    Text('TEL: (829) 733-7630', style: style),
                    SizedBox(width: 5),
                    Text('CEL: 809-XXX-XXXX', style: style),
                    SizedBox(width: 5),
                    Text('OFICINA: 809-XXX-XXXX', style: style),
                  ],
                ),
                Text('RNC : xxxxxx-x', style: style),
                // Text('DESPACHADOR /A : ${currentUser?.fullName ?? ''}',
                //         style: style),
              ],
            ),
          ],
        ),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        tableProducts(listPlani),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 15,
                width: 150,
                color: PdfColors.grey100,
                child: Center(
                    child: Text('ORDENES : ${listPlani.length}', style: style)),
              ),
              SizedBox(width: 5),
              Container(
                height: 15,
                width: 150,
                color: PdfColors.grey100,
                child: Center(
                    child: Text(
                        'CANT PIEZAS : ${getNumFormated(getTotalListPiezas(listPlani))}',
                        style: style)),
              ),
              SizedBox(width: 5),
              Container(
                  height: 15,
                  width: 150,
                  color: PdfColors.grey100,
                  child: Center(
                      child: Text(
                          '\$ ${getNumFormated(getTotalList(listPlani))}',
                          style: style)))
            ],
          ),
        ),

        buildPaymentInfoRow('Comentario : ', ''),
      ],
      // footer: (context) => buildFooter(service),
    ));

    return PdfApi.saveDocument(
        name:
            'SASTRERIA_REPORTES_${DateTime.now().toString().substring(0, 10)}_.pdf',
        pdf: pdf);
  }

  static getTotalList(List<SastreriaWorkItem> items) {
    int subTotal = 0;
    for (var item in items) {
      subTotal += int.parse(item.cant ?? '0') * int.parse(item.price ?? '0');
    }
    return subTotal;
  }

  static getTotalListPiezas(List<SastreriaWorkItem> items) {
    int subTotal = 0;
    for (var item in items) {
      subTotal += int.parse(item.cant ?? '0');
    }
    return subTotal;
  }

  static Widget tableProducts(List<SastreriaWorkItem> listProduct) {
    final headers = [
      'NUM ORDEN',
      'DETALLES',
      'TIPO PIEZA',
      'CANT',
      'COST',
      'TOTAL',
    ];

    final data = listProduct
        .map((producto) => [
              producto.numOrden,
              producto.description,

              producto.tipoPieza,

              // item.dateStart.toString().substring(0, 16),
              getNumFormated(int.parse(producto.cant ?? '0')),
              '\$ ${getNumFormated(int.parse(producto.price ?? '0'))}',

              '\$ ${getNumFormated(getTotalItem(producto))}'
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
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
      tableWidth: TableWidth.max,
      columnWidths: const {
        0: FlexColumnWidth(20),
        1: FlexColumnWidth(25),
        2: FlexColumnWidth(25),
        3: FlexColumnWidth(10),
        4: FlexColumnWidth(10),
        5: FlexColumnWidth(10),
      },
      cellStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      headerDecoration: const BoxDecoration(
        color: PdfColors.grey100,
      ),
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static int getTotalItem(SastreriaWorkItem item) {
    return int.parse(item.cant ?? '0') * int.parse(item.price ?? '0');
  }

  static Widget buildPaymentInfoRowImagen(String label, image) {
    const style = TextStyle(fontSize: 8);
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
                      Text('FECHA : ', style: style),
                      SizedBox(width: 3),
                      Text(
                        DateTime.now()
                            .toString()
                            .substring(0, 19)
                            .toUpperCase(),
                        style:
                            style.copyWith(color: PdfColors.blue, fontSize: 9),
                      ),
                      SizedBox(width: 3),
                      Text('IMPR POR.', style: style),
                      SizedBox(width: 3),
                      Text(currentUsers!.fullName.toString().toUpperCase(),
                          style: style.copyWith(color: PdfColors.black)),
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
          Text(label.toUpperCase()),
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
