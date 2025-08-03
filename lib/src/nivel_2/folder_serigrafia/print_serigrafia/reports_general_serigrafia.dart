import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import '/src/datebase/current_data.dart';
import '/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
import '/src/screen_print_pdf/apis/pdf_api.dart';
// import 'package:settingmat/src/screen_print_pdf/model/customer.dart';

class PdfReportsGeneralSerigrafia {
  static Future<File> generate(
      List<List<String>> tableData,
      totalTipoTrabajos,
      String fecha,
      List<List<String>> tableDataFullPintado,
      List<List<String>> tableDataPKTPintado,
      List<List<String>> tableDataFullCuadrar,
      List<List<String>> tableDataPKTCuadrar) async {
    final pdf = Document();
    final imageLogo2 =
        MemoryImage((await rootBundle.load(logoApp)).buffer.asUint8List());
    const style = TextStyle(fontSize: 8);
    pdf.addPage(
      MultiPage(
        build: (context) => [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    Text('RNC : ${currentEmpresa.rncEmpresa ?? ''}',
                        style: style),
                    // Text('DESPACHADOR /A : ${currentUser?.fullName ?? ''}',
                    //         style: style),
                    Text('Imprimido Por : ${currentUsers!.fullName ?? ''}',
                        style: style),
                    Text('Fecha : $fecha',
                        style: style.copyWith(color: PdfColors.black)),
                  ],
                ),
                Image(imageLogo2, height: 75, width: 75),
              ]),
            ],
          ),

          SizedBox(height: 1 * PdfPageFormat.cm / 3),

          Text('Produción Serigrafia',
              style: style.copyWith(color: PdfColors.black)),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          buildTable(tableData),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
          // buildTitle('Empleados destacados'),
          buildTableTotal(totalTipoTrabajos),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
          Text('Produción de colores full en pintado',
              style: style.copyWith(color: PdfColors.black)),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
          buildTablePiezas(tableDataFullPintado),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
          Text('Produción de colores pkt en pintado',
              style: style.copyWith(color: PdfColors.black)),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
          buildTablePiezas(tableDataPKTPintado),

          ///---------------------------------------////
          SizedBox(height: 0.3 * PdfPageFormat.cm),
          Text('Produción de colores full en cuadrar Marcos',
              style: style.copyWith(color: PdfColors.black)),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
          buildTablePiezas(tableDataFullCuadrar),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
          Text('Produción de colores full en cuadrar Marcos',
              style: style.copyWith(color: PdfColors.black)),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
          buildTablePiezas(tableDataPKTCuadrar),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
        ],
        footer: (context) => buildFooter(),
      ),
    );
    return PdfApi.saveDocument(
        name:
            'Resumen_Serigrafia_${DateTime.now().toString().substring(0, 10)}.pdf',
        pdf: pdf);
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

      border: const TableBorder(
        // top: BorderSide(color: PdfColors.brown),
        horizontalInside: BorderSide(color: PdfColors.brown100),
      ),
      tableWidth: TableWidth.max,
      cellStyle: const TextStyle(fontSize: 7),
      headerStyle: TextStyle(fontSize: 6, fontWeight: FontWeight.bold),
      cellAlignment: Alignment.topLeft,
      headerAlignment: Alignment.topLeft,
      headerDecoration: const BoxDecoration(color: PdfColors.grey100),
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
      border: const TableBorder(
        // top: BorderSide(color: PdfColors.brown),
        horizontalInside: BorderSide(color: PdfColors.brown100),
      ),
      tableWidth: TableWidth.max,
      cellStyle: const TextStyle(fontSize: 7),
      headerStyle: TextStyle(fontSize: 6, fontWeight: FontWeight.bold),
      cellAlignment: Alignment.topLeft,
      headerAlignment: Alignment.topLeft,
      headerDecoration: const BoxDecoration(color: PdfColors.grey100),
    );
  }

  //////////////table de la lista de tipo de tabajopor nombre de usuarios////////
  static Widget buildTableTotal(List<Sublima> totalTipoTrabajos) {
    return Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: 10,
        children: totalTipoTrabajos
            .map((e) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Container(
                      color: PdfColors.grey100,
                      width: 100,
                      padding: const EdgeInsets.all(6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(e.typeWork ?? 'N/A',
                              style: const TextStyle(fontSize: 6)),
                          SizedBox(width: 10),
                          Text(
                            e.toTalDiferences ?? 'N/A',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 6,
                                color: PdfColors.black),
                          )
                        ],
                      )),
                ))
            .toList());
  }

///////////////final de la pagina mi nombre de desarrollo ////////////
  static Widget buildFooter() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          Row(children: [Text('LuDeveloper')])
        ],
      );
}
