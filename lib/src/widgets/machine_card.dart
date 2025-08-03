import 'package:flutter/material.dart';
import '/src/model/machine.dart';
import '/src/widgets/menu_panel.dart';

class MachineCard extends StatelessWidget {
  const MachineCard({Key? key, required this.machine}) : super(key: key);
  final Machine machine;

  @override
  Widget build(BuildContext context) {
    final styleText =
        TextStyle(color: machine.isStop == 't' ? Colors.white : Colors.black);
    Row normalBotton(BuildContext context, String currentImagen) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              menuLateral('t' == 't' ? Icons.remove_red_eye : Icons.front_hand,
                  'Review', () {}, Colors.black45),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              menuLateral(Icons.report_problem, 'Reportar', () {}, Colors.red),
            ],
          )
        ],
      );
    }

    debugPrint(DateTime.now().toString().substring(0, 19));
    // print(machine.isStop);
    return Card(
      elevation: 8,
      color: machine.isStop == 't' ? Colors.red : Colors.white,
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  machine.isStop == 't'
                      ? const Icon(Icons.warning_outlined,
                          size: 50, color: Colors.white)
                      : Image.asset(
                          'assets/maquina.png',
                          scale: 2,
                        ),
                  Column(
                    children: [
                      Text(
                        'Maquina ${machine.numberMachine}',
                        style: styleText.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Modelo : ',
                                style: styleText,
                              ),
                              Text('Serial :', style: styleText),
                              Text('Type : ', style: styleText),
                              Text('Modulo : ', style: styleText),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Column(
                            children: [
                              Text(machine.modelo ?? 'N/A', style: styleText),
                              Text(machine.serial ?? 'N/A', style: styleText),
                              Text(machine.fabricante ?? 'N/A',
                                  style: styleText),
                              Text(machine.nameModulo ?? 'N/A',
                                  style: styleText),
                            ],
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
              machine.isStop == 't'
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                'Review',
                                style: styleText,
                              )),
                          const SizedBox(width: 15),
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                (states) => Colors.orange,
                              )),
                              onPressed: () {},
                              child: const Text('Reportar'))
                        ],
                      ),
                    )
                  : normalBotton(context, '')
            ],
          ),
        ),
      ),
    );
  }
}
