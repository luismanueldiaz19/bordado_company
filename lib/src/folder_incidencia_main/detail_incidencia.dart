import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '/src/datebase/current_data.dart';

import '../widgets/card_incidencia.dart';
import 'model_incidencia/incidencia_main.dart';

class DetailIncidencia extends StatefulWidget {
  const DetailIncidencia({super.key, this.report});
  final IncidenciaMain? report;

  @override
  State<DetailIncidencia> createState() => _DetailIncidenciaState();
}

class _DetailIncidenciaState extends State<DetailIncidencia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detalles'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(width: double.infinity),
              ZoomIn(
                  curve: Curves.elasticInOut,
                  child: SizedBox(
                      width: 450,
                      child: IncidenciaWidget(incidencia: widget.report!))),
              identy(context)
            ],
          ),
        ));
  }
}
