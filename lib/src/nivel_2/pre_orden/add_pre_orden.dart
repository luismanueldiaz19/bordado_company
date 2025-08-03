import 'package:animate_do/animate_do.dart';
import 'package:bordado_company/src/widgets/mensaje_scaford.dart';
import 'package:bordado_company/src/widgets/validar_screen_available.dart';
import 'package:flutter/material.dart';

import '../../datebase/current_data.dart';
import 'dart:convert';

import 'package:flutter/services.dart';
import '../../folder_list_product/dialog_get_product.dart';
import '../../folder_list_product/model_product/product.dart';
import '../../model/orden.dart';

import '../../util/commo_pallete.dart';
import '../../util/get_formatted_number.dart';
import '../../util/helper.dart';
import '/src/datebase/methond.dart';
import '/src/folder_cliente_company/model_cliente/cliente.dart';
import '/src/nivel_2/folder_planificacion/model_planificacion/planificacion_last.dart';
import '../../datebase/url.dart';
import '../../folder_cliente_company/dialog_get_client.dart';
import '../../model/new_orden.dart';

class AddPreOrden extends StatefulWidget {
  const AddPreOrden({super.key});

  @override
  State createState() => _AddPreOrdenState();
}

class _AddPreOrdenState extends State<AddPreOrden> {
  List<PlanificacionLast> planificacionList = [];
  // Variables para almacenar los valores del formulario

  TextEditingController controllerLogo = TextEditingController();
  TextEditingController controllerFicha = TextEditingController();
  TextEditingController controllerNota = TextEditingController();
  Cliente? clientPicked;
  List<String> departments = [];

  //////////////////
  String? _dateCreated;
  String? _dateCreatedEntrega;
  String? _selectedPriority = 'Normal';

  void enviarPreOrden() {
    if (clientPicked == null ||
        controllerLogo.text.isEmpty ||
        controllerFicha.text.isEmpty) {
      return scaffoldMensaje(
          context: context, mjs: 'Faltan campos', background: Colors.red);
    }
    if (!validarFechas(_dateCreated!, _dateCreatedEntrega!)) {
      return scaffoldMensaje(
          context: context,
          mjs: 'Fecha de creacion incorrecta a la entrega',
          background: Colors.orange);
    }
    var jsonDataLocal = {
      "id_cliente": clientPicked!.idCliente,
      "estado_prioritario": _selectedPriority?.toUpperCase(),
      "estado_general": "pendiente".toUpperCase(),
      "name_logo": controllerLogo.text.trim().toUpperCase(),
      "ficha": controllerFicha.text.trim().toUpperCase(),
      "observaciones":
          controllerNota.text.isNotEmpty ? controllerNota.text : 'N/A',
      "fecha_creacion": _dateCreated,
      "fecha_entrega": _dateCreatedEntrega,
      "estado_entrega": "pendiente".toUpperCase(),
      "usuario_id": currentUsers!.id,
      "items": [
        {
          "id_producto": 4,
          "cant": 15,
          "detalles_productos": "TSHIRT ALGODON BOB CAB",
          "nota": "Prioridad máxima",
          "estado_produccion": "pendiente".toUpperCase(),
          "departamentos": [1, 2, 3]
        },
        {
          "id_producto": 5,
          "cant": 10,
          "detalles_productos": "CAMISA OXFORD TROPICAL HOMBRE",
          "nota": "Entregar con logo",
          "estado_produccion": "pendiente".toUpperCase(),
          "departamentos": [2, 4]
        }
      ]
    };

    print(jsonDataLocal);

    // if (_dateCreated == null || _dateCreatedEntrega == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     backgroundColor: Colors.red,
    //     content: Text('Seleccione las fechas'),
    //     duration: Duration(seconds: 2),
    //   ));
    //   return;
    // }

    // final orden = Orden(
    //   idCliente: int.parse(clientPicked?.idCliente ?? '0'),
    //   estadoPrioritario: _selectedPriority,
    //   estadoGeneral: null,
    //   nameLogo: controllerLogo.text,
    //   ficha: controllerFicha.text,
    //   observaciones: '',
    //   // fechaCreacion: _dateCreated,
    //   // fechaEntrega: _dateCreatedEntrega,
    //   estadoEntrega: 'pendiente',
    //   usuarioId: currentUsers?.id,
    //   items: [], // Los agregarás en la siguiente pantalla
    // );

    // // Abrir formulario para agregar hijos (OrdenItems)
    // // Navigator.push(
    // //   context,
    // //   MaterialPageRoute(
    // //     builder: (_) => AddContinuacionPlanOrden(
    // //       orden: orden,
    // //       isClienteInterno: isClientInterno,
    // //     ),
    // //   ),
    // // );
  }

  verificacionFichaVacia(context, NewOrden item) async {
    //select_validar_ficha_or_orden
    final res = await httpRequestDatabase(
      "http://$ipLocal/settingmat/admin/select/select_validar_ficha_or_orden.php",
      {
        'ficha': item.ficha,
        'num_orden': item.numOrden,
        'priority': item.priority
      },
    );

    var response = jsonDecode(res.body);
    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(response['message']),
          duration: const Duration(seconds: 1)));
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) =>
      //         AddContinuacionPlan(item: item, isClientInterno: isClientInterno),
      //   ),
      // );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(response['message']),
          duration: const Duration(seconds: 2)));
    }
  }

  void chooseClient() async {
    Cliente? client = await showDialog<Cliente>(
        context: context,
        builder: (context) {
          return const DialogGetClients();
        });
    if (client != null) {
      clientPicked = client;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    _dateCreated = DateTime.now().toString().substring(0, 10);
    _dateCreatedEntrega =
        DateTime.now().add(const Duration(days: 5)).toString().substring(0, 10);
  }

  Product? productPicked;
  List listDepartTemp = [];
  bool isReadytoAdd = false;
  void chooseProduct() async {
    Product? produto = await showDialog<Product>(
        context: context,
        builder: (context) {
          return const DialogGetProductos();
        });
    if (produto != null) {
      setState(() {
        listDepartTemp.clear();
        isReadytoAdd = false;
        // controllerCant.clear();
        productPicked = produto;
      });
    }
  }

  bool isContinuar = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const curve = Curves.elasticInOut;
    final style = Theme.of(context).textTheme;
    String textPlain =
        "-Bordados -Serigrafía -Sublimación -Vinil -Uniformes deportivos y empresariales -Promociones y Más";

    final formularioNormal = Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(width: double.infinity),
              SlideInLeft(
                curve: curve,
                child: Container(
                  width: 250,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: DropdownButtonHideUnderline(
                      // Elimina la línea del Dropdown
                      child: DropdownButton<String>(
                        value: _selectedPriority,
                        items: priorityList?.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Center(
                                child: Text(getClientePorPrioridad(
                                    category))), // Centrar el texto de cada ítem
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPriority = value.toString();
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SlideInLeft(
                curve: curve,
                child: Container(
                  color: Colors.white,
                  height: 50,
                  width: 250,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: TextButton.icon(
                    icon: const Icon(Icons.search, color: Colors.black),
                    label: Text(
                        clientPicked != null
                            ? clientPicked!.nombre.toString()
                            : 'Buscar Cliente',
                        style: const TextStyle(color: Colors.black)),
                    onPressed: chooseClient,
                  ),
                ),
              ),
              SlideInLeft(
                  curve: curve,
                  child: buildTextFieldValidator(
                      controller: controllerLogo,
                      hintText: 'Escribir Logo',
                      label: 'Logo')),
              SlideInRight(
                curve: curve,
                child: buildTextFieldValidator(
                  controller: controllerFicha,
                  hintText: 'Escribir Ficha',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*$')),
                  ],
                  label: 'Ficha',
                ),
              ),
              SlideInLeft(
                curve: curve,
                child: Container(
                  color: Colors.white,
                  height: 50,
                  width: 250,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: TextButton.icon(
                    icon: const Icon(Icons.date_range_outlined,
                        color: Colors.black),
                    label: Text(
                        _dateCreated == null
                            ? 'Fecha Inicio    '
                            : _dateCreated ?? 'No hay fecha',
                        style: const TextStyle(color: Colors.black)),
                    onPressed: () async {
                      await pickSingleDate(context, (fecha) {
                        setState(() {
                          _dateCreated = fecha.substring(0, 10);
                        });
                      });
                    },
                  ),
                ),
              ),
              SlideInRight(
                curve: curve,
                child: Container(
                  color: Colors.white,
                  height: 50,
                  width: 250,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: TextButton.icon(
                    icon: const Icon(Icons.date_range_outlined,
                        color: Colors.black),
                    label: Text(
                        _dateCreatedEntrega == null
                            ? 'Fecha Entrega'
                            : _dateCreatedEntrega ?? 'No hay fecha',
                        style: const TextStyle(color: Colors.black)),
                    onPressed: () async {
                      await pickSingleDate(context, (fecha) {
                        setState(() {
                          _dateCreatedEntrega = fecha.substring(0, 10);
                        });
                      });
                    },
                  ),
                ),
              ),
              CustomLoginButton(
                onPressed: () {
                  setState(() {
                    isContinuar = !isContinuar;
                  });
                },
                text: isContinuar ? 'Volver' : 'Continuar',
                colorButton: isContinuar ? Colors.orange : Colors.green,
                width: 150,
              ),
            ],
          ),
        ),
      ),
    );
    final continuarFormulario = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SlideInRight(
              curve: curve,
              child: Container(
                  color: Colors.white,
                  // height: 50,
                  width: 250,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: TextButton(
                        onPressed: chooseProduct,
                        child: Text(
                            productPicked != null
                                ? productPicked!.nameProducto.toString()
                                : 'Buscar productos',
                            style: style.bodySmall)),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        productPicked != null
                            ? Text(
                                '\$ ${getNumFormatedDouble(productPicked!.originalPrice.toString())}',
                                style: style.labelSmall?.copyWith(
                                    color: ktejidogrey.withValues(alpha: 0.5),
                                    fontSize: 12))
                            : const SizedBox(),
                        productPicked != null
                            ? Text(
                                '${getNumFormatedDouble(productPicked!.stock.toString())} Stock',
                                style: style.labelSmall?.copyWith(
                                    color:
                                        Product.validatorStock(productPicked!)
                                            ? colorsBlueTurquesa
                                            : colorsRed,
                                    fontSize: 8))
                            : const SizedBox(),
                      ],
                    ),
                  )),
            ),
            CustomLoginButton(
              onPressed: () {
                setState(() {
                  isContinuar = !isContinuar;
                });
              },
              text: isContinuar ? 'Volver' : 'Continuar',
              colorButton: isContinuar ? Colors.orange : Colors.green,
              width: 150,
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Crear Orden')),
      body: ValidarScreenAvailable(
        windows: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  isContinuar ? continuarFormulario : formularioNormal,
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Bounce(
                          curve: curve,
                          child: const Text('Nueva Orden !',
                              style: TextStyle(fontSize: 24, color: colorsAd)),
                        ),
                      ),
                      BounceInDown(
                          curve: curve,
                          child: Image.asset('assets/lista-de-tareas.png',
                              scale: 5)),
                      FadeIn(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: 200,
                            child: Text(textPlain,
                                textAlign: TextAlign.center,
                                style: style.bodySmall
                                    ?.copyWith(color: Colors.grey)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      customButton(
                          onPressed: () => enviarPreOrden(),
                          width: 250,
                          colorText: Colors.white,
                          colors: colorsAd,
                          textButton: 'Revisar'),
                    ],
                  )),
                ],
              ),
            ),
            identy(context)
          ],
        ),
      ),
    );
  }
}
