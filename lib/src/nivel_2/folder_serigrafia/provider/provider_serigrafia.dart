import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../datebase/current_data.dart';
import '../../../datebase/methond.dart';
import '../../../datebase/url.dart';
import '../../forder_sublimacion/model_nivel/sublima.dart';

class ProviderSerigrafia extends ChangeNotifier {
  List<Sublima> _list = [];
  List<Sublima> _listFilter = [];

  List<Sublima> get list => _list;
  List<Sublima> get listFilter => _listFilter;

  String _messaje = 'Cargando... Espere por favor!';
  bool _isLoading = true;

  String get messaje => _messaje;
  bool get isLoading => _isLoading;

  Future getWork(id) async {
    _list.clear();
    _listFilter.clear();
    _isLoading = true;
    _messaje = 'Cargando... Espere por favor!';
    notifyListeners();
    String url =
        "http://$ipLocal/settingmat/admin/select/select_serigrafia_work.php";
    final res = await httpRequestDatabase(url, {'id': id});

    _list = sublimaFromJson(res.body);
    _listFilter = list;
    // print('Print body : ${res.body}');
    await animarWaiting();
    if (listFilter.isEmpty) {
      _isLoading = false;
      _messaje = 'No hay Trabajos';
      print('No hay Trabajos');
    }

    if (validarSupervisor()) {
      _listFilter = List.from(list);
      notifyListeners();
    } else {
      _listFilter = List.from(list
          .where((x) => x.codeUser == currentUsers?.code.toString())
          .toList());
      if (listFilter.isEmpty) {
        _isLoading = false;
        _messaje = 'No hay Trabajos';
        print('No hay Trabajos');
      }

      notifyListeners();
    }
  }

  void eliminarItem(Sublima item) async {
    final res = await httpRequestDatabase(
        "http://$ipLocal/settingmat/admin/delete/delete_serigrafia_work.php",
        {'id': item.id});
    final jsonData = json.decode(res.body);
    // print(res.body);
    if (jsonData['success']) {
      _list.remove(item);
      _listFilter.remove(item);
      notifyListeners();
    }
  }

  animarWaiting() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
