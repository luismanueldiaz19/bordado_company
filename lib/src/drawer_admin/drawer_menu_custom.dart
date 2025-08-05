import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../compras/add_compra.dart';
import '../compras/screen_compras.dart';
import '../folder_inventario/salidas_inventario.dart';

import '../nivel_2/folder_reception/screen_reception_entregas.dart';
import '../nivel_2/pre_orden/add_pre_orden.dart';
import '/src/datebase/current_data.dart';
import '/src/folder_admin_user/add_user.dart';
import '/src/folder_cliente_company/screen_cliente_company.dart';
import '/src/home.dart';
import '/src/folder_incidencia_main/home_incidencia_resuelto.dart';
import '/src/nivel_2/folder_planificacion/screen_planificacion_semanal.dart';
import '/src/nivel_2/folder_reception/historia_record/list_report_intput_output.dart';
import '../sign_in_login.dart';
import '/src/util/commo_pallete.dart';
import '../folder_admin_permiso/screen_admin_permiso.dart';
import '../folder_cliente_company/add_cliente.dart';
import '../folder_incidencia_main/add_incidencia_main.dart';
import '../folder_incidencia_main/screen_incidencia_current.dart';
import '../folder_list_product/screen_list_product.dart';
import '../model/users.dart';
import '../nivel_2/folder_planificacion/add_planificacion.dart';
import '../widgets/button_menu_drawer.dart';

class DrawerMenuCustom extends StatefulWidget {
  const DrawerMenuCustom({super.key});

  @override
  State<DrawerMenuCustom> createState() => _DrawerMenuCustomState();
}

class _DrawerMenuCustomState extends State<DrawerMenuCustom> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final style = Theme.of(context).textTheme;
    return Container(
      color: Colors.white,
      height: size.height,
      width: 200,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (conext) => const MyHomePage()),
                          (route) => false);
                    },
                    child:
                        BounceInDown(child: Image.asset(logoApp, height: 50))),
              ],
            ),
            const SizedBox(height: 15),

            //ScreenProductosNew

            // MyWidgetButton(
            //     icon: Icons.telegram,
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (conext) => const ProductoListScreen()));
            //     },
            //     textButton: 'Test'),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  hasPermissionUsuario(
                          currentUsers!.listPermission!, "inventario", "leer")
                      ? Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Text('Gestión Inventario ',
                                  textAlign: TextAlign.justify,
                                  style: style.bodySmall
                                      ?.copyWith(color: colorsBlueDeepHigh))
                            ],
                          ),
                        )
                      : const SizedBox(),
                  hasPermissionUsuario(
                          currentUsers!.listPermission!, "inventario", "leer")
                      ? Column(
                          children: [
                            hasPermissionUsuario(currentUsers!.listPermission!,
                                    "inventario", "crear")
                                ? MyWidgetButton(
                                    icon: Icons.add_box_outlined,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (conext) =>
                                                  const AddCompra()));
                                    },
                                    textButton: 'Agregar Inventario')
                                : const SizedBox(),

                            //AddCompra

                            MyWidgetButton(
                                icon: Icons.inbox_outlined,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (conext) =>
                                              const ScreenCompras()));
                                },
                                textButton: 'Entradas Inventarios'),
                            MyWidgetButton(
                                icon: Icons.outbond_outlined,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (conext) =>
                                          const SalidasInventario(),
                                    ),
                                  );
                                },
                                textButton: 'Salidas Inventario'),
                            MyWidgetButton(
                                icon: Icons.list,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (conext) =>
                                              const ScreenListProduct()));
                                },
                                textButton: 'Productos/Inventario'),
                          ],
                        )
                      : const SizedBox(),
                  hasPermissionUsuario(
                          currentUsers!.listPermission!, "inventario", "leer")
                      ? const Divider(endIndent: 20, indent: 20)
                      : const SizedBox(),
                  hasPermissionUsuario(
                          currentUsers!.listPermission!, "cliente", "leer")
                      ? Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Text('Gestión Clientes',
                                  textAlign: TextAlign.justify,
                                  style: style.bodySmall
                                      ?.copyWith(color: colorsBlueDeepHigh))
                            ],
                          ),
                        )
                      : const SizedBox(),
                  hasPermissionUsuario(
                          currentUsers!.listPermission!, "cliente", "leer")
                      ? Column(
                          children: [
                            hasPermissionUsuario(currentUsers!.listPermission!,
                                    "cliente", "crear")
                                ? MyWidgetButton(
                                    icon: Icons.home_outlined,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (conext) =>
                                                const AddClientForm()),
                                      );
                                    },
                                    textButton: 'Agregar clientes')
                                : const SizedBox(),
                            MyWidgetButton(
                                icon: Icons.group_outlined,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (conext) =>
                                              const ScreenClientes()));
                                },
                                textButton: 'Lista clientes'),
                          ],
                        )
                      : const SizedBox(),
                  hasPermissionUsuario(
                          currentUsers!.listPermission!, "cliente", "leer")
                      ? const Divider(endIndent: 20, indent: 20)
                      : const SizedBox(),
                  hasPermissionUsuario(
                          currentUsers!.listPermission!, "incidencia", "leer")
                      ? Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Text('Gestión Incidencia',
                                  textAlign: TextAlign.justify,
                                  style: style.bodySmall
                                      ?.copyWith(color: colorsBlueDeepHigh)),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  hasPermissionUsuario(
                          currentUsers!.listPermission!, "incidencia", "leer")
                      ? Column(
                          children: [
                            // hasPermissionUsuario(currentUsers!.listPermission!,
                            //         "incidencia", "crear")
                            //     ? MyWidgetButton(
                            //         icon: Icons.add,
                            //         onPressed: () {
                            //           Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //               builder: (conext) =>
                            //                   const AddIncidenciaOut(),
                            //             ),
                            //           );
                            //         },
                            //         textButton: 'Agregar Incidencias')
                            //     : const SizedBox(),
                            hasPermissionUsuario(currentUsers!.listPermission!,
                                    "incidencia", "crear")
                                ? MyWidgetButton(
                                    icon: Icons.add,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (conext) =>
                                              const AddIncidenciaMain(),
                                        ),
                                      );
                                    },
                                    textButton: 'Agregar Incidencias')
                                : const SizedBox(),

                            ///AddIncidenciaMain
                            ///ScreenIncidenciaCurrent
                            MyWidgetButton(
                                icon: Icons.warning_amber_rounded,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (conext) =>
                                              const ScreenIncidenciaCurrent()));
                                },
                                textButton: 'Incidencias Activas'),
                            // MyWidgetButton(
                            //     icon: Icons.abc,
                            //     onPressed: () {
                            //       Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (conext) => const FileViewer(
                            //                   numOrden: '4684')));
                            //     },
                            //     textButton: 'Ver archivos'),
                            //FileViewer
                            MyWidgetButton(
                                icon: Icons.checklist_sharp,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (conext) =>
                                              const HomeIncidenciaResueltos()));
                                },
                                textButton: 'Incidencias'),
                            // MyWidgetButton(
                            //     icon: Icons.warning_amber_rounded,
                            //     onPressed: () {
                            //       Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (conext) =>
                            //                   const HomeIncidenciaPendientes()));
                            //     },
                            //     textButton: 'Incidencias'),
                            // MyWidgetButton(
                            //     icon: Icons.close,
                            //     colorIcon: Colors.red.shade200,
                            //     onPressed: () {
                            //       Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (conext) =>
                            //                   const HomeIncidenciaResueltosViejo()));
                            //     },
                            //     textButton: 'Old Incidencia'),
                          ],
                        )
                      : const SizedBox(),
                  hasPermissionUsuario(
                          currentUsers!.listPermission!, "incidencia", "leer")
                      ? const Divider(endIndent: 20, indent: 20)
                      : const SizedBox(),
                  hasPermissionUsuario(currentUsers!.listPermission!,
                          "planificacion", "leer")
                      ? Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Text('Planificación',
                                  textAlign: TextAlign.justify,
                                  style: style.bodySmall
                                      ?.copyWith(color: colorsBlueDeepHigh)),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  hasPermissionUsuario(currentUsers!.listPermission!,
                          "planificacion", "leer")
                      ? Column(
                          children: [
                            hasPermissionUsuario(currentUsers!.listPermission!,
                                    "planificacion", "crear")
                                ? MyWidgetButton(
                                    icon: Icons.add,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (conext) =>
                                              const AddPreOrden(),
                                        ),
                                      );
                                    },
                                    textButton: 'Crear Orden')
                                : const SizedBox(),
                            hasPermissionUsuario(currentUsers!.listPermission!,
                                    "planificacion", "crear")
                                ? MyWidgetButton(
                                    icon: Icons.list_alt_rounded,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (conext) =>
                                              const ScreenReceptionEntregas(),
                                        ),
                                      );
                                    },
                                    textButton: 'Listado Ordenes')
                                : const SizedBox(),
                            MyWidgetButton(
                                icon: Icons.plagiarism_outlined,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (conext) =>
                                          const ScreenPlanificacionSemanal(),
                                    ),
                                  );
                                },
                                textButton: 'Planificación'),
                            MyWidgetButton(
                                icon: Icons.dashboard_outlined,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ListReportInputOutPut()));
                                },
                                textButton: 'Registros/Entregas'),
                          ],
                        )
                      : const SizedBox(),
                  hasPermissionUsuario(currentUsers!.listPermission!,
                          "planificacion", "leer")
                      ? const Divider(endIndent: 20, indent: 20)
                      : const SizedBox(),
                  hasPermissionUsuario(
                          currentUsers!.listPermission!, "admin", "leer")
                      ? Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Text('Administración',
                                  textAlign: TextAlign.justify,
                                  style: style.bodySmall
                                      ?.copyWith(color: colorsBlueDeepHigh)),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  hasPermissionUsuario(
                          currentUsers!.listPermission!, "admin", "leer")
                      ? Column(
                          children: [
                            hasPermissionUsuario(currentUsers!.listPermission!,
                                    "admin", "crear")
                                ? MyWidgetButton(
                                    icon: Icons.person_add_alt_outlined,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (conext) =>
                                                  const AddUser()));
                                    },
                                    textButton: 'Add Empleado')
                                : const SizedBox(),
                            MyWidgetButton(
                                icon: Icons.add,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (conext) =>
                                          const ScreenAdminPermisos(),
                                    ),
                                  );
                                },
                                textButton: 'Empleados/Permisos'),
                            MyWidgetButton(
                                icon: Icons.workspaces_outlined,
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           const ListaTipoTrabajos()),
                                  // );
                                },
                                textButton: 'Tipos de Trabajos'),
                          ],
                        )
                      : const SizedBox(),
                  hasPermissionUsuario(
                          currentUsers!.listPermission!, "admin", "leer")
                      ? const Divider(endIndent: 20, indent: 20)
                      : const SizedBox(),
                  hasPermissionUsuario(
                          currentUsers!.listPermission!, "plan", "leer")
                      ? Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Text('Admin de Planes',
                                  textAlign: TextAlign.justify,
                                  style: style.bodySmall
                                      ?.copyWith(color: colorsBlueDeepHigh))
                            ],
                          ),
                        )
                      : const SizedBox(),
                  hasPermissionUsuario(
                          currentUsers!.listPermission!, "plan", "leer")
                      ? Column(
                          children: [
                            hasPermissionUsuario(currentUsers!.listPermission!,
                                    "plan", "crear")
                                ? MyWidgetButton(
                                    icon: Icons.add,
                                    onPressed: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             const AddPlanPrinter()));
                                    },
                                    textButton: 'Agregar plan')
                                : const SizedBox(),
                            MyWidgetButton(
                                icon: Icons.list_alt_outlined,
                                onPressed: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             const ScreenSelectorDepartment()));
                                },
                                textButton: 'Plan semanal'),
                            hasPermissionUsuario(currentUsers!.listPermission!,
                                    "plan", "crear")
                                ? MyWidgetButton(
                                    icon: Icons.add_moderator_outlined,
                                    onPressed: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             const AdminPlan()));
                                    },
                                    textButton: 'Admin Plan')
                                : const SizedBox()
                          ],
                        )
                      : const SizedBox(),
                  hasPermissionUsuario(
                          currentUsers!.listPermission!, "plan", "leer")
                      ? const Divider(endIndent: 20, indent: 20)
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Text('Sección',
                            textAlign: TextAlign.justify,
                            style: style.bodySmall
                                ?.copyWith(color: colorsBlueDeepHigh)),
                      ],
                    ),
                  ),
                  MyWidgetButton(
                      icon: Icons.login,
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (conext) => const SignInLogin()),
                            (route) => false);
                      },
                      textButton: 'Cerrar Sección'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
