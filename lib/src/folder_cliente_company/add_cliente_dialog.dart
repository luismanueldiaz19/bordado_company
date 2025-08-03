import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/src/util/commo_pallete.dart';
import '/src/widgets/mensaje_scaford.dart';
import '../util/helper.dart';
import 'provider_clientes/provider_clientes.dart';

class AddClientDialog extends StatefulWidget {
  const AddClientDialog({super.key});

  @override
  State<AddClientDialog> createState() => _AddClientDialogState();
}

class _AddClientDialogState extends State<AddClientDialog> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();

  Future<void> agregarCliente() async {
    if (nombreController.text.isEmpty || apellidoController.text.isEmpty) {
      return;
    }
    var data = {
      'nombre': nombreController.text,
      'apellido': apellidoController.text,
      'direccion': direccionController.text.isNotEmpty
          ? direccionController.text
          : 'N/A',
      'telefono':
          telefonoController.text.isNotEmpty ? telefonoController.text : 'N/A',
      'correo_electronico':
          correoController.text.isNotEmpty ? correoController.text : 'N/A',
      'fecha_registro': DateTime.now().toString().substring(0, 10)
    };

    final mjs = await Provider.of<ClienteProvider>(context, listen: false)
        .addNewClient(data);

    if (!mounted) {
      return;
    }
    scaffoldMensaje(context: context, background: Colors.green, mjs: mjs);
    clearTextControllers();
    Navigator.pop(context, true);
  }

  void clearTextControllers() {
    nombreController.clear();
    apellidoController.clear();
    direccionController.clear();
    telefonoController.clear();
    correoController.clear();
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    direccionController.dispose();
    telefonoController.dispose();
    correoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return AlertDialog(
      title: Text('Agregar Cliente', style: style.labelLarge),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: double.infinity),
            buildTextFieldValidator(
              controller: nombreController,
              hintText: 'Escribir Nombre',
              label: 'Nombre  *',
            ),
            buildTextFieldValidator(
              controller: apellidoController,
              hintText: 'Escribir Apellido',
              label: 'Apellido  *',
            ),
            buildTextFieldValidator(
              controller: direccionController,
              hintText: 'Escribir Dirección',
              label: 'Dirección  (opcional)',
            ),
            buildTextFieldValidator(
              controller: telefonoController,
              hintText: 'Escribir Teléfono',
              label: 'Teléfono  (opcional)',
            ),
            buildTextFieldValidator(
              controller: correoController,
              hintText: 'Escribir un coreeo',
              label: 'coreeo  (opcional)',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
        ),
        customButton(
          width: 150,
          colorText: Colors.white,
          colors: colorsAd,
          textButton: 'Agregar Cliente',
          onPressed: agregarCliente,
        )
      ],
    );
  }
}
