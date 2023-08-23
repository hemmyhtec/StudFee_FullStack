import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../util/config.dart';

class CustomElevated extends StatefulWidget {
  final String buttonText;
  final IconData icon;
  final VoidCallback function;

  const CustomElevated(
      {super.key,
      required this.buttonText,
      required this.icon,
      required this.function});

  @override
  State<CustomElevated> createState() => _CustomElevatedState();
}

class _CustomElevatedState extends State<CustomElevated> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.function,
      style: ElevatedButton.styleFrom(
        backgroundColor: Config.primaryColor,
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 25,
          fontWeight: FontWeight.w400,
        ),
        elevation: 20,
      ),
      child: isLoading
          ? Column(
              children: const [
                SizedBox(
                  height: 15,
                ),
                CircularProgressIndicator(
                  color: Colors.black,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.buttonText),
                Icon(widget.icon),
              ],
            ),
    );
  }
}
