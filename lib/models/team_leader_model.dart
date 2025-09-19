
import 'dart:convert';

TealLeaderModel tealLeaderModelFromJson(String str) => TealLeaderModel.fromJson(json.decode(str));

String tealLeaderModelToJson(TealLeaderModel data) => json.encode(data.toJson());

class TealLeaderModel {
    List<TeamleaderData> data;

    TealLeaderModel({
        required this.data,
    });

    factory TealLeaderModel.fromJson(Map<String, dynamic> json) => TealLeaderModel(
        data: List<TeamleaderData>.from(json["data"].map((x) => TeamleaderData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class TeamleaderData {
    String name;
    String id;

    TeamleaderData({
        required this.name,
        required this.id,
    });

    factory TeamleaderData.fromJson(Map<String, dynamic> json) => TeamleaderData(
        name: json["name"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
    };
}
