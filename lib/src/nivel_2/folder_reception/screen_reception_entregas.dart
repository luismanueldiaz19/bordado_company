import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../folder_planificacion/folder_print_planificacion/print_main_planificacion.dart';
import '../pre_orden/add_pre_orden.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/model/users.dart';
import '/src/nivel_2/folder_planificacion/add_planificacion.dart';
import '/src/nivel_2/folder_re_orden/dialog_reorden_record.dart';
import '/src/nivel_2/folder_reception/file_view_orden.dart';
import '/src/nivel_2/folder_reception/historia_record/screen_record_reception.dart';
import '/src/nivel_2/folder_reception/custom_delegate_searching.dart';
import '/src/nivel_2/folder_reception/seguimiento_orden.dart';
import '/src/screen_print_pdf/apis/pdf_api.dart';
import '/src/util/get_formatted_number.dart';
import '/src/util/show_mesenger.dart';
import '/src/widgets/validar_screen_available.dart';
import '../../datebase/url.dart';
import '../../util/commo_pallete.dart';
import '../../util/dialog_confimarcion.dart';
import '../../util/helper.dart';
import '../../widgets/picked_date_widget.dart';
import '../folder_planificacion/model_planificacion/item_planificacion.dart';
import '../folder_planificacion/model_planificacion/planificacion_last.dart';
import '../folder_planificacion/url_planificacion/url_planificacion.dart';
import '../folder_re_orden/dialog_reorden.dart';
import '../folder_re_orden/model/reorden.dart';
import 'folder_admin_re_orden/screen_admin_re_orden.dart';
import 'folder_historia_cliente_orden/screen_historia_cliente_orden.dart';
import 'print_reception/print_reception_orden.dart';

class ScreenReceptionEntregas extends StatefulWidget {
  const ScreenReceptionEntregas({super.key});

  @override
  State<ScreenReceptionEntregas> createState() =>
      _ScreenReceptionEntregasState();
}

class _ScreenReceptionEntregasState extends State<ScreenReceptionEntregas> {
  List<PlanificacionLast> planificacionList = [];
  List<PlanificacionLast> planificacionListFilter = [];
  bool _isAscendingFicha = true;
  bool _isAscendingCliente = true;

  String modoEstado = "";
  String usuario = "";
  String? firstDate = DateTime.now().toString().substring(0, 10);
  String? secondDate = DateTime.now().toString().substring(0, 10);
  List<ReOrden> listReOrden = [];

  ///ordenes no entregado
  Future getReception() async {
    final res = await httpRequestDatabase(
        selectPlanificacionLast, {'date1': firstDate, 'date2': secondDate});
    // print(res.body);
    planificacionList = planificacionLastFromJson(res.body);
    planificacionListFilter = List.from(planificacionList);
    if (!mounted) return null;
    setState(() {});
  }

  void shomMjs(String msj) => utilShowMesenger(context, msj);

  ///ordenes no entregado
  Future getMonthly(date1, date2) async {
    setState(() {
      planificacionList.clear();
      planificacionListFilter.clear();
    });
    final res = await httpRequestDatabase(
        selectPlanificacionByMothEntregas, {'date1': date1, 'date2': date2});
    planificacionList = planificacionLastFromJson(res.body);

    setState(() {
      planificacionListFilter = planificacionList;
    });
  }

  Future getMonthlyCreated(date1, date2) async {
    setState(() {
      planificacionList.clear();
      planificacionListFilter.clear();
    });
    final res = await httpRequestDatabase(
        selectPlanificacionByMonthlyCreated, {'date1': date1, 'date2': date2});
    planificacionList = planificacionLastFromJson(res.body);

    setState(() {
      planificacionListFilter = planificacionList;
    });
  }

  @override
  void initState() {
    super.initState();
    getReorden();
    getReception();
  }

  Future deleleFromRecord(PlanificacionLast item, context) async {
    if (hasPermissionUsuario(
        currentUsers!.listPermission!, "admin", "eliminar")) {
      await showDialog(
          context: context,
          builder: (_) {
            return ConfirmacionDialog(
              mensaje:
                  '❌❌Esta seguro , se eliminar la orden completa del sistema ?❌❌',
              titulo: 'Alecta',
              onConfirmar: () async {
                Navigator.of(context).pop();
                // shomMjs(mjs) => utilShowMesenger(context, mjs);
                //delete_orden_completa
                final res = await httpRequestDatabase(
                    'http://$ipLocal/settingmat/admin/delete/delete_orden_completa.php',
                    {'is_key_unique_product': item.isKeyUniqueProduct});
                final data = jsonDecode(res.body);
                if (data['success']) {
                  setState(() {
                    planificacionList.remove(item);
                    planificacionListFilter.remove(item);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(data['message']),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 1)));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(data['message']),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 1)));
                }
              },
            );
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No no tiene permiso para eliminar'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  searchingOrden(String val) {
    if (val.isNotEmpty) {
      planificacionListFilter = List.from(planificacionList
          .where((x) =>
              x.ficha!.toUpperCase().contains(val.toUpperCase()) ||
              x.numOrden!.toUpperCase().contains(val.toUpperCase()) ||
              x.nameLogo!.toUpperCase().contains(val.toUpperCase()) ||
              x.clienteTelefono!.toUpperCase().contains(val.toUpperCase()) ||
              x.cliente!.toUpperCase().contains(val.toUpperCase()))
          .toList());
      setState(() {});
    } else {
      setState(() {
        planificacionListFilter = [...planificacionList];
      });
    }
  }

  atrasada() {
    List<PlanificacionLast> lisLocal = [];
    for (var item in planificacionList) {
      if (PlanificacionLast.comparaTime(
              DateTime.parse(item.fechaEntrega ?? '')) &&
          item.statu?.toUpperCase() != onEntregar.toUpperCase()) {
        lisLocal.add(item);
      }
    }
    planificacionListFilter = lisLocal;
    setState(() {});
  }

  searchingEstadoEmpleado() {
    setState(() {
      planificacionListFilter = List.from(planificacionList
          .where((x) =>
              x.userRegistroOrden!.toUpperCase() == usuario.toUpperCase() &&
              x.statu!.toUpperCase() == modoEstado.toUpperCase())
          .toList());
    });
  }

  normalizarWithRegisterOrden() {
    setState(() {
      planificacionListFilter = planificacionList
          .where((element) =>
              element.userRegistroOrden?.toUpperCase() == usuario.toUpperCase())
          .toList();
    });
  }

  searchingOnlyEstado() {
    setState(() {
      planificacionListFilter = List.from(planificacionList
          .where((x) => x.statu!.toUpperCase() == modoEstado.toUpperCase())
          .toList());
    });
  }

  Color getNombre(userRegited) {
    return usuario.toUpperCase() == userRegited.toUpperCase()
        ? Colors.red
        : Colors.blue;
  }

  Future getReorden() async {
    final res = await httpRequestDatabase(selectReOrden,
        {'token': token, 'date1': DateTime.now().toString().substring(0, 10)});
    listReOrden = reOrdenFromJson(res.body);
    await Future.delayed(const Duration(seconds: 2));

    if (!validatorUser()) {
      listReOrden = listReOrden
          .where((element) =>
              element.usuario?.toUpperCase() ==
              currentUsers?.fullName?.toUpperCase())
          .toList();
    }

    if (res.body != '') {
      if (!mounted) {
        return;
      }
      if (listReOrden.isNotEmpty) {
        await showDialog(
            context: context,
            builder: (context) {
              return DialogReOrden(listReOrden: listReOrden);
            });
      }
    }
  }

  void settingContabilidad(PlanificacionLast item) async {
    await showDialog(
        context: context, builder: (context) => builder(context, item));
  }

  searchingPriority(value) {
    // _departmentSelected = value;

    planificacionListFilter = List.from(planificacionList
        .where((x) => x.priority!.toUpperCase().contains(value.toUpperCase()))
        .toList());
    setState(() {});
  }

  Widget builder(context, PlanificacionLast item) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        content: SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text('Orden : ${item.numOrden}')),
              Text('Ficha : ${item.ficha}'),
              Text('${item.nameLogo}'),
              Text('${item.cliente}'),
              Text('${item.clienteTelefono}'),
              Text('Estado ${item.statu}'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 250,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        asignaContabilida(item);
                      },
                      child: const Text('Asignar a Contabilidad')),
                ),
              ),
            ],
          ),
        ),
      );

  Future asignaContabilida(PlanificacionLast item) async {
    final res = await httpRequestDatabase(
        updatePlanificacionContabilidad, {'id': item.id});
    // /print(res.body);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(res.body)));
  }

  Future setIsBalancePaid(PlanificacionLast item) async {
    // print('Valor inicial ${item.isValidateBalance}');
    await showDialog(
        context: context,
        builder: (_) {
          return ConfirmacionDialog(
            mensaje: 'Esta seguro de cambiar estado de balance?',
            titulo: 'Aviso',
            onConfirmar: () async {
              var value = item.isValidateBalance == 't' ? 'f' : 't';
              await httpRequestDatabase(
                  updateIsValidateBalance, {'id': item.id, 'value': value});
              exit();
            },
          );
        });

    // /print(res.body);
    if (!mounted) {
      return;
    }
  }

  void exit() async {
    Navigator.of(context).pop();
    await getReception();
  }

  void normalizaList() {
    setState(() {
      usuario = '';
      planificacionListFilter = List.from(planificacionList);
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    const shadow =
        BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 10);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Entregas De Saquetas'),
          actions: [
            Tooltip(
              message: 'Quitar filtro',
              child: IconButton(
                  icon: const Icon(Icons.filter_alt_off_outlined,
                      color: Colors.black),
                  onPressed: normalizaList),
            ),
            Tooltip(
              message: 'Imprimir',
              child: Container(
                // Agregado un contenedor para ajustar el espacio
                margin: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: const Icon(Icons.print_outlined, color: Colors.black),
                  onPressed: () async {
                    if (planificacionListFilter.isNotEmpty) {
                      final file = await PrintMainPlanificacionLast.generate(
                          planificacionListFilter);
                      await PdfApi.openFile(file);
                    }
                  },
                ),
              ),
            ),
            Tooltip(
                message: 'Buscar en Fecha',
                child: IconButton(
                    onPressed: () async {
                      String? dateee =
                          await showDatePickerCustom(context: context);
                      // print(dateee);
                      if (dateee != null) {
                        setState(() {
                          usuario = "";
                          modoEstado = "";
                          firstDate = dateee.toString();
                          secondDate = dateee.toString();
                          planificacionList.clear();
                          planificacionListFilter.clear();
                        });
                        getReception();
                        getReorden();
                      }
                    },
                    icon: const Icon(Icons.calendar_month))),
            PopupMenuButton<int>(
              onSelected: (int index) async {
                if (index == 5) {
                  getReorden();
                } else if (index == 1) {
                  showSearch(
                      context: context, delegate: CustomSearchDelegate());
                } else if (index == 2) {
                  hasPermissionUsuario(currentUsers!.listPermission!,
                          "planificacion", "crear")
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddPreOrden()),
                        )
                      : () {};
                } else if (index == 3) {
                  if (planificacionListFilter.isNotEmpty) {
                    final pdfFile = await PdfReceptionOrdenes.generate(
                        planificacionListFilter,
                        firstDate,
                        secondDate,
                        'atrazadas',
                        PlanificacionLast.totalOrdenEntregar(
                            planificacionListFilter));
                    PdfApi.openFile(pdfFile);
                  }
                } else if (index == 4) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScreenRecordReception()),
                  );
                } else if (index == 6) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScreenAdminReOrden()),
                  );
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                const PopupMenuItem<int>(
                  value: 1,
                  child: ListTile(
                    leading: Icon(Icons.search),
                    title: Text('Search'),
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: ListTile(
                    leading: Icon(Icons.add, color: Colors.black),
                    title: Text('Add Planificacion Form'),
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 3,
                  child: ListTile(
                    leading: Icon(Icons.print, color: Colors.black),
                    title: Text('Print'),
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 4,
                  child: ListTile(
                    leading: Icon(Icons.calendar_month_outlined,
                        color: Colors.black),
                    title: Text('Screen Record Reception'),
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 5,
                  child: ListTile(
                    leading:
                        Icon(Icons.info_outline_rounded, color: Colors.amber),
                    title: Text('Aviso Entregas'),
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 6,
                  child: ListTile(
                      leading: Icon(Icons.calendar_month_outlined,
                          color: Colors.red),
                      title: Text('Admin Aviso Entregas')),
                ),
              ],
            ),
          ],
        ),
        body: ValidarScreenAvailable(
          windows: Column(
            children: [
              const SizedBox(width: double.infinity),
              SlideInLeft(
                curve: Curves.elasticInOut,
                child: buildTextFieldValidator(
                    onChanged: (val) => searchingOrden(val),
                    hintText: 'Escribir Algo!',
                    label: 'Buscar'),
              ),
              SizedBox(
                height: 40,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: PlanificacionItem.getUniquePriorityList(
                            planificacionList
                                .map((e) =>
                                    PlanificacionItem(priority: e.priority))
                                .toList())
                        .map(
                          (value) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: getColorPriority(value),
                                boxShadow: const [shadow]),
                            child: TextButton(
                                child: Text(value,
                                    style: const TextStyle(color: colorsAd)),
                                onPressed: () => searchingPriority(value)),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: PlanificacionLast.depurarRegistradorOrden(
                            planificacionList)
                        .map((userRegited) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [shadow],
                        ),
                        child: Row(
                          children: [
                            TextButton(
                              child: Text(userRegited,
                                  style: const TextStyle(color: colorsAd)),
                              onPressed: () {
                                setState(() {
                                  modoEstado = '';
                                  usuario = userRegited.toUpperCase();
                                  planificacionListFilter = planificacionList
                                      .where((element) =>
                                          element.userRegistroOrden
                                              ?.toUpperCase() ==
                                          usuario.toUpperCase())
                                      .toList();
                                });
                              },
                            ),
                            usuario.toUpperCase() == userRegited.toUpperCase()
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        usuario = '';
                                        planificacionListFilter =
                                            List.from(planificacionList);
                                      });
                                    },
                                    icon: const Icon(Icons.close,
                                        color: Colors.red))
                                : const SizedBox()
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 35,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: PlanificacionLast.depurraEstadoOrden(
                              planificacionListFilter)
                          .map(
                        (estado) {
                          return Container(
                            color: modoEstado == estado
                                ? Colors.blue.shade100
                                : Colors.white,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      modoEstado = estado;
                                      if (usuario.isEmpty) {
                                        searchingOnlyEstado();
                                      } else {
                                        searchingEstadoEmpleado();
                                      }
                                    },
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty
                                            .resolveWith((states) =>
                                                const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.zero))),
                                    child: Text(estado)),
                                modoEstado == estado
                                    ? TextButton(
                                        onPressed: () {
                                          setState(() {
                                            modoEstado = '';
                                            if (usuario.isEmpty) {
                                              //normalizar lista
                                              planificacionListFilter =
                                                  planificacionList;
                                            } else {
                                              normalizarWithRegisterOrden();
                                            }
                                          });
                                        },
                                        child: const Center(
                                          child: Icon(Icons.close,
                                              color: Colors.red, size: 15),
                                        ))
                                    : const SizedBox()
                              ],
                            ),
                          );
                        },
                      ).toList()),
                ),
              ),
              planificacionListFilter.isNotEmpty
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: SingleChildScrollView(
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
                              decoration: const BoxDecoration(color: colorsAd),
                              headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              border: TableBorder.symmetric(
                                  outside: BorderSide(
                                      color: Colors.grey.shade100,
                                      style: BorderStyle.none),
                                  inside: const BorderSide(
                                      style: BorderStyle.solid,
                                      color: Colors.grey)),
                              columns: [
                                const DataColumn(label: Text('Detalles')),
                                const DataColumn(label: Text('Empleado')),
                                const DataColumn(label: Text('----')),
                                const DataColumn(label: Text('# Orden')),
                                DataColumn(
                                    label: Row(
                                  children: [
                                    const SizedBox(width: 5),
                                    const Text('Fichas'),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          // Cambiar el estado de ordenación
                                          _isAscendingFicha =
                                              !_isAscendingFicha;
                                          // Ordenar la lista según el estado actual
                                          planificacionListFilter.sort((a, b) {
                                            if (_isAscendingFicha) {
                                              return a.ficha!
                                                  .compareTo(b.ficha!);
                                            } else {
                                              return b.ficha!
                                                  .compareTo(a.ficha!);
                                            }
                                          });
                                        });
                                      },
                                      icon: Icon(
                                        _isAscendingFicha
                                            ? Icons.arrow_drop_up
                                            : Icons.arrow_drop_down_rounded,
                                        color: _isAscendingFicha
                                            ? Colors.green
                                            : Colors.red,
                                        size: style.titleMedium?.fontSize,
                                      ),
                                    ),
                                  ],
                                )),
                                const DataColumn(label: Text('Balance')),
                                const DataColumn(label: Text('Intervención')),
                                const DataColumn(label: Text('Comentarios')),
                                DataColumn(
                                  label: Row(
                                    children: [
                                      const Text('Fecha de entrega'),
                                      IconButton(
                                          onPressed: () {
                                            selectDateRange(context,
                                                (date1, date2) {
                                              getMonthly(date1, date2);
                                              // getMonthlyCreated
                                            });
                                          },
                                          icon: const Icon(
                                              Icons.calendar_month_outlined,
                                              color: Colors.white,
                                              size: 14))
                                    ],
                                  ),
                                ),
                                const DataColumn(label: Text('Logo')),
                                const DataColumn(label: Text('Estado')),
                                DataColumn(
                                    label: Row(
                                  children: [
                                    const SizedBox(width: 5),
                                    const Text('Cliente'),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          // Cambiar el estado de ordenación
                                          _isAscendingCliente =
                                              !_isAscendingCliente;
                                          // Ordenar la lista según el estado actual
                                          planificacionListFilter.sort((a, b) {
                                            if (_isAscendingCliente) {
                                              return a.ficha!
                                                  .compareTo(b.cliente!);
                                            } else {
                                              return b.ficha!
                                                  .compareTo(a.cliente!);
                                            }
                                          });
                                        });
                                      },
                                      icon: Icon(
                                        _isAscendingCliente
                                            ? Icons.arrow_drop_up
                                            : Icons.arrow_drop_down_rounded,
                                        color: _isAscendingCliente
                                            ? Colors.green
                                            : Colors.red,
                                        size: style.titleMedium?.fontSize,
                                      ),
                                    ),
                                  ],
                                )),
                                const DataColumn(
                                    label: Text('Cliente Telefono')),
                                DataColumn(
                                    label: Row(
                                  children: [
                                    const Text('Fecha Creación'),
                                    IconButton(
                                        onPressed: () {
                                          selectDateRange(context,
                                              (date1, date2) {
                                            getMonthlyCreated(date1, date2);
                                          });
                                        },
                                        icon: const Icon(
                                            Icons.calendar_month_outlined,
                                            color: Colors.white,
                                            size: 14))
                                  ],
                                )),
                                const DataColumn(label: Text('Eliminar')),
                              ],
                              rows: planificacionListFilter
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                int index = entry.key;
                                var item = entry.value;
                                return DataRow(
                                  color:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      // Alterna el color de fondo entre gris y blanco
                                      if (index.isOdd) {
                                        return PlanificacionLast.getColor(item);

                                        //  getColorPriority(
                                        //     item.priority ?? '');
                                      }
                                      return PlanificacionLast.getColor(item)
                                          .withOpacity(0.9);
                                      // getColorPriority(item.priority ?? '');
                                    },
                                  ),
                                  cells: [
                                    DataCell(TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (conext) =>
                                                    SeguimientoOrden(
                                                        item: item)));
                                      },
                                      child: const Text('CLICK!'),
                                    )),
                                    DataCell(Text(item.userRegistroOrden ?? ''),
                                        onTap: () {
                                      settingContabilidad(item);
                                    }, showEditIcon: true),
                                    DataCell(Text((item.priority ?? ''))),
                                    DataCell(
                                        Center(
                                          child: Text(
                                            item.numOrden ?? '',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ), onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (conext) => FileViewer(
                                                numOrden: item.numOrden)),
                                      );
                                    }),
                                    DataCell(Text(item.ficha ?? '')),
                                    DataCell(
                                        Center(
                                            child: Text(
                                          '\$ ${getNumFormatedDouble(item.balance ?? '0')}',
                                          style: TextStyle(
                                              fontWeight:
                                                  item.isValidateBalance == 't'
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                              color: PlanificacionLast
                                                  .getColorIsBalancePaid(item)),
                                        )), onTap: () async {
                                      await setIsBalancePaid(item);
                                    }),
                                    DataCell(
                                        Center(
                                            child: Text(item.llamada ?? '0')),
                                        onTap: () {
                                      if (item.llamada!.contains('0')) {
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DialogReOrdenRecord(
                                                      numOrden:
                                                          item.numOrden!)),
                                        );
                                      }
                                    }),
                                    DataCell(
                                      Text(item.comment != null &&
                                              item.comment!.length > 25
                                          ? '${item.comment!.substring(0, 25)}...'
                                          : item.comment ?? ''),
                                      onTap: () {
                                        utilShowMesenger(
                                            context, item.comment ?? '',
                                            title: 'Comentarios');
                                      },
                                    ),
                                    DataCell(
                                      Text(
                                        item.fechaEntrega ?? '',
                                        style: TextStyle(
                                            color: PlanificacionLast
                                                    .getColorsAtradas(item)
                                                ? Colors.black
                                                : Colors.red,
                                            fontWeight: PlanificacionLast
                                                    .getColorsAtradas(item)
                                                ? FontWeight.normal
                                                : FontWeight.bold),
                                      ),
                                    ),
                                    DataCell(
                                        SizedBox(
                                          width: 75,
                                          child: Text(
                                            item.nameLogo ?? '',
                                            style: const TextStyle(
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ), onTap: () {
                                      utilShowMesenger(
                                          context, item.nameLogo ?? '',
                                          title: 'LOGO');
                                    }),
                                    DataCell(Text(item.statu ?? '')),
                                    DataCell(
                                        SizedBox(
                                          width: 70,
                                          child: Text(item.cliente ?? '',
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                        ), onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ScreenHistoriaClienteOrden(
                                                    client:
                                                        item.cliente ?? 'N/A')),
                                      );
                                    }, onLongPress: () {
                                      utilShowMesenger(
                                          context, item.cliente ?? '',
                                          title: 'CLIENTE');
                                    }),
                                    DataCell(Text(item.clienteTelefono ?? '')),
                                    DataCell(Text(item.fechaStart ?? '')),
                                    DataCell(TextButton(
                                      child: const Text('Eliminar',
                                          style: TextStyle(color: Colors.red)),
                                      onPressed: () =>
                                          deleleFromRecord(item, context),
                                    ))
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(child: Text('No hay Datos')),
              planificacionListFilter.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: SizedBox(
                        height: 30,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              const SizedBox(width: 15),
                              BounceInDown(
                                delay: const Duration(milliseconds: 50),
                                child: Container(
                                  height: 70,
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          const Text('TOTAL ORDEN : '),
                                          const SizedBox(width: 15),
                                          Text(
                                              '${planificacionListFilter.length}',
                                              style: const TextStyle(
                                                  color: Colors.brown,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              BounceInDown(
                                delay: const Duration(milliseconds: 100),
                                child: Container(
                                  height: 70,
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          const Text('POR ENTREGAR: '),
                                          const SizedBox(width: 15),
                                          Text(
                                              PlanificacionLast
                                                  .totalOrdenEntregar(
                                                      planificacionListFilter),
                                              style: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              BounceInDown(
                                delay: const Duration(milliseconds: 100),
                                child: Container(
                                  height: 70,
                                  decoration: const BoxDecoration(
                                      color: colorsAd, boxShadow: [shadow]),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Center(
                                      child: TextButton(
                                          onPressed: () {
                                            planificacionListFilter =
                                                PlanificacionLast
                                                    .getTotalAtrasadaList(
                                                        planificacionList);
                                            setState(() {});
                                          },
                                          child: Row(
                                            children: [
                                              const Text('ATRASADAS: ',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              const SizedBox(width: 15),
                                              Text(
                                                  PlanificacionLast
                                                      .getTotalAtrasada(
                                                          planificacionListFilter),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              BounceInDown(
                                delay: const Duration(milliseconds: 100),
                                child: Container(
                                  height: 70,
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          const Text('BALANCE: '),
                                          const SizedBox(width: 15),
                                          Text(
                                              '\$ ${getNumFormatedDouble(PlanificacionLast.getBalanceTotal(planificacionListFilter))}',
                                              style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              identy(context)
            ],
          ),
        ));
  }
}
