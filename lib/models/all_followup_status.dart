import 'dart:convert';

GetAllFollowupStatus getAllFollowupStatusFromJson(String str) =>
    GetAllFollowupStatus.fromJson(json.decode(str));

String getAllFollowupStatusToJson(GetAllFollowupStatus data) =>
    json.encode(data.toJson());

class GetAllFollowupStatus {
  List<Datum> data;

  GetAllFollowupStatus({
    required this.data,
  });

  factory GetAllFollowupStatus.fromJson(Map<String, dynamic> json) =>
      GetAllFollowupStatus(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  String title;
  String status;

  Datum({
    required this.id,
    required this.title,
    required this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "status": status,
      };
}
