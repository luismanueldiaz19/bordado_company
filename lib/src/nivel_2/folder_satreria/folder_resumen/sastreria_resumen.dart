import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '/src/datebase/current_data.dart';
import '/src/model/department.dart';
import '/src/util/commo_pallete.dart';
import '/src/widgets/picked_date_widget.dart';

import '../../../datebase/methond.dart';
import '../../../datebase/url.dart';
import '../../../screen_print_pdf/apis/pdf_api.dart';
import '../../../util/helper.dart';
import '../../folder_confecion/model/confecion.dart';
import '../print_santreria/print_resumen_sastreria.dart';
import 'grafics/widget_grafic_by_type_work.dart';
import 'grafics/widget_grafics.dart';
import 'grafics/widget_grafics_month.dart';

class ResumenSastreria extends StatefulWidget {
  const ResumenSastreria({super.key, this.currentDepartment});
  final Department? currentDepartment;

  @override
  State<ResumenSastreria> createState() => _ResumenSastreriaState();
}

class _ResumenSastreriaState extends State<ResumenSastreria> {
  String? firstDate = DateTime.now().toString().substring(0, 10);
  String? secondDate = DateTime.now().toString().substring(0, 10);

  List<Confeccion> resumenList = [];
  List<Confeccion> resumenListTotales = [];
  List<Confeccion> resumenListMonth = [];
  List<Confeccion> resumenListMonthTotal = [];
  String? messaje = 'Cargando... Espere por favor!';
  bool isLoading = true;

  Future getResumen() async {
    setState(() {
      messaje = 'Cargando... Espere por favor!';
      isLoading = true;
    });
    final res = await httpRequestDatabase(
        'http://$ipLocal/settingmat/admin/select/select_report_sastreria_resumen_week.php',
        {
          'date1': firstDate,
          'date2': secondDate,
          'id_depart': widget.currentDepartment?.id
        });

    print(' getResumen ${res.body}');
    resumenList = confeccionFromJson(res.body);
    await animarWaiting();
    setState(() {});
  }

  animarWaiting() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future getResumentotales() async {
    final res = await httpRequestDatabase(
        'http://$ipLocal/settingmat/admin/select/select_report_sastreria_resumen_week_totales.php',
        {
          'date1': firstDate,
          'date2': secondDate,
          'id_depart': widget.currentDepartment?.id
        });

    resumenListTotales = confeccionFromJson(res.body);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getResumen();
    getResumentotales();
    getResumenMonth();
    getResumenMonthTotal();
  }

  // select_report_sastreria_resumen_month_resumen

  Future getResumenMonth() async {
    final res = await httpRequestDatabase(
        'http://$ipLocal/settingmat/admin/select/select_report_sastreria_resumen_month_resumen.php',
        {
          'date1': firstDate,
          'date2': secondDate,
          'id_depart': widget.currentDepartment?.id
        });

    resumenListMonth = confeccionFromJson(res.body);
    setState(() {});
  }

  Future getResumenMonthTotal() async {
    final res = await httpRequestDatabase(
        'http://$ipLocal/settingmat/admin/select/select_report_sastreria_resumen_month_totales.php',
        {
          'date1': firstDate,
          'date2': secondDate,
          'id_depart': widget.currentDepartment?.id
        });

    resumenListMonthTotal = confeccionFromJson(res.body);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen ${widget.currentDepartment?.nameDepartment}'),
        actions: [
          resumenList.isNotEmpty
              ? IconButton(
                  onPressed: () async {
                    final pdfFile = await PdfResumeSastreria.generate(
                        resumenList, widget.currentDepartment);

                    PdfApi.openFile(pdfFile);
                  },
                  icon: const Icon(Icons.print))
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: IconButton(
                onPressed: () {
                  selectDateRange(context, (date1, date2) {
                    firstDate = date1;
                    secondDate = date2;
                    getResumen();
                    getResumentotales();
                    getResumenMonth();
                    getResumenMonthTotal();
                  });
                },
                icon: const Icon(Icons.calendar_month)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(width: double.infinity),
            resumenList.isEmpty
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DataTable(
                      dataRowMaxHeight: 20,
                      dataRowMinHeight: 15,
                      horizontalMargin: 10.0,
                      columnSpacing: 15,
                      headingRowHeight: 30,
                      headingRowColor: MaterialStateColor.resolveWith(
                        (states) => const Color.fromARGB(255, 205, 208, 221),
                      ),
                      border: TableBorder.symmetric(
                          inside: const BorderSide(color: ktejidoblueOpaco)),
                      columns: const [
                        DataColumn(label: Text('Tipo de Trabajos')),
                        DataColumn(label: Text('Cantidad de Piezas')),
                      ],
                      rows: resumenList
                          .map((item) => DataRow(
                                  color:
                                      MaterialStateProperty.all(Colors.white),
                                  cells: [
                                    DataCell(Text(item.tipoTrabajo ?? 'N/A')),
                                    DataCell(Center(
                                        child: Text(item.cantPieza ?? 'N/A'))),
                                  ]))
                          .toList(),
                    ),
                  ),
            resumenList.isEmpty
                ? const SizedBox()
                : SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        height: 35,
                        width: 250,
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Plan : ', style: style.bodySmall),
                                const SizedBox(width: 10),
                                Text(resumenList.length.toString(),
                                    style: style.bodySmall?.copyWith(
                                        color: Colors.brown,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            resumenList.isEmpty
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: SizedBox(
                        height: size.height * 0.40,
                        child: WidgetGraficByTypeWork(data: resumenList))),
            resumenList.isEmpty
                ? const SizedBox()
                : const Divider(endIndent: 50, indent: 50),
            resumenListTotales.isEmpty
                ? const SizedBox()
                : SizedBox(
                    height: size.height * 0.50,
                    width: size.width * 0.50,
                    child: ShowGraficsPromedio(data: resumenListTotales)),
            resumenListTotales.isEmpty ? const SizedBox() : const Divider(),
            resumenListMonthTotal.isEmpty
                ? const SizedBox()
                : SizedBox(
                    height: size.height * 0.50,
                    width: size.width * 0.50,
                    child:
                        ShowGraficsPromedioMonth(data: resumenListMonthTotal)),
            identy(context)
          ],
        ),
      ),
    );
  }
}
