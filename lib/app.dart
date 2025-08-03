import 'package:bordado_company/src/datebase/current_data.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/src/nivel_2/folder_reception/provider_reception_planificacion.dart';
import '/src/folder_admin_user/services_provider_users.dart';
import '/src/provider/provider_sublimacion.dart';

import 'screen_splash.dart';
import 'src/folder_cliente_company/provider_clientes/provider_clientes.dart';
import 'src/nivel_2/folder_bordado/provider/provider_bordado.dart';
import 'src/nivel_2/folder_bordado/provider/provider_bordado_tirada.dart';
import 'src/nivel_2/folder_printer/printer_provider.dart';
import 'src/nivel_2/folder_satreria/provider/provider_sastreria.dart';
import 'src/nivel_2/folder_serigrafia/provider/provider_serigrafia.dart';
import 'src/provider/provider_department.dart';
import 'src/provider/provider_incidencia.dart';
import 'src/provider/provider_planificacion.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PrinterProvider()),
        ChangeNotifierProvider(create: (_) => ProviderDepartment()),
        ChangeNotifierProvider(create: (_) => ProviderPlanificacion()),
        ChangeNotifierProvider(create: (_) => ProviderIncidencia()),
        //ProviderIncidencia
        ChangeNotifierProvider(create: (_) => ProviderSublimacion()),
        ChangeNotifierProvider(create: (_) => ReceptionProviderPlanificacion()),
        ChangeNotifierProvider(create: (_) => ServicesProviderUsers()),
        ChangeNotifierProvider(create: (_) => ClienteProvider()),
        ChangeNotifierProvider(create: (_) => ProvideBordado()),
        ChangeNotifierProvider(create: (_) => ProviderBordadoTirada()),
        ChangeNotifierProvider(create: (_) => ProviderSastreria()),
        ChangeNotifierProvider(create: (_) => ProviderSerigrafia()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: nameApp,
          scrollBehavior: MyCustomScrollBehavior(),
          color: const Color.fromARGB(255, 233, 234, 238),
          theme: ThemeData(
              useMaterial3: true,
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: const Color.fromARGB(255, 233, 234, 238),
              buttonTheme: ButtonThemeData(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  minWidth: 150,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5)),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                    shape: WidgetStateProperty.resolveWith(
                      (states) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                    ),
                    padding: WidgetStateProperty.resolveWith((states) =>
                        const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5))),
              ),
              appBarTheme: AppBarTheme(
                  scrolledUnderElevation: 0.0,
                  backgroundColor: Colors.transparent,
                  titleTextStyle: Theme.of(context).textTheme.bodyLarge,
                  elevation: 0)),
          home: const ScreenSplash()),
    );
  }
}
