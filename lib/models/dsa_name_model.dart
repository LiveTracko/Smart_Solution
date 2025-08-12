class DsaModel {
  String? id;
  String? dsaName;
  String? address;
  String? gstin;
  String? dataType;
  String? created;

  DsaModel({
    this.id,
    this.dsaName,
    this.address,
    this.gstin,
    this.dataType,
    this.created,
  });

  factory DsaModel.fromJson(Map<String, dynamic> json) {
    return DsaModel(
        id: json['id'],
        dsaName: json['dsa_name'],
        address: json['address'],
        gstin: json['gstin'],
        dataType: json['data_type'],
        created: json['created']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dsa_name': dsaName,
      'address': address,
      'gstin': gstin,
      'data_type': dataType,
      'created': created
    };
  }
}
