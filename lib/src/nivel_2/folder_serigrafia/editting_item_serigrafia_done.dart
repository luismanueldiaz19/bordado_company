import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '/src/datebase/current_data.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/font_style.dart';
import '../forder_sublimacion/model_nivel/sublima.dart';

class EdittingItemSerigrafiaDone extends StatefulWidget {
  const EdittingItemSerigrafiaDone({super.key, required this.item});
  final Sublima item;

  @override
  State<EdittingItemSerigrafiaDone> createState() =>
      _EdittingItemSerigrafiaDoneState();
}

class _EdittingItemSerigrafiaDoneState
    extends State<EdittingItemSerigrafiaDone> {
  TextEditingController controllerOrden = TextEditingController();
  TextEditingController controllerLogo = TextEditingController();
  TextEditingController controllerFicha = TextEditingController();
  TextEditingController controllerCantOrden = TextEditingController();
  TextEditingController? controllerPieza = TextEditingController();
  TextEditingController? controllerPKt = TextEditingController();
  TextEditingController? controllerFull = TextEditingController();
  double valueSlider = 0;
  double _sliderpktColors = 0;
  double _sliderfullColors = 0;
  bool isSending = false;
  bool isComplete = false;
  updatedData(context) async {
    // if (controllerOrden.text.isNotEmpty &&
    //     controllerCantOrden.text.isNotEmpty &&
    //     controllerFicha.text.isNotEmpty &&
    //     controllerLogo.text.isNotEmpty) {
    //   setState(() {
    //     isSending = true;
    //   });

    //   //update_edit_serigrafia_online_work.php
    //   String url =
    //       "http://$ipLocal/settingmat/admin/update/update_edit_serigrafia_done.php";
    //   final res = await httpRequestDatabase(url, widget.item.toJson());

    //   setState(() {
    //     isSending = false;
    //   });
    //   scaffoldMensaje(
    //       context: context, background: Colors.green, mjs: res.body);
    //   // await Provider.of<ProviderSerigrafia>(context, listen: false)
    //   //     .getWork(widget.item.idDepart);
    // } else {
    //   // utilShowMesenger(context, 'Hay Campos Vacios');
    // }
  }

  @override
  void dispose() {
    super.dispose();
    controllerOrden.dispose();
    controllerCantOrden.dispose();
    controllerFicha.dispose();
    controllerLogo.dispose();
    controllerPieza?.dispose();
    controllerPKt?.dispose();
    controllerFull?.dispose();
  }

  @override
  void initState() {
    super.initState();

    controllerOrden.text = widget.item.numOrden.toString();
    controllerCantOrden.text = widget.item.cantOrden.toString();
    controllerFicha.text = widget.item.ficha.toString();
    controllerLogo.text = widget.item.nameLogo.toString();
    controllerPieza?.text = widget.item.cantPieza.toString();
    controllerPKt?.text = widget.item.pkt.toString();
    controllerFull?.text = widget.item.dFull.toString();
    _sliderpktColors = double.parse(widget.item.colorpkt ?? '1');
    _sliderfullColors = double.parse(widget.item.colorfull ?? '1');
  }

  bool validateInput(String input) {
    return input != '0';
  }

  Color calculateThumbColor(double value) {
    if (value <= 2) {
      return Colors.red;
    } else if (value <= 4) {
      return Colors.blue;
    } else {
      return Colors.brown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.copyWith(
        titleSmall: TextStyle(fontFamily: fontMuseo),
        bodySmall: TextStyle(fontFamily: fontBalooPaaji));
    final size = MediaQuery.of(context).size;

    bool isPktReport = true;
    if (widget.item.nameWork?.toUpperCase().trim() == 'EMPAQUE' ||
        widget.item.nameWork?.toUpperCase().trim() == 'CALANDRA' ||
        widget.item.nameWork?.toUpperCase().trim() == 'PLANCHA' ||
        widget.item.nameWork?.toUpperCase().trim() == 'HORNO' ||
        widget.item.nameWork?.toUpperCase().trim() == 'SELLOS') {
      isPktReport = false;
      print('report solamante de publicar QTY Pcs');
    }
    valueSlider = 13;
    return Scaffold(
      appBar: AppBar(title: const Text('Modo Editación')),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          Hero(
            tag: widget.item.id.toString(),
            child: Container(
              height: 50,
              width: 100,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: ktejidoBlueOcuro,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(13),
                    topRight: Radius.circular(13),
                    bottomLeft: Radius.circular(13),
                    bottomRight: Radius.circular(13)),
              ),
              child: Text(widget.item.nameLogo.toString().substring(0, 1),
                  style: style.titleLarge?.copyWith(color: Colors.white)),
            ),
          ),
          Text(widget.item.fullName ?? 'N/A', style: style.titleSmall),
          const SizedBox(height: 10),
          isPktReport
              ? isComplete
                  ? SizedBox(
                      height: size.height * 0.25,
                      width: size.height * 0.25,
                      child: Lottie.asset('animation/done.json',
                          repeat: false, fit: BoxFit.cover),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1.0)),
                              width: 250,
                              child: TextField(
                                enabled: !isSending,
                                controller: controllerLogo,
                                onChanged: (val) {
                                  widget.item.nameLogo = val;
                                },
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  hintText: 'Nombre del logo',
                                  label: Text('Nombre del logo'),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1.0)),
                              width: 250,
                              child: TextField(
                                enabled: !isSending,
                                textInputAction: TextInputAction.done,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                keyboardType: TextInputType.number,
                                onChanged: (val) {
                                  widget.item.numOrden = val;
                                },
                                controller: controllerOrden,
                                decoration: const InputDecoration(
                                  hintText: 'Num Orden',
                                  label: Text('Num Orden'),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1.0)),
                              width: 250,
                              child: TextField(
                                enabled: !isSending,
                                textInputAction: TextInputAction.done,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                keyboardType: TextInputType.number,
                                controller: controllerFicha,
                                onChanged: (val) {
                                  widget.item.ficha = val;
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Ficha',
                                  label: Text('Ficha'),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1.0)),
                              width: 250,
                              child: TextField(
                                enabled: !isSending,
                                controller: controllerCantOrden,
                                onChanged: (val) {
                                  widget.item.cantOrden = val;
                                },
                                textInputAction: TextInputAction.next,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Qty Orden',
                                  label: Text('Qty Orden'),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1.0)),
                              width: 250,
                              child: TextField(
                                enabled: !isSending,
                                onChanged: (value) {
                                  if (!validateInput(value)) {
                                    controllerPieza!.clear();
                                  }
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                controller: controllerPieza,
                                decoration: const InputDecoration(
                                  hintText: 'Cantidad',
                                  label: Text('Qty'),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1.0)),
                              width: 250,
                              child: TextField(
                                enabled: !isSending,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                controller: controllerFull,
                                decoration: const InputDecoration(
                                  hintText: 'FULL',
                                  label: Text('FULL'),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1.0)),
                              width: 250,
                              child: TextField(
                                enabled: !isSending,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                controller: controllerPKt,
                                decoration: const InputDecoration(
                                  hintText: 'PKT',
                                  label: Text('PKT'),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: 250,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('¿Cuántos colores tiene FULL?'),
                                  Slider(
                                    activeColor:
                                        calculateThumbColor(_sliderfullColors),
                                    thumbColor: Colors.white,
                                    label: _sliderfullColors.toStringAsFixed(0),
                                    value: _sliderfullColors,
                                    min: 0,
                                    max: 6,
                                    divisions: 5,
                                    onChanged: (value) {
                                      setState(() {
                                        _sliderfullColors = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: 250,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('¿Cuántos colores tiene PKT?'),
                                  Slider(
                                    activeColor:
                                        calculateThumbColor(_sliderpktColors),
                                    value: _sliderpktColors,
                                    min: 0,
                                    max: 6,
                                    label: _sliderpktColors.toStringAsFixed(0),
                                    divisions: 5,
                                    onChanged: (value) {
                                      setState(() {
                                        _sliderpktColors = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            isSending
                                ? SizedBox(
                                    width: 250,
                                    child: Column(
                                      children: [
                                        const LinearProgressIndicator(
                                            backgroundColor: ktejidoBlueOcuro,
                                            color: Colors.white),
                                        Text('Actualizando .. Espere',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    color: ktejidoBlueOcuro)),
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    width: 250,
                                    child: ElevatedButton(
                                      onPressed: () => updatedData(context),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateColor.resolveWith(
                                                  (states) =>
                                                      const Color.fromARGB(
                                                          255, 29, 66, 152))),
                                      child: const Text('Actualizar',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    )
              : const SizedBox(),
          !isPktReport
              ? isComplete
                  ? SizedBox(
                      height: size.height * 0.25,
                      width: size.height * 0.25,
                      child: Lottie.asset('animation/done.json',
                          repeat: false, fit: BoxFit.cover),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1.0)),
                              width: 250,
                              child: TextField(
                                enabled: !isSending,
                                controller: controllerLogo,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  hintText: 'Nombre del logo',
                                  label: Text('Nombre del logo'),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1.0)),
                              width: 250,
                              child: TextField(
                                enabled: !isSending,
                                textInputAction: TextInputAction.done,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                keyboardType: TextInputType.number,
                                controller: controllerOrden,
                                decoration: const InputDecoration(
                                  hintText: 'Num Orden',
                                  label: Text('Num Orden'),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1.0)),
                              width: 250,
                              child: TextField(
                                enabled: !isSending,
                                textInputAction: TextInputAction.done,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                keyboardType: TextInputType.number,
                                controller: controllerFicha,
                                decoration: const InputDecoration(
                                  hintText: 'Ficha',
                                  label: Text('Ficha'),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1.0)),
                              width: 250,
                              child: TextField(
                                enabled: !isSending,
                                controller: controllerCantOrden,
                                textInputAction: TextInputAction.next,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Qty Orden',
                                  label: Text('Qty Orden'),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(1.0)),
                                width: 250,
                                alignment: Alignment.center,
                                child: Text(widget.item.nameWork ?? 'N/A')),
                            const SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1.0)),
                              width: 250,
                              child: TextField(
                                enabled: !isSending,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  if (!validateInput(value)) {
                                    controllerPieza!.clear();
                                  }
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                controller: controllerPieza,
                                decoration: const InputDecoration(
                                  hintText: 'Cantidad',
                                  label: Text('Qty'),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            isSending
                                ? SizedBox(
                                    width: 250,
                                    child: Column(
                                      children: [
                                        const LinearProgressIndicator(
                                            backgroundColor: ktejidoBlueOcuro,
                                            color: Colors.white),
                                        Text('Actualizando .. Espere',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    color: ktejidoBlueOcuro)),
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    width: 250,
                                    child: ElevatedButton(
                                      onPressed: () => updatedData(context),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateColor.resolveWith(
                                                  (states) =>
                                                      const Color.fromARGB(
                                                          255, 29, 66, 152))),
                                      child: const Text('Actualizar',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    )
              : const SizedBox(),
          identy(context)
        ],
      ),
    );
  }
}
