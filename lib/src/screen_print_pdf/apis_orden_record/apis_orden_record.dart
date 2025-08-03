import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import '/src/screen_print_pdf/apis/pdf_api.dart';
import '/src/screen_print_pdf/model/customer.dart';
import '/src/screen_print_pdf/model/invoice.dart';
import '/src/screen_print_pdf/model/supplier.dart';

class PdfInvoiceOrdenRecord {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'Ordenes.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice.customer, invoice.info),
              buildInvoiceInfo(invoice.info),
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(Customer customer, InvoiceInfo info) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name Compañia', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            customer.name,
          ),
          Text(info.date),
        ],
      );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    // final paymentTerms = '${info.date.difference(info.date).inDays} days';
    final titles = <String>[
      'Fecha impr:',
    ];
    final data = <String>[DateTime.now().toString().substring(0, 19)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];
        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildSupplierAddress(Supplier supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.address),
        ],
      );

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            invoice.head,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Orden',
      'Logo',
      'Turno',
      'Calidad',
      'Fecha',
      'Comentario',
      'Piezas',
    ];
    final data = invoice.items?.map((item) {
      return [
        item.numOrden,
        item.logo,
        item.turn,
        item.calida == 't' ? 'Realizado' : 'N/A',
        item.dateCurrent,
        item.comment,
        item.cantPcs,
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      cellStyle: const TextStyle(
        fontSize: 10,
      ),
      // columnWidths: const {
      //   0: FractionColumnWidth(100),
      //   1: FractionColumnWidth(200),
      //   2: FractionColumnWidth(150),

      // },
      data: data ?? [],
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.center,
        4: Alignment.center,
        5: Alignment.center,
      },
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          buildSimpleText(title: 'Name Compañia'),
        ],
      );

  static buildSimpleText({
    required String title,
  }) {
    final style = TextStyle(
        fontWeight: FontWeight.bold, color: PdfColor.fromHex('2b4bd9'));

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
      ],
    );
  }

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

  static buildTextGet({
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
          // pw.SizedBox(),
        ],
      ),
    );
  }

  static Widget buildTotal(Invoice invoice) {
    int netTotal = 0;

    for (var element in invoice.items ?? []) {
      netTotal += int.parse(element.cantPcs);
    }

    // String total = netTotal.toInt().toString();

    // String totaNetLB = num(int.parse(total.toString()));

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
                  title: 'Total',
                  value: netTotal.toString(),
                  unite: true,
                ),
              ],
            ),
          ),
          // Divider(),
        ],
      ),
    );
  }
}
