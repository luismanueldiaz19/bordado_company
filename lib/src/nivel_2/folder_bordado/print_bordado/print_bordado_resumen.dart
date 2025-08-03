import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pdfwidgets;
import '../../../datebase/current_data.dart';
import '../../../screen_print_pdf/apis/pdf_api.dart';
import '../model/bordado_report.dart';

class PrintBordadoResumen {
  PrintBordadoResumen();

  static Future<File> generate(path, path2, String fecha) async {
    final imageFirma = MemoryImage(
        (await rootBundle.load('assets/logo_app.png')).buffer.asUint8List());

    // final image = MemoryImage(
    //     (await rootBundle.load('images/test2.png')).buffer.asUint8List());

    // Agregar la imagen al PDF
    final Uint8List imageBytes = File(path).readAsBytesSync();

    final pdfwidgets.MemoryImage imageGrafics =
        pdfwidgets.MemoryImage(imageBytes);

    // -----------------------------------------//
    // Agregar la imagen al PDF
    final Uint8List imageBytes2 = File(path2).readAsBytesSync();

    final pdfwidgets.MemoryImage imageGrafics2 =
        pdfwidgets.MemoryImage(imageBytes2);

    final imageMecael = MemoryImage(
        (await rootBundle.load('assets/bordado.jpg')).buffer.asUint8List());
    final imageLOGO =
        MemoryImage((await rootBundle.load(firmaLu)).buffer.asUint8List());
    final pdf = Document();
    const style = TextStyle(fontSize: 8);

    pdf.addPage(MultiPage(
      crossAxisAlignment: CrossAxisAlignment.center,
      build: (context) => [
        buildPaymentInfoRowImagen('Resumen Bordado', imageMecael, imageFirma),
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
                Text('Fechas : $fecha', style: style),
              ],
            ),
          ],
        ),
        Divider(endIndent: 50, indent: 50, color: PdfColors.grey400),
        Text('Reportes de Piezas'),
        SizedBox(height: 2 * PdfPageFormat.cm / 4),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              width: PdfPageFormat.a4.width / 1.20,
              alignment: Alignment.center,
              child: Image(imageGrafics))
        ]),
        SizedBox(height: 2 * PdfPageFormat.cm / 4),
        Divider(endIndent: 50, indent: 50, color: PdfColors.grey400),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Reportes de Puntadas')),
        SizedBox(height: 2),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            alignment: Alignment.center,
            child: Image(imageGrafics2),
            width: PdfPageFormat.a4.width / 1.20,
          )
        ]),
      ],
      footer: (context) => buildFooter(imageLOGO),
    ));

    return PdfApi.saveDocument(
        name: 'Docs_${DateTime.now().toString().substring(0, 10)}_.pdf',
        pdf: pdf);
  }

  static Widget tableProducts(List<BordadoReport> listProduct) {
    final headers = [
      'Registros',
      '# Ordenes',
      'Fichas',
      'Logo',
      'QTY # Orden',
      'QTY Realizadas',
      'QTY Defectuosas',
      'Fecha Inicios',
      'Maquinas',
      'Puntada/Vel.'
    ];

    final data = listProduct
        .map((producto) => [
              producto.fullName,
              producto.numOrden,
              producto.ficha,
              producto.nameLogo,
              producto.cantOrden,
              producto.cantElabored,
              producto.cantBad,
              producto.fechaGeneralStarted,
              producto.machine,
              '${producto.puntada}-${producto.veloz}',
            ])
        .toList();

    return Table.fromTextArray(
        headers: headers,
        data: data,
        border: const TableBorder(
          horizontalInside: BorderSide(color: PdfColors.grey100),
          verticalInside: BorderSide(color: PdfColors.grey100),
        ),
        tableWidth: TableWidth.max,
        cellAlignment: Alignment.topLeft,
        headerAlignment: Alignment.topLeft,
        cellStyle: const TextStyle(fontSize: 6),
        headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 5),
        headerDecoration: const BoxDecoration(color: PdfColors.grey300));
  }

  static Widget buildPaymentInfoRowImagen(String label, image, image2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image(image, height: 75, width: 75),
          SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 15)),
          SizedBox(width: 10),
          Image(image2, height: 75, width: 75),
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

  static Widget buildPaymentInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 8)),
          Text(value, style: const TextStyle(fontSize: 8)),
        ],
      ),
    );
  }
}
