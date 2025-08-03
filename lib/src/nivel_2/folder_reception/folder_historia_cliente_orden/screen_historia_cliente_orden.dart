import 'package:flutter/material.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/url.dart';
import '/src/util/show_mesenger.dart';
import '/src/widgets/loading.dart';

import '../../../datebase/methond.dart';
import '../../folder_planificacion/model_planificacion/planificacion_last.dart';

class ScreenHistoriaClienteOrden extends StatefulWidget {
  const ScreenHistoriaClienteOrden({super.key, required this.client});
  final String client;
  @override
  State<ScreenHistoriaClienteOrden> createState() =>
      _ScreenHistoriaClienteOrdenState();
}

class _ScreenHistoriaClienteOrdenState
    extends State<ScreenHistoriaClienteOrden> {
  List<PlanificacionLast> planificacionList = [];
  List<PlanificacionLast> planificacionListFilter = [];
  Future getReorden() async {
    print('Cliente  ${widget.client}');
    final res = await httpRequestDatabase(
        selectOrdenClientes, {'token': token, 'client': widget.client});

    print(res.body);
    planificacionList = planificacionLastFromJson(res.body);
    planificacionListFilter = planificacionList;
    setState(() {});
    // await Future.delayed(const Duration(seconds: 2));

    // if (res.body != '') {
    //   if (!mounted) {
    //     return;
    //   }
    //   if (listReOrden.isNotEmpty) {
    //     await showDialog(
    //         context: context,
    //         builder: (context) {
    //           return DialogReOrden(listReOrden: listReOrden);
    //         });
    //   }
    // }
  }

  @override
  void initState() {
    getReorden();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial Ordenes Cliente')),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          planificacionListFilter.isEmpty
              ? const Expanded(child: Loading(text: 'Cargando'))
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: DataTable(
                          dataRowMaxHeight: 30,
                          dataRowMinHeight: 20,
                          horizontalMargin: 10.0,
                          columnSpacing: 15,
                          columns: const [
                            DataColumn(label: Text('Clientes')),
                            DataColumn(label: Text('Empleado')),
                            DataColumn(label: Text('Orden')),
                            DataColumn(label: Text('Ficha')),
                            DataColumn(label: Text('Logo')),
                            DataColumn(label: Text('comentario')),
                            DataColumn(label: Text('Entrega')),
                            DataColumn(label: Text('Creado En')),
                          ],
                          rows: planificacionListFilter
                              .map((item) => DataRow(cells: [
                                    DataCell(Text(item.cliente ?? 'N/A')),
                                    DataCell(
                                        Text(item.userRegistroOrden ?? 'N/A')),
                                    DataCell(Text(item.numOrden ?? 'N/A')),
                                    DataCell(
                                        SizedBox(
                                            width: 75,
                                            child: Text(item.ficha ?? 'N/A',
                                                maxLines: 1)), onTap: () {
                                      getMensajeWidget(
                                          context, item.ficha ?? 'N/A');
                                    }),
                                    DataCell(
                                        SizedBox(
                                            width: 150,
                                            child: Text(item.nameLogo ?? 'N/A',
                                                maxLines: 1)), onTap: () {
                                      getMensajeWidget(
                                          context, item.nameLogo ?? 'N/A');
                                    }),
                                    DataCell(
                                        SizedBox(
                                            width: 250,
                                            child: Text(item.comment ?? 'N/A',
                                                maxLines: 1)), onTap: () {
                                      getMensajeWidget(
                                          context, item.comment ?? 'N/A');
                                    }),
                                    DataCell(Text(item.fechaEntrega ?? 'N/A')),
                                    DataCell(Text(item.fechaStart ?? 'N/A')),
                                  ]))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 35,
                width: 250,
                decoration: const BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Total  Ordenes : '),
                        const SizedBox(width: 15),
                        Text('${planificacionListFilter.length}',
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          identy(context),
        ],
      ),
    );
  }
}
