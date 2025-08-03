import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/model/users.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/helper.dart';
import '../datebase/current_data.dart';

class EdittingUsers extends StatefulWidget {
  const EdittingUsers({super.key, this.userEdit});
  final Users? userEdit;

  @override
  State<EdittingUsers> createState() => _EdittingUsersState();
}

class _EdittingUsersState extends State<EdittingUsers> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerCodigo = TextEditingController();
  TextEditingController controllerAreas = TextEditingController();
  String? _selectedCategory;
  String? _selectedCategoryTurno;

  @override
  void initState() {
    super.initState();
    controllerName.text = widget.userEdit?.fullName ?? 'N/A';
    controllerCodigo.text = widget.userEdit?.code ?? 'N/A';
    controllerAreas.text = widget.userEdit?.type ?? 'a';
    // Asegúrate de que el valor de _selectedCategory esté en la lista categories
    _selectedCategory = ocupacionesList.contains(widget.userEdit?.occupation)
        ? widget.userEdit?.occupation ?? 'Operador'
        : 'Operador'; // Default value
    // Asegúrate de que el valor de _selectedCategoryTurno esté en la lista categoriesTurno
    _selectedCategoryTurno = categoriesTurno.contains(widget.userEdit?.turn)
        ? widget.userEdit?.turn ?? 'turno A'
        : 'turno A'; // Default value
  }

  Future updateFrom() async {
    var data = {
      'id': widget.userEdit?.id,
      'full_name': controllerName.text,
      'occupation': _selectedCategory,
      'turn': _selectedCategoryTurno,
      'code': controllerCodigo.text,
      'type': controllerAreas.text
    };

    // print(widget.userEdit?.toJson());
    // print(data);
    String url = "http://$ipLocal/settingmat/admin/update/update_users.php";
    final res = await httpRequestDatabase(url, data);

    var response = jsonDecode(res!.body);
    if (response['success']) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(response['message']),
          duration: const Duration(seconds: 1)));
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(response['message']),
          duration: const Duration(seconds: 1)));
    }
  }

  Future deleteFrom() async {
    final res = await httpRequestDatabase(
        'http://$ipLocal/settingmat/admin/delete/delete_users.php',
        {'id': widget.userEdit?.id});

    // print(res.body);

    var response = jsonDecode(res!.body);
    if (response['success']) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(response['message']),
          duration: const Duration(seconds: 1)));
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(response['message']),
          duration: const Duration(seconds: 1)));
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Usuario a editar : ${widget.userEdit?.toJson()}');
    const curve = Curves.elasticInOut;
    final style = Theme.of(context).textTheme;
    String textPlain =
        "-Bordados -Serigrafía -Sublimación -Vinil -Uniformes deportivos y empresariales -Promociones y Más";
    return Scaffold(
      appBar: AppBar(title: const Text('Editar usuario')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(width: double.infinity, height: 25),
            SlideInRight(
              curve: curve,
              child: buildTextFieldValidator(
                controller: controllerName,
                hintText: 'Escribir Nombre',
                label: 'Logo',
              ),
            ),
            SlideInLeft(
              curve: curve,
              child: buildTextFieldValidator(
                controller: controllerCodigo,
                hintText: 'Escribir Codigo',
                label: 'Codigo',
              ),
            ),
            SlideInRight(
              curve: curve,
              child: buildTextFieldValidator(
                controller: controllerAreas,
                hintText: 'Escribir Area',
                label: 'Area',
              ),
            ),
            const SizedBox(height: 5),
            SlideInLeft(
              curve: curve,
              child: Container(
                width: 250,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: DropdownButtonHideUnderline(
                    // Elimina la línea del Dropdown
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedCategory,
                      items: ocupacionesList.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Center(
                              child: Text(
                                  category)), // Centrar el texto de cada ítem
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value.toString();
                          widget.userEdit?.occupation = value.toString();
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SlideInRight(
              curve: curve,
              child: Container(
                width: 250,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategoryTurno,
                      isExpanded: true,
                      items: categoriesTurno.map((turnCategori) {
                        return DropdownMenuItem<String>(
                          alignment: Alignment.center,
                          value: turnCategori,
                          child: Text(turnCategori),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryTurno = value.toString();
                          widget.userEdit?.turn = value.toString();
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            customButton(
                onPressed: updateFrom,
                width: 250,
                colorText: Colors.white,
                colors: colorsGreenLevel,
                textButton: 'Actualizar'),
            const SizedBox(height: 10),
            TextButton(
                onPressed: deleteFrom,
                child:
                    const Text('Eliminar', style: TextStyle(color: Colors.red)))
          ],
        ),
      ),
    );
  }
}
