// import 'dart:convert';
import 'dart:convert';

import 'package:http/http.dart' as http;

// 3u6Q!-D4WvXu7u Token
// http://$ipLocal/tu_prestamo/admin/insert/insert_client.php
class ApiService {
  // Método para realizar una solicitud GET
  Future<dynamic> getRequest(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error en la solicitud GET: ${response.reasonPhrase}');
    }
  }

  // Método para realizar una solicitud POST
  Future<dynamic> postRequest(String url, Map<String, dynamic> data) async {
    final response = await http.post(Uri.parse(url), body: data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception('Error en la solicitud POST: ${response.reasonPhrase}');
    }
  }

  // Método para realizar una solicitud PUT
  Future<dynamic> putRequest(String url, Map<String, dynamic> data) async {
    final response = await http.put(Uri.parse(url), body: data);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error en la solicitud PUT: ${response.reasonPhrase}');
    }
  }

  // Método para realizar una solicitud DELETE
  Future<void> deleteRequest(String url) async {
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Error en la solicitud DELETE: ${response.reasonPhrase}');
    }
  }

  Future httpEnviaMap(String url, var jsonData) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(jsonData),
    );

    print('response : ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception('Error en la solicitud POST: ${response.reasonPhrase}');
    }
  }
}
