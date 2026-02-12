import 'dart:convert';

AdminLoginRequestModel adminLoginRequestModelFromJson(String str) =>
    AdminLoginRequestModel.fromJson(json.decode(str));

String adminLoginRequestModelToJson(AdminLoginRequestModel data) =>
    json.encode(data.toJson());

class AdminLoginRequestModel {
  List<Datum> data;

  AdminLoginRequestModel({
    required this.data,
  });

  factory AdminLoginRequestModel.fromJson(Map<String, dynamic> json) =>
      AdminLoginRequestModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String name;
  String? profileImage;
  String? teamleaderId;
  dynamic monthlycount;
  dynamic todaycount;

  Datum({
    required this.name,
    this.profileImage,
    this.teamleaderId,
    required this.monthlycount,
    required this.todaycount,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        name: json["name"],
        profileImage: json["profile_image"],
        teamleaderId: json["teamleader_id"],
        monthlycount: json["monthlycount"],
        todaycount: json["todaycount"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "profile_image": profileImage,
        "teamleader_id": teamleaderId,
        "monthlycount": monthlycount,
        "todaycount": todaycount,
      };
}
