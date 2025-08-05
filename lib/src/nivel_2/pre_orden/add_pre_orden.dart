import 'package:animate_do/animate_do.dart';
import 'package:bordado_company/src/model/department.dart';
import 'package:bordado_company/src/widgets/loading.dart';
import 'package:bordado_company/src/widgets/mensaje_scaford.dart';
import 'package:bordado_company/src/widgets/validar_screen_available.dart';
import 'package:flutter/material.dart';
import '../../datebase/current_data.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../folder_list_product/dialog_get_product.dart';
import '../../folder_list_product/model_product/product.dart';
import '../../services/api_services.dart';
import '../../util/commo_pallete.dart';
import '../../util/get_formatted_number.dart';
import '../../util/helper.dart';
import '../folder_insidensia/pages_insidencia.dart/selected_department.dart';
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

  ///////controller del producto

  TextEditingController controllerCantidad = TextEditingController();
  TextEditingController controllerNotaOpcional = TextEditingController();
  TextEditingController controllerDetalles = TextEditingController();
  TextEditingController controllerDepartamentos = TextEditingController();
  final ApiService _api = ApiService();
  Cliente? clientPicked;
  List<Department> listDepartTemp = [];

  List<ItemProd> listItemsTemp = [];

  //////////////////
  String? _dateCreated;
  String? _dateCreatedEntrega;
  String? _selectedPriority = 'NORMAL';
  Map<String, Object?>? jsonDataLocal;
  bool _loading = false;
  void enviarPreOrden() async {
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
    setState(() {
      _loading = !_loading;
    });
    jsonDataLocal = {
      "id_cliente": clientPicked!.idCliente,
      "estado_prioritario": _selectedPriority?.toUpperCase(),
      "estado_general": estadoHojaList[0],
      "name_logo": controllerLogo.text.trim().toUpperCase(),
      "ficha": controllerFicha.text.trim().toUpperCase(),
      "observaciones":
          controllerNota.text.isNotEmpty ? controllerNota.text : 'N/A',
      "fecha_creacion": _dateCreated,
      "fecha_entrega": _dateCreatedEntrega,
      "estado_entrega": estadoHojaList[0],
      "usuario_id": currentUsers!.id,
      "items": listItemsTemp.map((e) => e.toJson()).toList(),
    };

    print(jsonDataLocal);
    //add_pre_orden

    final res = await _api.httpEnviaMap(
        'http://$ipLocal/$pathLocal/pre_orden/add_pre_orden.php',
        jsonDataLocal);

    final value = json.decode(res);

    scaffoldMensaje(
        mjs: value['message'].toString(),
        background: value['success'] ? Colors.green : Colors.red,
        context: context);
    setState(() {
      _loading = !_loading;
    });
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

  void chooseProduct() async {
    Product? produto = await showDialog<Product>(
        context: context,
        builder: (context) {
          return const DialogGetProductos();
        });
    if (produto != null) {
      setState(() {
        productPicked = produto;
        controllerDetalles.text = productPicked!.nameProducto!.toUpperCase();
        listDepartTemp.clear();
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
                              child: Center(child: Text(category)));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPriority = value.toString();
                            print(_selectedPriority);
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
                    label: 'Logo'),
              ),
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
            // const SizedBox(width: double.infinity),
            SlideInRight(
              curve: curve,
              child: Container(
                  color: Colors.white,
                  height: 50,
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
            if (productPicked != null)
              Column(
                children: [
                  buildTextFieldValidator(
                      controller: controllerCantidad,
                      hintText: 'Cantidad de Producto',
                      label: 'Cantidad'),
                  buildTextFieldValidator(
                      controller: controllerDetalles,
                      hintText: 'Detalles Productos',
                      label: 'Detalles Productos'),
                  buildTextFieldValidator(
                      controller: controllerNotaOpcional,
                      hintText: 'Nota (Opcional)',
                      label: 'Nota (Opcional)'),
                  customButton(
                      onPressed: () {
                        elegirDepartmento();
                        // controllerDepartamentos.text
                      },
                      textButton: 'Elegir Departamentos',
                      colors: colorsPuppleOpaco),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                        onPressed: () {
                          try {
                            if (productPicked == null ||
                                controllerCantidad.text.isEmpty ||
                                listDepartTemp.isEmpty) {
                              scaffoldMensaje(
                                context: context,
                                mjs:
                                    'Producto y cantidad y departamentos son requeridos',
                                background: Colors.red,
                              );
                              return;
                            }

                            final item = ItemProd(
                              cant: int.parse(controllerCantidad.text),
                              precioFinal: double.parse(
                                      productPicked!.originalPrice ?? '0')
                                  .toStringAsFixed(2),
                              departamentos: listDepartTemp
                                  .map((e) => int.tryParse(e.id ?? '') ?? 0)
                                  .where((id) => id > 0)
                                  .toSet()
                                  .toList(),
                              detallesProductos:
                                  controllerDetalles.text.trim().toUpperCase(),
                              estadoProduccion: estadoHojaList[0],
                              idProducto: int.parse(
                                  productPicked!.idProducto.toString()),
                              nota: controllerNotaOpcional.text.trim().isEmpty
                                  ? 'N/A'
                                  : controllerNotaOpcional.text.trim(),
                            );

                            setState(() {
                              listItemsTemp.add(item);

                              // Limpiar campos
                              controllerCantidad.clear();
                              controllerDetalles.clear();
                              controllerNotaOpcional.clear();
                              listDepartTemp.clear();
                              productPicked = null;
                            });

                            scaffoldMensaje(
                              context: context,
                              mjs: 'Producto agregado',
                              background: Colors.green,
                            );
                          } catch (e) {
                            scaffoldMensaje(
                              context: context,
                              mjs: 'Error al agregar producto',
                              background: Colors.red,
                            );
                          }
                        },
                        child: Text('Agregar Producto')),
                  ),
                ],
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
      body: _loading
          ? LoadingNew(
              imagen: 'assets/logo_lu.png',
              scale: 5,
              text: 'Registrando, Espere Por Favor..',
            )
          : ValidarScreenAvailable(
              windows: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        isContinuar ? continuarFormulario : formularioNormal,
                        listItemsTemp.isNotEmpty
                            ? Expanded(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    children: [
                                      BounceInDown(
                                          curve: curve,
                                          child: Image.asset(
                                              'assets/facturacion_electronica.png',
                                              scale: 5)),
                                      DataTable(
                                        dataRowMaxHeight: 35,
                                        dataRowMinHeight: 30,
                                        horizontalMargin: 12,
                                        columnSpacing: 16,
                                        headingRowHeight: 40,
                                        decoration: const BoxDecoration(
                                            color: Colors.teal), // Usa tu color
                                        headingTextStyle: const TextStyle(
                                            color: Colors.white),
                                        border: TableBorder.symmetric(
                                          inside: const BorderSide(
                                            color: Colors.grey,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        columns: const [
                                          DataColumn(label: Text('Quitar')),
                                          DataColumn(label: Text('Nombre')),
                                          DataColumn(
                                              label: Text('Descripción')),
                                          DataColumn(label: Text('Nota')),
                                          DataColumn(label: Text('Estado')),
                                          DataColumn(
                                              label: Text('Departamentos')),
                                        ],
                                        rows: listItemsTemp
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int index = entry.key;
                                          ItemProd prod = entry.value;

                                          return DataRow(
                                            color: WidgetStateProperty
                                                .resolveWith<Color>(
                                              (Set<WidgetState> states) {
                                                return index.isOdd
                                                    ? Colors.grey.shade300
                                                    : Colors.white;
                                              },
                                            ),
                                            cells: [
                                              DataCell(Text('Quitar'),
                                                  onTap: () {
                                                setState(() {
                                                  listItemsTemp.remove(prod);
                                                });
                                              }),
                                              DataCell(Tooltip(
                                                  message: prod
                                                      .detallesProductos
                                                      .toUpperCase(),
                                                  child: Text(limitarTexto(
                                                      prod.detallesProductos,
                                                      30)))),
                                              DataCell(
                                                  Text(prod.cant.toString())),
                                              DataCell(Tooltip(
                                                  message:
                                                      prod.nota.toUpperCase(),
                                                  child: Text(limitarTexto(
                                                      prod.nota, 25)))),
                                              DataCell(
                                                  Text(prod.estadoProduccion)),
                                              DataCell(Text(prod
                                                  .departamentos.length
                                                  .toString())),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                      FadeIn(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: SizedBox(
                                            width: 200,
                                            child: Text(textPlain,
                                                textAlign: TextAlign.center,
                                                style: style.bodySmall
                                                    ?.copyWith(
                                                        color: Colors.grey)),
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
                                  ),
                                ),
                              )
                            : Expanded(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: Bounce(
                                      curve: curve,
                                      child: const Text('Nueva Orden !',
                                          style: TextStyle(
                                              fontSize: 24, color: colorsAd)),
                                    ),
                                  ),
                                  BounceInDown(
                                      curve: curve,
                                      child: Image.asset(
                                          'assets/lista-de-tareas.png',
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

  void elegirDepartmento() async {
    await showDialog(
        context: context,
        builder: (context) {
          return SelectedDepartments(
            pressDepartment: (val) {
              setState(() {
                listDepartTemp = val;
                print(listDepartTemp);
              });
            },
          );
        });
  }
}

class ItemProd {
  final int idProducto;
  final int cant;
  final String detallesProductos;
  final String nota;
  final String estadoProduccion;
  final String? precioFinal;
  final List<int> departamentos;

  ItemProd({
    required this.idProducto,
    required this.cant,
    required this.detallesProductos,
    required this.nota,
    required this.estadoProduccion,
    required this.departamentos,
    required this.precioFinal,
  });

  // Para crear una instancia desde un JSON
  factory ItemProd.fromJson(Map<String, dynamic> json) {
    return ItemProd(
      idProducto: json['id_producto'],
      cant: json['cant'],
      detallesProductos: json['detalles_productos'],
      nota: json['nota'],
      estadoProduccion: json['estado_produccion'],
      precioFinal: json['precio_final'],
      departamentos: List<int>.from(json['departamentos']),
    );
  }

  // Para convertir la clase a JSON
  Map<String, dynamic> toJson() {
    return {
      'id_producto': idProducto,
      'cant': cant,
      'detalles_productos': detallesProductos,
      'nota': nota,
      'estado_produccion': estadoProduccion,
      'departamentos': departamentos,
      'precio_final': precioFinal,
    };
  }
}
