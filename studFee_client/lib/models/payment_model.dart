import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Levy {
  final String id;
  final String departmentName;
  final String levyName;
  final int feeAmount;
  Levy({
    required this.id,
    required this.departmentName,
    required this.levyName,
    required this.feeAmount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'departmentName': departmentName,
      'levyName': levyName,
      'feeAmount': feeAmount,
    };
  }

  factory Levy.fromMap(Map<String, dynamic> map) {
    return Levy(
      id: map['_id'] as String,
      departmentName: map['departmentName'] as String,
      levyName: map['levyName'] as String,
      feeAmount: map['feeAmount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Levy.fromJson(String source) =>
      Levy.fromMap(json.decode(source) as Map<String, dynamic>);
}
