import 'package:flutter/material.dart';
import '/src/datebase/methond.dart';
import '/src/nivel_2/folder_planificacion/url_planificacion/url_planificacion.dart';
import '../folder_planificacion/model_planificacion/planificacion_last.dart';

class ReceptionProviderPlanificacion with ChangeNotifier {
  List<PlanificacionLast> _planificacionList = [];
  List<PlanificacionLast> _planificacionListFilter = [];

  List<PlanificacionLast> get planificacionList => _planificacionList;
  List<PlanificacionLast> get planificacionListFilter =>
      _planificacionListFilter;

  ///ordenes no entregado
  Future getReceptionPlanificacionAll(date1, date2) async {
    _planificacionList.clear();
    _planificacionListFilter.clear();
    final res = await httpRequestDatabase(
        selectPlanificacionLast, {'date1': date1, 'date2': date2});
    _planificacionList = planificacionLastFromJson(res.body);
    _planificacionListFilter = _planificacionList;
    notifyListeners();
  }

  ///selectPlanificacionByMothEntregas

  void searchingFilter(String val) {
    // print(val);
    if (val.isNotEmpty) {
      _planificacionListFilter = List.from(_planificacionList
          .where((x) =>
              x.cliente!.toUpperCase().contains(val.toUpperCase()) ||
              x.clienteTelefono!.toUpperCase().contains(val.toUpperCase()) ||
              x.numOrden!.toUpperCase().contains(val.toUpperCase()) ||
              x.nameLogo!.toUpperCase().contains(val.toUpperCase()) ||
              x.userRegistroOrden!.toUpperCase().contains(val.toUpperCase()) ||
              x.ficha!.toUpperCase().contains(val.toUpperCase()) ||
              x.fechaStart!.toUpperCase().contains(val.toUpperCase()))
          .toList());
      notifyListeners();
    } else {
      _planificacionListFilter = [..._planificacionList];

      notifyListeners();
    }
  }

  void searchingDelirery(String val) {
    if (val.isNotEmpty) {
      _planificacionListFilter = List.from(_planificacionList
          .where(
              (x) => x.dateDelivered!.toUpperCase().contains(val.toUpperCase()))
          .toList());
      notifyListeners();
    } else {
      _planificacionListFilter = [..._planificacionList];

      notifyListeners();
    }
  }

  void searchingFilterStatu(String val) {
    if (val.isNotEmpty) {
      _planificacionListFilter = List.from(_planificacionList
          .where((x) => x.statu!.toUpperCase() == val.toUpperCase())
          .toList());
    }
    notifyListeners();
  }
}
