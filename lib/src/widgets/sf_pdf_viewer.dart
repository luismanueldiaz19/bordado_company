import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PDFViewerPage extends StatefulWidget {
  const PDFViewerPage({super.key, required this.pdfUrl});
  final String? pdfUrl;

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  Future<String?> downloadFile(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();
        final file = File("${dir.path}/temp.pdf");
        await file.writeAsBytes(bytes, flush: true);
        return file.path;
      } else {
        throw Exception('Error al descargar el archivo');
      }
    } catch (e) {
      print("Error descargando el PDF: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FutureBuilder<String?>(
        future: downloadFile(widget.pdfUrl!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Error al cargar el PDF'));
          } else {
            return PDFView(
              filePath: snapshot.data!,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
            );
          }
        },
      ),
    );
  }
}
