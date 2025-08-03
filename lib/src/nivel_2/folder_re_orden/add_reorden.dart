import 'package:flutter/material.dart';
import '/src/datebase/current_data.dart';
import '../../datebase/methond.dart';
import '../../datebase/url.dart';
import '../../widgets/picked_date_widget.dart';
import '../folder_planificacion/model_planificacion/planificacion_last.dart';

class AddReorden extends StatefulWidget {
  const AddReorden({super.key, required this.item});
  final PlanificacionLast item;

  @override
  State<AddReorden> createState() => _AddReordenState();
}

class _AddReordenState extends State<AddReorden> {
  String? _firstDate = DateTime.now().toString().substring(0, 10);
  TextEditingController controllerComment = TextEditingController();

  Future addRegister() async {
    var data = {
      'logo': widget.item.nameLogo?.toUpperCase(),
      'num_orden': widget.item.numOrden?.toUpperCase(),
      'ficha': widget.item.ficha?.toUpperCase(),
      'reorden': _firstDate,
      'created': DateTime.now().toString().substring(0, 10),
      'usuario': currentUsers?.fullName?.toUpperCase(),
      'comment': controllerComment.text.toUpperCase(),
      'balance': widget.item.balance?.toUpperCase(),
      'info_cliente':
          'Cliente : ${widget.item.cliente?.toUpperCase()}- Tel : ${widget.item.clienteTelefono?.toUpperCase()}'
    };
    // print(data);
    final res = await httpRequestDatabase(insertReOrden, data);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(res.body)));
    setState(() {
      controllerComment.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Programar Aviso a Orden')),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          const Text('Fecha de Programación'),
          const SizedBox(height: 10),
          Container(
            width: 250,
            color: Colors.white,
            child: TextButton(
                onPressed: () async {
                  String? dateee = await showDatePickerCustom(context: context);
                  if (dateee != null) {
                    _firstDate = dateee.toString();
                    //print(_firstDate);
                    setState(() {});
                  }
                },
                child: Text(_firstDate ?? 'N/A')),
          ),
          const SizedBox(height: 10),
          Container(
            color: Colors.white,
            width: 250,
            child: TextField(
              expands: false,
              controller: controllerComment,
              maxLines: 20,
              minLines: 1,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'Comentario',
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            color: Colors.white,
            width: 250,
            child: ElevatedButton(
              onPressed: () => addRegister(),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.black)),
              child: const Text('Programar',
                  style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}
