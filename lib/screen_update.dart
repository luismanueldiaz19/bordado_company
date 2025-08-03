import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '/src/datebase/methond.dart';
import '/src/util/commo_pallete.dart';
import 'package:url_launcher/url_launcher.dart';

import 'src/datebase/current_data.dart';
import 'src/datebase/url.dart';

class ScreenUpdState extends StatefulWidget {
  const ScreenUpdState({super.key});

  @override
  State<ScreenUpdState> createState() => _ScreenUpdStateState();
}

class _ScreenUpdStateState extends State<ScreenUpdState> {
  Map url = {
    'id': '',
    'path_android': '',
    'path_windows': '',
  };
  Future<void> _launchUrl() async {
    String sistemaOperativo = obtenerSistemaOperativo();
    if (sistemaOperativo == 'Android') {
      final Uri urlApp = Uri.parse(url['path_android']);
      if (!await launchUrl(urlApp)) {
        throw Exception('Could not launch $urlApp');
      }
    }
    if (sistemaOperativo == 'Windows') {
      final Uri urlApp = Uri.parse(url['path_windows']);
      if (!await launchUrl(urlApp)) {
        throw Exception('Could not launch $urlApp');
      }
    }
  }

  Future getPathDownload() async {
    final res = await httpRequestDatabase(selectPathDownload, {'view': 'view'});
    // print('path : ${res.body}');
    url = jsonDecode(res.body);
  }

  @override
  void initState() {
    getPathDownload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: double.infinity),
          BounceInDown(
              curve: Curves.elasticInOut,
              child: Image.asset('assets/actualizacion.png', scale: 4)),
          Text('Actualizacion Disponible !',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          SlideInRight(
            curve: Curves.elasticInOut,
            child: SizedBox(
              width: 150,
              child: FadeIn(
                child: ElevatedButton(
                  onPressed: () => _launchUrl(),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.resolveWith(
                        (states) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => colorsBlueDeepHigh)),
                  child: const Text('Descargar',
                      style: TextStyle(color: Colors.white, letterSpacing: 2)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
