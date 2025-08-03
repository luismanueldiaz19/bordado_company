import 'package:flutter/material.dart';
import '/src/widgets/custom_app_bar.dart';

class ScreenReportSuperVisor extends StatefulWidget {
  const ScreenReportSuperVisor({Key? key}) : super(key: key);

  @override
  State<ScreenReportSuperVisor> createState() => _ScreenReportSuperVisorState();
}

class _ScreenReportSuperVisorState extends State<ScreenReportSuperVisor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Reporte de supervisores'),
        ],
      ),
    );
  }
}
