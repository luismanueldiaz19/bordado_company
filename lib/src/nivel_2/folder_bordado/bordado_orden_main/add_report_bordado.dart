import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/nivel_2/folder_bordado/model/machine_bordado.dart';
import '/src/nivel_2/folder_bordado/database_bordado/url_bordado.dart';
import '/src/nivel_2/folder_bordado/provider/provider_bordado.dart';

import '/src/widgets/loading.dart';

import '../get_dialog_machine.dart';

class AddReportBordado extends StatefulWidget {
  const AddReportBordado({Key? key}) : super(key: key);

  @override
  State<AddReportBordado> createState() => _AddReportBordadoState();
}

class _AddReportBordadoState extends State<AddReportBordado> {
  MachineBordado? currentMaquina;
  final _formKey = GlobalKey<FormState>();
  List<MachineBordado> machineBordado = [];
  bool isLoading = false;
  late String logo;
  late String ficha;
  late String cantOrden;
  late String cantElab;
  late String numOrden;
  late String puntada;

  Future sendData() async {
    if (_formKey.currentState!.validate() && currentMaquina != null) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      // Aquí puedes hacer algo con los datos ingresados, como enviarlos a un servidor o guardarlos localmente
      var numKey = Random();
      var data = {
        'id_key_unique': numKey.nextInt(999999999).toString(),
        'user_worked': currentUsers?.id.toString(),
        'name_logo': logo,
        'num_orden': numOrden,
        'ficha': ficha,
        'cant_orden': cantOrden,
        'cant_elabored': '0',
        'puntada': puntada,
        'id_machine': currentMaquina!.idMachine,
        'fecha_general_started': DateTime.now().toString().substring(0, 19)
      };

      await httpRequestDatabase(insertBordadoReported, data);
      if (!mounted) {
        return;
      }
      await Provider.of<ProvideBordado>(context, listen: false)
          .getProducionCurrently();
      waitingTime(() {
        if (mounted) Navigator.pop(context, true);
      });
    }
  }

  Future deleteFrom(MachineBordado maq) async {
    await httpRequestDatabase(
        deleteBordadoMachine, {'id': maq.idMachine.toString()});
    machineBordado.remove(maq);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Trabajos')),
      body: isLoading
          ? const Loading(text: 'Registrando Trabajos')
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    BounceInDown(
                        child: Image.asset('assets/logo_app.png',
                            height: 150, width: 150)),
                    const SizedBox(width: double.infinity, height: 1),
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () async {
                          MachineBordado? res =
                              await showDialog<MachineBordado>(
                                  context: context,
                                  builder: (context) {
                                    return const DialogGetMachine();
                                  });
                          if (res != null) {
                            setState(() {
                              currentMaquina = res;
                            });
                          }
                        },
                        child: currentMaquina != null
                            ? Text(currentMaquina?.machine ?? 'N/A')
                            : const Text('QUE MAQUINA ?'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1.0)),
                      width: 250,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Nombre del logo',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 15),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingresa un nombre para el logo';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          logo = value!;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1.0)),
                      width: 250,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Puntada LOGO',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 15),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingresa un nombre para el logo';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          puntada = value!;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1.0)),
                      width: 250,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Número de orden',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 15),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingresa un número de orden';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          numOrden = value!;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1.0)),
                      width: 250,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Ficha',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 15),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingresa una ficha';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          ficha = value!;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1.0)),
                      width: 250,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Cantidad de la orden',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 15),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingresa una cantidad de orden';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          cantOrden = value!;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () => sendData(),
                        child: const Text('Crear'),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}





// Form(
//       key: _formKey,
//       child: Column(
//         children: [
         
//         ],
//       ),
//     );
  