import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studfees/components/auth_screen.dart';
import 'package:studfees/provider/user_provider.dart';
import 'package:studfees/screens/onboad/onboard.dart';
import 'package:studfees/services/auth_service.dart';
import 'package:studfees/util/routes.dart';

void main() async {
  await dotenv.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        )
      ],
      child: const SplashScreen(),
    ),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthServiceProvider authServiceProvider = AuthServiceProvider();

  @override
  void initState() {
    super.initState();
    authServiceProvider.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: Provider.of<UserProvider>(context).user.token.isNotEmpty
          ? const AuthScreen()
          : EasySplashScreen(
              logo: Image.asset(
                'assets/images/logo.png',
                width: 300.0,
                height: 300.0,
              ),
              backgroundColor: Colors.white60,
              showLoader: false,
              navigator: const OnBoarding(),
              durationInSeconds: 5,
            ),
    );
  }
}
