import 'package:flutter/material.dart';

class ProductoImagenWidget extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final bool showPlaceholderIfEmpty;

  const ProductoImagenWidget({
    super.key,
    required this.imageUrl,
    this.width = 100,
    this.height = 100,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.showPlaceholderIfEmpty = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl.trim().isNotEmpty;

    if (!hasImage && showPlaceholderIfEmpty) {
      return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: borderRadius,
          ),
          child: const Icon(Icons.image_not_supported, size: 40));
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            alignment: Alignment.center,
            child: const Icon(Icons.broken_image, size: 40),
          );
        },
      ),
    );
  }
}
