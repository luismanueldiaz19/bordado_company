import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/model/department.dart';
import '/src/nivel_2/folder_confecion/model/url_confecion.dart';
import '/src/util/show_mesenger.dart';

class AddTrabajoConfeccion extends StatefulWidget {
  const AddTrabajoConfeccion({super.key, this.current});
  final Department? current;
  @override
  State<AddTrabajoConfeccion> createState() => _AddTrabajoConfeccionState();
}

class _AddTrabajoConfeccionState extends State<AddTrabajoConfeccion> {
  TextEditingController controllerOrden = TextEditingController();
  TextEditingController controllerLogo = TextEditingController();
  TextEditingController controllerFicha = TextEditingController();
  TextEditingController controllertipoTrabajo = TextEditingController();
  bool isloading = false;

  Future agregarWork() async {
    if (controllerLogo.text.isNotEmpty &&
        controllerOrden.text.isNotEmpty &&
        controllerFicha.text.isNotEmpty &&
        controllertipoTrabajo.text.isNotEmpty) {
      setState(() {
        isloading = true;
      });
      var data = {
        'id_depart': widget.current?.id,
        'id_user': currentUsers?.id,
        'num_orden': controllerOrden.text,
        'ficha': controllerFicha.text,
        'name_logo': controllerLogo.text,
        'tipo_trabajo': controllertipoTrabajo.text,
        'date_start': DateTime.now().toString().substring(0, 19),
        'date': DateTime.now().toString().substring(0, 10),
      };

      final res = await httpRequestDatabase(insertReportConfeccion, data);
      // print(res.body);
      controllerOrden.clear();
      controllerFicha.clear();
      controllerLogo.clear();
      controllertipoTrabajo.clear();

      if (res.body == 'good') {
        if (mounted) Navigator.pop(context, true);
      }
      // Provider.of<ProviderSastreria>(context, listen: false)
    } else {
      utilShowMesenger(context, 'Error Campos vacios');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar trabajo')),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.0)),
            width: 250,
            child: TextField(
              controller: controllerOrden,
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Num Orden',
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.0)),
            width: 250,
            child: TextField(
              controller: controllerFicha,
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Ficha',
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.0)),
            width: 250,
            child: TextField(
              controller: controllerLogo,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'Nombre Logo',
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.0)),
            width: 250,
            child: TextField(
              controller: controllertipoTrabajo,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'Tipo de Pieza',
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
              ),
            ),
          ),
          const SizedBox(height: 20),
          isloading
              ? const Text('Subiendo')
              : ElevatedButton(
                  onPressed: () => agregarWork(),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.white)),
                  child: const Text('Crear trabajos'),
                ),
          const SizedBox(height: 25)
        ],
      ),
    );
  }
}
