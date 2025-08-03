import 'package:flutter/material.dart';
import '../datebase/current_data.dart';
import '../datebase/url.dart';
import '../screen_print_pdf/apis/pdf_api.dart';
import '../util/commo_pallete.dart';
import '../util/debounce.dart';
import '../util/get_formatted_number.dart';
import '../widgets/loading.dart';
import '../widgets/pick_range_date.dart';
import 'model/model_inventory_outputs.dart';
import 'print/print_salida_inventario.dart';

class SalidasInventario extends StatefulWidget {
  const SalidasInventario({super.key});

  @override
  State createState() => _SalidasInventarioState();
}

class _SalidasInventarioState extends State<SalidasInventario> {
  // List<Product> list = [];
  // List<Product> listFilter = [];

  String? firstDate = DateTime.now().toString().substring(0, 10);
  String? secondDate = DateTime.now().toString().substring(0, 10);
  Debounce? debounce = Debounce(duration: const Duration(milliseconds: 500));
  //http://$ipLocal/settingmat/admin/select/select_department.php
  final api = InventoryOutputApi(
      'http://$ipLocal/settingmat/admin/select/select_inventory_outputs.php');

  final int _limit = 500;
  int _offset = 0;
  int _totalItems = 0;
  bool _isLoading = false;

  String _filterName = '';
  bool _sortAscending = true;

  List<InventoryOutput> _items = [];

  final TextEditingController _filterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await api.fetchInventoryOutputs(
        fechaInicio: '$firstDate 00:00:00',
        fechaFin: '$secondDate 23:59:59',
        limit: _limit,
        offset: _offset,
      );

      // Filtrar por nombre en cliente localmente (también podría hacerse en API si se añade soporte)
      List<InventoryOutput> filtered = result.body.where((item) {
        return item.nameProduct
                .toLowerCase()
                .contains(_filterName.toLowerCase()) ||
            item.reason.toLowerCase().contains(_filterName.toLowerCase());
      }).toList();

      setState(() {
        _totalItems = result.totalItems;
        _items = filtered;
      });
    } catch (e) {
      setState(() {
        _items = [];
        _totalItems = 0;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error cargando datos: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSortQuantity() {
    setState(() {
      if (_sortAscending) {
        _items.sort((a, b) => a.quantity.compareTo(b.quantity));
      } else {
        _items.sort((a, b) => b.quantity.compareTo(a.quantity));
      }
      _sortAscending = !_sortAscending;
    });
  }

  void _onFilterChanged(String value) {
    setState(() {
      _filterName = value;
      _offset = 0;
    });
    _fetchData();
  }

  void _nextPage() {
    if (_offset + _limit < _totalItems) {
      setState(() {
        _offset += _limit;
      });
      _fetchData();
    }
  }

  void _prevPage() {
    if (_offset - _limit >= 0) {
      setState(() {
        _offset -= _limit;
      });
      _fetchData();
    }
  }

  imprimirInventario() async {
    final doc = await PrintSalidaInventario.generate(_items);
    await PdfApi.openFile(doc);
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Inventario Salidas'), actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Tooltip(
              message: 'Buscar en Fecha',
              child: IconButton(
                  onPressed: () {
                    selectDateRangeNew(context, (date1, date2) {
                      setState(() {
                        firstDate = date1.toString();
                        secondDate = date2.toString();
                      });
                      _fetchData();
                    });
                  },
                  icon: const Icon(Icons.calendar_month))),
        ),
        _items.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Tooltip(
                    message: 'Imprimir',
                    child: IconButton(
                        onPressed: () => imprimirInventario(),
                        icon: const Icon(Icons.print_outlined))),
              )
            : const SizedBox(),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: 50,
              width: 250,
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: TextField(
                controller: _filterController,
                decoration: InputDecoration(
                  labelText: 'Filtrar Productos',
                  hintText: 'Escribir el nombre del producto',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _filterController.clear();
                      _onFilterChanged('');
                    },
                  ),
                ),
                onChanged: _onFilterChanged,
              ),
            ),
            const SizedBox(height: 8),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _items.isEmpty
                    ? const LoadingNew()
                    : Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              sortAscending: _sortAscending,
                              sortColumnIndex: 3,
                              dataRowMaxHeight: 25,
                              dataRowMinHeight: 20,
                              horizontalMargin: 10.0,
                              columnSpacing: 15,
                              headingRowHeight: 30,
                              // decoration: const BoxDecoration(color: ktejidoblue),
                              headingTextStyle:
                                  const TextStyle(color: Colors.white),
                              border: TableBorder.symmetric(
                                  outside: BorderSide(
                                      color: Colors.grey.shade100,
                                      style: BorderStyle.none),
                                  inside: const BorderSide(
                                      style: BorderStyle.solid,
                                      color: Colors.grey)),
                              headingRowColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      colorsGreenTablas.withOpacity(0.8)),

                              columns: [
                                const DataColumn(label: Text('ID Salida')),
                                const DataColumn(label: Text('ID Producto')),
                                const DataColumn(
                                    label: Text('Nombre Producto')),
                                DataColumn(
                                  label: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('Cantidad'),
                                  ),
                                  numeric: true,
                                  onSort: (columnIndex, _) {
                                    _onSortQuantity();
                                  },
                                ),
                                const DataColumn(label: Text('Fecha Salida')),
                                const DataColumn(label: Text('Motivo')),
                              ],
                              rows: _items.asMap().entries.map((entry) {
                                int index = entry.key;
                                InventoryOutput item = entry.value;
                                return DataRow(
                                    color: MaterialStateProperty.resolveWith<
                                        Color>(
                                      (Set<MaterialState> states) {
                                        // Alterna el color de fondo entre gris y blanco
                                        if (index.isOdd) {
                                          return Colors.grey
                                              .shade300; // Color de fondo gris para filas impares
                                        }
                                        return Colors
                                            .white; // Color de fondo blanco para filas pares
                                      },
                                    ),
                                    cells: [
                                      DataCell(Text(item.idOutput.toString())),
                                      DataCell(Text(item.idProduct.toString())),
                                      DataCell(Text(item.nameProduct)),
                                      DataCell(Center(
                                          child: Text(item.quantity
                                              .toStringAsFixed(2)))),
                                      DataCell(Text(item.outputDate
                                          .toString()
                                          .substring(0, 19))),
                                      DataCell(Text(item.reason)),
                                    ]);
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Mostrando ${_offset + 1} - ${(_offset + _limit) > _totalItems ? _totalItems : (_offset + _limit)} de $_totalItems'),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: _offset == 0 ? null : _prevPage,
                  icon: const Icon(Icons.arrow_back),
                ),
                IconButton(
                  onPressed:
                      (_offset + _limit) >= _totalItems ? null : _nextPage,
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
            _items.isEmpty
                ? const SizedBox()
                : SizedBox(
                    height: 35,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
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
                                        getNumFormatedDouble(
                                            InventoryOutput.getTotal(_items)),
                                        style: style.bodySmall?.copyWith(
                                            color: Colors.brown,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            identy(context)
          ],
        ),
      ),
    );
  }
}
