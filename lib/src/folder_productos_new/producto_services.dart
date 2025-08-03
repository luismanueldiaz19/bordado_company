import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductoService {
  final String baseUrl;

  ProductoService(this.baseUrl);

  Future<http.Response> getProductos() async {
    print('$baseUrl/new.php');
    return await http.post(Uri.parse('$baseUrl/new.php'), body: {'': ''});
  }

  Future<http.Response> getProductoById(String id) async {
    return await http.get(Uri.parse('$baseUrl/get_producto.php?id=$id'));
  }

  Future<http.Response> createProducto(Map<String, dynamic> data) async {
    return await http.post(
      Uri.parse('$baseUrl/create_producto.php'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<http.Response> updateProducto(Map<String, dynamic> data) async {
    return await http.put(
      Uri.parse('$baseUrl/update_producto.php'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<http.Response> deleteProducto(String id) async {
    return await http.delete(
      Uri.parse('$baseUrl/delete_producto.php?id=$id'),
    );
  }
}
