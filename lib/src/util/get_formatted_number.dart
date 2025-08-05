import 'package:intl/intl.dart';

String getNumFormatedDouble(String numero) {
  double value = double.parse(numero);
  int numeroSimple = int.parse(value.toStringAsFixed(0));

  var formatter = NumberFormat('###,###,###');
  return formatter.format(numeroSimple);
}


String getNumFormatedUS(String numero) {
  double value = double.tryParse(numero) ?? 0.0;
  var formatter = NumberFormat('#,##0.00', 'en_US');
  return formatter.format(value);
}


String getNumFormated(int numero) {
  var formatter = NumberFormat('###,###,###');
  return formatter.format(numero);
}
