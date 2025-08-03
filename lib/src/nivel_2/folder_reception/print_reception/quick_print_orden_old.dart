import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import '/src/model/planificacion.dart';
import '/src/screen_print_pdf/apis/pdf_api.dart';

class PdfQuickPrint {
  static Future<File> generate(tableData) async {
    final pdf = Document();
    pdf.addPage(
      MultiPage(
        build: (context) => [
          buildHeader(),
          // SizedBox(height: 1 * PdfPageFormat.cm),
          buildTitle('Total ${tableData.length}'),
          SizedBox(height: 0.10 * PdfPageFormat.cm),
          buildTable(tableData),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
        ],
        footer: (context) => buildFooter(),
      ),
    );
    return PdfApi.saveDocument(name: 'ReporteProducion.pdf', pdf: pdf);
  }

  ////////////////WIDGet para el titulo//
  static Widget buildHeader() => Column(
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
              buildCustomerAddress(),
              // buildInvoiceInfo(invoice),
            ],
          ),
        ],
      );
  static Widget buildCustomerAddress() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reporte de Saqueta Por Entregar',
              style: TextStyle(fontWeight: FontWeight.bold)),
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
  static Widget buildTable(List<Planificacion> tableData) {
    final headers = [
      'Estado',
      'Department',
      '# Orden',
      'Ficha',
      'Nombre LOGO',
      'Cant',
      'Fecha Created',
      'Fecha de entrega',
    ];

    final data = tableData.map((item) {
      return [
        'Por Entregar',
        item.nameDepart,
        item.numOrden,
        item.ficha,
        item.nameLogo,
        item.cant,
        item.fechaStart,
        item.fechaEntrega,
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      // defaultColumnWidth: FlexColumnWidth(),
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 5),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 5),
      columnWidths: const {
        0: FractionColumnWidth(10),
        1: FractionColumnWidth(10),
        2: FractionColumnWidth(10),
        3: FractionColumnWidth(15),
        4: FractionColumnWidth(50),
        5: FractionColumnWidth(7),
        6: FractionColumnWidth(10),
        7: FractionColumnWidth(10),
      },
      headerAlignments: {
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
