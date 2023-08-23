import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Payment {
  final String? id;
  final String? createdAt;
  final String? fullName;
  final String? userEmail;
  final String levyName;
  final String? paymentStatus;
  final String? referenceId;
  final int feeAmount;
  Payment({
    this.id,
    this.createdAt,
    this.fullName,
    this.userEmail,
    required this.levyName,
    this.paymentStatus,
    this.referenceId,
    required this.feeAmount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt,
      'fullName': fullName,
      'userEmail': userEmail,
      'levyName': levyName,
      'paymentStatus': paymentStatus,
      'referenceId': referenceId,
      'feeAmount': feeAmount,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['_id'] as String,
      createdAt: map['createdAt'] as String,
      fullName: map['userName'] as String,
      userEmail: map['userEmail'] as String,
      levyName: map['levyName'] as String,
      paymentStatus: map['paymentStatus'] as String,
      referenceId: map['referenceId'] as String,
      feeAmount: map['feeAmount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Payment.fromJson(String source) =>
      Payment.fromMap(json.decode(source) as Map<String, dynamic>);
}
