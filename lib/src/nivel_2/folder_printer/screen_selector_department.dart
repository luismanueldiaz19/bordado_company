import 'package:flutter/material.dart';
import '../../util/commo_pallete.dart';
import '../../datebase/current_data.dart';
import '../../datebase/methond.dart';
import '../../datebase/url.dart';
import '../../model/department.dart';
import '../../util/get_image_area.dart';
import '../../util/show_mesenger.dart';
import 'screen_printer.dart';

class ScreenSelectorDepartment extends StatefulWidget {
  const ScreenSelectorDepartment({super.key});

  @override
  State createState() => _ScreenSelectorDepartmentState();
}

class _ScreenSelectorDepartmentState extends State<ScreenSelectorDepartment> {
  List<Department> listFilter = [];
  List choosed = [];
  List filterList = [
    'Sublimación',
    'Diseño',
    'Serigrafia',
    'Sastreria',
    'Bordado',
    'Confección',
    'Printer',
    'Costura'
  ];
  Future getDepartmentNiveles() async {
    // final res = await httpRequestDatabase(selectDepartment, {'view': 'view'});
    // List<Department> list = departmentFromJson(res.body);
    // listFilter = list.where((element) {
    //   return filterList.contains(element.nameDepartment);
    // }).toList();
    // setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDepartmentNiveles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Departamentos'),
      ),
      body: Column(
        children: [
          listFilter.isNotEmpty
              ? Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Center(
                      child: Wrap(
                        spacing: -10.0,
                        runSpacing: -15.0,
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.start,
                        children: listFilter.map((item) {
                          //  Department current = item;
                          String image =
                              getImageAreas(int.parse(item.id.toString()));

                          return CardNivelDepartmentOther(
                              depart: item, image: image);
                        }).toList(),
                      ),
                    ),
                  ),
                )
              : const Center(child: Text('No hay Departamentos')),
          identy(context),
        ],
      ),
    );
  }
}

class CardNivelDepartmentOther extends StatefulWidget {
  const CardNivelDepartmentOther({super.key, this.depart, this.image});
  final Department? depart;
  final String? image;
  @override
  State<CardNivelDepartmentOther> createState() => _CardNivelDepartmentState();
}

class _CardNivelDepartmentState extends State<CardNivelDepartmentOther> {
  bool _isHovered = false;
  double width = 175;
  double height = 175;
  getNavigatorDepartment(Department? depart) {
    // print(depart?.nameDepartment ?? '');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ScreenPrinter(depart: depart)),
    );
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
