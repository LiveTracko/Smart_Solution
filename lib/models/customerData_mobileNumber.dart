import 'dart:convert';

CustomerDataByMobileNumber dataByMobileNumberFromJson(String str) =>
    CustomerDataByMobileNumber.fromJson(json.decode(str));

String dataByMobileNumberToJson(CustomerDataByMobileNumber data) =>
    json.encode(data.toJson());

class CustomerDataByMobileNumber {
  CustomerData data;

  CustomerDataByMobileNumber({
    required this.data,
  });

  factory CustomerDataByMobileNumber.fromJson(Map<String, dynamic> json) =>
      CustomerDataByMobileNumber(
        data: CustomerData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class CustomerData {
  String id;
  String name;
  String contactNumber;
  dynamic maritalStatus;
  dynamic spouseName;
  dynamic dependents;
  dynamic personalEmail;
  dynamic officialEmail;
  dynamic motherName;
  dynamic qualification;
  dynamic presentAddress;
  dynamic pincode;
  dynamic state;
  dynamic permanentAddress;
  dynamic perAddPincode;
  dynamic perAddState;
  dynamic residenceStatus;
  dynamic yearsInCity;
  dynamic yearsInCurrentCity;
  dynamic yearsInCurrentResidence;
  dynamic companyName;
  dynamic companyAddress;
  dynamic officePhone;
  dynamic yearsInCurrentCompany;
  dynamic totalWorkExperience;
  dynamic designation;
  dynamic netIncome;
  dynamic reference1Name;
  dynamic reference1Mobile;
  dynamic reference1Address;
  dynamic reference2Name;
  dynamic reference2Mobile;
  dynamic reference2Address;
  String customerType;
  DateTime created;

  CustomerData({
    required this.id,
    required this.name,
    required this.contactNumber,
    required this.maritalStatus,
    required this.spouseName,
    required this.dependents,
    required this.personalEmail,
    required this.officialEmail,
    required this.motherName,
    required this.qualification,
    required this.presentAddress,
    required this.pincode,
    required this.state,
    required this.permanentAddress,
    required this.perAddPincode,
    required this.perAddState,
    required this.residenceStatus,
    required this.yearsInCity,
    required this.yearsInCurrentCity,
    required this.yearsInCurrentResidence,
    required this.companyName,
    required this.companyAddress,
    required this.officePhone,
    required this.yearsInCurrentCompany,
    required this.totalWorkExperience,
    required this.designation,
    required this.netIncome,
    required this.reference1Name,
    required this.reference1Mobile,
    required this.reference1Address,
    required this.reference2Name,
    required this.reference2Mobile,
    required this.reference2Address,
    required this.customerType,
    required this.created,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) => CustomerData(
        id: json["id"],
        name: json["name"],
        contactNumber: json["contactNumber"],
        maritalStatus: json["maritalStatus"],
        spouseName: json["spouseName"],
        dependents: json["dependents"],
        personalEmail: json["personalEmail"],
        officialEmail: json["officialEmail"],
        motherName: json["motherName"],
        qualification: json["qualification"],
        presentAddress: json["presentAddress"],
        pincode: json["pincode"],
        state: json["state"],
        permanentAddress: json["permanentAddress"],
        perAddPincode: json["per_add_pincode"],
        perAddState: json["per_add_state"],
        residenceStatus: json["residenceStatus"],
        yearsInCity: json["yearsInCity"],
        yearsInCurrentCity: json["yearsInCurrentCity"],
        yearsInCurrentResidence: json["yearsInCurrentResidence"],
        companyName: json["companyName"],
        companyAddress: json["companyAddress"],
        officePhone: json["officePhone"],
        yearsInCurrentCompany: json["yearsInCurrentCompany"],
        totalWorkExperience: json["totalWorkExperience"],
        designation: json["designation"],
        netIncome: json["netIncome"],
        reference1Name: json["reference1Name"],
        reference1Mobile: json["reference1Mobile"],
        reference1Address: json["reference1Address"],
        reference2Name: json["reference2Name"],
        reference2Mobile: json["reference2Mobile"],
        reference2Address: json["reference2Address"],
        customerType: json["customer_type"],
        created: DateTime.parse(json["created"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "contactNumber": contactNumber,
        "maritalStatus": maritalStatus,
        "spouseName": spouseName,
        "dependents": dependents,
        "personalEmail": personalEmail,
        "officialEmail": officialEmail,
        "motherName": motherName,
        "qualification": qualification,
        "presentAddress": presentAddress,
        "pincode": pincode,
        "state": state,
        "permanentAddress": permanentAddress,
        "per_add_pincode": perAddPincode,
        "per_add_state": perAddState,
        "residenceStatus": residenceStatus,
        "yearsInCity": yearsInCity,
        "yearsInCurrentCity": yearsInCurrentCity,
        "yearsInCurrentResidence": yearsInCurrentResidence,
        "companyName": companyName,
        "companyAddress": companyAddress,
        "officePhone": officePhone,
        "yearsInCurrentCompany": yearsInCurrentCompany,
        "totalWorkExperience": totalWorkExperience,
        "designation": designation,
        "netIncome": netIncome,
        "reference1Name": reference1Name,
        "reference1Mobile": reference1Mobile,
        "reference1Address": reference1Address,
        "reference2Name": reference2Name,
        "reference2Mobile": reference2Mobile,
        "reference2Address": reference2Address,
        "customer_type": customerType,
        "created": created.toIso8601String(),
      };
}
