import 'dart:convert';

ProductTypeList productTypeListFromJson(String str) =>
    ProductTypeList.fromJson(json.decode(str));

String productTypeListToJson(ProductTypeList data) =>
    json.encode(data.toJson());

class ProductTypeList {
  List<productData> data;

  ProductTypeList({
    required this.data,
  });

  factory ProductTypeList.fromJson(Map<String, dynamic> json) =>
      ProductTypeList(
        data: List<productData>.from(json["data"].map((x) => productData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class productData {
  String id;
  String name;
  String ptype;

  productData({
    required this.id,
    required this.name,
    required this.ptype,
  });

  factory productData.fromJson(Map<String, dynamic> json) => productData(
        id: json["id"],
        name: json["name"],
        ptype: json["ptype"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "ptype": ptype,
      };
}
