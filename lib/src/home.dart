import 'package:flutter/material.dart';
import '/src/datebase/current_data.dart';
import '/src/drawer_admin/drawer_menu_custom.dart';
import '/src/widgets/nivel_widgets.dart';
import '/src/widgets/validar_screen_available.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return ValidarScreenAvailable(
      mobile: Scaffold(
        drawer: const DrawerMenuCustom(),
        appBar: AppBar(title: const Text(nameApp)),
        body: Column(
          children: [
            const SizedBox(width: double.infinity),
            Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text('Departments',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.grey))),
            const Expanded(child: NivelWidgets())
          ],
        ),
      ),
      windows: Scaffold(
        body: Row(
          children: [
            const DrawerMenuCustom(),
            Expanded(
                child: Column(
              children: [
                const Expanded(child: NivelWidgets()),
                identy(context),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
