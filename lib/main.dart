//import 'dart:convert';

import 'package:flutter/material.dart';
import '/app.dart';
//import 'package:http/http.dart' as http;
// import '/src/datebase/current_data.dart';

void main() {
  runApp(const MyApp());
}

// Future getGlobalDateTime() async {
//   String endpoint =
//       'https://timeapi.io/api/Time/current/zone?timeZone=America/Santo_Domingo';

//   http.Response response = await http.get(Uri.parse(endpoint));
//   // print(response.body);
//   if (response.statusCode == 200) {
//     var json = jsonDecode(response.body);
//     final year = json['year'];
//     final month = json['month'];
//     final day = json['day'];
//     final hour = json['hour'];
//     final minute = json['minute'];
//     final seconds = json['seconds'];
//     final milliSeconds = json['milliSeconds'];
//     dateActual =
//         DateTime(year, month, day, hour, minute, seconds, milliSeconds);
//   } else {
//     // print('No hay Red Internet');
//   }
// }
