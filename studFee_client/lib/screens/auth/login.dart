import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studfees/components/custom_textfield.dart';
import 'package:studfees/screens/auth/forgetpassword.dart';
import 'package:studfees/screens/auth/register.dart';
import 'package:studfees/services/auth_service.dart';
import 'package:studfees/util/navigator.dart';

import '../../util/config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthServiceProvider authServiceProvider = AuthServiceProvider();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  TextEditingController admissionNumber = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    admissionNumber.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signUser() {
    authServiceProvider.signUserIn(
      context: context,
      admissionNumber: admissionNumber.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20,
              left: 20,
            ),
            child: Form(
              key: _globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 50),
                  ListTile(
                    title: Text(
                      'Hello Again! 👋',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'To access your Account and Manage your Levy Payments.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Contiune with your Admission No and Password.',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    editingController: admissionNumber,
                    textInputType: TextInputType.number,
                    labelText: 'Admission Number',
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Just dey play!';
                      }
                      return null;
                    },
                    isPassword: false,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    editingController: passwordController,
                    textInputType: TextInputType.name,
                    labelText: 'Password',
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Just dey play!';
                      }
                      return null;
                    },
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          nextScreen(context, const ForgetPassword());
                        },
                        child: const Text(
                          'Forget Password?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Config.backgroundColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_globalKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        Future.delayed(const Duration(seconds: 3), () {
                          setState(() {
                            signUser();
                            isLoading = false;
                          });
                        });
                      }
                    },
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
                            children: [
                              SizedBox(
                                height: 5,
                                width: MediaQuery.of(context).size.width,
                              ),
                              const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Login'),
                              Icon(Icons.send),
                            ],
                          ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      const Text(
                        'New User?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(),
                        onPressed: () {
                          nextScreen(context, const RegisterScreen());
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Config.primaryColor,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
