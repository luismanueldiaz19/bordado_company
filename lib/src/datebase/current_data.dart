import 'dart:io';

import 'package:flutter/material.dart';
import '/src/model/users.dart';

String appTOKEN = "SMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";
Users? currentUsers;
// DateTime? dateActual = DateTime.now();

bool isUpdate = false;

const nameApp = 'Company Bordado';

const String pathLocal = 'bordado_backend';

const logoApp = 'assets/logo_lu.png';

const firmaLu = "assets/logo_lu.png";

enum OptionAdmin { admin, master, supervisor, boss }

const String onProducion = 'En Produción';
const String onEntregar = 'Por Entregar';
const String onParada = 'En Parada';
const String onFallo = 'En Error';
const String onDone = 'Listo';
const String onProceso = 'En Proceso';
const String onOutStatu = 'N/A';

List<String> accesoDepart = [];

String textConfirmacion = '👉🏼Esta Seguro Realizar El Pedido ? 👈🏼';
String eliminarMjs = '🥺Esta Seguro De Eliminar🥺';
String actionMjs = '👉🏼Esta Seguro De Confirmar El Tiempo ?👈🏼';
String confirmarMjs =
    '👉🏼Esta Seguro De Confirmar El Despacho De Las Facturas?👈🏼';

String confirmarFinished =
    '👉🏼Esta Seguro De Confirmar El Como Terminado?👈🏼';
List<String> ocupacionesList = [
  'Operador',
  'Digitador de bordado',
  'Asistente de producción',
  'Supervisor de producción',
  'Diseñador gráfico',
  'Control de calidad',
  'Encargado de almacén',
  'Personal de empaque',
  'Despachador',
  'Técnico de mantenimiento',
  'Vendedor',
  'Gerente de producción',
  'Asistente administrativo',
];
List<String> categoriesTurno = ['Turno A', 'Turno B', 'Sin Turno'];
bool validatorUser() {
  if (currentUsers?.occupation == OptionAdmin.admin.name ||
      currentUsers?.occupation == OptionAdmin.boss.name ||
      currentUsers?.occupation == OptionAdmin.master.name) {
    return true;
  }
  return false;
}

bool validateAdmin() {
  if (currentUsers?.occupation == OptionAdmin.boss.name ||
      currentUsers?.occupation == OptionAdmin.master.name) {
    return true;
  }
  return false;
}

bool validarContable() {
  return currentUsers?.code == '1302' ||
          currentUsers?.code == '199512' ||
          currentUsers?.code == '9876'
      ? true
      : false;
}

bool validarSupervisor() {
  return currentUsers?.occupation == OptionAdmin.admin.name ||
          currentUsers?.occupation == OptionAdmin.master.name ||
          currentUsers?.occupation == OptionAdmin.boss.name
      ? true
      : false;
}

bool validarMySelf(String? usuario) {
  return currentUsers?.fullName?.toUpperCase() == usuario?.toUpperCase()
      ? true
      : false;
}

class EmpresaLocal {
  String? nombreEmpresa;
  String? adressEmpressa;
  String? telefonoEmpresa;
  String? celularEmpresa;
  String? oficinaEmpres;
  String? rncEmpresa;
  String? nCFEmpresa;
  String? correoEmpresa;

  EmpresaLocal(
      {this.adressEmpressa,
      this.celularEmpresa,
      this.nombreEmpresa,
      this.oficinaEmpres,
      this.rncEmpresa,
      this.telefonoEmpresa,
      this.nCFEmpresa,
      this.correoEmpresa});
}

EmpresaLocal currentEmpresa = EmpresaLocal(
    adressEmpressa:
        'C. Beller #78, Puerto Plata 57000, Puerto Plata, República Dominicana',
    celularEmpresa: '829-733-7630',
    nombreEmpresa: 'Tejidos Tropical',
    oficinaEmpres: '(829) 733-7630',
    rncEmpresa: 'xxxxx-x',
    telefonoEmpresa: '829-733-7630',
    nCFEmpresa: 'A0100000001',
    correoEmpresa: 'Tejidos_Tropical_***@**.com');

// user : upload
// clave : tbsyomsyaasinjnjyeyye

// tbsyomsyaasinjnjyeyye

String obtenerSistemaOperativo() {
  if (Platform.isAndroid) {
    return 'Android';
  } else if (Platform.isIOS) {
    return 'iOS';
  } else if (Platform.isWindows) {
    return 'Windows';
  } else if (Platform.isLinux) {
    return 'Linux';
  } else if (Platform.isMacOS) {
    return 'macOS';
  } else {
    return 'Plataforma desconocida';
  }
}

// Widget identy(context) => Padding(
//       padding: const EdgeInsets.only(bottom: 40, top: 25),
//       child: Text("©$nameApp Created by LuDeveloper",
//           style: Theme.of(context).textTheme.bodySmall,
//           textAlign: TextAlign.center),
//     );

Widget identy(context) => Padding(
      padding: const EdgeInsets.only(bottom: 40, top: 25),
      child: Column(
        children: [
          Text("©$nameApp.".toUpperCase(),
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center),
          Text("Created by LUDEVELOPER".toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.black45, fontSize: 8),
              textAlign: TextAlign.center),
        ],
      ),
    );

List<String>? priorityList = ['NORMAL', 'EMERGENCIA', 'PRIORIDAD', 'AGREGADO'];

// Map<String, Color> priorityColors = {
//   'NORMAL': Colors.white, // Normal en blanco (puedes cambiar el color si quieres)
//   'HOJA VERDE': Colors.green.shade400, // Emergencia
//   'HOJA NARANJA': Colors.orange, // Prioridad
//   'HOJA AMARILLA': Colors.yellow.shade300 // Agregado
// };
Map<String, Color> priorityColors = {
  'NORMAL': Colors.white, // Cliente: NORMAL
  'EMERGENCIA': Colors.red.shade400, // Cliente: EMERGENCIA
  'PRIORIDAD': Colors.orange, // Cliente: PRIORIDAD
  'AGREGADO': Colors.yellow.shade300 // Cliente: AGREGADO
};

Map<String, IconData> priorityIcons = {
  'NORMAL': Icons.check_circle_outline,
  'EMERGENCIA': Icons.warning_amber_rounded,
  'PRIORIDAD': Icons.priority_high,
  'AGREGADO': Icons.add_circle_outline,
};

// String getClientePorPrioridad(String prioridad) {
//   switch (prioridad.toUpperCase()) {
//     case 'NORMAL':
//       return 'NORMAL';
//     case 'HOJA VERDE':
//       return 'EMERGENCIA';
//     case 'HOJA NARANJA':
//       return 'PRIORIDAD';
//     case 'HOJA AMARILLA':
//       return 'AGREGADO';
//     default:
//       return 'NORMAL';
//   }
// }



// Función para obtener el color según la prioridad
Color getColorPriority(String priorityName) {
  return priorityColors[priorityName] ??
      Colors.white; // Retorna gris si no coincide con ninguna prioridad
}

// /Hoja verde
// -- Hoja naranja
// -- Hoja amarilla
// -- Normal
