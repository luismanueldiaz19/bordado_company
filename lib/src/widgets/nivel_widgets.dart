import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../src_screen_produccion/screen_produccion_department.dart';
import '/src/util/commo_pallete.dart';
import '../datebase/current_data.dart';
import '../model/department.dart';
import '../provider/provider_department.dart';
import '../util/get_image_area.dart';
import '../util/show_mesenger.dart';

class NivelWidgets extends StatefulWidget {
  const NivelWidgets({super.key});

  @override
  State<NivelWidgets> createState() => _NivelWidgetsState();
}

class _NivelWidgetsState extends State<NivelWidgets> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<ProviderDepartment>(context, listen: false)
          .getDepartmentNiveles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    List<Department> list = context.watch<ProviderDepartment>().list;
    return list.isNotEmpty
        ? SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Wrap(
                spacing: -10.0,
                runSpacing: -15.0,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.start,
                children: list.map(
                  (item) {
                    String image = getImageAreas(int.parse(item.id.toString()));
                    return CardNivelDepartment(depart: item, image: image);
                  },
                ).toList()),
          )
        : const Center(child: Text('No hay Departamentos'));
  }
}

class CardNivelDepartment extends StatefulWidget {
  const CardNivelDepartment({super.key, this.depart, this.image});
  final Department? depart;
  final String? image;
  @override
  State<CardNivelDepartment> createState() => _CardNivelDepartmentState();
}

class _CardNivelDepartmentState extends State<CardNivelDepartment> {
  bool _isHovered = false;
  double width = 175;
  double height = 175;
  void getNavigatorDepartment(Department current) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ScreenProduccionDepartment(current: current)));

    // switch (current.id) {
    //   case '1':
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) =>
    //                 ScreenProduccionDepartment(current: current)));
    //     break;

    //   case '10':
    //     // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     //     content: Text('Modulo en Proceso'),
    //     //     duration: Duration(milliseconds: 500)));

    //     // Navigator.push(context,
    //     //     MaterialPageRoute(builder: (context) => const ScreenPrinter()));

    //     break;
    //   case '3':
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => SerigrafiaDepart(current: current)));
    //     break;
    //   case '4':
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => ScreenSastreriaReport(current: current)));
    //     break;
    //   case '5':
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => ScreenBordado(current: current)));

    //     // Navigator.push(
    //     //     context,
    //     //     MaterialPageRoute(
    //     //         builder: (context) => SerigrafiaNivelDos(current: current)));
    //     break;
    //   case '6':
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => ScreenSastreriaReport(current: current)));
    //     // Navigator.push(
    //     //     context,
    //     //     MaterialPageRoute(
    //     //         builder: (context) => ScreenConfecion(current: current)));
    //     break;
    //   case '7':
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => ScreenAlmacen(current: current)));
    //     break;

    //   case '8':
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => const ScreenReceptionEntregas()));
    //     break;

    //   case '9':
    //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //         content: Text('Modulo no definidos'),
    //         duration: Duration(milliseconds: 500)));
    //     break;
    //   case '10':
    //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //         content: Text('Modulo en estructura de nuevo'),
    //         duration: Duration(milliseconds: 500)));
    //     // Navigator.push(
    //     //     context,
    //     //     MaterialPageRoute(
    //     //         builder: (context) => ScreenModelPrinter(current: current)));

    //     break;
    // }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return MouseRegion(
      onEnter: (_) => setState(() {
        _isHovered = true;
        width = 190; // Ajustamos el tamaño al hacer hover
        height = 190;
      }),
      onExit: (_) => setState(() {
        _isHovered = false;
        width = 175; // Tamaño original
        height = 175;
      }),
      child: GestureDetector(
        onTap: () {
          currentUsers!.type
                      .toString()
                      .contains(widget.depart?.type ?? 'n'.toString()) ||
                  currentUsers!.type.toString().contains('t')
              ? getNavigatorDepartment(widget.depart!)
              : () {};
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300), // Animación más rápida
          width: _isHovered ? width : 175, // Tamaño con hover y sin hover
          height: _isHovered ? height : 175,
          curve: Curves.easeInOut, // Suavizamos la animación
          color: _isHovered ? colorsBlueTurquesa : Colors.white,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.all(11),

          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                    child: Image.asset(widget.image!, fit: BoxFit.cover)),
              ),
              const Positioned.fill(
                child: Material(color: Colors.black45),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    widget.depart!.nameDepartment.toString(),
                    style: style.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    widget.depart!.type.toString().toUpperCase(),
                    style: style.bodySmall?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              currentUsers!.type
                          .toString()
                          .contains(widget.depart!.type ?? '0'.toString()) ||
                      currentUsers!.type.toString().contains('t')
                  ? Container()
                  : GestureDetector(
                      onTap: () => utilShowMesenger(
                          context, 'Area Bloqueada Solicitar al Administrador',
                          title: 'Información'),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: Icon(Icons.lock, color: Colors.red, size: 50),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
