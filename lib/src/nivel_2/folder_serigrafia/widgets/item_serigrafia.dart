import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/model/department.dart';
import '/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
import '/src/util/commo_pallete.dart';

import '../../../folder_incidencia_main/add_incidencia_main_desde_work.dart';
import '../../../util/dialog_confimarcion.dart';
import '../../../widgets/mensaje_scaford.dart';
import '../add_make_report_serigrafia.dart';
import '../editting_Item_serigrafia.dart';
import '../provider/provider_serigrafia.dart';

class MyWidgetItemSerigrafia extends StatefulWidget {
  const MyWidgetItemSerigrafia({super.key, required this.current});
  final Sublima current;

  @override
  State<MyWidgetItemSerigrafia> createState() => _MyWidgetItemSerigrafiaState();
}

class _MyWidgetItemSerigrafiaState extends State<MyWidgetItemSerigrafia> {
  void updateTime() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmacionDialog(
          mensaje: actionMjs,
          titulo: 'Aviso',
          onConfirmar: () async {
            updateDateStart(widget.current);
            Navigator.of(context).pop();
            scaffoldMensaje(
                context: context, background: Colors.green, mjs: 'Listo');
            // Navigator.pop(context);
          },
        );
      },
    );
  }

  Future deleteFromSerigrafia(context1) async {
    if (validarSupervisor()) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConfirmacionDialog(
            mensaje: eliminarMjs,
            titulo: 'Aviso',
            onConfirmar: () async {
              Navigator.of(context).pop();
              Provider.of<ProviderSerigrafia>(context1, listen: false)
                  .eliminarItem(widget.current);
            },
          );
        },
      );
    } else {
      scaffoldMensaje(
          context: context,
          background: Colors.orange,
          mjs: 'No Tiene Permiso 🥺🥺🥺');
    }
  }

  void addTestIncidencia() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddIncidenciaMainDesdeWork(
          orden: widget.current,
          pickedDepart:
              Department(nameDepartment: widget.current.nameDepartment),
        ),
      ),
    );
  }

  void finishedOrden() async {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) {
          return AddMakeReportSerigrafia(current: widget.current);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void edittingOrden() async {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) {
          return EdittingItemSerigrafia(item: widget.current);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  Future updateDateStart(Sublima current) async {
    setState(() {
      current.dateStart = DateTime.now().toString().substring(0, 19);
    });
    var data = {
      'date_start': DateTime.now().toString().substring(0, 19),
      'id': current.id
    };
    final res = await httpRequestDatabase(updateSerigrafiaWorkDateStart, data);
    print('updateDateStart ${res.body}');

    // Provider.of<ProviderSerigrafia>(context, listen: false).getWork(id);
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: finishedOrden,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Hero(
                      tag: widget.current.id.toString(),
                      child: CircleAvatar(
                        backgroundColor: ktejidoBlueOcuro,
                        child: Text(
                            widget.current.nameLogo
                                .toString()
                                .substring(0, 1)
                                .toUpperCase(),
                            style: style.labelLarge
                                ?.copyWith(color: Colors.white)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(widget.current.nameLogo ?? 'N/A',
                        style: style.labelLarge),
                    subtitle: Text('# : ${widget.current.numOrden ?? 'N/A'}',
                        style: style.bodySmall),
                    trailing: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_horiz_sharp),
                      onSelected: (value) async {
                        // Manejar la opción seleccionada aquí
                        print('Opción seleccionada: $value');
                        if (value == 'Eliminar') {
                          await deleteFromSerigrafia(context);
                        }

                        if (value == 'Incidencia') {
                          addTestIncidencia();
                        }
                        if (value == 'Terminar') {
                          finishedOrden();
                        }

                        if (value == 'Editar') {
                          edittingOrden();
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'Terminar',
                          child: ListTile(
                            leading: Icon(Icons.stop, color: Colors.black),
                            title: Text('Terminar'),
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Editar',
                          child: ListTile(
                            leading: Icon(Icons.edit_note, color: Colors.black),
                            title: Text('Editar'),
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Incidencia',
                          child: ListTile(
                            leading: Icon(Icons.add_reaction_outlined,
                                color: Colors.orange),
                            title: Text('Agregar Incidencia'),
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Eliminar',
                          child: ListTile(
                            leading: Icon(Icons.delete, color: Colors.red),
                            title: Text('Eliminar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Operador :'),
                  Text('Qty Orden :'),
                  Text('Tipo Trabajo :'),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.current.fullName ?? 'N/A'),
                  Text(widget.current.cantOrden ?? 'N/A'),
                  Text(widget.current.nameWork ?? 'N/A'),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3),
                        child: Icon(Icons.timer_outlined,
                            color: colorsGreenLevel, size: 15),
                      ),
                      Text('Inició :',
                          style: TextStyle(color: colorsGreenLevel)),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.current.dateStart ?? 'N/A',
                      style: const TextStyle(
                          color: colorsGreenLevel,
                          fontWeight: FontWeight.w500)),
                  IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: updateTime),
                ],
              ),
            ],
          ),
          const Spacer(),
          Container(
            decoration: const BoxDecoration(color: ktejidogrey),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Numero de ficha',
                    style: style.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    widget.current.ficha ?? '0',
                    style: style.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
