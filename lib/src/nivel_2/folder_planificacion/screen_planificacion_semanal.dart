import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/orden_list.dart';
import '/src/datebase/current_data.dart';
import '/src/model/users.dart';
import '/src/nivel_2/folder_planificacion/model_planificacion/item_planificacion.dart';
import '/src/provider/provider_planificacion.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/get_formatted_number.dart';
import '/src/util/show_mesenger.dart';
import '../../util/helper.dart';
import '../../widgets/pick_range_date.dart';
import 'record_planificacion/screen_record_planificacion.dart';
import 'screen_detalles_planificacion.dart';

class ScreenPlanificacionSemanal extends StatefulWidget {
  const ScreenPlanificacionSemanal({super.key});
  @override
  State<ScreenPlanificacionSemanal> createState() =>
      _ScreenPlanificacionSemanalState();
}

class _ScreenPlanificacionSemanalState
    extends State<ScreenPlanificacionSemanal> {
  bool _isAscendingFicha = true;
  bool _isAscendingCant = true;
  bool _isAscendingEntrega = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProviderPlanificacion>(context, listen: false)
          .cleanDepartmenSelected();
      final fecha1 = DateTime.now()
          .subtract(const Duration(days: 30))
          .toString()
          .substring(0, 10);
      final fecha2 = DateTime.now().toString().substring(0, 10);
      Provider.of<ProviderPlanificacion>(context, listen: false)
          .toChangeDate(fecha1, fecha2);
    });
  }

  void enviarAPlan(OrdenList item) async {
    // bool? result = await showDialog<bool>(
    //     context: context, builder: (context) => AddDialogPlan(item: item));
    // if (result != null) {
    //   if (result) {
    //     // ignore: use_build_context_synchronously
    //     showScaffoldMessenger(context, 'Listo', Colors.green);
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    const shadow =
        BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 10);
    final providerData = context.read<ProviderPlanificacion>();
    final watchList = context.watch<ProviderPlanificacion>();
    bool? isPlanner =
        hasPermissionUsuario(currentUsers!.listPermission!, "plan", "crear");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Planificación'),
        actions: [
          Tooltip(
            message: 'Quitar filtro',
            child: IconButton(
                icon: Icon(
                    watchList.departmentSelected.isEmpty
                        ? Icons.filter_alt_outlined
                        : Icons.filter_alt_off_outlined,
                    color: watchList.departmentSelected.isNotEmpty
                        ? Colors.red
                        : Colors.black),
                onPressed: providerData.normalizarList),
          ),
          Tooltip(
            message: 'Buscar por fecha',
            child: Container(
              // Agregado un contenedor para ajustar el espacio
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: const Icon(Icons.calendar_month_outlined,
                    color: Colors.black),
                onPressed: () async {
                  selectDateRangeNew(context, (date1, date2) {
                    providerData.toChangeDate(date1, date2);
                  });
                },
              ),
            ),
          ),
          Tooltip(
            message: 'Imprimir',
            child: Container(
              // Agregado un contenedor para ajustar el espacio
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: const Icon(Icons.print_outlined, color: Colors.black),
                onPressed: () async {
                  if (watchList.listItemsFilter.isNotEmpty) {
                    // final file = await PrintMainPlanificacion.generate(
                    //     watchList.listItemsFilter);
                    // await PdfApi.openFile(file);
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Tooltip(
              message: 'Buscar en el historial',
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ScreenRecordPlanificacion()));
                  },
                  icon: const Icon(Icons.cloud_done_outlined,
                      color: Colors.black)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          SlideInRight(
              curve: Curves.elasticInOut,
              child: buildTextFieldValidator(
                  onChanged: (val) => providerData.searchingOrden(val),
                  hintText: 'Escribir Algo!',
                  label: 'Buscar')),
          SizedBox(
            height: 40,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: OrdenList.getUniquePriorityList(watchList.listItems)
                    .map(
                      (value) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: getColorPriority(value),
                            boxShadow: const [shadow]),
                        child: TextButton(
                          child: Text(getClientePorPrioridad(value),
                              style: const TextStyle(color: colorsAd)),
                          onPressed: () {
                            providerData.searchingPriority(value);
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: OrdenList.getUniqueDepartmentList(watchList.listItems)
                    .map(
                      (value) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: watchList.departmentSelected == value
                                ? colorsBlueTurquesa
                                : Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: const [shadow]),
                        child: TextButton(
                          child: Text(value,
                              style: TextStyle(
                                  color: watchList.departmentSelected == value
                                      ? Colors.white
                                      : colorsAd)),
                          onPressed: () {
                            providerData.searchingArea(value);
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          watchList.listItemsFilter.isNotEmpty
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
                          dataRowMinHeight: 36,
                          dataRowMaxHeight: 42,
                          headingRowHeight: 44,
                          horizontalMargin: 16,
                          columnSpacing: 24,
                          showBottomBorder: true,
                          decoration: const BoxDecoration(color: colorsAd),
                          headingTextStyle: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          border: TableBorder.symmetric(
                              outside: BorderSide(
                                  color: Colors.grey.shade100,
                                  style: BorderStyle.none),
                              inside: const BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.grey)),
                          columns: [
                            if (isPlanner) DataColumn(label: Text('Pizarra')),
                            const DataColumn(label: Text('Detalles')),
                            const DataColumn(label: Text('----')),
                            DataColumn(
                                label: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Departamentos'),
                                watchList.listItems.isEmpty
                                    ? const SizedBox()
                                    : PopupMenuButton<String>(
                                        icon: Icon(Icons.arrow_drop_down,
                                            size: style.bodyLarge?.fontSize,
                                            color: Colors.white),
                                        iconSize: 20,
                                        onSelected: (String value) {
                                          providerData.searchingArea(value);
                                        },
                                        itemBuilder: (BuildContext context) {
                                          return OrdenList
                                                  .getUniqueDepartmentList(
                                                      watchList.listItems)
                                              .map<PopupMenuEntry<String>>(
                                                  (String value) {
                                            return PopupMenuItem<String>(
                                              value: value,
                                              height: 20,
                                              child: Text(value),
                                            );
                                          }).toList();
                                        },
                                      )
                              ],
                            )),
                            const DataColumn(label: Text('Estado')),
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
                                      _isAscendingFicha = !_isAscendingFicha;
                                      // Ordenar la lista según el estado actual
                                      watchList.listItemsFilter.sort((a, b) {
                                        if (_isAscendingFicha) {
                                          return a.ficha!.compareTo(b.ficha!);
                                        } else {
                                          return b.ficha!.compareTo(a.ficha!);
                                        }
                                      });
                                    });
                                  },
                                  icon: Icon(
                                    _isAscendingFicha
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down_rounded,
                                    color: Colors.white,
                                    size: style.titleMedium?.fontSize,
                                  ),
                                ),
                              ],
                            )),
                            const DataColumn(label: Text('Logo')),
                            const DataColumn(label: Text('Producto')),
                            DataColumn(
                                label: Row(
                              children: [
                                const Text('Cant'),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      // Cambiar el estado de ordenación
                                      _isAscendingCant = !_isAscendingCant;
                                      // Ordenar la lista según el estado actual
                                      watchList.listItemsFilter.sort((a, b) {
                                        if (_isAscendingCant) {
                                          return a.cant!.compareTo(b.cant!);
                                        } else {
                                          return b.cant!.compareTo(a.cant!);
                                        }
                                      });
                                    });
                                  },
                                  icon: Icon(
                                    _isAscendingCant
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down_rounded,
                                    color: Colors.white,
                                    size: style.titleMedium?.fontSize,
                                  ),
                                ),
                              ],
                            )),
                            const DataColumn(label: Text('Comentario')),
                            DataColumn(
                              label: Row(
                                children: [
                                  const Text('Entrega'),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        // Cambiar el estado de ordenación
                                        _isAscendingEntrega =
                                            !_isAscendingEntrega;
                                        // Ordenar la lista según el estado actual
                                        watchList.listItemsFilter.sort((a, b) {
                                          if (_isAscendingEntrega) {
                                            return a.fechaEntrega!
                                                .compareTo(b.fechaEntrega!);
                                          } else {
                                            return b.fechaEntrega!
                                                .compareTo(a.fechaEntrega!);
                                          }
                                        });
                                      });
                                    },
                                    icon: Icon(
                                      _isAscendingEntrega
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down_rounded,
                                      color: _isAscendingEntrega
                                          ? Colors.green
                                          : Colors.red,
                                      size: style.titleMedium?.fontSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const DataColumn(label: Text('Eliminar')),
                          ],
                          rows: watchList.listItemsFilter
                              .asMap()
                              .entries
                              .map((entry) {
                            int index = entry.key;
                            OrdenList item = entry.value;
                            return DataRow(
                              color: WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  // Alterna el color de fondo entre gris y blanco
                                  if (index.isOdd) {
                                    return getColorPriority(
                                        item.estadoPrioritario ?? '');
                                  }
                                  return getColorPriority(
                                      item.estadoPrioritario ?? '');
                                },
                              ),
                              cells: [
                                if (isPlanner)
                                  DataCell(Text('Enviar'),
                                      onTap: () => enviarAPlan(item)),
                                DataCell(
                                    const Text('Click ! ',
                                        style: TextStyle(color: Colors.black)),
                                    onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (conext) =>
                                          DetallesPlanificacion(
                                        orden: item,
                                      ),
                                    ),
                                  );
                                }),
                                DataCell(Text(getClientePorPrioridad(
                                    item.estadoPrioritario ?? ''))),
                                DataCell(Text(item.nameDepartment ?? '')),
                                DataCell(EstadoChip(
                                    estado: item.estadoProduccion ?? '')),
                                DataCell(
                                    Center(child: Text(item.numOrden ?? '')),
                                    onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (conext) => FileViewer(
                                  //           numOrden: item.numOrden)),
                                  // );
                                }),
                                DataCell(Center(child: Text(item.ficha ?? '')),
                                    onTap: () {
                                  getMensajeWidget(
                                      context, item.ficha ?? 'N/A');
                                }),
                                DataCell(
                                    Text(limitarTexto(item.nameLogo ?? '', 25)),
                                    onTap: () {
                                  utilShowMesenger(context, item.nameLogo ?? '',
                                      title: 'LOGO');
                                }),
                                DataCell(
                                    Text(limitarTexto(
                                        item.nameProducto ?? '', 25)),
                                    onTap: () {
                                  utilShowMesenger(
                                      context, item.nameProducto ?? '',
                                      title: 'Detalles Producto');
                                }),
                                DataCell(Center(child: Text(item.cant ?? ''))),
                                DataCell(
                                    Text(
                                      limitarTexto(item.nota ?? 'Sin nota', 15),
                                    ),
                                    onTap: () => utilShowMesenger(
                                        context, item.nota ?? '')),
                                DataCell(Text(
                                  item.fechaEntrega ?? '',
                                  style: TextStyle(
                                      color: PlanificacionItem.comparaTime(
                                              DateTime.parse(
                                                  item.fechaEntrega ?? ''))
                                          ? Colors.black
                                          : Colors.red,
                                      fontWeight: PlanificacionItem.comparaTime(
                                              DateTime.parse(
                                                  item.fechaEntrega ?? ''))
                                          ? FontWeight.normal
                                          : FontWeight.bold),
                                )),
                                DataCell(
                                    const Text('Eliminar',
                                        style: TextStyle(color: Colors.red)),
                                    onTap: () => eliminarOrden(item))
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BounceInDown(
                        curve: Curves.elasticInOut,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child:
                                Image.asset('assets/no_find.jpg', scale: 10)),
                      ),
                      const SizedBox(height: 10),
                      SlideInLeft(
                        curve: Curves.elasticInOut,
                        child: const Text('No hay datos..',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
          PaginacionWidgetButton(providerData: providerData, style: style),
          watchList.listItemsFilter.isNotEmpty
              ? SizedBox(
                  height: 35,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        //PlanificacionItem.getGetTotal(resumen),

                        Container(
                          height: 35,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Filas :', style: style.bodySmall),
                                  const SizedBox(width: 10),
                                  Text(
                                      watchList.listItemsFilter.length
                                          .toString(),
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
                                  Text('Ordenes :', style: style.bodySmall),
                                  const SizedBox(width: 10),
                                  Text(
                                      OrdenList.getUniqueNumOrden(
                                              watchList.listItemsFilter)
                                          .length
                                          .toString(),
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
                                  Text('Piezas :', style: style.bodySmall),
                                  const SizedBox(width: 10),
                                  Text(
                                      getNumFormatedDouble(
                                          OrdenList.getGetTotal(
                                              watchList.listItemsFilter)),
                                      style: style.bodySmall?.copyWith(
                                          color: Colors.brown,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
          identy(context)
        ],
      ),
    );
  }

  ///////este eliminar los item de una orden completa///
  Future eliminarOrden(OrdenList item) async {
    if (hasPermissionUsuario(
            currentUsers!.listPermission!, "operador", "eliminar") ||
        hasPermissionUsuario(
            currentUsers!.listPermission!, "admin", "eliminar")) {
      // await showDialog(
      //     context: context,
      //     builder: (_) {
      //       return ConfirmacionDialog(
      //         mensaje: '❌❌Esta seguro de eliminar esto?❌❌',
      //         titulo: 'Aviso',
      //         onConfirmar: () async {
      //           Navigator.of(context).pop();
      //           // print('Eliminado');
      //           await httpRequestDatabase(
      //               deleteProductoPlanificacionLast, {'id': '$id'});
      //           // getPlanificacionWork();
      //         },
      //       );
      //     });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No tiene permiso'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red),
      );
    }
  }
}

class PaginacionWidgetButton extends StatelessWidget {
  const PaginacionWidgetButton({
    super.key,
    required this.providerData,
    required this.style,
  });

  final ProviderPlanificacion providerData;
  final TextTheme style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // IconButton(
          //   icon: const Icon(
          //     Icons.arrow_back_ios,
          //     color: Colors.black,
          //     size: 10,
          //   ),
          //   onPressed: () {
          //     if (providerData.currentPage > 1) {
          //       providerData.changePage(providerData.currentPage - 1);
          //     }
          //   },
          // ),
          // Text(
          //     'Página ${providerData.currentPage} de ${providerData.totalPages}',
          //     style: style.bodySmall?.copyWith()),
          // IconButton(
          //   icon: const Icon(
          //     Icons.arrow_forward_ios,
          //     color: Colors.black,
          //     size: 10,
          //   ),
          //   onPressed: () {
          //     if (providerData.currentPage < providerData.totalPages) {
          //       providerData.changePage(providerData.currentPage + 1);
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}

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
    return Colors.green.shade200;
  }
  return Colors.white;
}
