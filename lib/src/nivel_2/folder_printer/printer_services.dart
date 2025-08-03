import 'dart:convert';
import '../../datebase/methond.dart';
import '../../datebase/url.dart';
import '../../model/department.dart';
import '../../util/helper.dart';
import 'model/printer_plan.dart';

class PrinterServices {
  Future delelePrintPlan(Map<String, String> jsonData) async {
    final res = await httpEnviaMapPOST(
        'http://$ipLocal/settingmat/admin/insert/delete_printer_planing.php',
        jsonData);
    return res;
  }

  Future addPrintPlan(Map<String, String> jsonData) async {
    final response = await httpEnviaMapPOST(
        'http://$ipLocal/settingmat/admin/insert/add_printer_plan.php',
        jsonData);

    print(response);
  }

  Future updatePrintPlan(Map<String, String> jsonData) async {
    final response = await httpEnviaMapPOST(
        'http://$ipLocal/settingmat/admin/insert/update_printer_planing.php',
        jsonData);

    print(response);

    return response;
  }

// List<PrinterPlan> printerPlanFromJson(
  Future<List<PrinterPlan>> getPlaningPrinter(
      Department? depart, bool estado) async {
    // print('getPlanesPendientes ....');
    final response = await httpEnviaMap(
        'http://$ipLocal/settingmat/admin/insert/get_printer_plan.php',
        jsonEncode({
          'name_depart': quitarAcentos(depart!.nameDepartment ?? 'N/A'),
          'estado': estado ? 'TERMINADO' : ''
        }));
    final data = jsonDecode(response);
    if (data['success']) {
      return printerPlanFromJson(jsonEncode(data['data']));
    }
    return [];
  }

// List<PrinterPlan> printerPlanFromJson(
  Future<List<PrinterPlan>> getPlaningAdmin(
      String fechaInicio, String fechaFin) async {
    // print('getPlanesPendientes ....');
    final response = await httpEnviaMap(
        'http://$ipLocal/settingmat/admin/insert/get_plan_week_admin.php',
        jsonEncode({"fecha_inicio": fechaInicio, "fecha_fin": fechaFin}));
    final data = jsonDecode(response);
    if (data['success']) {
      return printerPlanFromJson(jsonEncode(data['data']));
    }
    return [];
  }

  //get_printer_plan.php
}
