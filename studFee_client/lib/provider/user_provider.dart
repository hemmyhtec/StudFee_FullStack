import 'package:flutter/material.dart';
import 'package:studfees/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel(
    id: null,
    admissionNumber: '',
    password: '',
    gender: '',
    ugLevel: '',
    token: '',
    type: '',
    fullname: '',
    department: '',
    yearOfAdmin: '',
    email: '',
    coverImage: '',
    profileImage: '',
  );

  UserModel get user => _user;
  void setUser(String user) {
    _user = UserModel.fromJson(user);
    notifyListeners();
  }
}
