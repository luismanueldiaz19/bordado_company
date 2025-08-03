import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import '/src/screen_print_pdf/apis/pdf_api.dart';
import '/src/screen_print_pdf/model/customer.dart';
import '/src/screen_print_pdf/model/invoice.dart';
import '/src/screen_print_pdf/model/supplier.dart';

class PdfApisSublimacionWork {
  PdfApisSublimacionWork();

  Future<File> generate(Invoice invoice) async {
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

    return PdfApi.saveDocument(
        name: 'Reportes_Eficiencia_trabajos.pdf', pdf: pdf);
  }

  Widget buildHeader(Invoice invoice) => Column(
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
                  data: invoice.suplimaWork!.first.dateStart.toString(),
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

  Widget buildCustomerAddress(Customer customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nombre Compañia',
              style: TextStyle(fontWeight: FontWeight.bold)),
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

  Widget buildSupplierAddress(Supplier supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.address),
        ],
      );

  Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            invoice.head,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );
  // Duration toTalDiferences = const Duration();
  // // String totalTrabajo = '';
  // int totalOrden = 0;
  // int totalElaborado = 0;
  // double percentRelation = 0.0;
  // Duration? diferences;
  String takeTime(start, end) {
    DateTime date1 = DateTime.parse(start.toString().substring(0, 19));
    DateTime date2 = DateTime.parse(end.toString().substring(0, 19));
    Duration? diferences = date2.difference(date1);
    return diferences.toString().substring(0, 7);
  }

  Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Orden / Ficha',
      'Trabajo',
      'Usuario',
      'C.Orden / C.Lab',
      'Turno',
      'T.Ini',
      'T.Finished',
      'Tiempo'
    ];
    // takeTime(invoice.suplimaWork ?? []);
    final data = invoice.suplimaWork?.map((item) {
      return [
        "${item.numOrden} / ${item.ficha}",
        item.nameWork,
        item.fullName,
        "${item.cantOrden} / ${item.cantPieza}",
        item.turn,
        item.dateStart,
        item.dateEnd,
        takeTime(item.dateStart, item.dateEnd),
        // item.dateCurrent.toString().substring(0, 16),
        // getNumFormated(int.parse(item.cantOrden.toString())),
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data ?? [],
      border: null,

      defaultColumnWidth: const IntrinsicColumnWidth(flex: 2),
      headerAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.center,
        4: Alignment.center,
        5: Alignment.center,
        6: Alignment.center,
        7: Alignment.center,
      },
      // tableWidth: TableWidth.max,
      cellStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
      headerDecoration: BoxDecoration(
          color: PdfColors.orange100,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: const [
            BoxShadow(
              color: PdfColors.orange200,
              blurRadius: 3.5,
              offset: PdfPoint.zero,
              spreadRadius: 9.0,
            )
          ]),
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.center,
        4: Alignment.center,
        5: Alignment.center,
        6: Alignment.center,
        7: Alignment.center,
      },
    );
  }

  Widget buildTotal(Invoice invoice) {
    // double netTotal = 0.0;

    // for (var element in invoice.items ?? []) {
    //   netTotal += double.parse(element.monto);
    // }

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
                  title: 'Total Trabajo',
                  value: invoice.suplimaWork![0].toTalDiferences.toString(),
                  // getNumFormated(
                  // int.parse(netTotal.toStringAsFixed(0).toString())),
                  unite: true,
                ),
                buildText(
                  title: '% Orden Percent',
                  value: invoice.suplimaWork![0].percentRelation.toString(),
                  // getNumFormated(
                  // int.parse(netTotal.toStringAsFixed(0).toString())),
                  unite: true,
                ),
                buildText(
                  title: 'Total pieza Orden',
                  value: invoice.suplimaWork![0].totalOrden.toString(),
                  // getNumFormated(
                  // int.parse(netTotal.toStringAsFixed(0).toString())),
                  unite: true,
                ),
                buildText(
                  title: 'Total pieza Elaborado',
                  value: invoice.suplimaWork![0].totalElaborado.toString(),
                  // getNumFormated(
                  // int.parse(netTotal.toStringAsFixed(0).toString())),
                  unite: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          buildSimpleText(title: 'Design by LuDeveloper'),
        ],
      );

  buildSimpleText({
    required String title,
  }) {
    const style = TextStyle();

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
      ],
    );
  }

  buildText({
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

  buildTextGet({
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
