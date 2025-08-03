import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../model/orden.dart';
import '../../model/orden_item.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/folder_cliente_company/model_cliente/cliente.dart';
import '/src/nivel_2/folder_planificacion/model_planificacion/planificacion_last.dart';
import '/src/util/commo_pallete.dart';
import '../../datebase/url.dart';
import '../../folder_cliente_company/dialog_get_client.dart';
import '../../model/new_orden.dart';
import '../../util/helper.dart';
import '../../widgets/validar_screen_available.dart';
import 'add_continuacion_planificacion.dart';

class AddPlanificacionForm extends StatefulWidget {
  const AddPlanificacionForm({super.key});

  @override
  State<AddPlanificacionForm> createState() => _AddPlanificacionFormState();
}

class _AddPlanificacionFormState extends State<AddPlanificacionForm> {
  List<PlanificacionLast> planificacionList = [];
  // Variables para almacenar los valores del formulario

  TextEditingController controllerLogo = TextEditingController();
  TextEditingController controllerNumOrden = TextEditingController();
  TextEditingController controllerFicha = TextEditingController();
  Cliente? clientPicked;
  bool isClientInterno = false;
  List<String> departments = [];
  //////////////////
  DateTime? _dateCreated;

  DateTime? _dateCreatedEntrega;

  String? _selectedPriority = 'Normal';

  void methondSend() {
    if (_dateCreated == null || _dateCreatedEntrega == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Seleccione las fechas'),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    final orden = Orden(
      idCliente: int.parse(clientPicked?.idCliente ?? '0'),
      estadoPrioritario: _selectedPriority,
      estadoGeneral: null,
      nameLogo: isClientInterno ? 'N/A' : controllerLogo.text,
      numOrden: isClientInterno ? '0' : controllerNumOrden.text,
      ficha: controllerFicha.text,
      observaciones: '',
      fechaCreacion: _dateCreated,
      fechaEntrega: _dateCreatedEntrega,
      estadoEntrega: 'pendiente',
      usuarioId: currentUsers?.id,
      items: [], // Los agregarás en la siguiente pantalla
    );



    // Abrir formulario para agregar hijos (OrdenItems)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddContinuacionPlanOrden(
          orden: orden,
          isClienteInterno: isClientInterno,
        ),
      ),
    );
  }

  // void methondSend() {
  //   if (isClientInterno) {
  //     controllerNumOrden.text = '0';
  //     controllerLogo.text = 'N/A';
  //     clientPicked = Cliente(
  //       nombre: 'Tejidos'.toUpperCase(),
  //       apellido: 'Tropical'.toUpperCase(),
  //       telefono: '829-291-6505',
  //     );

  //     if (controllerFicha.text.isNotEmpty &&
  //         _dateCreated != null &&
  //         _dateCreatedEntrega != null &&
  //         clientPicked != null) {
  //       Random num = Random();

  //       NewOrden nuevaOrden = NewOrden.fromData(
  //         currentUsersFullName: currentUsers?.fullName,
  //         clientApellido: clientPicked?.apellido,
  //         clientNombre: clientPicked?.nombre,
  //         clientTelefono: clientPicked?.telefono,
  //         numOrdenText: '0',
  //         nameLogoText: 'N/A',
  //         fichaText: controllerFicha.text,
  //         fechaStartText: _dateCreated.toString().substring(0, 10),
  //         fechaEntregaText: _dateCreatedEntrega.toString().substring(0, 10),
  //         uniqueKeyProduct: num.nextInt(999999999).toString(),
  //         priority: _selectedPriority!,
  //       );
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => AddContinuacionPlan(
  //                 item: nuevaOrden, isClientInterno: isClientInterno)),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //           backgroundColor: Colors.red,
  //           content: Text('Llene todos los campos'),
  //           duration: Duration(seconds: 2)));
  //     }
  //   } else {
  //     if (controllerLogo.text.isNotEmpty &&
  //         controllerNumOrden.text.isNotEmpty &&
  //         controllerFicha.text.isNotEmpty &&
  //         clientPicked != null &&
  //         _dateCreated != null &&
  //         _dateCreatedEntrega != null) {
  //       Random num = Random();

  //       NewOrden nuevaOrden = NewOrden.fromData(
  //         currentUsersFullName: currentUsers?.fullName,
  //         clientApellido: clientPicked?.apellido,
  //         clientNombre: clientPicked?.nombre,
  //         clientTelefono: clientPicked?.telefono,
  //         numOrdenText: controllerNumOrden.text,
  //         nameLogoText: controllerLogo.text,
  //         fichaText: controllerFicha.text,
  //         fechaStartText: _dateCreated.toString().substring(0, 10),
  //         fechaEntregaText: _dateCreatedEntrega.toString().substring(0, 10),
  //         uniqueKeyProduct: num.nextInt(999999999).toString(),
  //         priority: _selectedPriority!,
  //       );

  //       verificacionFichaVacia(context, nuevaOrden);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //           backgroundColor: Colors.red,
  //           content: Text('Llene todos los campos'),
  //           duration: Duration(seconds: 2)));
  //     }
  //   }
  // }

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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AddContinuacionPlan(item: item, isClientInterno: isClientInterno),
        ),
      );
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const curve = Curves.elasticInOut;
    final style = Theme.of(context).textTheme;
    String textPlain =
        "-Bordados -Serigrafía -Sublimación -Vinil -Uniformes deportivos y empresariales -Promociones y Más";
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Orden')),
      body: ValidarScreenAvailable(
        windows: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
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
                                  icon: const Icon(Icons.search,
                                      color: Colors.black),
                                  label: Text(
                                      clientPicked != null
                                          ? clientPicked!.nombre.toString()
                                          : 'Buscar Cliente',
                                      style:
                                          const TextStyle(color: Colors.black)),
                                  onPressed: chooseClient,
                                ),
                              ),
                            ),
                            SlideInLeft(
                              curve: curve,
                              child: Container(
                                color: Colors.white,
                                height: 50,
                                width: 250,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: isClientInterno,
                                      onChanged: (value) {
                                        setState(() {
                                          isClientInterno = value!;
                                          clientPicked = Cliente(
                                            nombre: 'Tejidos'.toUpperCase(),
                                            apellido: 'Tropical'.toUpperCase(),
                                            telefono: '829-291-6505',
                                          );
                                          if (!isClientInterno) {
                                            controllerNumOrden.text = '';
                                            controllerLogo.text = '';
                                            clientPicked = null;
                                          }
                                        });
                                      },
                                    ),
                                    const Text('Cliente Interno'),
                                  ],
                                ),
                              ),
                            ),
                            if (!isClientInterno)
                              SlideInLeft(
                                curve: curve,
                                child: buildTextFieldValidator(
                                  controller: controllerNumOrden,
                                  hintText: 'Escribir Numero Orden',
                                  label: 'Numero Orden',
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^[1-9]\d*$')),
                                  ],
                                ),
                              ),
                            if (!isClientInterno)
                              SlideInRight(
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
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^[1-9]\d*$')),
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
                                          : '${_dateCreated!.day}/${_dateCreated!.month}/${_dateCreated!.year}',
                                      style:
                                          const TextStyle(color: Colors.black)),
                                  onPressed: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1995),
                                      lastDate: DateTime(2300),
                                    );
                                    setState(() {
                                      _dateCreated = date;
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
                                          : '${_dateCreatedEntrega!.day}/${_dateCreatedEntrega!.month}/${_dateCreatedEntrega!.year}',
                                      style:
                                          const TextStyle(color: Colors.black)),
                                  onPressed: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1995),
                                      lastDate: DateTime(2300),
                                    );
                                    setState(() {
                                      _dateCreatedEntrega = date;
                                      // DateTime? _dateEntrega;
                                      // DateTime? _dateCreatedEntrega;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                          onPressed: () => methondSend(),
                          width: 250,
                          colorText: Colors.white,
                          colors: colorsAd,
                          textButton: 'Comenzar'),
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

class AddContinuacionPlanOrden extends StatefulWidget {
  final Orden orden;
  final bool isClienteInterno;

  const AddContinuacionPlanOrden({
    super.key,
    required this.orden,
    required this.isClienteInterno,
  });

  @override
  State<AddContinuacionPlanOrden> createState() =>
      _AddContinuacionPlanOrdenState();
}

class _AddContinuacionPlanOrdenState extends State<AddContinuacionPlanOrden> {
  final List<OrdenItem> _ordenItems = [];

  void agregarItem(OrdenItem item) {
    setState(() {
      _ordenItems.add(item);
    });
  }

  void enviarOrden() async {
    final ordenFinal = widget.orden..items = _ordenItems;

    final response = await httpRequestDatabase(
      'http://$ipLocal/api/crear_orden.php',
      ordenFinal.toJson(),
    );

    if (jsonDecode(response.body)['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Orden creada correctamente'),
          duration: Duration(seconds: 2)));

      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error al crear orden'),
          duration: Duration(seconds: 2)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Productos a la Orden')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _ordenItems.length,
              itemBuilder: (_, index) {
                final item = _ordenItems[index];
                return ListTile(
                  title:
                      Text('Producto: ${item.idProducto} - Cant: ${item.cant}'),
                  subtitle: Text(item.nota ?? ''),
                );
              },
            ),
          ),
          customButton(
            onPressed: enviarOrden,
            textButton: 'Guardar Orden',
            colors: Colors.green,
            width: 250,
            colorText: Colors.white,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // final item = await showDialog<OrdenItem>(
          //   context: context,
          //   builder: (_) => DialogAgregarItem(),
          // );
          // if (item != null) agregarItem(item);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
