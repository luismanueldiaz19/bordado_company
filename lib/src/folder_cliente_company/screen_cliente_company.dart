import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/src/datebase/current_data.dart';
import '/src/folder_cliente_company/add_cliente.dart';
import '/src/folder_cliente_company/detalles_cliente.dart';
import '/src/folder_cliente_company/provider_clientes/provider_clientes.dart';
import '/src/util/commo_pallete.dart';

import '../util/helper.dart';
import '../util/show_mesenger.dart';

class ScreenClientes extends StatefulWidget {
  const ScreenClientes({super.key});

  @override
  State<ScreenClientes> createState() => _ScreenClientesState();
}

class _ScreenClientesState extends State<ScreenClientes> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ClienteProvider>(context, listen: false).getCliente();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final listClient =
        Provider.of<ClienteProvider>(context, listen: true).listClientsFilter;
    final provider = Provider.of<ClienteProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes $nameApp'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (conext) => const AddClientForm(),
                    ),
                  );
                },
                icon: const Icon(Icons.add)),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          SlideInLeft(
            curve: Curves.elasticInOut,
            child: buildTextFieldValidator(
              onChanged: (val) => provider.buscarCliente(val),
              hintText: 'Escribir Algo!',
              label: 'Buscar',
            ),
          ),
          listClient.isEmpty
              ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BounceInDown(
                        curve: Curves.elasticInOut,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child:
                                Image.asset('assets/no_find.jpg', scale: 10)),
                      ),
                      const SizedBox(height: 10),
                      SlideInLeft(
                        curve: Curves.elasticInOut,
                        child: const Text('No hay datos..',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(25),
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
                          decoration: const BoxDecoration(color: colorsOrange),
                          headingTextStyle:
                              const TextStyle(color: Colors.white),
                          border: TableBorder.symmetric(
                              outside: BorderSide(
                                  color: Colors.grey.shade100,
                                  style: BorderStyle.none),
                              inside: const BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.grey)),
                          columns: const [
                            DataColumn(label: Text('ACTION')),
                            DataColumn(label: Text('NOMBRES')),
                            DataColumn(label: Text('APELLIDOS')),
                            DataColumn(label: Text('DIRECCIONES')),
                            DataColumn(label: Text('TELEFONOS')),
                            DataColumn(label: Text('INFORMACIONES')),
                          ],
                          rows: listClient.asMap().entries.map((entry) {
                            int index = entry.key;
                            var item = entry.value;
                            return DataRow(
                              color: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  // Alterna el color de fondo entre gris y blanco
                                  if (index.isOdd) {
                                    return Colors.grey
                                        .shade300; // Color de fondo gris para filas impares
                                  }
                                  return Colors
                                      .white; // Color de fondo blanco para filas pares
                                },
                              ),
                              cells: [
                                DataCell(
                                    const Text('Click !',
                                        style: TextStyle(color: Colors.blue)),
                                    onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetallesCliente(item: item)),
                                  );
                                }),
                                DataCell(
                                    Tooltip(
                                        message: item.idCliente ?? 'N/A',
                                        child: Text(item.nombre != null &&
                                                item.nombre!.length > 25
                                            ? '${item.nombre!.substring(0, 25)}...'
                                            : item.nombre ?? '')),
                                    onTap: () => utilShowMesenger(
                                        context, item.nombre ?? '',
                                        title: 'Nombre')),
                                DataCell(Text(item.apellido ?? 'N/A')),
                                DataCell(Text(item.direccion ?? 'N/A')),
                                DataCell(Text(item.telefono ?? 'N/A')),
                                DataCell(Text(item.correoElectronico ?? 'N/A')),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed:
                    provider.paginaActual > 1 ? provider.anteriorPagina : null,
              ),
              Text(
                  'Página ${provider.paginaActual} de ${provider.totalPaginas}'),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: provider.paginaActual < provider.totalPaginas
                    ? provider.siguientePagina
                    : null,
              ),
            ],
          ),
          SizedBox(
            height: 35,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  
                  Container(
                    height: 35,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Clientes :', style: style.bodySmall),
                            const SizedBox(width: 10),
                            Text(listClient.length.toString(),
                                style: style.bodySmall?.copyWith(
                                    color: Colors.brown,
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
          identy(context)
        ],
      ),
    );
  }
}
