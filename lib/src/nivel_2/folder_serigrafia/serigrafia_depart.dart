import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/src/datebase/current_data.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/model/department.dart';
import '/src/model/type_work.dart';
import '/src/nivel_2/folder_serigrafia/online_serigrafia_work.dart';
import '/src/util/commo_pallete.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'folder_reporte_generales_serigrafia/serigrafia_reporte_generales.dart';
import 'resumen_serigrafia.dart';
import 'seriagrafia_historial.dart';

class SerigrafiaDepart extends StatefulWidget {
  const SerigrafiaDepart({super.key, required this.current});
  final Department current;

  @override
  State<SerigrafiaDepart> createState() => _SerigrafiaDepartState();
}

class _SerigrafiaDepartState extends State<SerigrafiaDepart> {
  TextEditingController controllerOrden = TextEditingController();
  TextEditingController controllerLogo = TextEditingController();
  TextEditingController controllerFicha = TextEditingController();
  TextEditingController controllerCantOrden = TextEditingController();
  List<TypeWork> listTypeWork = [];

  Future selectTypeWorkMethond() async {
    listTypeWork.clear();
    final res = await httpRequestDatabase(
        selectTypeWorkByKey, {'id_key': widget.current.idKeyWork});
    // print('List de Type Work ${res.body}');
    listTypeWork = typeWorkFromJson(res.body);
    // print(listTypeWork.length);
    if (listTypeWork.isNotEmpty) {
      setState(() {});
    }
  }

  // bool idType = false;

  @override
  void initState() {
    super.initState();
    // _chosenValue = 'Android';
    selectTypeWorkMethond();
    // getInfoMati();
  }

  // getInfoMati() async {
  //   String selectTest =
  //       "http://$ipLocal/tejidos/admin/select/select_test.php";
  //   final res = await httpRequestDatabase(selectTest, {'view': 'view'});
  //   print('Grafici ${res.body}');
  // }

  @override
  void dispose() {
    super.dispose();
    controllerOrden.dispose();
    controllerLogo.dispose();
    controllerFicha.dispose();
    controllerCantOrden.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // double sizeObtenido = getSize(size.width);

    return Scaffold(
        appBar: AppBar(title: const Text('Serigrafia')),
        body: Column(
          children: [
            const SizedBox(width: double.infinity),
            SizedBox(
              height: 75,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => OnlineSerigrafiaWork(
                                      current: widget.current,
                                    )),
                          );
                        },
                        child: Container(
                          height: 75,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white,
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Trabajos Online'),
                                Icon(Icons.online_prediction_outlined,
                                    color: Colors.green, size: 20)
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SeriagrafiaHistorial(
                                    current: widget.current)),
                          );
                        },
                        child: Container(
                          height: 75,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white,
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Detalles'),
                                Icon(Icons.description_sharp, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (conext) =>
                                      SerigrafiaReporteGenerales(
                                          current: widget.current,
                                          listTypeWork: listTypeWork)));
                        },
                        child: Container(
                          height: 75,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white,
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Viejo Reporte'),
                                Icon(Icons.cloud_outlined, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: '¿Desea agregar un nuevo trabajo?',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: ktejidogrey)),
                  TextSpan(
                      text: '  Click Abajo!',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: Colors.black45))
                ])),
            Expanded(
              child: SizedBox(
                width: size.width >= 750 ? size.width * 0.45 : size.width,
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    addAutomaticKeepAlives: false,
                    padding: const EdgeInsets.all(10.0),
                    itemCount: listTypeWork.length,
                    itemBuilder: (context, index) {
                      TypeWork current = listTypeWork[index];
                      String image =
                          "http://$ipLocal/settingmat/admin/imagen/${current.imagePath.toString()}";

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Material(
                          color: Colors.white,
                          child: ListTile(
                              leading: ConstrainedBox(
                                constraints: const BoxConstraints(
                                    maxHeight: 150,
                                    maxWidth: 150,
                                    minHeight: 100,
                                    minWidth: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Hero(
                                    tag: current.id.toString(),
                                    child: CachedNetworkImage(
                                      imageUrl: image,
                                      fit: BoxFit.cover,
                                      width: 200,
                                      height: 200,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          const SizedBox(
                                              height: 50,
                                              width: 50,
                                              child:
                                                  CircularProgressIndicator()),
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) {
                                      return MyWidgetAdd(
                                          currentTypeWork: current,
                                          image: image,
                                          department: widget.current);
                                    },
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return FadeTransition(
                                          opacity: animation, child: child);
                                    },
                                    transitionDuration:
                                        const Duration(milliseconds: 700),
                                    reverseTransitionDuration:
                                        const Duration(milliseconds: 500),
                                  ),
                                );

                                // MyWidgetAdd();
                              },
                              title: Text(current.typeWork.toString(),
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              subtitle: Text('ID : ${current.id.toString()}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.grey))),
                        ),
                      );
                    }),
              ),
            ),
            identy(context)
          ],
        ));
  }
}

class MyWidgetAdd extends StatefulWidget {
  const MyWidgetAdd(
      {super.key,
      required this.currentTypeWork,
      required this.department,
      required this.image});
  final TypeWork currentTypeWork;
  final String image;
  final Department department;
  @override
  State<MyWidgetAdd> createState() => _MyWidgetAddState();
}

class _MyWidgetAddState extends State<MyWidgetAdd> {
  TextEditingController controllerOrden = TextEditingController();
  TextEditingController controllerLogo = TextEditingController();
  TextEditingController controllerFicha = TextEditingController();
  TextEditingController controllerCantOrden = TextEditingController();
  bool isSending = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informacion del trabajo'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 175,
              width: 175,
              child: Hero(
                tag: widget.currentTypeWork.id.toString(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: 175,
                    height: 175,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    imageUrl: widget.image,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                            colorFilter: const ColorFilter.mode(
                                Colors.red, BlendMode.colorBurn)),
                      ),
                    ),
                    placeholder: (context, url) => const SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ),
            Text(widget.currentTypeWork.typeWork ?? 'N/A',
                style: Theme.of(context).textTheme.titleMedium),
            Divider(endIndent: size.width * 0.25, indent: size.width * 0.25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1.0)),
                    width: 250,
                    child: TextField(
                      enabled: !isSending,
                      controller: controllerLogo,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: 'Nombre del logo',
                        label: Text('Nombre del logo'),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1.0)),
                    width: 250,
                    child: TextField(
                      enabled: !isSending,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      controller: controllerOrden,
                      decoration: const InputDecoration(
                        hintText: 'Num Orden',
                        label: Text('Num Orden'),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1.0)),
                    width: 250,
                    child: TextField(
                      enabled: !isSending,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      controller: controllerFicha,
                      decoration: const InputDecoration(
                        hintText: 'Ficha',
                        label: Text('Ficha'),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1.0)),
                    width: 250,
                    child: TextField(
                      enabled: !isSending,
                      controller: controllerCantOrden,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Qty Orden',
                        label: Text('Qty Orden'),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  isSending
                      ? SizedBox(
                          width: 250,
                          child: Column(
                            children: [
                              const LinearProgressIndicator(
                                  backgroundColor: ktejidoBlueOcuro,
                                  color: Colors.white),
                              Text('Enviando',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: ktejidoBlueOcuro)),
                            ],
                          ),
                        )
                      : SizedBox(
                          width: 250,
                          child: ElevatedButton(
                            onPressed: () => insertSerigrafiaWorkMethond(),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => ktejidoBlueOcuro)),
                            child: const Text('Agregar Trabajo',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future insertSerigrafiaWorkMethond() async {
    setState(() {
      isSending = true;
    });
    var data = {
      'id_depart': widget.department.id,
      'code_user': currentUsers?.code,
      'num_orden': controllerOrden.text,
      'type_work': widget.currentTypeWork.id,
      'ficha': controllerFicha.text,
      'cant_orden': controllerCantOrden.text,
      'name_logo': controllerLogo.text,
    };
    // print(data);

    final res = await httpRequestDatabase(insertSerigrafiaWork, data);
    // print(res.body);
    if (res.body.toString() == 'good') {
      controllerOrden.clear();
      controllerFicha.clear();
      controllerCantOrden.clear();
      controllerLogo.clear();
      setState(() {
        isSending = false;
      });
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Orden Registrada Correctamente'),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 500),
        ),
      );
    }
  }
}
