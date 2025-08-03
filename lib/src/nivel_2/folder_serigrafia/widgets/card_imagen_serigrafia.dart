import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyWidgetImagenSerigrafia extends StatelessWidget {
  const MyWidgetImagenSerigrafia(
      {super.key,
      required this.imageUrl,
      this.height = 150,
      this.width = 150,
      required this.deleteImagen});
  final String imageUrl;
  final double? height;
  final double? width;
  final Function deleteImagen;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
            height: height,
            width: width,
          ),
          Positioned(
              bottom: 0,
              child: Container(
                height: 35,
                color: Colors.black45,
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                        onPressed: () => deleteImagen(),
                        icon: const Icon(Icons.delete, color: Colors.white)),
                    TextButton(
                      onPressed: () => deleteImagen(),
                      child: Text('Eliminar',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white)),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
