import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/src/util/commo_pallete.dart';
import '/src/widgets/mensaje_scaford.dart';

import '../../datebase/methond.dart';
import '../../datebase/url.dart';
import '../forder_sublimacion/model_nivel/sublima.dart';
import 'provider/provider_serigrafia.dart';

class EdittingItemSerigrafia extends StatefulWidget {
  const EdittingItemSerigrafia({super.key, required this.item});
  final Sublima item;

  @override
  State<EdittingItemSerigrafia> createState() => _EdittingItemSerigrafiaState();
}

class _EdittingItemSerigrafiaState extends State<EdittingItemSerigrafia> {
  TextEditingController controllerOrden = TextEditingController();
  TextEditingController controllerLogo = TextEditingController();
  TextEditingController controllerFicha = TextEditingController();
  TextEditingController controllerCantOrden = TextEditingController();
  bool isSending = false;
  updatedData(context) async {
    if (controllerOrden.text.isNotEmpty &&
        controllerCantOrden.text.isNotEmpty &&
        controllerFicha.text.isNotEmpty &&
        controllerLogo.text.isNotEmpty) {
      setState(() {
        isSending = true;
      });

      //update_edit_serigrafia_online_work.php
      String url =
          "http://$ipLocal/settingmat/admin/update/update_edit_serigrafia_online_work.php";
      final res = await httpRequestDatabase(url, {
        'num_orden': controllerOrden.text,
        'ficha': controllerFicha.text,
        'cant_orden': controllerCantOrden.text,
        'name_logo': controllerLogo.text,
        'id': widget.item.id.toString()
      });

      setState(() {
        isSending = false;
      });
      scaffoldMensaje(
          context: context, background: Colors.green, mjs: res.body);
      await Provider.of<ProviderSerigrafia>(context, listen: false)
          .getWork(widget.item.idDepart);
    } else {
      // utilShowMesenger(context, 'Hay Campos Vacios');
    }
  }

  @override
  void dispose() {
    super.dispose();
    controllerOrden.dispose();
    controllerCantOrden.dispose();
    controllerFicha.dispose();
    controllerLogo.dispose();
  }

  @override
  void initState() {
    super.initState();
    controllerOrden.text = widget.item.numOrden.toString();
    controllerCantOrden.text = widget.item.cantOrden.toString();
    controllerFicha.text = widget.item.ficha.toString();
    controllerLogo.text = widget.item.nameLogo.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modo Editación')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(width: double.infinity),
            Hero(
                tag: widget.item.id.toString(),
                child: Image.asset('assets/actualizacion.png', scale: 5)),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
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
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Qty Orden',
                        label: Text('Qty Orden'),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  isSending
                      ? SizedBox(
                          width: 250,
                          child: Column(
                            children: [
                              const LinearProgressIndicator(
                                  backgroundColor: ktejidoBlueOcuro,
                                  color: Colors.white),
                              Text('Enviando',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: ktejidoBlueOcuro)),
                            ],
                          ),
                        )
                      : SizedBox(
                          width: 250,
                          child: ElevatedButton(
                            onPressed: () => updatedData(context),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => const Color.fromARGB(
                                        255, 29, 66, 152))),
                            child: const Text('Actualizar',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
