import 'package:flutter/material.dart';
import '/src/model/machine_stop.dart';
import '/src/model/machine_stop_record.dart';

class CardRecoredStopMachine extends StatefulWidget {
  const CardRecoredStopMachine(
      {Key? key, required this.current, required this.press})
      : super(key: key);
  final MachineStop current;
  final VoidCallback press;

  @override
  State<CardRecoredStopMachine> createState() => _CardRecoredStopMachineState();
}

class _CardRecoredStopMachineState extends State<CardRecoredStopMachine> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListTile(
        tileColor: Colors.grey.shade200,
        leading: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 50,
            minHeight: 50,
            maxWidth: 50,
            maxHeight: 50,
          ),
        ),
        title: Text('${widget.current.fullName}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Parada : ${widget.current.firstStop}',
                style: const TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ],
        ),
        dense: false,
        trailing: IconButton(
          onPressed: widget.press,
          icon: const Icon(
            Icons.timer,
            color: Colors.orange,
          ),
        ),
      ),
    );
  }
}

class CardRecoredStopMachineRecord extends StatefulWidget {
  const CardRecoredStopMachineRecord(
      {Key? key, required this.current, required this.sumedHour})
      : super(key: key);
  final MachineStopRecord current;
  final Function(Duration) sumedHour;

  @override
  State<CardRecoredStopMachineRecord> createState() =>
      _CardRecoredStopMachineRecordState();
}

class _CardRecoredStopMachineRecordState
    extends State<CardRecoredStopMachineRecord> {
  bool isDiferencial = false;
  String diferencialTime = 'Not Format';
  Duration? diferences;
  Future<void> getDiferencialDate() async {
    DateTime date1 = DateTime.now();
    if (widget.current.firstStop.toString().isEmpty) {
      date1 = DateTime.parse(
          widget.current.secondStart.toString().substring(0, 19));
    } else {
      date1 =
          DateTime.parse(widget.current.firstStop.toString().substring(0, 19));
    }
    // DateTime date1 =
    //     DateTime.parse(widget.current.firstStop.toString().substring(0, 19));
    DateTime date2 =
        DateTime.parse(widget.current.secondStart.toString().substring(0, 19));
    diferences = date2.difference(date1);
    // print('La diferencias es :  : ${diferences?.inMinutes}');
    widget.sumedHour(
        diferences ?? const Duration(hours: 0, minutes: 0, seconds: 0));
  }

  @override
  void initState() {
    super.initState();
    getDiferencialDate();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListTile(
        leading: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 100,
            minHeight: 260,
            maxWidth: 104,
            maxHeight: 264,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 100,
              minHeight: 260,
              maxWidth: 104,
              maxHeight: 264,
            ),
            child: Center(child: Text(diferences.toString().substring(0, 7))),
          ),
        ),
        title: Text(widget.current.fullName.toString()),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Parada : ${widget.current.firstStop}',
                style: const TextStyle(color: Colors.red)),
            Text('${widget.current.fullName}'),
            Text('Corrida : ${widget.current.secondStart}',
                style: const TextStyle(color: Colors.green)),
            Text('comentario : ${widget.current.comment}',
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
        onLongPress: () {},
        dense: false,
      ),
    );
  }
}
