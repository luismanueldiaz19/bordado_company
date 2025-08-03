import 'package:flutter/material.dart';
import '/src/datebase/url.dart';
import '/src/nivel_2/folder_confecion/model/confecion.dart';
import '/src/nivel_2/folder_confecion/model/url_confecion.dart';

import '../../../datebase/methond.dart';

class ProviderSastreria extends ChangeNotifier {
  List<Confeccion> _list = [];
  List<Confeccion> _listFilter = [];
  String? messaje = 'Cargando... Espere por favor!';
  bool isLoading = true;

  List<Confeccion> get listFilter => _listFilter;

  Future getWork(firstDate, secondDate, idDepart) async {
    messaje = 'Cargando... Espere por favor!';
    _listFilter.clear();
    _list.clear();
    isLoading = true;
    notifyListeners();

    final res = await httpRequestDatabase(selectReportSastreriaDate,
        {'date1': firstDate, 'date2': secondDate, 'id_depart': idDepart});
    _list = confeccionFromJson(res.body);
    _listFilter = _list;
    await animarWaiting();
    if (listFilter.isEmpty) {
      isLoading = false;
      messaje = 'No hay Trabajos';
    }
    notifyListeners();
  }

  animarWaiting() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future updateEnd(Confeccion data, firstDate, secondDate, idDepart) async {
    await httpRequestDatabase(updateReportSastreriaDateEnd, {
      'date_end': DateTime.now().toString().substring(0, 19),
      'id': data.id
    });
    getWork(firstDate, secondDate, idDepart);
  }

  Future deleteFrom(Confeccion data, firstDate, secondDate, idDepart) async {
    await httpRequestDatabase(
        deleteReportSastreria, {'id': data.id.toString()});
    getWork(firstDate, secondDate, idDepart);
  }

  Future updatedComentario(
      id, comentario, firstDate, secondDate, idDepart) async {
    await httpRequestDatabase(
        updateReportSastreriaComentario, {'id': id, 'comment': comentario});
    getWork(firstDate, secondDate, idDepart);
  }

  void searching(String value) {
    // print(val);
    if (value.isNotEmpty) {
      _listFilter = List.from(_list
          .where((x) =>
              x.ficha!.toUpperCase().contains(value.toUpperCase()) ||
              x.numOrden!.toUpperCase().contains(value.toUpperCase()) ||
              x.nameLogo!.toUpperCase().contains(value.toUpperCase()))
          .toList());
      notifyListeners();
    } else {
      _listFilter = _list;
      notifyListeners();
    }
  }

  Future updateCantAndFinish(
      Confeccion data, firstDate, secondDate, idDepart) async {
    String url =
        "http://$ipLocal/settingmat/admin/update/update_report_sastreria_last.php";

    await httpRequestDatabase(url, data.toJson());
    getWork(firstDate, secondDate, idDepart);
  }
}
