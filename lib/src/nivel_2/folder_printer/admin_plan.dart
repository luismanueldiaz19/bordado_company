import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../datebase/current_data.dart';
import '../../model/users.dart';
import '../../screen_print_pdf/apis/pdf_api.dart';
import '../../util/commo_pallete.dart';
import '../../util/get_formatted_number.dart';
import '../../util/helper.dart';
import '../../util/show_mesenger.dart';
import '../../widgets/loading.dart';
import 'edit_admin_plan.dart';
import 'model/printer_plan.dart';
import 'pdf_print.dart';
import 'printer_provider.dart';
import 'printer_services.dart';
import 'ver_imagenes_page.dart';

class AdminPlan extends StatefulWidget {
  const AdminPlan({super.key});

  @override
  State createState() => _AdminPlanState();
}

class _AdminPlanState extends State<AdminPlan> {
  final PrinterServices _service = PrinterServices();
  String? date1 = DateTime.now().toString().substring(0, 10);
  String? date2 = DateTime.now().toString().substring(0, 10);
  List<PrinterPlan> _planes = [];
  List<PrinterPlan> _planeFilter = [];
  String? filtroDepart;
  String? filtroDiaSemana;
  String? filtroEstado;
  String? filtroFecha;

  Future<void> getPlanesAdmin() async {
    try {
      List<PrinterPlan> response =
          await _service.getPlaningAdmin(date1!, date2!);
      if (response.isNotEmpty) {
        _planes = response;
        _planeFilter = _planes;
      } else {
        _planes = [];
        _planeFilter = [];
      }
    } catch (e) {
      _planes = [];
      _planeFilter = [];
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPlanesAdmin();
  }

  clean() {
    setState(() {
      filtroDepart = null;
      filtroDiaSemana = null;
      filtroEstado = null;
      filtroFecha = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool hasPermisoActualizar = hasPermissionUsuario(
        currentUsers!.listPermission!, "plan", "actualizar");
    bool hasPermisoEliminar =
        hasPermissionUsuario(currentUsers!.listPermission!, "plan", "eliminar");
    bool hasPermisoAdmin =
        hasPermissionUsuario(currentUsers!.listPermission!, "plan", "crear");
    final providerRead = context.read<PrinterProvider>();
    final style = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Plan'),
        actions: [
          if (_planeFilter.isNotEmpty)
            IconButton(
                onPressed: () async {
                  final pdfFile = await PrintPlan.generate(_planeFilter);
                  PdfApi.openFile(pdfFile);
                },
                icon: const Icon(Icons.print)),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Tooltip(
              message: 'Seleccionar Fecha',
              child: Container(
                margin: const EdgeInsets.only(right: 1),
                child: IconButton(
                  icon: const Icon(Icons.calendar_month, color: Colors.black),
                  onPressed: () {
                    selectDateRange(context, (firstDate, secondDate) {
                      date1 = firstDate;
                      date2 = secondDate;
                      getPlanesAdmin();
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          if (_planeFilter.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildDropdown(
                      label: "Departamento",
                      value: filtroDepart,
                      items: PrinterPlan.getDepartmentUnique(_planes),
                      onChanged: (value) {
                        setState(() {
                          filtroDepart = value;
                          filtroDiaSemana = null;
                          filtroEstado = null;
                          filtroFecha = null;
                        });
                        filtrarRegistros();
                      },
                      style: style.bodySmall,
                    ),
                    const SizedBox(width: 12),
                    _buildDropdown(
                      label: "Fecha",
                      value: filtroFecha,
                      items: PrinterPlan.getFechaUnique(_planeFilter),
                      onChanged: (value) {
                        setState(() => filtroFecha = value);
                        filtrarRegistros();
                      },
                      style: style.bodySmall,
                    ),
                    const SizedBox(width: 12),
                    _buildDropdown(
                      label: "Estado",
                      value: filtroEstado,
                      items: PrinterPlan.getEstadoUnique(_planeFilter),
                      onChanged: (value) {
                        setState(() => filtroEstado = value);
                        filtrarRegistros();
                      },
                      style: style.bodySmall,
                    ),
                    const SizedBox(width: 12),
                    _buildDropdown(
                      label: "Día Semana",
                      value: filtroDiaSemana,
                      items: PrinterPlan.getSemanaUnique(_planeFilter),
                      onChanged: (value) {
                        setState(() => filtroDiaSemana = value);
                        filtrarRegistros();
                      },
                      style: style.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          _planeFilter.isNotEmpty
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
                          dataRowMaxHeight: 30,
                          dataRowMinHeight: 20,
                          horizontalMargin: 10.0,
                          columnSpacing: 15,
                          headingRowHeight: 35,
                          decoration: const BoxDecoration(),
                          border: TableBorder.symmetric(
                              outside: BorderSide(
                                  color: Colors.grey.shade100,
                                  style: BorderStyle.none),
                              inside: const BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.grey)),
                          headingTextStyle: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          dataTextStyle: const TextStyle(color: Colors.black87),
                          headingRowColor: MaterialStateColor.resolveWith(
                              (states) => moradoDiseno),
                          columns: [
                            const DataColumn(label: Text('DEPARTAMENTO')),
                            const DataColumn(label: Text('VER')),
                            if (hasPermisoEliminar)
                              const DataColumn(label: Text('DIAS')),
                            const DataColumn(label: Text('FECHA')),
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
                              const DataColumn(label: Text('EDITAR')),
                            if (hasPermisoEliminar)
                              const DataColumn(label: Text('QUITAR')),
                          ],
                          rows: _planeFilter.asMap().entries.map((entry) {
                            int index = entry.key;
                            var report = entry.value;
                            return DataRow(
                              color: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (index.isOdd) {
                                    return Colors.grey.shade300;
                                  }
                                  return Colors.white;
                                },
                              ),
                              cells: [
                                DataCell(Text(report.nameDepart.toString())),
                                DataCell(const Text('Ver'), onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VerImagenesPage(item: report)),
                                  );
                                }),
                                if (hasPermisoAdmin)
                                  DataCell(
                                      Text(quitarAcentos(
                                          report.diaSemana.toString())),
                                      onTap: () {
                                    print(report.toJson());
                                  }),
                                DataCell(Text(report.fechaTrabajo.toString())),
                                DataCell(Text(report.estado.toString())),
                                DataCell(Center(
                                    child: Text(report.indexWork.toString()))),
                                DataCell(Text(report.nombreLogo.toString())),
                                DataCell(Center(
                                  child: Text(
                                      getNumFormatedDouble(
                                          report.cantidad.toString()),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                )),
                                DataCell(Text(report.tipoTrabajo.toString())),
                                DataCell(Text(report.asignado.toString())),
                                DataCell(Text(report.ficha.toString())),
                                DataCell(Text(report.orden.toString())),
                                DataCell(
                                    Text(limitarTexto(
                                        report.comentario.toString(), 10)),
                                    onTap: () => utilShowMesenger(
                                        context, report.comentario ?? '')),
                                if (hasPermisoEliminar)
                                  DataCell(const Text('Editar'), onTap: () {
                                    print(report.printerPlaningId);
                                    // providerRead.eliminarPlan(report.toJson());
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditAdminPlan(item: report)),
                                    );
                                  }),
                                if (hasPermisoEliminar)
                                  DataCell(const Text('Quitar'), onTap: () {
                                    // print(report.printerPlaningId);
                                    clean();
                                    providerRead.eliminarPlan(report.toJson());

                                    setState(() {
                                      _planes.remove(report);
                                      _planeFilter = _planes;
                                    });
                                  }),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                )
              : const LoadingNew(
                  text: 'No hay datos',
                  scale: 10,
                ),
          identy(context)
        ],
      ),
    );
  }

  void filtrarRegistros() {
    // print('filtroModulo : $filtroModulo  y  filtroArea : $filtroArea');
    _planeFilter = _planes.where((r) {
      final cumpleModulo = filtroDepart == null || r.nameDepart == filtroDepart;
      final cumpleArea = filtroFecha == null || r.fechaTrabajo == filtroFecha;
      final cumpleSeccion = filtroEstado == null || r.estado == filtroEstado;
      final cumpleTaste =
          filtroDiaSemana == null || r.diaSemana == filtroDiaSemana;

      return cumpleModulo && cumpleArea && cumpleSeccion && cumpleTaste;
      //     cumpleZona;
    }).toList();

    // print('Lista encontradas: ${_listFilter.length}');
    setState(() {});
  }
}

Widget _buildDropdown({
  required String label,
  required String? value,
  required List<String> items,
  required void Function(String?) onChanged,
  required TextStyle? style,
}) {
  return Container(
    height: 40,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(8),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        hint: Text("Seleccionar $label", style: style),
        items: items.map((m) {
          return DropdownMenuItem(value: m, child: Text(m, style: style));
        }).toList(),
        onChanged: onChanged,
        icon: const Icon(Icons.arrow_drop_down),
        style: style,
        dropdownColor: Colors.white,
      ),
    ),
  );
}
