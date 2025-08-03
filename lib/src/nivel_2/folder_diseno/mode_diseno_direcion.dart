import 'package:flutter/material.dart';
import '/src/datebase/current_data.dart';
import '/src/model/department.dart';
import '/src/nivel_2/folder_diseno/folder_atencion_cliente/dialog_type.dart';
import '/src/nivel_2/folder_diseno/folder_atencion_cliente/record_atencion_cliente.dart';
import '/src/nivel_2/folder_diseno/folder_trabajo_diseno/add_trabajo_diseno.dart';
import '/src/nivel_2/folder_diseno/folder_trabajo_diseno/screen_trabajos_diseno.dart';
import '/src/widgets/custom_app_bar.dart';

import '../../util/font_style.dart';
import 'folder_atencion_cliente/screen_diseno_atencion_cliente.dart';

class ModeDisenoDirecion extends StatefulWidget {
  const ModeDisenoDirecion({super.key, this.current});
  final Department? current;

  @override
  State<ModeDisenoDirecion> createState() => _ModeDisenoDirecionState();
}

class _ModeDisenoDirecionState extends State<ModeDisenoDirecion> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Diseño'),
          const SizedBox(height: 50),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                  bottom: size.height * 0.30, left: 50, right: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ScreenDisenoAtencionCliente(
                                                current: widget.current)));
                              },
                              child: const Icon(Icons.work_outline_rounded,
                                  size: 100, color: Colors.white)),
                          Material(
                            color: Colors.transparent,
                            child: Text(
                              'Atención al cliente',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: fontBalooPaaji),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    width: 200,
                    height: 200,
                    color: Colors.brown,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Historial',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: fontBalooPaaji),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const RecordAtencionCliente()));
                          },
                          child: const Icon(Icons.calendar_month_outlined,
                              size: 100, color: Colors.white),
                        ),
                        Text(
                          'Atención al cliente',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: fontBalooPaaji),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Hero(
                    tag: 'Diseño',
                    child: Container(
                      width: 200,
                      height: 200,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AddTrabajoDiseno()));
                            },
                            icon: const Icon(Icons.design_services_outlined,
                                size: 100, color: Colors.white),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: Text(
                              'Trabajar Diseños',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: fontBalooPaaji),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    width: 200,
                    height: 200,
                    color: Colors.deepPurple,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Historial',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: fontBalooPaaji),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ScreenTrabajosDiseno()));
                          },
                          child: const Icon(Icons.library_books_rounded,
                              size: 100, color: Colors.white),
                        ),
                        Text(
                          'Trabajos Diseños',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: fontBalooPaaji),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  currentUsers?.occupation == OptionAdmin.admin.name ||
                          currentUsers?.occupation == OptionAdmin.master.name ||
                          currentUsers?.occupation == OptionAdmin.boss.name
                      ? Container(
                          width: 200,
                          height: 200,
                          color: Colors.black,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return JobDialog();
                                      },
                                    );
                                  },
                                  child: const Icon(Icons.add_box_outlined,
                                      size: 100, color: Colors.white)),
                              Text(
                                'Agregar Tipo\nTrabajos',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: fontBalooPaaji),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
