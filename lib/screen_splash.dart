import 'package:flutter/material.dart';
import 'src/sign_in_login.dart';
import 'src/widgets/loading.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  // final Future<Map<String, dynamic>> updateInfo = checkForUpdates();

  static Future<bool> checkForUpdates() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('_zoomAnimation ${_zoomAnimation?.value}');
    return Scaffold(
      body: FutureBuilder<bool>(
        future: checkForUpdates(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: Loading(text: 'Verificando Actualización'));
          } else if (snapshot.hasError || !snapshot.data!) {
            return const Center(
                child: Text('Error al obtener información de actualización'));
          }

          return const SignInLogin();
        },
      ),
    );
  }
}
