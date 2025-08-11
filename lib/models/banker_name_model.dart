import 'dart:convert';

BankerName bankerNameFromJson(String str) =>
    BankerName.fromJson(json.decode(str));

String bankerNameToJson(BankerName data) => json.encode(data.toJson());

class BankerName {
  List<BankerNameData> data;

  BankerName({
    required this.data,
  });

  factory BankerName.fromJson(Map<String, dynamic> json) => BankerName(
        data: List<BankerNameData>.from(
            json["data"].map((x) => BankerNameData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BankerNameData {
  String bankerName;
  String id;

  BankerNameData({
    required this.bankerName,
    required this.id,
  });

  factory BankerNameData.fromJson(Map<String, dynamic> json) => BankerNameData(
        bankerName: json["banker_name"] ?? '',
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "banker_name": bankerName,
        "id": id,
      };
}
