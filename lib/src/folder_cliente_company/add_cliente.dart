import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/src/datebase/methond.dart';
import '/src/widgets/mensaje_scaford.dart';

import '../datebase/url.dart';
import 'provider_clientes/provider_clientes.dart';

class AddClientForm extends StatefulWidget {
  const AddClientForm({super.key});

  @override
  State<AddClientForm> createState() => _AddClientFormState();
}

class _AddClientFormState extends State<AddClientForm> {
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
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Cliente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(width: double.infinity),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.0)),
                width: 250,
                child: TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(
                      labelText: 'Nombre *',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15)),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.0)),
                width: 250,
                child: TextField(
                  controller: apellidoController,
                  decoration: const InputDecoration(
                      labelText: 'Apellido *',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15)),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.0)),
                width: 250,
                child: TextField(
                  controller: direccionController,
                  decoration: const InputDecoration(
                    labelText: 'Dirección',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.0)),
                width: 250,
                child: TextField(
                  controller: telefonoController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.0)),
                width: 250,
                child: TextField(
                  controller: correoController,
                  decoration: const InputDecoration(
                    labelText: 'Infomacion Adicional',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.0)),
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    agregarCliente();
                  },
                  child: Text('Agregar Cliente'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
