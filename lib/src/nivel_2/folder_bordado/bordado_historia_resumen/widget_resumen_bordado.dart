import 'package:flutter/material.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/get_formatted_number.dart';
import '../model/bordado_resumen.dart';

class WidgetResumenBordado extends StatefulWidget {
  const WidgetResumenBordado({super.key, required this.groupedItemsFilter});
  final Map<String, List<BordadoResumen>> groupedItemsFilter;

  @override
  State<WidgetResumenBordado> createState() => _WidgetResumenBordadoState();
}

class _WidgetResumenBordadoState extends State<WidgetResumenBordado> {
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return ListView.builder(
      itemCount: widget.groupedItemsFilter.length,
      itemBuilder: (context, index) {
        final idKey = widget.groupedItemsFilter.keys.elementAt(index);
        final items = widget.groupedItemsFilter[idKey]!;
        // Crear el DataTable para los elementos de la factura
        final dataTable = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(bottom: 25),
          child: DataTable(
            dataTextStyle: const TextStyle(fontSize: 10, color: Colors.black),
            headingTextStyle:
                const TextStyle(fontSize: 10, color: Colors.black),
            dataRowMaxHeight: 20,
            dataRowMinHeight: 15,
            columnSpacing: 25,
            columns: const [
              DataColumn(label: Text('COLABORADOR')),
              DataColumn(label: Text('TIRADAS')),
              DataColumn(label: Text('PIEZA')),
              DataColumn(label: Text('PUNTADAS')),
              DataColumn(label: Text('MALA')),
              DataColumn(label: Text('TIEMPOS')),
            ],
            rows: items.map((item) {
              return DataRow(cells: [
                DataCell(Text(item.empleado ?? 'N/A')),
                DataCell(Text(item.tiradas ?? 'N/A')),
                DataCell(Text(item.pieza ?? 'N/A')),
                DataCell(Text(getNumFormatedDouble(item.puntada ?? 'N/A'))),
                DataCell(Text(item.piezaMala ?? 'N/A')),
                DataCell(Text(item.time ?? 'N/A')),
              ]);
            }).toList(),
          ),
        );
        var cantPieza = BordadoResumen.calcularTotalPieza(items);
        // var cantPiezaMala = BordadoResumen.calcularTotalMala(items);
        var cantPuntada = BordadoResumen.calcularTotalPuntada(items);
        var cantTiempo = BordadoResumen.getTimeR(items);
        var cantMala = BordadoResumen.calcularTotalMala(items);
        return Container(
          color: Colors.white,
          margin: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 5),
              Text('MAQUINA : ${items[0].maquina}',
                  style: style.bodySmall?.copyWith(
                      color: colorsBlueDeepHigh, fontWeight: FontWeight.bold)),
              dataTable,
              Padding(
                padding: const EdgeInsets.only(bottom: 15, top: 1),
                child: SizedBox(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          color: Colors.grey.shade100,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text('Pieza : $cantPieza'),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          color: Colors.grey.shade100,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text('Mala : $cantMala'),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          color: Colors.grey.shade100,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                              'Puntada : ${getNumFormatedDouble(cantPuntada.toString())}'),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          color: Colors.grey.shade100,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                              'tiempo : ${cantTiempo.toString().substring(0, 8)}'),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
