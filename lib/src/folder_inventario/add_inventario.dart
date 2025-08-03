import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../datebase/current_data.dart';
import '../folder_list_product/dialog_get_product.dart';
import '../folder_list_product/model_product/product.dart';
import '../util/commo_pallete.dart';
import '../util/get_formatted_number.dart';
import '../util/helper.dart';
import 'model/model_inventory_entry_item.dart';

class AddInventario extends StatefulWidget {
  const AddInventario({super.key});

  @override
  State createState() => _AddInventarioState();
}

class _AddInventarioState extends State<AddInventario> {
  List<InventoryEntryItem> entryItems = [];
  final controllerCant = TextEditingController();
  final controllerNumFactura = TextEditingController();
  final controllerNote = TextEditingController();
  Product? productPicked;

  List<InventoryEntryItem> entradaLista = [];

  void agregarProducto() {
    if (productPicked != null && controllerCant.text.isNotEmpty) {
      entradaLista.add(InventoryEntryItem(
        idProduct: int.parse(productPicked!.idProducto ?? '0'),
        quantity: double.parse(controllerCant.text.trim()),
        note: controllerNote.text.trim(),
        numFactura: controllerNumFactura.text.trim(),
        registedBy: currentUsers?.fullName ?? 'N/A',
        nameProduct: productPicked!.nameProducto ?? 'N/A',
      ));

      // Limpiar campos
      setState(() {
        productPicked = null;
        controllerCant.clear();
      });
    }
  }

  void eliminarProducto(int index) {
    setState(() {
      entradaLista.removeAt(index);
    });
  }

  Future<void> enviarOrden() async {
    // final url =
    //     Uri.parse('http://tuservidor.com/api/insert_inventory_entries.php');
    // final response = await http.post(
    //   url,
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode({
    //     'entries': entradaLista.map((e) => e.toJson()).toList(),
    //   }),
    // );

    // if (response.statusCode == 200) {
    //   // Éxito
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(content: Text("Orden enviada correctamente")));
    //   setState(() {
    //     entradaLista.clear();
    //   });
    // } else {
    //   // Error
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(content: Text("Error al enviar orden")));
    // }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    const curve = Curves.elasticInOut;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Inventario'),
      ),
      body: Column(children: [
        const SizedBox(width: double.infinity),
        buildTextFieldValidator(
          controller: controllerNumFactura,
          label: 'Factura',
          hintText: 'Escribe el número de factura',
        ),
        buildTextFieldValidator(
            label: 'Nota',
            hintText: 'Escribe una nota',
            controller: controllerNote),
        SlideInRight(
          curve: curve,
          child: Container(
              color: Colors.white,
              // height: 50,
              width: 250,
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: TextButton(
                    onPressed: () => chooseProduct(context),
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
                            '\$ ${getNumFormatedDouble(productPicked!.priceProduct.toString())}',
                            style: style.labelSmall?.copyWith(
                                color: ktejidogrey.withOpacity(0.5),
                                fontSize: 12))
                        : const SizedBox(),
                    productPicked != null
                        ? Text(
                            '${getNumFormatedDouble(productPicked!.stock.toString())} Stock',
                            style: style.labelSmall?.copyWith(
                                color: Product.validatorStock(productPicked!)
                                    ? colorsBlueTurquesa
                                    : colorsRed,
                                fontSize: 8))
                        : const SizedBox(),
                  ],
                ),
              )),
        ),
        SlideInLeft(
          curve: curve,
          child: buildTextFieldValidator(
            label: 'Cantidad',
            controller: controllerCant,
            hintText: 'Escribe la cantidad',
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onEditingComplete: agregarProducto,
          ),
        ),
        customButton(
            onPressed: agregarProducto,
            textButton: 'Agregar a lista',
            colors: colorsBlueDeepHigh),
        // Divider(),
        entradaLista.isEmpty
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.all(25),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    child: DataTable(
                      dataRowMaxHeight: 25,
                      dataRowMinHeight: 20,
                      horizontalMargin: 10.0,
                      columnSpacing: 15,
                      headingRowHeight: 30,
                      decoration: const BoxDecoration(color: ktejidogrey),
                      headingTextStyle: const TextStyle(color: Colors.white),
                      border: TableBorder.symmetric(
                          outside: BorderSide(
                              color: Colors.grey.shade100,
                              style: BorderStyle.none),
                          inside: const BorderSide(
                              style: BorderStyle.solid, color: Colors.grey)),
                      columns: const [
                        DataColumn(label: Text('NUMERO FACTURA')),
                        DataColumn(label: Text('NOMBRE PRODUCTO')),
                        DataColumn(label: Text('CANTIDAD')),
                        DataColumn(label: Text('COMENTARIO')),
                        DataColumn(label: Text('QUITAR')),
                      ],
                      rows: entradaLista.asMap().entries.map((entry) {
                        int index = entry.key;
                        InventoryEntryItem item = entry.value;
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
                            DataCell(Text(item.numFactura ?? 'N/A')),
                            DataCell(Text(item.nameProduct ?? 'N/A')),
                            DataCell(Text(item.quantity.toString())),
                            DataCell(Text(limitarTexto(item.note, 20))),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: Colors.red,
                                    size: style.bodySmall?.fontSize),
                                onPressed: () => eliminarProducto(index),
                              ),
                            )
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

        if (entradaLista.isNotEmpty)
          ElevatedButton.icon(
            icon: Icon(Icons.send),
            label: Text('Enviar Orden'),
            onPressed: enviarOrden,
          )
      ]),
    );
  }

  void chooseProduct(context) async {
    Product? produto = await showDialog<Product>(
        context: context,
        builder: (context) {
          return const DialogGetProductos();
        });
    if (produto != null) {
      setState(() {
        productPicked = produto;
      });
    }
  }
}
