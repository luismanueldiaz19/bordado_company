String getTimeRelation(String date1, String date2) {
  Duration diferenciaTiempo = const Duration(seconds: 0);

  if (date1.isNotEmpty &&
      date2.isNotEmpty &&
      date1 != 'N/A' &&
      date2 != 'N/A') {
    DateTime fechaStarted = DateTime.parse(date1);
    DateTime fechaEnd = DateTime.parse(date2);

    diferenciaTiempo = fechaEnd.difference(fechaStarted);
  } else {
    return 'ERROR TIMER';
  }

  // / Imprime: 1:15:00
  return diferenciaTiempo.toString().substring(0, 8);
}

String getTimeRelationEnMin(String date1, String date2) {
  Duration diferenciaTiempo = const Duration(seconds: 0);

  if (date1.isNotEmpty &&
      date2.isNotEmpty &&
      date1 != 'N/A' &&
      date2 != 'N/A') {
    DateTime fechaStarted = DateTime.parse(date1);
    DateTime fechaEnd = DateTime.parse(date2);

    diferenciaTiempo = fechaEnd.difference(fechaStarted);
  } else {
    return '- MIN';
  }

  // Devuelve la diferencia en minutos con el formato "X MIN"
  return '${diferenciaTiempo.inMinutes} MIN';
}

Duration getTimeRelationDuration(String date1, String date2) {
  Duration diferenciaTiempo = const Duration(seconds: 0);

  if (date1.isNotEmpty &&
      date2.isNotEmpty &&
      date1 != 'N/A' &&
      date2 != 'N/A') {
    DateTime fechaStarted = DateTime.parse(date1);
    DateTime fechaEnd = DateTime.parse(date2);

    diferenciaTiempo = fechaEnd.difference(fechaStarted);
  } else {
    return const Duration(hours: 0, minutes: 0, seconds: 0);
  }

  // / Imprime: 1:15:00
  return diferenciaTiempo;
}

List<String> getStartAndEndOfMonth() {
  final now = DateTime.now();
  final firstDayOfMonth =
      DateTime(now.year, now.month, 1).toString().substring(0, 10);
  final lastDayOfMonth =
      DateTime(now.year, now.month + 1, 0).toString().substring(0, 10);
  return [firstDayOfMonth, lastDayOfMonth];
}

List<String> getStartParser(DateTime now) {
  final firstDayOfMonth =
      DateTime(now.year, now.month, 1).toString().substring(0, 10);
  final lastDayOfMonth =
      DateTime(now.year, now.month + 1, 0).toString().substring(0, 10);
  return [firstDayOfMonth, lastDayOfMonth];
}

List<String> getStartParserAnual(DateTime now) {
  final firstDayOfYear = DateTime(now.year, 1, 1).toString().substring(0, 10);
  final lastDayOfYear = DateTime(now.year, 12, 31).toString().substring(0, 10);
  return [firstDayOfYear, lastDayOfYear];
}


String obtenerNombreMes(String fecha) {
  // Lista de nombres de los meses en español
  List<String> nombresMeses = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];

  var dat = DateTime.parse(fecha);
  // Obtener el número del mes (1-12)
  int numeroMes = dat.month;

  // Obtener el nombre del mes correspondiente
  String nombreMes = nombresMeses[numeroMes - 1];

  return nombreMes;
}
