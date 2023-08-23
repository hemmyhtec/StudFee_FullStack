import 'package:flutter/material.dart';
import 'package:studfees/components/button.dart';
import 'package:studfees/screens/auth/login.dart';
import 'package:studfees/util/navigator.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/student.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          reverse: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(197, 255, 255, 255),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 400.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ListTile(
                        title: Text(
                          "Student's Levy Payment Solution",
                          style: TextStyle(
                            fontSize: 55.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        subtitle: Text(
                          'This app is designed to make it easy for \nstudents to pay their levies and manage their account.',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: CustomElevated(
                          buttonText: 'Get Started',
                          icon: Icons.arrow_forward,
                          function: () {
                            nextScreen(
                              context,
                              const LoginScreen(),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
