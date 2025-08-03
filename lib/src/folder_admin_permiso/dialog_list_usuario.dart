import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/model/users.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/helper.dart';

class DialogListUsuario extends StatefulWidget {
  const DialogListUsuario({super.key});

  @override
  State<DialogListUsuario> createState() => _DialogListUsuarioState();
}

class _DialogListUsuarioState extends State<DialogListUsuario> {
  List<Users> list = [];
  List<Users> listFilter = [];
  List<Users> pickedUsuario = [];
  Future getListUsuario() async {
    String url =
        "http://$ipLocal/settingmat/admin/select/select_users_list_permission.php";
    final res = await httpRequestDatabaseGET(url);
    // print(res?.body);
    if (res?.body != null) {
      var response = jsonDecode(res!.body);
      if (response['success']) {
        list = usersFromJson(jsonEncode(response['data']));
        listFilter = list;
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // date = DateTime.now().toString().substring(0, 10);
    getListUsuario();
    // getNiveles();
  }

  void filterEmpleado(String filter) {
    setState(() {
      if (filter.isNotEmpty) {
        listFilter = listFilter
            .where((element) =>
                element.fullName!
                    .toLowerCase()
                    .contains(filter.toLowerCase()) ||
                element.code!.toLowerCase().contains(filter.toLowerCase()))
            .toList();
      } else {
        listFilter = list;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return AlertDialog(
      title: Text('Elegir Empleados', style: style.titleMedium),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BounceInDown(
            curve: Curves.elasticInOut,
            child: buildTextFieldValidator(
                onChanged: (value) => filterEmpleado(value),
                hintText: 'Escribir Empleado',
                label: 'Empleado'),
          ),
          list.isNotEmpty
              ? SizedBox(
                  width: 250,
                  height: 350,
                  child: Material(
                    color: Colors.transparent,
                    child: ListView.builder(
                      itemCount: listFilter.length,
                      itemBuilder: (context, index) {
                        Users current = list[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            tileColor: current.isSelected!
                                ? Colors.white54
                                : Colors.transparent,
                            onTap: () {
                              setState(() {
                                current.isSelected = !current.isSelected!;
                                if (current.isSelected!) {
                                  pickedUsuario.add(current);
                                } else {
                                  pickedUsuario.remove(current);
                                }
                              });
                            },
                            title: Text(current.fullName.toString(),
                                style: style.bodySmall),
                            subtitle: Text(
                              current.isSelected! ? 'Seleccionado' : '',
                              style: style.bodySmall
                                  ?.copyWith(color: colorsBlueDeepHigh),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : const Text('Espere, cargando lista.'),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: const Text('Cancelar',
                style: TextStyle(color: Colors.red, fontSize: 12))),
        customButton(
            width: 150,
            onPressed: () {
              Navigator.pop(context, pickedUsuario);
            },
            colorText: Colors.white,
            colors: colorsAd,
            textButton: 'Ya!')
      ],
    );
  }
}
