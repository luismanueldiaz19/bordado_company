import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../datebase/current_data.dart';
import '../datebase/url.dart';
import '../folder_incidencia_main/model_incidencia/incidencia_main.dart';
import '../screen_print_pdf/apis/pdf_api.dart';
import '../util/get_formatted_number.dart';

class PrintIncidencia {
  PrintIncidencia();

  static Future<File> generate(IncidenciaMain factura) async {
    final image =
        MemoryImage((await rootBundle.load(logoApp)).buffer.asUint8List());

    // // Agregar la imagen al PDF
    // final Uint8List imageBytes = File(path).readAsBytesSync();
    // final pdfWidgets.MemoryImage imageGrafics = pdfWidgets.MemoryImage(
    //   imageBytes,
    // );
    final imageLOGO = MemoryImage((await rootBundle.load(firmaLu)).buffer.asUint8List());
      Future<Image> loadImageFromUrl(String url) async {
      final ByteData imageData = await NetworkAssetBundle(Uri.parse(url)).load('');
      final Uint8List uint8list = imageData.buffer.asUint8List();
      final MemoryImage image = MemoryImage(uint8list);
      return Image(image);
    }

    List<Image> listImagen = [];
    if (factura.listImagenes!.isNotEmpty) {
      for (var image in factura.listImagenes!) {
        Image pdfImage = await loadImageFromUrl(
            'http://$ipLocal/settingmat/incidencia_imagen/${image.imagenPath}');
        final pdfImageWidget = Image(pdfImage.image);
        listImagen.add(pdfImageWidget);
      }
    }

    final pdf = Document();
    const style = TextStyle(fontSize: 8);
    pdf.addPage(MultiPage(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      build: (context) => [
        buildPaymentInfoRowImagen('Informe de incidencia', image),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        Text(currentEmpresa.nombreEmpresa ?? ''),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(currentEmpresa.adressEmpressa ?? '',
                  style: const TextStyle(fontSize: 9)),
              Row(
                children: [
                  Text('TEL: ${currentEmpresa.telefonoEmpresa ?? ''}',
                      style: style),
                  SizedBox(width: 5),
                  Text('CEL: ${currentEmpresa.celularEmpresa ?? ''}',
                      style: style),
                  SizedBox(width: 5),
                  Text('OFICINA: ${currentEmpresa.oficinaEmpres ?? ''}',
                      style: style),
                ],
              ),
              Text('RNC : ${currentEmpresa.rncEmpresa ?? ''}', style: style),
              // Text(
              //     'Registrado por : ${factura.dateRegisted ?? ''} En : ${factura.dateRegisted.toString().toUpperCase()}',
              //     style: style),
              SizedBox(height: 5),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text('Limite proximo pago:',
              //         style: style.copyWith(fontWeight: FontWeight.bold)),
              //     SizedBox(width: 5),
              //     Text('factura.fechaVencimiento ?? ',
              //         style: style.copyWith(
              //             color: PdfColors.red, fontWeight: FontWeight.bold)),
              //   ],
              // ),
            ],
          ),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: [
          //     // Text('Estado : ${factura.idFactura ?? ''}',
          //     //     style: TextStyle(
          //     //         color: PdfColors.black, fontWeight: FontWeight.bold)),
          //     Text(
          //         'Cliente : ${factura.apellido ?? ''}, ${factura.nombre ?? ''}',
          //         style: TextStyle(
          //             color: PdfColors.lightBlue900,
          //             fontWeight: FontWeight.bold)),
          //     Text('ID-Gubernamental : ${factura.dni ?? ''}', style: style),
          //     Text('Telefono: ${factura.telefono ?? ''}', style: style),

          //     Text('Dirección: ${factura.direccion ?? ''}', style: style),

          //     // Text('DESPACHADOR /A : ${currentUser?.fullName ?? ''}',
          //     //         style: style),
          //   ],
          // ),
        ]),
        Divider(color: PdfColors.grey),
        subInfor(title: 'Ficha', value: factura.ficha ?? 'N/A'),
        subInfor(title: 'Número de Orden', value: factura.numOrden ?? 'N/A'),
        subInfor(
            title: 'Ubicación Queja', value: factura.ubicacionQueja ?? 'N/A'),
        subInfor(
            title: 'Quien Encontró', value: factura.departmentFind ?? 'N/A'),
        subInfor(
            title: 'Fecha de Solución', value: factura.fechaResuelto ?? 'N/A'),
        subInfor(title: 'Registrado por ', value: factura.registedBy ?? 'N/A'),
        subInfor(title: 'Estado', value: factura.estado ?? 'N/A'),
        Divider(color: PdfColors.grey300),
        Text('Que pasó ?'),
        SizedBox(height: 1 * PdfPageFormat.cm / 6),
        Text(
          factura.whatHapped ?? 'N/A',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: PdfColors.red600,
          ),
        ),
        Divider(color: PdfColors.grey300),
        Text('Se Compromete a'),
        SizedBox(height: 1 * PdfPageFormat.cm / 6),
        Text(
          factura.compromiso ?? 'N/A',
          style:
              TextStyle(fontWeight: FontWeight.bold, color: PdfColors.green400),
        ),
        Divider(color: PdfColors.grey300),
        SizedBox(height: 1 * PdfPageFormat.cm / 6),
        subInfor(
            title: 'Producto Afectado',
            value: factura.listProducts?.length.toString()),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        tableProducts(factura.listProducts!),
        SizedBox(height: 1 * PdfPageFormat.cm / 6),
        Divider(color: PdfColors.grey300),
        SizedBox(height: 1 * PdfPageFormat.cm / 6),
        subInfor(
            title: 'Empleado Involucrados',
            value: factura.listUsuarioResponsable?.length.toString()),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        tableEmpleadoInvolucrado(factura.listUsuarioResponsable!),
        SizedBox(height: 1 * PdfPageFormat.cm / 6),
        Divider(color: PdfColors.grey300),
        SizedBox(height: 1 * PdfPageFormat.cm / 6),
        subInfor(
            title: 'Departamento Responsables',
            value: factura.listDepartamentoResponsable?.length.toString()),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        tableDepartamentoInvolucrado(factura.listDepartamentoResponsable!),

        // SizedBox(height: 300, width: 400, child: pdfImageWidget),
        Wrap(
            children: listImagen
                .map((imagen) =>
                    SizedBox(height: 150, width: 150, child: imagen))
                .toList()),
        SizedBox(height: 1 * PdfPageFormat.cm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            firmar(label: 'Firma Gerencia', value: ''),
            firmar(label: 'Firma Supervisor', value: ''),
            firmar(label: 'Firma Operador', value: ''),
          ],
        ),
      ],
      footer: (context) => buildFooter(imageLOGO),
    ));

    return PdfApi.saveDocument(
        name: 'incidencia_file_${factura.idListIncidencia}.pdf', pdf: pdf);
  }

  static Widget subInfor({String? title, String? value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$title :', style: TextStyle(fontSize: 8)),
          Text(value!, style: TextStyle(fontSize: 8))
        ],
      ),
    );
  }

  static Widget totalPaid({String? label, String? value}) {
    const styleSeven = TextStyle(fontSize: 7);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label ?? 'N/A', style: styleSeven.copyWith()),
                    SizedBox(width: 25),
                    Text(value ?? 'N/A', style: styleSeven.copyWith())
                  ],
                ),
                SizedBox(
                    width: 100,
                    child: Divider(color: PdfColors.grey200, height: 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget firmar({String? label, String? value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label ?? 'N/A', style: const TextStyle(fontSize: 6)),
                    SizedBox(width: 25),
                    Text('', style: const TextStyle(fontSize: 6))
                  ],
                ),
                SizedBox(width: 150, child: Divider(color: PdfColors.grey200)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(imageLOGO) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image(imageLOGO, height: 15, width: 15),
          SizedBox(width: 5),
          Text('Design by LuDeveloper', style: const TextStyle(fontSize: 7))
        ],
      );

  static Widget tableProducts(List<ListProduct> listProduct) {
    // DataColumn(label: Text('Numero Cuota')),
    // DataColumn(label: Text('Monto Pagar')),
    // DataColumn(label: Text('Mora')),
    // DataColumn(label: Text('Fecha Pago')),
    // DataColumn(label: Text('Fecha Limite')),
    // DataColumn(label: Text('Estado')),
    final headers = [
      'Nombre del producto',
      'cantidad',
      'costo',
      'subtotal',
    ];
    final data = listProduct
        .map(
          (producto) => [
            producto.nameProduct ?? '',
            '\$ ${getNumFormatedDouble(producto.cant.toString())}',
            '\$ ${getNumFormatedDouble(producto.costo.toString())}',
            ListProduct.getSubtotal(producto).toString()
          ],
        )
        .toList();

    return TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: const TableBorder(
          horizontalInside: BorderSide(color: PdfColors.orange100),
          verticalInside: BorderSide(color: PdfColors.orange100)),
      tableWidth: TableWidth.max,
      // cellAlignment: Alignment.topLeft,
      headerAlignment: Alignment.topLeft,
      cellStyle: const TextStyle(fontSize: 8),
      oddRowDecoration: const BoxDecoration(color: PdfColors.orange100),
      cellAlignments: {
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.bottomRight
      },
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
      headerDecoration: const BoxDecoration(color: PdfColors.orange100),
    );
  }

  static Widget tableEmpleadoInvolucrado(
      List<ListUsuarioResponsable> listProduct) {
    // DataColumn(label: Text('Numero Cuota')),
    // DataColumn(label: Text('Monto Pagar')),
    // DataColumn(label: Text('Mora')),
    // DataColumn(label: Text('Fecha Pago')),
    // DataColumn(label: Text('Fecha Limite')),
    // DataColumn(label: Text('Estado')),
    final headers = [
      'Nombre Empleado',
      'Codigo Empleado',
      '#ID Incidencia',
    ];
    final data = listProduct
        .map(
          (producto) => [
            producto.fullName ?? '',
            producto.code,
            producto.idListIncidencia
          ],
        )
        .toList();

    return TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: const TableBorder(
          horizontalInside: BorderSide(color: PdfColors.purple100),
          verticalInside: BorderSide(color: PdfColors.purple100)),
      tableWidth: TableWidth.max,
      // cellAlignment: Alignment.topLeft,
      headerAlignment: Alignment.topLeft,
      cellStyle: const TextStyle(fontSize: 8),
      oddRowDecoration: const BoxDecoration(color: PdfColors.purple100),
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.center,
        2: Alignment.bottomRight
      },
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
      headerDecoration: const BoxDecoration(color: PdfColors.purple100),
    );
  }

  static Widget tableDepartamentoInvolucrado(
      List<ListDepartamentoResponsable> listProduct) {
    // DataColumn(label: Text('Numero Cuota')),
    // DataColumn(label: Text('Monto Pagar')),
    // DataColumn(label: Text('Mora')),
    // DataColumn(label: Text('Fecha Pago')),
    // DataColumn(label: Text('Fecha Limite')),
    // DataColumn(label: Text('Estado')),
    final headers = [
      'Nombre Departamento',
      '#ID Incidencia',
    ];
    final data = listProduct
        .map(
          (producto) =>
              [producto.departmentResponsable ?? '', producto.idListIncidencia],
        )
        .toList();

    return TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: const TableBorder(
          horizontalInside: BorderSide(color: PdfColors.blue100),
          verticalInside: BorderSide(color: PdfColors.blue100)),
      tableWidth: TableWidth.max,
      // cellAlignment: Alignment.topLeft,
      headerAlignment: Alignment.topLeft,
      cellStyle: const TextStyle(fontSize: 8),
      oddRowDecoration: const BoxDecoration(color: PdfColors.blue100),
      cellAlignments: {0: Alignment.center, 1: Alignment.bottomRight},
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
      headerDecoration: const BoxDecoration(color: PdfColors.blue100),
    );
  }

  static Widget buildPaymentInfoRowImagen(String label, image) {
    const style = TextStyle(fontSize: 8);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image(image, height: 50, width: 50),
          Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(label.toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Impr por.', style: style),
                Text(DateTime.now().toString().substring(0, 19).toUpperCase(),
                    style: style.copyWith(color: PdfColors.brown, fontSize: 7)),
              ]),
        ],
      ),
    );
  }

  static Widget buildPaymentInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.toUpperCase(),
          ),
          Text(
            value,
            style: const TextStyle(
                // fontSize: 16.0,
                ),
          ),
        ],
      ),
    );
  }
}
