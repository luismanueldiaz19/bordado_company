// To parse this JSON data, do
//
//     final reporteFinal = reporteFinalFromJson(jsonString);

import 'dart:convert';

ReporteFinal reporteFinalFromJson(String str) =>
    ReporteFinal.fromJson(json.decode(str));

String reporteFinalToJson(ReporteFinal data) => json.encode(data.toJson());

class ReporteFinal {
  CarmeloLopez carmeloLopez;
  CarmeloLopez general;

  ReporteFinal({
    required this.carmeloLopez,
    required this.general,
  });

  factory ReporteFinal.fromJson(Map<String, dynamic> json) => ReporteFinal(
        carmeloLopez: CarmeloLopez.fromJson(json["Carmelo Lopez"]),
        general: CarmeloLopez.fromJson(json["general"]),
      );

  Map<String, dynamic> toJson() => {
        "Carmelo Lopez": carmeloLopez.toJson(),
        "general": general.toJson(),
      };
}

class CarmeloLopez {
  String? tajima6A;
  String? tajima1;
  String? tajima12;
  String? barudan1;
  String? barudan6;
  String? tajima6B;
  String? total;

  CarmeloLopez({
    this.tajima6A,
    this.tajima1,
    this.tajima12,
    this.barudan1,
    this.barudan6,
    this.tajima6B,
    this.total,
  });

  factory CarmeloLopez.fromJson(Map<String, dynamic>? json) => CarmeloLopez(
        tajima6A: json?["TAJIMA -6-A"] ?? '0',
        tajima1: json?["TAJIMA -1"] ?? '0',
        tajima12: json?["TAJIMA -12"] ?? '0',
        barudan1: json?["BARUDAN -1"] ?? '0',
        barudan6: json?["BARUDAN -6"] ?? '0',
        tajima6B: json?["TAJIMA -6-B"] ?? '0',
        total: json?["total"] ?? '0',
      );

  Map<String, dynamic> toJson() => {
        "TAJIMA -6-A": tajima6A,
        "TAJIMA -1": tajima1,
        "TAJIMA -12": tajima12,
        "BARUDAN -1": barudan1,
        "BARUDAN -6": barudan6,
        "TAJIMA -6-B": tajima6B,
        "total": total,
      };
}

