import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/src/datebase/current_data.dart';
import '/src/folder_list_product/model_product/producto_new.dart';
import '/src/folder_productos_new/modelo/produc.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/helper.dart';
import '/src/util/show_mesenger.dart';
import '../datebase/url.dart';
import 'general_data.dart';
import 'menu_custom.dart';
import 'producto_services_general/servicios_general_producto.dart';

class AddProductoNew extends StatefulWidget {
  const AddProductoNew({super.key});

  @override
  State createState() => _AddProductoNewState();
}

class _AddProductoNewState extends State<AddProductoNew> {
  GeneralData? dataGenera;
  late Talla selectedTalla;
  late ColorModel selectedColor;
  late Marca selectedMarca;
  late LineaProducto selectedLineaProduct;
  late MaterialModel selectedMaterial;

  late SubCategoria selectedCategoria;
  final ServiciosGeneralProducto _servicesProduct = ServiciosGeneralProducto();

  List<Produc> _listProd = [];

  final TextEditingController _precioMayoristaController =
      TextEditingController();
  final TextEditingController _precioOfertaController = TextEditingController();
  final TextEditingController _precioVentaController = TextEditingController();
  final TextEditingController _secuenciaNumController = TextEditingController();
  final TextEditingController _cantidadController =
      TextEditingController(text: '1'); // valor por defecto

  bool validatorForm() {
    return _isValidNumber(_precioMayoristaController.text) &&
        _isValidNumber(_precioOfertaController.text) &&
        _isValidNumber(_precioVentaController.text) &&
        _isValidNumber(_cantidadController.text);
  }

  bool _isValidNumber(String value) {
    return double.tryParse(value) != null;
  }

  Future fetchGeneralData() async {
    final url = Uri.parse(
        'http://$ipLocal/settingmat/admin/select/get_data_general.php');
    final response = await http.post(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['success']) {
        dataGenera = GeneralData.fromJson(jsonData);

        // Asignar a variables de instancia (sin "var" ni "Talla", etc)
        selectedTalla = dataGenera!.tallas.first;
        selectedColor = dataGenera!.colores.first;
        selectedMarca = dataGenera!.marcas.first;
        selectedMaterial = dataGenera!.materiales.first;
        selectedLineaProduct = dataGenera!.lineaProduct!.first;
        selectedCategoria = dataGenera!.subCategoria!.first;
        setState(() {});
      } else {
        throw Exception('Error en la respuesta de la API');
      }
    } else {
      throw Exception('Error en la conexión con la API');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchGeneralData();
  }

  @override
  void dispose() {
    _precioMayoristaController.dispose();
    _precioOfertaController.dispose();
    _precioVentaController.dispose();
    _secuenciaNumController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  Produc? prod;
  void saveProducto() {
    final precioMayorista =
        double.tryParse(_precioMayoristaController.text) ?? 0.0;
    final precioOferta = double.tryParse(_precioOfertaController.text) ?? 0.0;
    final precioVenta = double.tryParse(_precioVentaController.text) ?? 0.0;
    final secuenciaNum = _secuenciaNumController.text.toUpperCase();
    final cantidad = int.tryParse(_cantidadController.text) ?? 1;
    String descripcion =
        '${selectedLineaProduct.nameProducto} ${selectedMaterial.nameMaterial} ${selectedMarca.nameMarca} ${selectedCategoria.name}';
    bool value = validatorForm();
    if (value) {
      setState(() {
        prod = Produc(
          tallaId: selectedTalla.tallaId,
          colorId: selectedColor.colorId,
          marcaId: selectedMarca.marcaId,
          lineaProductoId: selectedLineaProduct.lineaProductoId,
          materialId: selectedMaterial.materialId,
          descripcion: descripcion,
          subCategoriaId: selectedCategoria.id,
          precioMayorista: precioMayorista,
          precioOferta: precioOferta,
          precioVenta: precioVenta,
          secuenciaNum: secuenciaNum.toUpperCase(),
          cantidad: cantidad,
          productoId: '00',
          colores: [],
          tallas: [],
        );
      });
    } else {
      showScaffoldMessenger(context, 'message', Colors.red);
    }

    // bool value = validatorForm();
    // if (value) {
    //   print(prod?.toJson());
    //   setState(() {
    //     _secuenciaNumController.clear();
    //   });
    //   // _servicesProduct.addNewProducto(prod);
    // } else {
    //   showScaffoldMessenger(context, 'message', Colors.red);
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (dataGenera == null) {
      // Datos aún no cargados
      return Scaffold(
        appBar: AppBar(title: const Text('Agregar Producto')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Producto')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: prod == null
            ? Column(
                children: [
                  const SizedBox(width: double.infinity),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SelectableItem<LineaProducto>(
                        width: 200,
                        selectedItem: selectedLineaProduct,
                        items: dataGenera!.lineaProduct!,
                        getLabel: (t) => t.nameProducto!,
                        getColor: (t) => Colors.red,
                        onChanged: (t) {
                          setState(() {
                            selectedLineaProduct = t;
                          });
                        },
                      ),
                      IconButton(
                        onPressed: () => _pedirLineaProducto(context),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SelectableItem<MaterialModel>(
                        width: 200,
                        selectedItem: selectedMaterial,
                        items: dataGenera!.materiales,
                        getLabel: (m) => m.nameMaterial,
                        getColor: (m) => Colors.orange,
                        onChanged: (m) {
                          setState(() {
                            selectedMaterial = m;
                          });
                        },
                      ),
                      IconButton(
                        onPressed: () => _pedirMaterial(context),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SelectableItem<Marca>(
                        width: 200,
                        selectedItem: selectedMarca,
                        items: dataGenera!.marcas,
                        getLabel: (m) => m.nameMarca,
                        getColor: (m) => Colors.green,
                        onChanged: (m) {
                          setState(() {
                            selectedMarca = m;
                          });
                        },
                      ),
                      IconButton(
                        onPressed: () => _pedirMarca(context),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SelectableItem<SubCategoria>(
                        width: 200,
                        selectedItem: selectedCategoria,
                        items: dataGenera!.subCategoria!,
                        getLabel: (t) => t.name,
                        getColor: (t) => Colors.brown,
                        onChanged: (t) {
                          setState(() {
                            selectedCategoria = t;
                          });
                        },
                      ),
                      IconButton(
                        onPressed: () => _pedirCategoria(context),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  buildTextFieldValidator(
                    width: 237,
                    controller: _precioVentaController,
                    hintText: 'Escribir Precio Venta',
                    label: 'Precio Venta *',
                  ),
                  buildTextFieldValidator(
                    width: 237,
                    controller: _precioMayoristaController,
                    hintText: 'Escribir Precio Mayorista',
                    label: 'Precio Mayorista *',
                  ),
                  buildTextFieldValidator(
                    width: 237,
                    controller: _precioOfertaController,
                    hintText: 'Escribir Precio Oferta',
                    label: 'Precio Oferta *',
                  ),
                  buildTextFieldValidator(
                    width: 237,
                    controller: _cantidadController,
                    hintText: 'Cantidad',
                    label: 'Cantidad *',
                  ),
                  const SizedBox(height: 20),
                  customButton(
                    width: 237,
                    onPressed: saveProducto,
                    textButton: 'Continuar',
                    colorText: Colors.white,
                    colors: colorsGreenTablas,
                  ),
                  identy(context)
                ],
              )
            : Column(
                children: [
                  Text(prod.toString()),
                  buildTextFieldValidator(
                    width: 237,
                    controller: _secuenciaNumController,
                    hintText: 'Escribir Secuencia',
                    label: 'Secuencia Num *',
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SelectableItem<ColorModel>(
                        width: 200,
                        selectedItem: selectedColor,
                        items: dataGenera!.colores,
                        getLabel: (c) => c.nombreColor,
                        getColor: (c) => Color(
                            int.parse(c.hexCode.replaceFirst('#', '0xff'))),
                        onChanged: (c) {
                          setState(() {
                            selectedColor = c;
                          });
                        },
                      ),
                      IconButton(
                        onPressed: () => _abrirDialogoColor(context),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SelectableItem<Talla>(
                        width: 200,
                        selectedItem: selectedTalla,
                        items: dataGenera!.tallas,
                        getLabel: (t) => t.nombreTalla,
                        getColor: (t) => Colors.blue,
                        onChanged: (t) {
                          setState(() {
                            selectedTalla = t;
                          });
                        },
                      ),
                      IconButton(
                        onPressed: () => _pedirTallas(context),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  customButton(
                    width: 237,
                    onPressed: () {
                      setState(() {
                        // prod!.colores.add(ColorProduct(colorId: ));
                        prod!.tallas.add(TallaProduct(
                            nombreTalla: selectedTalla.nombreTalla,
                            tallaId: selectedTalla.tallaId.toString()));
                      });
                    },
                    textButton: 'Listar',
                    colorText: Colors.white,
                    colors: colorsGreenTablas,
                  ),
                  prod!.tallas.isNotEmpty
                      ? DataTable(
                          dataRowMaxHeight: 35,
                          dataRowMinHeight: 30,
                          horizontalMargin: 12,
                          columnSpacing: 16,
                          headingRowHeight: 40,
                          decoration: const BoxDecoration(color: colorsAd),
                          headingTextStyle:
                              const TextStyle(color: Colors.white),
                          border: TableBorder.symmetric(
                              inside: const BorderSide(
                                  color: Colors.grey,
                                  style: BorderStyle.solid)),
                          columns: const [
                            DataColumn(label: Text('Size')),
                          ],
                          rows: prod!.tallas.asMap().entries.map((entry) {
                            int index = entry.key;
                            TallaProduct report = entry.value;
                            return DataRow(
                              color: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              cells: [
                                DataCell(Text(report.nombreTalla.toString())),
                              ],
                            );
                          }).toList(),
                        )
                      : const SizedBox(),
                  identy(context),
                ],
              ),
      ),
    );
  }

  void _pedirMaterial(BuildContext context) async {
    final resultado = await showInputDialog(
      context: context,
      title: 'Ingrese un material',
      hintText: 'Nombre',
      inputType: TextInputType.text,
    );
    if (resultado != null) {
      print('Valor ingresado: $resultado');
      _servicesProduct.addMaterial({'name_material': resultado.toUpperCase()});
      fetchGeneralData();
    }
  }

  void _pedirLineaProducto(BuildContext context) async {
    final resultado = await showInputDialog(
        context: context,
        title: 'Ingrese linea producto',
        hintText: 'linea producto',
        inputType: TextInputType.text);
    if (resultado != null) {
      print('Valor ingresado: $resultado');
      _servicesProduct.addLineaProducto(
          {'name_producto': resultado.toUpperCase(), 'ruta_imagen': 'N/A'});
      fetchGeneralData();
    }
  }

  void _pedirTallas(BuildContext context) async {
    final resultado = await showInputDialog(
      context: context,
      title: 'Ingrese una talla',
      hintText: 'Talla',
      inputType: TextInputType.text,
    );
    if (resultado != null) {
      print('Valor ingresado: $resultado');
      _servicesProduct.addTallas({'nombre_talla': resultado.toUpperCase()});
      fetchGeneralData();
    }
  }

  void _pedirMarca(BuildContext context) async {
    final resultado = await showInputDialog(
      context: context,
      title: 'Ingrese una Marca',
      hintText: 'Nombre de la marca',
      inputType: TextInputType.text,
    );
    if (resultado != null) {
      print('Valor ingresado: $resultado');
      _servicesProduct.addMarca({'name_marca': resultado.toUpperCase()});
      fetchGeneralData();
    }
  }

  void _pedirCategoria(BuildContext context) async {
    final resultado = await showInputDialog(
      context: context,
      title: 'Ingrese categoria',
      hintText: 'Nombre de la categoria',
      inputType: TextInputType.text,
    );
    if (resultado != null) {
      print('Valor ingresado: $resultado');
      _servicesProduct
          .addSubCategoria({'name_sub_categoria': resultado.toUpperCase()});
      fetchGeneralData();
    }
  }

  void _abrirDialogoColor(BuildContext context) async {
    final resultado = await showColorDialog(context);

    if (resultado != null) {
      print('Nombre: ${resultado['nombre_color']}');
      print('Hex: ${resultado['hex_code']}');

      _servicesProduct.addColors({
        'nombre_color': resultado['nombre_color']!.toUpperCase(),
        'hex_code': resultado['hex_code']!.toUpperCase()
      });
      fetchGeneralData();
    }
  }
}

Future<String?> showInputDialog({
  required BuildContext context,
  required String title,
  String hintText = '',
  TextInputType inputType = TextInputType.text,
}) {
  final TextEditingController _controller = TextEditingController();

  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 300, // Cuadrado aproximado
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                keyboardType: inputType,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    child: const Text('Aceptar'),
                    onPressed: () {
                      final value = _controller.text.trim();
                      Navigator.of(context)
                          .pop(value.isNotEmpty ? value : null);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

Future<Map<String, String>?> showColorDialog(BuildContext context) async {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController hexController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  return showDialog<Map<String, String>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Registrar color',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del color',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Nombre obligatorio'
                      : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: hexController,
                  decoration: const InputDecoration(
                    labelText: 'Código HEX (#RRGGBB)',
                    hintText: '#FF0000',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  validator: (value) {
                    final hex = value?.trim() ?? '';
                    final regex = RegExp(r'^#([A-Fa-f0-9]{6})$');
                    if (hex.isEmpty) return 'Código HEX obligatorio';
                    if (!regex.hasMatch(hex)) {
                      return 'Código inválido (#RRGGBB)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text('Cancelar'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      child: const Text('Guardar'),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(context, {
                            'nombre_color': nameController.text.trim(),
                            'hex_code': hexController.text.trim(),
                          });
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
