import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studfees/models/process_payment_model.dart';
import 'package:studfees/provider/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:studfees/screens/users/payment_history_details.dart';
import 'package:studfees/util/config.dart';
import 'package:studfees/util/navigator.dart';

class PaymentHistroyScreen extends StatefulWidget {
  const PaymentHistroyScreen({super.key});

  @override
  State<PaymentHistroyScreen> createState() => _PaymentHistroyScreenState();
}

class _PaymentHistroyScreenState extends State<PaymentHistroyScreen> {
  Future<List<Payment>> getPaymentHistory() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response response = await http.get(
        Uri.parse('$url/paymentsHistory'),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          'x-auth-token': userProvider.user.token,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        List list = body['data'];
        return list.map((history) => Payment.fromMap(history)).toList();
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        alignment: AlignmentDirectional.center,
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            top: -25,
            child: Text(
              'Payment historys',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
              height: double.infinity,
              child: FutureBuilder<List<Payment>>(
                future: getPaymentHistory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Payment>? list = snapshot.data;
                    return ListView.builder(
                      itemCount: list!.length,
                      itemBuilder: (context, index) {
                        Payment p = list[index];
                        String dateString = p.createdAt.toString();
                        DateTime date = DateTime.parse(dateString);
                        String formattedDate = date.toString().substring(0, 10);
                        return GestureDetector(
                          onTap: () {
                            Payment p = list[index];
                            var fullName = p.fullName;
                            var feeAmount = p.feeAmount;
                            var levyName = p.levyName;
                            var paymentStatus = p.paymentStatus;
                            var referenceId = p.referenceId;
                            nextScreen(
                                context,
                                PaymentHistoryDetails(
                                  fullname: fullName,
                                  feeAmount: feeAmount,
                                  levyName: levyName,
                                  paymentStatus: paymentStatus,
                                  referenceId: referenceId,
                                  date: formattedDate,
                                ));
                          },
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  p.levyName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  formattedDate,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: p.paymentStatus == "Success"
                                    ? const Text("Success",
                                        style: TextStyle(color: Colors.green))
                                    : const Text("Failed",
                                        style: TextStyle(color: Colors.red)),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ))
        ],
      ),
    );
  }
}
