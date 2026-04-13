// To parse this JSON data, do
//
//     final moveToLoginModel = moveToLoginModelFromJson(jsonString);

import 'dart:convert';

MoveToLoginModel moveToLoginModelFromJson(String str) =>
    MoveToLoginModel.fromJson(json.decode(str));

String moveToLoginModelToJson(MoveToLoginModel data) =>
    json.encode(data.toJson());

class MoveToLoginModel {
  LoginModel data;

  MoveToLoginModel({
    required this.data,
  });

  factory MoveToLoginModel.fromJson(Map<String, dynamic> json) =>
      MoveToLoginModel(
        data: LoginModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class LoginModel {
  String contactNumber;
  String sourcing;
  String loanAmount;
  String telecallerId;
  String loginRequestId;
  CustomerLoginModel customerLoginModel;

  LoginModel({
    required this.contactNumber,
    required this.sourcing,
    required this.loanAmount,
    required this.telecallerId,
    required this.loginRequestId,
    required this.customerLoginModel,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        contactNumber: json["contact_number"] ?? "",
        sourcing: json["sourcing"] ?? "",
        loanAmount: json["loan_amount"] ?? "",
        telecallerId: json["telecaller_id"] ?? "",
        loginRequestId: json["login_request_id"] ?? "",
        customerLoginModel:
            CustomerLoginModel.fromJson(json["customer_data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "contact_number": contactNumber,
        "sourcing": sourcing,
        "loan_amount": loanAmount,
        "telecaller_id": telecallerId,
        "login_request_id": loginRequestId,
        "customer_data": customerLoginModel.toJson(),
      };
}

class CustomerLoginModel {
  String customerName;
  dynamic dob;
  String companyName;
  String netIncome;

  CustomerLoginModel({
    required this.customerName,
    required this.dob,
    required this.companyName,
    required this.netIncome,
  });

  factory CustomerLoginModel.fromJson(Map<String, dynamic> json) =>
      CustomerLoginModel(
        customerName: json["customer_name"] ?? "",
        dob: json["dob"] ?? "",
        companyName: json["companyName"] ?? "",
        netIncome: json["netIncome"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "customer_name": customerName,
        "dob": dob,
        "companyName": companyName,
        "netIncome": netIncome,
      };
}
