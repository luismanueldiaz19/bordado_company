import 'dart:convert';

import 'package:flutter/material.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/model/department.dart';

import '../datebase/url.dart';

class ProviderDepartment with ChangeNotifier {
  List<Department> _list = [];
  List<Department> get list => _list;

  Future getDepartmentNiveles() async {
    accesoDepart.clear();
    final res = await httpRequestDatabase(
        'http://$ipLocal/$pathLocal/department/get_department.php',
        {'view': 'view'});

    print(res.body);
    final value = json.decode(res.body);

    _list = departmentFromJson(json.encode(value['data']));
    // print('usuarios es : ${currentUsers?.toJson()}');
    for (var element in _list) {
      // print('Depart : ${element.nameDepartment} - type : ${element.type}');
      if (currentUsers!.type!
              .toLowerCase()
              .contains(element.type!.toLowerCase()) ||
          currentUsers!.type!.contains('t')) {
        accesoDepart.add(element.nameDepartment!);
      }
    }
    debugPrint('Lista de acessos $accesoDepart');
    notifyListeners();
  }
}
