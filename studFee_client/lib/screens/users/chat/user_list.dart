import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:studfees/util/config.dart';
import 'package:studfees/util/navigator.dart';

import '../../../provider/user_provider.dart';
import 'chat_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final TextEditingController searchAdmissionNumber = TextEditingController();

  List<dynamic> _users = [];

  @override
  void initState() {
    _getUsers();
    super.initState();
  }

  void _getUsers() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    http.Response response = await http.get(
      Uri.parse('$url/users'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        'x-auth-token': userProvider.user.token,
      },
    );
    final data = jsonDecode(response.body);
    setState(() {
      _users = data;
    });
  }

  void _searchUser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    http.Response response = await http.get(
      Uri.parse('$url/users/$searchAdmissionNumber'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        'x-auth-token': userProvider.user.token,
      },
    );
    final user = response.body;
    print(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 230, 230, 230),
        title: TextFormField(
          controller: searchAdmissionNumber,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            suffixStyle: const TextStyle(color: Colors.black54),
            suffixIcon: IconButton(
              onPressed: _searchUser,
              icon: const Icon(Icons.search),
            ),
            labelStyle: const TextStyle(color: Colors.black54, fontSize: 20),
            labelText: 'Enter admission no',
            filled: true,
            fillColor: const Color.fromARGB(255, 230, 230, 230),
            prefixIconColor: Colors.black54,
            focusColor: Colors.black,
            focusedBorder: UnderlineInputBorder(
                borderSide: const BorderSide(color: Colors.white30),
                borderRadius: BorderRadius.circular(10)),
            errorBorder: UnderlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10)),
            enabledBorder: UnderlineInputBorder(
                borderSide: const BorderSide(color: Colors.white30),
                borderRadius: BorderRadius.circular(10)),
          ),
          onChanged: (value) {
            // setState(
            //   () {
            //     _searchAdmissionNumber.text = value;
            //   },
            // );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Config.primaryColor,
              radius: 20,
              child: (user['profileImage'] != null)
                  ? CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      backgroundImage: NetworkImage(user['profileImage']))
                  : const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 15,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
            ),
            title: Text(user['fullname']),
            subtitle: Text(user['admissionNumber']),
            onTap: () {
              nextScreen(
                  context, ChatScreen(receiver: user['admissionNumber']));
            },
          );
        },
      ),
    );
  }
}
