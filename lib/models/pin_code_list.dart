import 'dart:convert';

PinCodeList pinCodeListFromJson(String str) =>
    PinCodeList.fromJson(json.decode(str));

String pinCodeListToJson(PinCodeList data) => json.encode(data.toJson());

class PinCodeList {
  List<Datum>? data;

  PinCodeList({
    this.data,
  });

  factory PinCodeList.fromJson(Map<String, dynamic> json) => PinCodeList(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? id;
  String? dsa;
  String? bankName;
  String? pincode;
  String? city;
  String? dataType;
  dynamic created;
  String? dsaName;
  String? address;
  String? gstin;

  Datum({
    this.id,
    this.dsa,
    this.bankName,
    this.pincode,
    this.city,
    this.dataType,
    this.created,
    this.dsaName,
    this.address,
    this.gstin,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      id: json["id"] ?? '',
      dsa: json["dsa"] ?? '',
      bankName: json["bank_name"] ?? '',
      pincode: json["pincode"] ?? '',
      city: json["city"] ?? '',
      dataType: json["data_type"] ?? '',
      created: json["created"],
      dsaName: json["dsa_name"] ?? '',
      address: json["address"] ?? '',
      gstin: json["gstin"] ?? '');

  Map<String, dynamic> toJson() => {
        "id": id,
        "dsa": dsa,
        "bank_name": bankName,
        "pincode": pincode,
        "city": city,
        "data_type": dataType,
        "created": created,
        "dsa_name": [dsaName],
        "address": address,
        "gstin": [gstin],
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
