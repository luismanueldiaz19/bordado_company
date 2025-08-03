// import 'dart:io';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/widgets.dart';

// class PdfApi {
//   static Future<File> saveDocument({
//     required String name,
//     required Document pdf,
//   }) async {
//     final bytes = await pdf.save();
//     final dir = await getApplicationDocumentsDirectory();
//     final file = File('${dir.path}/$name');
//     await file.writeAsBytes(bytes);
//     return file;
//   }

//   static Future openFile(File file) async {
//     final url = file.path;
//     await OpenFile.open(url);
//   }

//   // bool canOpen(String filePath) {
//   //   return OpenFile.canOpen(filePath);
//   // }
// }
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
// import 'package:universal_html/html.dart' as html;

// import 'dart:typed_data';

class PdfApi {
  // static Future<File> saveDocument({
  //   required String name,
  //   required Document pdf,
  // }) async {
  //   final bytes = await pdf.save();
  //   final dir = await getApplicationDocumentsDirectory();
  //   final file = File('${dir.path}/$name');
  //   await file.writeAsBytes(bytes);
  //   return file;
  // }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    // print('Saving PDF to: ${dir.path}'); // Para depurar
    final file = File('${dir.path}/$name');

    // Verifica si el directorio existe
    if (!(await dir.exists())) {
      await dir.create(recursive: true);
    }

    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}

//   static Future openOrDownloadFile({
//     required File file,
//     required bool isWeb,
//   }) async {
//     if (isWeb) {
      
//       final bytes = await file.readAsBytes();
//       final blob = html.Blob([bytes]);
//       final url = html.Url.createObjectUrlFromBlob(blob);
//       final anchor = html.AnchorElement(href: url)
//         ..setAttribute('download', 'File_reports')
//         ..click();
//       html.Url.revokeObjectUrl(url);
//     } else {
//       // Abrir el archivo en un entorno no web (por ejemplo, dispositivos móviles)
//       // Utiliza un paquete como 'open_file' para abrir el archivo en lugar de descargarlo
//       // Ejemplo:
//       // await OpenFile.open(file.path);
//     }
//   }
// }

// class PdfApiWeb {
//   static Future<void> saveAndDownloadDocument({
//     required String name,
//     required Document pdf,
//   }) async {
//     final Uint8List bytes = await pdf.save();
//     final blob = html.Blob([bytes]);
//     final url = html.Url.createObjectUrlFromBlob(blob);
//     final anchor = html.AnchorElement(href: url)
//       ..setAttribute('download', name)
//       ..click();
//     html.Url.revokeObjectUrl(url);
//   }
// }