import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../../datebase/current_data.dart';
import '../../../screen_print_pdf/apis/pdf_api.dart';

class PdfPrintOrdenProduccion {
  PdfPrintOrdenProduccion();

  static Future<File> generate({
    required String cliente,
    required String fecha,
    required String entrega,
    required String ficha,
    required String codigo,
    required List<Map<String, dynamic>> productos,
    required String aprobadoPor,
  }) async {
    // Cargar imágenes
    final logoFirma = MemoryImage(
        (await rootBundle.load('assets/logo_lu.png')).buffer.asUint8List());

    final logoImage =
        MemoryImage((await rootBundle.load(logoApp)).buffer.asUint8List());
    final background = MemoryImage(
        (await rootBundle.load('assets/logo_app_sin_fondo.png'))
            .buffer
            .asUint8List());
    //  assets/skin.jpg
    // assets/loro.jpg
    // assets/loro_othe.jpg

    final pdf = Document();

    pdf.addPage(Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return Stack(
          children: [
            // Colocar el fondo como una imagen
            Positioned(
              right: 0,
              top: -5, // Ajusta según tu necesidad
              child: Opacity(
                opacity: 0.5, // Ajusta la opacidad para la marca de agua
                child: Container(
                  decoration: BoxDecoration(
                    // border: Border.all(
                    //     color: PdfColors.black, width: 1),

                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Image(
                    background,
                    width: 200,
                    height: 200, // Ajusta el tamaño
                  ),
                ),
              ),
            ),
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              // Agregar los demás elementos sobre la imagen de fondo
              buildHeaderInfo('Orden de Producción', logoImage),
              SizedBox(height: 10),
              buildClienteInfo(cliente, fecha, entrega, ficha, codigo),
              SizedBox(height: 10),
              buildTablaProductos(productos),
              SizedBox(height: 20),
              buildAprobado(aprobadoPor),

              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                buildFooter(logoFirma),
              ]),
              Divider(color: PdfColors.grey500),
            ])
          ],
        );
      },
      margin: const EdgeInsets.all(10),
    ));
    return PdfApi.saveDocument(
      name: 'orden_produccion_$codigo.pdf',
      pdf: pdf,
    );
  }

// Función para agregar la imagen de fondo
  static Widget buildBackground(ImageProvider backgroundImage) {
    return Positioned(
      left: 0,
      top:
          100, // Posiciona la imagen en la parte superior izquierda, cerca de la mitad
      child: Opacity(
        opacity:
            0.1, // Ajusta la opacidad para que sea más sutil como marca de agua
        child: Image(backgroundImage,
            width: 300, height: 300), // Ajusta el tamaño según sea necesario
      ),
    );
  }

  static Widget buildHeaderInfo(String title, ImageProvider logo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        SizedBox(width: 150, height: 50),
        SizedBox(width: 150, height: 50),
      ],
    );
  }

  static Widget buildClienteInfo(String cliente, String fecha, String entrega,
      String ficha, String codigo) {
    const style = TextStyle(fontSize: 12);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('Cliente: ', style: style),
        Text(cliente, style: style.copyWith(fontWeight: FontWeight.bold)),
      ]),
      SizedBox(height: 5),
      Text('Fecha: $fecha', style: style),
      SizedBox(height: 5),
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: PdfColors.green100,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: PdfColors.green600, width: 1),
        ),
        child: Text('Entrega: $entrega',
            style: style.copyWith(fontWeight: FontWeight.bold)),
      ),
      SizedBox(height: 5),
      Row(children: [
        Text('Ficha: $ficha', style: style),
        SizedBox(width: 20),
        Text('Código: $codigo', style: style),
      ]),
    ]);
  }

  static Widget buildTablaProductos(List<Map<String, dynamic>> productos) {
    final headers = ['Descripción', 'Precio', 'Cantidad'];
    final data = productos
        .map((e) => [
              e['descripcion'] ?? 'N/A',
              e['precio'] ?? '0',
              e['cantidad'].toString(),
            ])
        .toList();

    // Calcular el total
    final total = productos.fold<double>(
        0, (sum, item) => sum + double.parse(item['cantidad'] ?? 0));

    return Column(
      children: [
        TableHelper.fromTextArray(
          headers: headers,
          data: data,
          headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          cellStyle: const TextStyle(fontSize: 14),
          border: TableBorder.all(width: 0.5, color: PdfColors.grey500),
          headerDecoration: const BoxDecoration(color: PdfColors.grey300),
          cellAlignments: const {
            0: Alignment.centerLeft,
            1: Alignment.centerRight,
            2: Alignment.centerRight,
          },
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Total: ', style: const TextStyle(fontSize: 12)),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 10)),
            Text(
              total.toStringAsFixed(0),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  static Widget buildAprobado(String aprobadoPor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Aprobado por:', style: const TextStyle(fontSize: 9)),
              SizedBox(height: 10),
              Text(aprobadoPor,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Container(
                width: 100, // ajusta el ancho de la línea de firma
                height: 0.5, // delgada línea para la firma
                color: PdfColors.black,
              ),
            ],
          )
        ],
      ),
    );
  }

  static Widget buildFooter(ImageProvider firma) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image(firma, height: 15, width: 15),
        SizedBox(width: 5),
        Text('Design by LuDeveloper', style: const TextStyle(fontSize: 7))
      ],
    );
  }
}
