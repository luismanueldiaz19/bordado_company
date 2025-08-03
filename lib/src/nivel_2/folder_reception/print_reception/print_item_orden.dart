import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import '/src/nivel_2/folder_planificacion/model_planificacion/item_planificacion.dart';
import '/src/screen_print_pdf/apis/pdf_api.dart';

class PdfReportOrdenItem {
  static Future<File> generate(tableData) async {
    final pdf = Document();
    pdf.addPage(
      MultiPage(
        build: (context) => [
          buildHeader(),
          // SizedBox(height: 1 * PdfPageFormat.cm),
          buildTitle('Ordenes ${tableData.length}'),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          buildTable(tableData),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
        ],
        footer: (context) => buildFooter(),
      ),
    );
    return PdfApi.saveDocument(name: 'Statu_ordenes.pdf', pdf: pdf);
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
  static Widget buildTable(List<PlanificacionItem> tableData) {
    final headers = [
      'Depart',
      '# Orden / Fichas',
      'Nombre del Logo',
      'Detalles',
      'Cant',
      'Statu',
      'Fecha',
      'Fecha Ent.',
      'Comentario',
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
        item.department,
        '${item.numOrden} - ${item.ficha}',
        item.nameLogo,
        item.tipoProduct,
        item.cant,
        item.statu,
        item.fechaStart,
        item.fechaEnd,
        item.comment
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
        0: FractionColumnWidth(15),
        1: FractionColumnWidth(15),
        2: FractionColumnWidth(30),
        3: FractionColumnWidth(20),
        4: FractionColumnWidth(10),
        5: FractionColumnWidth(20),
        6: FractionColumnWidth(20),
        7: FractionColumnWidth(20),
        8: FractionColumnWidth(25),
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
        8: Alignment.centerLeft,
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
