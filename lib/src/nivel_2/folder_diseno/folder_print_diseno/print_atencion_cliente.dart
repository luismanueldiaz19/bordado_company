import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import '/src/nivel_2/folder_diseno/folder_atencion_cliente/record_atencion_cliente.dart';
import '/src/screen_print_pdf/apis/pdf_api.dart';

import '../model_diseno/atencion_cliente.dart';

class PdfAtencionCliente {
  static Future<File> generate(tableData) async {
    // File('assets/logo_app.png').readAsBytesSync()
    final image = MemoryImage(
        (await rootBundle.load('assets/design.jpg')).buffer.asUint8List());
    final pdf = Document();

    pdf.addPage(
      MultiPage(
        build: (context) => [
          // buildPaymentInfoRowImagen('Información', image, image),
          buildHeader(image, 'Informacion Atencion Al Clientes'),
          // SizedBox(height: 1 * PdfPageFormat.cm),
          buildTitle('Trabajos :  ${tableData.length}'),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          buildTable(tableData),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
        ],
        footer: (context) => buildFooter(),
      ),
    );
    return PdfApi.saveDocument(name: 'Documentos.pdf', pdf: pdf);
  }

  ////////////////WIDGet para el titulo//
  static Widget buildHeader(image2, text) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: 'adsfsddgsudfvsutav',
                ),
              ),
              Text(text),
              pw.Image(image2, height: 100, width: 100),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(),
              // buildInvoiceInfo(invoice),
            ],
          ),
        ],
      );
  static Widget buildCustomerAddress() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tejidos Tropical'),
          // Text('Confección'),
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

//////////////table de la lista de tipo de tabajopor nombre de usuarios////////
  static Widget buildTable(List<AtencionCliente> tableData) {
    final headers = [
      'Detalles/LOGO',
      'Tipo Trabajos',
      'Empezó',
      'Terminó',
      'Promedio',
      'Empleado',
    ];
    //  DataColumn(label: Text('Departamento')),
    //     DataColumn(label: Text('Estado')),
    //     DataColumn(label: Text('Num Orden')),
    //     DataColumn(label: Text('Fichas')),
    //     DataColumn(label: Text('Logo')),
    //     DataColumn(label: Text('Producto')),
    //     DataColumn(label: Text('Cant')),
    //     DataColumn(label: Text('Comentario')),

    final data = tableData.map((item) {
      return [
        item.descripcion,
        item.typeWorked,
        item.dateStart,
        item.dateEnd,
        diferentTime(item),
        item.userRegistered,
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: const TableBorder(
        horizontalInside: BorderSide(color: PdfColors.brown),
      ),
      headerAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerLeft,
        4: Alignment.centerLeft,
      },
      tableWidth: TableWidth.max,
      columnWidths: const {
        0: FlexColumnWidth(15),
        1: FlexColumnWidth(15),
        2: FlexColumnWidth(15),
        3: FlexColumnWidth(15),
        4: FlexColumnWidth(15),
      },
      cellStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
      headerDecoration: const BoxDecoration(
        color: PdfColors.grey100,
      ),
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerLeft,
        4: Alignment.centerLeft,
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
