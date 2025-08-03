import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../../datebase/url.dart';

class ServiceUploadPrint {
  // Future<XFile?> comprimirImagen(File file) async {
  //   final dir = await getTemporaryDirectory();
  //   final targetPath =
  //       "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

  //   final result = await FlutterImageCompress.compressAndGetFile(
  //       file.absolute.path, targetPath,
  //       quality: 60);

  //   return result;
  // }

  Future<void> subirImagenConId(File imagen, int printerPlaningId) async {
    // final imagenComprimida = await comprimirImagen(imagen);
    //   if (imagenComprimida == null) return;

    //   Dio dio = Dio();
    //   final nombreArchivo = p.basename(imagenComprimida.path);

    //   FormData formData = FormData.fromMap({
    //     "printer_planing_id": printerPlaningId.toString(),
    //     "imagen": await MultipartFile.fromFile(imagenComprimida.path,
    //         filename: nombreArchivo),
    //   });

    //   try {
    //     await dio.post(
    //       "http://$ipLocal/settingmat/imagen_plan/uploads.php",
    //       data: formData,
    //       onSendProgress: (sent, total) {
    //         // print("Progreso: ${(sent / total * 100).toStringAsFixed(1)}%");
    //       },
    //     );

    //     // print("Respuesta: ${response.data}");
    //   } catch (e) {
    //     // print("Error al subir: $e");
    //   }
  }
}
