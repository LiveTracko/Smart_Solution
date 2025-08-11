class DataEntryBankList {
  final String dsaId;
  final String bankName;

  DataEntryBankList({
    required this.dsaId,
    required this.bankName,
  });

  // Factory method to create an instance from a JSON object
  factory DataEntryBankList.fromJson(Map<String, dynamic> json) {
    return DataEntryBankList(
      dsaId: json['dsa_id'] as String,
      bankName: json['bank_name'] as String,
    );
  }

  // Method to convert an instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'dsa_id': dsaId,
      'bank_name': bankName,
    };
  }
}

// Function to parse a list of banks from JSON data
List<DataEntryBankList> parseBankList(List<dynamic> data) {
  return data.map((item) => DataEntryBankList.fromJson(item)).toList();
}
