import 'package:bordado_company/src/util/commo_pallete.dart';
import 'package:bordado_company/src/util/get_formatted_number.dart';
import 'package:flutter/material.dart';
import '../../datebase/current_data.dart';
import '../../model/orden_list.dart';

import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class ViewFactura extends StatefulWidget {
  const ViewFactura({super.key, this.factura});
  final OrdenList? factura;

  @override
  State createState() => _ViewFacturaState();
}

class _ViewFacturaState extends State<ViewFactura> {
  // FacturaRepositories repoFactura = FacturaRepositories();
  // Factura? item;
  // Future getFacturaDetallesId() async {
  //   // setState(() {
  //   //   listPurchase.clear();
  //   //   listPurchaseFilter.clear();
  //   // });
  //   // item = await repoFactura.getFacturaById(widget.factura!.idFactura!);

  //   if (!mounted) {
  //     return;
  //   }
  //   setState(() {});
  // }

  // @override
  // void initState() {
  //   super.initState();

  //   getFacturaDetallesId();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver Factura'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: buildFacturaPreview(),
          ),
          identy(context)
        ],
      ),
    );
  }

  Widget buildFacturaPreview() {
    final style = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Positioned(
            right: 150,
            top: 15,
            child: Transform.rotate(
              angle: -0.50,
              child: Opacity(
                opacity: 0.09,
                child: Image.asset(
                  logoApp,
                  height: 500,
                  width: 500,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado Empresa
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo + Empresa
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('${currentEmpresa.nombreEmpresa}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(
                        'RNC: ${currentEmpresa.rncEmpresa}',
                        style: TextStyle(
                            color: colorsPuppleOpaco,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                          width: 250,
                          child: Text('${currentEmpresa.adressEmpressa}')),
                      Row(
                        children: [
                          Text('Tel: ${currentEmpresa.telefonoEmpresa}'),
                          const SizedBox(width: 10),
                          Text('Tel: ${currentEmpresa.celularEmpresa}'),
                        ],
                      ),

                      if (widget.factura != null) ...[
                        const SizedBox(width: 250, child: Divider()),
                        const Text('Cliente :',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        Text('RNC: ${widget.factura!.cliente!.nombre ?? ''}'),
                        Text(
                            'Dirección: ${widget.factura!.cliente!.direccion ?? ''}'),
                        Text(
                            'Tel: ${widget.factura!.cliente!.telefono ?? 'Sin teléfono'}'),
                        Row(
                          children: [
                            const Text('Facturado a:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 5),
                            Text(currentUsers?.fullName ?? 'N/A'),
                          ],
                        ),
                      ],
                      const SizedBox(height: 20),

                      // Cliente
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // ✅ CÓDIGO QR del ID de la factura
                      if (widget.factura!.numOrden != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 100,
                              // width: 100,
                              child: PrettyQrView.data(
                                data: widget.factura!.numOrden ?? 'N/A',
                                decoration: const PrettyQrDecoration(
                                  shape: PrettyQrSmoothSymbol(
                                      color: Colors.black, roundFactor: 1),
                                  image: PrettyQrDecorationImage(
                                      image: AssetImage(
                                          'assets/tatami_logo_mariposa.png'),
                                      position: PrettyQrDecorationImagePosition
                                          .embedded),
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 10),
                      Text('Factura : ----',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),

                      // const SizedBox(height: 5),
                      const SizedBox(height: 5),
                      Text('Pedido #: P111048'),
                      Text(
                          'Fecha de Entrega: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.factura!.fechaEntrega ?? ''))}'),
                      Text('Vendedor: _ ${widget.factura!.fullName ?? 'N/A'}_'),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Text('NCF : ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text('----',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      if (widget.factura! != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            children: [
                              const Text('Válida hasta 31/12/2022'),
                              // Text(item!.tipoNcf!.toUpperCase(),
                              //     style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              // Detalles productos
              Table(
                border: TableBorder.all(color: Colors.grey),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FixedColumnWidth(80), // Código
                  1: FlexColumnWidth(), // Descripción
                  2: FixedColumnWidth(100), // Cant
                  3: FixedColumnWidth(100), // Precio
                  4: FixedColumnWidth(100), // Total
                },
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: Colors.grey),
                    children: const [
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: Text('Código',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: Text('Descripción',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: Text('Cant.',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: Text('Precio',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: Text('Total',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                  ...widget.factura!.ordenItem!.map((itemDetalles) {
                    final totalLinea =
                        double.parse(itemDetalles.precioFinal ?? '0.0') *
                            itemDetalles.cant!;
                    return TableRow(
                      children: [
                        Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                                'CODG:${itemDetalles.idProducto.toString()}')),
                        Padding(
                            padding: EdgeInsets.all(5),
                            child:
                                Text(itemDetalles.detallesProductos ?? 'N/A')),
                        Center(child: Text('${itemDetalles.cant}')),
                        Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                                '\$ ${getNumFormatedUS(itemDetalles.precioFinal ?? '0')!}')),
                        Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                                '\$ ${getNumFormatedUS(totalLinea.toStringAsFixed(2))}')),
                      ],
                    );
                  }),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Columna izquierda: Nota + Transferencia
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '⚠ Nota de Pago:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '• Cheque a nombre de: ${currentEmpresa.nombreEmpresa!.toUpperCase()}',
                          style: TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '• Transferencia bancaria:\n  Banco ****\n  Cuenta Corriente: 794-****\n  Beneficiario: ${currentEmpresa.nombreEmpresa}\n  (Indicar número de orden de pedido)',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 8),
                        const Text(
                          '✨ Producto bordado con dedicación y detalle.',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '🇩🇴 Hecho a mano en República Dominicana.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Expanded(
                  //   flex: 3,
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: const [
                  //       Text('Note : Cheque a Nombre  de JAVIER ANTONIO REGALADO'),
                  //       SizedBox(height: 5),
                  //       Text(
                  //         'Transferencia : Banco Popular cuenta Corriente # 794228650  Beneficiario\nJavier Ant. Recalado (Indicar Orden de Pedido)',
                  //         style: TextStyle(fontWeight: FontWeight.bold),
                  //       ),
                  //       SizedBox(height: 5),
                  //       Text('Made in Dominican Republic.'),
                  //     ],
                  //   ),
                  // ),

                  // Columna derecha: Totales
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildTotalRow('Total Bruto.:', 0),
                        _buildTotalRow('Descuento.:', 0.0),
                        _buildTotalRow('Monto Exento.:', 0.0),
                        _buildTotalRow('Base Imponible.:', 0),
                        const Divider(color: Colors.black26),
                        _buildTotalRow('Sub-Total.:', 0),
                        _buildTotalRow('ITBIS:', 0),
                        const Divider(color: Colors.black26),
                        _buildTotalRow('Total  RD\$.', 0, isBold: true),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Pie de página
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text('Estado : ${item?.estado ?? ''}'),
                  const SizedBox(),
                  Text(
                      'Fecha - ${DateFormat('dd/MM/yyyy hh:mm:ss a').format(DateTime.now())}'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  isBold ? const TextStyle(fontWeight: FontWeight.bold) : null),
          Text('\$${value.toStringAsFixed(2)}',
              style:
                  isBold ? const TextStyle(fontWeight: FontWeight.bold) : null),
        ],
      ),
    );
  }
}

// class SeguimientoOrden extends StatefulWidget {
//   const SeguimientoOrden({super.key, required this.item});
//   final OrdenList? item;

//   @override
//   State<SeguimientoOrden> createState() => _SeguimientoOrdenState();
// }

// class _SeguimientoOrdenState extends State<SeguimientoOrden> {
//   @override
//   Widget build(BuildContext context) {
//     final orden = widget.item;

//     if (orden == null) {
//       return const Scaffold(
//         body: Center(child: Text('No se encontró la orden')),
//       );
//     }

//     final cliente = orden.cliente;
//     final productos = orden.ordenItem ?? [];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Pre Orden'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.picture_as_pdf),
//             onPressed: () {
//               // Acción para convertir en factura o generar PDF
//             },
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🧾 Info Orden
//             Text('Orden #${orden.numOrden}',
//                 style: Theme.of(context).textTheme.titleLarge),
//             const SizedBox(height: 8),
//             Text('Fecha de creación: ${orden.fechaCreacion}'),
//             Text('Fecha de entrega: ${orden.fechaEntrega}'),
//             Text('Estado general: ${orden.estadoGeneral}'),
//             Text('Estado entrega: ${orden.estadoEntrega}'),
//             Text('Prioridad: ${orden.estadoPrioritario}'),
//             Text('Logo: ${orden.nameLogo}'),
//             Text('Ficha: ${orden.ficha}'),
//             Text('Observaciones: ${orden.observaciones ?? 'N/A'}'),
//             const Divider(height: 30),
//             // 👤 Info Cliente
//             Text('Cliente', style: Theme.of(context).textTheme.titleLarge),
//             Text('${cliente?.nombre ?? ''} ${cliente?.apellido ?? ''}'),
//             Text('Dirección: ${cliente?.direccion ?? ''}'),
//             Text('Teléfono: ${cliente?.telefono ?? ''}'),
//             Text('Correo: ${cliente?.correoElectronico ?? ''}'),
//             const Divider(height: 30),

//             // 📦 Productos (usando tu DataTable personalizado)
//             Text('Detalle de Productos',
//                 style: Theme.of(context).textTheme.titleLarge),
//             const SizedBox(height: 10),

//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 dataRowMaxHeight: 25,
//                 dataRowMinHeight: 20,
//                 horizontalMargin: 10.0,
//                 columnSpacing: 15,
//                 headingRowHeight: 30,
//                 decoration: const BoxDecoration(color: colorsOrange),
//                 headingTextStyle: const TextStyle(
//                     color: Colors.white, fontWeight: FontWeight.bold),
//                 border: TableBorder.symmetric(
//                   outside: BorderSide(
//                       color: Colors.grey.shade100, style: BorderStyle.none),
//                   inside: const BorderSide(
//                       style: BorderStyle.solid, color: Colors.grey),
//                 ),
//                 columns: const [
//                   DataColumn(label: Text('DETALLES')),
//                   DataColumn(label: Text('----')),
//                   DataColumn(label: Text('DEPARTAMENTO')),
//                   DataColumn(label: Text('ESTADO')),
//                   DataColumn(label: Text('# ORDEN')),
//                   DataColumn(label: Text('FICHA')),
//                   DataColumn(label: Text('LOGO')),
//                   DataColumn(label: Text('DETALLES')),
//                   DataColumn(label: Text('QTY')),
//                   DataColumn(label: Text('COMMENT')),
//                   DataColumn(label: Text('ELIMINAR')),
//                 ],
//                 rows: productos.asMap().entries.map((entry) {
//                   int index = entry.key;
//                   var item = entry.value;
//                   return DataRow(
//                     color: WidgetStateProperty.resolveWith((states) =>
//                         getColorPriority(item.estadoProduccion ?? '')),
//                     cells: [
//                       DataCell(const Text('Click !',
//                           style: TextStyle(color: colorsOrange))),
//                       DataCell(Text(item.estadoProduccion ?? '')),
//                       DataCell(Text(item.detallesProductos ?? '')),
//                       DataCell(Text(item.estadoProduccion ?? '')),
//                       DataCell(Center(child: Text('${orden.numOrden}'))),
//                       DataCell(Text('${orden.ficha}')),
//                       DataCell(Text('${orden.nameLogo}')),
//                       DataCell(Text(item.detallesProductos ?? '')),
//                       DataCell(Text(item.cant.toString())),
//                       DataCell(Text(item.nota ?? '')),
//                       DataCell(
//                         hasPermissionUsuario(currentUsers!.listPermission!,
//                                 "admin", "eliminar")
//                             ? TextButton(
//                                 child: const Text('Eliminar',
//                                     style: TextStyle(color: Colors.red)),
//                                 onPressed: () {
//                                   // Acción eliminar
//                                 },
//                               )
//                             : const Text('Sin Permiso'),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
