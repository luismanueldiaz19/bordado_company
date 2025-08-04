import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/provider_department.dart';
import '/src/model/department.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/helper.dart';

class SelectedDepartments extends StatefulWidget {
  const SelectedDepartments({super.key, required this.pressDepartment});
  final Function(List<Department>) pressDepartment;

  @override
  State<SelectedDepartments> createState() => _SelectedDepartmentsState();
}

class _SelectedDepartmentsState extends State<SelectedDepartments> {
  List<Department> choosed = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    choosed = [];
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final provider = Provider.of<ProviderDepartment>(context);

    return AlertDialog(
      title: Text('Elegir Departamentos', style: style.titleMedium),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          provider.list.isNotEmpty
              ? SizedBox(
                  width: 250,
                  height: 350,
                  child: Material(
                    color: Colors.transparent,
                    child: ListView.builder(
                      itemCount: provider.list.length,
                      itemBuilder: (context, index) {
                        Department current = provider.list[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            tileColor: current.isSelected == true
                                ? Colors.white54
                                : Colors.transparent,
                            onTap: () {
                              setState(() {
                                current.isSelected =
                                    !(current.isSelected ?? false);
                                if (current.isSelected!) {
                                  choosed.add(current);
                                } else {
                                  choosed
                                      .removeWhere((d) => d.id == current.id);
                                }
                              });
                            },
                            title: Text(current.nameDepartment ?? 'Sin nombre',
                                style: style.bodySmall),
                            subtitle: Text(
                              current.isSelected == true ? 'Seleccionado' : '',
                              style: style.bodySmall?.copyWith(
                                color: colorsBlueDeepHigh,
                              ),
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
              style: TextStyle(color: Colors.red, fontSize: 12)),
        ),
        customButton(
          width: 150,
          onPressed: () {
            Navigator.pop(context);
            widget.pressDepartment(choosed); // Aquí puedes mandar vacía también
          },
          colorText: Colors.white,
          colors: colorsAd,
          textButton: 'Ya!',
        )
      ],
    );
  }
}
