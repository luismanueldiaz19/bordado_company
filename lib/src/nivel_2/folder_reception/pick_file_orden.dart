import 'dart:convert';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import '/src/util/helper.dart';
import '/src/widgets/loading.dart';
import '../../datebase/url.dart';

class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({super.key, required this.numOrden});
  final String numOrden;
  @override
  State createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends State<UploadFileScreen> {
  File? _selectedFile;
  final TextEditingController _fileNameController = TextEditingController();
  final TextEditingController _notaController = TextEditingController();
  String? _fileType;
  bool isUpLoading = false;

  // Seleccionar archivo usando FilePicker
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileNameController.text =
            result.files.single.name; // Nombre del archivo
        _fileType =
            result.files.single.extension; // Tipo del archivo (extensión)
      });
    }
  }

  // Subir archivo al servidor
  Future<void> _uploadFile(context) async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor seleccione un archivo.')),
      );
      return;
    }

    setState(() {
      isUpLoading = !isUpLoading;
    });

    String fileName = _fileNameController.text;
    String nota =
        _notaController.text.isEmpty ? 'Sin Comentario' : _notaController.text;
    String uploadUrl =
        'http://$ipLocal/settingmat/upload_file_orden/upload_file.php'; // Ajusta la URL

    Dio dio = Dio();

    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          _selectedFile!.path,
          filename: fileName,
        ),
        'file_name': fileName,
        'nota': nota,
        'file_type': _fileType ?? '',
        'numOrden': widget.numOrden,
      });

      Response response = await dio.post(
        uploadUrl,
        data: formData,
        onSendProgress: (int sent, int total) {
          print(
              "Progreso de subida: ${(sent / total * 100).toStringAsFixed(2)}%");

          updateProgress('${(sent / total * 100).toStringAsFixed(2)}%');
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.data);
        if (data['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message']),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message']),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al subir el archivo.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir el archivo: $e')),
      );
    } finally {
      setState(() {
        isUpLoading = false;
      });
    }
  }

  ValueNotifier<String> valueCargaNotifier = ValueNotifier<String>('0%');

  void updateProgress(String newValue) {
    valueCargaNotifier.value = newValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Subir documento'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isUpLoading
              ? Center(
                  child: ValueListenableBuilder<String>(
                    valueListenable: valueCargaNotifier,
                    builder: (context, valueCarga, child) {
                      return Loading(
                          imagen: 'assets/nube.png',
                          text: 'Espere por favor, subiendo ... $valueCarga');
                    },
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(width: double.infinity),
                    BounceInDown(
                      curve: Curves.elasticInOut,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.upload_file_outlined, size: 50),
                      ),
                    ),
                    SlideInLeft(
                      curve: Curves.elasticInOut,
                      child: buildTextFieldValidator(
                        label: 'Nombre del Archivo',
                        controller: _fileNameController,
                        readOnly: true,
                      ),
                    ),
                    const SizedBox(height: 5),
                    SlideInRight(
                      curve: Curves.elasticInOut,
                      child: buildTextFieldValidator(
                        label: 'nota (opcional)',
                        controller: _notaController,
                        hintText: 'Escribir nota',
                      ),
                    ),
                    const SizedBox(height: 20),
                    _selectedFile != null
                        ? ZoomIn(
                            curve: Curves.elasticInOut,
                            child: customButton(
                              onPressed: () => _uploadFile(context),
                              textButton: 'Subir Archivo',
                              colorText: Colors.white,
                              colors: Colors.green,
                            ),
                          )
                        : BounceInDown(
                            curve: Curves.elasticInOut,
                            child: customButton(
                              onPressed: _pickFile,
                              textButton: 'Seleccionar Archivo',
                              colorText: Colors.white,
                              colors: Colors.orange,
                            ),
                          ),
                  ],
                ),
        ));
  }
}
