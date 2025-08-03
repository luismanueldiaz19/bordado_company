import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '/src/datebase/methond.dart';
import '/src/util/commo_pallete.dart';

import '../datebase/url.dart';
import '../model/department.dart';
import '../nivel_2/folder_satreria/model/type_works.dart';
import '../widgets/dialog_get_deparment.dart';
import 'add_form_new_work.dart';

class MyWidgetDetailsPhotoView extends StatefulWidget {
  const MyWidgetDetailsPhotoView({super.key, required this.data});
  final TypeWorks data;

  @override
  State<MyWidgetDetailsPhotoView> createState() =>
      _MyWidgetDetailsPhotoViewState();
}

class _MyWidgetDetailsPhotoViewState extends State<MyWidgetDetailsPhotoView> {
  TextEditingController controllerUrlImagen = TextEditingController();
  TextEditingController controllerTypeWorkName = TextEditingController();

  @override
  void initState() {
    super.initState();
    controllerUrlImagen.text = widget.data.imageTypeWork ?? 'N/A';
    controllerTypeWorkName.text = widget.data.nameTypeWork ?? 'N/A';
  }

  void actualizarWorkType() async {
    var data = {
      'id': widget.data.idTypeWorkSastreria,
      'name_type_work': controllerTypeWorkName.text,
      'image_type_work': controllerUrlImagen.text
    };

    print(data);
    final res = await httpRequestDatabase(
        'http://$ipLocal/settingmat/admin/update/update_type_work_sastreria.php',
        data);
    print(res.body);
    var response = jsonDecode(res!.body);

    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(response['message']),
          duration: const Duration(seconds: 1)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(response['message']),
          duration: const Duration(seconds: 1)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final sized = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Container(
              alignment: Alignment.center,
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Hero(
                    tag: widget.data.idTypeWorkSastreria.toString(),
                    child: Center(
                      child: SizedBox(
                        child: CachedNetworkImage(
                          imageUrl: widget.data.imageTypeWork.toString(),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) {
                            return const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error, color: Colors.red),
                                Text(
                                  'Error al cargar la imagen',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            );
                          },
                          fit: BoxFit.cover,
                          height: sized.height / 5,
                          width: 250,
                        ),
                      ),
                    ),
                  )),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(1.0)),
            width: 250,
            child: TextField(
              controller: controllerTypeWorkName,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'Trabajo',
                label: Text('Escribir tipo'),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(1.0)),
            width: 250,
            child: TextField(
              keyboardType: TextInputType.text,
              controller: controllerUrlImagen,
              decoration: InputDecoration(
                hintText: 'Url Imagen',
                label: const Text('Url Imagen'),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 15),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 250,
            child: ElevatedButton(
              onPressed: actualizarWorkType,
              style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => colorsBlueTurquesa)),
              child: const Text('Actualizar',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
