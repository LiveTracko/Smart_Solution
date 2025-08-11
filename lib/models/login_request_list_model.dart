import 'package:intl/intl.dart';

class LoginRequest {
  final String id;
  final DateTime loginRequestDate;
  final String telecallerId;
  final String customerName;
  final String contactNumber;
  final String? loanStatus; // Nullable loan status
  final String bankId;
  final String loanAmount;
  final String commonRemark;
  final String remark;
  final DateTime created;
  final String? title; // Nullable title
  final String? bankName; // Nullable title
  final String? sourcing;
  final String? sourcingTitle;

  LoginRequest({
    required this.id,
    required this.loginRequestDate,
    required this.telecallerId,
    required this.customerName,
    required this.contactNumber,
    this.loanStatus, // Optional
    required this.bankId,
    required this.loanAmount,
    required this.commonRemark,
    required this.remark,
    required this.created,
    this.title, // Optional
    this.bankName,
    required this.sourcing,
    this.sourcingTitle,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      id: json['id'] as String,
      loginRequestDate:
          DateFormat("dd-MM-yyyy HH:mm").parse(json['login_request_date']),
      telecallerId: json['telecaller_id'] as String,
      customerName: json['customer_name'] as String,
      contactNumber: json['contact_number'] as String,
      loanStatus: json['loan_status'], // Nullable field
      bankId: json['bank_id'] as String,
      loanAmount: json['loan_amount'] as String,
      commonRemark: json['common_remark'] as String,
      remark: json['remark'] as String,
      created: DateTime.parse(json['created']),
      title: json['title'] ?? '', // Nullable field
      bankName: json['bank_name'] ?? '', // Nullable field
      sourcing: (json['sourcing'] ?? '') as String,
      sourcingTitle: (json['sourcing_title'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'login_request_date':
          DateFormat("dd-MM-yyyy HH:mm").format(loginRequestDate),
      'telecaller_id': telecallerId,
      'customer_name': customerName,
      'contact_number': contactNumber,
      'loan_status': loanStatus,
      'bank_id': bankId,
      'loan_amount': loanAmount,
      'common_remark': commonRemark,
      'remark': remark,
      'created': created.toIso8601String(),
      'title': title,
      'bank_name': bankName,
      'sourcing': sourcing,
      'sourcing_title': sourcingTitle,
    };
  }
}
