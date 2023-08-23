// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ReadOnlyTextField extends StatelessWidget {
  TextEditingController controller;
  ReadOnlyTextField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        suffixStyle: const TextStyle(color: Colors.black54),
        labelStyle: const TextStyle(color: Colors.black54, fontSize: 20),
        filled: true,
        fillColor: const Color.fromARGB(255, 230, 230, 230),
        prefixIconColor: Colors.black54,
        focusColor: Colors.black,
        focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.white30),
            borderRadius: BorderRadius.circular(10)),
        errorBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10)),
        enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.white30),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
