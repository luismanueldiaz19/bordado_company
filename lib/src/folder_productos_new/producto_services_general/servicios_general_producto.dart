
import '/src/folder_productos_new/modelo/produc.dart';

import '../../datebase/methond.dart';
import '../../datebase/url.dart';

class ServiciosGeneralProducto {
  Future addColors(Map<String, String> jsonData) async {
    final response = await httpEnviaMapPOST(
        'http://$ipLocal/settingmat/admin/insert/insert_color.php', jsonData);
    print(response);
  }

  Future addMaterial(Map<String, String> jsonData) async {
    final response = await httpEnviaMapPOST(
        'http://$ipLocal/settingmat/admin/insert/insert_material.php',
        jsonData);
    print(response);
  }

  Future addMarca(Map<String, String> jsonData) async {
    final response = await httpEnviaMapPOST(
        'http://$ipLocal/settingmat/admin/insert/insert_marca.php', jsonData);
    print(response);
  }

  Future addSubCategoria(Map<String, String> jsonData) async {
    final response = await httpEnviaMapPOST(
        'http://$ipLocal/settingmat/admin/insert/insert_sub_categoria.php',
        jsonData);
    print(response);
  }

  Future addLineaProducto(Map<String, String> jsonData) async {
    final response = await httpEnviaMapPOST(
        'http://$ipLocal/settingmat/admin/insert/insert_linea_producto.php',
        jsonData);
    print(response);
  }

  Future addTallas(Map<String, String> jsonData) async {
    final response = await httpEnviaMapPOST(
        'http://$ipLocal/settingmat/admin/insert/insert_tallas.php', jsonData);
    print(response);
  }

  Future addNewProducto(Produc jsonData) async {
    final response = await httpRequestDatabase(
        'http://$ipLocal/settingmat/admin/insert/insert_prod.php',
        jsonData.toJson());
    print(response.body);
  }

  //nombre_talla

  // Future delelePrintPlan(Map<String, String> jsonData) async {
  //   final res = await httpEnviaMapPOST(
  //       'http://$ipLocal/settingmat/admin/insert/delete_printer_planing.php',
  //       jsonData);
  //   return res;
  // }

  // Future addPrintPlan(Map<String, String> jsonData) async {
  //   final response = await httpEnviaMapPOST(
  //       'http://$ipLocal/settingmat/admin/insert/add_printer_plan.php',
  //       jsonData);

  //   print(response);
  // }

  // Future updatePrintPlan(Map<String, String> jsonData) async {
  //   final response = await httpEnviaMapPOST(
  //       'http://$ipLocal/settingmat/admin/insert/update_printer_planing.php',
  //       jsonData);

  //   print(response);

  //   return response;
  // }
}
