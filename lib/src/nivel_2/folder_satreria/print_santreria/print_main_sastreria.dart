import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import '/src/datebase/current_data.dart';
import '/src/model/department.dart';

import '../../../screen_print_pdf/apis/pdf_api.dart';
import '../../../util/get_formatted_number.dart';
import '../../folder_confecion/model/confecion.dart';
import '../model/sastreria_item.dart';

class PdfMainReportSastreria {
  PdfMainReportSastreria();

  static Future<File> generate(
      List<Confeccion> listPlani, Department? current) async {
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
        buildPaymentInfoRowImagen(
            'REPORTE ${current?.nameDepartment ?? 'N/A'}', image),
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
                    child:
                        Text('TRABAJOS : ${listPlani.length}', style: style)),
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

  static getTotalListPiezas(List<Confeccion> items) {
    int subTotal = 0;
    for (var item in items) {
      subTotal += int.parse(item.cantPieza ?? '0');
    }
    return subTotal;
  }

  static String diferentTime(Confeccion current) {
    if (current.dateEnd == 'N/A') {
      return 'No hay tiempo';
    } else {
      Duration? diferences;
      DateTime date1 =
          DateTime.parse(current.dateStart.toString().substring(0, 19));
      DateTime date2 =
          DateTime.parse(current.dateEnd.toString().substring(0, 19));
      diferences = date2.difference(date1);

      return diferences.toString().substring(0, 8);
    }
  }

  static Widget tableProducts(List<Confeccion> listProduct) {
    final headers = [
      'NUM ORDEN',
      'FICHAS',
      'LOGO',
      'TIPO TRABAJOS',
      'CANT PIEZA',
      'COMIENZO',
      'TERMINADO',
      'PROMEDIO'
    ];

    final data = listProduct.map((item) {
      String time = diferentTime(item);
      return [
        item.numOrden,
        item.ficha,
        item.nameLogo,
        item.tipoTrabajo,
        item.cantPieza,
        item.dateStart,
        item.dateEnd,
        item.dateEnd == 'N/A' ? 'No hay tiempo' : time,
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: const TableBorder(
        // top: BorderSide(color: PdfColors.brown),
        horizontalInside: BorderSide(color: PdfColors.brown100),
      ),
      tableWidth: TableWidth.max,
      cellStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 6),
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 6),
      headerDecoration: const BoxDecoration(color: PdfColors.grey100),
      cellAlignment: Alignment.center,
      headerAlignment: Alignment.center,
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
