import 'package:flutter/material.dart';
import 'package:studfees/screens/users/chat/chat_list.dart';
import 'package:studfees/screens/users/payment.dart';
import 'package:studfees/screens/users/profile.dart';

import '../screens/users/dictionary/dic.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int index = 0;
  final screens = [
    const ProfileScreen(),
    const PaymentListScreen(),
    DictionaryScreen(),
    const ChatListScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          indicatorColor: const Color.fromARGB(29, 27, 0, 202),
          backgroundColor: Colors.transparent,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: index,
          animationDuration: const Duration(seconds: 3),
          onDestinationSelected: (index) => setState(() {
            this.index = index;
          }),
          destinations: const [
            NavigationDestination(
              icon: ImageIcon(AssetImage('assets/icons/home-2.png')),
              label: 'Home',
            ),
            NavigationDestination(
              icon: ImageIcon(AssetImage('assets/icons/payment.png')),
              label: 'Payment',
            ),
            Center(
              child: NavigationDestination(
                icon: ImageIcon(AssetImage('assets/icons/book.png')),
                label: 'Dictionary',
              ),
            ),
            NavigationDestination(
              icon: ImageIcon(AssetImage('assets/icons/people.png')),
              label: 'Meet-up',
            ),
          ],
        ),
      ),
    );
  }
}
