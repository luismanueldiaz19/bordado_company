import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import '/src/datebase/url.dart';

import 'add_producto_new.dart';
import 'producto.dart';
import 'producto_repository.dart';
import 'producto_services.dart';
import 'widget_imagen.dart';

class ProductoListScreen extends StatefulWidget {
  const ProductoListScreen({super.key});

  @override
  State<ProductoListScreen> createState() => _ProductoListScreenState();
}

class _ProductoListScreenState extends State<ProductoListScreen> {
  late ProductoRepository _productoRepository;
  late Future<List<Producto>> _futureProductos;
  final String ruta = 'http://$ipLocal/settingmat';

  final TextEditingController _searchController = TextEditingController();
  List<Producto> _todosLosProductos = []; // original
  List<Producto> _productosFiltrados = []; // visibles

  @override
  void initState() {
    super.initState();
    _productoRepository = ProductoRepository(
      ProductoService('http://$ipLocal/settingmat/admin/select'),
    );

    _futureProductos = _productoRepository.fetchProductos().then((productos) {
      _todosLosProductos = productos;
      _productosFiltrados = productos;
      return productos;
    });
  }

  void _filtrarProductos(String query) {
    final queryLower = query.toLowerCase();

    setState(() {
      _productosFiltrados = _todosLosProductos.where((producto) {
        return producto.descripcion.toLowerCase().contains(queryLower) ||
            producto.secuenciaNum.toLowerCase().contains(queryLower) ||
            producto.marca.toLowerCase().contains(queryLower) ||
            producto.material.toLowerCase().contains(queryLower);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _filtrarProductos,
          decoration: const InputDecoration(
            hintText: 'Buscar productos...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AddProductoNew()));
              },
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Producto>>(
        future: _futureProductos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final productos = _productosFiltrados;

          if (productos.isEmpty) {
            return const Center(child: Text('No hay productos disponibles.'));
          }

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final producto = productos[index];
              final tieneImagen = producto.rutaImagen.isNotEmpty;

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Imagen
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: ClipRRect(
                                child: tieneImagen
                                    ? ProductoImagenWidget(
                                        imageUrl: '$ruta${producto.rutaImagen}',
                                        width: 35,
                                        height: 35)
                                    : const Icon(Icons.image_not_supported,
                                        size: 80)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(producto.descripcion.toUpperCase(),
                                    style: style.bodySmall),
                                // Text(producto.subCategoria),
                                Row(
                                  children: [
                                    const Text('Precios:'),
                                    const SizedBox(width: 8),
                                    PopupMenuButton<int>(
                                      tooltip: 'Ver precios',
                                      icon: const Icon(Icons.price_change,
                                          size: 24),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 1,
                                          child: Text(
                                              'Precio venta: \$${producto.precioVenta}'),
                                        ),
                                        PopupMenuItem(
                                          value: 2,
                                          child: Text(
                                              'Precio oferta: \$${producto.precioOferta}'),
                                        ),
                                        PopupMenuItem(
                                          value: 3,
                                          child: Text(
                                              'Precio mayorista: \$${producto.precioMayorista}'),
                                        ),
                                      ],
                                      onSelected: (value) {
                                        // Aquí puedes hacer algo si lo deseas
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: PrettyQrView.data(
                              data: producto.productoId,
                              decoration: const PrettyQrDecoration(
                                shape: PrettyQrSmoothSymbol(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // const Divider(),
                      // // Colores
                      // Text('Colores disponibles:',
                      //     style: Theme.of(context)
                      //         .textTheme
                      //         .bodySmall
                      //         ?.copyWith(fontWeight: FontWeight.bold)),
                      // const SizedBox(height: 5),

                      // Wrap(
                      //   spacing: 8,
                      //   children: producto.colores.map((color) {
                      //     final parsedColor = Color(int.parse(
                      //         color.hexCode.replaceFirst('#', '0xff')));
                      //     final brightness =
                      //         ThemeData.estimateBrightnessForColor(parsedColor);
                      //     return Chip(
                      //       label: Text(
                      //         color.nombreColor,
                      //         style: Theme.of(context)
                      //             .textTheme
                      //             .bodySmall
                      //             ?.copyWith(
                      //                 color: brightness == Brightness.dark
                      //                     ? Colors.white
                      //                     : Colors.black),
                      //       ),
                      //       backgroundColor: parsedColor,
                      //     );
                      //   }).toList(),
                      // ),
                      // const SizedBox(height: 5),
                      // Text('Tallas disponibles:',
                      //     style: Theme.of(context)
                      //         .textTheme
                      //         .bodySmall
                      //         ?.copyWith(fontWeight: FontWeight.bold)),
                      // const SizedBox(height: 5),
                      // Wrap(
                      //   spacing: 8,
                      //   children: producto.tallas.map((talla) {
                      //     return Chip(
                      //         label: Text(talla.nombreTalla,
                      //             style: Theme.of(context).textTheme.bodySmall),
                      //         backgroundColor: Colors.grey.shade200);
                      //   }).toList(),
                      // ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
