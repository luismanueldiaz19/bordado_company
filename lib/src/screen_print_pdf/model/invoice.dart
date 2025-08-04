import '../../model/sublima.dart';
import '/src/screen_print_pdf/model/customer.dart';

class Invoice {
  final InvoiceInfo info;

  final Customer customer;
  final List<InvoiceItem>? items;
  final List<InvoiceItemFinalOrden>? itemsFinalOrder;
  final List<Sublima>? listEmpleadoDestacados;
  final List<Sublima>? suplimaWork;
  // final List<InvoiceItemFinalOrden>? itemsFinalOrder;

  // final List<InvoiceItemDespachoMC>? itemsDespachoMC;
  // final List<InvoiceItemDesperdicios>? itemsDesperdicio;
  // final List<InvoiceItemGeneralInventario>? itemsTotalGeneral;
  final String head;

  const Invoice({
    this.itemsFinalOrder,
    required this.info,
    required this.customer,
    this.items,
    this.listEmpleadoDestacados,
    required this.head,
    this.suplimaWork,

    // this.itemsDespachoMC,
    // this.itemsDesperdicio,
    // this.itemsTotalGeneral,
  });
}

class InvoiceInfo {
  final String date;

  const InvoiceInfo({
    required this.date,
  });
}

class InvoiceItem {
  String? id;
  String? userDatos;
  String? idModulo;
  String? numOrden;
  String? date;
  String? dateCurrent;
  String? logo;
  String? cantPcs;
  String? cantPunts;
  String? velozMachine;
  String? calida;
  String? timeMachine;
  String? comment;
  String? turn;
  String? tStop;
  String? porcentTimeMiss;
  String? tGeneralTime;
  String? tWorkedTime;
  String? pcsElaborated;

  InvoiceItem({
    required this.id,
    required this.userDatos,
    required this.idModulo,
    required this.numOrden,
    required this.date,
    required this.dateCurrent,
    required this.logo,
    required this.cantPcs,
    required this.cantPunts,
    required this.velozMachine,
    required this.calida,
    required this.timeMachine,
    required this.comment,
    required this.turn,
    required this.tStop,
    required this.porcentTimeMiss,
    required this.tGeneralTime,
    required this.tWorkedTime,
    required this.pcsElaborated,
  });
}

class InvoiceItemFinalOrden {
  String? numOrden;
  String? turn;
  String? dateCurrent;
  String? calida;
  String? cantPcs;
  String? pcsBad;
  String? cantTirada;
  String? pcsTirada;
  String? eficienciaTotal;
  String? deficienciaTotal;
  String? logo;

  InvoiceItemFinalOrden({
    required this.numOrden,
    required this.turn,
    required this.dateCurrent,
    required this.calida,
    required this.cantPcs,
    required this.pcsBad,
    required this.cantTirada,
    required this.pcsTirada,
    required this.eficienciaTotal,
    required this.deficienciaTotal,
    required this.logo,
  });
}
