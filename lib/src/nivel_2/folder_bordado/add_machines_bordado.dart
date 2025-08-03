import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '/src/datebase/methond.dart';
import '/src/nivel_2/folder_bordado/database_bordado/url_bordado.dart';
import '/src/widgets/loading.dart';

class AddMachinesBordados extends StatefulWidget {
  const AddMachinesBordados({Key? key}) : super(key: key);

  @override
  State<AddMachinesBordados> createState() => _AddMachinesBordadosState();
}

class _AddMachinesBordadosState extends State<AddMachinesBordados> {
  final _formKey = GlobalKey<FormState>();
  late String nombre;
  late String veloz;
  bool isLoading = false;

  Future sendData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      await httpRequestDatabase(insertMachine,
          {'machine': nombre, 'veloz': veloz, 'statu': 'RUNNING'});

      waitingTime(() {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('agregar Maquina Bordado')),
      body: isLoading
          ? const Loading(text: 'Registrando Maquina')
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(width: double.infinity),
                    BounceInDown(
                        child: Image.asset('assets/logo_app.png',
                            height: 200, width: 150)),
                    SlideInLeft(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1.0)),
                        width: 250,
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            labelText: 'Nombre Maquina',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 15),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor ingresa un nombre';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            nombre = value!;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SlideInLeft(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1.0)),
                        width: 250,
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            labelText: 'Velocidad',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 15),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor ingresa Speed';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            veloz = value!;
                          },
                          onEditingComplete: () => sendData(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    BounceInUp(
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Container(
                          width: 250,
                          height: 30,
                          color: Colors.white,
                          child: TextButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.resolveWith(
                                    (states) => const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero))),
                            onPressed: () => sendData(),
                            child: const Text('Agregar'),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        "©TejidoTropical ©copyright-2023 LuDeveloper",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
