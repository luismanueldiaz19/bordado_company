import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/department.dart';
import '../../widgets/validar_screen_available.dart';
import '../../widgets/widget_not_screen.dart';
import 'add_plan_printer.dart';
import 'mobile_screen.dart';
import 'model/printer_plan.dart';
import 'printer_provider.dart';
// import 'printer_provider.dart';

class ScreenPrinter extends StatefulWidget {
  const ScreenPrinter({super.key, required this.depart});
  final Department? depart;

  @override
  State<ScreenPrinter> createState() => _ScreenPrinterState();
}

class _ScreenPrinterState extends State<ScreenPrinter> {
  String? firstDate = DateTime.now().toString().substring(0, 10);

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final providerWatch = context.watch<PrinterProvider>();
    final providerRead = context.read<PrinterProvider>();
    final double fontSize = getResponsiveFontSize(context, scale: 3.0);
    const curve = Curves.elasticInOut;
    return Scaffold(
      backgroundColor: PrinterPlan.getColorByDepartment(
          widget.depart?.nameDepartment ?? 'N/A'),
      appBar: AppBar(
        title: Text(widget.depart?.nameDepartment ?? 'N/A',
            style: style.titleLarge),
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Bounce(
                  curve: curve,
                  child: Text(
                    '${widget.depart?.nameDepartment}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Checkbox(
                  fillColor: MaterialStateColor.resolveWith(
                    (states) => Colors.white,
                  ),
                  checkColor: Colors.black,
                  value: providerWatch.estadoPicked,
                  onChanged: (val) {
                    providerRead.setEstadoPicked(widget.depart);
                  },
                ),
                const Text(
                  'Terminados!',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ValidarScreenAvailable(
        mobile: const NotScreenWidget(),
        windows: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 1),
                      child: ClipPath(
                        clipper: DientesClipper(
                            dienteAncho: 50, dienteAlto: 15, radioEsquina: 10),
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: MobileScreen(depart: widget.depart)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

double getResponsiveFontSize(BuildContext context, {double scale = 1}) {
  final Size size = MediaQuery.of(context).size;

  // Escala basada en ancho (puedes usar height si prefieres)
  double baseWidth = 1920; // resolución de referencia
  double currentWidth = size.width;

  return (currentWidth / baseWidth) * 16 * scale; // 16 es el tamaño base
}
