import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import '/src/screen_print_pdf/apis/pdf_api.dart';
import '/src/screen_print_pdf/model/customer.dart';
import '/src/screen_print_pdf/model/invoice.dart';
import '/src/screen_print_pdf/model/supplier.dart';
import '/src/util/get_formatted_number.dart';

class SastreriaDetallesPdf {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice),
        // SizedBox(height: 1 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'Sastreria_detalles.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Column(
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
                  data: invoice.listSastreriaWorkItem?.first.description
                          .toString() ??
                      'Hola',
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice.customer),
              // buildInvoiceInfo(invoice),
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(Customer customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Report ', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            customer.name,
          ),
          Text(customer.address),
        ],
      );

  // static Widget buildInvoiceInfo(info) {
  //   // final paymentTerms = '${info.date.difference(info.date).inDays} days';
  //   final titles = <String>[
  //     'Fecha : ',
  //   ];
  //   final data = <String>[
  //     info.date.toString().substring(0, 19),
  //     // paymentTerms,
  //   ];

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: List.generate(titles.length, (index) {
  //       final title = titles[index];
  //       final value = data[index];

  //       return buildText(title: title, value: value, width: 200);
  //     }),
  //   );
  // }

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
      'Num Orden',
      'Detalles',
      'Tipo Pieza',
      'Cantidad',
      'Precio'
    ];
    final data = invoice.listSastreriaWorkItem?.map((item) {
      // final total = item.unitPrice * item.quantity * (1 + item.vat);
      return [
        item.numOrden,
        item.description,

        item.tipoPieza,

        // item.dateStart.toString().substring(0, 16),
        getNumFormated(int.parse(item.cant ?? '0')),
        getNumFormated(int.parse(item.price ?? '0')),
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data ?? [],
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice) {
    int netTotalPieza = 0;
    int netTotalPrecio = 0;

    int multiplo = 0;
    for (var element in invoice.listSastreriaWorkItem ?? []) {
      multiplo =
          int.parse(element.cant ?? '0') * int.parse(element.price ?? '0');
      netTotalPieza += multiplo;
      netTotalPrecio += int.parse(element.cant ?? '0');
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
                  title: 'Total Pieza',
                  value: getNumFormated(int.parse(netTotalPrecio.toString())),
                  unite: true,
                ),
                buildText(
                  title: 'Total Precio',
                  value: getNumFormated(int.parse(netTotalPieza.toString())),
                  unite: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          buildSimpleText(title: 'Design by LuDeveloper'),
        ],
      );

  static buildSimpleText({
    required String title,
  }) {
    final style = TextStyle();

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
}
