import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pdfwidgets;
import '../../../datebase/current_data.dart';
import '../../../screen_print_pdf/apis/pdf_api.dart';
import '../model/bordado_report.dart';

class PrintMainBordado {
  PrintMainBordado();

  static Future<File> generate(path, listTotales) async {
    final imageFirma = MemoryImage(
        (await rootBundle.load('assets/logo_app.png')).buffer.asUint8List());

    // final image = MemoryImage(
    //     (await rootBundle.load('images/test2.png')).buffer.asUint8List());

    // Agregar la imagen al PDF
    final Uint8List imageBytes = File(path).readAsBytesSync();

    final pdfwidgets.MemoryImage imageGrafics =
        pdfwidgets.MemoryImage(imageBytes);

    final imageMecael = MemoryImage(
        (await rootBundle.load('assets/bordado.jpg')).buffer.asUint8List());
    final imageLOGO =
        MemoryImage((await rootBundle.load(firmaLu)).buffer.asUint8List());
    final pdf = Document();
    const style = TextStyle(fontSize: 8);

    pdf.addPage(MultiPage(
      build: (context) => [
        buildPaymentInfoRowImagen(
            'Trabajos Activos Bordado', imageMecael, imageFirma),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(currentEmpresa.nombreEmpresa ?? ''),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentEmpresa.adressEmpressa ?? '',
                    style: const TextStyle(fontSize: 9)),
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
              ],
            ),
          ],
        ),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        tableProducts(listTotales),
        SizedBox(height: 5 * PdfPageFormat.cm / 4),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Container(
              height: 15,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Text('Items : ${listTotales.length}', style: style),
              color: PdfColors.grey100),
          Container(
              height: 15,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                  'QTY # Orden : ${BordadoReport.calcularQTYOrden(listTotales).toString()}',
                  style: style),
              color: PdfColors.grey100),
          Container(
              height: 15,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                  'QTY Realizadas : ${BordadoReport.calcularTotalPieza(listTotales).toString()}',
                  style: style),
              color: PdfColors.grey100),
          Container(
              height: 15,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                  'QTY Defectuosas : ${BordadoReport.calcularTotalMala(listTotales).toString()}',
                  style: style),
              color: PdfColors.grey100)
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              height: PdfPageFormat.a4.height / 3,
              width: PdfPageFormat.a4.width / 3,
              alignment: Alignment.center,
              child: Image(imageGrafics))
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
