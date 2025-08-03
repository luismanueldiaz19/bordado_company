import 'dart:convert';

import 'package:bordado_company/src/datebase/current_data.dart';
import 'package:flutter/material.dart';

import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/folder_cliente_company/model_cliente/cliente.dart';

import '../util/commo_pallete.dart';
import '../util/helper.dart';
import 'add_cliente_dialog.dart';

class DialogGetClients extends StatefulWidget {
  const DialogGetClients({super.key});

  @override
  State<DialogGetClients> createState() => _DialogGetClientsState();
}

class _DialogGetClientsState extends State<DialogGetClients> {
  List<Cliente> listClients = [];
  List<Cliente> listClientsFilter = [];

  Cliente? entregadorCurrent;

  Future getClient() async {
    setState(() {
      listClients.clear();
      listClientsFilter.clear();
    });
    String url = "http://$ipLocal/$pathLocal/clientes/get_clientes.php";
    final res = await httpRequestDatabase(url, {'token': token});
    var value = jsonDecode(res.body);
    listClients = clienteFromJson(jsonEncode(value['clientes']));
    listClientsFilter = listClients;
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getClient();
  }

  _seachingItem(String value) {
    if (value.isNotEmpty) {
      setState(() {
        listClientsFilter = listClients
            .where((element) =>
                element.nombre!.toUpperCase().contains(value.toUpperCase()))
            .toList();
      });
    } else {
      setState(() {
        listClientsFilter = listClients;
      });
    }
  }

// Para mostrar el diálogo:
  void mostrarAgregarClienteDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddClientDialog();
      },
    ).then((value) {
      if (value != null) {
        getClient();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final sized = MediaQuery.sizeOf(context);
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: Colors.white,
      elevation: 10,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Elegir el Cliente', style: style.labelLarge),
          Tooltip(
            message: 'add nuevo cliente!',
            child: IconButton(
                onPressed: () => mostrarAgregarClienteDialog(context),
                icon: const Icon(Icons.person_add_alt_1_outlined)),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
        ),
        customButton(
          width: 150,
          colorText: Colors.white,
          colors: colorsAd,
          textButton: 'Elegir',
          onPressed: () {
            Navigator.pop(context, entregadorCurrent);
          },
        )
      ],
      content: SizedBox(
        height: sized.height * 0.50,
        child: Column(
          children: [
            buildTextFieldValidator(
              onChanged: (val) => _seachingItem(val),
              hintText: 'Buscar cliente',
              label: 'Buscar',
            ),
            const SizedBox(height: 10),
            listClientsFilter.isNotEmpty
                ? Expanded(
                    child: SizedBox(
                    // color: Colors.red,
                    width: 250,
                    child: ListView.builder(
                      itemCount: listClientsFilter.length,
                      itemBuilder: (context, index) {
                        Cliente item = listClientsFilter[index];
                        return Container(
                          color: entregadorCurrent == item
                              ? Colors.blue.shade100
                              : Colors.white,
                          width: 200,
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                entregadorCurrent = item;
                              });
                            },
                            title: Text(
                                '${item.nombre ?? 'N/A'} ${item.apellido ?? 'N/A'}',
                                style: style.labelSmall),
                            subtitle: Text('Tel : ${item.telefono ?? 'N/A'}',
                                style: style.bodySmall
                                    ?.copyWith(color: Colors.black54)),
                          ),
                        );
                      },
                    ),
                  ))
                : const Center(child: Text('No hay cliente')),
          ],
        ),
      ),
    );
  }
}
