// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  TextEditingController editingController;
  TextInputType textInputType;
  String labelText;
  TextInputAction textInputAction;
  // ignore: prefer_typing_uninitialized_variables
  var validator;
  bool isPassword;
  // bool isIcon;

  CustomTextField({
    Key? key,
    required this.editingController,
    required this.textInputType,
    required this.labelText,
    required this.textInputAction,
    required this.validator,
    required this.isPassword,
    // required this.isIcon,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      style: GoogleFonts.inter(
        color: Colors.black,
        fontSize: 20,
      ),
      textInputAction: widget.textInputAction,
      controller: widget.editingController,
      keyboardType: widget.textInputType,
      obscureText: widget.isPassword ? _obscureText : !_obscureText,
      decoration: InputDecoration(
        suffixStyle: const TextStyle(color: Colors.black54),
        suffixIcon: widget.isPassword
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                    !_obscureText ? Icons.visibility_off : Icons.visibility),
              )
            : null,
        labelStyle: const TextStyle(color: Colors.black54, fontSize: 20),
        labelText: widget.labelText,
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
