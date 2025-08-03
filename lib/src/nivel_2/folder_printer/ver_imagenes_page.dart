import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../datebase/current_data.dart';
import '../../datebase/url.dart';
import '../../model/users.dart';
import 'model/printer_plan.dart';
import 'screen_subir_imagen_page.dart';
import 'ver_imagen_completa.dart';

class VerImagenesPage extends StatefulWidget {
  const VerImagenesPage({super.key, required this.item});
  final PrinterPlan item;

  @override
  State<VerImagenesPage> createState() => _VerImagenesPageState();
}

class _VerImagenesPageState extends State<VerImagenesPage> {
  final _idController = TextEditingController();
  List<String> imagenes = [];
  // final String ipLocal = "192.168.1.100"; // Cambia por tu IP local

  Future<void> cargarImagenes(String id) async {
    try {
      final response = await Dio().get(
        "http://$ipLocal/settingmat/imagen_plan/listar_imagenes.php",
        queryParameters: {"id": id},
      );

      final data =
          response.data is String ? jsonDecode(response.data) : response.data;

      if (data["status"] == "ok") {
        final List datos = data["imagenes"];
        setState(() {
          imagenes = datos
              .map((e) => "http://$ipLocal/settingmat/imagen_plan/${e['ruta']}")
              .toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["mensaje"] ?? "Error al cargar")),
        );
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _idController.text = widget.item.printerPlaningId.toString();
    cargarImagenes(_idController.text);
  }

  Future<void> _confirmarEliminarImagen(int index) async {
    final urlCompleta = imagenes[index];
    final nombreArchivo = urlCompleta.split('/').last;
    print('urlCompleta : $urlCompleta');
    print('nombreArchivo : $nombreArchivo');
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar imagen"),
        content:
            const Text("¿Estás seguro de que deseas eliminar esta imagen?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      await eliminarImagenDesdeBackend(nombreArchivo);
      setState(() => imagenes.removeAt(index));
    }
  }

  Future<void> eliminarImagenDesdeBackend(String nombreArchivo) async {
    try {
      final response = await Dio().post(
        "http://$ipLocal/settingmat/imagen_plan/eliminar_imagen.php",
        data: {"nombre_archivo": nombreArchivo},
      );

      print(response);
      final data =
          response.data is String ? jsonDecode(response.data) : response.data;

      if (data["status"] != "ok") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(data["mensaje"] ?? "Error al eliminar imagen")),
        );
      }
    } catch (e) {
      print("Error al eliminar: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasPermisoActualizar = hasPermissionUsuario(
        currentUsers!.listPermission!, "plan", "actualizar");
    bool hasPermisoEliminar =
        hasPermissionUsuario(currentUsers!.listPermission!, "plan", "eliminar");
    bool hasPermisoAdmin =
        hasPermissionUsuario(currentUsers!.listPermission!, "plan", "crear");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ver Imágenes del Trabajo"),
        actions: [
          if (hasPermisoAdmin)
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SubirImagenPage(item: widget.item)),
                    ).then((value) {
                      cargarImagenes(_idController.text);
                    });
                  },
                  icon: const Icon(Icons.add)),
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: imagenes.isEmpty
                  ? const Center(child: Text("No hay imágenes"))
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemCount: imagenes.length,
                      itemBuilder: (context, index) {
                        final url = imagenes[index];

                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => VerImagenCompleta(url: url),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade300)),
                                child: Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                            hasPermisoEliminar
                                ? Positioned(
                                    right: 4,
                                    top: 4,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.white, size: 20),
                                        onPressed: () =>
                                            _confirmarEliminarImagen(index),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
