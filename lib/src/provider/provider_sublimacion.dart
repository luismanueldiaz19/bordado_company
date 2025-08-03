import 'dart:convert';

import 'package:flutter/material.dart';
import '/src/datebase/methond.dart';

import '../datebase/current_data.dart';
import '../datebase/url.dart';
import '../nivel_2/forder_sublimacion/model_nivel/list_work_sublimacion.dart';

class ProviderSublimacion with ChangeNotifier {
  // List<PlanificacionItem> _listItemsNotTouch = [];
  List<ListWorkSublimacion> _listWork = [];
  List<ListWorkSublimacion> _listWorkFilter = [];
  List<ListWorkSublimacion> get listWorkFilter => _listWorkFilter;
  List<ListWorkSublimacion> get listWork => _listWork;
  // String _departmentSelected = '';
  // String get departmentSelected => _departmentSelected;

  Future getListWork() async {
    _listWorkFilter.clear();
    _listWork.clear();
    final res = await httpRequestDatabaseGET(
        "http://$ipLocal/settingmat/admin/select/select_lista_trabajos_sublimacion_nube.php");

    if (res != null) {
      final data = jsonDecode(res.body);
      if (data['success']) {
        _listWork = listWorkSublimacionFromJson(jsonEncode(data['body']));

        _listWorkFilter = List.from(_listWork
            .where((x) =>
                x.codeListWork!.toUpperCase() ==
                currentUsers?.code.toString().toUpperCase())
            .toList());

        if (currentUsers?.occupation == OptionAdmin.master.name ||
            currentUsers?.occupation == OptionAdmin.supervisor.name ||
            currentUsers?.occupation == OptionAdmin.admin.name) {
          _listWorkFilter = _listWork;
        }
      }
    }
    notifyListeners();
  }
}
