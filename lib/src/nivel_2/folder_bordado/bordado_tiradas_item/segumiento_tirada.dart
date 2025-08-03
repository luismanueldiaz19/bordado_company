import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/src/datebase/current_data.dart';
import '/src/nivel_2/folder_bordado/model/bordado_report.dart';
import '/src/nivel_2/folder_bordado/model/bordoda_tirada.dart';
import '/src/nivel_2/folder_bordado/database_bordado/url_bordado.dart';
import '/src/util/show_mesenger.dart';

import '../../../datebase/methond.dart';
import '../../../util/commo_pallete.dart';
import '../../../util/dialog_confimarcion.dart';
import '../../../util/get_time_relation.dart';
import '../../../widgets/widget_comentario.dart';
import '../../folder_reception/file_view_orden.dart';
import '../provider/provider_bordado.dart';
import '../provider/provider_bordado_tirada.dart';

class SeguimientoTiradaBordado extends StatefulWidget {
  const SeguimientoTiradaBordado({super.key, required this.item});
  final BordadoReport item;

  @override
  State<SeguimientoTiradaBordado> createState() =>
      _SeguimientoTiradaBordadoState();
}

class _SeguimientoTiradaBordadoState extends State<SeguimientoTiradaBordado> {
  Future updateFromComment(id, comment) async {
    await httpRequestDatabase(
        updateBordadoReportedComment, {'id': id, 'comment': comment});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProviderBordadoTirada>(context, listen: false)
          .getTirada(widget.item.idKeyUnique);
    });
  }

  updateItem(BordadoTirada item) async {
    item.idKeyUnique = widget.item.idKeyUnique;

    String mjs =
        await Provider.of<ProviderBordadoTirada>(context, listen: false)
            .updateTiradaV2(item.toJson(), widget.item.idKeyUnique);
    if (!mounted) {
      return;
    }
    await Provider.of<ProvideBordado>(context, listen: false)
        .getProducionCurrently();
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mjs.toString())));
  }

  updateItemTime(BordadoTirada item) async {
    item.idKeyUnique = widget.item.idKeyUnique;
    String mjs =
        await Provider.of<ProviderBordadoTirada>(context, listen: false)
            .updateTiradaV2Time(item.toJson(), widget.item.idKeyUnique);
    if (!mounted) {
      return;
    }
    await Provider.of<ProvideBordado>(context, listen: false)
        .getProducionCurrently();
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mjs.toString())));
  }

  void updateTirada(BordadoTirada item, listTirada) async {
    // print('Cantida de la orden ${widget.item.cantOrden}');
    // print('Cantida de la eleborada ${widget.item.cantElabored}');
    item.idKeyUnique = widget.item.idKeyUnique;
    String? valueCant = await showDialog<String>(
        context: context,
        builder: (context) {
          return AddComentario(
            text: 'Qty Realizada',
            textInputType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
            ],
            textFielName: 'Qty : ',
          );
        });

    if (valueCant != null) {
      //Provider.of<ProviderBordadoTirada>(context, listen: false)
      final cant = BordadoTirada.getTotalElaborada(listTirada);
      double result = double.parse(cant) + double.parse(valueCant);
      // print('Resultado $result');
      // print('Orden ${widget.item.cantOrden}');
      if (result > double.parse(widget.item.cantOrden ?? '0')) {
        if (!mounted) {
          return;
        }
        return getMensajeWidget(
            context, 'Cantidad Es Mayor al Cantidad de la orden',
            text: 'Error de Cantidad');
      } else {
        item.cantElabored = valueCant;
        item.fechaEnd = DateTime.now().toString().substring(0, 19);
        await updateItem(item);
        await updateItemTime(item);
      }
    }
  }

  void updateTiradaBad(BordadoTirada item) async {
    item.idKeyUnique = widget.item.idKeyUnique;
    item.status = 'f';
    String? valueCant = await showDialog<String>(
        context: context,
        builder: (context) {
          return AddComentario(
            text: 'Qty Defectuosa',
            textInputType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
            ],
            textFielName: 'Qty : ${item.cantBad}',
          );
        });

    if (valueCant != null) {
      item.cantBad = valueCant;

      await updateItem(item);
      // await updateItem(item);
    }
  }

  void updateTiradaTimeEnd(BordadoTirada item) async {
    item.idKeyUnique = widget.item.idKeyUnique;
    await showDialog(
        context: context,
        builder: (_) {
          return ConfirmacionDialog(
            mensaje:
                'Esta seguro de reportar el tiempo de Qty : ${item.cantElabored} Piezas?',
            titulo: 'Aviso Importante',
            onConfirmar: () async {
              item.fechaEnd = DateTime.now().toString().substring(0, 19);
              Navigator.of(context).pop();
              await updateItemTime(item);
            },
          );
        });
  }

  agregarTiradaMethond() async {
    await showDialog(
        context: context,
        builder: (_) {
          return ConfirmacionDialog(
            mensaje: 'Esta seguro de Iniciar?',
            titulo: 'Aviso Importante',
            onConfirmar: () async {
              var data = {
                'id_user': currentUsers?.id,
                'id_key_unique': widget.item.idKeyUnique,
                'cant_elabored': '0',
                'fecha_started': DateTime.now().toString().substring(0, 19),
                'cant_bad': '0',
              };
              if (!mounted) {
                return;
              }
              await Provider.of<ProviderBordadoTirada>(context, listen: false)
                  .sendTirada(data);
              if (!mounted) {
                return;
              }
              await Provider.of<ProvideBordado>(context, listen: false)
                  .getProducionCurrently();
              if (!mounted) {
                return;
              }

              Navigator.of(context).pop();
            },
          );
        });
  }

  bool comprobarTirada(List<BordadoTirada> list) {
    if (list.isEmpty) {
      print('lista esta vacio se puede publicar');
      return true;
    }
    if (double.parse(list.first.cantElabored ?? '0') > 0) {
      print('ultimo numero de la lista  ${list.first.cantElabored}');
      print('la cantidad es menor a 0');
      return true;
    }

    print('no se puede publicar');
    return false;
  }

  //update_bordado_reported_finished

  updateFinished() async {
    await showDialog(
        context: context,
        builder: (_) {
          return ConfirmacionDialog(
            mensaje: 'Esta Seguro de Terminar Esta Orden?',
            titulo: 'Aviso Importante',
            onConfirmar: () async {
              var data = {
                'id_key_unique': widget.item.idKeyUnique,
                'is_finished': 't',
                'fecha_general_end': DateTime.now().toString().substring(0, 19)
              };

              await Provider.of<ProviderBordadoTirada>(context, listen: false)
                  .updateItemFinished(data, widget.item.idKeyUnique);
              if (!mounted) {
                return;
              }
              await Provider.of<ProvideBordado>(context, listen: false)
                  .getProducionCurrently();
              if (!mounted) {
                return;
              }
              Navigator.pop(context);
              Navigator.of(context).pop();
            },
          );
        });
    if (!mounted) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerTirada =
        Provider.of<ProviderBordadoTirada>(context, listen: true);
    final style = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Seguimiento de Tiradas')),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          providerTirada.listTirada.isNotEmpty
              ? Expanded(
                  child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    child: DataTable(
                      dataRowMaxHeight: 20,
                      dataRowMinHeight: 15,
                      headingRowHeight: 20,
                      headingTextStyle: style.titleSmall,
                      dataTextStyle: style.bodySmall,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 205, 208, 221),
                            Color.fromARGB(255, 225, 228, 241),
                            Color.fromARGB(255, 233, 234, 238),
                          ],
                        ),
                      ),
                      border: TableBorder.symmetric(),
                      columns: const [
                        DataColumn(label: Text('Empleado')),
                        DataColumn(label: Text('#.Orden')),
                        DataColumn(label: Text('Fichas')),
                        DataColumn(label: Text('Logo')),
                        DataColumn(label: Text('Qty Orden')),
                        DataColumn(label: Text('Qty Realizado')),
                        DataColumn(label: Text('Qty Defectuosa')),
                        DataColumn(label: Text('Fecha Inicial')),
                        DataColumn(label: Text('Fecha Final')),
                        DataColumn(label: Text('Tiempos')),
                        DataColumn(label: Text('Comentarios')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: providerTirada.listTirada
                          .map(
                            (item) => DataRow(
                              color: MaterialStateProperty.resolveWith(
                                  (states) => BordadoTirada.getColorComparar(
                                      item, providerTirada.currentSelected)),
                              cells: [
                                DataCell(Text(item.fullName ?? '')),
                                DataCell(Text(item.numOrden ?? ''), onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (conext) => FileViewer(
                                            numOrden: item.numOrden)),
                                  );
                                }),
                                DataCell(Text(item.ficha ?? '')),
                                DataCell(Text(item.nameLogo ?? '')),
                                DataCell(Text(item.cantOrden ?? '',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text(item.cantElabored ?? ''),
                                    onTap: BordadoTirada.validadNumber(
                                            item.cantElabored ?? '0')
                                        ? () => updateTirada(
                                            item, providerTirada.listTirada)
                                        : null),
                                DataCell(Text(item.cantBad ?? ''),
                                    onTap: !BordadoTirada.validadNumber(
                                            item.cantElabored ?? '0')
                                        ? BordadoTirada.validadNumber(
                                                item.cantBad ?? '0')
                                            ? () => updateTiradaBad(item)
                                            : null
                                        : null),
                                DataCell(Text(item.fechaStarted ?? '')),
                                DataCell(Text(item.fechaEnd ?? '')),
                                DataCell(Text(getTimeRelation(
                                    item.fechaStarted ?? 'N/A',
                                    item.fechaEnd ?? 'N/A'))),
                                DataCell(
                                    SizedBox(
                                      width: 150,
                                      child: Text(item.comment ?? ''),
                                    ), onTap: () {
                                  utilShowMesenger(context, item.comment ?? '');
                                }),
                                DataCell(
                                  Text(validarSupervisor()
                                      ? 'Eliminar'
                                      : 'No suport'),
                                  onTap: () => eliminarOTirada(item),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ))
              : const Expanded(child: Center(child: Text('No hay Tiradas'))),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 15, top: 10, left: 25, right: 25),
            child: SizedBox(
              height: 35,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.item.isFinished == 'f'
                        ? SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) => Colors.green)),
                              onPressed: () {
                                if (comprobarTirada(
                                    providerTirada.listTirada)) {
                                  agregarTiradaMethond();
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                      'Es obligatorio terminar la tirada correspondientes',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                  ));
                                }
                              },
                              child: Text('Agregar tirada',
                                  style: style.bodySmall
                                      ?.copyWith(color: Colors.white)),
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(width: 10),
                    widget.item.isFinished == 'f'
                        ? SizedBox(
                            width: 100,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => colorsBlueTurquesa)),
                                onPressed: () {
                                  if (comprobarTirada(
                                      providerTirada.listTirada)) {
                                    updateFinished();
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                        'Es obligatorio terminar la tirada correspondientes /Eliminar la tirada no realizada',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                },
                                child: Text('Terminar',
                                    style: style.bodySmall
                                        ?.copyWith(color: Colors.white))),
                          )
                        : const SizedBox(),
                    // const SizedBox(width: 10),
                    // SizedBox(
                    //   width: 100,
                    //   child: ElevatedButton(
                    //       style: ButtonStyle(
                    //           backgroundColor:
                    //               MaterialStateProperty.resolveWith(
                    //                   (states) => colorsRed)),
                    //       onPressed: () async {},
                    //       child: Text(
                    //           widget.item.isPause == 'f'
                    //               ? 'Continuar'
                    //               : 'Pausar',
                    //           style: style.bodySmall
                    //               ?.copyWith(color: Colors.white))),
                    // )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SizedBox(
              height: 35,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      height: 35,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Qty Tiradas : ', style: style.bodySmall),
                              const SizedBox(width: 10),
                              Text(providerTirada.listTirada.length.toString(),
                                  style: style.bodySmall?.copyWith(
                                      color: Colors.brown,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 35,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Qty Realizados : ', style: style.bodySmall),
                              const SizedBox(width: 10),
                              Text(
                                  BordadoTirada.getTotalElaborada(
                                      providerTirada.listTirada),
                                  style: style.bodySmall?.copyWith(
                                      color: Colors.brown,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 35,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Qty Defectuosos: ', style: style.bodySmall),
                              const SizedBox(width: 10),
                              Text(
                                  BordadoTirada.getTotalBad(
                                      providerTirada.listTirada),
                                  style: style.bodySmall?.copyWith(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          identy(context)
        ],
      ),
    );
  }

  ///////este eliminar los item de una orden completa///
  Future eliminarOTirada(BordadoTirada item) async {
    if (validarSupervisor()) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConfirmacionDialog(
            mensaje: '❌❌Esta Seguro de Eliminar❌❌',
            titulo: 'Aviso',
            onConfirmar: () async {
              await httpRequestDatabase(deleteBordadoTirada, {'id': item.id});
              if (!mounted) {
                return;
              }
              Provider.of<ProviderBordadoTirada>(context, listen: false)
                  .getTirada(widget.item.idKeyUnique);
              if (!mounted) {
                return;
              }
              await Provider.of<ProvideBordado>(context, listen: false)
                  .getProducionCurrently();
              if (!mounted) {
                return;
              }
              Navigator.of(context).pop();
              // providerTirada.listTirada.removeWhere((item) => item.id == id);
              // getTirada();
            },
          );
        },
      );
    }
  }
}

// Future statuMethond(PlanificacionItem? current, {required String statu}) async {
//   var data = {
//     'id': current?.isKeyUniqueProduct,
//     'statu': statu,
//   };
//   final res = await httpRequestDatabase(updatePlanificacionLastStatu, data);
//   // print(res.body);
//   if (res.body.toString() == 'good') {}
// }

// bool comparaTime(DateTime time1) {
//   // Creamos las dos fechas a comparar
//   // DateTime fecha1 = DateTime(2022, 5, 1);
//   DateTime fecha2 = DateTime.now();
//   DateTime soloFecha = DateTime(fecha2.year, fecha2.month, fecha2.day - 1);
//   // debugPrint('Fecha de Entrega es : $soloFecha comparar con $fecha2');
//   // print('La fecha soloFecha $soloFecha');
//   if (soloFecha.isBefore(time1)) {
//     // print(true);
//     return true;
//   } else {
//     // print(false);
//     return false;
//   }

// // // Comparamos las fechas
//   // if (time1.isAfter(soloFecha)) {
//   //   print('Ya se cumplio la fecha');
//   //   print(true);
//   //   return true;
//   // }
//   // return false;
// }
