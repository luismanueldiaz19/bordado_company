import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '/src/datebase/methond.dart';
import '/src/model/users.dart';

import '../datebase/current_data.dart';
import '../datebase/url.dart';
import '../util/commo_pallete.dart';
import '../util/helper.dart';
import 'dialog_pick_permission.dart';

class EditedUserPermision extends StatefulWidget {
  const EditedUserPermision({super.key, this.item, this.listPermission});
  final Users? item;
  final List<ListPermission>? listPermission;
  @override
  State<EditedUserPermision> createState() => _EditedUserPermisionState();
}

class _EditedUserPermisionState extends State<EditedUserPermision> {
  Users? itemFilter;

  Future eliminarPermision(ListPermission item) async {
    String url =
        "http://$ipLocal/settingmat/admin/delete/delete_users_permission.php";
    final res = await httpRequestDatabase(
        url, {'id_permisos': item.idPermisos, 'id_users': itemFilter?.id});

    var response = jsonDecode(res!.body);
    if (response['success']) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(response['message']),
          duration: const Duration(seconds: 1)));
      setState(() {
        itemFilter!.listPermission!.remove(item);
      });
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(response['message']),
          duration: const Duration(seconds: 1)));
    }
  }

  @override
  void initState() {
    super.initState();
    itemFilter = widget.item;
  }

  Future putPermission(Users users) async {
    // Mostrar el diálogo de selección de permiso
    ListPermission? permiso =
        await showPermisoDialog(context, widget.listPermission!);

    // Actualizar el estado con el permiso seleccionado
    if (permiso != null) {
      await addPermissionUser(users, permiso);
    }
  }

  Future addPermissionUser(Users users, ListPermission permiso) async {
//insert_permission_users
    String url =
        "http://$ipLocal/settingmat/admin/insert/insert_permission_users.php";
    final res = await httpRequestDatabase(
        url, {'id_permisos': permiso.idPermisos, 'id_users': users.id});
    final data = jsonDecode(res!.body);
    print('Permission List : ${res?.body}');
    if (!data['success']) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(data['message']),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 1)));
    } else {
      setState(() {
        itemFilter?.listPermission?.add(permiso);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Permisos')),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          itemFilter!.listPermission!.isNotEmpty
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        child: DataTable(
                          dataRowMaxHeight: 25,
                          dataRowMinHeight: 20,
                          horizontalMargin: 10.0,
                          columnSpacing: 15,
                          headingRowHeight: 30,
                          decoration:
                              const BoxDecoration(color: colorsBlueDeepHigh),
                          headingTextStyle: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          border: TableBorder.symmetric(
                              outside: BorderSide(
                                  color: Colors.grey.shade100,
                                  style: BorderStyle.none),
                              inside: const BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.grey)),
                          columns: const [
                            DataColumn(label: Text('Nombre Completo')),
                            DataColumn(label: Text('Modulo')),
                            DataColumn(label: Text('Acción')),
                            DataColumn(label: Text('Eliminar')),
                          ],
                          rows: itemFilter!.listPermission!
                              .asMap()
                              .entries
                              .map((entry) {
                            int index = entry.key;
                            var report = entry.value;
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
                                DataCell(Text(itemFilter!.fullName ?? 'N/A')),
                                DataCell(Text(report.modulo ?? 'N/A')),
                                DataCell(Text(report.action ?? 'N/A')),
                                DataCell(
                                    hasPermissionUsuario(
                                            currentUsers!.listPermission!,
                                            "admin",
                                            "eliminar")
                                        ? Text('Eliminar')
                                        : Text('Sin Permiso'),
                                    onTap: hasPermissionUsuario(
                                            currentUsers!.listPermission!,
                                            "admin",
                                            "eliminar")
                                        ? () => eliminarPermision(report)
                                        : null),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/disminuyendo.png', scale: 5),
                    const Text('No hay Permiso')
                  ],
                )),
          BounceInDown(
            curve: Curves.elasticInOut,
            child: customButton(
              onPressed: () => putPermission(itemFilter!),
              colorText: Colors.white,
              colors: colorsGreenLevel,
              textButton: 'Agregar permiso',
              width: 150,
            ),
          ),
          identy(context)
        ],
      ),
    );
  }
}
