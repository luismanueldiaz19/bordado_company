import 'package:flutter/material.dart';

import '../../../datebase/methond.dart';
import '../../../datebase/url.dart';
import '../database_bordado/url_bordado.dart';
import '../model/bordoda_tirada.dart';

class ProviderBordadoTirada extends ChangeNotifier {
  List<BordadoTirada> _listTirada = [];
  // List<BordadoTirada> _listReported = [];
  // List<BordadoTirada> _listTiradaTotal = [];
  // List<BordadoTirada> get listReported => _listReported;
  List<BordadoTirada> get listTirada => _listTirada;

  BordadoTirada _currentSelected = BordadoTirada();
  BordadoTirada get currentSelected => _currentSelected;

  Future getTirada(idKeyUnique) async {
    _listTirada.clear();
    _currentSelected = BordadoTirada();
    final res = await httpRequestDatabase(
        selectBordadoTiradaIdKey, {'id_key_unique': idKeyUnique});
    _listTirada = bordadoTiradaFromJson(res.body);
    // totalElaborated = 0;
    // totalCantBad = 0;
    // for (var element in listTirada) {
    //   totalElaborated += int.parse(element.cantElabored ?? '0');
    //   totalCantBad += int.parse(element.cantBad ?? '0');
    // }
    // updateCanUpdate(widget.item.id, totalElaborated, totalCantBad);

    // setState(() {});
    notifyListeners();
  }

  void elegirItemTirada(BordadoTirada item) {
    _currentSelected = item;
    notifyListeners();
  }

  Future<String> updateTiradaV2(data, idKeyUnique) async {
    final res = await httpRequestDatabase(
        "http://$ipLocal/settingmat/admin/update/update_tirada_bordado_v2.php",
        data);
    // print(res.body);
    getTirada(idKeyUnique);
    return '${res.body}';
  }

  Future<String> updateTiradaV2Time(data, idKeyUnique) async {
    final res = await httpRequestDatabase(
        "http://$ipLocal/settingmat/admin/update/update_tirada_bordado_v2_time.php",
        data);

    getTirada(idKeyUnique);
    return '${res.body}';
  }

  Future sendTirada(data) async {
    await httpRequestDatabase(insertBordadoTirada, data);
    getTirada(data['id_key_unique']);
  }

  Future eliminarOTirada(id) async {
    await httpRequestDatabase(deleteBordadoTirada, {'id': '$id'});
  }

  Future<String> updateItemFinished(data, idKeyUnique) async {
    final res = await httpRequestDatabase(
        "http://$ipLocal/settingmat/admin/update/update_bordado_reported_finished.php",
        data);

    getTirada(idKeyUnique);
    return '${res.body}';
  }
}
