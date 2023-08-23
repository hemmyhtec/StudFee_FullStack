import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studfees/components/grid_box.dart';
import 'package:studfees/provider/user_provider.dart';
import 'package:studfees/screens/users/payment.dart';
import 'package:studfees/screens/users/profile.dart';
import 'package:studfees/util/config.dart';
import 'package:studfees/util/navigator.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().hour;

    String? greetings;

    if (now < 12) {
      greetings = 'Good Morining 🌻';
    } else if (now < 17) {
      greetings = 'Good Afternoon 🌞';
    } else {
      greetings = 'Good Evening 🌙';
    }

    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(0.0),
                    title: Text(
                      greetings.toString(),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    subtitle: Text(
                      user.fullname.toString(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/logo.png'),
                )
              ],
            ),
            Flexible(
              fit: FlexFit.loose,
              child: GridView.extent(
                childAspectRatio: (2 / 2),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                maxCrossAxisExtent: 100.0,
                children: [
                  GridBox(
                    image: Image.asset(
                      'assets/icons/user.png',
                      width: 40,
                      height: 40,
                      color: Config.primaryColor,
                    ),
                    textTitle: 'Profile',
                    function: () {
                      nextScreen(context, const ProfileScreen());
                    },
                  ),
                  GridBox(
                    image: Image.asset(
                      'assets/icons/payment.png',
                      width: 40,
                      height: 40,
                      color: Config.primaryColor,
                    ),
                    textTitle: 'Payment',
                    function: () {
                      nextScreen(context, const PaymentListScreen());
                    },
                  ),
                  GridBox(
                    image: Image.asset(
                      'assets/icons/book.png',
                      width: 40,
                      height: 40,
                      color: Config.primaryColor,
                    ),
                    textTitle: 'E-Library',
                    function: () {
                      debugPrint('E-Library');
                    },
                  ),
                  GridBox(
                    image: Image.asset(
                      'assets/icons/people.png',
                      width: 40,
                      height: 40,
                      color: Config.primaryColor,
                    ),
                    textTitle: 'Meet Up',
                    function: () {
                      debugPrint('Meet Up');
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
