import 'dart:io';
import 'package:http/http.dart' as http;

import '../datebase/url.dart';

class UploadService {
  Future<String> uploadImageIncidencia(
      File imageFile, String id, String nameFile, String comment) async {
    var uri = Uri.parse(
        "http://$ipLocal/settingmat/incidencia_imagen/upload_imagen_insidencia.php");
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: nameFile,
      ))
      ..fields['id_list_incidencia'] = id
      ..fields['comentario'] = comment;
    try {
      var streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        var responseBody = await streamedResponse.stream.bytesToString();
        // print('responseBody : $responseBody');/
        return responseBody;
      } else {
        return 'Error al cargar la imagen. Código de estado: ${streamedResponse.statusCode}';
      }
    } catch (e) {
      return 'Error al cargar la imagen: $e';
    }
  }

  //delete_imagen_incidencia
}
