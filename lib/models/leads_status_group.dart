import 'dart:convert';

GetLeadStatusGroup getLeadStatusGroupFromJson(String str) =>
    GetLeadStatusGroup.fromJson(json.decode(str));

String getLeadStatusGroupToJson(GetLeadStatusGroup data) =>
    json.encode(data.toJson());

class GetLeadStatusGroup {
  List<Datum> data;

  GetLeadStatusGroup({
    required this.data,
  });

  factory GetLeadStatusGroup.fromJson(Map<String, dynamic> json) =>
      GetLeadStatusGroup(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  String statusGroupName;
  String? status;
  String sequenceNo;

  Datum({
    required this.id,
    required this.statusGroupName,
    required this.status,
    required this.sequenceNo,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        statusGroupName: json["status_group_name"],
        status: json["status"],
        sequenceNo: json["sequence_no"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status_group_name": statusGroupName,
        "status": status,
        "sequence_no": sequenceNo,
      };
}
