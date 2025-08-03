import 'dart:convert';
import 'package:flutter/material.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/model/department.dart';
import '/src/util/font_style.dart';
import '/src/util/show_mesenger.dart';
import '/src/widgets/custom_app_bar.dart';

class ScreenDisenoAtencionCliente extends StatefulWidget {
  const ScreenDisenoAtencionCliente({Key? key, this.current}) : super(key: key);
  final Department? current;

  @override
  State<ScreenDisenoAtencionCliente> createState() =>
      _ScreenDisenoAtencionClienteState();
}

class _ScreenDisenoAtencionClienteState
    extends State<ScreenDisenoAtencionCliente> {
  String startWorked = '';
  String type = '';
  List typeWork = [];
  TextEditingController jobLogo = TextEditingController();

  Map<String, dynamic> data = {};
  sendWork() async {
    if (jobLogo.text.isNotEmpty && type.isNotEmpty) {
      data = {
        'descripcion': jobLogo.text.toUpperCase(),
        'type_worked': type,
        'date_start': startWorked,
        'date_end': DateTime.now().toString().substring(0, 19),
        'user_registed': currentUsers?.fullName,
      };
      print(data);
      //  insert_atencion_cliente_diseno
      String insertAtencionClienteDiseno =
          "http://$ipLocal/settingmat/admin/insert/insert_atencion_cliente_diseno.php";

      // insert_tipo_trabajo_diseno
      final res = await httpRequestDatabase(insertAtencionClienteDiseno, data);
      print(res.body.toString());
      if (res.body.toString().contains('good')) {
        setState(() {
          data = {};
          startWorked = '';
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

// select_tipo_trabajo_diseno
    final res = await httpRequestDatabase(selectType, {'view': 'view'});
    //  print(res.body);
    parsedData = json.decode(res.body).cast<Map<String, dynamic>>();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getTypeWork();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Diseño'),
          const SizedBox(height: 25),
          startWorked.isEmpty
              ? Hero(
                  tag: 'Atencion',
                  child: Container(
                    width: 200,
                    height: 200,
                    color: Colors.blue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                data['date_start'] = startWorked =
                                    DateTime.now().toString().substring(0, 19);
                                data['user_registed'] = currentUsers?.fullName;
                              });
                            },
                            child: const Icon(Icons.safety_divider_sharp,
                                size: 100, color: Colors.white)),
                        Material(
                          color: Colors.transparent,
                          child: Text(
                            'Realizar Atención',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: fontBalooPaaji),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
          const SizedBox(height: 25),
          startWorked.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.work),
                          title: Text(data['type_worked'] ??
                              'Selecionar Tipo de trabajos'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fecha de inicio: ${data['date_start']}',
                                style: const TextStyle(color: Colors.blue),
                              ),
                              Text(
                                  'Usuario registrado: ${data['user_registed']}'),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 250,
                          child: TextField(
                            onEditingComplete: () {
                              if (jobLogo.text.isNotEmpty) {
                                // _sendJobToServer(_jobController.text);
                                // Navigator.of(context).pop();
                              }
                            },
                            controller: jobLogo,
                            decoration: const InputDecoration(
                                hintText: 'Descripcion/LOGO'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => Colors.red)),
                            onPressed: () => sendWork(),
                            child: const Text('Terminar',
                                style: TextStyle(color: Colors.white))),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
          startWorked.isNotEmpty
              ? parsedData.isNotEmpty
                  ? Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await Future.delayed(const Duration(seconds: 2));
                          getTypeWork();
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 50, top: 20),
                          physics: const BouncingScrollPhysics(),
                          itemCount: parsedData.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      if (data['type_worked'] == null) {
                                        data['type_worked'] = parsedData[index]
                                                ['name_type_work']
                                            .toString();
                                        type = data['type_worked'];
                                      } else {
                                        data['type_worked'] =
                                            data['type_worked'] +
                                                ' ' +
                                                parsedData[index]
                                                        ['name_type_work']
                                                    .toString();
                                        type = data['type_worked'];
                                      }
                                    });
                                  },
                                  child: Text(
                                      parsedData[index]['name_type_work'])),
                            );
                          },
                        ),
                      ),
                    )
                  : const SizedBox()
              : const SizedBox(),
        ],
      ),
    );
  }
}
