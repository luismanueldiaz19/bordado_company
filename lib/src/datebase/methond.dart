library database;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/src/datebase/url.dart';
import '/src/model/machine_stop.dart';
import '/src/model/machine_stop_record.dart';
import '/src/model/operation_modulo.dart';
import '/src/model/tirada.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future httpRequestDatabase(String url, Map<String, dynamic> map) async {
  var client = http.Client();

  var response = await client.post(Uri.parse(url), body: map);
  if (response.statusCode == 200) {
    client.close();
    return response;
  } else {
    client.close();
  }
}

Future<http.Response?> httpRequestDatabaseGET(String url) async {
  var client = http.Client();
  // Convertir los parámetros en una cadena de consulta (query string)
  var uri = Uri.parse(url);
  try {
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      return response; // Retornar la respuesta si el código de estado es 200
    } else {
      return null; // Retornar null si la solicitud falla
    }
  } catch (e) {
    debugPrint('Error en la solicitud GET: $e');
    return null; // Retornar null en caso de error
  } finally {
    client.close(); // Cerrar el cliente independientemente del resultado
  }
}

Future getListOperationModulo({idModulo}) async {
  final res =
      await httpRequestDatabase(selectOperationModulo, {'id_modulo': idModulo});
  // print(res.body);
  return operationModuloFromJson(res.body);
}

Future<List<MachineStop>> viewStopMachine(idMachine) async {
  // debugPrint('methond : view StopMachine');
  final res = await httpRequestDatabase(selectAddStopMachine, {
    'idMachine': idMachine,
  });
  return machineStopFromJson(res.body);
  // return machineFromJson(res.body);
}

Future<List<MachineStopRecord>> viewStopMachineRecord(
    idMachine, date1, date2) async {
  // debugPrint('methond : view StopMachine');
  final res = await httpRequestDatabase(selectAddStopMachineRecord, {
    'idMachine': idMachine,
    'date1': date1,
    'date2': date2,
  });
  // print('Las parada son ${res.body}');
  return machineStopRecordFromJson(res.body);
  // return machineFromJson(res.body);
}

Future<List<MachineStopRecord>> viewStopMachineRecordVerified(
    {numOrden}) async {
  // debugPrint('methond : view StopMachine');
  final res = await httpRequestDatabase(selectAddStopMachineRecordVerified, {
    'num_orden': numOrden,
  });
  return machineStopRecordFromJson(res.body);
  // return machineFromJson(res.body);
}

Future<List<Tirada>> viewTiradaVerified({numOrden}) async {
  // debugPrint('methond : view StopMachine');
  final res = await httpRequestDatabase(selectReanudarOrdenVerified, {
    'num_orden': numOrden,
  });
  return tiradaFromJson(res.body);
  // return machineFromJson(res.body);
}

Future httpEnviaMap(String url, var jsonData) async {
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonData,
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    return response.body;
  } else {
   throw Exception('Error en la solicitud POST: ${response.reasonPhrase}');
  }
}

Future httpEnviaMapPOST(String url, Map<String, String> formData) async {
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: formData,
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    return response.body;
  } else {
    throw Exception('Error en la solicitud POST: ${response.reasonPhrase}');
  }
}

Future<String> saveScreenshotToLocalFile(Uint8List image,
    {String? nameFile}) async {
  var directory = await getTemporaryDirectory();
  File file = File('${directory.path}/${nameFile}_screenshot.png');
  await file.writeAsBytes(image);
  return file.path;
}
