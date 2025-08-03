import 'package:flutter/material.dart';

import '../../../datebase/methond.dart';
import '../../../datebase/url.dart';
import '../database_bordado/url_bordado.dart';
import '../model/bordado_report.dart';

class ProvideBordado extends ChangeNotifier {
  List<BordadoReport> _listReported = [];
  List<BordadoReport> _listTiradaTotal = [];
  List<BordadoReport> get listReported => _listReported;
  List<BordadoReport> get listTiradaTotal => _listTiradaTotal;
  Future getProducionCurrently() async {
    listReported.clear();
    listTiradaTotal.clear();
    final res =
        await httpRequestDatabase(selectBordadoReported, {'view': 'view'});
    String url =
        "http://$ipLocal/settingmat/admin/select/select_bordado_tirada_total_actual.php";
    final res2 = await httpRequestDatabase(url, {'view': 'view'});
    _listTiradaTotal = bordadoReportFromJson(res2.body);
    _listReported = bordadoReportFromJson(res.body);
    print('Provider inited');
    notifyListeners();
  }

  Future eliminarBordadoReport(id) async {
    await httpRequestDatabase(deleteBordadoReportedGeneral, {'id': '$id'});
    getProducionCurrently();
  }
}
