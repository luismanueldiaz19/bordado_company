import 'package:flutter/material.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/util/get_formatted_number.dart';

import '../../../widgets/pick_range_date.dart';
import '../../folder_re_orden/model/reorden.dart';

class ScreenAdminReOrden extends StatefulWidget {
  const ScreenAdminReOrden({super.key});

  @override
  State<ScreenAdminReOrden> createState() => _ScreenAdminReOrdenState();
}

class _ScreenAdminReOrdenState extends State<ScreenAdminReOrden> {
  String? firstDate = DateTime.now().toString().substring(0, 10);
  String? secondDate = DateTime.now().toString().substring(0, 10);
  List<ReOrden> listReOrden = [];
  Future<void> getReorden() async {
    setState(() {
      listReOrden.clear();
    });
    try {
      final res = await httpRequestDatabase(selectReOrdenAdmin,
          {'token': token, 'date1': firstDate, 'date2': secondDate});

      listReOrden = reOrdenFromJson(res.body);
      // print(res.body);

      if (!validatorUser()) {
        listReOrden = listReOrden
            .where((element) =>
                element.usuario?.toUpperCase() ==
                currentUsers?.fullName?.toUpperCase())
            .toList();
      }

      if (listReOrden.isEmpty) {
        // Si la lista está vacía, puedes mostrar un mensaje informativo
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontraron datos')),
        );
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      // Manejar errores generales
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
    setState(() {});
  }

  Future deleteFrom(ReOrden item) async {
    await httpRequestDatabase(deleteReOrden, {'id': item.id});
    // print(res.body);
    setState(() {
      listReOrden.remove(item);
    });
  }

  @override
  void initState() {
    getReorden();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final sized = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Avisos Entregas')),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          DateRangeSelectionWidget(
            press: (date1, date2) {
              setState(() {
                firstDate = date1;
                secondDate = date2;
                getReorden();
              });
              // getIncidencia(_firstDate, _secondDate);
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SizedBox(
              width: sized.width >= 700 ? sized.width * 0.50 : 350,
              child: SingleChildScrollView(
                child: Column(
                  children: listReOrden
                      .map((item) => Container(
                            color: Colors.grey.shade50,
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.logo ?? 'N/A',
                                    style: style.labelLarge),
                                Text('Ficha : ${item.ficha ?? 'N/A'}'),
                                Text(
                                    'Balance \$ ${getNumFormatedDouble(item.balance ?? 'N/A')}',
                                    style: style.labelLarge
                                        ?.copyWith(color: Colors.green)),
                                Text(item.infoCliente ?? 'N/A'),
                                Text('Programado : ${item.reorden ?? 'N/A'}',
                                    style: style.labelLarge),
                                Text(
                                    'Seguimiento Por ${item.usuario ?? 'N/A'}'),
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () => deleteFrom(item),
                                      child: const Text('Eliminar'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
          Container(
            height: 35,
            width: 250,
            decoration: const BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('BALANCE: '),
                    const SizedBox(width: 15),
                    Text(
                        '\$ ${getNumFormatedDouble(ReOrden.getBalanceTotal(listReOrden))}',
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
          identy(context),
        ],
      ),
    );
  }
}
