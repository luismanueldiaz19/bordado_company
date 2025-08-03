import 'package:flutter/material.dart';

import '../../../datebase/url.dart';
import '../../folder_satreria/widgtes/imagen_widget_tipo_work.dart';
import '../model/imagen_serigrafia.dart';

class DetaileItemSerigrafiaImagen extends StatefulWidget {
  const DetaileItemSerigrafiaImagen(
      {super.key,
      required this.currentIndex,
      required this.photos,
      required this.onPageChanged});
  final int currentIndex;
  final List<ImagenSerigrafia> photos;
  final ValueChanged<int> onPageChanged;
  @override
  State<DetaileItemSerigrafiaImagen> createState() =>
      _DetaileItemSerigrafiaImagenState();
}

class _DetaileItemSerigrafiaImagenState
    extends State<DetaileItemSerigrafiaImagen> {
  late final controller = PageController(initialPage: widget.currentIndex);

  ///saber posicion en la recorriste y notificarle al padre principa con el index de pageView
  ///

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sized = MediaQuery.of(context).size;
    const rutaImgen = "http://$ipLocal/settingmat/admin/imagen_serigrafias";
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        color: Colors.black,
        alignment: Alignment.center,
        height: sized.height / 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Center(
            child: SizedBox(
              height: sized.height / 2,
              child: PageView(
                controller: controller,
                onPageChanged: widget.onPageChanged,
                children: [
                  for (final photo in widget.photos)
                    Hero(
                      tag: photo.idSerigrafiaImagenPath.toString(),
                      child: MyWidgetImagen(
                          imageUrl: '$rutaImgen/${photo.namePath ?? ''}',
                          width: sized.width,
                          height: sized.height / 2),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
