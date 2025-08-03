import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/src/datebase/current_data.dart';
import '/src/model/department.dart';
import '/src/nivel_2/folder_confecion/model/confecion.dart';
import '/src/nivel_2/folder_satreria/add_trabajo_sastreria.dart';
import '/src/nivel_2/folder_satreria/screen_satreria.dart';
import '/src/screen_print_pdf/apis/pdf_api.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/dialog_confimarcion.dart';
import '/src/util/get_time_relation.dart';
import '/src/util/helper.dart';
import '/src/util/show_mesenger.dart';
import '/src/widgets/loading.dart';
import '/src/widgets/widget_comentario.dart';
import '../../util/get_formatted_number.dart';
import '../../widgets/picked_date_widget.dart';
import 'folder_resumen/sastreria_resumen.dart';
import 'print_santreria/print_main_sastreria.dart';
import 'provider/provider_sastreria.dart';

class ScreenSastreriaReport extends StatefulWidget {
  const ScreenSastreriaReport({super.key, this.current});
  final Department? current;

  @override
  State<ScreenSastreriaReport> createState() => _ScreenSastreriaReportState();
}

class _ScreenSastreriaReportState extends State<ScreenSastreriaReport> {
  String? _secondDate = DateTime.now().toString().substring(0, 10);
  String? _firstDate = DateTime.now().toString().substring(0, 10);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProviderSastreria>(context, listen: false)
          .getWork(_firstDate, _secondDate, widget.current?.id);
    });
  }

  cantFinished(contexto, Confeccion item) async {
    String? valueCant = await showDialog<String>(
        context: context,
        builder: (context) {
          return AddComentario(
            text: 'Qty Realizada',
            textInputType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
            ],
            textFielName: 'Qty : ',
          );
        });

    if (valueCant != null) {
      item.cantPieza = valueCant;
      item.dateEnd = DateTime.now().toString().substring(0, 19);
      Provider.of<ProviderSastreria>(contexto, listen: false)
          .updateCantAndFinish(
              item, _firstDate, _secondDate, widget.current?.id);
    }
  }

  updateComentario(contexto, Confeccion item) async {
    String? valueCant = await showDialog<String>(
        context: context,
        builder: (context) {
          return const AddComentario(
            text: 'Poner',
            textInputType: TextInputType.text,
            textFielName: 'Nota',
          );
        });

    if (valueCant != null) {
      item.comment = valueCant;
      // item.dateEnd = DateTime.now().toString().substring(0, 19);
      // Provider.of<ProviderSastreria>(contexto, listen: false)
      //     .updateCantAndFinish(item, _firstDate, _secondDate);
    }
  }

  deleteFrom(Confeccion item) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmacionDialog(
          mensaje: '❌❌Esta Seguro de Eliminar❌❌',
          titulo: 'Aviso',
          onConfirmar: () async {
            //deleteFrom
            Provider.of<ProviderSastreria>(context, listen: false)
                .deleteFrom(item, _firstDate, _secondDate, widget.current?.id);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final providerList = Provider.of<ProviderSastreria>(context, listen: true);
    final providerData = Provider.of<ProviderSastreria>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.current?.nameDepartment ?? 'N/A'),
        actions: [
          IconButton(
              onPressed: () {
                selectDateRange(context, (date1, date2) {
                  _firstDate = date1;
                  _secondDate = date2;
                  providerData.getWork(
                      _firstDate, _secondDate, widget.current?.id);
                });
              },
              icon: const Icon(Icons.calendar_month)),
          IconButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddTrabajoSastreria(current: widget.current)));
              },
              icon: const Icon(Icons.add_box_outlined)),
          currentUsers?.occupation == OptionAdmin.master.name ||
                  currentUsers?.id == '30' ||
                  currentUsers?.id == '33' ||
                  currentUsers?.id == '31'
              ? IconButton(
                  onPressed: () async {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScreenSatreria(
                                    currentDepart: widget.current)))
                        .then((value) => {});
                    ;
                  },
                  icon: const Icon(Icons.event))
              : const SizedBox(),
          providerList.listFilter.isNotEmpty
              ? IconButton(
                  onPressed: () async {
                    final pdfFile = await PdfMainReportSastreria.generate(
                        providerList.listFilter, widget.current);

                    PdfApi.openFile(pdfFile);
                  },
                  icon: const Icon(Icons.print))
              : const SizedBox(),
          const SizedBox(width: 15)
        ],
      ),
      body: Column(
        children: [
          const SizedBox(width: double.infinity, height: 5),
          Container(
            width: 250,
            color: Colors.white,
            child: TextField(
              onChanged: (val) => providerData.searching(val),
              decoration: const InputDecoration(
                hintText: 'Buscar',
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15, top: 10),
                suffixIcon: Tooltip(
                  message: 'Buscar /Ficha/Orden',
                ),
              ),
            ),
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Quiere ver los trabajos terminado?',
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResumenSastreria(
                                      currentDepartment: widget.current)));
                        },
                        child: const Text('Resumen Aqui!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: ktejidoBlueOcuro)))
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          providerList.listFilter.isEmpty
              ? Expanded(
                  child: Loading(
                      text: providerData.messaje ?? 'No hay datos',
                      isLoading: providerData.isLoading))
              : Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 15),
                    child: SizedBox(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          child: DataTable(
                            dataRowMaxHeight: 20,
                            dataRowMinHeight: 15,
                            horizontalMargin: 10.0,
                            columnSpacing: 15,
                            headingRowHeight: 20,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 205, 208, 221),
                                  Color.fromARGB(255, 225, 228, 241),
                                  Color.fromARGB(255, 233, 234, 238),
                                ],
                              ),
                            ),
                            border: TableBorder.symmetric(
                                inside: const BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.grey)),
                            // dataTextStyle: style.bodySmall,
                            // headingTextStyle: style.bodyMedium,
                            columns: const [
                              DataColumn(label: Text('# Orden')),
                              DataColumn(label: Text('Ficha')),
                              DataColumn(label: Text('Nombre Logo')),
                              DataColumn(label: Text('Tipo Trabajo')),
                              DataColumn(label: Text('Qty')),
                              DataColumn(label: Text('Comenzó')),
                              DataColumn(label: Text('Terminó')),
                              DataColumn(label: Text('Tiempo')),
                              DataColumn(label: Text('Nota')),
                              DataColumn(label: Text('Registrado Por')),
                              DataColumn(label: Text('Action')),
                            ],
                            rows: providerList.listFilter
                                .map((item) => DataRow(
                                        color:
                                            MaterialStateProperty.resolveWith(
                                                (states) => Colors.white),
                                        cells: [
                                          DataCell(
                                              Text(item.numOrden ?? 'N/A')),
                                          DataCell(Text(item.ficha ?? 'N/A')),
                                          DataCell(
                                              Text(item.nameLogo ?? 'N/A')),
                                          DataCell(
                                              Text(item.tipoTrabajo ?? 'N/A')),
                                          DataCell(
                                              Center(
                                                  child: Text(Confeccion
                                                          .getValidatorCant(
                                                              item)
                                                      ? item.cantPieza ?? 'N/A'
                                                      : 'Reportar')),
                                              onTap:
                                                  Confeccion.getValidatorCant(
                                                          item)
                                                      ? null
                                                      : () => cantFinished(
                                                          context, item)),
                                          DataCell(
                                              Text(item.dateStart ?? 'N/A')),
                                          DataCell(Text(item.dateEnd ?? 'N/A')),
                                          DataCell(Text(getTimeRelation(
                                              item.dateStart ?? 'N/A',
                                              item.dateEnd ?? 'N/A'))),
                                          DataCell(
                                              Tooltip(
                                                  message:
                                                      'Double Click! Poner Nota',
                                                  child: Text(
                                                      item.comment ?? 'N/A')),
                                              onDoubleTap: () {
                                            updateComentario(context, item);
                                          }, onTap: () {
                                            getMensajeWidget(
                                                context, item.comment ?? 'N/A',
                                                text: 'Nota');
                                          }),
                                          DataCell(
                                              Text(item.fullName ?? 'N/A')),
                                          DataCell(
                                              Text(
                                                  validarSupervisor() ||
                                                          validarMySelf(
                                                              item.fullName ??
                                                                  'N/A')
                                                      ? 'Eliminar'
                                                      : 'Not Suport',
                                                  style: const TextStyle(
                                                      color: Colors.red)),
                                              onTap: validarSupervisor() ||
                                                      validarMySelf(
                                                          item.fullName ??
                                                              'N/A')
                                                  ? () => deleteFrom(item)
                                                  : null)
                                        ]))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          providerList.listFilter.isEmpty
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SizedBox(
                    height: 35,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            height: 35,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Total Trabajos : ',
                                        style: style.bodySmall),
                                    const SizedBox(width: 10),
                                    Text(
                                      providerList.listFilter.length.toString(),
                                      style: style.bodySmall?.copyWith(
                                          color: ktejidoBlueOcuro,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 35,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Qty. : ', style: style.bodySmall),
                                    const SizedBox(width: 10),
                                    Text(
                                        getNumFormatedDouble(
                                            Confeccion.getTotalListPiezas(
                                                providerList.listFilter)),
                                        style: style.bodySmall?.copyWith(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 35,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Total Tiempo : ',
                                        style: style.bodySmall),
                                    const SizedBox(width: 10),
                                    Text(
                                        Confeccion.getTimeR(
                                            providerList.listFilter),
                                        style: style.bodySmall?.copyWith(
                                            color: ktejidoBlueOcuro,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          identy(context)
        ],
      ),
    );
  }
}

String diferentTime(Confeccion current) {
  Duration? diferences;
  DateTime date1 =
      DateTime.parse(current.dateStart.toString().substring(0, 19));
  DateTime date2 = DateTime.parse(current.dateEnd.toString().substring(0, 19));
  diferences = date2.difference(date1);

  return diferences.toString();
}
