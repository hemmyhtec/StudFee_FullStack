// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AlertBox extends StatelessWidget {
  String alertText;
  final VoidCallback callback;
  IconData icon;
  Color color;
  String buttonText;
  Color buttonColor;

  AlertBox(
      {Key? key,
      required this.alertText,
      required this.callback,
      required this.icon,
      required this.color,
      required this.buttonText,
      required this.buttonColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 250,
          child: Column(
            children: [
              const SizedBox(height: 30),
              Icon(
                icon,
                size: 40,
                color: color,
              ),
              const SizedBox(height: 50),
              Center(
                child: Text(
                  alertText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: callback,
                child: Container(
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
