class GetStatusGroupModel {
  List<StatusGroupModel>? data;

  GetStatusGroupModel({this.data});

  GetStatusGroupModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <StatusGroupModel>[];
      json['data'].forEach((v) {
        data!.add(StatusGroupModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StatusGroupModel {
  String? id;
  String? StatusGroupModelName;
  dynamic status;
  String? sequenceNo;
  String? seqNoNumeric;
  dynamic totalLoanAmount;
  String? filecount;

  StatusGroupModel(
      {this.id,
        this.StatusGroupModelName,
        this.status,
        this.sequenceNo,
        this.seqNoNumeric,
        this.totalLoanAmount,
        this.filecount});

  StatusGroupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    StatusGroupModelName = json['status_group_name'];
    status = json['status'];
    sequenceNo = json['sequence_no'];
    seqNoNumeric = json['seq_no_numeric'];
    totalLoanAmount = json['totalLoanAmount'];
    filecount = json['filecount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['status_group_name'] = this.StatusGroupModelName;
    data['status'] = this.status;
    data['sequence_no'] = this.sequenceNo;
    data['seq_no_numeric'] = this.seqNoNumeric;
    data['totalLoanAmount'] = this.totalLoanAmount;
    data['filecount'] = this.filecount;
    return data;
  }
}
