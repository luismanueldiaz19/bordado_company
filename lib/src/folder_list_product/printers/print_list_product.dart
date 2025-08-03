import 'dart:io';
import 'package:flutter/services.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;

import '../../datebase/current_data.dart';
import '../../screen_print_pdf/apis/pdf_api.dart';
import '../../util/get_formatted_number.dart';
import '../model_product/product.dart';

// import '../evaluacion_tabacco.dart';

class PrintListProduct {
  PrintListProduct();

  static Future<File> generate(List<Product> listIncidenciaUsers) async {
    final firmaControlOperacion = MemoryImage(
        (await rootBundle.load('assets/logo_app_sin_fondo.png'))
            .buffer
            .asUint8List());

    final imageFirma =
        MemoryImage((await rootBundle.load(firmaLu)).buffer.asUint8List());

    final pageTheme = await _myPageTheme(PdfPageFormat.a4);

    // final Uint8List imageBytes = File(path).readAsBytesSync();
    // final Uint8List imageBytes2 = File(path2).readAsBytesSync();
    // final pdfWidgets.MemoryImage imageGrafics =
    //     pdfWidgets.MemoryImage(imageBytes);

    // final pdfWidgets.MemoryImage imageGrafics2 =
    //     pdfWidgets.MemoryImage(imageBytes2);

    final pdf = Document();
    const style = TextStyle(fontSize: 10, color: PdfColors.grey600);
    pdf.addPage(MultiPage(
      pageTheme: pageTheme,
      build: (context) => [
        buildHeader(
            department: 'Información Impreso por ${currentUsers?.fullName}',
            imageLogo: firmaControlOperacion,
            fecha: DateTime.now().toString().substring(0, 10),
            text: 'Listado de Productos',
            current: 'Control de inventario de productos'),

        tableProducts(listIncidenciaUsers),
        // SizedBox(height: 1 * PdfPageFormat.cm / 4),
        // Center(child: Text('Aprobador  Por', style: style)),
        // SizedBox(height: 1 * PdfPageFormat.cm / 4),
        // Center(
        //   child: SizedBox(
        //     width: PdfPageFormat.a4.width * 0.7,
        //     child: Center(
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           buildPaymentInfoRow('Supervisor :',
        //               '------------------------------------------'),
        //           SizedBox(height: 1 * PdfPageFormat.cm / 4),
        //           buildPaymentInfoRow('Calidad :',
        //               '------------------------------------------'),
        //         ],
        //       ),
        //     ),
        //   ),
        // )
        // // Image(imageFirma, height: 150, width: 150),
      ],
      footer: (context) => buildFooter(imageFirma),
    ));

    return PdfApi.saveDocument(
        name: 'List_Product_${DateTime.now().toString().substring(0, 10)}_.pdf',
        pdf: pdf);
  }

  static Widget buildHeader(
      {String? department,
      ImageProvider? imageLogo,
      String? fecha,
      String? text,
      String? current}) {
    const double size = 90;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image(imageLogo!, width: size, height: size),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(currentEmpresa.nombreEmpresa ?? 'N/A',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: PdfColors.black)),
                SizedBox(height: 2),
                Text('${currentEmpresa.adressEmpressa}',
                    style:
                        const TextStyle(fontSize: 8, color: PdfColors.grey700)),
                Row(children: [
                  Text('Tel: ${currentEmpresa.telefonoEmpresa}',
                      style: const TextStyle(
                          fontSize: 8, color: PdfColors.grey700)),
                  Text('Cel: ${currentEmpresa.celularEmpresa}',
                      style: const TextStyle(
                          fontSize: 8, color: PdfColors.grey700)),
                ]),
                SizedBox(height: 2),
                Text('Servicios: Bordados | Serigrafía | Sublimación',
                    style:
                        const TextStyle(fontSize: 7, color: PdfColors.grey600)),
                Text('Uniformes | Promociones | Otros',
                    style:
                        const TextStyle(fontSize: 7, color: PdfColors.grey600)),
                SizedBox(height: 2),
                Text('Instagram: @TejidosTropical',
                    style: const TextStyle(fontSize: 8, color: PdfColors.blue)),
                Text('perfildigitalrs.linkbio.co/TejidosTropical',
                    style: const TextStyle(
                        fontSize: 7, color: PdfColors.blueGrey600)),
              ],
            ),
          ],
        ),
        SizedBox(height: 5),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            text ?? 'N/A',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: PdfColors.blueGrey800),
          ),
          Text(current ?? 'N/A',
              style: const TextStyle(
                  fontSize: 08,
                  // fontWeight: FontWeight.bold,
                  color: PdfColors.blueGrey800)),
          SizedBox(height: 2),
          Text(
            department ?? 'N/A',
            style: const TextStyle(
                fontSize: 06,
                // fontWeight: FontWeight.bold,
                color: PdfColors.blueGrey500),
          ),
          SizedBox(height: 2),
          Text('Fecha: $fecha',
              style: const TextStyle(fontSize: 8, color: PdfColors.grey600)),
        ]),
        Divider(color: PdfColors.grey200, thickness: 1),
        SizedBox(height: 10),
      ],
    );
  }

  static Widget tableProducts(List<Product> listProduct) {
    final headers = [
      '#ID',
      'NOMBRE PRODUCTO',
      'QTY',
      'PRECIO',
      'SUB TOTAL',
      'PEDIR',
    ];

    List<List<String?>> dataList = listProduct.map((material) {
      final precio = material.priceProduct ?? 0;
      final cantidad = double.tryParse(material.stock ?? '0') ?? 0;
      // final subTotal = precio * cantidad;

      return [
        material.idProducto,
        material.nameProducto,
        material.stock,
        '\$ ${precio}',
        '0',
        // '\$ ${getNumFormatedDouble(subTotal.toStringAsFixed(2))}',
        Product.getCantidadParaCompletarMaximo(material).toString()
      ];
    }).toList();
    return TableHelper.fromTextArray(
      headers: headers,
      data: dataList,
      border: const TableBorder(
          horizontalInside: BorderSide(color: PdfColors.grey100),
          verticalInside: BorderSide(color: PdfColors.grey100)),
      tableWidth: TableWidth.max,
      headerAlignment: Alignment.centerLeft,
      cellStyle: const TextStyle(fontSize: 8),
      oddRowDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellAlignments: {
        for (var i = 2; i < headers.length; i++) i: Alignment.center,
      },
      headerStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 6,
        color: PdfColors.white,
      ),
      headerDecoration: const BoxDecoration(color: PdfColors.black),
    );
  }

  static Widget buildFooter(image) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image(image, height: 10, width: 10),
          SizedBox(width: 10),
          Text('Design by LuDeveloper', style: const TextStyle(fontSize: 7)),
        ],
      );

  static Widget buildPaymentInfoRow(String label, String value) {
    const style = TextStyle(fontSize: 8, color: PdfColors.grey600);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: style),
            Text(value, style: style),
          ],
        ),
      ),
    );
  }

  static Future<pdfWidgets.PageTheme> _myPageTheme(PdfPageFormat format) async {
    final imageLogoApp = MemoryImage(
        (await rootBundle.load('assets/logo_app_sin_fondo.png'))
            .buffer
            .asUint8List());
    // final imageLogo = MemoryImage(
    //     (await rootBundle.load('images/boxes.png')).buffer.asUint8List());
    return pdfWidgets.PageTheme(
      orientation: PageOrientation.natural,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      buildForeground: (context) {
        return Stack(
          children: [
            pdfWidgets.Positioned(
              right: 20,
              top: 10,
              child: Transform.rotate(
                angle: 45,
                child: Opacity(
                    opacity: 0.2,
                    child: Container(
                        child: Image(imageLogoApp, width: 200, height: 200))),
              ),
            ),
            pdfWidgets.Positioned(
              left: 20,
              bottom: 30,
              child: Transform.rotate(
                angle: 45,
                child: Opacity(
                    opacity: 0.3,
                    child: Container(
                        child: Image(imageLogoApp, width: 35, height: 35))),
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget cardCont(
      {String? aboveMaxText,
      String? aboveMaxNum,
      PdfColor? colors,
      String? text}) {
    const styleTittle = TextStyle(fontSize: 10, color: PdfColors.white);
    const style = TextStyle(fontSize: 8, color: PdfColors.black);
    return Row(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(color: colors ?? PdfColors.red300),
        child: Text('${aboveMaxNum ?? 'N/A'} #', style: styleTittle),
      ),
      SizedBox(width: 5),
      Text(text ?? 'N/A', style: style)
    ]);
  }

  static double calcularPorcentajeCalidad({
    required int bajos,
    required int buenos,
    required int altos,
  }) {
    final int total = bajos + buenos + altos;
    if (total == 0) return 0.0;

    final double puntos = (buenos * 1.0) + (altos * 0.0) - (bajos * 0.0);

    final double porcentaje = (puntos / total) * 100;

    return porcentaje;
  }
}
