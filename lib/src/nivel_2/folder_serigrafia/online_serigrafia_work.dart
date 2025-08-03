import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/validar_screen_available.dart';
import '/src/datebase/current_data.dart';
import '/src/model/department.dart';
import '/src/nivel_2/folder_serigrafia/widgets/item_serigrafia.dart';
import '/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
import '/src/util/commo_pallete.dart';

import '../../widgets/loading.dart';
import 'provider/provider_serigrafia.dart';

class OnlineSerigrafiaWork extends StatefulWidget {
  const OnlineSerigrafiaWork({super.key, required this.current});
  final Department current;

  @override
  State<OnlineSerigrafiaWork> createState() => _OnlineSerigrafiaWorkState();
}

class _OnlineSerigrafiaWorkState extends State<OnlineSerigrafiaWork> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProviderSerigrafia>(context, listen: false)
          .getWork(widget.current.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final providerList = Provider.of<ProviderSerigrafia>(context, listen: true);

    const curve = Curves.elasticInOut;
    String textPlain = "- Bordados | Serigrafía | Sublimación y Más";
    return Scaffold(
        appBar: AppBar(
            title: Text('Trabajos Online${widget.current.nameDepartment}')),
        body: ValidarScreenAvailable(
            windows: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      providerList.listFilter.isNotEmpty
                          ? Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: RefreshIndicator(
                                  onRefresh: () =>
                                      Provider.of<ProviderSerigrafia>(context,
                                              listen: false)
                                          .getWork(widget.current.id),
                                  child: ListView.builder(
                                    itemCount: providerList.listFilter.length,
                                    physics: const BouncingScrollPhysics(),
                                    itemExtent: 300,
                                    itemBuilder: (context, index) {
                                      Sublima current =
                                          providerList.listFilter[index];
                                      return MyWidgetItemSerigrafia(
                                          current: current);
                                    },
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              child: Loading(
                                  imagen: 'assets/logo_app_sin_fondo.png',
                                  text: providerList.messaje,
                                  isLoading: providerList.isLoading)),
                      providerList.listFilter.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              child: SizedBox(
                                height: 35,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    height: 35,
                                    decoration: const BoxDecoration(
                                        color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Total : ',
                                                style: style.bodySmall),
                                            const SizedBox(width: 10),
                                            Text(
                                                providerList.listFilter.length
                                                    .toString(),
                                                style: style.bodySmall
                                                    ?.copyWith(
                                                        color: ktejidoBlueOcuro,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      identy(context),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SlideInRight(
                          curve: curve,
                          child: Image.asset('assets/paleta.png', scale: 5)),
                      FadeIn(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: 200,
                            child: Text(textPlain,
                                textAlign: TextAlign.center,
                                style: style.bodySmall
                                    ?.copyWith(color: Colors.grey)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            mobile: Column(
              children: [
                const SizedBox(width: double.infinity),
                providerList.listFilter.isNotEmpty
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: RefreshIndicator(
                            onRefresh: () => Provider.of<ProviderSerigrafia>(
                                    context,
                                    listen: false)
                                .getWork(widget.current.id),
                            child: ListView.builder(
                              itemCount: providerList.listFilter.length,
                              physics: const BouncingScrollPhysics(),
                              itemExtent: 300,
                              itemBuilder: (context, index) {
                                Sublima current =
                                    providerList.listFilter[index];
                                return MyWidgetItemSerigrafia(current: current);
                              },
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: Loading(
                            text: providerList.messaje,
                            isLoading: providerList.isLoading),
                      ),
                providerList.listFilter.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 10),
                        child: SizedBox(
                          height: 35,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              height: 35,
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Total : ', style: style.bodySmall),
                                      const SizedBox(width: 10),
                                      Text(
                                          providerList.listFilter.length
                                              .toString(),
                                          style: style.bodySmall?.copyWith(
                                              color: ktejidoBlueOcuro,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                identy(context)
              ],
            )));
  }
}
