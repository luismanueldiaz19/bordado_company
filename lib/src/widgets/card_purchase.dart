// =============================
// 🚀 WIDGET PERSONALIZADO DE FACTURA
// =============================
import 'package:flutter/material.dart';
import '../datebase/current_data.dart';
import '../model/purchase.dart';
import '../model/users.dart';

class PurchaseCard extends StatelessWidget {
  final Purchases purchase;
  const PurchaseCard({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: CustomPaint(
        painter: FacturaPainter(),
        child: Container(
          // width: 300,
          // height: 300,
          // Ajustado para ser más cuadrado
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🟢 ENCABEZADO DE LA FACTURA
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "# Compra : ${purchase.purchasesId}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            purchase.proveedor ?? 'Proveedor',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text('Factura : ${purchase.numFactura}',
                              style: style.bodySmall
                                  ?.copyWith(color: Colors.black54)),
                          Text('${purchase.usuario}',
                              style: style.bodySmall
                                  ?.copyWith(color: Colors.deepOrange)),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          purchase.fechaCompra.toString(),
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        Text(
                          purchase.estado ?? '',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Producto"),
                    Row(
                      children: [
                        Text("Units"),
                        SizedBox(width: 10),
                        Text("Precio"),
                        SizedBox(width: 10),
                        Text("SubTotal"),
                      ],
                    )
                  ],
                ),
                // 🟢 LISTA DE ITEMS
                Column(
                  children: purchase.purchasesItems!.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.nameProduct ?? "",
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text("${item.cantidad} x \$${item.precioUnitario}",
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 10),
                          Text("\$${item.subtotal}",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const Divider(),
                // 🟢 TOTAL
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("\$${purchase.total}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(purchase.nota ?? '',
                        style:
                            style.bodySmall?.copyWith(color: Colors.black54))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    hasPermissionUsuario(currentUsers!.listPermission!,
                            "inventario", "crear")
                        ? IconButton(
                            onPressed: () async {
                              //  UpdatePurchases
                              // await showDialog(
                              //     context: context,
                              //     builder: (contex) {
                              //       return UpdatePurchases(
                              //         purchase: purchase,
                              //         onUpdate: (item) {
                              //           print(item.toJson());
                              //         },
                              //       );
                              //     });
                            },
                            icon: const Icon(Icons.mode_edit_outlined),
                          )
                        : const SizedBox(),
                    hasPermissionUsuario(currentUsers!.listPermission!,
                            "inventario", "eliminar")
                        ? IconButton(
                            onPressed: () => eliminar(),
                            icon: const Icon(Icons.delete_forever_outlined))
                        : const SizedBox(),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.print))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void eliminar() {}
}

// =============================
// 🎨 CUSTOM PAINTER PARA EL CORTE
// =============================
class FacturaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.white; // Color de la factura

    Path path = Path();

    double triangleSize = 10; // Tamaño del diente

    // 🔵 Comenzamos desde la esquina superior izquierda
    path.moveTo(0, 0);

    // 🔽 Triángulos superiores
    for (double i = 0; i < size.width; i += triangleSize * 2) {
      path.lineTo(i + triangleSize, triangleSize);
      path.lineTo(i + (triangleSize * 2), 0);
    }

    // 📏 Lado derecho
    path.lineTo(size.width, size.height);

    // 🔽 Triángulos inferiores
    for (double i = size.width; i > 0; i -= triangleSize * 2) {
      path.lineTo(i - triangleSize, size.height - triangleSize);
      path.lineTo(i - (triangleSize * 2), size.height);
    }

    // 📏 Lado izquierdo
    path.lineTo(0, 0);
    path.close();

    // 🖌️ Dibujar la forma
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
