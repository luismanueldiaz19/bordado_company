import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import '/src/nivel_2/folder_insidensia/model/product_incidencia.dart';
import '/src/screen_print_pdf/apis/pdf_api.dart';
import '../model/incidencia.dart';

class PdfDetallesCard {
  PdfDetallesCard();

  static Future<File> generate(Incidencia service,
      List<ProductIncidencia> listProduct, List imageLocal) async {
    final pdf = Document();
    // List<String> pasos = widget.current.whatcause.toString().split(", ");
// File('assets/logo_app.png').readAsBytesSync()
    final image = MemoryImage(
        (await rootBundle.load('assets/logo_app.png')).buffer.asUint8List());

    final imageVerificado = MemoryImage(
        (await rootBundle.load('assets/verified.png')).buffer.asUint8List());

    final imageNotVerificado = MemoryImage(
        (await rootBundle.load('assets/not_verified.png'))
            .buffer
            .asUint8List());
    Future<Image> loadImageFromUrl(String url) async {
      final ByteData imageData =
          await NetworkAssetBundle(Uri.parse(url)).load('');
      final Uint8List uint8list = imageData.buffer.asUint8List();
      final MemoryImage image = MemoryImage(uint8list);
      return Image(image);
    }

    List<Image> listImagen = [];
    for (var image in imageLocal) {
      Image pdfImage = await loadImageFromUrl('$image');
      final pdfImageWidget = Image(pdfImage.image);
      listImagen.add(pdfImageWidget);
    }

    pdf.addPage(MultiPage(
      build: (context) => [
        buildPaymentInfoRowImagen('Información del Incidencia', image,
            service.isFinished == 't' ? imageVerificado : imageNotVerificado),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Departamento: ${service.depart}"),
              Text("Fecha creación : ${service.date} "),
              Text(
                "Fecha Solución : ${service.dateCurrent} ",
                style: const TextStyle(color: PdfColors.green),
              ),
            ],
          ),
        ]),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Logo :  ${service.logo}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              "Numero Orden :  ${service.numOrden}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              "Numero Ficha :  ${service.ficha}",
              style: const TextStyle(color: PdfColors.teal),
            ),
            Divider(),

            /////////Que Paso?////
            Text(
              "Ubiacion del problema ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text("Queja : ${service.queja}",
                style: const TextStyle(color: PdfColors.teal)),
            Divider(),
            Text(
              "Que Paso?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text("${service.whycause} ",
                style: const TextStyle(color: PdfColors.red)),
            Divider(),
            Text(
              "Porque Paso?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text("${service.whatcause} ",
                style: const TextStyle(color: PdfColors.teal)),
            Divider(),
            Text(
              "Departamentos Responsables",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text("${service.departResponsed} ",
                style: const TextStyle(color: PdfColors.teal)),

            Divider(),
            Text(
              "Empleados Responsables",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text("${service.usersResponsed} ",
                style: const TextStyle(color: PdfColors.teal)),

            Divider(),
            Text("Compromiso / Solución",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text(" ${service.solucionwhat}",
                style: const TextStyle(color: PdfColors.blueAccent)),
            Divider(),
            Text('Productos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            SizedBox(height: 10), tableProducts(listProduct),
            Divider(),
            buildTotal(listProduct),
            SizedBox(height: 1 * PdfPageFormat.cm),
            // SizedBox(height: 300, width: 400, child: pdfImageWidget),
            Wrap(
                children: listImagen
                    .map((imagen) =>
                        SizedBox(height: 200, width: 200, child: imagen))
                    .toList()),
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
      footer: (context) => buildFooter(service),
    ));

    return PdfApi.saveDocument(
        name: 'Incidencia_Orden_${service.numOrden}_.pdf', pdf: pdf);
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

  static Widget buildPaymentInfoRowImagen(String label, image, image2) {
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
          pw.Image(image2, height: 100, width: 100),
          SizedBox(width: 100),
        ],
      ),
    );
  }

  static Widget tableProducts(List<ProductIncidencia> listProduct) {
    final headers = ['Productos', 'Cantidades', 'Costos'];
    final data = listProduct
        .map((producto) => [producto.product, producto.cant, producto.cost])
        .toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,

      defaultColumnWidth: const IntrinsicColumnWidth(flex: 2),
      headerAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
      },
      // tableWidth: TableWidth.max,
      cellStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      headerDecoration: const BoxDecoration(
        color: PdfColors.grey100,
      ),
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
      },
    );
  }

  static Widget buildFooter(Incidencia invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Design by LuDeveloper', style: TextStyle(fontSize: 7)),
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
