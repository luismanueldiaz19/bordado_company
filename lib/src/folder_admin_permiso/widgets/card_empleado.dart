import 'package:flutter/material.dart';
import '../../datebase/current_data.dart';
import '../../model/users.dart';
import '../../util/commo_pallete.dart';
import '../../util/helper.dart';
import '../edited_user_permision.dart';
import '../editting_users.dart';

class CardEmpleado extends StatelessWidget {
  const CardEmpleado({
    super.key,
    required this.decoration,
    required this.item,
    required this.style,
    required this.listPermission,
  });

  final BoxDecoration decoration;
  final Users item;
  final TextTheme style;
  final List<ListPermission> listPermission;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 200,
      width: 150,
      decoration: decoration,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nombre : '),
                    Text('Codigo : '),
                    Text('Puesto : '),
                    Text('Turno : '),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item.fullName ?? 'N/A',
                      style: style.bodyMedium,
                    ),
                    Text(item.code ?? 'N/A',
                        style: style.labelSmall
                            ?.copyWith(color: colorsAd, fontSize: 12)),
                    Text(
                      item.occupation ?? 'N/A',
                      style: style.labelSmall,
                    ),
                    Text(item.turn ?? 'N/A',
                        style: style.labelSmall
                            ?.copyWith(color: colorsAd, fontSize: 12)),
                  ],
                ),
              ],
            ),
            item.listPermission!.isEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/mala-critica.png',
                          height: 25, width: 25),
                      const SizedBox(width: 10),
                      Text('Sin permisos',
                          style: style.labelSmall?.copyWith(color: Colors.red))
                    ],
                  )
                : const SizedBox(),
            hasPermissionUsuario(
                    currentUsers!.listPermission!, "admin", "crear")
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EdittingUsers(userEdit: item)),
                                );
                              },
                              child: Text('Editar',
                                  style: style.labelLarge
                                      ?.copyWith(color: Colors.black45))),
                          const SizedBox(width: 10),
                          customButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditedUserPermision(
                                        item: item,
                                        listPermission: listPermission)),
                              );
                            },
                            colorText: Colors.white,
                            colors: colorsAd,
                            textButton: 'Permitir',
                            width: 85,
                          )
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
