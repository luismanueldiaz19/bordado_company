import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/util/commo_pallete.dart';

import '../../../datebase/url.dart';
import '../../../util/dialog_confimarcion.dart';
import '../../../util/get_time_relation.dart';
import '../../../util/show_mesenger.dart';
import '../model/report_bordado_tirada.dart';
import '../database_bordado/url_bordado.dart';

class SearchingOrdenBordado extends StatefulWidget {
  const SearchingOrdenBordado({super.key});

  @override
  State<SearchingOrdenBordado> createState() => _SearchingOrdenBordadoState();
}

class _SearchingOrdenBordadoState extends State<SearchingOrdenBordado> {
  bool isEmptyLoading = false;
  String opcion = 'orden';
  TextEditingController controller = TextEditingController();
  List<BordadoReportTiradas> listTiradas = [];

  searchingItem() async {
    if (controller.text.isEmpty) {
      return;
    }

    String url =
        "http://$ipLocal/settingmat/admin/select/select_bordado_tiradas_filtro_busqueda.php";
    waitingAnimacion();
    final res = await httpRequestDatabase(
        url, {'opcion': opcion, 'value': controller.text});

    listTiradas = bordadoReportTiradasFromJson(res.body);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  waitingAnimacion() async {
    setState(() {
      isEmptyLoading = !isEmptyLoading;
    });
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      isEmptyLoading = !isEmptyLoading;
    });
  }

  Future eliminarBordadoReport(id) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmacionDialog(
          mensaje: '❌ Esta Seguro de Eliminar ❌',
          titulo: 'Aviso',
          onConfirmar: () async {
            Navigator.of(context).pop();
            await httpRequestDatabase(
                deleteBordadoReportedGeneral, {'id': '$id'});
            listTiradas!.removeWhere((item) => item.id == id);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: const Color(0xfffbfbfb),
      appBar: AppBar(title: const Text('Buscar Trabajos Bordado')),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          BounceInDown(
            child: Text('Te puedo ayudar a buscar Algo ?',
                style: style.headlineSmall?.copyWith(color: ktejidoBlueOcuro),
                textAlign: TextAlign.center),
          ),
          Text('¡Te brindo estas opciones de búsqueda!',
              style: style.labelMedium, textAlign: TextAlign.center),
          CheckBoxGroup(
            onChanged: (Opcion valor) {
              // print('Valor seleccionado: $valor');
              opcion = valor.name;
              // print('$opcion');
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FadeIn(
              duration: const Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8)),
                width: 250,
                child: TextField(
                  textInputAction: TextInputAction.done,
                  controller: controller,
                  onEditingComplete: () => searchingItem(),
                  decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(top: 2, right: 10),
                        child: IconButton(
                            onPressed: () => searchingItem(),
                            icon: const Icon(Icons.search)),
                      ),
                      border: InputBorder.none,
                      labelText: 'Escribir tu busqueda!',
                      hintStyle: const TextStyle(color: ktejidoBlueOcuro),
                      labelStyle: const TextStyle(color: ktejidoBlueOcuro),
                      contentPadding: const EdgeInsets.only(left: 10)),
                ),
              ),
            ),
          ),
          isEmptyLoading
              ? Expanded(
                  child: Column(
                  children: [
                    Image.asset('assets/buscar.gif', scale: 4),
                    Text('Buscando ... Espere',
                        style: style.titleMedium
                            ?.copyWith(color: ktejidoBlueOcuro))
                  ],
                ))
              : listTiradas.isNotEmpty
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 20),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            child: DataTable(
                              dataRowMaxHeight: 20,
                              dataRowMinHeight: 15,
                              headingRowColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => Colors.blue.shade100),
                              headingRowHeight: 20,
                              border: TableBorder.symmetric(
                                  inside: const BorderSide(color: Colors.grey)),
                              headingTextStyle: style.labelLarge,
                              dataTextStyle: style.bodyMedium,
                              columns: const [
                                DataColumn(label: Text('Maquina')),
                                DataColumn(label: Text('Empleado')),
                                DataColumn(label: Text('#Orden / Fichas')),
                                DataColumn(label: Text('Logo')),
                                DataColumn(label: Text('Cant Orden')),
                                DataColumn(label: Text('Elaborado')),
                                DataColumn(label: Text('C.Malo')),
                                DataColumn(label: Text('Started')),
                                DataColumn(label: Text('End')),
                                DataColumn(label: Text('Timer')),
                                DataColumn(label: Text('Eliminar')),
                              ],
                              rows: listTiradas!
                                  .map(
                                    (item) => DataRow(
                                      color: MaterialStateProperty.resolveWith(
                                          (states) =>
                                              BordadoReportTiradas.getColor(
                                                  item)),
                                      cells: [
                                        DataCell(Text(item.machine ?? '')),
                                        DataCell(Text(item.fullName ?? 'N/A')),
                                        DataCell(Center(
                                          child: Text(
                                              '${item.numOrden ?? ''} - ${item.ficha ?? ''}'),
                                        )),

                                        DataCell(
                                            Text(
                                              item.nameLogo ?? '',
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                            ), onTap: () {
                                          utilShowMesenger(
                                              context, item.nameLogo ?? '',
                                              title: 'LOGO');
                                        }),
                                        DataCell(Center(
                                            child: Text(item.cantOrden ?? ''))),
                                        DataCell(Center(
                                            child:
                                                Text(item.cantElabored ?? ''))),
                                        DataCell(
                                          BordadoReportTiradas.getValidarMalos(
                                                  item)
                                              ? Container(
                                                  alignment: Alignment.center,
                                                  // margin: EdgeInsets.all(2),
                                                  // padding: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2),
                                                      color: Colors.red),
                                                  child: Text(
                                                      item.cantBad ?? '0',
                                                      style: const TextStyle(
                                                          color: Colors.white)),
                                                )
                                              : Center(
                                                  child: Text(
                                                      item.cantBad ?? '0')),
                                        ),
                                        DataCell(Text(item.fechaStarted ?? '')),
                                        DataCell(Text(item.fechaEnd ?? '')),
                                        DataCell(Text(getTimeRelation(
                                            item.fechaStarted ?? 'N/A',
                                            item.fechaEnd ?? 'N/A'))),

                                        // DataCell(Row(
                                        //   children: [
                                        //     Text(item.puntada ?? ''),
                                        //     const Text('--'),
                                        //     Text(item.veloz ?? '')
                                        //   ],
                                        // )),
                                        // DataCell(
                                        //     SizedBox(
                                        //       width: 50,
                                        //       child: Text(item.comment ?? '',
                                        //           style: const TextStyle(
                                        //               overflow:
                                        //                   TextOverflow.ellipsis)),
                                        //     ), onTap: () {
                                        //   utilShowMesenger(
                                        //       context, item.comment ?? '',
                                        //       title: 'Comentarios');
                                        // }),
                                        DataCell(
                                            Text(validatorUser()
                                                ? 'Eliminar'
                                                : 'Not Support'),
                                            onTap: validatorUser()
                                                ? () => eliminarBordadoReport(
                                                    item.id)
                                                : null),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ZoomIn(
                          child: Image.asset('assets/gif_icon.gif', scale: 2))),
          identy(context)
        ],
      ),
    );
  }
}

enum Opcion { orden, ficha, logo }

class CheckBoxGroup extends StatefulWidget {
  final void Function(Opcion) onChanged;

  const CheckBoxGroup({Key? key, required this.onChanged}) : super(key: key);

  @override
  State<CheckBoxGroup> createState() => _CheckBoxGroupState();
}

class _CheckBoxGroupState extends State<CheckBoxGroup> {
  late Opcion _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = Opcion.orden; // Inicializar con el primer valor del enum
    widget.onChanged(
        _selectedOption); // Llamar a la función de devolución de llamada al inicializar
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          value: Opcion.orden,
          groupValue: _selectedOption,
          onChanged: (Opcion? value) {
            setState(() {
              _selectedOption = value!;
              widget.onChanged(
                  _selectedOption); // Llamar a la función de devolución de llamada
            });
          },
        ),
        const Text('Orden'),
        Radio(
          value: Opcion.ficha,
          groupValue: _selectedOption,
          onChanged: (Opcion? value) {
            setState(() {
              _selectedOption = value!;
              widget.onChanged(
                  _selectedOption); // Llamar a la función de devolución de llamada
            });
          },
        ),
        const Text('Ficha'),
        Radio(
          value: Opcion.logo,
          groupValue: _selectedOption,
          onChanged: (Opcion? value) {
            setState(() {
              _selectedOption = value!;
              widget.onChanged(
                  _selectedOption); // Llamar a la función de devolución de llamada
            });
          },
        ),
        const Text('Logo'),
      ],
    );
  }
}
