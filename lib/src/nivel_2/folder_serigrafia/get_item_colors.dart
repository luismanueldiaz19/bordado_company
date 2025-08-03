import 'package:flutter/material.dart';

class GetItemColors extends StatefulWidget {
  const GetItemColors({Key? key, required this.value}) : super(key: key);
  final Function value;

  @override
  State<GetItemColors> createState() => _GetItemColorsState();
}

class _GetItemColorsState extends State<GetItemColors> {
  late int _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = 0;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: _selectedValue.toString(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedValue = int.parse(newValue!);
          });
          widget.value(_selectedValue.toString());
        },
        items: const [
          DropdownMenuItem(
            value: '0',
            child: Text('0'),
          ),
          DropdownMenuItem(
            value: '1',
            child: Text('1'),
          ),
          DropdownMenuItem(
            value: '2',
            child: Text('2'),
          ),
          DropdownMenuItem(
            value: '3',
            child: Text('3'),
          ),
          DropdownMenuItem(
            value: '4',
            child: Text('4'),
          ),
          DropdownMenuItem(
            value: '5',
            child: Text('5'),
          ),
          DropdownMenuItem(
            value: '6',
            child: Text('6'),
          ),
        ]);
  }
}
