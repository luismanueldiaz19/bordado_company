import 'package:flutter/material.dart';
import '/src/nivel_2/folder_bordado/database_bordado/url_bordado.dart';

import '../../datebase/methond.dart';
import 'model/machine_bordado.dart';

class DialogGetMachine extends StatefulWidget {
  const DialogGetMachine({super.key});

  @override
  State<DialogGetMachine> createState() => _DialogGetMachineState();
}

class _DialogGetMachineState extends State<DialogGetMachine> {
  MachineBordado? machineCurrent;
  List<MachineBordado> listMachine = [];
  Future getMachine() async {
    final res =
        await httpRequestDatabase(selectMachineBordado, {'view': 'view'});
    listMachine = machineBordadoFromJson(res.body);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getMachine();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;

    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      title: Text('Elegir Maquina', style: style.bodyMedium),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: const Text('Cancelar')),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context, machineCurrent);
            },
            child: const Text('Elegir')),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          listMachine.isNotEmpty
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.50,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: listMachine
                          .map((item) => Container(
                                color: machineCurrent == item
                                    ? Colors.blue.shade100
                                    : Colors.white,
                                width: 200,
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        machineCurrent = item;
                                      });
                                    },
                                    child: Text(item.machine ?? 'N/A')),
                              ))
                          .toList(),
                    ),
                  ),
                )
              : const Center(child: Text('No Maquinas'))
        ],
      ),
    );
  }
}
