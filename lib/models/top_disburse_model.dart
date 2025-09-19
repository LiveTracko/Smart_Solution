// To parse this JSON data, do
//
//     final topDisburseUser = topDisburseUserFromJson(jsonString);

import 'dart:convert';

TopDisburseUser topDisburseUserFromJson(String str) =>
    TopDisburseUser.fromJson(json.decode(str));

String topDisburseUserToJson(TopDisburseUser data) =>
    json.encode(data.toJson());

class TopDisburseUser {
  Monthly yearly;
  Monthly monthly;

  TopDisburseUser({
    required this.yearly,
    required this.monthly,
  });

  factory TopDisburseUser.fromJson(Map<String, dynamic> json) =>
      TopDisburseUser(
        yearly: Monthly.fromJson(json["yearly"]),
        monthly: Monthly.fromJson(json["monthly"]),
      );

  Map<String, dynamic> toJson() => {
        "yearly": yearly.toJson(),
        "monthly": monthly.toJson(),
      };
}

class Monthly {
  String id;
  String name;
  String? profileImage;
  String amount;

  Monthly({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.amount,
  });

  factory Monthly.fromJson(Map<String, dynamic> json) => Monthly(
        id: json["id"],
        name: json["name"],
        profileImage: json["profile_image"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "profile_image": profileImage,
        "amount": amount,
      };
}
