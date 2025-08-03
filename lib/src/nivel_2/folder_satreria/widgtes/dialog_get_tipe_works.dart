import 'package:flutter/material.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/model/department.dart';
import '/src/nivel_2/folder_satreria/model/type_works.dart';

class DialogGetTipeWorks extends StatefulWidget {
  const DialogGetTipeWorks({super.key, this.current});
  final Department? current;

  @override
  State<DialogGetTipeWorks> createState() => _DialogGetTipeWorksState();
}

class _DialogGetTipeWorksState extends State<DialogGetTipeWorks> {
  List<TypeWorks> listDetypeWorks = [];
  TypeWorks? typeWorkCurrent;
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
    final style = Theme.of(context).textTheme;
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      title: Text('Elegir el Tipo de trabajos', style: style.bodyMedium),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: Text('Cancelar')),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context, typeWorkCurrent);
            },
            child: Text('Elegir')),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Container(
          //     color: Colors.white,
          //     height: 50,
          //     width: 200,
          //     child: TextField(
          //       keyboardType: TextInputType.number,
          //       onChanged: (val) {
          //         // _seachingItem(val);
          //       },
          //       decoration: const InputDecoration(
          //           hintText: 'Buscar',
          //           border: InputBorder.none,
          //           contentPadding: EdgeInsets.only(left: 15.0)),
          //     )),
          listDetypeWorks.isNotEmpty
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.50,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: listDetypeWorks
                          .map((item) => Container(
                                color: typeWorkCurrent == item
                                    ? Colors.blue.shade100
                                    : Colors.white,
                                width: 200,
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        typeWorkCurrent = item;
                                      });
                                    },
                                    child: Text(item.nameTypeWork ?? 'N/A')),
                              ))
                          .toList(),
                    ),
                  ),
                )
              : const Center(child: Text('No Hay Data'))
        ],
      ),
    );
  }
}
