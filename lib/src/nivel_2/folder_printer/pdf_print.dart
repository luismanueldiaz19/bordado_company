import 'dart:io';
import 'package:flutter/services.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../datebase/current_data.dart';
import '../../screen_print_pdf/apis/pdf_api.dart';
import '../../util/get_formatted_number.dart';
import 'model/printer_plan.dart';

class PrintPlan {
  PrintPlan();
  static Future<File> generate(List<PrinterPlan> list) async {
    final pdf = Document();

    final firmaControlOperacion = MemoryImage(
        (await rootBundle.load('assets/logo_lu.png')).buffer.asUint8List());
    final imageFirma =
        MemoryImage((await rootBundle.load(firmaLu)).buffer.asUint8List());
    final pageTheme = await _myPageTheme(PdfPageFormat.a4);

    pdf.addPage(
      MultiPage(
        pageTheme: pageTheme,
        build: (context) => [
          buildHeader(
            department: 'Información Impreso por ${currentUsers?.fullName}',
            imageLogo: firmaControlOperacion,
            fecha: DateTime.now().toString().substring(0, 10),
            text: 'Listado de Plan',
            current: 'Planificación',
          ),
          tableProduccionLinea(list)
        ],
        footer: (context) => buildFooter(imageFirma),
      ),
    );

    return PdfApi.saveDocument(
        name: 'Plani_${DateTime.now().toString().substring(0, 10)}.pdf',
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
                  style:
                      const TextStyle(fontSize: 8, color: PdfColors.grey600)),
            ]),
            // Image(imageLogo!, width: size, height: size),
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
        Divider(color: PdfColors.grey200, thickness: 1),
      ],
    );
  }

  static Widget tableProduccionLinea(List<PrinterPlan> list) {
    final headers = [
      'DEPART',
      'ESTADO',
      '#NUM',
      'LOGO',
      'CANT',
      'TIPOS',
      'ASIGNADO',
      'FICHA',
      'ORDEN',
      'FECHA',
    ];

    final data = list.map((item) {
      return [
        item.nameDepart ?? '',
        item.estado ?? '',
        item.indexWork ?? '',
        item.nombreLogo ?? '',
        item.cantidad ?? '',
        item.tipoTrabajo ?? '',
        item.asignado ?? '',
        item.orden ?? '',
        item.ficha ?? '',
        item.fechaTrabajo ?? '',
      ];
    }).toList();
    // // AGREGAR FILA DE TOTALES / PROMEDIOS
    // final totalProduccion = ProducionLinea.getTotal(list);

    // final avgProdPorHora = ProducionLinea.getTotalHoursProd(
    //   list,
    //   ProducionLinea.depurarFechaProducion(list).length.toString(),
    // );

    // final filaResumen = [
    //   'TOTALES', // MACHINE
    //   // '${data.length} rows', // MODULO
    //   getNumFormatedDouble(totalProduccion), // PRODUCION,
    //   '${ProducionLinea.getAVGDespMaquina(list)} %', // DESP-MAQUINA
    //   '${ProducionLinea.getAVGDespOperario(list)} %', // D. OPERARIO
    //   '${ProducionLinea.getAVGDespTotal(list)} %', // DESP-TOTAL
    //   '', // EFIC-REAL
    //   '',
    //   getNumFormatedDouble(avgProdPorHora), // AVG-PROD/HOURS
    //   '',
    //   '',
    //   '',
    //   // FECHA,
    //   // USUARIO,
    //   // TURNO
    // ];

    // data.add(filaResumen);

    return TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: const TableBorder(
          horizontalInside: BorderSide(color: PdfColors.grey100),
          verticalInside: BorderSide(color: PdfColors.grey100)),
      tableWidth: TableWidth.max,
      headerAlignment: Alignment.centerLeft,
      cellStyle: const TextStyle(fontSize: 8),
      oddRowDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellAlignments: {
        for (var i = 0; i < headers.length; i++) i: Alignment.center,
      },
      headerStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 6,
        color: PdfColors.white,
      ),
      headerDecoration: const BoxDecoration(color: PdfColors.black),
    );
  }

// Función auxiliar para calcular el promedio de producción por hora
  static String _calcularPromedio(String? produccionStr, String? horasStr) {
    final produccion = double.tryParse(produccionStr ?? '') ?? 0;
    final horas = double.tryParse(horasStr ?? '') ?? 0;
    if (horas == 0) return '0';
    return getNumFormatedDouble((produccion / horas).toString());
  }

  static Widget buildFooter(image) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image(image, height: 10, width: 10),
          SizedBox(width: 10),
          Text('Design by LuDeveloper', style: const TextStyle(fontSize: 7)),
        ],
      );

  static Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
    final imageLogoApp =
        MemoryImage((await rootBundle.load(logoApp)).buffer.asUint8List());

    return pw.PageTheme(
      orientation: PageOrientation.natural,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      buildForeground: (context) {
        return Stack(
          children: [
            pw.Positioned(
              right: 20,
              top: -10,
              child: Transform.rotate(
                angle: 45,
                child: Opacity(
                    opacity: 0.2,
                    child: Container(
                        child: Image(imageLogoApp, width: 200, height: 200))),
              ),
            ),
            pw.Positioned(
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
      // buildBackground: (pw.Context context) {
      //   return pw.FullPage(
      //     ignoreMargins: true,
      //     child: pw.Stack(
      //       children: [],
      //     ),
      //   );
      // },
    );
  }
}
