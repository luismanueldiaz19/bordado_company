import 'package:flutter/material.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/model/department.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/helper.dart';

class SelectedDepartments extends StatefulWidget {
  const SelectedDepartments({super.key, required this.pressDepartment});
  final Function pressDepartment;
  @override
  State<SelectedDepartments> createState() => _SelectedDepartmentsState();
}

class _SelectedDepartmentsState extends State<SelectedDepartments> {
  List<Department> list = [];
  List choosed = [];
  Future getDepartmentNiveles() async {
    final res = await httpRequestDatabase(selectDepartment, {'view': 'view'});
    list = departmentFromJson(res.body);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // date = DateTime.now().toString().substring(0, 10);
    getDepartmentNiveles();
    // getNiveles();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return AlertDialog(
      title: Text('Elegir Departamentos', style: style.titleMedium),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          list.isNotEmpty
              ? SizedBox(
                  width: 250,
                  height: 350,
                  child: Material(
                    color: Colors.transparent,
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        Department current = list[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            tileColor: current.isSelected!
                                ? Colors.white54
                                : Colors.transparent,
                            onTap: () {
                              setState(() {
                                current.isSelected = !current.isSelected!;
                                if (current.isSelected!) {
                                  choosed.add(current.nameDepartment);
                                } else {
                                  choosed.remove(current.nameDepartment);
                                }
                              });
                            },
                            title: Text(current.nameDepartment.toString(),
                                style: style.bodySmall),
                            subtitle: Text(
                              current.isSelected! ? 'Seleccionado' : '',
                              style: style.bodySmall
                                  ?.copyWith(color: colorsBlueDeepHigh),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : const Text('Espere, cargando lista.'),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: const Text('Cancelar',
                style: TextStyle(color: Colors.red, fontSize: 12))),
        customButton(
            width: 150,
            onPressed: () {
              Navigator.pop(context);
              widget.pressDepartment(choosed);
            },
            colorText: Colors.white,
            colors: colorsAd,
            textButton: 'Ya!')
      ],
    );
  }
}
