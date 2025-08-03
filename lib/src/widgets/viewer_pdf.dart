import 'package:flutter/material.dart';

// import 'package:pdfrx/pdfrx.dart';

class ViewerPdf extends StatefulWidget {
  const ViewerPdf({super.key, required this.pdfUrl});
  final String? pdfUrl;

  @override
  State<ViewerPdf> createState() => _ViewerPdfState();
}

class _ViewerPdfState extends State<ViewerPdf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visor PDF'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text('PDF no disponible'),
            ),
          ),
        ],
      ),

      // PdfViewer.uri(
      //   Uri.parse(widget.pdfUrl!),
      //   params: PdfViewerParams(
      //     enableTextSelection: true, // Para seleccionar texto
      //     viewerOverlayBuilder: (context, size, handleLinkTap) => [
      //       const CircularProgressIndicator(), // Indicador de carga
      //     ],
      //   ),
      // ),
    );
  }
}
