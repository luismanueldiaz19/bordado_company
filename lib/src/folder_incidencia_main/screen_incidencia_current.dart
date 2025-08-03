import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/src/folder_incidencia_main/detail_incidencia.dart';
import '/src/model/users.dart';
import '/src/provider/provider_incidencia.dart';
import '/src/util/helper.dart';
import '/src/util/show_mesenger.dart';
import '/src/widgets/validar_screen_available.dart';
import '../datebase/current_data.dart';
import '../folder_print_services/print_incidencia.dart';
import '../nivel_2/folder_reception/file_view_orden.dart';
import '../screen_print_pdf/apis/pdf_api.dart';
import '../util/commo_pallete.dart';
import 'model_incidencia/incidencia_main.dart';

class ScreenIncidenciaCurrent extends StatefulWidget {
  const ScreenIncidenciaCurrent({super.key});

  @override
  State<ScreenIncidenciaCurrent> createState() =>
      _ScreenIncidenciaCurrentState();
}

class _ScreenIncidenciaCurrentState extends State<ScreenIncidenciaCurrent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProviderIncidencia>(context, listen: false)
          .getIncidencia('no resuelto');
    });
  }

  @override
  Widget build(BuildContext context) {
    const shadow =
        BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 10);
    final decoration = BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [shadow]);
    final style = Theme.of(context).textTheme;

    List<IncidenciaMain> listFilter =
        context.watch<ProviderIncidencia>().listFilter;

    final providerData = context.read<ProviderIncidencia>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incidencia activas'),
      ),
      body: ValidarScreenAvailable(
        windows: Column(
          children: [
            const SizedBox(width: double.infinity),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BounceInDown(
                      curve: Curves.elasticOut,
                      child: Image.asset('assets/seguimiento.png', scale: 6)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      'Resuelve tus Incidencias',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Text('Toma el control de tus usuarios',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: const [shadow],
                    ),
                    child: TextField(
                      onChanged: (value) => providerData.searchingItem(value),
                      decoration: InputDecoration(
                          hintText: 'Buscar', // Texto de ayuda más descriptivo
                          border: InputBorder
                              .none, // Mantiene sin borde el campo de texto
                          suffixIcon: Icon(Icons.search,
                              color: Colors.grey[600],
                              size: 24), // Estiliza el icono de búsqueda
                          contentPadding:
                              const EdgeInsets.only(left: 25, top: 10)),
                    ),
                  ),
                ],
              ),
            ),
            listFilter.isEmpty
                ? Expanded(
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
                  )
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(25),
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
                              headingRowHeight: 25,
                              decoration:
                                  const BoxDecoration(color: colorsGreenLevel),
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
                              columns: const [
                                DataColumn(label: Text('PDF')),
                                DataColumn(label: Text('Ver Detalles')),
                                DataColumn(label: Text('Encontrado por')),
                                DataColumn(label: Text('Num Orden')),
                                DataColumn(label: Text('Ficha')),
                                DataColumn(label: Text('Logo')),
                                DataColumn(label: Text('Causa')),
                                DataColumn(label: Text('Compromiso')),
                                DataColumn(
                                    label: Text('Empleados Responsable')),
                                DataColumn(label: Text('Depart Responsable')),
                                DataColumn(label: Text('Creado en')),
                                DataColumn(label: Text('Resuelto en')),
                                DataColumn(label: Text('Registrado por')),
                                DataColumn(label: Text('Eliminar')),
                              ],
                              rows: listFilter.asMap().entries.map((entry) {
                                int index = entry.key;
                                IncidenciaMain report = entry.value;
                                return DataRow(
                                  color:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      // Alterna el color de fondo entre gris y blanco
                                      if (index.isOdd) {
                                        return Colors.grey
                                            .shade300; // Color de fondo gris para filas impares
                                      }
                                      return Colors
                                          .white; // Color de fondo blanco para filas pares
                                    },
                                  ),
                                  cells: [
                                    DataCell(
                                        const Text('Pdf',
                                            style: TextStyle(
                                                color: colorsAd,
                                                fontWeight: FontWeight.w500)),
                                        onTap: () async {
                                      final doc =
                                          await PrintIncidencia.generate(
                                              report);
                                      await PdfApi.openFile(doc);
                                    }),
                                    DataCell(
                                        const Text('Click !',
                                            style: TextStyle(
                                                color: colorsAd,
                                                fontWeight: FontWeight.w500)),
                                        onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailIncidencia(
                                                    report: report)),
                                      );
                                    }),
                                    DataCell(
                                        Text(report.departmentFind ?? 'N/A')),
                                    DataCell(Text(report.numOrden ?? 'N/A'),
                                        onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FileViewer(
                                                  numOrden: report.numOrden)));
                                    }),
                                    DataCell(Text(report.ficha ?? 'N/A')),
                                    DataCell(
                                        Text(report.logo != null &&
                                                report.logo!.length > 15
                                            ? '${report.logo!.substring(0, 15)}...'
                                            : report.logo ?? ''), onTap: () {
                                      utilShowMesenger(
                                          context, report.logo ?? '');
                                    }),
                                    DataCell(
                                        Text(
                                          report.whatHapped != null &&
                                                  report.whatHapped!.length > 15
                                              ? '${report.whatHapped!.substring(0, 15)}...'
                                              : report.whatHapped ?? '',
                                          style: TextStyle(
                                              color: Colors.red.shade300),
                                        ), onTap: () {
                                      utilShowMesenger(
                                          context, report.whatHapped ?? '');
                                    }),
                                    DataCell(
                                        Text(report.compromiso != null &&
                                                report.compromiso!.length > 30
                                            ? '${report.compromiso!.substring(0, 30)}...'
                                            : report.compromiso ?? ''),
                                        onTap: () {
                                      utilShowMesenger(
                                          context, report.compromiso ?? '');
                                    }),
                                    DataCell(
                                        Center(
                                          child: Text(report
                                              .listUsuarioResponsable!.length
                                              .toString()),
                                        ),
                                        onTap: () => viewUsuario(context,
                                            report.listUsuarioResponsable!)),
                                    DataCell(
                                        Center(
                                          child: Text(report
                                              .listDepartamentoResponsable!
                                              .length
                                              .toString()),
                                        ),
                                        onTap: () => viewDepartment(
                                            context,
                                            report
                                                .listDepartamentoResponsable!)),
                                    DataCell(Text(report.createdAt ?? 'N/A')),
                                    DataCell(
                                        Text(report.fechaResuelto ?? 'N/A')),
                                    DataCell(Text(report.registedBy ?? 'N/A')),
                                    hasPermissionUsuario(
                                            currentUsers!.listPermission!,
                                            "incidencia",
                                            "eliminar")
                                        ? DataCell(
                                            const Text('Eliminar'),
                                            onTap: report.listImagenes!.isEmpty
                                                ? () => providerData
                                                    .deleteFromIncidencia(
                                                        report.idListIncidencia,
                                                        'no resuelto')
                                                : () {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Debe de borrar las imagenes cargadas al la incidencia'),
                                                        duration: Duration(
                                                            seconds: 1),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                  },
                                          )
                                        : const DataCell(Text('Sin Permiso')),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Total : ${listFilter.length.toString()} Incidencias',
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black45)),
                ],
              ),
            ),
            identy(context)
          ],
        ),
      ),
    );
  }
}
