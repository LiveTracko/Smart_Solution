class SourceModel {
  String? id;
  String? sourcingTitle;
  String? dataType;

  SourceModel({
    this.id,
    this.sourcingTitle,
    this.dataType,
  });

  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(
      id: json['id'],
      sourcingTitle: json['sourcing_title'],
      dataType: json['data_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sourcing_title': sourcingTitle,
      'data_type': dataType,
    };
  }
}
