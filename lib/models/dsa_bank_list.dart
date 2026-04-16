class DsaBankList {
  List<DsaBank> data;

  DsaBankList({required this.data});

  factory DsaBankList.fromJson(Map<String, dynamic> json) {
    return DsaBankList(
      data: List<DsaBank>.from(json["data"].map((x) => DsaBank.fromJson(x))),
    );
  }
}

class DsaBank {
  String bankName;
  String? bankId;

  DsaBank({required this.bankName, this.bankId});

  factory DsaBank.fromJson(Map<String, dynamic> json) {
    return DsaBank(
      bankName: json["bank_name"],
      bankId: json["bank_id"],
    );
  }
}
