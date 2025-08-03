import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

getDayWritted(String? fecha) {
  Intl.defaultLocale = 'es'; // Configura el idioma por defecto
  initializeDateFormatting(
      Intl.defaultLocale!); // Inicializa los datos de localización
  late DateFormat? format = DateFormat.EEEE();
  var dateString = format.format(
      DateTime.parse(fecha ?? DateTime.now().toString().substring(0, 10)));
  return dateString.toUpperCase();
}
