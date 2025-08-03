import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/nivel_2/folder_confecion/model/confecion.dart';
import '/src/nivel_2/folder_confecion/model/url_confecion.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/show_mesenger.dart';
import '/src/widgets/custom_app_bar.dart';

class DetallesItemSastreria extends StatefulWidget {
  const DetallesItemSastreria({Key? key, this.item}) : super(key: key);
  final Confeccion? item;

  @override
  State<DetallesItemSastreria> createState() => _DetallesItemSastreriaState();
}

class _DetallesItemSastreriaState extends State<DetallesItemSastreria> {
  TextEditingController controllerOrden = TextEditingController();
  TextEditingController controllerLogo = TextEditingController();
  TextEditingController controllerFicha = TextEditingController();
  TextEditingController controllertipoTrabajo = TextEditingController();
//---------------------------------------------//
  TextEditingController cant = TextEditingController();
  bool isloading = false;
  String calidaString = '';
  bool isUpdatedModo = false;

  @override
  void initState() {
    super.initState();
    controllerOrden.text = widget.item!.numOrden.toString();
    controllerLogo.text = widget.item!.nameLogo.toString();
    controllerFicha.text = widget.item!.ficha.toString();

    controllertipoTrabajo.text = widget.item!.tipoTrabajo.toString();
  }

  Future updateWorkConfecion() async {
    if (controllerLogo.text.isNotEmpty &&
        controllerOrden.text.isNotEmpty &&
        controllerFicha.text.isNotEmpty &&
        controllertipoTrabajo.text.isNotEmpty) {
      setState(() {
        isloading = true;
      });
      var data = {
        'id': widget.item?.id,
        'num_orden': controllerOrden.text,
        'ficha': controllerFicha.text,
        'name_logo': controllerLogo.text,
        'tipo_trabajo': controllertipoTrabajo.text
      };

      // print(data);
      // num_orden']; ['tipo_trabajo'];	['name_logo'];['ficha'] ['id'];
      await httpRequestDatabase(updateReportSastreria, data);

      controllerOrden.clear();
      controllerFicha.clear();

      controllerLogo.clear();
      controllertipoTrabajo.clear();
      if (mounted) Navigator.pop(context, true);
    } else {
      utilShowMesenger(context, 'Error Campos vacios');
    }
  }

  Future reportMake() async {
    if (cant.text.isNotEmpty) {
      setState(() {
        isloading = true;
      });
      var data = {
        'cant_pieza': cant.text,
        'id': widget.item?.id,
        'comment': calidaString
      };
      // print(data);

      await httpRequestDatabase(updateReportSastreriaCantPieza, data);
      // print('reportMake :   ${res.body}');
      if (mounted) Navigator.pop(context, true);
    } else {
      utilShowMesenger(context, 'Cantidad vacio');
    }
  }

  bool isCalidad = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Detalles'),
          isUpdatedModo
              ? Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ZoomIn(
                          duration: const Duration(milliseconds: 200),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  width: 250,
                                  child: TextField(
                                    controller: controllerOrden,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Num Orden',
                                      labelStyle:
                                          TextStyle(color: colorsBlueDeepHigh),
                                      hintText: 'Num Orden',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(left: 15),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  width: 250,
                                  child: TextField(
                                    controller: controllerFicha,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelStyle:
                                          TextStyle(color: colorsBlueDeepHigh),
                                      labelText: 'Ficha',
                                      hintText: 'Ficha',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(left: 15),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  width: 250,
                                  child: TextField(
                                    controller: controllerLogo,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      labelStyle:
                                          TextStyle(color: colorsBlueDeepHigh),
                                      labelText: 'Nombre Logo',
                                      hintText: 'Nombre Logo',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(left: 15),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  width: 250,
                                  child: TextField(
                                    controller: controllertipoTrabajo,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      labelStyle:
                                          TextStyle(color: colorsBlueDeepHigh),
                                      labelText: 'Tipo de Pieza',
                                      hintText: 'Tipo de Pieza',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(left: 15),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                isloading
                                    ? const Text('Subiendo')
                                    : ElevatedButton(
                                        onPressed: () => updateWorkConfecion(),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith((states) =>
                                                        Colors.white)),
                                        child: const Text('Guardar',
                                            style:
                                                TextStyle(color: Colors.green)),
                                      )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        // listOrden.isNotEmpty
                        //     ? SizedBox(
                        //         height: 200,
                        //         width: MediaQuery.of(context).size.width * 0.75,
                        //         child: SingleChildScrollView(
                        //           physics: const BouncingScrollPhysics(),
                        //           scrollDirection: Axis.horizontal,
                        //           child: Row(
                        //             children: listOrden
                        //                 .map((e) => SizedBox(
                        //                       width:
                        //                           MediaQuery.of(context).size.width *
                        //                               0.50,
                        //                       // color: Colors.red,
                        //                       child: ListTile(
                        //                         title: Text(
                        //                             'Logo:  ${e.nameLogo ?? 'N/A'}'),
                        //                         subtitle: Column(
                        //                           crossAxisAlignment:
                        //                               CrossAxisAlignment.start,
                        //                           children: [
                        //                             Text(
                        //                                 'Ficha : ${e.ficha ?? 'N/A'}'),
                        //                             Text(
                        //                                 "Num Orden ${e.numOrden ?? 'N/A'}"),
                        //                             Text(
                        //                                 "Cant Orden ${e.cantOrden ?? 'N/A'}")
                        //                           ],
                        //                         ),
                        //                       ),
                        //                     ))
                        //                 .toList(),
                        //           ),
                        //         ))
                        //     : const Text('Lista en espera...'),

                        ElevatedButton(
                          onPressed: () {
                            isUpdatedModo = false;
                            setState(() {});
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => Colors.white)),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(height: 20),
                    isCalidad
                        ? Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10.0)),
                            width: 250,
                            child: TextField(
                              controller: cant,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelStyle:
                                    TextStyle(color: colorsBlueDeepHigh),
                                labelText: 'Cantidad',
                                hintText: 'Cantidad',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 15),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 20),
                    isCalidad
                        ? const SizedBox()
                        : ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isCalidad = true;
                                calidaString =
                                    'Yo ${currentUsers?.fullName} Verifique la calidad de este producto';
                              });
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => Colors.white)),
                            child: const Text('Confirmación de calidad'),
                          ),
                    const SizedBox(height: 5),
                    isloading
                        ? const Text('Subiendo')
                        : isCalidad
                            ? ElevatedButton(
                                onPressed: () => reportMake(),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Colors.white)),
                                child: const Text('Reportar Cantidad'),
                              )
                            : const SizedBox(),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () {
                        isUpdatedModo = true;
                        setState(() {});
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.white)),
                      child: const Text('Modificar'),
                    )
                  ],
                )
        ],
      ),
    );
  }
}
