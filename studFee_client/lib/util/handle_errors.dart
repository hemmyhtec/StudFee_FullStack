import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:studfees/util/snak_message.dart';

import 'alert_dailog.dart';
import 'config.dart';

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
  required VoidCallback onFailed,
}) {
  switch (response.statusCode) {
    case 200:
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertBox(
            buttonColor: Config.primaryColor,
            buttonText: 'Okay',
            color: Config.primaryColor,
            alertText: jsonDecode(response.body)['msg'],
            callback: onSuccess,
            icon: Icons.check,
          );
        },
      );
      break;
    case 300:
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertBox(
            buttonColor: Config.primaryColor,
            buttonText: 'Okay',
            color: Config.primaryColor,
            alertText: jsonDecode(response.body)['msg'],
            callback: onSuccess,
            icon: Icons.check,
          );
        },
      );
      break;
    case 400:
      // showSnackBar(context, jsonDecode(response.body)['msg']);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertBox(
            buttonColor: Colors.red,
            buttonText: 'Retry',
            color: Colors.red,
            alertText: jsonDecode(response.body)['msg'],
            callback: onFailed,
            icon: Icons.sms_failed,
          );
        },
      );
      break;
    case 500:
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertBox(
            buttonColor: Colors.red,
            buttonText: 'Retry',
            color: Colors.red,
            alertText: jsonDecode(response.body)['msg'],
            callback: onFailed,
            icon: Icons.sms_failed,
          );
        },
      );
      break;
    default:
      showSnackBar(context, jsonDecode(response.body)['msg']);
  }
}
