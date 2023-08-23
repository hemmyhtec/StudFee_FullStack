import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String test) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(test),
    ),
  );
}
