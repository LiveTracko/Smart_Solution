import 'dart:convert';

CallLogModel callLogModelFromJson(String str) =>
    CallLogModel.fromJson(json.decode(str));

String callLogModelToJson(CallLogModel data) => json.encode(data.toJson());

class CallLogModel {
  List<Datum> data;

  CallLogModel({
    required this.data,
  });

  factory CallLogModel.fromJson(Map<String, dynamic> json) => CallLogModel(
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
  String callAttempt;
  String callContacted;
  String callNotcontact;
  String callLeadconverstion;
  String totalCallTime;

  Datum({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.callAttempt,
    required this.callContacted,
    required this.callNotcontact,
    required this.callLeadconverstion,
    required this.totalCallTime,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        profileImage: json['profile_image'],
        callAttempt: json["call_attempt"],
        callContacted: json["call_contacted"],
        callNotcontact: json["call_notcontact"],
        callLeadconverstion: json["call_leadconverstion"],
        totalCallTime: json["total_call_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "profile_image": profileImage,
        "call_attempt": callAttempt,
        "call_contacted": callContacted,
        "call_notcontact": callNotcontact,
        "call_leadconverstion": callLeadconverstion,
        "total_call_time": totalCallTime,
      };
}
