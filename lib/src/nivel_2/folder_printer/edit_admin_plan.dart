import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../datebase/current_data.dart';
import '../../util/helper.dart';
import 'model/printer_plan.dart';
import 'printer_services.dart';

class EditAdminPlan extends StatefulWidget {
  const EditAdminPlan({super.key, this.item});
  final PrinterPlan? item;

  @override
  State createState() => _EditAdminPlanState();
}

class _EditAdminPlanState extends State<EditAdminPlan> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _indexWork;
  late final TextEditingController _bocetoCtrl;
  late final TextEditingController _nombreLogoCtrl;
  late final TextEditingController _tipoTrabajoCtrl;
  late final TextEditingController _cantidadCtrl;
  late final TextEditingController _fichaCtrl;
  late final TextEditingController _ordenCtrl;
  late final TextEditingController _asignadoCtrl;
  late final TextEditingController _comentarioCtrl;

  @override
  void initState() {
    super.initState();
    _indexWork = TextEditingController(text: widget.item!.indexWork.toString());
    _bocetoCtrl = TextEditingController(text: widget.item!.boceto ?? '');
    _nombreLogoCtrl =
        TextEditingController(text: widget.item!.nombreLogo ?? '');
    _tipoTrabajoCtrl =
        TextEditingController(text: widget.item!.tipoTrabajo ?? '');
    _cantidadCtrl =
        TextEditingController(text: widget.item!.cantidad?.toString() ?? '');
    _fichaCtrl = TextEditingController(text: widget.item!.ficha ?? '');
    _ordenCtrl = TextEditingController(text: widget.item!.orden ?? '');
    _asignadoCtrl = TextEditingController(text: widget.item!.asignado ?? '');
    _comentarioCtrl =
        TextEditingController(text: widget.item!.comentario ?? '');
  }

  @override
  void dispose() {
    _bocetoCtrl.dispose();
    _indexWork.dispose();
    _nombreLogoCtrl.dispose();
    _tipoTrabajoCtrl.dispose();
    _cantidadCtrl.dispose();
    _fichaCtrl.dispose();
    _ordenCtrl.dispose();
    _asignadoCtrl.dispose();
    _comentarioCtrl.dispose();
    super.dispose();
  }

  PrinterServices _printerServices = PrinterServices();
  void _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;

    final cantidad = int.tryParse(_cantidadCtrl.text.trim());
    if (cantidad == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cantidad debe ser un número válido')),
      );
      return;
    }

    setState(() {
      widget.item!.boceto = _bocetoCtrl.text.trim();
      widget.item!.nombreLogo = _nombreLogoCtrl.text.trim();
      widget.item!.tipoTrabajo = _tipoTrabajoCtrl.text.trim();
      widget.item!.cantidad = cantidad;
      widget.item!.ficha = _fichaCtrl.text.trim();
      widget.item!.orden = _ordenCtrl.text.trim();
      widget.item!.asignado = _asignadoCtrl.text.trim();
      widget.item!.comentario = _comentarioCtrl.text.trim();
      widget.item!.indexWork = int.parse(_indexWork.text.trim());
    });

    await _printerServices.updatePrintPlan(widget.item!.toJson());

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: const Icon(Icons.save),
              onPressed: _guardarCambios,
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(width: double.infinity),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTextFieldValidator(
                        controller: _indexWork,
                        label: 'Indice #NUM',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ]),
                    buildTextFieldValidator(
                        controller: _bocetoCtrl, label: 'Boceto'),
                    buildTextFieldValidator(
                        controller: _nombreLogoCtrl, label: 'Nombre del logo'),
                    buildTextFieldValidator(
                        controller: _tipoTrabajoCtrl, label: 'Tipo de trabajo'),
                    buildTextFieldValidator(
                        controller: _cantidadCtrl,
                        label: 'Cantidad',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ]),
                    buildTextFieldValidator(
                        controller: _fichaCtrl, label: 'Ficha'),
                    buildTextFieldValidator(
                        controller: _ordenCtrl, label: 'Orden'),
                    buildTextFieldValidator(
                        controller: _asignadoCtrl, label: 'Asignado a'),
                    buildTextFieldValidator(
                        controller: _comentarioCtrl, label: 'Comentario'),
                  ],
                ),
              ),
            ),
            identy(context),
          ],
        ),
      ),
    );
  }
}
