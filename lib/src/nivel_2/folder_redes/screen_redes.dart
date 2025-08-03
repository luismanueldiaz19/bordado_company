import 'package:flutter/material.dart';
import '/src/widgets/custom_app_bar.dart';

class ScreenRedes extends StatefulWidget {
  const ScreenRedes({Key? key}) : super(key: key);

  @override
  State<ScreenRedes> createState() => _ScreenRedesState();
}

class _ScreenRedesState extends State<ScreenRedes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Administración de redes'),
        ],
      ),
    );
  }
}
