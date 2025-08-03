import 'package:flutter/material.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/model/department.dart';
import '../util/commo_pallete.dart';
import '../widgets/dialog_get_deparment.dart';

class AddFormNewWork extends StatefulWidget {
  const AddFormNewWork({super.key});

  @override
  State<AddFormNewWork> createState() => _AddFormNewWorkState();
}

class _AddFormNewWorkState extends State<AddFormNewWork> {
  TextEditingController controllerUrlImagen = TextEditingController();
  TextEditingController controllerTypeWorkName = TextEditingController();
  Department? depart;
  bool isloading = false;
  addNew() async {
    if (depart != null &&
        controllerTypeWorkName.text.isNotEmpty &&
        controllerUrlImagen.text.isNotEmpty &&
        isValidUrl(controllerUrlImagen.text)) {
      setState(() {
        isloading = true;
      });
      var data = {
        'name_type_work': controllerTypeWorkName.text.toString(),
        'image_type_work': controllerUrlImagen.text,
        'area_work_sastreria': depart?.nameDepartment.toString(),
      };
      //insert_type_work_sastreria
      final res = await httpRequestDatabase(
          'http://$ipLocal/settingmat/admin/insert/insert_type_work_sastreria.php',
          data);
      print(res.body);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Agregar Nuevo')),
        body: Column(
          children: [
            const SizedBox(width: double.infinity, height: 5),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(1.0)),
              width: 250,
              height: 40,
              alignment: Alignment.center,
              child: TextButton(
                  onPressed: () async {
                    Department? res = await showDialog<Department>(
                        context: context,
                        builder: (context) {
                          return const DialogGetDeparment();
                        });
                    if (res != null) {
                      setState(() {
                        depart = res;
                      });
                    }
                  },
                  child: depart != null
                      ? Text(depart?.nameDepartment ?? 'N/A')
                      : const Text('Area/Departamento?')),
            ),
            const SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(1.0)),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(1.0)),
              width: 250,
              child: TextField(
                keyboardType: TextInputType.text,
                controller: controllerUrlImagen,
                decoration: InputDecoration(
                  hintText: 'Url Imagen',
                  label: const Text('Url Imagen'),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(left: 15),
                  errorText: controllerUrlImagen.text.isNotEmpty
                      ? !isValidUrl(controllerUrlImagen.text)
                          ? 'URL no válida'
                          : null
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            isloading
                ? const SizedBox(
                    width: 250,
                    child: Column(
                      children: [
                        LinearProgressIndicator(),
                        Text('Reportando .... Espere')
                      ],
                    ),
                  )
                : SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          addNew();
                        });
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => ktejidoBlueOcuro)),
                      child: const Text('Agregar Trabajo',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
            const SizedBox(height: 25),
            identy(context),
          ],
        ));
  }
}

bool isValidUrl(String url) {
  // Expresión regular para validar una URL
  final RegExp urlRegExp = RegExp(
      r"^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$");
  // Verifica si la cadena coincide con la expresión regular
  return urlRegExp.hasMatch(url);
}
