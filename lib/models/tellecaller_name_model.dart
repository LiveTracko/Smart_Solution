// To parse this JSON data, do
//
//     final telecallerList = telecallerListFromJson(jsonString);

import 'dart:convert';

TelecallerList telecallerListFromJson(String str) =>
    TelecallerList.fromJson(json.decode(str));

String telecallerListToJson(TelecallerList data) => json.encode(data.toJson());

class TelecallerList {
  List<TellecallerData> data;

  TelecallerList({
    required this.data,
  });

  factory TelecallerList.fromJson(Map<String, dynamic> json) => TelecallerList(
        data: List<TellecallerData>.from(
            json["data"].map((x) => TellecallerData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class TellecallerData {
  String id;
  String name;
  String roleId;

  TellecallerData({
    required this.id,
    required this.name,
    required this.roleId,
  });

  factory TellecallerData.fromJson(Map<String, dynamic> json) =>
      TellecallerData(
        id: json["id"],
        name: json["name"],
        roleId: json["role_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "role_id": roleId,
      };
}
