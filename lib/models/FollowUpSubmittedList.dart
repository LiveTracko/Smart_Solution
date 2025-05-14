class FollowUpSubmitedList {
  List<Data>? data;

  FollowUpSubmitedList({this.data});

  FollowUpSubmitedList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = {};
    if (data != null) {
      jsonData['data'] = data!.map((v) => v.toJson()).toList();
    }
    return jsonData;
  }
}

class Data {
  String? id;
  String? entryDate;
  String? customerName;
  String? contactNumber;
  String? bankName;
  String? dataType;
  String? salary;
  String? followupDate;
  String? contactStatus;
  String? remarkStatus;
  String? remark;
  String? excelDataId; // New field
  String? callDuration; // New field
  String? telecallerId;
  String? tcname;

  Data({
    this.id,
    this.entryDate,
    this.customerName,
    this.contactNumber,
    this.bankName,
    this.dataType,
    this.salary,
    this.followupDate,
    this.contactStatus,
    this.remarkStatus,
    this.remark,
    this.excelDataId, // New field
    this.callDuration, // New field
    this.telecallerId,
    this.tcname,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    entryDate = json['entry_date'];
    customerName = json['customer_name'];
    contactNumber = json['contact_number'];
    bankName = json['bank_name'];
    dataType = json['data_type'];
    salary = json['salary'];
    followupDate = json['followup_date'];
    contactStatus = json['contact_status'];
    remarkStatus = json['remark_status'];
    remark = json['remark'];
    excelDataId = json['excel_data_id']; // New field
    callDuration = json['call_duration']; // New field
    telecallerId = json['telecaller_id'];
    tcname = json['tcname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = {};
    jsonData['id'] = id;
    jsonData['entry_date'] = entryDate;
    jsonData['customer_name'] = customerName;
    jsonData['contact_number'] = contactNumber;
    jsonData['bank_name'] = bankName;
    jsonData['data_type'] = dataType;
    jsonData['salary'] = salary;
    jsonData['followup_date'] = followupDate;
    jsonData['contact_status'] = contactStatus;
    jsonData['remark_status'] = remarkStatus;
    jsonData['remark'] = remark;
    jsonData['excel_data_id'] = excelDataId; // New field
    jsonData['call_duration'] = callDuration; // New field
    jsonData['telecaller_id'] = telecallerId;
    jsonData['tcname'] = tcname;
    return jsonData;
  }
}
