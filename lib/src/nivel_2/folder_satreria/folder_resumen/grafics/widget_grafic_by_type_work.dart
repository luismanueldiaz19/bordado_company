
import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../folder_confecion/model/confecion.dart';

class WidgetGraficByTypeWork extends StatefulWidget {
  final List<Confeccion> data;
  // final List<Confeccion> data;

  const WidgetGraficByTypeWork({super.key, required this.data});

  @override
  State<WidgetGraficByTypeWork> createState() => _WidgetGraficByTypeWorkState();
}

class _WidgetGraficByTypeWorkState extends State<WidgetGraficByTypeWork> {
  //  ScreenshotController screenshotController = ScreenshotController();
  // TooltipBehavior tooltipBehavior = TooltipBehavior();
  void captureAndSaveScreens(BuildContext context) async {
    try {
      String? path1Local;
      // Capturar la primera pantalla
      // screenshotController1.capture().then((Uint8List? image1) {
      //   if (image1 != null) {
      //     saveScreenshotToLocalFile(image1, nameFile: '1').then((path1) {});
      //   }
      // });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final sized = MediaQuery.of(context).size;
    print(widget.data);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        color: Colors.white54,
        width: sized.width < 900 ? sized.width : sized.width * 0.90,
        // child: SfCartesianChart(
        //   primaryXAxis: const CategoryAxis(),
        //   primaryYAxis: const NumericAxis(),
        //   legend: Legend(
        //       isVisible: true,
        //       legendItemBuilder:
        //           (String name, dynamic series, dynamic point, int index) {
        //         Confeccion item = widget.data[index];
        //         return Text(item.tipoTrabajo.toString());
        //       }),
        //   title: ChartTitle(
        //       text: 'Resumen',
        //       textStyle: style.labelSmall?.copyWith(color: colorsBlueDeepHigh)),
        //   series: widget.data
        //       .map(
        //         (item) => ColumnSeries<Confeccion, String>(
        //           pointColorMapper: (Confeccion trampa, _) => ktejidogrey,
        //           dataSource: [
        //             Confeccion(
        //                 tipoTrabajo: item.tipoTrabajo,
        //                 cantPieza: item.cantPieza)
        //           ],
        //           xValueMapper: (Confeccion trampa, _) =>
        //               trampa.tipoTrabajo.toString(),
        //           yValueMapper: (Confeccion trampa, _) =>
        //               double.parse(trampa.cantPieza ?? '0'),
        //           dataLabelSettings: DataLabelSettings(
        //               isVisible: true,
        //               labelAlignment: ChartDataLabelAlignment.auto,
        //               textStyle: style.labelSmall!),
        //           dataLabelMapper: (trampa, index) {
        //             return '${trampa.tipoTrabajo.toString()}\n${trampa.cantPieza.toString()}';
        //           },
        //         ),
        //       )
        //       .toList(),
        // ),
      ),
    );
  }
}

// class MyColumnChart extends StatelessWidget {
//   final List<Confeccion> data;

//   MyColumnChart({required this.data});

//   @override
//   Widget build(BuildContext context) {
//     final style = Theme.of(context).textTheme;
//     final sized = MediaQuery.of(context).size;
//     return SfCartesianChart(
//       title: ChartTitle(text: 'Column View (Data)'),
//       legend: Legend(
//         isVisible: true,
//         legendItemBuilder:
//             (String name, dynamic series, dynamic point, int index) {
//           final ChartSeries<dynamic, dynamic> chartSeries = series;
//           final ChartPoint<dynamic> chartPoint = point;

//           return Container(
//             padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(4),
//               color: Colors.grey[200],
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(width: 10, height: 10, color: chartSeries.color),
//                 SizedBox(width: 5),
//                 Text(name),
//               ],
//             ),
//           );
//         },
//       ),
//       tooltipBehavior: TooltipBehavior(enable: true),
//       series: <CartesianSeries>[
//         ColumnSeries<Confeccion, String>(
//           width: 0.1,
//           pointColorMapper: (Confeccion trampa, _) => ktejidogrey,
//           dataSource: data,
//           xValueMapper: (Confeccion trampa, _) => trampa.tipoTrabajo.toString(),
//           yValueMapper: (Confeccion trampa, _) =>
//               double.parse(trampa.cantPieza ?? '0'),
//           dataLabelSettings: DataLabelSettings(
//             isVisible: true,
//             labelAlignment: ChartDataLabelAlignment.auto,
//             textStyle: style.labelSmall!,
//           ),
//           // Usar generateDataLabels para personalizar las etiquetas de datos
//           dataLabelMapper: (trampa, index) {
//             return '${trampa.tipoTrabajo.toString()}\n${trampa.cantPieza.toString()}';
//           },
//         ),
//       ],
//     );
//   }
// }
