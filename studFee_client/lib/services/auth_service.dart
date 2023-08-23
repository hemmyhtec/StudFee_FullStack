// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studfees/components/auth_screen.dart';
import 'package:studfees/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:studfees/provider/user_provider.dart';
import 'package:studfees/screens/auth/login.dart';
import 'package:studfees/util/config.dart';
import 'package:studfees/util/handle_errors.dart';
import 'package:studfees/util/navigator.dart';

class AuthServiceProvider {
  void registerUser({
    required BuildContext context,
    required String admissionNumber,
    required String password,
    required String email,
    required String gender,
    required String ugLevel,
  }) async {
    try {
      UserModel user = UserModel(
        admissionNumber: admissionNumber,
        password: password,
        gender: gender,
        email: email,
        ugLevel: ugLevel,
        token: '',
        type: 'Student',
      );
      http.Response response = await http.post(
        Uri.parse('$url/register'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
      );
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: (() {
          nextScreenReplace(context, const LoginScreen());
        }),
        onFailed: (() {
          Navigator.pop(context);
        }),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void signUserIn({
    required BuildContext context,
    required String admissionNumber,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(Uri.parse('$url/userSign'),
          body: jsonEncode(
            {
              'admissionNumber': admissionNumber,
              'password': password,
            },
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
          });
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false)
              .setUser(response.body);
          await prefs.setString(
            'x-auth-token',
            jsonDecode(response.body)['token'],
          );
          Navigator.pushNamedAndRemoveUntil(
              context, AuthScreen.routeName, (route) => false);
        },
        onFailed: () {
          Navigator.pop(context);
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(Uri.parse('$url/tokenIsValid'),
          headers: <String, String>{
            'Content-Type': 'application/json, charset=UTF-8',
            'x-auth-token': token!
          });

      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        http.Response userResponse = await http
            .get(Uri.parse('$url/getUserData'), headers: <String, String>{
          'Content-Type': 'application/json, charset=UTF-8',
          'x-auth-token': token
        });
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userResponse.body);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // String? profileImageUrl;
  void uploadCoverImage(
      {required BuildContext context, required File coverImage}) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      String coverImageUrl;
      CloudinaryResponse newResponse = await Config.cloudinary.uploadFile(
        CloudinaryFile.fromFile(coverImage.path,
            resourceType: CloudinaryResourceType.Image,
            folder: 'StudFees/CoverImages'),
      );
      coverImageUrl = newResponse.secureUrl;

      http.Response response = await http.put(
        Uri.parse('$url/updateData'),
        body: jsonEncode({'coverImage': coverImageUrl}),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          var userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(response.body);
        },
        onFailed: () {
          Navigator.pop(context);
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void uploadProfileImage(
      {required BuildContext context, required File profileImage}) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      String profileImageUrl;
      CloudinaryResponse response = await Config.cloudinary.uploadFile(
        CloudinaryFile.fromFile(profileImage.path,
            resourceType: CloudinaryResourceType.Image,
            folder: 'StudFees/CoverImages'),
      );
      profileImageUrl = response.secureUrl;

      http.Response newResponse = await http.put(
        Uri.parse('$url/updateData'),
        body: jsonEncode({'profileImage': profileImageUrl}),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandle(
        response: newResponse,
        context: context,
        onSuccess: () {
          Navigator.popAndPushNamed(context, '/profile-screen');
        },
        onFailed: () {
          Navigator.pop(context);
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void forgetPassword({
    required BuildContext context,
    required String email,
  }) async {
    try {
      http.Response response =
          await http.post(Uri.parse('$url/resetPasswordToken'),
              body: jsonEncode(
                {
                  'email': email,
                },
              ),
              headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
          });
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () async {
          nextScreenReplace(context, const LoginScreen());
        },
        onFailed: () {
          Navigator.pop(context);
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
