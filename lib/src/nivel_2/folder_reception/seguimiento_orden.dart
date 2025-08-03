import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screen_print_pdf/apis/pdf_api.dart';
import '/src/datebase/current_data.dart';
import '/src/nivel_2/folder_planificacion/url_planificacion/url_planificacion.dart';
import '/src/nivel_2/folder_reception/add_item_orden.dart';
import '/src/nivel_2/folder_reception/provider_reception_planificacion.dart';
import '/src/nivel_2/tabla_indentifiacion_action/indentificacion_action.dart';
import '/src/util/show_mesenger.dart';
import '../../datebase/methond.dart';
import '../../datebase/url.dart';
import '../../model/users.dart';
import '../../util/commo_pallete.dart';
import '../../widgets/custom_comment_widget.dart';
import '../folder_planificacion/model_planificacion/item_planificacion.dart';
import '../folder_planificacion/model_planificacion/planificacion_last.dart';
import '../folder_re_orden/add_reorden.dart';
import 'file_view_orden.dart';
import 'print_reception/print_orden_cliente_interno.dart';

class SeguimientoOrden extends StatefulWidget {
  const SeguimientoOrden({super.key, required this.item});
  final PlanificacionLast item;

  @override
  State<SeguimientoOrden> createState() => _SeguimientoOrdenState();
}

class _SeguimientoOrdenState extends State<SeguimientoOrden> {
  List<PlanificacionItem> list = [];
  bool isEntrega = false;
  late TextEditingController comment;

  Future getSeguimiento() async {
    final res = await httpRequestDatabase(selectProductoPlanificacionLastIdKey,
        {'is_key_product': widget.item.isKeyUniqueProduct.toString()});
    // print(res.body);
    list = planificacionItemFromJson(res.body);
    list.isNotEmpty ? validadListaTerminada(list) : () {};
    setState(() {});
  }

  Future updateFromComment(id, comment) async {
    await httpRequestDatabase(
        updatePlanificacionCommentLast, {'id': id, 'comment': comment});
    // print('Comment  Reponse:  ${res.body}');
  }

  @override
  void initState() {
    super.initState();
    comment = TextEditingController();
    getSeguimiento();
  }

  bool isLoading = false;

  Future updateBalance() async {
    String? valueCant = await showDialog<String>(
        context: context,
        builder: (context) {
          return const AddComentarioCustom(
              text: 'Balance', textFielName: 'Escribir Balance Total');
        });

    if (valueCant != null) {
      final res = await httpRequestDatabase(updatePlanificacionBalance,
          {'id': widget.item.id, 'balance': valueCant});
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.white,
          content:
              Text(res.body, style: const TextStyle(color: Colors.black))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final receptionProvider = context.read<ReceptionProviderPlanificacion>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguimiento de Orden'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            child: TextButton(
              onPressed: () {
                updateBalance();
              },
              child: const Text('Poner Balance\$'),
            ),
          ),
          list.isNotEmpty
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: IconButton(
                    icon: const Icon(Icons.print),
                    onPressed: () async {
                      final filePdf = await PdfPrintOrdenProduccion.generate(
                        cliente: widget.item.cliente ?? 'N/A',
                        fecha: widget.item.fechaStart ?? 'N/A',
                        entrega: widget.item.fechaEntrega ?? 'N/A',
                        ficha: widget.item.ficha ?? 'N/A',
                        codigo: widget.item.numOrden ?? 'N/A',
                        aprobadoPor: '',
                        productos: [
                          ...list.map(
                            (item) => {
                              'descripcion': item.tipoProduct ?? 'N/A',
                              'cantidad': item.cant ?? 'N/A',
                              'precio': '',
                            },
                          ),
                        ],
                      );
                      await PdfApi.openFile(filePdf);
                    },
                  ),
                )
              : const SizedBox()
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(width: double.infinity),
            TableModifica(
                current: list, pressDelete: (id) => eliminarOrden(id)),
            const SizedBox(height: 5),
            Container(
                color: Colors.yellow.shade100,
                child: TextButton.icon(
                    icon: const Icon(Icons.timer_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddReorden(item: widget.item)),
                      );
                    },
                    label: const Text('PROGRAMAR AVISO'))),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.80,
              child: IndetificacionAction(press: (value) {
                statuMethond(
                    PlanificacionItem(
                        isKeyUniqueProduct: widget.item.isKeyUniqueProduct),
                    statu: value);

                //
                utilShowMesenger(context, 'Publicado en $value');
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
              child: ListTile(
                title: Text('Comentario de Orden General :',
                    style: Theme.of(context).textTheme.labelMedium),
                subtitle: Text(
                  widget.item.comment ?? 'N/A',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
            isLoading
                ? const Text('Subiendo')
                : SizedBox(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 25),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 150,
                              color: Colors.white,
                              child: TextButton(
                                  onPressed: () async {
                                    String? value = await showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.zero),
                                          title: BounceInDown(
                                              child: Text(
                                            'Agregar Comentario',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          )),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ZoomIn(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  width: 250,
                                                  child: TextField(
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    controller: comment,
                                                    decoration:
                                                        const InputDecoration(
                                                      border: InputBorder.none,
                                                      labelText: 'Comentario',
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              left: 10),
                                                    ),
                                                    onEditingComplete: () {
                                                      Navigator.of(context)
                                                          .pop(comment.text);
                                                      comment.clear();
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              child: const Text('Cancelar'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Comentar'),
                                              onPressed: () {
                                                if (comment.text.isNotEmpty) {
                                                  Navigator.of(context)
                                                      .pop(comment.text);
                                                  comment.clear();
                                                }
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    // print(value);

                                    if (value != null) {
                                      var commentLocal =
                                          '${widget.item.comment}- ( $value ${DateTime.now().toString().substring(0, 19)} )';
                                      if (widget.item.comment == 'N/A') {
                                        commentLocal = value;
                                      }
                                      updateFromComment(
                                          widget.item.id, commentLocal);
                                      widget.item.comment = commentLocal;
                                      setState(() {});
                                    }
                                  },
                                  child: const Text('Comentar',
                                      style: TextStyle(color: Colors.black))),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              color: Colors.white,
                              child: TextButton(
                                  onPressed: () async {
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddItemOrden(
                                                        item: widget.item)))
                                        .then((value) => {
                                              getSeguimiento(),
                                            });
                                  },
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Text('Agregar Productos',
                                        style: TextStyle(color: Colors.black)),
                                  )),
                            ),
                            const SizedBox(width: 10),
                            isEntrega
                                ? Container(
                                    width: 150,
                                    color: Colors.white,
                                    child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          entregarOrden(receptionProvider);
                                        },
                                        child: const Text('Entregar')),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ),
                  ),
            identy(context),
          ],
        ),
      ),
    );
  }

  void validadListaTerminada(List<PlanificacionItem> listLocal) {
    bool allItemsAreDone = listLocal.every((item) => item.isDone == 't');
    if (allItemsAreDone) {
      setState(() {
        isEntrega = true;
      });
    } else {
      setState(() {
        isEntrega = false;
      });
    }
  }

  Future entregarOrden(ReceptionProviderPlanificacion receptionProvider) async {
    // print(widget.item.comment);
    String comentLocal = widget.item.comment.toString();
    if (comentLocal == 'N/A') {
      comentLocal =
          'Se Entrego al Cliente Ala ( ${DateTime.now().toString().substring(0, 19)} )';
    } else {
      comentLocal =
          '${widget.item.comment}, Se Entrego al Cliente A la ( ${DateTime.now().toString().substring(0, 19)} )';
    }
    var dataSend = {
      'date_delivered': DateTime.now().toString().substring(0, 19),
      'user_entrega_orden': currentUsers?.fullName.toString(),
      'is_entregado': 't',
      'comment': comentLocal,
      'is_key_unique_product': widget.item.isKeyUniqueProduct,
    };

    var dataRegister = {
      'num_orden': widget.item.numOrden,
      'fecha': DateTime.now().toString().substring(0, 10),
      'statu': 'Salidas',
      'user_register': currentUsers?.fullName.toString(),
    };

    // $num_orden = $_POST['num_orden'];
    // $fecha = $_POST['fecha'];
    // $statu = $_POST['statu'];
    // $user_register = $_POST['user_register'];
    await httpRequestDatabase(insertReportEntradaSalidaReception, dataRegister);
    await httpRequestDatabase(updatePlanificacionLast, dataSend);
    // print('Terminando Orden ${res.body}');
    receptionProvider.getReceptionPlanificacionAll(
        DateTime.now().toString().substring(0),
        DateTime.now().toString().substring(0));
    if (mounted) {
      Navigator.pop(context);
    }
  }

  ///////este eliminar los item de una orden completa///
  Future eliminarOrden(id) async {
    await httpRequestDatabase(deleteProductoPlanificacionLast, {'id': '$id'});
    // print(res.body);
    list.removeWhere((item) => item.id == id);
    setState(() {});
  }
}

Future statuMethond(PlanificacionItem? current, {required String statu}) async {
  var data = {
    'id': current?.isKeyUniqueProduct,
    'statu': statu,
  };
  final res = await httpRequestDatabase(updatePlanificacionLastStatu, data);
  // print(res.body);
  if (res.body.toString() == 'good') {}
}

class TableModifica extends StatelessWidget {
  const TableModifica({Key? key, this.current, required this.pressDelete})
      : super(key: key);
  final List<PlanificacionItem>? current;
  final Function pressDelete;

  Color getColor(PlanificacionItem planificacion) {
    if (planificacion.statu == onProducion) {
      return Colors.cyan.shade100;
    }
    if (planificacion.statu == onEntregar) {
      return Colors.orangeAccent.shade100;
    }
    if (planificacion.statu == onParada) {
      return Colors.redAccent.shade100;
    }
    if (planificacion.statu == onProceso) {
      return Colors.teal.shade100;
    }
    if (planificacion.statu == onFallo) {
      return Colors.black54;
    }
    if (planificacion.statu == onDone) {
      return Colors.green.shade100;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 25),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: DataTable(
            dataRowMaxHeight: 25,
            dataRowMinHeight: 20,
            horizontalMargin: 10.0,
            columnSpacing: 15,
            headingRowHeight: 30,
            decoration: const BoxDecoration(color: colorsOrange),
            headingTextStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            border: TableBorder.symmetric(
                outside: BorderSide(
                    color: Colors.grey.shade100, style: BorderStyle.none),
                inside: const BorderSide(
                    style: BorderStyle.solid, color: Colors.grey)),
            columns: const [
              DataColumn(label: Text('DETALLES')),
              DataColumn(label: Text('----')),
              DataColumn(label: Text('DEPARTAMENTO')),
              DataColumn(label: Text('ESTADO')),
              DataColumn(label: Text('# ORDEN')),
              DataColumn(label: Text('FICHA')),
              DataColumn(label: Text('LOGO')),
              DataColumn(label: Text('DETALLES')),
              DataColumn(label: Text('QTY')),
              DataColumn(label: Text('COMMENT')),
              DataColumn(label: Text('ELIMINAR')),
            ],
            rows: current!.asMap().entries.map((entry) {
              int index = entry.key;
              var item = entry.value;
              return DataRow(
                color: MaterialStateProperty.resolveWith(
                    (states) => getColorPriority(item.priority ?? '')),
                cells: [
                  DataCell(
                      const Text('Click ! ',
                          style: TextStyle(color: colorsOrange)), onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (conext) => DetallesPlanificacion(
                    //       currentLocal: item,
                    //     ),
                    //   ),
                    // );
                  }),
                  DataCell(Text(getClientePorPrioridad(item.priority ?? ''))),
                  DataCell(Text(item.department ?? '')),
                  DataCell(Text(item.statu ?? '')),
                  DataCell(Center(child: Text(item.numOrden ?? '')), onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (conext) =>
                              FileViewer(numOrden: item.numOrden)),
                    );
                  }),
                  DataCell(Center(child: Text(item.ficha ?? ''))),
                  DataCell(Text(item.nameLogo ?? '')),
                  DataCell(Text(item.tipoProduct ?? '')),
                  DataCell(Text(item.cant ?? '')),
                  DataCell(
                      Text(
                        item.comment != null && item.comment!.length > 25
                            ? '${item.comment!.substring(0, 25)}...'
                            : item.comment ?? '',
                      ),
                      onTap: () =>
                          utilShowMesenger(context, item.comment ?? '')),
                  DataCell(
                    hasPermissionUsuario(
                            currentUsers!.listPermission!, "admin", "eliminar")
                        ? TextButton(
                            child: const Text('Eliminar',
                                style: TextStyle(color: Colors.red)),
                            onPressed: () => pressDelete(item.id),
                          )
                        : const Text('Sin Permiso'),
                  )
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

bool comparaTime(DateTime time1) {
  // Creamos las dos fechas a comparar
  // DateTime fecha1 = DateTime(2022, 5, 1);
  DateTime fecha2 = DateTime.now();
  DateTime soloFecha = DateTime(fecha2.year, fecha2.month, fecha2.day - 1);
  // debugPrint('Fecha de Entrega es : $soloFecha comparar con $fecha2');
  // print('La fecha soloFecha $soloFecha');
  if (soloFecha.isBefore(time1)) {
    // print(true);
    return true;
  } else {
    // print(false);
    return false;
  }

// // Comparamos las fechas
  // if (time1.isAfter(soloFecha)) {
  //   print('Ya se cumplio la fecha');
  //   print(true);
  //   return true;
  // }
  // return false;
}
