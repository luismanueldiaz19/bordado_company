import 'dart:convert';
import 'dart:io';
import 'package:bordado_company/src/services/api_services.dart';
import 'package:bordado_company/src/util/get_formatted_number.dart';
import 'package:bordado_company/src/util/show_mesenger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../model/orden_work.dart';
import '../../../model/tipo_trabajo.dart';
import '../../../widgets/custom_comment_widget.dart';
import '../../folder_printer/model/printer_plan.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/nivel_2/forder_sublimacion/model_nivel/image_get_path_file.dart';
import 'package:file_picker/file_picker.dart';
import '/src/util/get_time_relation.dart';
import '/src/util/helper.dart';
import '../../../model/users.dart';

class CardSublimacion extends StatefulWidget {
  const CardSublimacion({
    super.key,
    required this.current,
    required this.eliminarPress,
  });
  final OrdenWork current;
  final Function eliminarPress;

  @override
  State<CardSublimacion> createState() => _CardSublimacionState();
}

class _CardSublimacionState extends State<CardSublimacion> {
  final ApiService _apiService = ApiService();

  ////////////Multi Imagen/////
  List<File> listFile = [];
  List<String> listBase64Imagen = [];

  /// en usos
  List<String> listFilename = [];
  final ImagePicker _picker = ImagePicker();
  /////////////////////////
  /////los validator de image Picked
  List<ImageGetPathFile> imageGetServer = [];

  ////////////////////////

  Future obtenerImage() async {
    listBase64Imagen.clear();
    // print(Platform.isWindows);
    if (Platform.isWindows) {
      return pickeFileWindow();
    }

    if (Platform.isAndroid) {
      return pickedAndroid();
    }
  }

  Future pickedAndroid() async {
    final List<XFile> image = await _picker.pickMultiImage(imageQuality: 80);

    for (var element in image) {
      // base64Image = base64Encode(file.readAsBytesSync());
      // print('path de la imahgen ${element.path}');
      // listFile.add(File(element.path));
      // // print('Archivo : ${element.path}');
      // File localfile = File(element.path);
      // String localName = localfile.path.split('/').last;
      // // print('localName $localName');
      // listBase64Imagen.add(base64Encode(localfile.readAsBytesSync()));
      // listFilename.add(localName);
      // await Future.delayed(const Duration(milliseconds: 100));
    }

    await sendMulpleImage(listBase64Imagen);
  }

  Future sendMulpleImage(List listBase64Imagen) async {
    for (int i = 0; i < listBase64Imagen.length; i++) {
      final res = await httpRequestDatabase(uploadImagenSublimacion, {
        'image': '${listBase64Imagen[i]}',
        'name': listFilename[i],
        // 'token': appTOKEN,
      });
      print('  sendMulpleImage  :${res.body}');
      insertImageServer(listFilename[i].toString());
    }
    // print('Exit Ciclo imagen');

    // getImageServer();
  }

/////metodo de insert el path de la imagen //////
  Future insertImageServer(String path) async {
    // final res = await httpRequestDatabase(insertImagePathFile, {
    //   'image_path': path,
    //   'id_path': widget.current.idCliente,
    //   'date_current': DateTime.now().toString().substring(0, 19),
    // });

    // print('insertImageServer : s${res.body}');
  }

  ///para windows
  FilePickerResult? result;

  Future pickeFileWindow() async {
    result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        dialogTitle: 'Select a file for our App',
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'png',
        ]);

    if (result == null) return;

    for (PlatformFile file in result!.files) {
      // File localfile = File(file.path!);
      // String localName = file.name;
      // // print('localName $localName');
      // listBase64Imagen.add(base64Encode(localfile.readAsBytesSync()));
      // listFilename.add(localName);
      // print('Archivo : $listFilename');
    }

    await sendMulpleImage(listBase64Imagen);
  }

  void ajustarStart(OrdenWork item) async {
    bool? value = await showConfirmationDialogOnyAsk(context, actionMjs);
    if (value != null && value) {
      item.startDate = DateTime.now().toString().substring(0, 19);
      item.endDate = null;
      actualizarItem(item);
    }
  }

  void ajustarEnd(OrdenWork item) async {
    bool? value = await showConfirmationDialogOnyAsk(context, actionMjs);
    if (value != null && value) {
      item.endDate = DateTime.now().toString().substring(0, 19);
      actualizarItem(item);
    }
  }

  void ajustarComentario(OrdenWork item) async {
    String? valueCant = await showDialog<String>(
        context: context,
        builder: (context) {
          return const AddComentarioCustom(
              text: 'Comentario', textFielName: 'Escribir');
        });

    if (valueCant != null) {
      final oldComentario =
          '${item.observacionesHoja}, (${currentUsers?.fullName} Comentó : ${valueCant.toString().trim()} a la (${DateTime.now().toString().substring(0, 19)}). ';
      item.observacionesHoja = oldComentario.toString();
      actualizarItem(item);
    }
  }

  void ajustarCantProducion(Campo itemCampo) async {
    ///actualizarCantProducion
    ///
    String? valueCant = await showDialog<String>(
        context: context,
        builder: (context) {
          return AddComentarioCustom(
            text: 'Poner Cantidad',
            textFielName: 'Cantidad',
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          );
        });

    if (valueCant != null) {
      itemCampo.cant = valueCant;
      final jsonDataLocal = {
        'hoja_produccion_campos_id': itemCampo.hojaProduccionCamposId,
        'cant': itemCampo.cant.toString().trim(),
      };
      actualizarCantProducion(jsonDataLocal);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    bool _isEliminar = hasPermissionUsuario(
        currentUsers!.listPermission!, "operador", "eliminar");
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withAlpha(77),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: PrinterPlan.getColorByDepartment(
                    widget.current.nameDepartment ?? 'N/A')
                .withAlpha(51), // alpha 0.2 * 255 ≈ 51
            blurRadius: 12,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.image, color: Colors.black54, size: 15),
                      const SizedBox(width: 5),
                      Text(widget.current.nameLogo.toString().toUpperCase(),
                          style: style.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.numbers,
                              color: Colors.black54, size: 15),
                          const SizedBox(width: 5),
                          Text('Orden :',
                              style: style.bodySmall
                                  ?.copyWith(color: Colors.black54)),
                          const SizedBox(width: 5),
                          Text(widget.current.numOrden.toString().toUpperCase())
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.numbers_outlined,
                              color: Colors.black54, size: 15),
                          const SizedBox(width: 5),
                          Text('Ficha : ',
                              style: style.bodySmall
                                  ?.copyWith(color: Colors.black54)),
                          const SizedBox(width: 5),
                          Text(widget.current.ficha.toString().toUpperCase()),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 28,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Cantidad De Orden ', style: style.bodySmall),
                  Text(getNumFormatedDouble(widget.current.cantOrden ?? '0')),
                  Text('Piezas', style: style.bodySmall),
                  const VerticalDivider(color: Colors.black12),
                  Text('0.0 %', style: style.bodyLarge),
                ],
              ),
            ),

            const Divider(color: Colors.black12),
            if (widget.current.campos != null &&
                widget.current.campos!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      widget.current.nameTrabajo ?? 'N/A',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: PrinterPlan.getColorByDepartment(
                            widget.current.nameDepartment ?? 'N/A'),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 2),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.current.campos!.length,
                    itemBuilder: (context, index) {
                      final itemCampo = widget.current.campos![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.label_important_outline,
                                    size: style.bodySmall!.fontSize),
                                const SizedBox(width: 8),
                                Text(itemCampo.nombreCampo ?? 'Sin nombre',
                                    style: style.titleSmall)
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                print(itemCampo.toJson());
                                ajustarCantProducion(itemCampo);
                              },
                              //  () => ajustarCantProducion(itemCampo),
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                padding: EdgeInsets.zero,
                                height: 20,
                                width: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueGrey.withAlpha(77),
                                      blurRadius: 1,
                                      offset: const Offset(0, 1),
                                    ),
                                    BoxShadow(
                                      color: PrinterPlan.getColorByDepartment(
                                              widget.current.nameDepartment ??
                                                  'N/A')
                                          .withAlpha(
                                              51), // alpha 0.2 * 255 ≈ 51
                                      blurRadius: 12,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  getNumFormatedDouble(itemCampo.cant ?? '0'),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // CustomLoginButton(
                  //   onPressed: () => enviarToProducion(context),
                  //   text: 'Tomar Producción',
                  //   colorButton: PrinterPlan.getColorByDepartment(
                  //       widget.orden?.nameDepartment ?? 'N/A'),
                  //   width: 250,
                  // )
                ],
              ),
            // const Divider(),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(widget.current.nameTrabajo.toString(),
            //           style:
            //               style.bodySmall?.copyWith(color: Colors.black54)),
            //       const Tooltip(
            //           message: 'Calidad verificada',
            //           child: Icon(Icons.check,
            //               color: colorsGreenLevel, size: 15)),
            //       Text(widget.current.usuarioId.toString(),
            //           style: style.titleSmall?.copyWith(color: colorsAd)),
            //     ],
            //   ),
            // ),
            const Divider(color: Colors.black12),
            ///////aqui estaba las pieza pkt
            ///
            ///

            ///lista de imagenes del trabajos

            // widget.current.imagenes!.isNotEmpty
            //     ? SizedBox(
            //         height: 100,
            //         child: SingleChildScrollView(
            //           scrollDirection: Axis.horizontal,
            //           physics: const BouncingScrollPhysics(),
            //           child: Row(
            //             children: widget.current.imagenes!
            //                 .map(
            //                   (image) => Container(
            //                     height: 75,
            //                     width: 100,
            //                     margin: EdgeInsets.symmetric(horizontal: 5),
            //                     decoration: const BoxDecoration(
            //                         borderRadius:
            //                             BorderRadius.all(Radius.circular(5)),
            //                         boxShadow: [shadow],
            //                         color: Colors.white),
            //                     child: ClipRRect(
            //                       borderRadius: BorderRadius.circular(5),
            //                       child: GestureDetector(
            //                         onTap: () async {
            //                           // print('$urlImage${image.imagePath}');
            //                           await showDialog(
            //                               context: context,
            //                               builder: (context) {
            //                                 return AlertDialog(
            //                                   content: Image.network(
            //                                     '$urlImage${image.imagePath}',
            //                                     loadingBuilder: (context,
            //                                         child, loadingProgress) {
            //                                       if (loadingProgress == null)
            //                                         return child;
            //                                       return const Center(
            //                                           child:
            //                                               Text('Loading...'));
            //                                     },
            //                                     errorBuilder: (context, error,
            //                                         stackTrace) {
            //                                       return const Text(
            //                                           'Error Imagen');
            //                                     },
            //                                   ),
            //                                 );
            //                               });
            //                         },
            //                         child: Image.network(
            //                           '$urlImage${image.imagePath}',
            //                           loadingBuilder:
            //                               (context, child, loadingProgress) {
            //                             if (loadingProgress == null) {
            //                               return child;
            //                             }
            //                             return const Center(
            //                                 child: Text('Loading...'));
            //                           },
            //                           errorBuilder:
            //                               (context, error, stackTrace) {
            //                             return const Icon(
            //                                 Icons.error_outline);
            //                           },
            //                           fit: BoxFit.cover,
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 )
            //                 .toList(),
            //           ),
            //         ),
            //       )
            //     : const SizedBox(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.current.startDate ?? 'Sin Tiempo',
                          style:
                              style.labelSmall?.copyWith(color: Colors.teal)),
                      Text(widget.current.endDate ?? 'Sin Tiempo',
                          style: style.labelSmall
                              ?.copyWith(color: Colors.redAccent)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.play_arrow),
                          tooltip: 'Actualizar el comienzo',
                          onPressed: () => ajustarStart(widget.current)),
                      IconButton(
                          icon: const Icon(Icons.stop, color: Colors.red),
                          tooltip: 'Actualizar el terminado',
                          onPressed: () => ajustarEnd(widget.current)),
                    ],
                  ),
                  Container(
                    height: 35,
                    width: 75,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.withAlpha(77),
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                        BoxShadow(
                          color: PrinterPlan.getColorByDepartment(
                                  widget.current.nameDepartment ?? 'N/A')
                              .withAlpha(51), // alpha 0.2 * 255 ≈ 51
                          blurRadius: 12,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      getTimeRelationEnMin(widget.current.startDate ?? 'N/A',
                          widget.current.endDate ?? 'N/A'),
                      style: style.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Tooltip(
                    message: 'Comentar',
                    child: IconButton(
                        icon:
                            Icon(Icons.message_outlined, color: Colors.black45),
                        onPressed: () => ajustarComentario(widget.current)),
                  ),
                  Tooltip(
                    message: 'Eliminar',
                    child: IconButton(
                      icon: Icon(Icons.delete_outline_sharp, color: Colors.red),
                      onPressed: () {
                        widget.eliminarPress(widget.current);
                      },
                    ),
                  ),
                  // Tooltip(
                  //   message: 'Editar',
                  //   child: IconButton(
                  //     icon: Icon(Icons.edit, color: Colors.blue),
                  //     onPressed: () {
                  //       // widget.eliminarPress(widget.current);
                  //     },
                  //   ),
                  // ),
                  Tooltip(
                    message: 'Agregar Fotos',
                    child: IconButton(
                      icon:
                          Icon(Icons.add_a_photo_outlined, color: Colors.blue),
                      onPressed: () => obtenerImage(),
                    ),
                  ),
                  Tooltip(
                    message: 'Agregar una incidencia',
                    child: IconButton(
                      icon: Icon(Icons.warning_amber_rounded,
                          color: Colors.orange),
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => AddIncidenciaMainDesdeWork(
                        //         orden: widget.current,
                        //         pickedDepart: Department(
                        //             nameDepartment:
                        //                 widget.current.nameDepartment)),
                        //   ),
                        // );
                      },
                    ),
                  ),
                  CustomLoginButton(
                      onPressed: () => actualizarItem(widget.current),
                      width: 100,
                      text: 'Completar',
                      colorButton: PrinterPlan.getColorByDepartment(
                          widget.current.nameDepartment ?? 'N/A')),
                ],
              ),
            ),
            Text(
              widget.current.observacionesHoja ?? 'Sin Nota',
              textAlign: TextAlign.justify,
              style: style.bodySmall?.copyWith(color: Colors.black45),
            )
          ],
        ),
      ),
    );
  }

  Future actualizarItem(OrdenWork item) async {
    print(item.toJson());

    final value = await _apiService.httpEnviaMap(
        'http://$ipLocal/$pathLocal/produccion/actualizar_hoja.php',
        item.toJson());
    // print(value);
    final r = json.decode(value);

    showScaffoldMessenger(
        context, r['message'], r['success'] ? Colors.green : Colors.red);
    setState(() {});
  }

  Future actualizarCantProducion(jsonDataLocal) async {
    // print(item.toJson());
    final value = await _apiService.httpEnviaMap(
        'http://$ipLocal/$pathLocal/produccion/actualizar_campos_producion.php',
        jsonDataLocal);
    // print(value);
    final r = json.decode(value);

    showScaffoldMessenger(
        context, r['message'], r['success'] ? Colors.green : Colors.red);
    setState(() {});
  }

  //actualizar_campos_producion
}
