import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String? id;
  final String? fullname;
  final String admissionNumber;
  final String? department;
  final String? yearOfAdmin;
  final String? coverImage;
  final String? profileImage;
  final String password;
  final String gender;
  final String ugLevel;
  final String email;
  final String token;
  final String type;
  UserModel({
    this.id,
    this.fullname,
    required this.admissionNumber,
    this.department,
    this.yearOfAdmin,
    this.coverImage,
    this.profileImage,
    required this.password,
    required this.gender,
    required this.ugLevel,
    required this.email,
    required this.token,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullname': fullname,
      'admissionNumber': admissionNumber,
      'department': department,
      'coverImage': coverImage,
      'profileImage': profileImage,
      'yearOfAdmin': yearOfAdmin,
      'password': password,
      'gender': gender,
      'ugLevel': ugLevel,
      'email': email,
      'token': token,
      'type': type,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] as String,
      fullname: map['fullname'] != null ? map['fullname'] as String : null,
      admissionNumber: map['admissionNumber'] as String,
      department:
          map['department'] != null ? map['department'] as String : null,
      coverImage:
          map['coverImage'] != null ? map['coverImage'] as String : null,
      profileImage:
          map['profileImage'] != null ? map['profileImage'] as String : null,
      yearOfAdmin:
          map['yearOfAdmin'] != null ? map['yearOfAdmin'] as String : null,
      password: map['password'] as String,
      gender: map['gender'] as String,
      ugLevel: map['ugLevel'] as String,
      email: map['email'] as String,
      token: map['token'] as String,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
