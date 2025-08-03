import 'dart:convert';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../datebase/url.dart';
import '../../util/commo_pallete.dart';
import '../../util/helper.dart';
import '../../widgets/validar_screen_available.dart';
import 'model/printer_plan.dart';
import 'services/services_print_upload.dart';

class SubirImagenPage extends StatefulWidget {
  const SubirImagenPage({super.key, required this.item});
  final PrinterPlan item;

  @override
  State<SubirImagenPage> createState() => _SubirImagenPageState();
}

class _SubirImagenPageState extends State<SubirImagenPage> {
  File? _imagen;
  double _progreso = 0.0;
  final _idController = TextEditingController();
  int? _imagenSizeBytes;

  ServiceUploadPrint serviceUploadPrint = ServiceUploadPrint();

  @override
  void initState() {
    super.initState();
    _idController.text = widget.item.printerPlaningId.toString();
  }
  // final String ipLocal = "192.168.1.100"; // 🔁 Cambia por tu IP local o dominio

  Future<void> seleccionarImagen() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final sizeBytes = await file.length();
      setState(() {
        _imagen = file;
        _imagenSizeBytes = sizeBytes;
      });
    }
  }

  // Future<File?> comprimirImagen(File file) async {
  //   if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
  //     return file; // ❌ No se comprime en escritorio
  //   }

  //   final dir = await getTemporaryDirectory();
  //   final targetPath =
  //       "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

  //   final result = await FlutterImageCompress.compressAndGetFile(
  //     file.absolute.path,
  //     targetPath,
  //     quality: 60,
  //   );

  //   return result != null ? File(result.path) : null;
  // }

  Future<void> subirImagen() async {
    if (_imagen == null || _idController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Falta imagen o ID")),
      );
      return;
    }
    const maxSize = 2 * 1024 * 1024; // 1MB
    final bytes = await _imagen!.length();

    if (bytes > maxSize) {
      final sizeInKB = (bytes / 1024).toStringAsFixed(2);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("La imagen ($sizeInKB KB) supera el límite de 1MB")),
      );
      return;
    }

    final printerPlaningId = _idController.text.trim();
    // final imagenFinal = await comprimirImagen(_imagen!);
    // final nombreArchivo = p.basename(imagenFinal!.path);

    // final formData = FormData.fromMap({
    //   "printer_planing_id": printerPlaningId,
    //   "imagen": await MultipartFile.fromFile(imagenFinal.path,
    //       filename: nombreArchivo),
    // });

    final dio = Dio();

    try {
      // final response = await dio.post(
      //   "http://$ipLocal/settingmat/imagen_plan/uploads.php",
      //   data: formData,
      //   onSendProgress: (sent, total) {
      //     setState(() => _progreso = sent / total);
      //   },
      // );
      // final data =
      //     response.data is String ? jsonDecode(response.data) : response.data;

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //       content: Text(data["mensaje"] ?? "Subido con éxito"),
      //       backgroundColor: Colors.green),
      // );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al subir imagen")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sizeKB = _imagenSizeBytes != null
        ? (_imagenSizeBytes! / 1024).toStringAsFixed(2)
        : null;
    final size = MediaQuery.of(context).size;
    const curve = Curves.elasticInOut;
    final style = Theme.of(context).textTheme;
    String textPlain =
        "-Bordados -Serigrafía -Sublimación -Vinil -Uniformes deportivos y empresariales -Promociones y Más";
    return Scaffold(
        appBar: AppBar(title: const Text("Subir Imagen al Trabajo")),
        body: ValidarScreenAvailable(
          windows: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: double.infinity),
                      SizedBox(
                        width: 450,
                        child: Column(
                          children: [
                            if (_imagen != null)
                              Column(
                                children: [
                                  Image.file(_imagen!, height: 180),
                                  const SizedBox(height: 10),
                                  if (sizeKB != null)
                                    Text("Tamaño: $sizeKB KB",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600)),
                                ],
                              ),
                            if (_imagen != null)
                              LinearProgressIndicator(
                                value: _progreso,
                                minHeight: 8,
                                backgroundColor: Colors.grey.shade300,
                              ),
                            const SizedBox(height: 20),
                            if (_imagen != null)
                              customButton(
                                  onPressed: subirImagen,
                                  width: 250,
                                  colorText: Colors.white,
                                  colors: colorsGreenTablas,
                                  textButton: 'Subir al servidor'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Bounce(
                          curve: curve,
                          child: const Text('Nuevo Imagen !',
                              style: TextStyle(fontSize: 24, color: colorsAd)),
                        ),
                      ),
                      BounceInDown(
                          curve: curve,
                          child: Image.asset('assets/nube.png', scale: 5)),
                      FadeIn(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: 200,
                            child: Text(textPlain,
                                textAlign: TextAlign.center,
                                style: style.bodySmall
                                    ?.copyWith(color: Colors.grey)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      customButton(
                          onPressed: seleccionarImagen,
                          width: 250,
                          colorText: Colors.white,
                          colors: colorsAd,
                          textButton: 'Seleccionar Imagen'),
                      // const SizedBox(height: 15),
                      // printerProvider.isLoading
                      //     ? const Center(child: CircularProgressIndicator())
                      //     : customButton(
                      //         onPressed: () => send(printerProvider),
                      //         width: 250,
                      //         colorText: Colors.white,
                      //         colors: colorsAd,
                      //         textButton: 'Guardar'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
