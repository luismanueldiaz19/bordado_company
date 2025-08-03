import 'package:flutter/material.dart';
import '/src/nivel_2/forder_sublimacion/model_nivel/image_get_path_file.dart';
import '/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
import '/src/widgets/custom_app_bar.dart';

class ShowImageFile extends StatefulWidget {
  const ShowImageFile(
      {Key? key,
      required this.images,
      required this.current,
      required this.urlImage})
      : super(key: key);
  final List<ImageGetPathFile> images;
  final Sublima current;
  final String urlImage;

  @override
  State<ShowImageFile> createState() => _ShowImageFileState();
}

class _ShowImageFileState extends State<ShowImageFile> {
  // '$urlImage${current.imagePath}'
  @override
  Widget build(BuildContext context) {
    var textSize = 15.0;
    final style = Theme.of(context).textTheme;
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Imagen de la orden'),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Logo : ${widget.current.nameLogo.toString()}",
                style: style.bodyMedium!.copyWith(fontSize: textSize),
              ),
              Column(
                children: [
                  Text(
                    'Num Orden ${widget.current.numOrden.toString()}',
                    style: style.bodyMedium!.copyWith(fontSize: textSize),
                  ),
                  Text(
                    'Ficha : ${widget.current.ficha.toString()}',
                    style: style.bodyMedium!.copyWith(fontSize: textSize),
                  ),
                ],
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                ImageGetPathFile current = widget.images[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: SizedBox(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        '${widget.urlImage}${current.imagePath}',
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: Text('Loading...'));
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('Error Imagen');
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
