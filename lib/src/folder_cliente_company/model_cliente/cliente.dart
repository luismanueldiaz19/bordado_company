// To parse this JSON data, do
//
//     final cliente = clienteFromJson(jsonString);

import 'dart:convert';

List<Cliente> clienteFromJson(String str) =>
    List<Cliente>.from(json.decode(str).map((x) => Cliente.fromJson(x)));

String clienteToJson(List<Cliente> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cliente {
  String? idCliente;
  String? nombre;
  String? apellido;
  String? direccion;
  String? telefono;
  String? correoElectronico;
  String? fechaRegistro;

  Cliente({
    this.idCliente,
    this.nombre,
    this.apellido,
    this.direccion,
    this.telefono,
    this.correoElectronico,
    this.fechaRegistro,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        idCliente: json["id_cliente"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        direccion: json["direccion"],
        telefono: json["telefono"],
        correoElectronico: json["correo_electronico"],
        fechaRegistro: json["fecha_registro"],
      );

  Map<String, dynamic> toJson() => {
        "id_cliente": idCliente ?? 'N/A',
        "nombre": nombre ?? 'N/A',
        "apellido": apellido ?? 'N/A',
        "direccion": direccion ?? 'N/A',
        "telefono": telefono ?? 'N/A',
        "correo_electronico": correoElectronico ?? 'N/A',
        "fecha_registro": fechaRegistro ?? 'N/A',
      };
}
