import 'package:flutter/material.dart';
import '/src/widgets/widget_not_screen.dart';

class ValidarScreenAvailable extends StatelessWidget {
  const ValidarScreenAvailable(
      {super.key,
      required this.windows,
      this.mobile = const NotScreenWidget()});
  final Widget windows;
  final Widget? mobile;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return size.width < 800 || size.height < 405 ? mobile! : windows;
  }
}
