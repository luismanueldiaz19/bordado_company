import 'dart:typed_data';

import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
import '/src/datebase/methond.dart';
import '/src/util/commo_pallete.dart';
import '../../../../util/get_day_writed.dart';
import '../../../../util/get_time_relation.dart';
import '../../../folder_confecion/model/confecion.dart';

class ShowGraficsPromedio extends StatefulWidget {
  final List<Confeccion> data;

  const ShowGraficsPromedio({super.key, required this.data});

  @override
  State<ShowGraficsPromedio> createState() => _ShowGraficsPromedioState();
}

class _ShowGraficsPromedioState extends State<ShowGraficsPromedio> {
  //  ScreenshotController screenshotController = ScreenshotController();

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        color: Colors.white54,
        width: sized.width < 600 ? sized.width : sized.width * 0.40,
        // child: SfCartesianChart(
        //   primaryXAxis: const CategoryAxis(),
        //   primaryYAxis: const NumericAxis(),
        //   title: ChartTitle(
        //       text: 'Producción Semanal',
        //       textStyle:
        //           style.labelSmall?.copyWith(color: colorsBlueDeepHigh)),
        //   series: <CartesianSeries>[
        //     LineSeries<Confeccion, String>(
        //         color: Colors.black,
        //         dataSource: widget.data,
        //         xValueMapper: (Confeccion sales, _) =>
        //             sales.semana.toString().substring(0, 10),
        //         yValueMapper: (Confeccion sales, _) => int.parse(
        //             double.parse(sales.cantPieza ?? '0').toStringAsFixed(0))),
        //     ColumnSeries<Confeccion, String>(
        //       width: 0.1,
        //       pointColorMapper: (Confeccion trampa, _) => ktejidogrey,
        //       dataSource: widget.data,
        //       xValueMapper: (Confeccion trampa, _) =>
        //           trampa.semana.toString().substring(0, 10),
        //       yValueMapper: (Confeccion trampa, _) =>
        //           double.parse(trampa.cantPieza ?? '0'),
        //       dataLabelSettings: DataLabelSettings(
        //           isVisible: true,
        //           labelAlignment: ChartDataLabelAlignment.auto,
        //           textStyle: style.labelSmall!),
        //       dataLabelMapper: (trampa, index) {
        //         return '${trampa.cantPieza}\n ${getDayWritted(trampa.semana.toString().substring(0, 10))}';
        //       },
        //     ),
        //   ],
        // ),
      ),
    );

    // Column(
    //   children: [
    //    const Divider(),
    //     ElevatedButton.icon(
    //         icon: const Icon(Icons.print, color: Colors.white),
    //         style: ButtonStyle(
    //           backgroundColor:
    //               MaterialStateProperty.resolveWith((states) => ktejidoblue),
    //           shape: MaterialStateProperty.resolveWith((states) =>
    //               RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(3))),
    //         ),
    //         onPressed: () => captureAndSaveScreens(context),
    //         label:
    //             const Text('Imprimir', style: TextStyle(color: Colors.white))),
    //   ],
    // );
  }
}
