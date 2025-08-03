import 'dart:convert';

import 'package:flutter/material.dart';
import '../datebase/url.dart';
import '../model/orden_list.dart';
import '/src/datebase/current_data.dart';

import '../datebase/methond.dart';

class ProviderPlanificacion with ChangeNotifier {
  List<OrdenList> _listItemsNotTouch = [];
  List<OrdenList> _listItems = [];
  List<OrdenList> _listItemsFilter = [];
  List<OrdenList> get listItemsFilter => _listItemsFilter;
  List<OrdenList> get listItems => _listItems;
  String _departmentSelected = '';
  String get departmentSelected => _departmentSelected;

  int get currentPage => _currentPage;
  int get totalItems => _totalItems;
  int get itemsPerPage => _itemsPerPage;

  int get totalPages => (_totalItems / _itemsPerPage).ceil();

  void changePage(int newPage) {
    if (newPage >= 0 && newPage != _currentPage) {
      _currentPage = newPage;
      // getPlanificacionWork();

      notifyListeners();
    }
    print('Cambio de página a: $_currentPage');
  }

  set totalItems(int value) {
    _totalItems = value;
    notifyListeners();
  }

  set itemsPerPage(int value) {
    _itemsPerPage = value;
    notifyListeners();
  }

  String? _firstDate = DateTime.now()
      .subtract(const Duration(days: 90))
      .toString()
      .substring(0, 10);
  String? _secondDate = DateTime.now().toString().substring(0, 10);

  ///ajuste de la paginación
  int _currentPage = 0;
  int _totalItems = 0;
  int _itemsPerPage = 20; // Ajusta esto a lo que quieras

  void toChangeDate(date1, date2) {
    debugPrint('Hubo un cambio de fechas');
    _firstDate = date1;
    _secondDate = date2;
    getPlanificacionWork();
    notifyListeners();
  }

  Future getPlanificacionWork() async {
    debugPrint('Provider planificacion trabajando');

    ///esta lista es para no tocar los elementos
    _listItemsNotTouch.clear();
    _listItemsFilter.clear();
    _listItems.clear();

    // Calcular el total de elementos y ajustar la paginación
    _totalItems = _listItemsNotTouch.length;
    _itemsPerPage = 20; // Puedes ajustar este valor según sea necesario
    _currentPage = 0; // Reiniciar a la primera página

    final res = await httpRequestDatabase(
        'http://$ipLocal/$pathLocal/produccion/get_produccion.php',
        {'modo': 'DESC', 'date1': _firstDate, 'date2': _secondDate});

    final value = json.decode(res.body);

    if (value['success']) {
      print(json.encode(value['data']));

      _listItemsNotTouch = ordenListFromJson(json.encode(value['data']));

      ///lista para filtrar
      _listItems = _listItemsNotTouch.where((element) {
        return accesoDepart.contains(element.nameDepartment);
      }).toList();
      _listItemsFilter = _listItems;
      if (_departmentSelected.isNotEmpty) {
        searchingArea(_departmentSelected);
      }
      await wattingMoment();
      notifyListeners();
    }

    ///List<OrdenList> ordenListFromJson(
    print(res.body);
  }

  // Función para manejar el cambio de página
  void _onPageChanged(int pageIndex) {
    _currentPage = pageIndex;
    getPlanificacionWork(); // Vuelve a obtener los datos con la nueva página
  }

  Future<void> searchingOrden(String val) async {
    if (_departmentSelected.isNotEmpty) {
      // Filtrar por búsqueda (val) y por el departamento seleccionado
      _listItemsFilter = _listItems.where((x) {
        // Condiciones para la búsqueda por ficha, numOrden o nameLogo
        final matchesSearch =
            x.ficha!.toUpperCase().contains(val.toUpperCase()) ||
                x.numOrden!.toUpperCase().contains(val.toUpperCase()) ||
                x.nameLogo!.toUpperCase().contains(val.toUpperCase());

        // Condición para el filtro por departamento
        final matchesDepartment = x.nameDepartment!.toUpperCase() ==
            _departmentSelected.toUpperCase();

        // Ambas condiciones deben ser verdaderas
        return matchesSearch && matchesDepartment;
      }).toList();
    } else {
      // Si no hay departamento seleccionado, solo filtrar por la búsqueda
      if (val.isNotEmpty) {
        _listItemsFilter = _listItems.where((x) {
          return x.ficha!.toUpperCase().contains(val.toUpperCase()) ||
              x.numOrden!.toUpperCase().contains(val.toUpperCase()) ||
              x.nameLogo!.toUpperCase().contains(val.toUpperCase());
        }).toList();
      } else {
        // Si no hay búsqueda ni filtro, mostrar la lista completa
        _listItemsFilter = _listItems;
      }
    }
    // Notificar los cambios para actualizar la UI
    notifyListeners();
  }

  searchingArea(value) {
    _departmentSelected = value;

    _listItemsFilter = List.from(_listItems
        .where((x) =>
            x.nameDepartment!.toUpperCase().contains(value.toUpperCase()))
        .toList());
    notifyListeners();
  }

  searchingPriority(value) {
    // _departmentSelected = value;

    _listItemsFilter = List.from(_listItems
        .where((x) =>
            x.estadoPrioritario!.toUpperCase().contains(value.toUpperCase()))
        .toList());
    notifyListeners();
  }

  normalizarList() {
    _departmentSelected = '';
    _listItemsFilter = _listItems;
    notifyListeners();
  }

  cleanDepartmenSelected() {
    _departmentSelected = '';
    notifyListeners();
  }

  Future wattingMoment() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
