import 'dart:convert';

List<Register> registerFromJson(String str) =>
    List<Register>.from(json.decode(str).map((x) => Register.fromJson(x)));

String registerToJson(List<Register> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Register {
  String? id;
  String? numOrden;
  String? fecha;
  String? statu;
  String? userRegister;

  Register({
    this.id,
    this.numOrden,
    this.fecha,
    this.statu,
    this.userRegister,
  });

  Register copyWith({
    String? id,
    String? numOrden,
    String? fecha,
    String? statu,
    String? userRegister,
  }) =>
      Register(
        id: id ?? this.id,
        numOrden: numOrden ?? this.numOrden,
        fecha: fecha ?? this.fecha,
        statu: statu ?? this.statu,
        userRegister: userRegister ?? this.userRegister,
      );

  factory Register.fromJson(Map<String, dynamic> json) => Register(
        id: json["id"],
        numOrden: json["num_orden"],
        fecha: json["fecha"],
        statu: json["statu"],
        userRegister: json["user_register"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "num_orden": numOrden,
        "fecha": fecha,
        "statu": statu,
        "user_register": userRegister,
      };
}

class ResumeRegister {
  String? empleado;
  String? entradas;
  String? salidas;
  ResumeRegister({this.empleado, this.entradas, this.salidas});

  getTotalEntradas(List<ResumeRegister> list) {
    int value = 0;
    for (var element in list) {
      value += int.parse(element.entradas ?? '0');
    }
    return value;
  }

  getTotalSalidas(List<ResumeRegister> list) {
    int value = 0;
    for (var element in list) {
      value += int.parse(element.salidas ?? '0');
    }
    return value;
  }
}
