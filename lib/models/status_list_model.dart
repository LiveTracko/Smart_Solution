import 'dart:convert';

StatusList statusListFromJson(String str) =>
    StatusList.fromJson(json.decode(str));

String statusListToJson(StatusList data) => json.encode(data.toJson());

class StatusList {
  List<statusData> data;

  StatusList({
    required this.data,
  });

  factory StatusList.fromJson(Map<String, dynamic> json) => StatusList(
        data: List<statusData>.from(
            json["data"].map((x) => statusData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class statusData {
  String id;
  String dataEntryStatus;
  String statusGroupId;
  String status;
  DateTime created;

  statusData({
    required this.id,
    required this.dataEntryStatus,
    required this.statusGroupId,
    required this.status,
    required this.created,
  });

  factory statusData.fromJson(Map<String, dynamic> json) => statusData(
        id: json["id"],
        dataEntryStatus: json["data_entry_status"],
        statusGroupId: json["status_group_id"],
        status: json["status"],
        created: DateTime.parse(json["created"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "data_entry_status": dataEntryStatus,
        "status_group_id": statusGroupId,
        "status": status,
        "created": created.toIso8601String(),
      };
}
