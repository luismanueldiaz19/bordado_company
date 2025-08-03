import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../util/debounce.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/url.dart';
import '/src/model/users.dart';
import '/src/util/helper.dart';
import '/src/widgets/validar_screen_available.dart';

import '../datebase/methond.dart';
import 'dialog_pick_permission.dart';
import 'widgets/card_empleado.dart';

class ScreenAdminPermisos extends StatefulWidget {
  const ScreenAdminPermisos({super.key});

  @override
  State<ScreenAdminPermisos> createState() => _ScreenAdminPermisosState();
}

class _ScreenAdminPermisosState extends State<ScreenAdminPermisos> {
  List<Users> list = [];
  List<Users> listFilter = [];
  List<ListPermission> listPermission = [];
  ListPermission? permissionPicked;
  Debounce? debounce;
  Future getListUsuario() async {
    String url =
        "http://$ipLocal/settingmat/admin/select/select_users_list_permission.php";
    final res = await httpRequestDatabaseGET(url);

    if (res?.body != null) {
      var response = jsonDecode(res!.body);
      if (response['success']) {
        final listUsuario = jsonEncode(response['data']);
        list = usersFromJson(listUsuario);
        listFilter = list;
        setState(() {});
      }
    }
  }

  void searchingItem(String filter) {
    debounce ??= Debounce(duration: const Duration(milliseconds: 500));

    // Usamos debounce para evitar múltiples llamadas rápidas
    debounce!.call(() {
      if (filter.isEmpty) {
        listFilter = list;
      } else {
        String lowerCaseFilter = filter.toLowerCase();
        listFilter = list.where((element) {
          return element.fullName!.toLowerCase().contains(lowerCaseFilter) ||
              element.code!.toLowerCase().contains(lowerCaseFilter) ||
              element.occupation!.toLowerCase().contains(lowerCaseFilter);
        }).toList();
      }

      setState(() {});
    });
  }

  Future getListPermission() async {
    String url =
        "http://$ipLocal/settingmat/admin/select/get_file_list_permission.php";
    final res = await httpRequestDatabaseGET(url);
    if (res?.body != null) {
      final data = jsonDecode(res!.body);
      if (data['success']) {
        listPermission = listPermissionFromJson(jsonEncode(data['data']));
      }
    }
    // print(listPermission.length);
  }

  @override
  void initState() {
    super.initState();
    getListUsuario();
    getListPermission();
  }

  @override
  Widget build(BuildContext context) {
    const shadow =
        BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 10);
    final decoration = BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [shadow]);
    final style = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrador permisos'),
      ),
      body: ValidarScreenAvailable(
        windows: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  listFilter.isEmpty
                      ? Expanded(
                          child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset('assets/gif_icon.gif',
                                      scale: 5)),
                              const SizedBox(height: 10),
                              Text('No hay datos..', style: style.bodySmall),
                            ],
                          ),
                        ))
                      : Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: ListView.builder(
                              itemCount: listFilter.length,
                              itemBuilder: (conext, index) {
                                Users item = listFilter[index];
                                return ZoomIn(
                                  curve: Curves.elasticOut,
                                  child: CardEmpleado(
                                      decoration: decoration,
                                      item: item,
                                      style: style,
                                      listPermission: listPermission),
                                );
                              },
                            ),
                          ),
                        ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: BounceInDown(
                                curve: Curves.elasticOut,
                                child: Image.asset('assets/actualizacion.png',
                                    scale: 6))),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: Text(
                            'Más fácil y Rápido',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: Text(
                            'Toma el control de tus usuarios',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [shadow],
                          ),
                          child: TextField(
                            onChanged: (value) => searchingItem(value),
                            decoration: InputDecoration(
                                hintText:
                                    'Buscar', // Texto de ayuda más descriptivo
                                border: InputBorder
                                    .none, // Mantiene sin borde el campo de texto
                                suffixIcon: Icon(Icons.search,
                                    color: Colors.grey[600],
                                    size: 24), // Estiliza el icono de búsqueda
                                contentPadding:
                                    const EdgeInsets.only(left: 15, top: 8)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'Total : ${listFilter.length.toString()} Usuarios',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black45)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            identy(context)
          ],
        ),
        mobile: Column(
          children: [
            buildTextFieldValidator(
                label: 'Buscar', onChanged: (value) => searchingItem(value)),
            // const SizedBox(height: 10),
            listFilter.isEmpty
                ? Expanded(
                    child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child:
                                Image.asset('assets/gif_icon.gif', scale: 5)),
                        const SizedBox(height: 10),
                        Text('No hay datos..', style: style.bodySmall),
                      ],
                    ),
                  ))
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: ListView.builder(
                          itemCount: listFilter.length,
                          itemBuilder: (conext, index) {
                            Users item = listFilter[index];
                            return ZoomIn(
                              curve: Curves.elasticOut,
                              child: CardEmpleado(
                                  decoration: decoration,
                                  item: item,
                                  style: style,
                                  listPermission: listPermission),
                            );
                          }),
                    ),
                  ),
            Text('Cantidad de Empleados : ${listFilter.length}',
                style: style.bodySmall?.copyWith(color: Colors.grey)),
            identy(context)
          ],
        ),
      ),
    );
  }

  Future putPermission(Users users) async {
    // Mostrar el diálogo de selección de permiso
    ListPermission? permiso = await showPermisoDialog(context, listPermission);

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
      await getListUsuario();
    }
  }
}
