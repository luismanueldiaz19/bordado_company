import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/nivel_2/folder_planificacion/model_planificacion/planificacion_last.dart';
import '/src/nivel_2/folder_reception/seguimiento_orden.dart';
import '/src/util/show_mesenger.dart';

class CustomSearchDelegate extends SearchDelegate<List<PlanificacionLast>> {
  // Cambiar el texto del campo de búsqueda
  @override
  String get searchFieldLabel =>
      'Número de orden'; // Cambiar el texto del campo de búsqueda

  TextField buildTextField(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number, // Configurar teclado para números
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly, // Restringir a números
      ],
      textInputAction: TextInputAction.search,
      style: const TextStyle(fontSize: 10),
      // style: Theme.of(context).textTheme.bodySmall,

      decoration: const InputDecoration(
          hintText: 'numero de orden', // Cambiar el hintText
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          hintStyle: TextStyle(fontSize: 10)),
      onSubmitted: (String value) {
        close(context, []);
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      cardColor: Theme.of(context).scaffoldBackgroundColor,
      appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context)
            .scaffoldBackgroundColor, // Cambia este color al que desees
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Ingresa un término de búsqueda'),
      );
    } else {
      return FutureBuilder<List<PlanificacionLast>>(
        future: searchOnServer(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No se encontraron resultados'),
            );
          } else {
            final List<PlanificacionLast> results = snapshot.data!;
            return SizedBox(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
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
                            style: BorderStyle.solid, color: Colors.grey)),
                    columns: const [
                      DataColumn(label: Text('Seguimiento')),
                      DataColumn(label: Text('Registro')),
                      DataColumn(label: Text('Numero Orden')),
                      DataColumn(label: Text('Fichas')),
                      DataColumn(label: Text('Comentarios')),
                      DataColumn(label: Text('Logo')),
                      DataColumn(label: Text('Estado')),
                      DataColumn(label: Text('Cliente')),
                      DataColumn(label: Text('Cliente Telefono')),
                      DataColumn(label: Text('Fecha Creación')),
                      DataColumn(label: Text('Fecha de entrega')),
                    ],
                    rows: results
                        .map(
                          (item) => DataRow(
                            color: MaterialStateProperty.resolveWith(
                                (states) => PlanificacionLast.getColor(item)),
                            cells: [
                              DataCell(TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (conext) =>
                                              SeguimientoOrden(item: item)));
                                },
                                child: const Text('CLICK!'),
                              )),
                              DataCell(Text(item.userRegistroOrden ?? '')),
                              DataCell(
                                Row(
                                  children: [
                                    Text(item.numOrden ?? '',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis)),
                                  ],
                                ),
                              ),
                              DataCell(
                                  SizedBox(
                                    width: 50,
                                    child: Text(item.ficha ?? '',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis)),
                                  ), onTap: () {
                                utilShowMesenger(context, item.ficha ?? '',
                                    title: 'Ficha');
                              }),
                              DataCell(
                                SizedBox(
                                  width: 50,
                                  child: Text(item.comment ?? '',
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis)),
                                ),
                                onTap: () {
                                  utilShowMesenger(context, item.comment ?? '',
                                      title: 'Comentarios');
                                },
                              ),
                              DataCell(
                                  SizedBox(
                                    width: 75,
                                    child: Text(
                                      item.nameLogo ?? '',
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ), onTap: () {
                                utilShowMesenger(context, item.nameLogo ?? '',
                                    title: 'LOGO');
                              }),
                              DataCell(Text(item.statu ?? '')),
                              DataCell(
                                SizedBox(
                                  width: 70,
                                  child: Text(item.cliente ?? '',
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis)),
                                ),
                                onTap: () {
                                  utilShowMesenger(context, item.cliente ?? '',
                                      title: 'CLIENTE');
                                },
                              ),
                              DataCell(Text(item.clienteTelefono ?? '')),
                              DataCell(Text(item.fechaStart ?? '')),
                              DataCell(
                                Text(
                                  item.fechaEntrega ?? '',
                                  style: TextStyle(
                                      color: item.statu?.toLowerCase() !=
                                              onEntregar.toLowerCase()
                                          ? comparaTime(DateTime.parse(
                                                  item.fechaEntrega ?? ''))
                                              ? Colors.black
                                              : Colors.red
                                          : Colors.black,
                                      fontWeight: item.statu?.toLowerCase() !=
                                              onEntregar.toLowerCase()
                                          ? comparaTime(DateTime.parse(
                                                  item.fechaEntrega ?? ''))
                                              ? FontWeight.normal
                                              : FontWeight.bold
                                          : FontWeight.normal),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            );

            // ListView.builder(
            //   itemCount: results.length,
            //   itemBuilder: (context, index) {
            //     return ListTile(
            //       title:
            //           Text(results[index].numOrden.toString()), // Ajusta esto
            //     );
            //   },
            // );
          }
        },
      );
    }
  }

  bool comparaTime(DateTime time1) {
    // Creamos las dos fechas a comparar
    DateTime fecha2 = DateTime.now();
    DateTime soloFecha = DateTime(fecha2.year, fecha2.month, fecha2.day - 1);
    if (soloFecha.isBefore(time1)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Container(
        margin: const EdgeInsets.only(top: 10, right: 25),
        child: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, []);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Ingresa el numero de orden'),
    );
  }
}

Future<List<PlanificacionLast>> searchOnServer(String query) async {
  String url =
      "http://$ipLocal/settingmat/admin/select/select_planificacion_last_unique_orden.php";
  final res = await httpRequestDatabase(url, {'num_orden': query});
  List<PlanificacionLast> listPlanificacion =
      planificacionLastFromJson(res.body);
  return listPlanificacion;
}
