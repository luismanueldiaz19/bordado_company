import 'package:flutter/material.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';

class JobDialog extends StatefulWidget {
  const JobDialog({super.key});

  @override
  State<JobDialog> createState() => _JobDialogState();
}

class _JobDialogState extends State<JobDialog> {
  TextEditingController jobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Escribir tipo de trabajo'),
      content: TextField(
        onEditingComplete: () {
          if (jobController.text.isNotEmpty) {
            _sendJobToServer(jobController.text);
            Navigator.of(context).pop();
          }
        },
        controller: jobController,
        decoration: const InputDecoration(hintText: 'Tipo de trabajo'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (jobController.text.isNotEmpty) {
              _sendJobToServer(jobController.text);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Enviar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
      ],
    );
  }

  void _sendJobToServer(String job) async {
    // print(job);
    String insertType =
        "http://$ipLocal/settingmat/admin/insert/insert_tipo_trabajo_diseno.php";

    var data = {'name_type_work': job.toUpperCase()};
    // insert_tipo_trabajo_diseno
    final res = await httpRequestDatabase(insertType, data);
    // print(res.body);
    // Aquí puedes realizar la lógica para enviar el tipo de trabajo al servidor
    // Puedes utilizar la librería http para realizar una solicitud HTTP al servidor
    // por ejemplo:
    // http.post(Uri.parse('https://ejemplo.com/api/trabajo'), body: {'job': job});
    // Recuerda que debes manejar las respuestas y posibles errores del servidor adecuadamente.
  }
}
