import 'dart:convert';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/util/font_style.dart';

class ScreenImagen extends StatefulWidget {
  const ScreenImagen({super.key});

  @override
  State<ScreenImagen> createState() => _ScreenImagenState();
}

class _ScreenImagenState extends State<ScreenImagen> {
  ////////////Multi Imagen/////
  List<File> listFile = [];
  List<String> listBase64Imagen = [];

  /// en usos
  List<String> listFilename = [];
  final ImagePicker _picker = ImagePicker();
  /////////////////////////

  Future obtenerImage() async {
    final List<XFile> image = await _picker.pickMultiImage(imageQuality: 100);
    for (var element in image) {
      // base64Image = base64Encode(file.readAsBytesSync());
      // print('path de la imahgen ${element.path}');
      listFile.add(File(element.path));
      // print('Archivo : ${element.path}');
      File localfile = File(element.path);
      String localName = localfile.path.split('/').last;
      // print('localName $localName');
      listBase64Imagen.add(base64Encode(localfile.readAsBytesSync()));
      listFilename.add(localName);
      // await Future.delayed(const Duration(milliseconds: 100));
      print('Image added ${element.path}');
    }
    isMultiMedia = true;
    setState(() {});
  }

  Future sendMulpleImage(List listBase64Imagen, String idkey) async {
    print('Subiendo imagen .....');
    for (int i = 0; i < listBase64Imagen.length; i++) {
      // insertImageServer(listFilename[i].toString(), idkey);
      uploadImagen(listFilename[i].toString(), listBase64Imagen[i]);
    }
    // print('Exit Ciclo imagen');
    // setState(() {
    //   isLoadingFoto = false;
    //   isMultiMedia = false;
    // });
    // getImageServer();
  }

  Future uploadImagen(name, imagen) async {
    final res = await httpRequestDatabase(
        uploadimagenIncidenciaSublimacion, {'image': imagen, 'name': name});
    debugPrint('resquest  de la imagen ${res.body}');
    await Future.delayed(const Duration(milliseconds: 300));
  }

  /////metodo de insert el path de la imagen //////
  Future insertImageServer(String path, String key) async {
    await httpRequestDatabase(insertImagePathFileIncidencia, {
      'image_path': path,
      'id_key_image': key,
      'date_current': DateTime.now().toString().substring(0, 19),
    });
  }

  FilePickerResult? result;

  Future pickeFileWindow() async {
    result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        dialogTitle: 'Select a file for our App',
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png']);

    if (result == null) return;

    for (PlatformFile file in result!.files) {
      File localfile = File(file.path!);
      String localName = file.name;
      // print('localName $localName');
      listBase64Imagen.add(base64Encode(localfile.readAsBytesSync()));
      listFilename.add(localName);
      print('Image added ${file.path}');
    }
    isMultiMedia = true;
    setState(() {});
  }

  /////los validator de image Picked
  bool isMultiMedia = false;
  bool isLoadingFoto = false;
  bool idSendingData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subir Imagen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BounceInDown(
              child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            child: SizedBox(
              height: 100,
              width: 200,
              child: TextButton.icon(
                label: isMultiMedia
                    ? const Text('Correcto',
                        style: TextStyle(color: Colors.green))
                    : const Text('Foto'),
                icon: isMultiMedia
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      )
                    : const Icon(Icons.camera),
                onPressed: Platform.isWindows
                    ? () => pickeFileWindow()
                    : () => obtenerImage(),
              ),
            ),
          )),
          const SizedBox(height: 15),
          BounceInRight(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: SizedBox(
                width: 250,
                child: TextButton(
                  onPressed: () => sendMulpleImage(listBase64Imagen, '199512'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.green),
                  ),
                  child: Text(
                    isMultiMedia ? 'Enviar ' : 'No Completo',
                    style: TextStyle(
                        color: Colors.white, fontFamily: fontBalooPaaji),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
