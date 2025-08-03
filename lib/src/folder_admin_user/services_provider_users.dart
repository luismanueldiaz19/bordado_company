import 'dart:convert';

import 'package:flutter/material.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/model/users.dart';

class ServicesProviderUsers with ChangeNotifier {
  List<Users> _userList = [];
  List<Users> _userListFilter = [];

  List<Users> get userList => _userList;

  List<Users> get userListFilter => _userListFilter;

  Future getUserAdmin() async {
    final res = await httpRequestDatabase(selectUsersAdmin, {'view': 'view'});
    _userList = usersFromJson(res.body);
    _userListFilter = [..._userList];
    // print(res.body);
    notifyListeners();
  }

  Future searchingFilter(String val) async {
    // print(val);
    if (val.isNotEmpty) {
      _userListFilter = List.from(_userList
          .where((x) =>
              x.fullName!.toUpperCase().contains(val.toUpperCase()) ||
              x.occupation!.toUpperCase().contains(val.toUpperCase()) ||
              x.code!.toUpperCase().contains(val.toUpperCase()))
          .toList());
      notifyListeners();
    } else {
      _userListFilter = [..._userList];
      notifyListeners();
    }
  }

  Future updateFrom(Users localUser) async {
    //full_name= '$full_name', occupation= '$occupation',turn='$turn', code= '$code'

    var data = {
      'id': localUser.id,
      'full_name': localUser.fullName,
      'occupation': localUser.occupation,
      'turn': localUser.turn,
      'code': localUser.code,
      'type': localUser.type,
    };
    // print(data);
    final res = await httpRequestDatabase(updateUsers, data);
    print(res.body);
    getUserAdmin();
  }

  Future deleteFrom(Users localUser) async {
    await httpRequestDatabase(deleteUsers, {'id': localUser.id});
    getUserAdmin();
  }

  Future<String> addUser(jsonData) async {
    String mensaje = 'Error al agregar el usuario';

    try {
      final res = await httpRequestDatabase(
          'http://$ipLocal/settingmat/admin/insert/insert_add_users_nuevo.php',
          jsonData);

      final resBody = jsonDecode(res.body);

      if (resBody['success']) {
        print(resBody['body']);
        mensaje = resBody['body'] ?? 'Usuario agregado correctamente';
      } else {
        mensaje = resBody['message'] ?? 'No se pudo agregar el usuario';
        print('Error al agregar el usuario: $resBody');
      }
    } catch (e) {
      mensaje = 'Ocurrió un error al agregar el usuario: $e';
      print(mensaje);
    }

    return mensaje;
  }
}
