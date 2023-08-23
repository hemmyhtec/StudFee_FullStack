import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studfees/screens/auth/login.dart';
import 'package:studfees/services/auth_service.dart';
import 'package:studfees/util/navigator.dart';
import '../../components/custom_textfield.dart';
import '../../util/config.dart';
import 'package:validators/validators.dart' as validator;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthServiceProvider authServiceProvider = AuthServiceProvider();
  final List<String> gender = [
    'Male',
    'Female',
  ];
  String? selectedValue;

  bool isLoading = false;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController admissionNumber = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ugLevelController = TextEditingController();

  @override
  void dispose() {
    admissionNumber.dispose();
    passwordController.dispose();
    emailController.dispose();
    ugLevelController.dispose();
    super.dispose();
  }

  void registerUser() {
    authServiceProvider.registerUser(
      context: context,
      admissionNumber: admissionNumber.text.trim(),
      password: passwordController.text.trim(),
      email: emailController.text.trim(),
      gender: selectedValue.toString(),
      ugLevel: ugLevelController.text.trim(),
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
                      'Get Started! 👌',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Create Account to Access and Manage your Levy Payments.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 20.0,
                      ),
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
                        return 'Dey play! Empty value not allowed';
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
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Dey play! Empty value not allowed';
                      } else if (value.length < 8) {
                        return 'Password should be minimum 8 characters';
                      }
                      return null;
                    },
                    isPassword: true,
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
                  DropdownButtonFormField2(
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      isDense: false,
                      filled: true,
                      fillColor: Color.fromARGB(255, 230, 230, 230),
                    ),
                    hint: const Text(
                      'Gender',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                      ),
                    ),
                    items: gender
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          ),
                        )
                        .toList(),
                    value: selectedValue,
                    validator: (value) {
                      if (value == null) {
                        return 'Dey play! Empty value not allowed';
                      }
                      return null;
                    },
                    onChanged: ((value) {
                      setState(() {
                        selectedValue = value as String;
                      });
                    }),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    editingController: ugLevelController,
                    textInputType: TextInputType.name,
                    labelText: 'Level',
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value.isEmpty) {
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
                              Text('Register'),
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
