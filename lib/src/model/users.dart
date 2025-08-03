// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

List<Users> usersFromJson(String str) =>
    List<Users>.from(json.decode(str).map((x) => Users.fromJson(x)));

String usersToJson(List<Users> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<ListPermission> listPermissionFromJson(String str) =>
    List<ListPermission>.from(
        json.decode(str).map((x) => ListPermission.fromJson(x)));

class Users {
  String? id;
  String? fullName;
  String? occupation;
  String? created;
  String? turn;
  String? code;
  String? type;
  String? statu;
  bool? isSelected;
  List<ListPermission>? listPermission;

  Users({
    this.id,
    this.fullName,
    this.occupation,
    this.created,
    this.turn,
    this.code,
    this.type,
    this.statu,
    this.isSelected = false,
    this.listPermission,
  });

  Users copyWith({
    String? id,
    String? fullName,
    String? occupation,
    String? created,
    String? turn,
    String? code,
    String? type,
    String? statu,
    List<ListPermission>? listPermission,
  }) =>
      Users(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        occupation: occupation ?? this.occupation,
        created: created ?? this.created,
        turn: turn ?? this.turn,
        code: code ?? this.code,
        type: type ?? this.type,
        statu: statu ?? this.statu,
        listPermission: listPermission ?? this.listPermission,
      );

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["id"],
        fullName: json["full_name"],
        occupation: json["occupation"],
        created: json["created"],
        turn: json["turn"],
        code: json["code"],
        type: json["type"],
        statu: json["statu"],
        listPermission: json["list_permission"] == null
            ? []
            : List<ListPermission>.from(json["list_permission"]!
                .map((x) => ListPermission.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "occupation": occupation,
        "created": created,
        "turn": turn,
        "code": code,
        "type": type,
        "statu": statu,
        "list_permission": listPermission == null
            ? []
            : List<dynamic>.from(listPermission!.map((x) => x.toJson())),
      };
}

class ListPermission {
  String? idPermisos;
  String? modulo;
  String? action;

  ListPermission({
    this.idPermisos,
    this.modulo,
    this.action,
  });

  ListPermission copyWith({
    String? idPermisos,
    String? modulo,
    String? action,
  }) =>
      ListPermission(
        idPermisos: idPermisos ?? this.idPermisos,
        modulo: modulo ?? this.modulo,
        action: action ?? this.action,
      );

  factory ListPermission.fromJson(Map<String, dynamic> json) => ListPermission(
        idPermisos: json["id_permisos"],
        modulo: json["modulo"],
        action: json["action"],
      );

  Map<String, dynamic> toJson() => {
        "id_permisos": idPermisos,
        "modulo": modulo,
        "action": action,
      };
}

bool hasPermissionUsuario(
    List<ListPermission> permissions, String module, String action) {
  for (var permission in permissions) {
    if (permission.modulo == module && permission.action == action) {
      return true;
    }
  }
  return false;
}
