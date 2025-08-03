import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;

import '../../datebase/current_data.dart';
import '../../screen_print_pdf/apis/pdf_api.dart';
import '../model/model_inventory_outputs.dart';

class PrintSalidaInventario {
  static Future<File> generate(List<InventoryOutput> listaSalidas) async {
    final imageLogo = MemoryImage(
        (await rootBundle.load('assets/logo_app_sin_fondo.png'))
            .buffer
            .asUint8List());

    final pageTheme = await _myPageTheme(PdfPageFormat.a4);
    final pdf = Document();
    final imageFirma =
        MemoryImage((await rootBundle.load(firmaLu)).buffer.asUint8List());

    pdf.addPage(MultiPage(
      pageTheme: pageTheme,
      build: (context) => [
        //  department: 'Información Impreso por ${currentUsers?.fullName}',
        //     imageLogo: firmaControlOperacion,
        //     fecha: DateTime.now().toString().substring(0, 10),
        //     text: 'Listado de Productos',
        //     current: 'Control de inventario de productos'
        buildHeader(
          text: 'Reporte de Salidas de Inventario',
          current: currentUsers?.fullName ?? 'N/A',
          fecha: DateTime.now().toString().substring(0, 10),
          imageLogo: imageLogo,
          department: 'Información Impreso por ${currentUsers?.fullName}',
        ),
        tableSalidas(listaSalidas),
      ],
      footer: (context) => buildFooter(imageFirma),
    ));

    return PdfApi.saveDocument(
        name:
            'Salidas_Inventario_${DateTime.now().toString().substring(0, 10)}.pdf',
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

  static Widget tableSalidas(List<InventoryOutput> salidas) {
    final headers = ['#ID', 'Producto', 'Cantidad', 'Motivo', 'Fecha'];
    final data = salidas.map((e) {
      return [
        e.idOutput.toString(),
        e.nameProduct,
        e.quantity.toStringAsFixed(2),
        e.reason,
        e.outputDate.toString().substring(0, 19),
      ];
    }).toList();
    // Calcular total de piezas (sumar quantity)
    final totalPiezas = salidas.fold<double>(0.0, (sum, e) => sum + e.quantity);

    // Agregar fila de total al final
    data.add([
      '', // ID vacío
      'TOTAL',
      totalPiezas.toStringAsFixed(2),
      '',
      '',
    ]);
    return TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: const TableBorder(
          horizontalInside: BorderSide(color: PdfColors.grey100),
          verticalInside: BorderSide(color: PdfColors.grey100)),
      tableWidth: TableWidth.max,
      headerAlignment: Alignment.centerLeft,
      cellStyle: const TextStyle(fontSize: 6),
      oddRowDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellAlignments: {
        for (var i = 2; i < headers.length; i++) i: Alignment.center,
      },
      headerStyle: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 9, color: PdfColors.white),
      headerDecoration: const BoxDecoration(color: PdfColors.black),
    );
  }

  static Widget buildFooter(ImageProvider image) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image(image, height: 20, width: 20),
        SizedBox(width: 10),
        Text('Design by LuDeveloper', style: TextStyle(fontSize: 7)),
      ],
    );
  }

  static Future<pdfWidgets.PageTheme> _myPageTheme(PdfPageFormat format) async {
    final bgImage = MemoryImage(
        (await rootBundle.load('assets/logo_app_sin_fondo.png'))
            .buffer
            .asUint8List());

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
                  opacity: 0.1,
                  child: Image(bgImage, width: 150, height: 150),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
