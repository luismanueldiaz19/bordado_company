import 'package:flutter/material.dart';

class DateRangeSelectionWidget extends StatefulWidget {
  const DateRangeSelectionWidget({super.key, required this.press});
  final Function press;
  @override
  State<DateRangeSelectionWidget> createState() =>
      _DateRangeSelectionWidgetState();
}

class _DateRangeSelectionWidgetState extends State<DateRangeSelectionWidget> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2021),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        widget.press(_startDate.toString().substring(0, 10),
            _endDate.toString().substring(0, 10));
      });

      // Aquí puedes realizar la consulta a la base de datos con las fechas seleccionadas (_startDate y _endDate)
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return TextButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith((states) =>
              const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
          backgroundColor:
              MaterialStateProperty.resolveWith((states) => Colors.white)),
      onPressed: () => _selectDateRange(context),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: _startDate.toString().substring(0, 10),
                    style: style.bodyMedium?.copyWith(color: Colors.green)),
                TextSpan(
                    text: '  Entre  ', style: style.bodyMedium?.copyWith()),
                TextSpan(
                    text: _endDate.toString().substring(0, 10),
                    style: style.bodyMedium?.copyWith(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

DateTime _startDate = DateTime.now().subtract(const Duration(days: 1));
DateTime _endDate = DateTime.now().subtract(const Duration(days: 1));

Future<void> selectDateRangeNew(BuildContext context, final Function press) async {
  DateTimeRange? picked = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2021),
    lastDate: DateTime(2100),
    initialDateRange: DateTimeRange(
      start: _startDate,
      end: _endDate,
    ),
  );

  if (picked != null) {
    _startDate = picked.start;
    _endDate = picked.end;
    press(_startDate.toString().substring(0, 10),
        _endDate.toString().substring(0, 10));
  }
}
