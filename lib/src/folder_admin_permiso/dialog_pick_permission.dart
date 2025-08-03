// Función para mostrar el diálogo
import 'package:flutter/material.dart';
import '/src/util/commo_pallete.dart';

import '../model/users.dart';

Future<ListPermission?> showPermisoDialog(
    BuildContext context, List<ListPermission> permisos) async {
  final style = Theme.of(context).textTheme;
  return showDialog<ListPermission>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text('Seleccionar Permiso', style: style.titleSmall),
        content: SizedBox(
          width: 250,
          height: 300,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: permisos.length,
            itemBuilder: (BuildContext context, int index) {
              final permiso = permisos[index];
              return ListTile(
                title: Text(permiso.modulo ?? 'N/A'),
                subtitle: Text('Acción: ${permiso.action}',
                    style:
                        style.bodySmall?.copyWith(color: colorsBlueDeepHigh)),
                onTap: () {
                  Navigator.of(context)
                      .pop(permiso); // Retorna el objeto Permiso seleccionado
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context)
                  .pop(null); // Cerrar el diálogo sin seleccionar nada
            },
          ),
        ],
      );
    },
  );
}
