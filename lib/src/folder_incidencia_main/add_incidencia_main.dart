import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/src/datebase/current_data.dart';
import '/src/home.dart';
import '/src/model/users.dart';
import '/src/util/commo_pallete.dart';
import '../datebase/methond.dart';
import '../datebase/url.dart';
import '../folder_admin_permiso/dialog_list_usuario.dart';
import '../model/department.dart';
import '../nivel_2/folder_insidensia/pages_insidencia.dart/selected_department.dart';
import '../util/helper.dart';
import '../widgets/loading.dart';
import 'add_product_incidencia.dart';

class AddIncidenciaMain extends StatefulWidget {
  const AddIncidenciaMain({super.key});

  @override
  State<AddIncidenciaMain> createState() => _AddIncidenciaMainState();
}

class _AddIncidenciaMainState extends State<AddIncidenciaMain> {
  Department? pickedDepart;
  bool isLoading = false;
  TextEditingController controllerLogo = TextEditingController();
  TextEditingController controllerNumOrden = TextEditingController();
  TextEditingController controllerFicha = TextEditingController();
  TextEditingController controllerQuePaso = TextEditingController();
  TextEditingController controllerCompromiso = TextEditingController();
  List<String> categoriesQuejas = ['Externa', 'Interna', 'Sin Definir'];
  String? _selectedCategory = 'Interna';
  List<ProductoIncidencia> listProduct = [];
  List<Users> listUsuario = [];
  List<Department> listDepartResponsable = [];
// ficha, num_orden, logo, ubicacion_queja, department_find,
//     what_happed, compromiso, estado, registed_by

  Future addIncidenciaCompleta(context) async {
    if (pickedDepart == null) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error falta el origen de la incidencia'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (controllerLogo.text.isEmpty ||
        controllerNumOrden.text.isEmpty ||
        controllerFicha.text.isEmpty ||
        controllerQuePaso.text.isEmpty ||
        controllerCompromiso.text.isEmpty) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Formulario incompleto'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.orange,
        ),
      );
    }
    if (listProduct.isEmpty) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lista de producto vacio'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.red,
        ),
      );
    }
    if (listUsuario.isEmpty) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lista de empleado vacio'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.brown,
        ),
      );
    }
    if (listDepartResponsable.isEmpty) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lista departamentos responsables vacio'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.orange,
        ),
      );
    }

    setState(() {
      isLoading = !isLoading;
    });
    var data = {
      'ficha': controllerFicha.text,
      'num_orden': controllerNumOrden.text,
      'logo': controllerLogo.text,
      'ubicacion_queja': _selectedCategory,
      'department_find': pickedDepart!.nameDepartment!,
      'what_happed': controllerQuePaso.text,
      'compromiso': controllerCompromiso.text,
      'estado': 'no resuelto',
      'registed_by': currentUsers?.fullName,
      'list_depart_responsable': listDepartResponsable
          .map((e) => {'department_responsable': e.nameDepartment ?? 'N/A'})
          .toList(),
      'list_producto': listProduct
          .map((e) => {
                'name_product': e.nameProducto,
                'cant': e.cantidad ?? '0.0',
                'costo': e.costo ?? '0.0'
              })
          .toList(),
      'list_usuario': listUsuario
          .map((e) => {'full_name': e.fullName, 'code': e.code ?? '0.0'})
          .toList(),
    };
    print(data);
    //insert_file_incidencia_completa
    final res = await httpEnviaMap(
        'http://$ipLocal/settingmat/admin/insert/insert_file_incidencia_completa.php',
        jsonEncode(data));
    // print(res);
    final response = jsonDecode(res);
    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['message']),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.green,
      ));
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        isLoading = !isLoading;
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (conext) => const MyHomePage()),
          (route) => false);
    } else {
      setState(() {
        isLoading = !isLoading;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['message']),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    const curve = Curves.elasticInOut;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add nueva incidencia'),
      ),
      body: isLoading
          ? const Loading(isLoading: true, text: 'Enviando al servidor')
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(width: double.infinity),
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
                            pickedDepart != null
                                ? pickedDepart!.nameDepartment.toString()
                                : 'Donde se encontró?',
                            style: const TextStyle(color: Colors.black)),
                        onPressed: chooseDepart,
                      ),
                    ),
                  ),
                  SlideInRight(
                    curve: curve,
                    child: buildTextFieldValidator(
                      controller: controllerLogo,
                      hintText: 'Escribir Logo',
                      label: 'Logo',
                    ),
                  ),
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
                        ]),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text('Ubicación Queja : '),
                          DropdownButton<String>(
                            value: _selectedCategory,
                            items: categoriesQuejas.map((category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value.toString();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SlideInRight(
                    curve: curve,
                    child: buildTextFieldValidator(
                      controller: controllerQuePaso,
                      hintText: 'Escribir Que paso? *',
                      label: 'Que Paso ? *',
                    ),
                  ),
                  SlideInLeft(
                    curve: curve,
                    child: buildTextFieldValidator(
                      controller: controllerCompromiso,
                      hintText: 'Escribir Compromiso *',
                      label: 'Cual es que compromiso ?*',
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
                        icon: const Icon(Icons.search, color: Colors.black),
                        label: Text(
                            listDepartResponsable.isNotEmpty
                                ? '${listDepartResponsable.length.toString()} Involucrados'
                                : 'Involucrar departamentos ?',
                            style: const TextStyle(color: Colors.black)),
                        onPressed: chooseDepartReponsables,
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
                            listUsuario.isNotEmpty
                                ? '${listUsuario.length.toString()} Involucrados'
                                : 'Involucrar Empleados ?',
                            style: const TextStyle(color: Colors.black)),
                        onPressed: chooseUsuario,
                      ),
                    ),
                  ),
                  customButton(
                      onPressed: () => addProductoDialog(),
                      width: 250,
                      colorText: Colors.white,
                      colors: colorsOrange,
                      textButton: 'Agregar Articulo'),
                  const SizedBox(height: 15),
                  listProduct.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DataTable(
                            dataRowMaxHeight: 20,
                            dataRowMinHeight: 15,
                            horizontalMargin: 10.0,
                            columnSpacing: 15,
                            headingRowHeight: 20,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 245, 212, 158)),
                            headingTextStyle: const TextStyle(
                                color: colorsAd, fontWeight: FontWeight.bold),
                            border: TableBorder.symmetric(
                                outside: BorderSide(
                                    color: Colors.grey.shade100,
                                    style: BorderStyle.none),
                                inside: const BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.grey)),
                            columns: const [
                              DataColumn(label: Text('Producto')),
                              DataColumn(label: Text('Cantidad')),
                              DataColumn(label: Text('Costo')),
                              DataColumn(label: Text('Quitar')),
                            ],
                            rows: listProduct.asMap().entries.map((entry) {
                              int index = entry.key;
                              var report = entry.value;
                              return DataRow(
                                color: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    // Alterna el color de fondo entre gris y blanco
                                    if (index.isOdd) {
                                      return Colors.grey
                                          .shade300; // Color de fondo gris para filas impares
                                    }
                                    return Colors
                                        .white; // Color de fondo blanco para filas pares
                                  },
                                ),
                                cells: [
                                  DataCell(Text(report.nameProducto ?? 'N/A')),
                                  DataCell(Text(report.cantidad ?? 'N/A')),
                                  DataCell(Text(report.costo ?? 'N/A')),
                                  DataCell(const Text('Quitar'), onTap: () {
                                    setState(() {
                                      listProduct.remove(report);
                                    });
                                  }),
                                ],
                              );
                            }).toList(),
                          ),
                        )
                      : const SizedBox(),
                  BounceInDown(
                    curve: curve,
                    child: customButton(
                      onPressed: () => addIncidenciaCompleta(context),
                      width: 250,
                      colorText: Colors.white,
                      colors: colorsAd,
                      textButton: 'Enviar',
                    ),
                  ),
                  identy(context),
                ],
              ),
            ),
    );
  }

  chooseDepart() async {
    // await showDialog(
    //     context: context,
    //     builder: (context) {
    //       return SelectedDepartments(
    //         pressDepartment: (val) {
    //           setState(() {
    //             pickedDepart = Department(
    //               nameDepartment: val[0],
    //             );
    //           });
    //         },
    //       );
    //     });
  }

  chooseDepartReponsables() async {
    // await showDialog(
    //     context: context,
    //     builder: (context) {
    //       return SelectedDepartments(
    //         pressDepartment: (val) {
    //           listDepartResponsable.clear();
    //           for (var element in val) {
    //             listDepartResponsable.add(Department(nameDepartment: element));
    //           }
    //           setState(() {});
    //         },
    //       );
    //     });
  }

  chooseUsuario() async {
    listUsuario.clear();
    List<Users>? listPicked = await showDialog<List<Users>>(
        context: context,
        builder: (context) {
          return const DialogListUsuario();
        });
    if (listPicked != null) {
      for (var element in listPicked) {
        listUsuario.add(element);
      }
    }
    setState(() {});
  }

  addProductoDialog() async {
    final product = await showDialog(
        context: context,
        builder: ((context) {
          return const AddProductIncidencia();
        }));

    if (product != null) {
      listProduct.add(ProductoIncidencia(
          cantidad: product['cant'],
          nameProducto: product['product'],
          costo: product['costo']));
      setState(() {});
    }
  }
}

class ProductoIncidencia {
  String? nameProducto;
  String? cantidad;
  String? costo;

  ProductoIncidencia({
    this.nameProducto,
    this.cantidad,
    this.costo,
  });
}
