import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import '/src/screen_print_pdf/apis/pdf_api.dart';
import '/src/util/get_time_relation.dart';

import '../../../datebase/current_data.dart';
import '../model/report_bordado_tirada.dart';

class PrintBordadoHistorial {
  PrintBordadoHistorial();

  static Future<File> generate(List<BordadoReportTiradas> listReported, fecha,
      pieza, mala, piezaGeneral, tiempoGeneral) async {
    final pdf = Document();

    final imageLogo = MemoryImage(
        (await rootBundle.load('assets/logo_app.png')).buffer.asUint8List());

    final imageBordado = MemoryImage(
        (await rootBundle.load('assets/bordado.jpg')).buffer.asUint8List());
    final imageLOGO =
        MemoryImage((await rootBundle.load(firmaLu)).buffer.asUint8List());
    const style = TextStyle(fontSize: 8);

    pdf.addPage(MultiPage(
      crossAxisAlignment: CrossAxisAlignment.center,
      build: (context) => [
        buildPaymentInfoRowImagen(
            'Control de producción', imageLogo, imageBordado, fecha),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(currentEmpresa.nombreEmpresa ?? ''),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(currentEmpresa.adressEmpressa ?? '',
                    style: const TextStyle(fontSize: 9)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
              ],
            ),
          ],
        ),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        tableMateriales(listReported),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            height: 15,
            decoration: const BoxDecoration(color: PdfColors.grey100),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('PIEZAS : ', style: const TextStyle(fontSize: 6)),
                  Text(
                    '$pieza',
                    style: TextStyle(
                        color: PdfColors.brown,
                        fontWeight: FontWeight.bold,
                        fontSize: 6),
                  ),
                ],
              ),
            )),
          ),
          SizedBox(width: 5),
          Container(
              height: 15,
              decoration: const BoxDecoration(color: PdfColors.grey100),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                  child: Row(
                    children: [
                      Text('PIEZAS MALA: ',
                          style: const TextStyle(fontSize: 6)),
                      SizedBox(width: 15),
                      Text('$mala',
                          style: TextStyle(
                              color: PdfColors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 6)),
                    ],
                  ),
                ),
              )),
          SizedBox(width: 5),
          Container(
            height: 15,
            decoration: const BoxDecoration(color: PdfColors.grey100),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Row(
                  children: [
                    Text('PUNTD GENERAL : ',
                        style: const TextStyle(fontSize: 6)),
                    SizedBox(width: 15),
                    Text('$piezaGeneral',
                        style: TextStyle(
                            color: PdfColors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 6)),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 5),
          Container(
            height: 15,
            decoration: const BoxDecoration(color: PdfColors.grey100),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Row(
                  children: [
                    Text('TIEMPO GENERAL : ',
                        style: const TextStyle(fontSize: 6)),
                    SizedBox(width: 15),
                    Text('$tiempoGeneral',
                        style: TextStyle(
                            color: PdfColors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 6)),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ],
      footer: (context) => buildFooter(imageLOGO),
    ));

    return PdfApi.saveDocument(name: 'Documento.pdf', pdf: pdf);
  }

  static Widget tableMateriales(List<BordadoReportTiradas> list) {
    List<List<String>> data = list.map((item) {
      return [
        item.machine.toString(),
        item.fullName.toString(),
        '${item.numOrden.toString()} - ${item.ficha.toString()}',
        item.nameLogo.toString(),
        item.cantOrden.toString(),
        item.cantElabored.toString(),
        item.cantBad.toString(),
        item.puntada.toString(),
        getTimeRelation(item.fechaStarted ?? 'N/A', item.fechaEnd ?? 'N/A'),
      ];
    }).toList();

    return Table.fromTextArray(
      headers: [
        'MAQUINA',
        'EMPLEADOS',
        '# ORDEN/FICHAS',
        'LOGO',
        'ORDEN QTY',
        'ELAB QTY',
        'MALA QTY',
        'PUNTADAS',
        'TIEMPO',
      ],
      data: data,
      border: const TableBorder(
          horizontalInside: BorderSide(color: PdfColors.grey)),
      headerStyle: const TextStyle(fontSize: 6),
      cellStyle: const TextStyle(fontSize: 5),
      headerAlignment: Alignment.centerRight,
      cellAlignment: Alignment.centerRight,
      headerDecoration: const BoxDecoration(color: PdfColors.blue50),
    );
  }

  static Widget buildPaymentInfoRowImagen(String label, image, image2, fecha) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 15)),
        SizedBox(height: 2),
        Text('Bordado'),
        SizedBox(height: 2),
        Text(fecha, style: const TextStyle(fontSize: 8, color: PdfColors.black))
      ],
    );
  }

  static Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          // fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
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

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }

  static Widget buildFooter(imageLOGO) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image(imageLOGO, height: 15, width: 15),
          SizedBox(width: 5),
          Text('Design by LuDeveloper', style: const TextStyle(fontSize: 7))
        ],
      );

  static buildTextGet({
    required String title,
  }) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 5))),
          // pw.SizedBox(),
        ],
      ),
    );
  }
}
