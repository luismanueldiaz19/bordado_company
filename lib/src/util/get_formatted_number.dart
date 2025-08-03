

import 'package:intl/intl.dart';

String getNumFormatedDouble(String numero) {
  double value = double.parse(numero);
  int numeroSimple = int.parse(value.toStringAsFixed(0));

  var formatter = NumberFormat('###,###,###');
  return formatter.format(numeroSimple);
}

String getNumFormated(int numero) {
  var formatter = NumberFormat('###,###,###');
  return formatter.format(numero);
}
