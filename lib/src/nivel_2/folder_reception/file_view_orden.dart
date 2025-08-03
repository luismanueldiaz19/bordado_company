import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/model/users.dart';
import '/src/nivel_2/folder_reception/pick_file_orden.dart';
import '/src/widgets/loading.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../datebase/url.dart';
import 'orden_file.dart'; // Para abrir los PDFs

class FileViewer extends StatefulWidget {
  final String? numOrden;
  const FileViewer({super.key, this.numOrden});

  @override
  State<FileViewer> createState() => _FileViewerState();
}

class _FileViewerState extends State<FileViewer> {
  List<OrdenFiles> files = []; // Lista para almacenar los archivos
// List<OrdenFiles> ordenFilesFromJson(
  @override
  void initState() {
    super.initState();
    _fetchFiles(); // Llamar al método para obtener los archivos
  }

  // Método para obtener los archivos desde el servidor
  Future<void> _fetchFiles() async {
    final url = Uri.parse(
        'http://$ipLocal/settingmat/admin/select/select_file_orden.php?num_orden=${widget.numOrden}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['success']) {
        // print(jsonEncode(data['files']));

        if (!context.mounted) return;
        files = ordenFilesFromJson(
            jsonEncode(data['files'])); // Aquí obtienes la lista de archivos
        setState(() {});
      } else {
        print('Error en la respuesta: ${data['message']}');
      }
    } else {
      print('Error al obtener los archivos, código: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Informacion Boceto/Images'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UploadFileScreen(numOrden: widget.numOrden!)),
                  ).then((value) {
                    _fetchFiles();
                  });
                },
                icon: const Icon(Icons.add),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            const SizedBox(width: double.infinity),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Numero Orden : ${widget.numOrden}',
                  style: style.titleMedium),
            ),
            files.isEmpty
                ? const Expanded(
                    child: Center(
                        child: Loading(text: 'No hay datos', isLoading: false)))
                : Expanded(
                    child: SizedBox(
                      width: 350,
                      child: ListView.builder(
                        itemCount: files.length,
                        itemBuilder: (context, index) {
                          OrdenFiles item = files[index];
                          // final file = files[index];
                          // final fileName = file['file_name'];
                          // final fileType = file['file_type'];
                          // final filePath = file['file_path'];
                          // final nota = file['nota'];

                          return CardFileOrden(
                            item: item,
                            onDelete: () =>
                                deleteFromImage(context, item.idFileOrden),
                          );

                          // item.fileType == 'pdf'
                          //     ? ListTile(
                          //         leading: item.fileType == 'pdf'
                          //             ? const Icon(Icons.picture_as_pdf,
                          //                 color: Colors.red)
                          //             : const Icon(Icons.image,
                          //                 color: Colors.blue),
                          //         title: Text(item.fileName ?? 'Sin Formato'),
                          //         subtitle: Text('Comentario : ${item.nota}'),
                          //         onTap: () {
                          //           if (item.fileType == 'pdf') {
                          //             // print(' Abrir PDF $urlLoaded${item.filePath}');
                          //             // Abrir PDF en el navegador
                          //             _openPDF('$urlLoaded${item.filePath}');
                          //             // print(file.toJson());

                          //             ///upload_file_orden/certificadoPDF.pdf
                          //           } else {
                          //             // print(file);
                          //             // print(
                          //             // 'Mostrar la imagen en un dialog'); // Mostrar la imagen en un dialog
                          //             showDialog(
                          //               context: context,
                          //               builder: (_) => Dialog(
                          //                 child: Image.network(
                          //                     '$urlLoaded${item.filePath}'),
                          //               ),
                          //             );
                          //           }
                          //         },
                          //         trailing: hasPermissionUsuario(
                          //                 currentUsers!.listPermission!,
                          //                 "admin",
                          //                 "eliminar")
                          //             ? IconButton(
                          //                 icon: const Icon(Icons.close,
                          //                     color: Colors.red),
                          //                 onPressed: () => deleteFromImage(
                          //                     context, item.idFileOrden))
                          //             : const SizedBox(),
                          //       )
                          //     : Column(
                          //         children: [
                          //           GestureDetector(
                          //             onTap: () {
                          //               showDialog(
                          //                 context: context,
                          //                 builder: (_) => Dialog(
                          //                   child: Image.network(
                          //                       '$urlLoaded${item.filePath}'),
                          //                 ),
                          //               );
                          //             },
                          //             child: ClipRRect(
                          //               borderRadius: BorderRadius.circular(25),
                          //               child: Image.network(
                          //                   fit: BoxFit.cover,
                          //                   '$urlLoaded${item.filePath}',
                          //                   scale: 5,
                          //                   height: 200,
                          //                   width: 200),
                          //             ),
                          //           ),
                          //           const Divider(),
                          //           Text('Comentario : ${item.nota}'),
                          //           IconButton(
                          //               icon: const Icon(Icons.close,
                          //                   color: Colors.red),
                          //               onPressed: () => deleteFromImage(
                          //                   context, item.idFileOrden))
                          //         ],
                          //       );
                        },
                      ),
                    ),
                  ),
            // CardFileOrden(),
            identy(context)
          ],
        ));
  }

  // Método para abrir el PDF en el navegador o app predeterminada

  deleteFromImage(context, idFileOrden) async {
    // delete_from_imagen

    // Implementa la lógica para eliminar la imagen según el ID del cliente
    // print("Eliminar imagen del cliente: $id  :  filename : $fileName");

    const String url =
        'http://$ipLocal/settingmat/upload_file_orden/delete_from_imagen.php?';
    final res = await httpRequestDatabase(url, {'id_file_orden': idFileOrden});

    print('response : ${res.body}');
    final data = jsonDecode(res.body);
    if (data['success']) {
      // setState(() {
      //   list.removeWhere((element) => element.sanPagoId == id);
      // });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message']),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green,
        ),
      );
      _fetchFiles();
      // getImageListDocument();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message']),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class CardFileOrden extends StatefulWidget {
  const CardFileOrden({super.key, this.item, this.onDelete});
  final OrdenFiles? item;
  final Function? onDelete;

  @override
  State<CardFileOrden> createState() => _CardFileOrdenState();
}

class _CardFileOrdenState extends State<CardFileOrden> {
  void _openPDF(context, String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      // print('No se puede abrir el PDF');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se puede abrir el PDF'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const urlLoaded = 'http://$ipLocal/settingmat/';
    final style = Theme.of(context).textTheme;
    return Container(
      height: 175,
      width: 350,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 10)
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                widget.item?.fileType == 'pdf'
                    ? Expanded(
                        child: IconButton(
                          onPressed: () {
                            _openPDF(
                                context, '$urlLoaded${widget.item?.filePath}');
                          },
                          icon: const Icon(Icons.picture_as_pdf_outlined,
                              color: Colors.red, size: 50),
                        ),
                      )
                    : Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                child: Image.network(
                                    '$urlLoaded${widget.item?.filePath}'),
                              ),
                            );
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 4),
                                    blurRadius: 10)
                              ],
                            ),
                            child: Image.network(
                                fit: BoxFit.cover,
                                '$urlLoaded${widget.item?.filePath}'),
                          ),
                        ),
                      ),
                Expanded(
                  child: Center(
                    child: Text(widget.item?.fileName ?? '',
                        style:
                            style.bodySmall?.copyWith(color: Colors.black54)),
                  ),
                )
              ],
            ),
          ),
          const Divider(),
          const Row(children: [Text('Comentario')]),
          Expanded(
            child: Text(
              widget.item?.nota ?? '',
              textAlign: TextAlign.justify,
              style: style.bodySmall?.copyWith(color: Colors.black54),
            ),
          ),
          hasPermissionUsuario(
                  currentUsers!.listPermission!, "admin", "eliminar")
              ? TextButton(
                  onPressed: () {
                    widget.onDelete!();
                  },
                  child: Text(
                    'Eliminar',
                    style: style.bodySmall?.copyWith(color: Colors.red),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
