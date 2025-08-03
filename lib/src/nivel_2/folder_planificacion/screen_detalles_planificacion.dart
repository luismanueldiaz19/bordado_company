import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:bordado_company/src/services/api_services.dart';
import 'package:bordado_company/src/util/commo_pallete.dart';
import 'package:bordado_company/src/util/helper.dart';
import 'package:bordado_company/src/widgets/loading.dart';
import 'package:bordado_company/src/widgets/mensaje_scaford.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import '../../model/orden_list.dart';
import '../../model/tipo_trabajo.dart';
import '../../screen_print_pdf/apis/pdf_api.dart';
import '../../widgets/validar_screen_available.dart';
import '../folder_printer/model/printer_plan.dart';
import '../folder_reception/print_reception/print_orden_cliente_interno.dart';
import '/src/datebase/current_data.dart';
import '/src/model/department.dart';
import '../../datebase/url.dart';
import '../../folder_incidencia_main/add_incidencia_main_desde_work.dart';
import '../folder_reception/orden_file.dart';
import '../forder_sublimacion/model_nivel/sublima.dart';

class DetallesPlanificacion extends StatefulWidget {
  const DetallesPlanificacion({super.key, this.orden});
  final OrdenList? orden;

  @override
  State<DetallesPlanificacion> createState() => _DetallesPlanificacionState();
}

class _DetallesPlanificacionState extends State<DetallesPlanificacion> {
  List<OrdenFiles> files = [];
  final ApiService _api = ApiService();
  List<TipoTrabajo> listTipoTrabajo = [];
  TipoTrabajo? tipoPicked;
  // List<TipoTrabajo> tipoTrabajoFromJson(

  putIncidencia() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddIncidenciaMainDesdeWork(
          orden: Sublima(
              nameLogo: widget.orden!.nameLogo,
              numOrden: widget.orden!.numOrden,
              ficha: widget.orden!.ficha,
              nameDepartment: widget.orden!.nameDepartment),
          pickedDepart:
              Department(nameDepartment: widget.orden!.nameDepartment),
        ),
      ),
    );
  }

  // Método para obtener los archivos desde el servidor
  Future<List<OrdenFiles>> _fetchFiles() async {
    // final url =
    //     'http://$ipLocal/settingmat/admin/select/select_file_orden.php?num_orden=${widget.orden?.numOrden}';

    // final res = await httpRequestDatabaseGET(url);
    // if (res != null) {
    //   final data = jsonDecode(res.body);
    //   if (data['success']) {

    //     return ordenFilesFromJson(
    //         jsonEncode(data['files'])); // Aquí obtienes la lista de archivos
    //   } else {
    //     return [];
    //   }
    // }
    return [];
  }

  Future getTipoTrabajo() async {
    final res = await _api.httpEnviaMap(
        'http://$ipLocal/$pathLocal/produccion/get_tipo_trabajos.php', {
      'area': quitarAcentos(widget.orden?.nameDepartment?.toUpperCase() ?? '')
    });

    final value = json.decode(res);
    if (value['success']) {
      // print(json.encode(value['data']));
      listTipoTrabajo = tipoTrabajoFromJson(json.encode(value['data']));
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getTipoTrabajo();
  }

  bool _loading = false;
  Future enviarToProducion(context) async {
    setState(() {
      _loading = !_loading;
    });
    var data = {
      'start_date': DateTime.now().toString().substring(0, 19),
      'usuario_id': currentUsers!.id,
      'orden_items_id': widget.orden!.ordenItemsId,
      'tipo_trabajo_id': tipoPicked!.tipoTrabajoId,
      'campoos': tipoPicked!.campos
          ?.map((value) => {'campo_id': value.campoId})
          .toList()
    };

    print(data);

    final res = await _api.httpEnviaMap(
        'http://$ipLocal/$pathLocal/produccion/add_producion.php', data);

    final value = json.decode(res);

    scaffoldMensaje(
        mjs: value['message'].toString(),
        background: value['success'] ? Colors.green : Colors.red,
        context: context);
    setState(() {
      _loading = !_loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final prioridadColor = _getPrioridadColor(widget.orden!.estadoPrioritario);
    final estadoProduccionColor =
        _getEstadoColor(widget.orden!.estadoProduccion);
    // const curve = Curves.elasticInOut;
    final style = Theme.of(context).textTheme;
    // String textPlain =
    //     "-Bordados -Serigrafía -Sublimación -Vinil -Uniformes deportivos y empresariales -Promociones y Más";
    // const urlLoaded = 'http://$ipLocal/settingmat/';

    // print(widget.orden!.toJson());
    const String textInfo =
        'Fábrica textil especializada en bordado, sublimación, sastrería y confección. Comprometidos con la calidad y la innovación en cada prenda.';

    final screenMobile = SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(width: double.infinity),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, // Fondo blanco (puedes cambiarlo)
              borderRadius: BorderRadius.circular(1),
              boxShadow: [
                BoxShadow(
                    color: Colors.blueGrey
                        .withValues(alpha: 0.3), // sombra principal
                    blurRadius: 8,
                    offset: const Offset(0, 4)),
                BoxShadow(
                    color: PrinterPlan.getColorByDepartment(
                            widget.orden?.nameDepartment ?? 'N/A')
                        .withValues(alpha: 0.5),
                    blurRadius: 12,
                    offset: const Offset(5, 8)),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(width: double.infinity),
                SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      Expanded(
                        child: PrettyQrView.data(
                          data: widget.orden?.planificacionWorkId ?? '',
                          decoration: const PrettyQrDecoration(
                            shape: PrettyQrSmoothSymbol(
                                color: Colors.black, roundFactor: 1),
                            image: PrettyQrDecorationImage(
                                image: AssetImage('assets/loro.png'),
                                position:
                                    PrettyQrDecorationImagePosition.embedded),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.numbers, color: Colors.black54),
                            const SizedBox(width: 10),
                            Text(
                              widget.orden?.ficha ?? 'N/A',
                              style: style.titleLarge?.copyWith(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Text('Nombre de Logo',
                    style: style.titleSmall?.copyWith(color: Colors.black54)),
                Text(widget.orden?.nameLogo ?? 'N/A',
                    style: style.titleLarge?.copyWith(
                        color: Colors.black54, fontWeight: FontWeight.bold)),
                const Divider(),
                _buildRow(Icons.factory, 'Departamento:',
                    widget.orden?.nameDepartment),
                _buildRow(Icons.numbers, 'Orden #:', widget.orden?.numOrden),
                _buildRow(Icons.person, 'Cliente:', widget.orden?.nombre),
                _buildRow(Icons.shopping_bag, 'Producto:',
                    widget.orden?.nameProducto),
                _buildRow(
                    Icons.confirmation_number, 'Cantidad:', widget.orden?.cant),
                _buildRow(Icons.format_list_bulleted, 'Detalles:',
                    widget.orden?.detallesProductos),
                _buildRow(Icons.calendar_today, 'Entrega:',
                    widget.orden?.fechaEntrega),
                _buildRow(Icons.access_time, 'Fecha creación:',
                    widget.orden?.fechaItemCreacion),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Chip(
                      label: Text(
                          widget.orden?.estadoPrioritario?.toUpperCase() ??
                              'Sin prioridad'),
                      backgroundColor: prioridadColor.withValues(alpha: 0.2),
                      labelStyle: TextStyle(color: prioridadColor),
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text(
                          widget.orden?.estadoProduccion?.toUpperCase() ??
                              'Sin estado'),
                      backgroundColor:
                          estadoProduccionColor.withValues(alpha: 0.2),
                      labelStyle: TextStyle(color: estadoProduccionColor),
                    ),
                  ],
                ),
                listTipoTrabajo.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 250,
                              child: buildStyledDropdownFormField<TipoTrabajo>(
                                label: 'Tipo de trabajos',
                                value: tipoPicked,
                                items: listTipoTrabajo,
                                onChanged: (val) {
                                  setState(() {
                                    tipoPicked = val;
                                  });
                                },
                                style: Theme.of(context).textTheme,
                                color: PrinterPlan.getColorByDepartment(
                                        widget.orden?.nameDepartment ?? 'N/A')
                                    .withValues(alpha: 0.7),
                                icon: Icons.description,
                                validator: (val) => val == null
                                    ? 'Seleccione un tipo trabajos'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          if (tipoPicked != null && tipoPicked!.campos!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Campos de producción: ${tipoPicked!.campos!.length}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45)),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: tipoPicked!.campos!.length,
                  itemBuilder: (context, index) {
                    final item = tipoPicked!.campos![index];
                    return ListTile(
                      leading: const Icon(Icons.label_important_outline),
                      title: Text(item.nombreCampo ?? 'Sin nombre'),
                      trailing: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 50,
                        color: Colors.white,
                        margin: EdgeInsets.all(5),
                        child: Text('0'),
                      ),
                      // subtitle:
                      //     Text('Tipo: ${item.tipoDato ?? 'Desconocido'}'),
                    );
                  },
                ),
                CustomLoginButton(
                  onPressed: () => enviarToProducion(context),
                  text: 'Tomar Producción',
                  colorButton: PrinterPlan.getColorByDepartment(
                      widget.orden?.nameDepartment ?? 'N/A'),
                  width: 250,
                )
              ],
            ),
          identy(context)
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles Del Producto'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: IconButton(
              icon: const Icon(Icons.print),
              onPressed: () async {
                final filePdf = await PdfPrintOrdenProduccion.generate(
                  cliente: '',
                  fecha: widget.orden!.fechaItemCreacion ?? 'N/A',
                  entrega: widget.orden!.fechaEntrega ?? 'N/A',
                  ficha: widget.orden!.ficha ?? 'N/A',
                  codigo: widget.orden!.numOrden ?? 'N/A',
                  aprobadoPor: '',
                  productos: [
                    {
                      'descripcion': widget.orden!.nameProducto ?? 'N/A',
                      'cantidad': widget.orden!.cant ?? 'N/A',
                      'precio': '',
                    },
                  ],
                );
                await PdfApi.openFile(filePdf);
              },
            ),
          )
        ],
      ),
      body: _loading
          ? Center(
              child: LoadingNew(
                  scale: 5,
                  text: 'Registrando en producion',
                  imagen: 'assets/codigo-de-barras.png'))
          : ValidarScreenAvailable(
              mobile: screenMobile,
              windows: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: screenMobile,
                            )),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              BounceInDown(
                                curve: Curves.elasticOut,
                                child: SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: PrettyQrView.data(
                                    data:
                                        widget.orden?.planificacionWorkId ?? '',
                                    decoration: const PrettyQrDecoration(
                                      shape: PrettyQrSmoothSymbol(
                                          color: Colors.black, roundFactor: 1),
                                      image: PrettyQrDecorationImage(
                                          image: AssetImage('assets/loro.png'),
                                          position:
                                              PrettyQrDecorationImagePosition
                                                  .embedded),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: SizedBox(
                                    width: 250,
                                    child: Text(
                                      textInfo,
                                      textAlign: TextAlign.justify,
                                      style: style.bodySmall,
                                    ),
                                  )),
                              const SizedBox(height: 25),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                child: SizedBox(
                                  width: 250,
                                  child: Text('Lo mejor de ti continua..',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.grey)),
                                ),
                              ),
                              const SizedBox(height: 25),
                              Container(
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: const [shadow],
                                ),
                                child: TextField(
                                  onChanged: (value) => {},
                                  decoration: InputDecoration(
                                      hintText:
                                          'Buscar', // Texto de ayuda más descriptivo
                                      border: InputBorder
                                          .none, // Mantiene sin borde el campo de texto
                                      suffixIcon: Icon(Icons.search,
                                          color: Colors.grey[600],
                                          size:
                                              24), // Estiliza el icono de búsqueda
                                      contentPadding: const EdgeInsets.only(
                                          left: 25, top: 10)),
                                ),
                              ),
                              // const SizedBox(height: 10),
                              // const Divider(indent: 50, endIndent: 50),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  identy(context)
                ],
              ),
            ),
    );
  }

  Widget _buildRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: SizedBox(
        height: 22,
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey[700]),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(value ?? '-', overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPrioridadColor(String? prioridad) {
    switch (prioridad?.toLowerCase()) {
      case 'urgente':
        return Colors.red;
      case 'media':
        return Colors.orange;
      case 'baja':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getEstadoColor(String? estado) {
    switch (estado?.toLowerCase()) {
      case 'pendiente':
        return Colors.deepOrange;
      case 'en_proceso':
        return Colors.blue;
      case 'pausado':
        return Colors.amber;
      case 'en_revision':
        return Colors.purple;
      case 'completado':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
// FutureBuilder<List<OrdenFiles>>(
                  //   future: _fetchFiles(),
                  //   builder: (BuildContext context,
                  //       AsyncSnapshot<List<OrdenFiles>> snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return const SizedBox(
                  //           height: 50,
                  //           child:
                  //               CircularProgressIndicator()); // Muestra un indicador de carga mientras se obtienen los datos
                  //     } else if (snapshot.hasError) {
                  //       return Text(
                  //           'Error: ${snapshot.error}'); // Muestra un mensaje de error si falla la solicitud
                  //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  //       return Column(
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsets.only(bottom: 15),
                  //             child: Bounce(
                  //                 curve: curve,
                  //                 child: const Text('Great Job !',
                  //                     style: TextStyle(
                  //                         fontSize: 24, color: colorsAd))),
                  //           ),
                  //           BounceInDown(
                  //               curve: curve,
                  //               child: Image.asset('assets/informe.png', scale: 6)),
                  //         ],
                  //       );
                  //     } else {
                  //       // Si se obtuvieron los datos, muestra la lista
                  //       final files = snapshot.data!;
                  //       return Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 25),
                  //         child: SizedBox(
                  //           height: MediaQuery.sizeOf(context).height * 0.40,
                  //           child: ListView.builder(
                  //             scrollDirection: Axis.horizontal,
                  //             itemCount: files.length,
                  //             itemBuilder: (context, index) {
                  //               OrdenFiles file = files[index];
                  //               return file.fileType == 'pdf'
                  //                   ? isAndroidOrIOS()
                  //                       ? Container(
                  //                           height: 350,
                  //                           width:
                  //                               MediaQuery.sizeOf(context).width *
                  //                                   0.50,
                  //                           decoration: const BoxDecoration(
                  //                             borderRadius: BorderRadius.all(
                  //                                 Radius.circular(10)),
                  //                             color: Colors.white,
                  //                             boxShadow: [
                  //                               BoxShadow(
                  //                                   color: Colors.black26,
                  //                                   offset: Offset(0, 4),
                  //                                   blurRadius: 10)
                  //                             ],
                  //                           ),
                  //                           child: GestureDetector(
                  //                               onLongPress: () {
                  //                                 // ViewerPdf
                  //                                 //ViewPdfPage
                  //                                 Navigator.push(
                  //                                   context,
                  //                                   MaterialPageRoute(
                  //                                       builder: (context) => ViewerPdf(
                  //                                           pdfUrl:
                  //                                               '$urlLoaded${file.filePath}')),
                  //                                 );
                  //                               },
                  //                               child: Padding(
                  //                                 padding:
                  //                                     const EdgeInsets.all(8.0),
                  //                                 child: PDFViewerPage(
                  //                                     pdfUrl:
                  //                                         '$urlLoaded${file.filePath}'),
                  //                               )))
                  //                       : SizedBox(
                  //                           height: 150,
                  //                           width: 150,
                  //                           child: IconButton(
                  //                               onPressed: () async {
                  //                                 if (await canLaunchUrl(Uri.parse(
                  //                                     '$urlLoaded${file.filePath}'))) {
                  //                                   await launchUrl(Uri.parse(
                  //                                       '$urlLoaded${file.filePath}'));
                  //                                 } else {
                  //                                   // print('No se puede abrir el PDF');
                  //                                   ScaffoldMessenger.of(context)
                  //                                       .showSnackBar(
                  //                                     const SnackBar(
                  //                                       content: Text(
                  //                                           'No se puede abrir el PDF'),
                  //                                       duration:
                  //                                           Duration(seconds: 1),
                  //                                       backgroundColor: Colors.red,
                  //                                     ),
                  //                                   );
                  //                                 }
                  //                               },
                  //                               icon: const Icon(
                  //                                   Icons.picture_as_pdf)),
                  //                         )
                  //                   : Padding(
                  //                       padding: const EdgeInsets.symmetric(
                  //                           horizontal: 15),
                  //                       child: GestureDetector(
                  //                         onTap: () async {
                  //                           showDialog(
                  //                             context: context,
                  //                             builder: (_) => Dialog(
                  //                               child: Image.network(
                  //                                   '$urlLoaded${file.filePath}'),
                  //                             ),
                  //                           );
                  //                         },
                  //                         child: Container(
                  //                           height: 150,
                  //                           width: 250,
                  //                           decoration: const BoxDecoration(
                  //                             borderRadius: BorderRadius.all(
                  //                                 Radius.circular(25)),
                  //                             color: Colors.white,
                  //                             boxShadow: [
                  //                               BoxShadow(
                  //                                   color: Colors.black26,
                  //                                   offset: Offset(0, 4),
                  //                                   blurRadius: 10)
                  //                             ],
                  //                           ),
                  //                           child: ClipRRect(
                  //                             borderRadius:
                  //                                 BorderRadius.circular(15),
                  //                             child: Image.network(
                  //                                 fit: BoxFit.cover,
                  //                                 '$urlLoaded${file.filePath}'),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     );
                  //             },
                  //           ),
                  //         ),
                  //       );
                  //     }
                  //   },
                  // ),


// Column(
//           children: [
//             const SizedBox(width: double.infinity),
//             Expanded(
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(25),
//                       child: Column(
//                         children: [
//                           const Text('Información Trabajo',
//                               style: TextStyle(
//                                   fontSize: 14, color: Colors.black54)),
//                           Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.max,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Text(
//                                       widget.orden?.nameLogo ?? 'N/A',
//                                       style: style.titleLarge?.copyWith(
//                                           color: Colors.black54,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     const SizedBox(width: 10),
//                                     Icon(
//                                       Icons.verified,
//                                       color: true
//                                           //  PlanificacionItem.getIsDone(
//                                           //         widget.orden!)
//                                           ? Colors.green
//                                           : Colors.red,
//                                     )
//                                   ],
//                                 ),
//                                 const Divider(),
//                                 Text(
//                                     'Num Order : ${widget.orden?.numOrden}',
//                                     style: const TextStyle(fontSize: 14)),
//                                 Text('Cant : ${widget.orden?.cant}',
//                                     style: const TextStyle(fontSize: 14)),
//                                 Text('${widget.orden?.nameDepartment}',
//                                     style: const TextStyle(fontSize: 14)),
//                                 Text('Logo : ${widget.orden?.nameLogo}',
//                                     style: const TextStyle(fontSize: 14)),
//                                 const Divider(),
//                                 Text(
//                                     'Creada en : ${widget.orden?.fechaItemCreacion}',
//                                     style: style.bodySmall
//                                         ?.copyWith(color: Colors.black54)),
//                                 Text(
//                                     'Para entregar : ${widget.orden?.fechaEntrega}',
//                                     style: style.bodySmall?.copyWith(
//                                         color: Colors.orange.shade300)),
//                                 const SizedBox(height: 10),
//                                 SlideInLeft(
//                                   curve: curve,
//                                   child: customButton(
//                                       onPressed: () => putOrdenIsDone(context),
//                                       width: 125,
//                                       colorText: Colors.white,
//                                       colors: colorsRed,
//                                       textButton: 'Terminar'),
//                                 )
//                               ],
//                             ),
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 25, vertical: 15),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   utilShowMesenger(context,
//                                       widget.orden?.nota ?? 'N/A');
//                                 },
//                                 child: Text(
//                                     'Comentario : ${widget.orden?.nota}',
//                                     style: const TextStyle(fontSize: 14),
//                                     maxLines: 8,
//                                     overflow: TextOverflow.ellipsis),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: FutureBuilder<List<OrdenFiles>>(
//                               future: _fetchFiles(),
//                               builder: (BuildContext context,
//                                   AsyncSnapshot<List<OrdenFiles>> snapshot) {
//                                 if (snapshot.connectionState ==
//                                     ConnectionState.waiting) {
//                                   return const CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos
//                                 } else if (snapshot.hasError) {
//                                   return Text(
//                                       'Error: ${snapshot.error}'); // Muestra un mensaje de error si falla la solicitud
//                                 } else if (!snapshot.hasData ||
//                                     snapshot.data!.isEmpty) {
//                                   return const Text(
//                                       'No hay archivos disponibles'); // Muestra mensaje si no hay datos
//                                 } else {
//                                   // Si se obtuvieron los datos, muestra la lista
//                                   final files = snapshot.data!;
//                                   return ListView.builder(
//                                     scrollDirection: Axis.horizontal,
//                                     itemCount: files.length,
//                                     itemBuilder: (context, index) {
//                                       OrdenFiles file = files[index];
//                                       return file.fileType == 'pdf'
//                                           ? isAndroidOrIOS()
//                                               ? Container(
//                                                   height: 350,
//                                                   width:
//                                                       MediaQuery.sizeOf(context)
//                                                               .width *
//                                                           0.50,
//                                                   decoration:
//                                                       const BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.all(
//                                                             Radius.circular(
//                                                                 10)),
//                                                     color: Colors.white,
//                                                     boxShadow: [
//                                                       BoxShadow(
//                                                           color: Colors.black26,
//                                                           offset: Offset(0, 4),
//                                                           blurRadius: 10)
//                                                     ],
//                                                   ),
//                                                   child: GestureDetector(
//                                                       onLongPress: () {
//                                                         Navigator.push(
//                                                           context,
//                                                           MaterialPageRoute(
//                                                               builder: (context) =>
//                                                                   ViewPdfPage(
//                                                                       pdfUrl:
//                                                                           '$urlLoaded${file.filePath}')),
//                                                         );
//                                                       },
//                                                       child: Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .all(8.0),
//                                                         child: PDFViewerPage(
//                                                             pdfUrl:
//                                                                 '$urlLoaded${file.filePath}'),
//                                                       )))
//                                               : Container(
//                                                   height: 150,
//                                                   width: 75,
//                                                   decoration:
//                                                       const BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.all(
//                                                             Radius.circular(
//                                                                 10)),
//                                                     color: Colors.white,
//                                                     boxShadow: [
//                                                       BoxShadow(
//                                                           color: Colors.black26,
//                                                           offset: Offset(0, 4),
//                                                           blurRadius: 10)
//                                                     ],
//                                                   ),
//                                                   child: IconButton(
//                                                     onPressed: () async {
//                                                       if (await canLaunchUrl(
//                                                           Uri.parse(
//                                                               '$urlLoaded${file.filePath}'))) {
//                                                         await launchUrl(Uri.parse(
//                                                             '$urlLoaded${file.filePath}'));
//                                                       } else {
//                                                         // print('No se puede abrir el PDF');
//                                                         ScaffoldMessenger.of(
//                                                                 context)
//                                                             .showSnackBar(
//                                                           const SnackBar(
//                                                             content: Text(
//                                                                 'No se puede abrir el PDF'),
//                                                             duration: Duration(
//                                                                 seconds: 1),
//                                                             backgroundColor:
//                                                                 Colors.red,
//                                                           ),
//                                                         );
//                                                       }
//                                                     },
//                                                     icon: const Icon(
//                                                         Icons.picture_as_pdf),
//                                                   ),
//                                                 )
//                                           : Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 15),
//                                               child: GestureDetector(
//                                                 onTap: () async {
//                                                   showDialog(
//                                                     context: context,
//                                                     builder: (_) => Dialog(
//                                                       child: Image.network(
//                                                           '$urlLoaded${file.filePath}'),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   height: 150,
//                                                   width: 250,
//                                                   decoration:
//                                                       const BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.all(
//                                                             Radius.circular(
//                                                                 25)),
//                                                     color: Colors.white,
//                                                     boxShadow: [
//                                                       BoxShadow(
//                                                           color: Colors.black26,
//                                                           offset: Offset(0, 4),
//                                                           blurRadius: 10)
//                                                     ],
//                                                   ),
//                                                   child: ClipRRect(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             15),
//                                                     child: Image.network(
//                                                         fit: BoxFit.cover,
//                                                         '$urlLoaded${file.filePath}'),
//                                                   ),
//                                                 ),
//                                               ),
//                                             );
//                                     },
//                                   );
//                                 }
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(25.0),
//                           child: Bounce(
//                               curve: curve,
//                               child: const Text('Great Job !',
//                                   style: TextStyle(
//                                       fontSize: 24, color: colorsAd))),
//                         ),
//                         BounceInDown(
//                             curve: curve,
//                             child: Image.asset('assets/informe.png', scale: 5)),
//                         FadeIn(
//                           child: Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: SizedBox(
//                                 width: 200,
//                                 child: Text(textPlain,
//                                     textAlign: TextAlign.center,
//                                     style: style.bodySmall
//                                         ?.copyWith(color: Colors.grey))),
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         SlideInLeft(
//                           curve: curve,
//                           child: customButton(
//                               onPressed: () => putOrdenWorking(context),
//                               width: 250,
//                               colorText: Colors.white,
//                               colors: colorsGreenTablas,
//                               textButton: 'Trabajar'),
//                         ),
//                         const SizedBox(height: 5),
//                         // PlanificacionItem.getIsCalidad(widget.orden!)

//                         SlideInRight(
//                           curve: curve,
//                           child: customButton(
//                               onPressed: () => putOrdenCalidad(context),
//                               width: 250,
//                               colorText: Colors.white,
//                               colors: colorsOrange,
//                               textButton: 'Confirmar Calidad'),
//                         )
//                         // : const SizedBox(),
//                         ,
//                         const SizedBox(height: 5),

//                         customButton(
//                             onPressed: () => comentar(context),
//                             width: 250,
//                             colorText: Colors.white,
//                             colors: colorsBlueDeepHigh,
//                             textButton: 'Comentar'),
//                         const SizedBox(height: 5),
//                         BounceInUp(
//                           curve: curve,
//                           child: customButton(
//                               onPressed: putIncidencia,
//                               width: 250,
//                               colorText: Colors.white,
//                               colors: colorsAd,
//                               textButton: 'Report Incidencia'),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             identy(context)
//           ],
//         )