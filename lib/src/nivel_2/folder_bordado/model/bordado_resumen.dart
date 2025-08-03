import '../../../util/get_time_relation.dart';

class BordadoResumen {
  String? empleado;
  String? maquina;
  String? puntada;
  String? pieza;
  String? percent;
  String? time;
  String? piezaMala;
  String? tiradas;

  BordadoResumen(
      {this.empleado,
      this.maquina,
      this.percent,
      this.pieza,
      this.puntada,
      this.time,
      this.piezaMala,
      this.tiradas});

  static String getTimeR(List<BordadoResumen> list) {
    List<String>? value = [];
    Duration sumaDurationTime = const Duration();
    // double minut = 0.0;
    for (var element in list) {
      value.add(element.time ?? '');
      // Duration durationTime = getTimeRelationDuration(
      //     element.fechaGeneralStarted ?? 'N/A',
      //     element.fechaGeneralEnd ?? 'N/A');

      // if (durationTime != 'N/A') {
      //   sumaDurationTime += durationTime;
      // }
    }
    // print('minute  Promedio : $minut');
    var durationValue = sumDurations(value);
    return durationValue.toString();
  }

  static int calcularTotalPieza(List<BordadoResumen> list) {
    int value = 0;
    for (var element in list) {
      value = value += int.parse(element.pieza ?? '0');
    }
    return value;
  }

  static int calcularTotalPuntada(List<BordadoResumen> list) {
    int value = 0;
    for (var element in list) {
      value = value += int.parse(element.puntada ?? '0');
    }
    return value;
  }

  static int calcularTotalMala(List<BordadoResumen> list) {
    int value = 0;
    for (var element in list) {
      value = value += int.parse(element.piezaMala ?? '0');
    }
    return value;
  }

  static Duration sumDurations(List<String> durations) {
    Duration totalDuration = const Duration();

    for (String durationString in durations) {
      List<String> parts = durationString.split(':');

      if (parts.length == 3) {
        // Horas, minutos y segundos
        int hours = int.parse(parts[0]);
        int minutes = int.parse(parts[1]);
        double seconds = double.parse(parts[2]);

        totalDuration += Duration(
          hours: hours,
          minutes: minutes,
          seconds: seconds.toInt(),
          milliseconds: ((seconds % 1) * 1000).toInt(),
        );
      }
    }

    return totalDuration;
  }
}

class Factura {
  final String numeroFactura;
  final String fechaEmision;
  final String cliente;
  final List<BordadoResumen> items;

  Factura({
    required this.numeroFactura,
    required this.fechaEmision,
    required this.cliente,
    required this.items,
  });
}
