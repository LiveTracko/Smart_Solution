
import 'dart:convert';

AllDisbursementDetails allDisbursementDetailsFromJson(String str) => AllDisbursementDetails.fromJson(json.decode(str));

String allDisbursementDetailsToJson(AllDisbursementDetails data) => json.encode(data.toJson());

class AllDisbursementDetails {
    List<Datum> data;

    AllDisbursementDetails({
        required this.data,
    });

    factory AllDisbursementDetails.fromJson(Map<String, dynamic> json) => AllDisbursementDetails(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String? year;
    String? month;
    String? monthName;
    String amount;

    Datum({
        required this.year,
        required this.month,
        required this.monthName,
        required this.amount,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        year: json["year"],
        month: json["month"],
        monthName: json["month_name"],
        amount: json["amount"],
    );

    Map<String, dynamic> toJson() => {
        "year": year,
        "month": month,
        "month_name": monthName,
        "amount": amount,
    };
}
