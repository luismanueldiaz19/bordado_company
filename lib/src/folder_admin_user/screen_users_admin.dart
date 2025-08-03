import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/src/datebase/current_data.dart';
import '/src/util/helper.dart';
import '/src/widgets/validar_screen_available.dart';

import '../model/users.dart';
import '../util/commo_pallete.dart';
import 'services_provider_users.dart';

class ScreenUsersAdmin extends StatefulWidget {
  const ScreenUsersAdmin({super.key});

  @override
  State<ScreenUsersAdmin> createState() => _ScreenUsersAdminState();
}

class _ScreenUsersAdminState extends State<ScreenUsersAdmin> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ServicesProviderUsers>(context, listen: false).getUserAdmin();
    });
  }

  @override
  Widget build(BuildContext context) {
    const shadow =
        BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 10);
    final decoration = BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [shadow]);
    final style = Theme.of(context).textTheme;

    final listFilter = context.watch<ServicesProviderUsers>().userListFilter;

    final provider = context.read<ServicesProviderUsers>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de usuarios'),
      ),
      body: ValidarScreenAvailable(
        windows: Column(
          children: [
            Expanded(
                child: Row(
              children: [
                listFilter.isEmpty
                    ? Expanded(
                        child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset('assets/gif_icon.gif',
                                    scale: 5)),
                            const SizedBox(height: 10),
                            Text('No hay datos..', style: style.bodySmall),
                          ],
                        ),
                      ))
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: ListView.builder(
                              itemCount: listFilter.length,
                              itemBuilder: (conext, index) {
                                Users item = listFilter[index];
                                return ZoomIn(
                                  curve: Curves.elasticOut,
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    height: 175,
                                    width: 150,
                                    decoration: decoration,
                                    child: Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(item.fullName ??
                                                          'N/A'),
                                                      Text(item.code ?? 'N/A'),
                                                      Text(item.occupation ??
                                                          'N/A'),
                                                      Text(item.turn ?? 'N/A'),
                                                    ],
                                                  ),
                                                ),
                                                item.listPermission!.isEmpty
                                                    ? Expanded(
                                                        child: Center(
                                                          child: Column(
                                                            children: [
                                                              Expanded(
                                                                  child: Image
                                                                      .asset(
                                                                          'assets/mala-critica.png')),
                                                              Expanded(
                                                                child: Text(
                                                                    'No hay registros...',
                                                                    style: style
                                                                        .bodySmall),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Column(
                                                        children: [
                                                          Text(
                                                              'Lista de permisos',
                                                              style: style
                                                                  .labelSmall),
                                                          Expanded(
                                                            child:
                                                                SingleChildScrollView(
                                                              physics:
                                                                  const BouncingScrollPhysics(),
                                                              child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: item
                                                                      .listPermission!
                                                                      .map((permiso) =>
                                                                          Row(
                                                                            children: [
                                                                              Text(permiso.modulo ?? 'N/A'),
                                                                              const SizedBox(width: 10),
                                                                              Text(permiso.action ?? 'N/A'),
                                                                            ],
                                                                          ))
                                                                      .toList()),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                // TextButton(
                                                //     onPressed: () {},
                                                //     child: Text('Editar',
                                                //         style: style.labelLarge
                                                //             ?.copyWith(
                                                //                 color: Colors
                                                //                     .black45))),
                                                const SizedBox(width: 10),
                                                customButton(
                                                  onPressed: () {
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //       builder: (context) =>
                                                    //           EditedUserPermision(
                                                    //               item: item,
                                                    //               listPermission:
                                                    //                   listPermission)),
                                                    // );
                                                  },
                                                  colorText: Colors.white,
                                                  colors: colorsAd,
                                                  textButton: 'Editar',
                                                  width: 85,
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                Expanded(
                    child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: BounceInDown(
                            curve: Curves.elasticOut,
                            child: Image.asset('assets/recursos_humanos.png',
                                scale: 6))),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        'Usuarios',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        'Toma el control de tus usuarios',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width:
                          250, // Aumenta el ancho para darle más espacio al campo de búsqueda
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical:
                              5), // Agrega padding dentro del container para que se vea más equilibrado
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset:
                                Offset(0, 3), // Posiciona la sombra hacia abajo
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) => provider.searchingFilter(value),
                        decoration: InputDecoration(
                          hintText:
                              'Buscar Usuario', // Texto de ayuda más descriptivo
                          border: InputBorder
                              .none, // Mantiene sin borde el campo de texto
                          suffixIcon: Icon(Icons.search,
                              color: Colors.grey[600],
                              size: 24), // Estiliza el icono de búsqueda
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 15), // Ajusta el padding interno
                        ),
                      ),
                    ),
                    // const SizedBox(height: 10),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 50),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Text(
                    //           'Total : ${getNumFormatedDouble(ProyectoEarthItem.getMetroActivo(itemsFilter))} m²2',
                    //           textAlign: TextAlign.center,
                    //           style: GoogleFonts.akatab().copyWith(
                    //               fontSize: 16, color: Colors.black45)),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 50),
                    //   child: Text(
                    //     '${itemsFilter.length.toString()} Solares',
                    //     textAlign: TextAlign.center,
                    //     style: GoogleFonts.akatab()
                    //         .copyWith(fontSize: 15, color: Colors.grey),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 50),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Text(
                    //         '${getNumFormatedDouble(ProyectoEarthItem.getTotalVendido(itemsFilter))} Vendidos ,',
                    //         textAlign: TextAlign.center,
                    //         style: GoogleFonts.akatab()
                    //             .copyWith(fontSize: 15, color: Colors.grey),
                    //       ),
                    //       const SizedBox(width: 10),
                    //       Text(
                    //         '${getNumFormatedDouble(ProyectoEarthItem.getTotalNoVendido(itemsFilter))} Quedan',
                    //         textAlign: TextAlign.center,
                    //         style: GoogleFonts.akatab()
                    //             .copyWith(fontSize: 15, color: Colors.grey),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ))
              ],
            )),
            identy(context)
          ],
        ),
      ),
    );
  }
}
