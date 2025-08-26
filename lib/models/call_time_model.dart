// import 'package:intl/intl.dart';
// import 'package:smart_solutions/components/commons.dart';

class GetCallTimeModel {
  CallTimeModel? callTimeModel;

  GetCallTimeModel({this.callTimeModel});

  GetCallTimeModel.fromJson(Map<String, dynamic> json) {
    callTimeModel =
        json['data'] != null ? CallTimeModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (callTimeModel != null) {
      data['data'] = callTimeModel!.toJson();
    }
    return data;
  }
}

class CallTimeModel {
  int? totalAttempt;
  List<TotalContact>? totalContact;
  List<TotalAttemptContact>? totalAttemptContact;

  List<TotalNoContact>? totalNocontact;
  String? totalDuration;

  CallTimeModel(
      {this.totalAttempt,
      this.totalContact,
      this.totalNocontact,
      this.totalDuration});

  CallTimeModel.fromJson(Map<String, dynamic> json) {
    totalAttempt = json['total_attempt'];
    totalDuration = json['total_callduration'];

    if (json['total_attempt_contact'] != null) {
      totalAttemptContact = <TotalAttemptContact>[];

      json['total_attempt_contact'].forEach((v) {
        totalAttemptContact!.add(TotalAttemptContact.fromJson(v));
      });
    }
    if (json['total_contact'] != null) {
      totalContact = <TotalContact>[];

      json['total_contact'].forEach((v) {
        totalContact!.add(TotalContact.fromJson(v));
      });
    }
    if (json['total_nocontact'] != null) {
      totalNocontact = <TotalNoContact>[];
      json['total_nocontact'].forEach((v) {
        totalNocontact!.add(TotalNoContact.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_attempt'] = totalAttempt;
    if (totalContact != null) {
      data['total_contact'] = totalContact!.map((v) => v.toJson()).toList();
    }
    if (totalNocontact != null) {
      data['total_nocontact'] = totalNocontact!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TotalContact {
  String? callStatus;
  String? created;
  String? count;

  TotalContact({this.callStatus, this.created, this.count});

  TotalContact.fromJson(Map<String, dynamic> json) {
    callStatus = json['call_status'];
    created = json['created'];
    // try {
    //   DateTime dateTime = DateTime.parse(cr);
    //   String formattedTime = DateFormat('h a').format(dateTime);
    //   created = formattedTime;
    // } catch (e) {
    //   customLog('error while parsing time in model $e', name: "TotalNoContact");
    //   created = json['created'];
    // }
    // created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['call_status'] = callStatus;
    data['created'] = created;
    return data;
  }
}

class TotalNoContact {
  String? callStatus;
  String? created;

  TotalNoContact({this.callStatus, this.created});

  TotalNoContact.fromJson(Map<String, dynamic> json) {
    callStatus = json['call_status'];
    created = json['created'];
    // try {
    //   DateTime dateTime = DateTime.parse(cr);
    //   String formattedTime = DateFormat('h a').format(dateTime);
    //   created = formattedTime;
    // } catch (e) {
    //   customLog('error while parsing time in model $e', name: "TotalNoContact");
    //   created = json['created'];
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['call_status'] = callStatus;
    data['created'] = created;
    return data;
  }
}

class TotalAttemptContact {
  String? callStatus;
  String? created;

  TotalAttemptContact({this.callStatus, this.created});

  TotalAttemptContact.fromJson(Map<String, dynamic> json) {
    callStatus = json['call_status'];
    created = json['created'];
    // try {
    //   DateTime dateTime = DateTime.parse(cr);
    //   String formattedTime = DateFormat('h a').format(dateTime);
    //   created = formattedTime;
    // } catch (e) {
    //   customLog('error while parsing time in model $e', name: "TotalNoContact");
    //   created = json['created'];
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['call_status'] = callStatus;
    data['created'] = created;
    return data;
  }
}
