import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/src/datebase/url.dart';
import '/src/nivel_2/folder_serigrafia/widgets/widget_tap.dart';
import '/src/nivel_2/folder_serigrafia/widgets/widgets_show_imagen.dart';
import '/src/util/get_time_relation.dart';
import '../../../datebase/current_data.dart';
import '../../../datebase/methond.dart';
import '../../../util/commo_pallete.dart';
import '../../../util/dialog_confimarcion.dart';
import '../../../util/font_style.dart';
import '../../../widgets/widget_comentario.dart';
import '../../forder_sublimacion/model_nivel/sublima.dart';
import '../../forder_sublimacion/widgets/percent_star.dart';
import '../editting_item_serigrafia_done.dart';
import 'package:slide_rating_dialog/slide_rating_dialog.dart';
import '../model/imagen_serigrafia.dart';
import '../services/upload_services.dart';
import 'card_imagen_serigrafia.dart';

class MyWidgetSerigrafiaCard extends StatefulWidget {
  const MyWidgetSerigrafiaCard(
      {super.key,
      this.isImagen,
      this.current,
      required this.deleteFromDone,
      required this.pageController});
  final bool? isImagen;
  final Sublima? current;
  final Function? deleteFromDone;
  final PageController pageController;

  @override
  State<MyWidgetSerigrafiaCard> createState() => _MyWidgetSerigrafiaCardState();
}

class _MyWidgetSerigrafiaCardState extends State<MyWidgetSerigrafiaCard> {
  double _ranting = 0;
  bool upImagen = false;
  Future<void> openImagePicker(BuildContext context) async {
    if (validarMySelf(widget.current!.fullName)) {
      List<XFile>? images =
          await ImagePicker().pickMultiImage(imageQuality: 100);
      if (images.isNotEmpty) {
        setState(() {
          upImagen = true;
        });

        for (XFile image in images) {
          await uploadImage(File(image.path), image.name);
        }
      }
      setState(() {
        upImagen = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Este Trabajo no pertenece a tu usuario!'),
          backgroundColor: Colors.red));
    }
  }

  final uploadService = UploadService();

  Future<void> uploadImage(File imageFile, String imagenName) async {
    // var progressStream =
    final mjs = await uploadService.uploadImage(
        imageFile, widget.current!.id!, imagenName);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mjs), duration: const Duration(seconds: 1)));
    await _loadImages();
  }

  Future<List<ImagenSerigrafia>> getImagenServer() async {
    String url =
        "http://$ipLocal/settingmat/admin/select/select_serigrafia_imagenes.php";
    final res = await httpRequestDatabase(url, {'id': widget.current!.id});
    // print('Imagene  reques Response : ${res.body}');
    return imagenSerigrafiaFromJson(res.body);
  }

  List<ImagenSerigrafia> _imageList = [];

  Future deleteFromDone(context2, ImagenSerigrafia photos) async {
    if (validarMySelf(widget.current!.fullName)) {
      await showDialog(
        context: context,
        builder: (BuildContext context1) {
          return ConfirmacionDialog(
            mensaje: '❌❌Esta Seguro de Eliminar❌❌',
            titulo: 'Aviso',
            onConfirmar: () async {
              // print(photos.idSerigrafiaImagenPath);
              // print(photos.created);
              // print(photos.namePath);

              // // delete_serigrafia_work_finished_done
              String url =
                  "http://$ipLocal/settingmat/admin/imagen_serigrafias/delete_imagen.php";
              final res = await httpRequestDatabase(url, {
                'file_name': photos.namePath.toString(),
                'id': photos.idSerigrafiaImagenPath.toString()
              });
              // print(res.body);
              if (!mounted) {
                return;
              }
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(res.body),
                    backgroundColor: Colors.green.shade400),
              );
              _loadImages();
            },
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No tiene permiso para eliminar'),
          backgroundColor: Colors.red));
    }
  }

  @override
  void initState() {
    super.initState();
    // Cargar los datos una sola vez al crear el widget
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      // Lógica para cargar las imágenes desde tu fuente de datos (por ejemplo, una API)
      // Aquí debes reemplazar esta línea con tu propia lógica
      List<ImagenSerigrafia> images = await getImagenServer();
      setState(() {
        _imageList = images;
      });
    } catch (e) {
      print('Error al cargar las imágenes: $e');
    }
  }

  Future calificar() async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext cont) => SlideRatingDialog(
        onRatingChanged: (rating) {
          _ranting = double.parse('$rating');
          print(rating.toString());
        },
        buttonOnTap: () async {
          if (_ranting > 0) {
            String url =
                "http://$ipLocal/settingmat/admin/update/update_edit_serigrafia_ranking.php";
            final res = await httpRequestDatabase(url, {
              'id': widget.current!.id,
              'rating': _ranting.toStringAsFixed(0),
              'is_rating': 't'
            });
            setState(() {
              widget.current?.rating = _ranting.toStringAsFixed(0);
              widget.current?.isRating = 't';
            });

            print('rating =  $_ranting body ${res.body}');
            Navigator.pop(context);
          }
        },
        title: 'Calificación',
        ratingBarBackgroundColor: ktejidoblue.withOpacity(0.5),
        buttonColor: ktejidoblue,
        buttonTitle: 'Enviar',
        subTitle: 'Como califica este trabajo?',
      ),
    );
  }

  Future comment() async {
    if (validateAdmin()) {
      String? valueCant = await showDialog<String>(
          context: context,
          builder: (context) {
            return const AddComentario(
                text: 'Escribir',
                textInputType: TextInputType.text,
                textFielName: 'Escribir Nota');
          });

      if (valueCant != null) {
        String url =
            "http://$ipLocal/settingmat/admin/update/update_edit_serigrafia_nota.php";
        final res = await httpRequestDatabase(
            url, {'id': widget.current!.id, 'nota': valueCant});
        setState(() {
          widget.current?.nota = valueCant;
        });
      }
    }
  }

  ///update_edit_serigrafia_nota

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.copyWith(
        titleSmall: TextStyle(fontFamily: fontMuseo),
        bodySmall: TextStyle(fontFamily: fontBalooPaaji));
    bool isPktReport = true;
    if (widget.current?.nameWork?.toUpperCase().trim() == 'EMPAQUE' ||
        widget.current?.nameWork?.toUpperCase().trim() == 'CALANDRA' ||
        widget.current?.nameWork?.toUpperCase().trim() == 'PLANCHA' ||
        widget.current?.nameWork?.toUpperCase().trim() == 'HORNO' ||
        widget.current?.nameWork?.toUpperCase().trim() == 'SELLOS') {
      isPktReport = false;
      // print('report solamante de publicar QTY Pcs');
    }
    const rutaImgen = "http://$ipLocal/settingmat/admin/imagen_serigrafias";
    return Container(
      width: 450,
      decoration: const BoxDecoration(color: Colors.white),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.teal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpansionTile(
              leading: ConstrainedBox(
                constraints: const BoxConstraints(
                    maxHeight: 150, maxWidth: 100, minHeight: 75, minWidth: 75),
                child: Hero(
                  tag: widget.current!.id.toString(),
                  child: CircleAvatar(
                    backgroundColor: ktejidoBlueOcuro,
                    child: Text(
                      widget.current!.nameLogo.toString().substring(0, 1),
                      style: style.titleLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
              title: Text(widget.current?.fullName ?? 'N/A',
                  style: style.titleSmall),
              subtitle: Text(widget.current?.nameLogo ?? 'N/A',
                  style: style.bodySmall),
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              // controller: controller,
              // trailing: IconButton(
              //     onPressed: () => viewControl(),
              //     icon: const Icon(Icons.settings_suggest_outlined,
              //         color: Colors.blue)),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26)),
                      child: InkWell(
                        onTap: () {
                          if (validarSupervisor()) {
                            // EdittingItemSerigrafiaDone
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) {
                                  return EdittingItemSerigrafiaDone(
                                      item: widget.current!);
                                },
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                      opacity: animation, child: child);
                                },
                                transitionDuration:
                                    const Duration(milliseconds: 600),
                                reverseTransitionDuration:
                                    const Duration(milliseconds: 400),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('No tiene permiso para editar'),
                                    backgroundColor: Colors.red));
                          }
                        },
                        child: const Icon(Icons.edit, color: Colors.black54),
                      ),
                    ),
                    InkWell(
                      onTap: () => openImagePicker(context),
                      child: Container(
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26)),
                        child: Icon(Icons.upload_file, color: Colors.black54),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26)),
                      child: const Icon(Icons.apartment_outlined,
                          color: Colors.black54),
                    ),
                    InkWell(
                      onTap: () => widget.deleteFromDone!(),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red.shade300)),
                        child: Icon(Icons.delete, color: Colors.red.shade300),
                      ),
                    ),
                  ],
                ),
                upImagen
                    ? const Center(
                        child: Text('Subiendo Imagen ... Espere Por favor.'))
                    : _imageList.isEmpty
                        ? const Center(
                            child: Text('No hay imágenes disponibles'))
                        : Container(
                            height: 150,
                            padding: const EdgeInsets.all(10),
                            child: PageView.builder(
                              controller: widget.pageController,
                              scrollDirection: Axis.horizontal,
                              itemCount: _imageList.length,
                              itemBuilder: (context, index) {
                                ImagenSerigrafia photos = _imageList[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, _, __) {
                                          return DetaileItemSerigrafiaImagen(
                                              onPageChanged:
                                                  (indexFromDetails) {
                                                widget.pageController
                                                    .jumpToPage(
                                                        indexFromDetails);
                                              },
                                              currentIndex: index,
                                              photos: _imageList);
                                        },
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          return FadeTransition(
                                              opacity: animation, child: child);
                                        },
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Hero(
                                      tag: photos.idSerigrafiaImagenPath
                                          .toString(),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: MyWidgetImagenSerigrafia(
                                              deleteImagen: () =>
                                                  deleteFromDone(
                                                      context, photos),
                                              imageUrl:
                                                  '$rutaImgen/${photos.namePath ?? ''}')),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ],
            ),

            const Divider(endIndent: 50, indent: 50),
            // const Divider(endIndent: 75, indent: 75),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Numero Orden'),
                      Text('Ficha : '),
                      Text('Qty Orden : '),
                      Text('Qty : '),
                      Text('Trabajos : '),
                      Text('Turno : '),
                    ],
                  ),
                  Column(
                    children: [
                      Text(widget.current?.numOrden ?? 'N/A'),
                      Text(widget.current?.ficha ?? 'N/A'),
                      Text(widget.current?.cantOrden ?? 'N/A'),
                      Text(widget.current?.cantPieza ?? 'N/A',
                          style: const TextStyle(
                              color: ktejidoBlueOcuro,
                              fontWeight: FontWeight.bold)),
                      Text(widget.current?.nameWork ?? 'N/A'),
                      Text(widget.current?.turn ?? 'N/A'),
                    ],
                  )
                ],
              ),
            ),
            isPktReport
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MyWidgetTap(
                          label: 'Full', text: widget.current?.dFull ?? 'N/A'),
                      MyWidgetTap(
                          label: 'C. Full',
                          text: widget.current?.colorfull ?? 'N/A'),
                      MyWidgetTap(
                          label: 'PKT', text: widget.current?.pkt ?? 'N/A'),
                      MyWidgetTap(
                          label: 'C. PKT',
                          text: widget.current?.colorpkt ?? 'N/A'),
                    ],
                  )
                : const SizedBox(),
            // const Divider(endIndent: 50, indent: 50),
            const Divider(endIndent: 50, indent: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.public,
                              size: 15, color: Colors.grey),
                          const SizedBox(width: 5),
                          Text(
                            widget.current!.dateStart.toString(),
                            style: style.labelLarge!
                                .copyWith(fontFamily: fontMuseo),
                          ),
                        ],
                      ),
                      Text(
                        widget.current!.dateEnd.toString(),
                        style: style.bodySmall,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.timelapse_rounded,
                          size: 15, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(getTimeRelation(widget.current!.dateStart ?? 'N/A',
                          widget.current!.dateEnd ?? 'N/A')),
                    ],
                  ),
                ],
              ),
            ),
            widget.current!.statu == 't'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check, color: colorsGreenLevel),
                          const SizedBox(width: 5),
                          Text(
                            'Calidad Verificada',
                            style: TextStyle(
                                color: colorsGreenLevel,
                                fontWeight: FontWeight.bold,
                                fontFamily: fontTenali),
                          ),
                        ],
                      ),
                      Sublima.isRatedWork(widget.current!)
                          ? validateAdmin()
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: SizedBox(
                                    width: 100,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateColor.resolveWith(
                                                  (states) =>
                                                      const Color.fromARGB(
                                                          255, 29, 66, 152)),
                                          shape:
                                              MaterialStateProperty.resolveWith(
                                                  (states) =>
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)))),
                                      onPressed: () => calificar(),
                                      child: Text(
                                        'Calificar',
                                        style: style.bodySmall
                                            ?.copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Text('Sin Calificar aun! 😔',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: fontTenali)),
                                )
                          : SizedBox(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: StarRating(
                                      percent: int.parse(
                                          widget.current!.rating ?? '0'))))
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.close, color: colorsRed),
                      const SizedBox(width: 5),
                      Text(
                        'Calidad no verificada',
                        style: TextStyle(
                            color: colorsRed,
                            fontWeight: FontWeight.bold,
                            fontFamily: fontTenali),
                      ),
                    ],
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: GestureDetector(
                onTap: () => comment(),
                child: Text(
                  widget.current?.nota ?? 'N/A',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: colorsBlueDeepHigh,
                      fontWeight: FontWeight.bold,
                      fontFamily: fontTenali),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
