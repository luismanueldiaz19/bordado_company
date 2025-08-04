import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import '/src/model/planificacion.dart';
import '../../model/sublima.dart';
import '/src/screen_print_pdf/apis/pdf_api.dart';
// import 'package:settingmat/src/screen_print_pdf/model/customer.dart';
import '/src/util/get_formatted_number.dart';

class PdfReceptionPrint {
  static Future<File> generate(ranked, tituto) async {
    final pdf = Document();
    final image = MemoryImage(
        (await rootBundle.load('assets/logo_app.png')).buffer.asUint8List());

    pdf.addPage(
      MultiPage(
        build: (context) => [
          // buildHeader(fecha),
          // SizedBox(height: 1 * PdfPageFormat.cm),
          buildPaymentInfoRowImagen('Recepción / Saquetas', image),

          SizedBox(height: 0.5 * PdfPageFormat.cm),
          buildTitle(tituto),
          buildTableDestacado(ranked),
          Divider(),
          // buildTotal(ranked),
          // Divider(),
          // buildTotal(data),
        ],
        footer: (context) => buildFooter(),
      ),
    );
    return PdfApi.saveDocument(name: 'Reception.pdf', pdf: pdf);
  }

  static Widget buildPaymentInfoRowImagen(String label, image) {
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
          // pw.Image(image2, height: 100, width: 100),
          // SizedBox(width: 100),
        ],
      ),
    );
  }

  ////////////////WIDGet para el titulo//
  static Widget buildHeader(fecha) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // buildSupplierAddress(invoice.supplier),
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: 'adsfsddgsudfvsutav',
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(fecha),
              // buildInvoiceInfo(invoice),
            ],
          ),
        ],
      );
  static Widget buildCustomerAddress(fecha) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fecha : ${fecha['firstDate']} hasta ${fecha['secondDate']}',
          ),
          Text('Reporte General Serigrafia',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Tejidos Tropical'),
          Text('Serigrafia'),
        ],
      );
  //----------------------------------------//
  static Widget buildTitle(text) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style:
                TextStyle(fontWeight: FontWeight.bold, color: PdfColors.teal),
          ),
          // SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );
  //////////////////////total Parts de Empleado Destacado///
  static Widget buildTotal(List<Sublima>? listEmpleadoDestacados) {
    int netTotal = 0;

    for (var element in listEmpleadoDestacados ?? []) {
      netTotal += int.parse(element.cantPieza);
    }

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Total Cantidad : ',
                  value: getNumFormated(int.parse(netTotal.toString())),
                  unite: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//////////////table de la lista de tipo de tabajopor nombre de usuarios////////
  static Widget buildTable(List<List<String>> tableData) {
    return Table.fromTextArray(
      // context: context,
      headers: [
        'Empleados',
        'PINTANDO',
        'QUEMADO',
        'HORNO',
        'CUADRAR MARCOS',
        'BORRAR MARCOS',
        'PLANCHANDO',
        'EMPAQUE',
        'TOTAL',
      ],
      data: tableData,
      headerAlignment: Alignment.centerLeft,
      cellAlignment: Alignment.centerLeft,

      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 10,

      cellStyle: const TextStyle(
        fontSize: 6,
      ),
      defaultColumnWidth: const FixedColumnWidth(25),
      headerStyle: TextStyle(
          fontSize: 6, color: PdfColors.brown, fontWeight: FontWeight.bold),
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
      },
    );
  }

  //////////////table de la lista de tipo de tabajopor nombre de usuarios////////
  static Widget buildTablePiezas(List<List<String>> tableData) {
    return Table.fromTextArray(
      // context: context,
      headers: [
        'Nombre',
        'C-1',
        'C-2',
        'C-3',
        'C-4',
        'C-5',
        'C-6',
        'Total',
      ],
      data: tableData,
      headerAlignment: Alignment.centerLeft,
      cellAlignment: Alignment.centerLeft,

      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 10,

      cellStyle: const TextStyle(
        fontSize: 6,
      ),
      defaultColumnWidth: const FixedColumnWidth(25),
      headerStyle: TextStyle(
          fontSize: 6, color: PdfColors.brown, fontWeight: FontWeight.bold),
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerLeft,
        4: Alignment.centerLeft,
        5: Alignment.centerLeft,
        6: Alignment.centerLeft,
        7: Alignment.centerLeft,
      },
    );
  }

  //////////////table de la lista de tipo de tabajopor nombre de usuarios////////
  static Widget buildTableTotal(List<Sublima>? totalTipoTrabajos) {
    return Row(
        children: totalTipoTrabajos!
            .map(
              (e) => Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    Text(e.typeWork ?? 'N/A',
                        style: const TextStyle(fontSize: 8)),
                    Text(
                      ': ${e.toTalDiferences ?? 'N/A'}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 6,
                          color: PdfColors.green),
                    )
                  ],
                ),
              ),
            )
            .toList());
    // Table.fromTextArray(
    //   // context: context,
    //   headers: [
    //     'Calandra',
    //     'Empaque',
    //     'Plancha',
    //     'Horno',
    //     'Transfer',
    //     'Vinil',
    //     'Impreción Cortes',
    //     'Sub-Normal',
    //     'Sellos',
    //     'DTF'
    //   ],
    //   data: totalTipoTrabajos ?? [],
    //   headerAlignment: Alignment.centerLeft,
    //   cellAlignment: Alignment.centerLeft,

    //   headerDecoration: const BoxDecoration(color: PdfColors.grey300),
    //   cellHeight: 10,

    //   cellStyle: const TextStyle(
    //     fontSize: 6,
    //   ),
    //   defaultColumnWidth: const FixedColumnWidth(25),
    //   headerStyle: TextStyle(
    //       fontSize: 6, color: PdfColors.brown, fontWeight: FontWeight.bold),
    //   cellAlignments: {
    //     0: Alignment.centerLeft,
    //     1: Alignment.centerLeft,
    //     2: Alignment.centerLeft,
    //     3: Alignment.centerLeft,
    //     4: Alignment.centerLeft,
    //     5: Alignment.centerLeft,
    //     6: Alignment.centerLeft,
    //     7: Alignment.centerLeft,
    //     8: Alignment.centerLeft,
    //     9: Alignment.centerLeft,
    //     10: Alignment.centerLeft,
    //     11: Alignment.centerLeft,
    //   },
    // );
  }

  //////////////////////////table empleados destacado /////////
  static Widget buildTableDestacado(
      List<Planificacion>? listEmpleadoDestacados) {
    final headers = [
      'Department',
      'Orden/Ficha',
      'Logo',
      'Cant',
      'Entrega / Fecha'
    ];
    final data = listEmpleadoDestacados?.map((item) {
      return [
        item.nameDepart,

        '${item.numOrden} -- ${item.ficha}',

        // item.dateStart.toString().substring(0, 16),
        item.nameLogo,
        item.cant,
        '${item.isEntregado} / ${item.fechaEntrega}',
      ];
    }).toList();

    return Table.fromTextArray(
      // cellDecoration: BoxDecoration(),
      headers: headers,

      data: data ?? [],
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 6),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellStyle: const TextStyle(fontSize: 7),
      columnWidths: const {
        0: FixedColumnWidth(11.0),
        1: FixedColumnWidth(10.0),
        2: FixedColumnWidth(35.0),
        3: FixedColumnWidth(6.0),
        4: FixedColumnWidth(15),
      },
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
      },
    );
  }

///////////////final de la pagina mi nombre de desarrollo ////////////
  static Widget buildFooter() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              Text('Design by LuDeveloper', style: const TextStyle()),
              SizedBox(width: 2 * PdfPageFormat.mm),
            ],
          ),
        ],
      );

////////////////////widgte de text para el total de buldTotal//////////
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
}
