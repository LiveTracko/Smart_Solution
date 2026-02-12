import 'dart:convert';

AdminDisbursementModel adminDisbursementModelFromJson(String str) =>
    AdminDisbursementModel.fromJson(json.decode(str));

String adminDisbursementModelToJson(AdminDisbursementModel data) =>
    json.encode(data.toJson());

class AdminDisbursementModel {
  List<Datum> data;

  AdminDisbursementModel({
    required this.data,
  });

  factory AdminDisbursementModel.fromJson(Map<String, dynamic> json) =>
      AdminDisbursementModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  String name;
  String? profileImage;
  String loginCount;
  String disbursedCount;
  String amount;

  Datum({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.loginCount,
    required this.disbursedCount,
    required this.amount,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        profileImage: json["profile_image"],
        loginCount: json["login_count"],
        disbursedCount: json["disbursed_count"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "profile_image": profileImage,
        "login_count": loginCount,
        "disbursed_count": disbursedCount,
        "amount": amount,
      };
}
