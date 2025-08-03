import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../datebase/url.dart';

class UploadService {
  Future<String> uploadImage(File imageFile, String id, String nameFile) async {
    var uri = Uri.parse(
        "http://$ipLocal/settingmat/admin/imagen_serigrafias/upload.php");
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: nameFile,
      ))
      ..fields['id_serigrafia_work_finished'] = id;
    try {
      var streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        var responseBody = await streamedResponse.stream.bytesToString();
        return 'Respuesta del servidor PHP: $responseBody';
      } else {
        return 'Error al cargar la imagen. Código de estado: ${streamedResponse.statusCode}';
      }
    } catch (e) {
      return 'Error al cargar la imagen: $e';
    }
  }
}
