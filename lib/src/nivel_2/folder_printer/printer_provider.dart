import 'dart:convert';

import 'package:flutter/material.dart';
import '../../model/department.dart';
import '../../util/helper.dart';
import 'model/printer_plan.dart';
import 'printer_services.dart';

class PrinterProvider with ChangeNotifier {
  final PrinterServices _service = PrinterServices();
  bool isLoading = false;
  String message = '';
  List<PrinterPlan> _planes = [];
  List<PrinterPlan> _planeFilter = [];

  List<PrinterPlan> get planeFilter => _planeFilter;
  List<PrinterPlan> get planes => _planes;
  String? _diaPicked;
  String? get diaPicked => _diaPicked;
  bool _estadoPicked = false;
  bool get estadoPicked => _estadoPicked;
  // String? _estadoFiltro;
  // String? get estadoFiltro => _estadoFiltro;

  /// Establece el día seleccionado y aplica el filtro
  void setDiaPicked(String dia) {
    _diaPicked = dia;
    filtrarPorDia(); // Llama al filtro automáticamente
  }

  void setEstadoPicked(Department? depart) {
    _estadoPicked = !_estadoPicked;
    getPlanesPendientes(depart);
    // setDiaPicked(_diaPicked ?? 'Lunes');
  }

// String? filtroDiaSemana;
  bool incluirEstadosCriticos = true;
  void filtrarPorDia() {
    _planeFilter = _planes.where((plan) {
      final diaPlan = quitarAcentos(plan.diaSemana?.toUpperCase() ?? '');
      final estadoPlan = quitarAcentos(plan.estado?.toUpperCase() ?? '');

      // Filtro por día de la semana
      final cumpleDia = _diaPicked == null ||
          quitarAcentos(_diaPicked!.toUpperCase()) == diaPlan;

      // Filtro por estados críticos
      final esCritico = estadoPlan == 'URGENTE'.toUpperCase() ||
          estadoPlan == 'PARADO'.toUpperCase() ||
          estadoPlan == 'RETRASADO'.toUpperCase();

      return cumpleDia || (incluirEstadosCriticos && esCritico);
    }).toList();

    // Ordenar por indexWork (nulls al final)
    _planeFilter.sort((a, b) {
      final aIndex = a.indexWork ?? 999999;
      final bIndex = b.indexWork ?? 999999;
      return aIndex.compareTo(bIndex);
    });

    notifyListeners();
  }

  // void filtrarPorDia() {
  //   if (_diaPicked == null || _diaPicked!.isEmpty) {
  //     _planeFilter = _planes; // Sin filtro, mostrar todo
  //   } else {
  //     String diaFiltrado = quitarAcentos(_diaPicked!.toLowerCase());

  //     _planeFilter = _planes.where((plan) {
  //       String diaPlan = quitarAcentos(plan.diaSemana?.toLowerCase() ?? '');
  //       return diaPlan == diaFiltrado;
  //     }).toList();
  //   }

  //   notifyListeners();
  // }

  Future<void> getPlanesPendientes(Department? depart) async {
    isLoading = true;

    _planes.clear();
    _planeFilter.clear();
    notifyListeners();
    try {
      List<PrinterPlan> response =
          await _service.getPlaningPrinter(depart, _estadoPicked);
      if (response.isNotEmpty) {
        _planes = response;
        _planeFilter = _planes;
        message = 'Datos cargados correctamente';
      } else {
        message = 'Error desconocido';
        _planes = [];
        _planeFilter = [];
      }
    } catch (e) {
      message = 'Error: $e';
      _planes = [];
      _planeFilter = [];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> addPlan(Map<String, String> data) async {
    isLoading = true;
    notifyListeners();

    try {
      await _service.addPrintPlan(data);
      message = 'Trabajo agregado correctamente.';
    } catch (e) {
      message = 'Error: $e';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updatePlan(PrinterPlan item) async {
    try {
      await _service.updatePrintPlan(item.toJson());
      if (item.estado == 'TERMINADO') {
        _planes.remove(item);
        _planeFilter.remove(item);
      }

      filtrarPorDia();
    } catch (e) {
      message = 'Error: $e';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> eliminarPlan(Map<String, String> jsonData) async {
    try {
      final response = await _service.delelePrintPlan(jsonData);

      final data = jsonDecode(response);
      if (data['success']) {
        _planes.remove(PrinterPlan.fromJson(jsonData));
        _planeFilter = _planes;
        filtrarPorDia();

        // notifyListeners();
      } else {
        message = data['message'] ?? 'Error desconocido';
      }
    } catch (e) {
      message = 'Error: $e';
    }
    notifyListeners();
  }
}
