import 'package:flutter/material.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/model/department.dart';

class DialogGetDeparment extends StatefulWidget {
  const DialogGetDeparment({super.key});

  @override
  State<DialogGetDeparment> createState() => _DialogGetDeparmentState();
}

class _DialogGetDeparmentState extends State<DialogGetDeparment> {
  List<Department> listDepartment = [];
  Department? departmentCurrent;
// List<TypeWorks> typeWorksFromJson(
  Future getDepartments() async {
    final res = await httpRequestDatabase(selectDepartment, {'view': 'view'});
    listDepartment = departmentFromJson(res.body);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDepartments();
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
              Navigator.pop(context, departmentCurrent);
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
          listDepartment.isNotEmpty
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.50,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: listDepartment
                          .map((item) => Container(
                                color: departmentCurrent == item
                                    ? Colors.blue.shade100
                                    : Colors.white,
                                width: 200,
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        departmentCurrent = item;
                                      });
                                    },
                                    child: Text(item.nameDepartment ?? 'N/A')),
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
