import 'dart:convert';
import 'package:flutter/material.dart';
import '/src/datebase/methond.dart';
import '../datebase/url.dart';
import '../folder_incidencia_main/model_incidencia/incidencia_main.dart';

class ProviderIncidencia with ChangeNotifier {
  // List<PlanificacionItem> _listItemsNotTouch = [];
  List<IncidenciaMain> _list = [];
  List<IncidenciaMain> _listFilter = [];
  List<IncidenciaMain> get listFilter => _listFilter;
  // List<IncidenciaMain> get list => _list;

  Future getIncidencia(estado) async {
    // var estado = "no resuelto";
    String? url =
        "http://$ipLocal/settingmat/admin/select/select_incidencia_test.php?estado=$estado";
    final res = await httpRequestDatabaseGET(url);

    if (res != null) {
      print(res.body);
      var response = jsonDecode(res.body);
      // print(res.body);
      if (response['success']) {
        _list = incidenciaMainFromJson(jsonEncode(response['body']));
        _listFilter = _list;
      }
    }
    notifyListeners();
  }

  searchingItem(String val) {
    // print(val);
    if (val.isNotEmpty) {
      _listFilter = List.from(_list
          .where((x) =>
              x.ficha!.toUpperCase().contains(val.toUpperCase()) ||
              x.departmentFind!.toUpperCase().contains(val.toUpperCase()) ||
              x.numOrden!.toUpperCase().contains(val.toUpperCase()))
          .toList());
    } else {
      _listFilter = _list;
    }
    notifyListeners();
  }

  Future deleteFromIncidencia(idListIncidencia, estado) async {
    //delete_incidencia_completa
    String? url =
        "http://$ipLocal/settingmat/admin/delete/delete_incidencia_completa.php";
    final res = await httpRequestDatabase(
        url, {'id_list_incidencia': idListIncidencia});

    final data = jsonDecode(res.body);
    print(data);
    await getIncidencia(estado);
  }
}
