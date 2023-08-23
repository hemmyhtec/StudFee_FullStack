import 'package:flutter/material.dart';
import 'package:studfees/screens/users/chat/user_list.dart';
import 'package:studfees/util/config.dart';
import 'package:studfees/util/navigator.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => ChatListScreenState();
}

class ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          Center(
            child: Text('Chat list'),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Config.primaryColor,
        child: const Icon(Icons.list_sharp),
        onPressed: () => nextScreen(context, const UserListScreen()),
      ),
    );
  }
}
