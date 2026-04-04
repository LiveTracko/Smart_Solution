import 'dart:convert';

CallBackModel callBackModelFromJson(String str) =>
    CallBackModel.fromJson(json.decode(str));

String callBackModelToJson(CallBackModel data) => json.encode(data.toJson());

class CallBackModel {
  List<CallBackData> data;
  Totals totals;

  CallBackModel({
    required this.data,
    required this.totals,
  });

  factory CallBackModel.fromJson(Map<String, dynamic> json) => CallBackModel(
        data: List<CallBackData>.from(
            json["data"].map((x) => CallBackData.fromJson(x))),
        totals: Totals.fromJson(json["totals"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "totals": totals.toJson(),
      };
}

class CallBackData {
  String id;
  String name;
  String profileImage;
  String teamleaderId;
  String todayCallbackCount;
  String monthlyCallbackCount;

  CallBackData({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.teamleaderId,
    required this.todayCallbackCount,
    required this.monthlyCallbackCount,
  });

  factory CallBackData.fromJson(Map<String, dynamic> json) => CallBackData(
        id: json["id"],
        name: json["name"],
        profileImage: json["profile_image"] ?? '',
        teamleaderId: json["team_leader"] ?? '',
        todayCallbackCount: json["today_callback_count"],
        monthlyCallbackCount: json["monthly_callback_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "profile_images": profileImage,
        "team_leader": teamleaderId,
        "today_callback_count": todayCallbackCount,
        "monthly_callback_count": monthlyCallbackCount,
      };
}

class Totals {
  int todayCallbackTotal;
  int monthlyCallbackTotal;

  Totals({
    required this.todayCallbackTotal,
    required this.monthlyCallbackTotal,
  });

  factory Totals.fromJson(Map<String, dynamic> json) => Totals(
        todayCallbackTotal: json["today_callback_total"],
        monthlyCallbackTotal: json["monthly_callback_total"],
      );

  Map<String, dynamic> toJson() => {
        "today_callback_total": todayCallbackTotal,
        "monthly_callback_total": monthlyCallbackTotal,
      };
}
