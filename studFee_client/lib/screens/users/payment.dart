import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:studfees/screens/users/payment_histroy.dart';
import 'package:studfees/screens/users/process_payment.dart';
import 'package:studfees/util/navigator.dart';

import '../../models/payment_model.dart';
import '../../provider/user_provider.dart';
import '../../util/config.dart';

class PaymentListScreen extends StatefulWidget {
  const PaymentListScreen({super.key});

  @override
  State<PaymentListScreen> createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends State<PaymentListScreen> {
  Future<List<Levy>> fetchLevies() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response newResponse = await http.get(
        Uri.parse('$url/payments'),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          'x-auth-token': userProvider.user.token,
        },
      );
      if (newResponse.statusCode == 200) {
        Map<String, dynamic> body = json.decode(newResponse.body);
        List levies = body['department'];
        return levies.map((levy) => Levy.fromMap(levy)).toList();
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Levies Fee',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Levy>>(
          future: fetchLevies(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Levy>? levies = snapshot.data;
              return ListView.builder(
                itemCount: levies!.length,
                itemBuilder: (context, index) {
                  Levy levy = levies[index];
                  return ListTile(
                      title: Text(
                        levy.levyName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('Department: ${levy.departmentName}'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          var deptName = levy.departmentName;
                          var userName = user.fullname;
                          var levyAmount = levy.feeAmount;
                          var paymentName = levy.levyName;
                          var userEmail = user.email;
                          nextScreen(
                            context,
                            ProcessPayment(
                              deptName: deptName,
                              userName: userName,
                              levyAmount: levyAmount,
                              paymentName: paymentName,
                              userEmail: userEmail,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Config.primaryColor,
                          padding: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 0,
                        ),
                        child: Text('Pay Fee: ${levy.feeAmount}'),
                      ));
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Config.primaryColor,
        onPressed: () {
          _showModalBottomSheet(context);
        },
        child: const Icon(Icons.history),
      ),
    );
  }
}

void _showModalBottomSheet(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      ),
    ),
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.4,
      minChildSize: 0.32,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: const PaymentHistroyScreen(),
      ),
    ),
  );
}
