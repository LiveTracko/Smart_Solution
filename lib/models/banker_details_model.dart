

import 'dart:convert';

BankerDetails bankerDetailsFromJson(String str) => BankerDetails.fromJson(json.decode(str));

String bankerDetailsToJson(BankerDetails data) => json.encode(data.toJson());

class BankerDetails {
    List<BankerDetailsData> data;

    BankerDetails({
        required this.data,
    });

    factory BankerDetails.fromJson(Map<String, dynamic> json) => BankerDetails(
        data: List<BankerDetailsData>.from(json["data"].map((x) => BankerDetailsData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class BankerDetailsData {
    String id;
    String bankName;
    String bankerName;
    String bankerCode;
    String source;
    String product;
    String state;
    String location;
    String designation;
    String mobile;
    String email;
    String dataType;
    DateTime created;

    BankerDetailsData({
        required this.id,
        required this.bankName,
        required this.bankerName,
        required this.bankerCode,
        required this.source,
        required this.product,
        required this.state,
        required this.location,
        required this.designation,
        required this.mobile,
        required this.email,
        required this.dataType,
        required this.created,
    });

    factory BankerDetailsData.fromJson(Map<String, dynamic> json) => BankerDetailsData(
        id: json["id"],
        bankName: json["bank_name"],
        bankerName: json["banker_name"],
        bankerCode: json["banker_code"],
        source: json["source"],
        product: json["product"],
        state: json["state"],
        location: json["location"],
        designation: json["designation"],
        mobile: json["mobile"],
        email: json["email"],
        dataType: json["data_type"],
        created: DateTime.parse(json["created"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "bank_name": bankName,
        "banker_name": bankerName,
        "banker_code": bankerCode,
        "source": source,
        "product": product,
        "state": state,
        "location": location,
        "designation": designation,
        "mobile": mobile,
        "email": email,
        "data_type": dataType,
        "created": created.toIso8601String(),
    };
}
