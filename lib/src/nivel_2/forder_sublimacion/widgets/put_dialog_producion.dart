import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/src/util/helper.dart';

import '../../../datebase/methond.dart';
import '../../../datebase/url.dart';
import '../../../provider/provider_sublimacion.dart';
import '../../../util/commo_pallete.dart';
import '../model_nivel/list_work_sublimacion.dart';

class PutDialogProducion extends StatefulWidget {
  const PutDialogProducion({super.key, this.item});
  final Item? item;

  @override
  State<PutDialogProducion> createState() => _PutDialogProducionState();
}

class _PutDialogProducionState extends State<PutDialogProducion> {
  final TextEditingController piezaController = TextEditingController();
  final TextEditingController pktController = TextEditingController();
  final TextEditingController pFullController = TextEditingController();

  void putWithPkt() async {
    if (piezaController.text.isNotEmpty &&
        pktController.text.isNotEmpty &&
        pFullController.text.isNotEmpty) {
      widget.item?.cantPiezaSublimacionWork = piezaController.text;
      widget.item?.pFull = pFullController.text;
      widget.item?.pkt = pktController.text;
      widget.item?.statuSublimacionWork = 't';
      widget.item?.dateEndSublimacionWork =
          DateTime.now().toString().substring(0, 19);

      await updateItem(widget.item!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error campos vacio'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void putPieza() async {
    if (piezaController.text.isNotEmpty) {
      widget.item?.cantPiezaSublimacionWork = piezaController.text;
      widget.item?.statuSublimacionWork = 't';
      widget.item?.dateEndSublimacionWork =
          DateTime.now().toString().substring(0, 19);
      await updateItem(widget.item!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error campos de pieza vacio'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future updateItem(Item json) async {
    var data = {
      'id': json.idSublimacionWork,
      'num_orden': json.numOrdenSublimacionWork,
      'date_start': json.dateStartSublimacionWork,
      'date_end': json.dateEndSublimacionWork,
      'statu': json.statuSublimacionWork,
      'ficha': json.fichaSublimacionWork,
      'cant_pieza': json.cantPiezaSublimacionWork,
      'cant_orden': json.cantOrdenSublimacionWork,
      'name_logo': json.nameLogoSublimacionWork,
      'p_full': json.pFull,
      'pkt': json.pkt
    };
    // print(data);
    await httpRequestDatabase(
        "http://$ipLocal/settingmat/admin/update/update_sublimacion_item_list.php",
        data);
    if (!mounted) {
      return null;
    }
    Provider.of<ProviderSublimacion>(context, listen: false).getListWork();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    bool isPktReport = true;

    if (widget.item!.typeWork!.toUpperCase().trim() == 'EMPAQUE' ||
        widget.item!.typeWork!.toUpperCase().trim() == 'CALANDRA' ||
        widget.item!.typeWork!.toUpperCase().trim() == 'PLANCHA' ||
        widget.item!.typeWork!.toUpperCase().trim() == 'HORNO' ||
        widget.item!.typeWork!.toUpperCase().trim() == 'SELLOS') {
      isPktReport = false;
    }
    final style = Theme.of(context).textTheme;
    return AlertDialog(
      title: Text('Haz tu reporte !', style: style.labelLarge),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: double.infinity),
            SlideInRight(
              curve: Curves.elasticInOut,
              child: buildTextFieldValidator(
                controller: piezaController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*$')),
                ],
                hintText: 'Escribir Pieza',
                label: 'Pieza  *',
              ),
            ),
            isPktReport
                ? Column(
                    children: [
                      SlideInLeft(
                        curve: Curves.elasticInOut,
                        child: buildTextFieldValidator(
                          controller: pFullController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[1-9]\d*$')),
                          ],
                          hintText: 'Pieza Full',
                          label: 'Full  *',
                        ),
                      ),
                      SlideInRight(
                        curve: Curves.elasticInOut,
                        child: buildTextFieldValidator(
                            controller: pktController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[1-9]\d*$')),
                            ],
                            hintText: 'Pieza PKT',
                            label: 'PKT  *'),
                      ),
                    ],
                  )
                : const SizedBox()
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
        ),
        customButton(
          width: 150,
          colorText: Colors.white,
          colors: colorsGreenTablas,
          textButton: 'Publicar',
          onPressed: isPktReport ? putWithPkt : putPieza,
        )
      ],
    );
  }
}
