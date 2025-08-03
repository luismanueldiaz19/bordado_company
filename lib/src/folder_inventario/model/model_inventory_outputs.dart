import 'dart:convert';
import 'package:http/http.dart' as http;

// Modelo para cada salida (inventory output)
class InventoryOutput {
  final int idOutput;
  final int idProduct;
  final String nameProduct;
  final double quantity;
  final String? outputDate;
  final String reason;

  InventoryOutput({
    required this.idOutput,
    required this.idProduct,
    required this.nameProduct,
    required this.quantity,
    required this.outputDate,
    required this.reason,
  });

  factory InventoryOutput.fromJson(Map<String, dynamic> json) {
    return InventoryOutput(
      idOutput: int.parse(json['id_output']),
      idProduct: int.parse(json['id_product']),
      nameProduct: json['name_product'],
      quantity: double.parse(json['quantity'].toString()),
      outputDate: json['output_date'],
      reason: json['reason'],
    );
  }

  
  
  static String getTotal(List<InventoryOutput> collection) {
      double totalOrden = 0.0;
  
      for (var element in collection) {
        totalOrden += double.parse(element.quantity.toString());
      }
      return totalOrden.toStringAsFixed(0);
    }
}

// Modelo para la respuesta completa del API
class InventoryOutputResponse {
  final bool success;
  final int totalItems;
  final String message;
  final List<InventoryOutput> body;

  InventoryOutputResponse({
    required this.success,
    required this.totalItems,
    required this.message,
    required this.body,
  });

  factory InventoryOutputResponse.fromJson(Map<String, dynamic> json) {
    var list = json['body'] as List;
    List<InventoryOutput> outputs =
        list.map((i) => InventoryOutput.fromJson(i)).toList();

    return InventoryOutputResponse(
      success: json['success'],
      totalItems: json['total_items'],
      message: json['message'],
      body: outputs,
    );
  }
}

// Servicio para llamar el API
class InventoryOutputApi {
  final String baseUrl;

  InventoryOutputApi(this.baseUrl);

  Future<InventoryOutputResponse> fetchInventoryOutputs({
    required String fechaInicio,
    required String fechaFin,
    int limit = 20,
    int offset = 0,
  }) async {
    final uri = Uri.parse(baseUrl).replace(queryParameters: {
      'fecha_inicio': fechaInicio,
      'fecha_fin': fechaFin,
      'limit': limit.toString(),
      'offset': offset.toString(),
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      print(response.body);
      final jsonData = json.decode(response.body);
      return InventoryOutputResponse.fromJson(jsonData);
    } else {
      throw Exception('Error al cargar datos del API');
    }
  }
}
