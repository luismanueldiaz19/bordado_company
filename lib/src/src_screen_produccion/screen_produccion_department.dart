import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:bordado_company/src/services/api_services.dart';
import 'package:flutter/material.dart';
import '../model/orden_work.dart';
import '../util/show_mesenger.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/url.dart';
import '/src/model/department.dart';
import '../widgets/card_sublimacion.dart';
import '/src/util/commo_pallete.dart';
import '/src/util/helper.dart';
import '/src/widgets/validar_screen_available.dart';
import '../widgets/loading.dart';
import '../widgets/pick_range_date.dart';

class ScreenProduccionDepartment extends StatefulWidget {
  const ScreenProduccionDepartment({super.key, required this.current});
  final Department current;

  @override
  State<ScreenProduccionDepartment> createState() =>
      _ScreenProduccionDepartmentState();
}

class _ScreenProduccionDepartmentState
    extends State<ScreenProduccionDepartment> {
  String? _secondDate = DateTime.now().toString().substring(0, 10);
  String? _firstDate = DateTime.now().toString().substring(0, 10);

  final ApiService _apiService = ApiService();

  bool isCombine = false;
  List<OrdenWork> listFilter = [];
  List<OrdenWork> list = [];
  String typeTrabajo = '';
  String usuario = '';

  // List<OrdenWork> ordenWorkFromJson(

  @override
  void initState() {
    super.initState();
    getWork();
  }

  Future getWork({bool? isRecord = false}) async {
    setState(() {
      listFilter.clear();
      list.clear();
    });

    String url = isRecord!
        ? 'http://$ipLocal/$pathLocal/produccion/get_produccion_by_depart_by_date.php'
        : 'http://$ipLocal/$pathLocal/produccion/get_produccion_by_depart.php';

    final valueBody = await _apiService.httpEnviaMap(url, {
      'id_depart': widget.current.id,
      'start_date_from': _firstDate,
      'start_date_to': _secondDate,
    });

    final value = json.decode(valueBody);

    if (value['success']) {
      print(json.encode(value['data']));

      list = ordenWorkFromJson(json.encode(value['data']));
      listFilter = [...list];
      setState(() {});
    }

    // String selectSublimacionWorkFinishedbydate =
    //     "http://$ipLocal/settingmat/admin/select/select_sublimacion_work_finished_by_date.php";
    // final res = await httpRequestDatabase(
    //     'http://$ipLocal/settingmat/admin/select/select_sublimacion_work_finished_by_date.php',
    //     {'id_depart': widget.current.id, 'date1': date1, 'date2': date2});

    // // print(res.body);
    // list = sublimaFromJson(res.body);
    // listFilter = [...list];
    // setState(() {});
  }

  //get_produccion_by_depart_by_date

  Future deleteFromSublima(id) async {
    bool? value = await showConfirmationDialogOnyAsk(context, eliminarMjs);
    if (value != null && value) {
      final jsonDataLocal = {'hoja_produccion_id': id};
      await eliminarItem(jsonDataLocal);
    }
  }

  Future eliminarItem(jsonDataLocal) async {
    // print(item.toJson());
    final value = await _apiService.httpEnviaMap(
        'http://$ipLocal/$pathLocal/produccion/eliminar_producion_campos.php',
        jsonDataLocal);
    // print(value);
    final r = json.decode(value);
    showScaffoldMessenger(
        context, r['message'], r['success'] ? Colors.green : Colors.red);
    getWork();
  }

  String nombrePicked = '';
  String workPicked = '';
  normalizarList() {
    setState(() {
      nombrePicked = '';
      workPicked = '';
      listFilter = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final styte = Theme.of(context).textTheme;

    // print(widget.current.toJson());
    const shadow =
        BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 10);
    const String textInfo =
        'Fábrica textil especializada en bordado, sublimación, sastrería y confección. Comprometidos con la calidad y la innovación en cada prenda.';
    final screenMobile = Column(
      children: [
        SizedBox(width: double.infinity, height: 5),
        SlideInRight(
          curve: Curves.elasticInOut,
          child: buildTextFieldValidator(
            // onChanged: (val) => searching(val),
            hintText: 'Buscar',
            label: 'Ficha/orden',
          ),
        ),
        SizedBox(
          height: 40,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: OrdenWork.depurarEmpleados(list)
                  .map(
                    (value) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: nombrePicked == value
                              ? Colors.blue
                              : Colors.white,
                          boxShadow: const [shadow]),
                      child: TextButton(
                        child: Text(value,
                            style: TextStyle(
                                color: nombrePicked == value
                                    ? Colors.white
                                    : colorsAd)),
                        onPressed: () {
                          nombrePicked = value;
                          workPicked = '';
                          // searchingEmploye(nombrePicked);
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 40,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: OrdenWork.depurarTypeWork(listFilter)
                  .map(
                    (value) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: workPicked == value
                              ? Colors.orange
                              : Colors.white,
                          boxShadow: const [shadow]),
                      child: TextButton(
                        child: Text(value,
                            style: TextStyle(
                                color: workPicked == value
                                    ? Colors.white
                                    : colorsAd)),
                        onPressed: () {
                          workPicked = value;
                          if (nombrePicked != '') {
                            // searchingWorkAndEmpleado();
                          } else {
                            // searchingTypeWork(workPicked);
                          }
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 5),
        //// lista de los  trabajo de la machines
        listFilter.isNotEmpty
            ? Expanded(
                child: SizedBox(
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: listFilter.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        OrdenWork current = listFilter[index];
                        return CardSublimacion(
                          current: current,
                          eliminarPress: (OrdenWork element) {
                            deleteFromSublima(element.hojaProduccionId);
                          },
                        );
                      },
                    ),
                  ),
                ),
              )
            : const LoadingNew(scale: 5, imagen: 'assets/actualizacion.png'),
        const SizedBox(height: 10),
        ////Total de la pieza y maquina
        // identy(context)
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.current.nameDepartment ?? 'N/A'),
        actions: [
          Tooltip(
            message: 'Quitar filtro',
            child: IconButton(
                icon: Icon(
                    nombrePicked != '' || workPicked != ''
                        ? Icons.filter_alt_off_outlined
                        : Icons.filter_alt_outlined,
                    color: nombrePicked != '' || workPicked != ''
                        ? Colors.red
                        : Colors.black),
                onPressed: normalizarList),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
                icon: const Icon(Icons.calendar_month_outlined,
                    color: Colors.black),
                onPressed: () {
                  selectDateRangeNew(context, (date1, date2) {
                    setState(() {
                      _firstDate = date1.toString();
                      _secondDate = date2.toString();
                    });
                    getWork(isRecord: true);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: const Icon(Icons.print, color: Colors.black),
              onPressed: () async {
                if (listFilter.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('En desarrollo'),
                      duration: Duration(seconds: 1),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  // final pdfFile =
                  //     await PdfInventarioGeneral.generate(listInventarioFilter);

                  // PdfApi.openFile(pdfFile);
                }
              },
            ),
          ),
        ],
      ),
      body: ValidarScreenAvailable(
        mobile: screenMobile,
        windows: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: screenMobile),
                  Expanded(
                    child: SizedBox(
                      // color: Colors.blue,
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BounceInDown(
                                    curve: Curves.elasticOut,
                                    child: Image.asset(
                                        'assets/lista-de-tareas.png',
                                        scale: 4)),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    child: SizedBox(
                                      width: 250,
                                      child: Text(
                                        textInfo,
                                        textAlign: TextAlign.justify,
                                        style: styte.bodySmall,
                                      ),
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 50),
                                  child: SizedBox(
                                    width: 250,
                                    child: Text('Lo mejor de ti continua..',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.grey)),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Container(
                                //   width: 200,
                                //   decoration: BoxDecoration(
                                //     color: Colors.white,
                                //     borderRadius: BorderRadius.circular(50),
                                //     boxShadow: const [shadow],
                                //   ),
                                //   child: TextField(
                                //     onChanged: (value) => {},
                                //     decoration: InputDecoration(
                                //         hintText:
                                //             'Buscar', // Texto de ayuda más descriptivo
                                //         border: InputBorder
                                //             .none, // Mantiene sin borde el campo de texto
                                //         suffixIcon: Icon(Icons.search,
                                //             color: Colors.grey[600],
                                //             size:
                                //                 24), // Estiliza el icono de búsqueda
                                //         contentPadding: const EdgeInsets.only(
                                //             left: 25, top: 10)),
                                //   ),
                                // ),
                                // const SizedBox(height: 10),
                                const Divider(indent: 100, endIndent: 100),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Trabajos : ${listFilter.length}',
                                        style: styte.bodyLarge?.copyWith(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text(
                                    //     'Piezas : ',
                                    //     style: styte.bodyLarge?.copyWith(
                                    //       color: Colors.black54,
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            identy(context)
          ],
        ),
      ),
    );
  }
}
