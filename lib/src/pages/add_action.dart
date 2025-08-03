import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/model/department.dart';
import '/src/util/show_mesenger.dart';
import '/src/widgets/custom_app_bar.dart';

class AddAction extends StatefulWidget {
  const AddAction({super.key});

  @override
  State<AddAction> createState() => _AddActionState();
}

class _AddActionState extends State<AddAction> {
  late TextEditingController? addTypeWorked;
  List<Department> list = [];
  String idKeyWork = '';
  bool isPhotoTake = false;
  List<File> listFile = [];
  List<String> listBase64Imagen = [];

  /// en usos
  List<String> listFilename = [];
  final ImagePicker _picker = ImagePicker();

  Future getDepartmentNiveles() async {
    final res = await httpRequestDatabase(selectDepartment, {'view': 'view'});
    debugPrint('departamentos:  ${res.body}');
    list = departmentFromJson(res.body);
    setState(() {
      idKeyWork = list.first.idKeyWork.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getDepartmentNiveles();

    addTypeWorked = TextEditingController();
  }

  Future sendImagen() async {
    if (addTypeWorked!.text.isNotEmpty && isPhotoTake) {
      var data = {
        'type_work': addTypeWorked?.text,
        'image_path': listFilename[0],
      };

      await httpRequestDatabase(insertTypeWork, data);
    } else {
      utilShowMesenger(context, 'Falta el nombre de la Acción Photo');
    }
  }

  Future obtenerImage() async {
    // print(Platform.isWindows);
    if (Platform.isWindows) {
      return pickeFileWindow();
    }

    if (Platform.isAndroid) {
      return pickedAndroid();
    }
  }

  Future pickedAndroid() async {
    final List<XFile> image = await _picker.pickMultiImage(imageQuality: 80);

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
    }
    isPhotoTake = true;
    setState(() {});
  }

  //////////////is Window picked image ///////
  ///
  FilePickerResult? result;
  Future pickeFileWindow() async {
    result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        dialogTitle: 'Select a file for our App',
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'png',
        ]);

    if (result == null) return;

    for (PlatformFile file in result!.files) {
      File localfile = File(file.path!);
      String localName = file.name;
      // print('localName $localName');
      listBase64Imagen.add(base64Encode(localfile.readAsBytesSync()));
      listFilename.add(localName);
      // print('Archivo : $listFilename');
    }
    isPhotoTake = true;
    setState(() {});
  }

  /////metodo de insert el path de la imagen //////
  Future insertWorkType() async {
    var data = {
      'type_work': addTypeWorked?.text,
      'image_path': listFilename[0],
      'id_key': idKeyWork,
    };
    // print(data);
    final res = await httpRequestDatabase(insertTypeWork, data);
    print('Listo tyep work ${res.body}');
    sendMulpleImage(listBase64Imagen);
  }

  Future sendMulpleImage(List listBase64Imagen) async {
    for (int i = 0; i < listBase64Imagen.length; i++) {
      await httpRequestDatabase(uploadimagen, {
        'image': '${listBase64Imagen[i]}',
        'name': listFilename[i],
        // 'token': appTOKEN,
      });
    }

    isPhotoTake = false;
    // getImageServer();
    listFilename.clear();
    listBase64Imagen.clear();
  }

  bool isSelectedDepart = false;
  @override
  Widget build(BuildContext context) {
    // TargetPlatform platform = Theme.of(context).platform;

    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Agregar tipo de trabajo'),
          const SizedBox(height: 30),
          SizedBox(
            height: 120,
            width: MediaQuery.of(context).size.width * 0.95,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: list
                    .map((e) => GestureDetector(
                          onTap: () {
                            isSelectedDepart = true;
                            idKeyWork = e.idKeyWork.toString();
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(15.0),
                              child: SizedBox(
                                height: 100,
                                width: 150,
                                child: Column(
                                  children: [
                                    Text(e.nameDepartment ?? 'N/A'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          isSelectedDepart
              ? Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.40,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: TextField(
                        controller: addTypeWorked,
                        textInputAction: TextInputAction.none,
                        onEditingComplete: () {},
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            border: InputBorder.none,
                            hintText: 'Escribir acción'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    isPhotoTake
                        ? const SizedBox()
                        : TextButton.icon(
                            onPressed: () => obtenerImage(),
                            icon: const Icon(Icons.photo_camera_outlined),
                            label: const Text('Tomar Foto/Subir'),
                          ),
                    const SizedBox(height: 10),
                    isPhotoTake
                        ? ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => Colors.green),
                            ),
                            onPressed: () => insertWorkType(),
                            child: const Text('Agregar'),
                          )
                        : const SizedBox(),
                  ],
                )
              : const Text('Elegir un departamento')
        ],
      ),
    );
  }
}
