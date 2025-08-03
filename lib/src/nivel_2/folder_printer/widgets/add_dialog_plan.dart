import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../util/commo_pallete.dart';
import '../../../util/helper.dart';
import '../../../util/show_mesenger.dart';
import '../../../widgets/bottom_custom.dart';
import '../../../widgets/picked_date_widget.dart';
import '../../folder_planificacion/model_planificacion/item_planificacion.dart';
import '../model/printer_plan.dart';
import '../printer_provider.dart';

class AddDialogPlan extends StatefulWidget {
  const AddDialogPlan({super.key, required this.item});
  final PlanificacionItem item;

  @override
  State createState() => _AddDialogPlanState();
}

class _AddDialogPlanState extends State<AddDialogPlan> {
  // late Map<String, String> localFormData;
  TextEditingController controlleraAsignado =
      TextEditingController(text: 'N/A');
  TextEditingController controllerIndexWork = TextEditingController();
  TextEditingController controllerCant = TextEditingController();
  TextEditingController controlleComentario =
      TextEditingController(text: 'N/A');
  String? _firstDate = DateTime.now().toString().substring(0, 10);
  @override
  void initState() {
    super.initState();
    controllerCant.text = widget.item.cant.toString();
    _firstDate = widget.item.fechaEnd.toString().trim();
    // Copiamos el objeto para trabajar localmente si es necesario
    // localFormData = Map<String, String>.from(widget.formData);
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final printerProvider = Provider.of<PrinterProvider>(context);
    // print(widget.item.toJson());
    return AlertDialog(
      title: Text('Completar Datos', style: style.titleMedium),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: PrinterPlan.getColorByDepartment(
                  widget.item.department ?? 'N/A'),
              borderRadius: BorderRadius.circular(1),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.3), // sombra principal
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: colorsBlueDeepHigh
                      .withOpacity(0.1), // sombra secundaria para efecto
                  blurRadius: 12,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Vista previa',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                        child: _buildPreviewRow(
                            'Orden', widget.item.numOrden, context)),
                    Expanded(
                        child: _buildPreviewRow(
                            'Ficha', widget.item.ficha, context)),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                        child: _buildPreviewRow(
                            'Fecha', widget.item.fechaStart, context)),
                    Expanded(
                        child: _buildPreviewRow(
                            'Estado', widget.item.statu, context)),
                  ],
                ),
                _buildPreviewRow('Logo', widget.item.nameLogo, context),

                _buildPreviewRow('Tipo',
                    limitarTexto(widget.item.tipoProduct ?? '', 25), context),
                Row(
                  children: [
                    Expanded(
                        child: _buildPreviewRow(
                            'Cantidad', widget.item.cant, context)),
                    Expanded(
                        child: _buildPreviewRow(
                            'Depto.', widget.item.department, context)),
                  ],
                ),

                const Divider(),
                // Aquí va el resto de tu contenido:
                // Fecha + Inputs
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                // const Divider(),
                Text('Cambiar la fecha de plan',
                    style: style.titleMedium?.copyWith(color: colorsRedOpaco)),
                const Divider(),
                Container(
                  width: 250,
                  height: 50,
                  color: Colors.grey.shade100,
                  child: TextButton(
                      onPressed: () async {
                        String? dateee =
                            await showDatePickerCustom(context: context);
                        if (dateee != null) {
                          _firstDate = dateee.toString();
                          //print(_firstDate);
                          setState(() {});
                        }
                      },
                      child: Text('Fecha : ${_firstDate ?? 'N/A'}')),
                ),
                buildTextFieldValidator(
                  label: 'Cantidad',
                  controller: controllerCant,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  hintText: 'Poner cantidad',
                ),
                buildTextFieldValidator(
                  label: 'Indexes De Prioridad',
                  controller: controllerIndexWork,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  hintText: 'Prioridad',
                ),
                buildTextFieldValidator(
                  label: 'Asignar A',
                  controller: controlleraAsignado,
                  hintText: 'Asignar',
                ),
                buildTextFieldValidator(
                    label: 'Comentario',
                    controller: controlleComentario,
                    hintText: 'Comentar'),
              ],
            ),
          ))
        ],
      ),
      actions: [
        BottomCustom(
            onPressed: () {
              final indexWork = controllerIndexWork.text.trim();
              final asignado = controlleraAsignado.text.trim();
              final comentario = controlleComentario.text.trim();
              final cant = controllerCant.text.trim();

              if (indexWork.isEmpty) {
                showScaffoldMessenger(
                    context, 'Debes ingresar la prioridad.', Colors.red);
                return;
              }

              if (asignado.isEmpty) {
                showScaffoldMessenger(
                    context, 'Debes asignar a alguien.', Colors.red);
                return;
              }
              if (cant.isEmpty) {
                showScaffoldMessenger(
                    context, 'Debes tener una cantidad.', Colors.red);
                return;
              }

              // Si pasa la validación, entonces arma el formData
              final Map<String, String> formData = {
                'nombre_logo': widget.item.nameLogo ?? 'N/A',
                'index_work': indexWork,
                'tipo_trabajo': widget.item.nameLogo ?? 'N/A',
                'cantidad': cant.toString(),
                'ficha': widget.item.ficha ?? 'N/A',
                'orden': widget.item.numOrden ?? 'N/A',
                'asignado': asignado,
                'comentario': comentario.isEmpty ? 'N/A' : comentario,
                'estado': 'PENDIENTE',
                'name_depart': quitarAcentos(widget.item.department ?? 'N/A'),
                'fecha_trabajo':
                    _firstDate ?? DateTime.now().toString().substring(0, 10),
                'boceto': 'N/A',
              };

              printerProvider.addPlan(formData);
              Navigator.pop(context, true);
            },
            text: 'Enviar',
            colorButton: PrinterPlan.getColorByDepartment(
                widget.item.department ?? 'N/A'),
            width: 150),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // Cerrar sin guardar
          },
          child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}

Widget _buildPreviewRow(String label, String? value, context) {
  final style = Theme.of(context).textTheme;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0),
    child: Row(
      children: [
        Text('$label : ',
            style: style.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black54)),
        Expanded(
          child: borderedText(
            value ?? 'N/A',
            style.bodyMedium!.copyWith(color: Colors.transparent),
            borderColor: Colors.white70,
            strokeWidth: 1.5,
          ),
        ),
      ],
    ),
  );
}

Widget borderedText(String text, TextStyle style,
    {Color borderColor = Colors.white, double strokeWidth = 1}) {
  return Stack(
    children: [
      // Texto de fondo (borde)
      Text(
        text,
        style: style.copyWith(
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..color = borderColor,
        ),
      ),
      // Texto principal (relleno)
      Text(
        text,
        style: style,
      ),
    ],
  );
}
