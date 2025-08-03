import 'dart:convert';
import 'producto.dart';
import 'producto_services.dart';

class ProductoRepository {
  final ProductoService _service;

  ProductoRepository(this._service);

  Future<List<Producto>> fetchProductos() async {
    final response = await _service.getProductos();

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] && data['productos'] != null) {
        return (data['productos'] as List)
            .map((json) => Producto.fromJson(json))
            .toList();
      }
    }

    throw Exception('Error al cargar productos');
  }

  Future<Producto> fetchProductoById(String id) async {
    final response = await _service.getProductoById(id);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        return Producto.fromJson(data['producto']);
      }
    }

    throw Exception('Producto no encontrado');
  }

  Future<bool> crearProducto(Map<String, dynamic> data) async {
    final response = await _service.createProducto(data);
    return jsonDecode(response.body)['success'] == true;
  }

  Future<bool> actualizarProducto(Map<String, dynamic> data) async {
    final response = await _service.updateProducto(data);
    return jsonDecode(response.body)['success'] == true;
  }

  Future<bool> eliminarProducto(String id) async {
    final response = await _service.deleteProducto(id);
    return jsonDecode(response.body)['success'] == true;
  }
}
