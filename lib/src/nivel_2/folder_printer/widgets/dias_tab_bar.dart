import 'package:flutter/material.dart';

import '../../../util/commo_pallete.dart';

class DiasTabBar extends StatefulWidget {
  final Function(String diaSeleccionado) onDiaSeleccionado;

  const DiasTabBar({super.key, required this.onDiaSeleccionado});

  @override
  State<DiasTabBar> createState() => _DiasTabBarState();
}

class _DiasTabBarState extends State<DiasTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> dias = [
    'Lunes',
    'Martes',
    'Miercoles',
    'Jueves',
    'Viernes',
    'Sabado',
    'Domingo'
  ];

  @override
  void initState() {
    super.initState();

    // 0 para Lunes ... 6 para Domingo
    int diaActualIndex = DateTime.now().weekday - 1;
    _tabController = TabController(
      length: dias.length,
      vsync: this,
      initialIndex: diaActualIndex,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      widget.onDiaSeleccionado(dias[_tabController.index]);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: TabBar(
        isScrollable: true,
        controller: _tabController,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black87,
        indicator: BoxDecoration(
          color: colorsOrange,
          borderRadius: BorderRadius.circular(8),
        ),
        labelStyle: const TextStyle(
          fontSize: 40, // Tamaño grande para TV
          fontWeight: FontWeight.bold, height: 1.0,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 36, // Tamaño grande para pestañas no seleccionadas
          height: 1.0,
        ),
        tabAlignment: TabAlignment.start,
        tabs: dias
            .map(
              (dia) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                child: Tab(text: dia),
              ),
            )
            .toList(),
      ),
    );
  }
}
