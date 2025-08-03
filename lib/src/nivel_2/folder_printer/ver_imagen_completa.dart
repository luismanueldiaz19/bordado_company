import 'package:flutter/material.dart';

class VerImagenCompleta extends StatelessWidget {
  final String url;

  const VerImagenCompleta({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                maxScale: 5.0,
                minScale: 0.5,
                child: Center(
                  child: Image.network(
                    url,
                    fit: BoxFit.contain, // Muy importante
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
