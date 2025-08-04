import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '/src/util/commo_pallete.dart';
import 'dart:io';

import '../folder_incidencia_main/model_incidencia/incidencia_main.dart';

String formatDate(DateTime date) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(date);
}

bool isValidEmail(String email) {
  final RegExp regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  return regex.hasMatch(email);
}

Future<void> showCustomDialog(
    BuildContext context, String title, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

String formatCurrency(double amount) {
  return '\$${amount.toStringAsFixed(2)}';
}

Widget buildStyledDropdown({
  required String label,
  required String? value,
  required List<String> items,
  required void Function(String?) onChanged,
  required TextTheme style,
  required Color color,
  required IconData icon,
  double? height = 40,
  double? width = 200,
}) {
  return Container(
    height: height,
    width: width,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(0),
      border: Border.all(color: color, width: 1),
    ),
    child: DropdownButton<String>(
      focusColor: Colors.transparent, // 🔹 Quita el color de fondo en focus
      focusNode: FocusNode(
          skipTraversal: true,
          canRequestFocus: false), // 🔹 Evita que se marque con rectángulo
      value: value,
      hint: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(label, style: style.bodySmall?.copyWith(color: color)),
        ],
      ),
      icon: Icon(Icons.arrow_drop_down, color: color),
      dropdownColor: Colors.white,
      style: style.bodySmall?.copyWith(color: Colors.black),

      items: items.map((m) {
        return DropdownMenuItem<String>(
          value: m,
          child: Text(m, style: style.bodySmall),
        );
      }).toList(),
      onChanged: onChanged,
    ),
  );
}

class EstadoChip extends StatelessWidget {
  final String estado;

  const EstadoChip({super.key, required this.estado});
  @override
  Widget build(BuildContext context) {
    // Color color = switch (estado.toLowerCase()) {
    //   'en revision' => Colors.orange,
    //   'pendiente' => Colors.grey,
    //   'pausado' => Colors.red,
    //   'en proceso' => Colors.green,
    //   'completado' => Colors.blueAccent,
    //   _ => Colors.grey,
    // };

    return Chip(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      label: Text(estado.toUpperCase(),
          style: const TextStyle(color: Colors.white)),
      backgroundColor: estadoHojaColores[estado] ?? Colors.grey,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

Widget buildStyledDropdownFormField<T>({
  required String label,
  required T? value,
  required List<T> items,
  required void Function(T?) onChanged,
  required TextTheme style,
  required Color color,
  required IconData icon,
  String Function(T)? getItemLabel, // para mostrar nombre
  String? Function(T?)? validator,
  double height = 40,
}) {
  return Container(
    height: height,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(2),
      border: Border.all(color: color, width: 0),
    ),
    child: DropdownButton<T>(
      focusColor: Colors.transparent, // 🔹 Quita el color de fondo en focus
      focusNode: FocusNode(
          skipTraversal: true,
          canRequestFocus: false), // 🔹 Evita que se marque con rectángulo
      value: value,
      hint: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(label, style: style.bodySmall?.copyWith(color: color)),
        ],
      ),
      icon: Icon(Icons.arrow_drop_down, color: color),
      dropdownColor: Colors.white,
      style: style.bodySmall?.copyWith(color: Colors.black),

      items: items.map((m) {
        return DropdownMenuItem<T>(
          value: m,
          child: Text(m.toString(), style: style.bodySmall),
        );
      }).toList(),
      onChanged: onChanged,
    ),
  );
}

const shadow =
    BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 10);
Widget buildTextFieldValidator(
    {String? hintText,
    required String label,
    TextEditingController? controller,
    List<TextInputFormatter>? inputFormatters,
    TextInputType keyboardType = TextInputType.text,
    Function? onChanged,
    Function? onEditingComplete,
    bool? readOnly,
    Color? color = Colors.white,
    double? width}) {
  return Container(
    color: color,
    height: 50,
    width: width ?? 250,
    margin: const EdgeInsets.symmetric(vertical: 5),
    child: TextFormField(
      readOnly: readOnly ?? false,
      onChanged: onChanged == null ? null : (val) => onChanged(val),
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese $label';
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: hintText,
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15.0)),
      onEditingComplete:
          onEditingComplete == null ? null : () => onEditingComplete(),
    ),
  );
}

Future waitingTime(Duration duration) async {
  await Future.delayed(duration);
}

DateTime calculateNextPaymentDate(DateTime startDate, String paymentMode) {
  DateTime nextPaymentDate;

  switch (paymentMode.toLowerCase()) {
    case 'semanal':
      nextPaymentDate = startDate.add(const Duration(days: 7));
      break;
    case 'quincenal':
      nextPaymentDate = startDate.add(const Duration(days: 14));
      break;
    case 'mensual':
      nextPaymentDate =
          DateTime(startDate.year, startDate.month + 1, startDate.day);
      // Ajusta el día del mes si supera el número de días en el mes siguiente
      if (nextPaymentDate.month != startDate.month + 1) {
        nextPaymentDate = DateTime(nextPaymentDate.year, nextPaymentDate.month,
            0); // Último día del mes
      }
      break;
    default:
      throw ArgumentError(
          'Modo de pago no válido. Debe ser "semanal", "quincenal" o "mensual".');
  }

  return nextPaymentDate;
}

DateTime _startDate = DateTime.now();
DateTime _endDate = DateTime.now();

Future<void> selectDateRange(BuildContext context, final Function press) async {
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

///metodo para extraer la semana correspondientes
Map<String, String> getWeekDates(DateTime date) {
// Obtener el lunes de la semana a la que pertenece la fecha
  DateTime monday = date.subtract(Duration(days: date.weekday - 1));

  // Obtener el domingo de la semana a la que pertenece la fecha
  DateTime sunday = monday.add(const Duration(days: 6));

  // Formatear las fechas
  String formattedMonday = DateFormat('yyyy-MM-dd').format(monday);
  String formattedSunday = DateFormat('yyyy-MM-dd').format(sunday);
  // Crear un mapa con la fecha de inicio y fin
  return {
    'start': formattedMonday,
    'end': formattedSunday,
  };
}

///metodo para extraer el anual fecha correspondientes
Map<String, String> getDateComplete(DateTime date) {
  // Primer día del año
  DateTime firstDayOfYear = DateTime(date.year, 1, 1);

  // Último día del año
  DateTime lastDayOfYear = DateTime(date.year, 12, 31);

  // Formateador para mostrar las fechas en el formato 'yyyy-MM-dd'
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  return {
    'start': formatter.format(firstDayOfYear),
    'end': formatter.format(lastDayOfYear),
  };
}

String quitarAcentos(String texto) {
  const Map<String, String> acentos = {
    'á': 'a',
    'é': 'e',
    'í': 'i',
    'ó': 'o',
    'ú': 'u',
    'Á': 'A',
    'É': 'E',
    'Í': 'I',
    'Ó': 'O',
    'Ú': 'U',
    'ñ': 'n',
    'Ñ': 'N',
    'ü': 'u',
    'Ü': 'U',
  };

  return texto.split('').map((c) => acentos[c] ?? c).join();
}

String getMonthLetter(String fecha) {
  List<String> nombresMeses = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];
  String nombreMes = nombresMeses[DateTime.parse(fecha).month - 1];
  return nombreMes.toUpperCase();
}

String limitarTexto(String texto, int maxCaracteres) {
  if (texto.length <= maxCaracteres) return texto;
  return '${texto.substring(0, maxCaracteres)}...';
}

Widget customButton(
        {double? width,
        Color? colors,
        Color? colorText,
        required VoidCallback? onPressed,
        String? textButton}) =>
    SizedBox(
      width: width ?? 250,
      child: ElevatedButton(
        // style: styleButton,
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.resolveWith((states) => colors),
            shape: MaterialStateProperty.resolveWith((states) =>
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero))),
        onPressed: onPressed,
        child: Text(textButton ?? 'N/A',
            style: TextStyle(color: colorText ?? Colors.white)),
      ),
    );
void viewUsuario(context, List<ListUsuarioResponsable>? colection) async {
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          content: Padding(
            padding: const EdgeInsets.all(25),
            child: DataTable(
              dataRowMaxHeight: 20,
              dataRowMinHeight: 15,
              horizontalMargin: 10.0,
              columnSpacing: 15,
              headingRowHeight: 20,
              decoration: const BoxDecoration(color: colorsPuppleOpaco),
              headingTextStyle: const TextStyle(color: Colors.white),
              border: TableBorder.symmetric(
                  outside: BorderSide(
                      color: Colors.grey.shade100, style: BorderStyle.none),
                  inside: const BorderSide(
                      style: BorderStyle.solid, color: Colors.grey)),
              columns: const [
                DataColumn(label: Text('Empleado')),
                DataColumn(label: Text('Codigo')),
              ],
              rows: colection!.asMap().entries.map((entry) {
                int index = entry.key;
                ListUsuarioResponsable report = entry.value;
                return DataRow(
                  color: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      // Alterna el color de fondo entre gris y blanco
                      if (index.isOdd) {
                        return Colors.grey
                            .shade300; // Color de fondo gris para filas impares
                      }
                      return Colors
                          .white; // Color de fondo blanco para filas pares
                    },
                  ),
                  cells: [
                    DataCell(Text(report.fullName ?? 'N/A')),
                    DataCell(Text(report.code ?? 'N/A')),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      });
}

void viewDepartment(
    context, List<ListDepartamentoResponsable>? colection) async {
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          content: Padding(
            padding: const EdgeInsets.all(25),
            child: DataTable(
              dataRowMaxHeight: 20,
              dataRowMinHeight: 15,
              horizontalMargin: 10.0,
              columnSpacing: 15,
              headingRowHeight: 20,
              decoration: const BoxDecoration(color: colorsBlueDeepHigh),
              headingTextStyle: const TextStyle(color: Colors.white),
              border: TableBorder.symmetric(
                  outside: BorderSide(
                      color: Colors.grey.shade100, style: BorderStyle.none),
                  inside: const BorderSide(
                      style: BorderStyle.solid, color: Colors.grey)),
              columns: const [
                DataColumn(label: Text('Departamento')),
                DataColumn(label: Text('Create at')),
              ],
              rows: colection!.asMap().entries.map((entry) {
                int index = entry.key;
                ListDepartamentoResponsable report = entry.value;
                return DataRow(
                  color: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      // Alterna el color de fondo entre gris y blanco
                      if (index.isOdd) {
                        return Colors.grey
                            .shade300; // Color de fondo gris para filas impares
                      }
                      return Colors
                          .white; // Color de fondo blanco para filas pares
                    },
                  ),
                  cells: [
                    DataCell(Text(report.departmentResponsable ?? 'N/A')),
                    DataCell(Text(report.createdAt ?? 'N/A')),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      });
}

bool isAndroidOrIOS() {
  return Platform.isAndroid || Platform.isIOS;
}

Future<bool?> showConfirmationDialogOnyAsk(
    BuildContext context, String message) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange), // Ícono
            SizedBox(width: 10),
            Text('Confirmación',
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        content: SizedBox(
          width: 250,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Cancelar', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.of(context).pop(false); // Devuelve falso si se cancela
            },
          ),
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.green),
            child: Text('Aceptar', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.of(context).pop(true); // Devuelve true si se acepta
            },
          ),
        ],
      );
    },
  );
}

class CustomLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color colorButton;
  final double? width;
  const CustomLoginButton(
      {super.key,
      this.width = 200,
      required this.onPressed,
      this.text = 'Registrar',
      this.colorButton = colorsBlueTurquesa});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 35,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorButton, // Azul oscuro como en la imagen
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          elevation: 3,
        ),
        onPressed: onPressed,
        child: Text(text,
            style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                letterSpacing: 1.4,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}

Future<void> pickSingleDate(
  BuildContext context,
  Function(String) onSelected,
) async {
  DateTime now = DateTime.now();

  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: now,
    firstDate: DateTime(2021),
    lastDate: DateTime(2100),
  );

  if (picked != null) {
    // Combinar la fecha elegida con la hora actual
    DateTime finalDateTime = DateTime(
      picked.year,
      picked.month,
      picked.day,
      now.hour,
      now.minute,
      now.second,
    );

    // Formato completo: yyyy-MM-dd HH:mm:ss
    String formatted = finalDateTime.toString().substring(0, 19);
    onSelected(formatted);
  }
}

bool validarFechas(String fechaCreacion, String fechaEntrega) {
  final DateTime creacion =
      DateTime.parse(fechaCreacion).subtract(Duration(days: 1));
  final DateTime entrega = DateTime.parse(fechaEntrega);

  return creacion.isBefore(entrega);
}

Color getColorByDepartment(String estado) {
  switch (estado.toUpperCase()) {
    case 'SUBLIMACIÓN':
    case 'SUBLIMACION': // por si viene sin tilde
      return turquesaSublimado;
    case 'PRINTER':
      return naranjaPrinter;
    case 'SASTRERIA':
      return verdeLimonSastreria;
    case 'CONFECCION':
      return lilaConfeccion;
    case 'BORDADO':
      return amarilloBordado;
    case 'SERIGRAFIA':
      return fucsiaSerigrafia;
    case 'COSTURA':
      return rojoCostura;
    case 'DISENO':
    case 'DISEÑO':
      return rojoCostura;
    default:
      return Colors.orange;
  }
}

final List<String> estadoHojaList = [
  'PENDIENTE'.toUpperCase(),
  'EN PROCESO'.toUpperCase(),
  'EN PRODUCCION'.toUpperCase(),
  'PAUSADO'.toUpperCase(),
  'COMPLETADO'.toUpperCase(),
  'CANCELADO'.toUpperCase(),
];
final Map<String?, Color> estadoHojaColores = {
  'PENDIENTE'.toUpperCase(): Colors.orange,
  'EN PROCESO'.toUpperCase(): Colors.blue,
  'EN PRODUCCION'.toUpperCase(): Colors.indigo,
  'PAUSADO'.toUpperCase(): Colors.grey,
  'COMPLETADO'.toUpperCase(): Colors.green,
  'CANCELADO'.toUpperCase(): Colors.red,
};
