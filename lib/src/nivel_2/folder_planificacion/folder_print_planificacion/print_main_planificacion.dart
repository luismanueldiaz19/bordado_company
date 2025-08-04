import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import '../../../datebase/current_data.dart';
import '../../../screen_print_pdf/apis/pdf_api.dart';
import '../../../util/get_formatted_number.dart';
import '../model_planificacion/item_planificacion.dart';
import '../model_planificacion/planificacion_last.dart';
import 'dart:convert';

class PrintMainPlanificacion {
  PrintMainPlanificacion();

  static Future<File> generate(List<PlanificacionItem> resumen) async {
    // Cargar imágenes
    final logoImage =
        MemoryImage((await rootBundle.load(logoApp)).buffer.asUint8List());
    final firmaImage =
        MemoryImage((await rootBundle.load(firmaLu)).buffer.asUint8List());

    // Crear el documento PDF
    final pdf = Document();
    const textStyle = TextStyle(fontSize: 8);
    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      build: (context) => [
        buildHeaderInfo(logoImage),
        buildEmpresaInfo(),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        tableProducts(resumen),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    totalPaid(label: 'Filas', value: resumen.length.toString()),
                    totalPaid(
                        label: 'Total Orden',
                        value: PlanificacionItem.getUniqueNumOrden(resumen)
                            .length
                            .toString()),
                    totalPaid(
                        label: 'Total Piezas',
                        value: getNumFormatedDouble(
                            PlanificacionItem.getGetTotal(resumen))),
                  ],
                )
              ],
            )),
      ],
      footer: (context) => buildFooter(firmaImage),
    ));

    // Guardar el documento PDF
    return PdfApi.saveDocument(name: 'doc.pdf', pdf: pdf);
  }

  // Información de la empresa
  static Widget buildEmpresaInfo() {
    const textStyle = TextStyle(fontSize: 7);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text('TEL: ${currentEmpresa.telefonoEmpresa ?? ''}',
              style: textStyle),
          SizedBox(width: 5),
          Text('CEL: ${currentEmpresa.celularEmpresa ?? ''}', style: textStyle),
          SizedBox(width: 5),
          Text('OFICINA: ${currentEmpresa.oficinaEmpres ?? ''}',
              style: textStyle),
        ]),
        Text('RNC: ${currentEmpresa.rncEmpresa ?? ''}', style: textStyle),
      ],
    );
  }

  static Widget tableProducts(List<PlanificacionItem> list) {
    final headers = [
      'Prioridad',
      'Departamento',
      'Estado Trabajo',
      '# Orden',
      'Ficha',
      'Logo',
      'Producto',
      'Cant',
      'Comentario',
      'Entrega'
    ];

    final data = list.map((item) {
      return [
        (item.priority ?? ''),
        item.department ?? 'N/A',
        (item.statu != null && item.statu!.length > 25)
            ? '${item.statu!.substring(0, 25)}...'
            : item.statu ?? '',
        item.numOrden ?? 'N/A',
        item.ficha ?? 'N/A',
        (item.nameLogo != null && item.nameLogo!.length > 25)
            ? '${item.nameLogo!.substring(0, 25)}...'
            : item.nameLogo ?? '',
        (item.tipoProduct != null && item.tipoProduct!.length > 25)
            ? '${item.tipoProduct!.substring(0, 25)}...'
            : item.tipoProduct ?? '',
        item.cant ?? 'N/A',
        (item.comment != null && item.comment!.length > 25)
            ? '${item.comment!.substring(0, 25)}...'
            : item.comment ?? '',
        item.fechaEnd ?? 'N/A'
      ];
    }).toList();

    return TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: const TableBorder(
        horizontalInside: BorderSide(color: PdfColors.grey300),
        verticalInside: BorderSide(color: PdfColors.grey300),
      ),
      tableWidth: TableWidth.max,
      headerAlignment: Alignment.centerLeft,
      cellStyle: const TextStyle(fontSize: 6),
      oddRowDecoration: const BoxDecoration(color: PdfColors.grey100),
      headerStyle: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 7, color: PdfColors.white),
      headerDecoration: const BoxDecoration(color: PdfColors.blueGrey700),
    );
  }

  // Información general y logotipo
  static Widget buildHeaderInfo(ImageProvider logo) {
    return Row(children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(logo, height: 35, width: 35),
            SizedBox(width: 10),
            Text(currentEmpresa.nombreEmpresa ?? ''),
          ]),
      Spacer(),
      Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Planificacion', style: const TextStyle(fontSize: 12)),
            Text('Fecha: ${DateTime.now().toString().substring(0, 10)}',
                style: const TextStyle(fontSize: 7))
          ])
    ]);
  }

  // Pie de página
  static Widget buildFooter(ImageProvider firma) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image(firma, height: 15, width: 15),
        SizedBox(width: 5),
        Text('Design by LuDeveloper', style: TextStyle(fontSize: 7))
      ],
    );
  }

  static Widget totalPaid({String? label, String? value}) {
    const styleSeven = TextStyle(fontSize: 9);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 150,
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
                    width: 150,
                    child: Divider(color: PdfColors.grey200, height: 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PrintMainPlanificacionLast {
  PrintMainPlanificacionLast();

  static Future<File> generate(List<PlanificacionLast> resumen) async {
    // Cargar imágenes
    final logoImage =
        MemoryImage((await rootBundle.load(logoApp)).buffer.asUint8List());
    final firmaImage =
        MemoryImage((await rootBundle.load(firmaLu)).buffer.asUint8List());

    // Crear el documento PDF
    final pdf = Document();
    const textStyle = TextStyle(fontSize: 8);
    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      build: (context) => [
        buildHeaderInfo(logoImage),
        buildEmpresaInfo(),
        SizedBox(height: 1 * PdfPageFormat.cm / 2),
        tableProducts(resumen),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    totalPaid(
                        label: 'Total Orden', value: resumen.length.toString()),
                    totalPaid(
                        label: 'Para Entregar',
                        value: PlanificacionLast.totalOrdenEntregar(resumen)),
                    totalPaid(
                        label: 'Balance',
                        value:
                            '\$ ${getNumFormatedDouble(PlanificacionLast.getBalanceTotal(resumen))}'),
                    totalPaid(
                        label: 'Atrazos',
                        value: PlanificacionLast.getTotalAtrasada(resumen)),
                  ],
                )
              ],
            )),
      ],
      footer: (context) => buildFooter(firmaImage),
    ));

    // Guardar el documento PDF
    return PdfApi.saveDocument(name: 'reception_document.pdf', pdf: pdf);
  }

  // Información de la empresa
  static Widget buildEmpresaInfo() {
    const textStyle = TextStyle(fontSize: 7);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text('TEL: ${currentEmpresa.telefonoEmpresa ?? ''}',
              style: textStyle),
          SizedBox(width: 5),
          Text('CEL: ${currentEmpresa.celularEmpresa ?? ''}', style: textStyle),
          SizedBox(width: 5),
          Text('OFICINA: ${currentEmpresa.oficinaEmpres ?? ''}',
              style: textStyle),
        ]),
        Text('RNC: ${currentEmpresa.rncEmpresa ?? ''}', style: textStyle),
      ],
    );
  }

  static Widget tableProducts(List<PlanificacionLast> list) {
    final headers = [
      'Empleado',
      '# Orden',
      'Fichas',
      'Balance',
      'Intervención',
      'Comentarios',
      'Entregar',
      'Nombre del Logo',
      'Estado',
      'Cliente',
      'Cliente Telefono',
      'Fecha Creación',
    ];

    final data = list.map((item) {
      return [
        item.userRegistroOrden
            .toString()
            .replaceAll(RegExp(r'[\u0300-\u036f]'), ''),

        item.numOrden ?? 'N/A',
        item.ficha ?? 'N/A',
        item.balance ?? 'N/A',
        item.llamada ?? 'N/A', // Intervención
        (item.comment != null && item.comment!.length > 25)
            ? '${item.comment!.substring(0, 25)}...'
            : item.comment ?? '',
        item.fechaEntrega ?? 'N/A',
        (item.nameLogo != null && item.nameLogo!.length > 25)
            ? '${item.nameLogo!.substring(0, 25)}...'
            : item.nameLogo ?? '',
        item.statu ?? 'N/A',
        item.cliente ?? 'N/A',
        item.clienteTelefono ?? 'N/A',
        item.fechaStart ?? 'N/A',
      ];
    }).toList();

    return TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: const TableBorder(
        horizontalInside: BorderSide(color: PdfColors.grey300),
        verticalInside: BorderSide(color: PdfColors.grey300),
      ),
      tableWidth: TableWidth.max,
      headerAlignment: Alignment.centerLeft,
      cellStyle: const TextStyle(fontSize: 6),
      oddRowDecoration: const BoxDecoration(color: PdfColors.grey100),
      headerStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 7,
        color: PdfColors.white,
      ),
      headerDecoration: const BoxDecoration(color: PdfColors.blueGrey700),
    );
  }

  // Información general y logotipo
  static Widget buildHeaderInfo(ImageProvider logo) {
    return Row(children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(logo, height: 35, width: 35),
            SizedBox(width: 10),
            Text(currentEmpresa.nombreEmpresa ?? ''),
          ]),
      Spacer(),
      Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Area de Recepción', style: const TextStyle(fontSize: 12)),
            Text('Fecha: ${DateTime.now().toString().substring(0, 10)}',
                style: const TextStyle(fontSize: 7))
          ])
    ]);
  }

  // Pie de página
  static Widget buildFooter(ImageProvider firma) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image(firma, height: 15, width: 15),
        SizedBox(width: 5),
        Text('Design by LuDeveloper', style: TextStyle(fontSize: 7))
      ],
    );
  }

  static Widget totalPaid({String? label, String? value}) {
    const styleSeven = TextStyle(fontSize: 9);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 150,
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
                    width: 150,
                    child: Divider(color: PdfColors.grey200, height: 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
