import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '/src/model/users.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/get_formatted_number.dart';
import '/src/util/helper.dart';
import '../datebase/current_data.dart';
import '../datebase/methond.dart';
import '../datebase/url.dart';
import '../folder_incidencia_main/editar_product_incidencia.dart';
import '../folder_incidencia_main/model_incidencia/incidencia_main.dart';
import '../folder_print_services/print_incidencia.dart';
import '../folder_services/upload_services.dart';
import '../provider/provider_incidencia.dart';
import '../screen_print_pdf/apis/pdf_api.dart';
import '../util/dialog_confimarcion.dart';
import 'widget_comentario.dart';

class IncidenciaWidget extends StatefulWidget {
  final IncidenciaMain incidencia;

  const IncidenciaWidget({super.key, required this.incidencia});

  @override
  State<IncidenciaWidget> createState() => _IncidenciaWidgetState();
}

class _IncidenciaWidgetState extends State<IncidenciaWidget> {
  ///para windows
  FilePickerResult? result;
  ////////////Multi Imagen/////
  // List<File> listFile = [];
  // List<String> listBase64Imagen = [];

  /// en usos
  // List<String> listFilename = [];
  // final ImagePicker _picker = ImagePicker();
  UploadService uploadService = UploadService();
  /////////////////////////
  /////los validator de image Picked
  // List<ImageGetPathFile> imageGetServer = [];

  Future updateItemIncidencia(context, IncidenciaMain json) async {
    var data = {
      'id_list_incidencia': json.idListIncidencia,
      'ficha': json.ficha,
      'num_orden': json.numOrden,
      'logo': json.logo,
      'ubicacion_queja': json.ubicacionQueja,
      'department_find': json.departmentFind,
      'what_happed': json.whatHapped,
      'compromiso': json.compromiso,
      'estado': json.estado,
      'fecha_resuelto': json.fechaResuelto,
    };
    // print(data);
    await httpRequestDatabase(
        "http://$ipLocal/settingmat/admin/update/update_incidencia_item.php",
        data);
    await Provider.of<ProviderIncidencia>(context, listen: false)
        .getIncidencia('no resuelto');
  }

  editarArticulo(ListProduct report) async {
    final product = await showDialog(
        context: context,
        builder: ((context) {
          return EditarProductIncidencia(report: report);
        }));

    if (product != null) {
      setState(() {});
    }
  }

  Future obtenerImage(context) async {
    List<XFile>? images = await ImagePicker().pickMultiImage(imageQuality: 100);
    if (images.isNotEmpty) {
      String? comment = await showDialog<String>(
        context: context,
        builder: (context) {
          return const AddComentario(
              text: 'Nota ?',
              textInputType: TextInputType.text,
              textFielName: 'Escribir Nota');
        },
      );

      if (comment != null) {
        for (XFile image in images) {
          // print(image.path);
          final res = await uploadService.uploadImageIncidencia(
              File(image.path),
              widget.incidencia.idListIncidencia!,
              image.name,
              comment);
          // print('upload_document_profiles : ciclo for  : ${res}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(res.toString()),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 1)));
          widget.incidencia.listImagenes?.add(ListImagene(
              comentario: comment,
              createdAt: DateTime.now().toString(),
              imagenPath: image.name,
              idListIncidencia: '1111'));
        }
      }
    }
    setState(() {});
  }

  deleteImage(context, ListImagene imagen) async {
    // print(imagen.toJson());
    final res = await httpRequestDatabase(
        "http://$ipLocal/settingmat/incidencia_imagen/delete_imagen_incidencia.php",
        {
          'imagen_path': imagen.imagenPath ?? '',
          'id_list_imagen_incidencia': imagen.idListImagenIncidencia,
        });
    final data = jsonDecode(res.body);
    if (data['success']) {
      setState(() {
        widget.incidencia.listImagenes?.remove(imagen);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message']),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message']),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.red,
        ),
      );
    }
    // /imagen_path  and id_list_imagen_incidencia

    // {id_list_imagen_incidencia: c2ecc7d2-c572-411f-b03e-49a52bf9f9ad,
    // imagen_path: logo_vitamed.jpg, comentario: N/A,
    // created_at: 2024-10-29,
    // id_list_incidencia: f97ee8f6-e06b-4163-98eb-4fca85e56311}
  }

  showImagenDialog(ListImagene imagen) async {
    await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Image.network(
                      'http://$ipLocal/settingmat/incidencia_imagen/${imagen.imagenPath}'),
                ),
                Expanded(child: Text(imagen.comentario ?? 'N/A')),
              ],
            ),
          );
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
    const urlIamge = 'http://$ipLocal/settingmat/incidencia_imagen/';

    return Container(
      decoration: decoration,
      margin: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.incidencia.logo ?? "Sin Logo",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Image.asset('assets/incidente.png',
                      scale: 5, height: 50, width: 50)
                ],
              ),
            ),
            // Información básica
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Ficha:'),
                      Text(widget.incidencia.ficha ?? "N/A",
                          style: style.titleSmall),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Número de Orden:'),
                      Text(widget.incidencia.numOrden ?? "N/A",
                          style: style.titleSmall),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Ubicación Queja:'),
                      Text(widget.incidencia.ubicacionQueja ?? "N/A",
                          style: style.titleSmall),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Quien Encontró:'),
                      Text(widget.incidencia.departmentFind ?? "N/A",
                          style: style.titleSmall),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Icon(Icons.public_outlined,
                  //         size: style.bodyLarge?.fontSize),
                  //     Text(incidencia.registedBy ?? "N/A",
                  //         style: style.titleSmall),
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Fecha de solución :'),
                      Text(widget.incidencia.fechaResuelto ?? "N/A",
                          style: style.titleSmall),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Registrado por :'),
                      Text(widget.incidencia.registedBy ?? "N/A",
                          style: style.titleSmall),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  Text('Que pasó:', style: style.titleSmall),
                  Text(
                    widget.incidencia.whatHapped ?? "N/A",
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 8,
                    style: style.bodyMedium
                        ?.copyWith(color: colorsRedOpaco, fontSize: 16),
                  ),
                  const Divider(),
                  Text('Se comprometieron a :', style: style.titleSmall),
                  Text(
                    widget.incidencia.compromiso ?? "N/A",
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 8,
                    style: style.bodyMedium
                        ?.copyWith(color: colorsGreenTablas, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Center(
                child: Text('Estado: ${widget.incidencia.estado ?? "N/A"}',
                    style: style.titleMedium)),
            const SizedBox(height: 5), const Divider(),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('Productos afectados', style: style.titleSmall)),
            const SizedBox(height: 5),
            if (widget.incidencia.listProducts != null &&
                widget.incidencia.listProducts!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DataTable(
                  dataRowMaxHeight: 20,
                  dataRowMinHeight: 15,
                  horizontalMargin: 10.0,
                  columnSpacing: 15,
                  headingRowHeight: 20,
                  decoration: const BoxDecoration(color: colorsOrange),
                  headingTextStyle: const TextStyle(color: Colors.white),
                  border: TableBorder.symmetric(
                      outside: BorderSide(
                          color: Colors.grey.shade100, style: BorderStyle.none),
                      inside: const BorderSide(
                          style: BorderStyle.solid, color: Colors.grey)),
                  columns: const [
                    DataColumn(label: Text('Producto')),
                    DataColumn(label: Text('Cantidad')),
                    DataColumn(label: Text('Costo')),
                    DataColumn(label: Text('Subtotal')),
                    DataColumn(label: Text('Editar')),
                  ],
                  rows: widget.incidencia.listProducts!
                      .asMap()
                      .entries
                      .map((entry) {
                    int index = entry.key;
                    var report = entry.value;
                    return DataRow(
                      color: MaterialStateProperty.resolveWith<Color>(
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
                        DataCell(Text(report.nameProduct ?? 'N/A')),
                        DataCell(Center(child: Text(report.cant.toString()))),
                        DataCell(Text('\$ ${report.costo.toString()}')),
                        DataCell(Text(
                            '\$ ${getNumFormatedDouble(ListProduct.getSubtotal(report))}')),
                        hasPermissionUsuario(currentUsers!.listPermission!,
                                    "incidencia", "eliminar") ||
                                hasPermissionUsuario(
                                    currentUsers!.listPermission!,
                                    "admin",
                                    "crear")
                            ? DataCell(const Text('Editar'),
                                onTap: () => editarArticulo(report))
                            : const DataCell(Text('Sin Permiso')),
                      ],
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 5),
            const Divider(),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('Empleado responsables', style: style.titleSmall)),
            const SizedBox(height: 5),
            // Lista de usuarios responsables
            if (widget.incidencia.listUsuarioResponsable != null &&
                widget.incidencia.listUsuarioResponsable!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DataTable(
                  dataRowMaxHeight: 20,
                  dataRowMinHeight: 15,
                  horizontalMargin: 10.0,
                  columnSpacing: 15,
                  headingRowHeight: 20,
                  decoration: const BoxDecoration(color: colorsPuppleOpaco),
                  headingTextStyle: const TextStyle(color: Colors.white),
                  border: TableBorder.symmetric(
                      outside: BorderSide(
                          color: Colors.grey.shade100, style: BorderStyle.none),
                      inside: const BorderSide(
                          style: BorderStyle.solid, color: Colors.grey)),
                  columns: const [
                    DataColumn(label: Text('Empleado')),
                    DataColumn(label: Text('Codigo')),
                  ],
                  rows: widget.incidencia.listUsuarioResponsable!
                      .asMap()
                      .entries
                      .map((entry) {
                    int index = entry.key;
                    var report = entry.value;
                    return DataRow(
                      color: MaterialStateProperty.resolveWith<Color>(
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
                        DataCell(Text(report.fullName ?? 'N/A')),
                        DataCell(Text(report.code.toString())),
                      ],
                    );
                  }).toList(),
                ),
              ),
            // Lista de departamentos responsables
            const SizedBox(height: 5),
            const Divider(),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('Lista departamentos', style: style.titleSmall)),
            const SizedBox(height: 5),
            if (widget.incidencia.listDepartamentoResponsable != null &&
                widget.incidencia.listDepartamentoResponsable!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DataTable(
                  dataRowMaxHeight: 20,
                  dataRowMinHeight: 15,
                  horizontalMargin: 10.0,
                  columnSpacing: 15,
                  headingRowHeight: 20,
                  decoration: const BoxDecoration(color: colorsBlueDeepHigh),
                  headingTextStyle: const TextStyle(color: Colors.white),
                  border: TableBorder.symmetric(
                      outside: BorderSide(
                          color: Colors.grey.shade100, style: BorderStyle.none),
                      inside: const BorderSide(
                          style: BorderStyle.solid, color: Colors.grey)),
                  columns: const [
                    DataColumn(label: Text('Departamento')),
                  ],
                  rows: widget.incidencia.listDepartamentoResponsable!
                      .asMap()
                      .entries
                      .map((entry) {
                    int index = entry.key;
                    var report = entry.value;
                    return DataRow(
                      color: MaterialStateProperty.resolveWith<Color>(
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
                        DataCell(Text(report.departmentResponsable ?? 'N/A')),
                      ],
                    );
                  }).toList(),
                ),
              ),

            // Lista de imágenes
            if (widget.incidencia.listImagenes != null &&
                widget.incidencia.listImagenes!.isNotEmpty)
              ExpansionTile(
                title: Text('Imágenes', style: style.bodySmall),
                children: widget.incidencia.listImagenes!.map((imagen) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.network(
                                      '$urlIamge${imagen.imagenPath}',
                                      scale: 5,
                                      height: 75,
                                      width: 75,
                                      fit: BoxFit.contain),
                                ),
                                onTap: () => showImagenDialog(imagen),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                  child: Text(imagen.comentario ?? "N/A",
                                      textAlign: TextAlign.justify,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 8,
                                      style: style.bodySmall)),
                            ],
                          ),
                          hasPermissionUsuario(currentUsers!.listPermission!,
                                  "incidencia", "eliminar")
                              ? Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: SizedBox(
                                        width: 100,
                                        child: TextButton.icon(
                                          icon: Icon(Icons.close,
                                              size: style.bodyLarge?.fontSize,
                                              color: Colors.red),
                                          onPressed: () =>
                                              deleteImage(context, imagen),
                                          label: Text(
                                            'Eliminar',
                                            style: style.bodySmall
                                                ?.copyWith(color: Colors.red),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

            if (hasPermissionUsuario(
                    currentUsers!.listPermission!, "incidencia", "eliminar") ||
                hasPermissionUsuario(
                    currentUsers!.listPermission!, "admin", "crear"))
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () async {
                          final doc =
                              await PrintIncidencia.generate(widget.incidencia);
                          await PdfApi.openFile(doc);
                        },
                        icon: const Icon(Icons.print)),
                    TextButton(
                        onPressed: () => obtenerImage(context),
                        child: const Text('Cargar Imagen',
                            style: TextStyle(color: Colors.black54))),
                    widget.incidencia.estado != 'resuelto'
                        ? customButton(
                            width: 175,
                            colors: colorsGreenTablas,
                            colorText: Colors.white,
                            textButton: 'Marcar resuelto',
                            onPressed: () => matchResuelto(context))
                        : const SizedBox(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  matchResuelto(context_) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmacionDialog(
          mensaje: 'Esta seguro de marcar como resuelto?',
          titulo: 'Aviso',
          onConfirmar: () async {
            widget.incidencia.fechaResuelto =
                DateTime.now().toString().substring(0, 10);
            widget.incidencia.estado = 'resuelto';
            await updateItemIncidencia(context, widget.incidencia);

            Navigator.of(context_).pop();
            // getWork();
          },
        );
      },
    );
    setState(() {});
  }
}
