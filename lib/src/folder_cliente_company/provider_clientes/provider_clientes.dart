import 'dart:convert';

import 'package:flutter/material.dart';
import '../../util/debounce.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';

import '../model_cliente/cliente.dart';

class ClienteProvider extends ChangeNotifier {
  List<Cliente> _listClients = [];
  List<Cliente> _listClientsFilter = [];

  List<Cliente> get listClients => _listClients;
  List<Cliente> get listClientsFilter => _listClientsFilter;

  int _limit = 50;
  int _offset = 0;
  String _search = '';
  int _totalPaginas = 1;

  int get totalPaginas => _totalPaginas;
  int get paginaActual => (_offset ~/ _limit) + 1;

  Future getCliente({int? limit, int? offset, String? search}) async {
    _listClients.clear();
    _listClientsFilter.clear();
    _limit = limit ?? _limit;
    _offset = offset ?? _offset;
    _search = search ?? _search;
    String url =
        "http://$ipLocal/settingmat/admin/select/select_clientes_new.php";
    final res = await httpRequestDatabase(url, {
      'token': token,
      'limit': _limit.toString(),
      'offset': _offset.toString(),
      'filtro': _search,
    });

    final body = jsonDecode(res.body);

    if (body['success']) {
      _listClients = clienteFromJson(jsonEncode(body['body']));
      _listClientsFilter = _listClients;
      _totalPaginas = body['totalPaginas'] ?? 1;
    } else {
      _listClients = [];
      _listClientsFilter = [];
    }

    notifyListeners();
  }
  // Future getCliente() async {
  //   _listClients.clear();
  //   _listClientsFilter.clear();
  //   String url = "http://$ipLocal/settingmat/admin/select/select_clientes.php";
  //   final res = await httpRequestDatabase(url, {
  //       'token': token,
  //       'limit': _limit.toString(),
  //       'offset': _offset.toString(),
  //       'search': _filtro
  //     },
  //   );
  //   // _listClients = clienteFromJson(res.body);
  //   // _listClientsFilter = _listClients;
  //   // notifyListeners();
  // }

  void siguientePagina() {
    if (_offset + _limit < _totalPaginas * _limit) {
      _offset += _limit;
      getCliente();
    }
  }

  void anteriorPagina() {
    if (_offset - _limit >= 0) {
      _offset -= _limit;
      getCliente();
    }
  }

  void buscarCliente(String texto) {
    Debounce debounce = Debounce(duration: const Duration(milliseconds: 500));
    debounce.call(() {
      _offset = 0; // Reiniciar a la primera página
      getCliente(search: texto);
    });
  }

  Future deleteCliente(data) async {
    String url = "http://$ipLocal/settingmat/admin/delete/delete_client.php";
    final res = await httpRequestDatabase(url, data);
    await getCliente();

    return res.body;
  }

  Future<String> updateMethodCliente(data) async {
    String url = "http://$ipLocal/settingmat/admin/update/update_cliente.php";
    final res = await httpRequestDatabase(url, data);
    getCliente();
    return res.body;
  }

  Future<String> addNewClient(data) async {
    String url = "http://$ipLocal/settingmat/admin/insert/insert_clientes.php";
    final res = await httpRequestDatabase(url, data);
    getCliente();
    return res.body;
  }

  searchingOrden(String val) {
    if (val.isNotEmpty) {
      _listClientsFilter = _listClients
          .where((x) =>
              x.apellido!.toUpperCase().contains(val.toUpperCase()) ||
              x.nombre!.toUpperCase().contains(val.toUpperCase()) ||
              x.telefono!.toUpperCase().contains(val.toUpperCase()))
          .toList();
    } else {
      _listClientsFilter = _listClients;
    }
    notifyListeners();
  }
}
