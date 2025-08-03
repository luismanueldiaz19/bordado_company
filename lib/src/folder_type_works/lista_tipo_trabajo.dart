import 'package:flutter/material.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/folder_type_works/add_form_new_work.dart';
import '/src/folder_type_works/details_photo_view.dart';
import '/src/nivel_2/folder_satreria/model/type_works.dart';
import '/src/nivel_2/folder_satreria/widgtes/imagen_widget_tipo_work.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/helper.dart';

class ListaTipoTrabajos extends StatefulWidget {
  const ListaTipoTrabajos({super.key});

  @override
  State<ListaTipoTrabajos> createState() => _ListaTipoTrabajosState();
}

class _ListaTipoTrabajosState extends State<ListaTipoTrabajos> {
  List<TypeWorks> listDetypeWorks = [];
  TypeWorks? typeWorkCurrent;
// List<TypeWorks> typeWorksFromJson(
  Future getTypeWork() async {
    final res = await httpRequestDatabase(
        'http://$ipLocal/settingmat/admin/select/select_type_work_sastreria_all.php',
        {'area_work_sastreria': 'area_work_sastreria'});
    // print('select_type_work_sastreria_all:  ${res.body}');
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
    final style = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Tipo de trabajos')),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          Expanded(
            child: SizedBox(
              width: 350,
              child: RefreshIndicator(
                onRefresh: getTypeWork,
                child: ListView.builder(
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
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, __, child) {
                                  return MyWidgetDetailsPhotoView(
                                      data: current);
                                },
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                      opacity: animation, child: child);
                                },
                              ),
                            );
                          },
                          child: Hero(
                            tag: current.idTypeWorkSastreria.toString(),
                            child: MyWidgetImagen(
                                imageUrl: current.imageTypeWork ?? 'N/A'),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          customButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddFormNewWork()),
                );
              },
              textButton: 'Agregar Nuevo',
              colorText: Colors.white,
              colors: colorsAd),
          identy(context),
        ],
      ),
    );
  }
}
