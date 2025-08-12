// To parse this JSON data, do
//
//     final companyList = companyListFromJson(jsonString);

import 'dart:convert';

CompanyList companyListFromJson(String str) =>
    CompanyList.fromJson(json.decode(str));

String companyListToJson(CompanyList data) => json.encode(data.toJson());

class CompanyList {
  List<companyData>? data;

  CompanyList({
    this.data,
  });

  factory CompanyList.fromJson(Map<String, dynamic> json) => CompanyList(
        data: json["data"] == null
            ? []
            : List<companyData>.from(
                json["data"]!.map((x) => companyData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class companyData {
  String? id;
  String? dsa;
  String? bankName;
  String? companyName;
  String? category;
  String? dataType;
  dynamic created;
  String? dsaName;
  String? address;
  String? gstin;

  companyData({
    this.id,
    this.dsa,
    this.bankName,
    this.companyName,
    this.category,
    this.dataType,
    this.created,
    this.dsaName,
    this.address,
    this.gstin,
  });

  factory companyData.fromJson(Map<String, dynamic> json) => companyData(
        id: json["id"],
        dsa: json["dsa"],
        bankName: json["bank_name"]!,
        companyName: json["company_name"],
        category: json["category"]!,
        dataType: json["data_type"],
        created: json["created"],
        dsaName: json["dsa_name"]!,
        address: json["address"],
        gstin: json["gstin"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dsa": dsa,
        "bank_name": bankName,
        "company_name": companyName,
        "category": category,
        "data_type": dataType,
        "created": created,
        "dsa_name": dsaName,
        "address": address,
        "gstin": gstin,
      };
}
