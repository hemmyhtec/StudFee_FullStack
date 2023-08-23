import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studfees/screens/auth/login.dart';
import 'package:studfees/services/auth_service.dart';
import 'package:studfees/util/navigator.dart';
import '../../components/custom_textfield.dart';
import '../../util/config.dart';
import 'package:validators/validators.dart' as validator;

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  AuthServiceProvider authServiceProvider = AuthServiceProvider();

  bool isLoading = false;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  void registerUser() {
    authServiceProvider.forgetPassword(
      context: context,
      email: emailController.text.trim(),
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
                      'Forget Password!🤥',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Enter your email address to receive a reset link.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    editingController: emailController,
                    textInputType: TextInputType.emailAddress,
                    labelText: 'Email Address',
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (!validator.isEmail(value)) {
                        return 'Just dey play! enter a valid email';
                      } else if (value.toString().isEmpty) {
                        return 'Dey play! Empty value not allowed';
                      }
                      return null;
                    },
                    isPassword: false,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_globalKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        Future.delayed(const Duration(seconds: 5), () {
                          setState(() {
                            registerUser();
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
                              Text('Reset Password'),
                              Icon(Icons.send),
                            ],
                          ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text(
                        'Existing User?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(),
                        onPressed: () {
                          nextScreen(context, const LoginScreen());
                        },
                        child: const Text(
                          'Login',
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
