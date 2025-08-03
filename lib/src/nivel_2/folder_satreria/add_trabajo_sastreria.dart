import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/model/department.dart';
import '/src/nivel_2/folder_confecion/model/url_confecion.dart';
import '/src/nivel_2/folder_satreria/model/type_works.dart';
import '/src/nivel_2/folder_satreria/widgtes/dialog_get_tipe_works.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/show_mesenger.dart';

import 'provider/provider_sastreria.dart';
import 'widgtes/imagen_widget_tipo_work.dart';

class AddTrabajoSastreria extends StatefulWidget {
  const AddTrabajoSastreria({super.key, this.current});
  final Department? current;
  @override
  State<AddTrabajoSastreria> createState() => _AddTrabajoSastreriaState();
}

class _AddTrabajoSastreriaState extends State<AddTrabajoSastreria> {
  TextEditingController controllerOrden = TextEditingController();
  TextEditingController controllerLogo = TextEditingController();
  TextEditingController controllerFicha = TextEditingController();
  final firstDate = DateTime.now().toString().substring(0, 10);
  bool isloading = false;
  TypeWorks? typeWorkCurrent;
  Future agregarWork() async {
    if (controllerLogo.text.isNotEmpty &&
        controllerOrden.text.isNotEmpty &&
        controllerFicha.text.isNotEmpty) {
      setState(() {
        isloading = true;
      });
      var data = {
        'id_depart': widget.current?.id,
        'id_user': currentUsers?.id,
        'num_orden': controllerOrden.text,
        'ficha': controllerFicha.text,
        'name_logo': controllerLogo.text,
        'tipo_trabajo': typeWorkCurrent?.nameTypeWork.toString(),
        'date_start': DateTime.now().toString().substring(0, 19),
        'date': DateTime.now().toString().substring(0, 10),
      };

      // print(data);
      final res = await httpRequestDatabase(insertReportSastreria, data);

      controllerOrden.clear();
      controllerFicha.clear();
      controllerLogo.clear();
      typeWorkCurrent = null;
      Provider.of<ProviderSastreria>(context, listen: false)
          .getWork(firstDate, firstDate, widget.current?.id);
      if (res.body == 'good') {
        if (mounted) Navigator.pop(context, true);
      }
    } else {
      utilShowMesenger(context, 'Error Campos vacios');
    }
  }

  List<TypeWorks> listDetypeWorks = [];
// List<TypeWorks> typeWorksFromJson(
  Future getTypeWork() async {
    // listDeliverys.clear();
    final res = await httpRequestDatabase(
        'http://$ipLocal/settingmat/admin/select/select_type_work_sastreria.php',
        {'area_work_sastreria': widget.current?.nameDepartment});
    // print('Sastreria type works :  ${res.body}');
    listDetypeWorks = typeWorksFromJson(res.body);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getTypeWork();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar trabajo sastreria')),
      body: typeWorkCurrent == null
          ? Column(
              children: [
                const SizedBox(width: double.infinity, height: 5),
                Text(
                  'Trabajos Disponibles.',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: ktejidoBlueOcuro),
                ),
                Text(
                  'Deslizar hacia abajo para refrescar la lista!',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: ktejidogrey),
                ),
                // const Divider(endIndent: 50, indent: 50),
                const SizedBox(height: 10),
                Expanded(
                  child: SizedBox(
                    width: 350,
                    child: RefreshIndicator(
                      onRefresh: getTypeWork,
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: listDetypeWorks.length,
                        itemBuilder: (context, index) {
                          TypeWorks current = listDetypeWorks[index];
                          return ListTile(
                            title: Text(current.nameTypeWork ?? 'N/A'),
                            subtitle: Text(current.areaWorkSastreria ?? 'N/A'),
                            leading: ConstrainedBox(
                              constraints: const BoxConstraints(
                                  maxHeight: 150,
                                  maxWidth: 150,
                                  minHeight: 100,
                                  minWidth: 10),
                              child: MyWidgetImagen(
                                  imageUrl: current.imageTypeWork ?? 'N/A'),
                            ),
                            onTap: () {
                              setState(() {
                                typeWorkCurrent = current;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
                identy(context)
              ],
            )
          : Column(
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
                        setState(() {
                          typeWorkCurrent = null;
                        });
                      },
                      child: typeWorkCurrent != null
                          ? Text(
                              '${typeWorkCurrent?.nameTypeWork ?? 'N/A'} (Quitar)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis)
                          : const Text('Tipo de trabajo?')),
                ),
                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(1.0)),
                  width: 250,
                  child: TextField(
                    controller: controllerLogo,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'Nombre del logo',
                      label: Text('Nombre del logo'),
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
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    controller: controllerOrden,
                    decoration: const InputDecoration(
                      hintText: 'Num Orden',
                      label: Text('Num Orden'),
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
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    controller: controllerFicha,
                    decoration: const InputDecoration(
                      hintText: 'Ficha',
                      label: Text('Ficha'),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15),
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
                          onPressed: () => agregarWork(),
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
            ),
    );
  }
}
