import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../util/commo_pallete.dart';
import '../../util/helper.dart';
import '../../widgets/picked_date_widget.dart';
import '../../widgets/validar_screen_available.dart';
import '../folder_insidensia/pages_insidencia.dart/selected_department.dart';
import 'printer_provider.dart';
import 'widgets/selector_estado_print.dart';

class AddPlanPrinter extends StatefulWidget {
  const AddPlanPrinter({super.key});

  @override
  State createState() => _AddPlanPrinterState();
}

class _AddPlanPrinterState extends State<AddPlanPrinter> {
  final _formKey = GlobalKey<FormState>();
  String? _firstDate = DateTime.now().toString().substring(0, 10);

  final List<Map<String, String>> trabajosPendientes = [];
  String? nameDepart;
  String estadoWork = 'PENDIENTE';
  final Map<String, String> formData = {
    'nombre_logo': '',
    'index_work': '0',
    'tipo_trabajo': '',
    'cantidad': '',
    'ficha': 'N/A',
    'orden': 'N/A',
    'asignado': '',
    'comentario': 'N/A',
    'estado': 'PENDIENTE',
    'name_depart': 'N/A',
    'fecha_trabajo': DateTime.now().toString().substring(0, 10),
    'boceto': 'N/A',
  };

  void agregarTrabajo() {
    if (_formKey.currentState!.validate() && nameDepart != null) {
      _formKey.currentState!.save();
      formData['fecha_trabajo'] = _firstDate.toString();
      formData['name_depart'] = quitarAcentos(nameDepart.toString());
      formData['estado'] = estadoWork.toString().toUpperCase();
      trabajosPendientes.add(Map.from(formData)); // Clonar
      _formKey.currentState!.reset();

      setState(() {});
    }
  }

  void enviarTodos(PrinterProvider printerProvider) async {
    if (trabajosPendientes.isEmpty) return;

    for (var trabajo in trabajosPendientes) {
      await printerProvider.addPlan(trabajo);
    }

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Todos los trabajos fueron enviados correctamente.')));

    trabajosPendientes.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final printerProvider = Provider.of<PrinterProvider>(context);
    final mobile = Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            EstadoSelector(
              estadoActual: estadoWork,
              onChanged: (nuevoEstado) {
                setState(() {
                  setState(() {
                    estadoWork = nuevoEstado; // ✅ actualiza el modelo
                  });

                  // Si deseas actualizar en la base de datos también:
                  // providerRead.updateEstadoPlan(report.toJson());
                });
              },
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: 250,
                    height: 50,
                    color: Colors.grey.shade100,
                    child: TextButton(
                        onPressed: () async {
                          String? dateee =
                              await showDatePickerCustom(context: context);
                          if (dateee != null) {
                            _firstDate = dateee.toString();
                            //print(_firstDate);
                            setState(() {});
                          }
                        },
                        child: Text('Fecha : ${_firstDate ?? 'N/A'}')),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    color: Colors.grey.shade100,
                    height: 50,
                    width: 250,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: TextButton.icon(
                      icon: const Icon(Icons.search, color: Colors.black),
                      label: Text(
                          nameDepart != null
                              ? nameDepart!.toString()
                              : 'Que departamento?',
                          style: const TextStyle(color: Colors.black)),
                      onPressed: chooseDepart,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: _buildField('nombre_logo', 'Nombre del logo')),
                const SizedBox(width: 10),
                Expanded(child: _buildField('tipo_trabajo', 'Tipo de trabajo')),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: _buildField('index_work', 'Indices de prioridad',
                        isNumber: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number)),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildField('cantidad', 'Cantidad',
                      isNumber: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: _buildField('orden', 'Orden')),
                const SizedBox(width: 10),
                Expanded(child: _buildField('ficha', 'Ficha')),
              ],
            ),
            Row(
              children: [
                Expanded(child: _buildField('asignado', 'Asignado a')),
                const SizedBox(width: 10),
                Expanded(child: _buildField('comentario', 'Comentario')),
              ],
            ),
            printerProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        customButton(
                            onPressed: agregarTrabajo,
                            width: 150,
                            colorText: Colors.white,
                            colors: colorsAd,
                            textButton: 'Agregar a la lista'),
                        const SizedBox(width: 10),
                        trabajosPendientes.isNotEmpty
                            ? customButton(
                                onPressed: () => enviarTodos(printerProvider),
                                width: 150,
                                colorText: Colors.white,
                                colors: Colors.green,
                                textButton: 'Enviar todos')
                            : const SizedBox()
                      ],
                    ),
                  ),
            const SizedBox(height: 20),
            trabajosPendientes.isEmpty
                ? const Text('No hay trabajos agregados aún.')
                : Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        dataRowMaxHeight: 20,
                        dataRowMinHeight: 15,
                        horizontalMargin: 10.0,
                        columnSpacing: 15,
                        headingRowHeight: 20,
                        decoration:
                            const BoxDecoration(color: colorsBlueDeepHigh),
                        headingTextStyle: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        columns: const [
                          DataColumn(label: Text("ESTADO")),
                          DataColumn(label: Text("DEPART")),
                          DataColumn(label: Text("INDEX")),
                          DataColumn(label: Text("LOGO")),
                          DataColumn(label: Text("TIPO")),
                          DataColumn(label: Text("CANT.")),
                          DataColumn(label: Text("ASIGNADO")),
                          DataColumn(label: Text("FECHA")),
                          DataColumn(label: Text("QUITAR")),
                        ],
                        rows: trabajosPendientes.map((t) {
                          return DataRow(
                              color: MaterialStateColor.resolveWith(
                                (states) => Colors.grey.shade100,
                              ),
                              cells: [
                                //name_depart
                                DataCell(Text(t['estado'] ?? '')),
                                DataCell(Text(t['name_depart'] ?? '')),
                                DataCell(Text(t['index_work'] ?? '')),
                                DataCell(Text(t['nombre_logo'] ?? '')),
                                DataCell(Text(t['tipo_trabajo'] ?? '')),
                                DataCell(Text(t['cantidad'] ?? '')),
                                DataCell(Text(t['asignado'] ?? '')),
                                DataCell(Text(t['fecha_trabajo'] ?? '')),
                                DataCell(
                                    const Text('Quitar',
                                        style: TextStyle(color: Colors.red)),
                                    onTap: () {
                                  setState(() {
                                    trabajosPendientes.remove(t);
                                  });
                                }),
                              ]);
                        }).toList(),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
    final size = MediaQuery.of(context).size;
    const curve = Curves.elasticInOut;
    final style = Theme.of(context).textTheme;
    String textPlain =
        "-Bordados -Serigrafía -Sublimación -Vinil -Uniformes deportivos y empresariales -Promociones y Más";
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Trabajo Printer')),
      body: ValidarScreenAvailable(
        mobile: mobile,
        windows: Row(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: ClipPath(
                  clipper: DientesClipper(
                      dienteAncho: 50, dienteAlto: 15, radioEsquina: 10),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.all(50), child: mobile),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Bounce(
                      curve: curve,
                      child: const Text('Nuevo Trabajo !',
                          style: TextStyle(fontSize: 24, color: colorsAd)),
                    ),
                  ),
                  BounceInDown(
                      curve: curve,
                      child:
                          Image.asset('assets/lista-de-tareas.png', scale: 5)),
                  FadeIn(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: 200,
                        child: Text(textPlain,
                            textAlign: TextAlign.center,
                            style:
                                style.bodySmall?.copyWith(color: Colors.grey)),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 15),
                  // printerProvider.isLoading
                  //     ? const Center(child: CircularProgressIndicator())
                  //     : customButton(
                  //         onPressed: () => send(printerProvider),
                  //         width: 250,
                  //         colorText: Colors.white,
                  //         colors: colorsAd,
                  //         textButton: 'Guardar'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  chooseDepart() async {
    await showDialog(
        context: context,
        builder: (context) {
          return SelectedDepartments(
            pressDepartment: (List val) {
              if (val.isNotEmpty) {
                setState(() {
                  // print(val);
                  nameDepart = val.first;
                });
              }
            },
          );
        });
  }

  Widget _buildField(
    String key,
    String label, {
    bool isNumber = false,
    List<TextInputFormatter>? inputFormatters,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
        color: Colors.grey.shade100,
        height: 50,
        width: 250,
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: TextFormField(
          keyboardType: isNumber ? TextInputType.number : keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
              labelText: label,
              hintText: label,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15.0)),
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Campo requerido' : null,
          onSaved: (value) => formData[key] = value ?? '',
        ));
  }
}

class DientesClipper extends CustomClipper<Path> {
  final double dienteAncho;
  final double dienteAlto;
  final double radioEsquina;

  DientesClipper({
    this.dienteAncho = 15,
    this.dienteAlto = 10,
    this.radioEsquina = 12,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    // Punto inicial: empieza justo después del radio en la esquina superior izquierda
    path.moveTo(0, radioEsquina + dienteAlto);

    // --- Lado superior (de izquierda a derecha) ---
    double x = 0;
    bool bajar = true;

    while (x < w - radioEsquina) {
      path.lineTo(x, bajar ? radioEsquina : radioEsquina + dienteAlto);
      x += dienteAncho;
      bajar = !bajar;
    }

    // Línea hasta antes de la esquina superior derecha
    path.lineTo(w - radioEsquina, radioEsquina + (bajar ? dienteAlto : 0));

    // Arco esquina superior derecha (clockwise)
    path.arcToPoint(
      Offset(w, radioEsquina * 2),
      radius: Radius.circular(radioEsquina),
      clockwise: true,
    );

    // --- Lado derecho (de arriba a abajo) ---
    double y = radioEsquina * 2;
    bool izquierda = true;

    while (y < h - radioEsquina) {
      path.lineTo(izquierda ? w - radioEsquina : w, y);
      y += dienteAncho;
      izquierda = !izquierda;
    }

    // Línea antes de la esquina inferior derecha
    path.lineTo(w - radioEsquina, h - radioEsquina);

    // Arco esquina inferior derecha
    path.arcToPoint(
      Offset(w - radioEsquina * 2, h),
      radius: Radius.circular(radioEsquina),
      clockwise: true,
    );

    // --- Lado inferior (de derecha a izquierda) ---
    x = w - radioEsquina * 2;
    bool subir = true;

    while (x > radioEsquina) {
      path.lineTo(x, subir ? h - radioEsquina : h - radioEsquina - dienteAlto);
      x -= dienteAncho;
      subir = !subir;
    }

    // Línea antes de la esquina inferior izquierda
    path.lineTo(radioEsquina, h - radioEsquina - (subir ? dienteAlto : 0));

    // Arco esquina inferior izquierda
    path.arcToPoint(
      Offset(0, h - radioEsquina * 2),
      radius: Radius.circular(radioEsquina),
      clockwise: true,
    );

    // --- Lado izquierdo (de abajo a arriba) ---
    y = h - radioEsquina * 2;
    bool derecha = true;

    while (y > radioEsquina * 2) {
      path.lineTo(derecha ? radioEsquina : 0, y);
      y -= dienteAncho;
      derecha = !derecha;
    }

    // Línea final hasta el punto inicial (arriba izquierda)
    path.lineTo(0, radioEsquina + dienteAlto);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
