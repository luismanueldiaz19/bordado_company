import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../datebase/current_data.dart';
import '../util/commo_pallete.dart';
import '../util/helper.dart';
import '/src/folder_admin_user/services_provider_users.dart';
import '/src/util/show_mesenger.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  late TextEditingController codeController;
  late TextEditingController nameController;

  late String _selectedCategory;
  late String _selectedCategoryTurno;

  @override
  void initState() {
    super.initState();
    _selectedCategory = 'Operador';
    _selectedCategoryTurno = 'Turno A';
    nameController = TextEditingController();
    codeController = TextEditingController();
  }

  String? ocupacionSeleccionada;

  void addNewUsuario(ServicesProviderUsers usersProvider) async {
    if (nameController.text.isNotEmpty && codeController.text.isNotEmpty) {
      var data = {
        'full_name': nameController.text,
        'occupation': _selectedCategory,
        'code': codeController.text,
        'turn': _selectedCategoryTurno,
      };

      String msj = await usersProvider.addUser(data);

      if (!context.mounted) return; // ✅ Verificamos que el widget siga activo
      nameController.clear();
      codeController.clear();
      showScaffoldMessenger(
          context, msj, Colors.black87); // Puedes usar el mensaje real
    } else {
      if (!context.mounted) return; // ✅ También aquí
      utilShowMesenger(context, 'Hay datos vacíos');
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider = context.read<ServicesProviderUsers>();
    final style = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Empleado')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(width: double.infinity, height: 20),
            BounceInRight(
              curve: Curves.elasticInOut,
              child: buildTextFieldValidator(
                label: 'Nombre Empleado',
                controller: nameController,
                hintText: 'Ejemplo: Juan Perez',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
                ],
              ),
            ),
            BounceInLeft(
              curve: Curves.elasticInOut,
              child: buildTextFieldValidator(
                label: 'Codigo Empleado',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                hintText: 'Ejemplo: 123456',
                controller: codeController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Óptiones de ocupación',
                  style: style.bodySmall?.copyWith(color: Colors.grey)),
            ),
            BounceInRight(
              child: Container(
                color: Colors.white,
                height: 50,
                width: 250,
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: DropdownButton<String>(
                  borderRadius: BorderRadius.zero,
                  isExpanded: true,
                  value: _selectedCategory,
                  padding: const EdgeInsets.only(left: 10),
                  items: ocupacionesList.map((category) {
                    return DropdownMenuItem<String>(
                        value: category, child: Text(category));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value.toString();
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Turnos Disponibles',
                  style: style.bodySmall?.copyWith(color: Colors.grey)),
            ),
            BounceInLeft(
              curve: Curves.elasticInOut,
              child: Container(
                color: Colors.white,
                height: 50,
                width: 250,
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: DropdownButton<String>(
                  value: _selectedCategoryTurno,
                  padding: const EdgeInsets.only(left: 10),
                  items: categoriesTurno.map((turnCategori) {
                    return DropdownMenuItem<String>(
                      value: turnCategori,
                      child: Text(turnCategori),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryTurno = value.toString();
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            BounceInUp(
              curve: Curves.elasticInOut,
              child: customButton(
                textButton: 'Agregar Usuario',
                onPressed: () => addNewUsuario(usersProvider),
                colorText: Colors.white,
                colors: colorsBlueDeepHigh,
              ),
            ),
            identy(context)
          ],
        ),
      ),
    );
  }
}
