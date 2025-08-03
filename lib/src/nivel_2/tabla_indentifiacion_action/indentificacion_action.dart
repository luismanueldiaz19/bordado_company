import 'package:flutter/material.dart';

import '../../datebase/current_data.dart';

class IndetificacionAction extends StatelessWidget {
  const IndetificacionAction({Key? key, required this.press}) : super(key: key);
  final Function press;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.grey.shade100),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 7),
        child: Row(
          children: list
              .map(
                (identity) => SizedBox(
                  child: Column(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        color: identity.color,
                      ),
                      TextButton(
                          onPressed: () => press(identity.action),
                          child: Text(identity.action)),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

List<TablaIdentity> list = [
  TablaIdentity(action: onProducion, color: Colors.cyan),
  TablaIdentity(action: onEntregar, color: Colors.orangeAccent),
  TablaIdentity(action: onParada, color: Colors.redAccent),
  TablaIdentity(action: onFallo, color: Colors.black54),
  TablaIdentity(action: onDone, color: Colors.green),
  TablaIdentity(action: onProceso, color: Colors.teal),
  TablaIdentity(
      action: onOutStatu, color: const Color.fromARGB(255, 157, 196, 51)),
];

// onProducion, onEspera, onParada, onFallo, onDone, onOrden
class TablaIdentity {
  String action;
  Color color;
  TablaIdentity({required this.color, required this.action});
}
