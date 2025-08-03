import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../datebase/current_data.dart';
import '../../model/department.dart';
import '../../model/users.dart';
import '../../util/commo_pallete.dart';
import '../../util/get_formatted_number.dart';
import '../../util/helper.dart';
import '../../util/show_mesenger.dart';
import 'model/printer_plan.dart';
import 'printer_provider.dart';
import 'screen_printer.dart';
import 'ver_imagenes_page.dart';
import 'widgets/dias_tab_bar.dart';
import 'widgets/mostrar_widget_text.dart';
import 'widgets/selector_estado_print.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key, required this.depart});
  final Department? depart;
  @override
  State createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  final List<String> dias = [
    'Lunes',
    'Martes',
    'Miercoles',
    'Jueves',
    'Viernes',
    'Sabado',
    'Domingo'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<PrinterProvider>();
      await provider.getPlanesPendientes(widget.depart); // cargar los datos
      int diaActualIndex = DateTime.now().weekday - 1;
      provider.setDiaPicked(dias[diaActualIndex]); // filtrar por día actual
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<PrinterProvider>();
    final providerRead = context.read<PrinterProvider>();
    // final size = MediaQuery.of(context).size;
    final double fontSize = getResponsiveFontSize(context, scale: 1.9);
    // const curve = Curves.elasticInOut;
    bool hasPermisoActualizar = hasPermissionUsuario(
        currentUsers!.listPermission!, "plan", "actualizar");
    bool hasPermisoEliminar =
        hasPermissionUsuario(currentUsers!.listPermission!, "plan", "eliminar");
    bool hasPermisoAdmin =
        hasPermissionUsuario(currentUsers!.listPermission!, "plan", "crear");
    return Column(
      children: [
        const SizedBox(width: double.infinity),
        DiasTabBar(
          onDiaSeleccionado: (dia) {
            providerRead.setDiaPicked(dia);
          },
        ),
        providerWatch.planeFilter.isEmpty
            ? const SizedBox()
            : Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      child: DataTable(
                        border: TableBorder.symmetric(
                            outside: BorderSide(
                                color: Colors.grey.shade100,
                                style: BorderStyle.none),
                            inside: const BorderSide(
                                style: BorderStyle.solid, color: Colors.grey)),
                        headingTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: fontSize),
                        dataTextStyle: TextStyle(
                            color: Colors.black87, fontSize: fontSize),
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => colorsBlueTurquesaOther),
                        columns: [
                          const DataColumn(label: Text('VER')),
                          if (hasPermisoEliminar)
                            const DataColumn(label: Text('DIAS')),
                          const DataColumn(label: Text('ESTADO')),
                          const DataColumn(label: Text('#NUM')),
                          const DataColumn(label: Text('LOGO')),
                          const DataColumn(label: Text('CANT')),
                          const DataColumn(label: Text('TIPOS')),
                          const DataColumn(label: Text('ASIGNADO')),
                          const DataColumn(label: Text('FICHA')),
                          const DataColumn(label: Text('ORDEN')),
                          const DataColumn(label: Text('COMMENT')),
                          if (hasPermisoEliminar)
                            const DataColumn(label: Text('QUITAR')),
                        ],
                        rows: providerWatch.planeFilter
                            .asMap()
                            .entries
                            .map((entry) {
                          int index = entry.key;
                          PrinterPlan report = entry.value;
                          return DataRow(
                            color: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                final estado = report.estado ?? '';
                                final colorEstado =
                                    PrinterPlan.getColorByEstado(estado)
                                        .withOpacity(0.5);

                                // Si quieres aplicar color solo si es distinto a negro por defecto:
                                if (colorEstado != Colors.black) {
                                  return colorEstado;
                                }

                                // Si no, alternar fondo blanco y gris por índice
                                return index.isOdd
                                    ? Colors.grey.shade300
                                    : Colors.white;
                              },
                            ),
                            cells: [
                              DataCell(Text('Ver'), onTap: () {
                                print(report.toJson());
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VerImagenesPage(item: report)),
                                );
                                //SubirImagenPage
                                //VerImagenesPage
                              }),
                              if (hasPermisoAdmin)
                                DataCell(Text(report.diaSemana.toString())),
                              DataCell(Row(
                                children: [
                                  // Text(report.estado.toString()),
                                  EstadoSelector(
                                    estadoActual:
                                        report.estado.toString().toUpperCase(),
                                    onChanged: hasPermisoActualizar
                                        ? (nuevoEstado) {
                                            setState(() {
                                              setState(() {
                                                report.estado = nuevoEstado;
                                              });

                                              providerRead.updatePlan(report);
                                            });
                                          }
                                        : (nuevoEstado) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content:
                                                    Text('No tiene permiso'),
                                                duration: Duration(seconds: 1),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          },
                                  ),
                                ],
                              )),
                              DataCell(Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (hasPermisoAdmin)
                                    IconButton(
                                      iconSize: fontSize,
                                      onPressed: () =>
                                          mostrarInputIndex(context, report),
                                      icon: const Icon(Icons.edit,
                                          color: colorsRed),
                                    ),
                                  if (hasPermisoAdmin)
                                    const SizedBox(width: 10),
                                  Text(report.indexWork.toString()),
                                ],
                              )),
                              DataCell(Text(report.nombreLogo.toString())),
                              DataCell(Center(
                                child: Text(
                                    getNumFormatedDouble(
                                        report.cantidad.toString()),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              )),
                              DataCell(Text(report.tipoTrabajo.toString())),
                              DataCell(Row(
                                children: [
                                  if (hasPermisoActualizar)
                                    IconButton(
                                      iconSize: fontSize,
                                      onPressed: () => mostrarInputAsignacion(
                                          context, report),
                                      icon: const Icon(Icons.edit,
                                          color: colorsRed),
                                    ),
                                  if (hasPermisoActualizar)
                                    const SizedBox(width: 10),
                                  Text(report.asignado.toString()),
                                ],
                              )),
                              DataCell(Text(report.ficha.toString())),
                              DataCell(Text(report.orden.toString())),
                              DataCell(
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (hasPermisoActualizar)
                                        IconButton(
                                          iconSize: fontSize,
                                          onPressed: () =>
                                              mostrarInputComentario(
                                                  context, report),
                                          icon: const Icon(Icons.edit,
                                              color: colorsRed),
                                        ),
                                      if (hasPermisoActualizar)
                                        const SizedBox(width: 10),
                                      Text(limitarTexto(
                                          report.comentario.toString(), 10)),
                                    ],
                                  ),
                                  onTap: () => utilShowMesenger(
                                      context, report.comentario ?? '')),
                              if (hasPermisoEliminar)
                                DataCell(const Text('Quitar'), onTap: () async {
                                  bool? value =
                                      await showConfirmationDialogOnyAsk(
                                          context, eliminarMjs);

                                  if (value != null) {
                                    if (value) {
                                      providerRead
                                          .eliminarPlan(report.toJson());
                          
                                    } else {}
                                  }

                                  // providerRead.eliminarPlan(report.toJson());
                                }),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
        providerWatch.planeFilter.isEmpty
            ? const SizedBox()
            : Text('QTY : ${providerWatch.planeFilter.length}',
                style: TextStyle(fontSize: fontSize)),
        identy(context),
      ],
    );
  }

  void mostrarInputComentario(context, PrinterPlan report) async {
    final provider = Provider.of<PrinterProvider>(context, listen: false);

    final resultado = await mostrarDialogoTexto(context,
        identificador: 'Escribe tu comentario');
    bool isFirst = report.comentario != 'N/A' || report.comentario != 'n/a';

    if (resultado != null && resultado.isNotEmpty) {
      print('Texto ingresado: $resultado');
      report.comentario = isFirst
          ? '${report.comentario}, $resultado (${currentUsers?.fullName})'
          : '${report.comentario},(${currentUsers?.fullName})';
      await provider.updatePlan(report);
      print(report.toJson());
    } else {
      print('No se ingresó texto o fue cancelado');
    }
  }

  void mostrarInputAsignacion(context, PrinterPlan report) async {
    final provider = Provider.of<PrinterProvider>(context, listen: false);
    final resultado =
        await mostrarDialogoTexto(context, identificador: 'Asignar A :');

    if (resultado != null && resultado.isNotEmpty) {
      print('Texto ingresado: $resultado');

      final esNumero = RegExp(r'^\d+$').hasMatch(resultado);

      if (!esNumero) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Solo se permiten números")),
        );
        return;
      }
      report.asignado = resultado;
      await provider.updatePlan(report);
      print(report.toJson());
    } else {
      print('No se ingresó texto o fue cancelado');
    }
  }

  void mostrarInputIndex(BuildContext context, PrinterPlan report) async {
    final provider = context.read<PrinterProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final resultado =
        await mostrarDialogoTexto(context, identificador: 'Asignar Index :');

    if (resultado != null && resultado.isNotEmpty) {
      report.indexWork = int.tryParse(resultado ?? '0') ?? 0;

      try {
        await provider.updatePlan(report);
        // provider.setDiaPicked(provider.diaPicked ?? 'lunes');
        scaffoldMessenger.showSnackBar(
          const SnackBar(
              content: Text('Trabajo actualizado exitosamente'),
              backgroundColor: Colors.green),
        );
      } catch (e) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
              content: Text('Error al actualizar: $e'),
              backgroundColor: Colors.red),
        );
      }
    } else {
      print('No se ingresó texto o fue cancelado');
    }
  }
}
