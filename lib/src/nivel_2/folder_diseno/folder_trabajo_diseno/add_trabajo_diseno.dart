import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/util/font_style.dart';
import '/src/util/show_mesenger.dart';
import '/src/widgets/custom_app_bar.dart';

class AddTrabajoDiseno extends StatefulWidget {
  const AddTrabajoDiseno({Key? key}) : super(key: key);

  @override
  State<AddTrabajoDiseno> createState() => _AddTrabajoDisenoState();
}

class _AddTrabajoDisenoState extends State<AddTrabajoDiseno> {
  String startWorked = '';
  String type = '';
  List typeWork = [];
  TextEditingController numOrden = TextEditingController();
  TextEditingController ficha = TextEditingController();
  TextEditingController logoController = TextEditingController();
  TextEditingController cantController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  Map<String, dynamic> data = {};
  sendWork() async {
    if (cantController.text.isNotEmpty &&
        type.isNotEmpty &&
        numOrden.text.isNotEmpty &&
        ficha.text.isNotEmpty &&
        logoController.text.isNotEmpty) {
      //       $ficha = $_POST['ficha'];
      // $num_orden = $_POST['num_orden'];
      data = {
        'num_orden': numOrden.text.toString(),
        'ficha': ficha.text.toString(),
        'logo': logoController.text.toLowerCase(),
        'cantidad': cantController.text.toUpperCase(),
        'comment': commentController.text.isNotEmpty
            ? commentController.text.toUpperCase()
            : 'N/A',
        'type_worked': type,
        'date_start': startWorked,
        'date_end': DateTime.now().toString().substring(0, 19),
        'user_registed': currentUsers?.fullName,
      };
      print(data);
      //  insert_atencion_cliente_diseno
      String insertTrabajoDiseno =
          "http://$ipLocal/settingmat/admin/insert/insert_trabajo_diseno.php";

      // insert_tipo_trabajo_diseno
      final res = await httpRequestDatabase(insertTrabajoDiseno, data);
      // print(res.body.toString());
      if (res.body.toString().contains('good')) {
        setState(() {
          data = {};
          startWorked = '';
          cantController.clear();
          numOrden.clear();
          ficha.clear();
          commentController.clear();
        });
      }
    } else {
      utilShowMesenger(
          context, 'Error Campo Vacio /Type de trabajo no selecionado',
          title: 'Error');
    }
  }

  Future addTypeWork(String type) async {}
  List<Map<String, dynamic>> parsedData = [];
  Future getTypeWork() async {
    String selectType =
        "http://$ipLocal/settingmat/admin/select/select_tipo_trabajo_diseno.php";

    //select_tipo_trabajo_diseno
    final res = await httpRequestDatabase(selectType, {'view': 'view'});
    //print(res.body);
    parsedData = json.decode(res.body).cast<Map<String, dynamic>>();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getTypeWork();
  }

  @override
  void dispose() {
    super.dispose();
    cantController.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Diseño'),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.only(left: 55),
            child: Row(
              children: [
                Hero(
                  tag: 'Diseño',
                  child: Container(
                    width: 100,
                    height: 75,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.bottomRight,
                        transform: GradientRotation(15),
                        colors: [
                          Color.fromARGB(255, 115, 180, 117),

                          Color.fromARGB(255, 184, 124, 119),
                          // Colors.teal,
                          Color.fromARGB(255, 47, 127, 192),
                          Color.fromARGB(255, 202, 171, 124),
                          Color.fromARGB(255, 125, 180, 127),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  data['date_start'] = startWorked =
                                      DateTime.now()
                                          .toString()
                                          .substring(0, 19);
                                  data['user_registed'] =
                                      currentUsers?.fullName;
                                });
                              },
                              icon: const Icon(Icons.computer_outlined,
                                  size: 20, color: Colors.white)),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: Text(
                            'Trabajar',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: fontBalooPaaji),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          startWorked.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'Fecha de inicio: ${data['date_start']}',
                          style: const TextStyle(color: Colors.blue),
                        ),
                        SizedBox(
                          width: 250,
                          child: TextField(
                            controller: logoController,
                            decoration: const InputDecoration(hintText: 'LOGO'),
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 250,
                          child: TextField(
                            controller: numOrden,
                            decoration:
                                const InputDecoration(hintText: 'Num Orden'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 250,
                          child: TextField(
                            controller: ficha,
                            decoration:
                                const InputDecoration(hintText: 'Ficha'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 250,
                          child: TextField(
                            controller: cantController,
                            decoration:
                                const InputDecoration(hintText: 'Cantidad'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 250,
                          child: TextField(
                            onEditingComplete: () {
                              if (commentController.text.isNotEmpty) {
                                sendWork();
                              }
                            },
                            controller: commentController,
                            decoration:
                                const InputDecoration(hintText: 'Comentario'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => Colors.red)),
                            onPressed: () => sendWork(),
                            child: const Text('Terminar',
                                style: TextStyle(color: Colors.white)))
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
          Text(data['type_worked'] ?? 'Selecionar Tipo de trabajos',
              style: const TextStyle(color: Colors.brown, fontSize: 20)),
          SizedBox(
            height: 75,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                  children: parsedData
                      .map((item) => Container(
                            color: Colors.blue,
                            height: 50,
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (data['type_worked'] == null) {
                                      data['type_worked'] =
                                          item['name_type_work'].toString();
                                      type = data['type_worked'];
                                    } else {
                                      data['type_worked'] =
                                          data['type_worked'] +
                                              ' ' +
                                              item['name_type_work'].toString();
                                      type = data['type_worked'];
                                    }
                                  });
                                },
                                child: Text(item['name_type_work'],
                                    style:
                                        const TextStyle(color: Colors.white))),
                          ))
                      .toList()),
            ),
          )
        ],
      ),
    );
  }
}
