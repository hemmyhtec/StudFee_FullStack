import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:provider/provider.dart';
import 'package:studfees/components/button.dart';
import 'package:http/http.dart' as http;
import 'package:studfees/models/process_payment_model.dart';
import 'package:studfees/util/alert_dailog.dart';

import '../../provider/user_provider.dart';
import '../../util/config.dart';

class ProcessPayment extends StatefulWidget {
  String deptName;
  String? userName;
  int levyAmount;
  String paymentName;
  String userEmail;
  ProcessPayment({
    Key? key,
    required this.deptName,
    this.userName,
    required this.levyAmount,
    required this.paymentName,
    required this.userEmail,
  }) : super(key: key);

  @override
  State<ProcessPayment> createState() => _ProcessPaymentState();
}

class _ProcessPaymentState extends State<ProcessPayment> {
  String publicKey = 'pk_test_ae8c3bb88d24ffa2f72c0eda65d59ee8c8a84f0b';

  final plugin = PaystackPlugin();

  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: publicKey);
  }

  String getReference() {
    var plaform = (Platform.isIOS) ? 'iOS' : 'Android';
    final todaysDate = DateTime.now().microsecondsSinceEpoch;
    return 'StudFee${plaform}_$todaysDate';
  }

  chargeCard() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Charge charge = Charge();
    final amount = widget.levyAmount * 100;
    charge.amount = amount;
    charge.reference = getReference();
    charge.email = widget.userEmail;

    CheckoutResponse response = await plugin.checkout(
      context,
      charge: charge,
      method: CheckoutMethod.card,
    );

    if (response.status == true) {
      Payment payment = Payment(
        levyName: widget.paymentName,
        feeAmount: widget.levyAmount,
        paymentStatus: 'Success',
        referenceId: response.reference,
      );

      http.Response apiResponse = await http.post(
        Uri.parse('$url/paymentsProcess'),
        body: payment.toJson(),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          'x-auth-token': userProvider.user.token,
        },
      );

      if (jsonDecode(apiResponse.body)['msg'] == 'Payment Successful') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertBox(
                alertText: jsonDecode(apiResponse.body)['msg'],
                callback: () async {
                  Navigator.pop(context);
                },
                icon: Icons.check,
                color: Config.primaryColor,
                buttonText: 'Okay',
                buttonColor: Config.primaryColor,
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertBox(
                alertText: apiResponse.body,
                callback: () {
                  Navigator.pop(context);
                },
                icon: Icons.check,
                color: Colors.red,
                buttonText: 'Retry',
                buttonColor: Colors.red,
              );
            });
      }
    } else if (response.status == false) {
      Payment payment = Payment(
        levyName: widget.paymentName,
        feeAmount: widget.levyAmount,
        paymentStatus: 'Failed',
        referenceId: response.reference,
      );

      await http.post(
        Uri.parse('$url/paymentsProcess'),
        body: payment.toJson(),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          'x-auth-token': userProvider.user.token,
        },
      );

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertBox(
              alertText: 'Transaction failed',
              callback: () async {
                Navigator.pop(context);
              },
              icon: Icons.check,
              color: Config.primaryColor,
              buttonText: 'Okay',
              buttonColor: Config.primaryColor,
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertBox(
              alertText: 'Payment failed',
              callback: () {
                Navigator.pop(context);
              },
              icon: Icons.check,
              color: Colors.red,
              buttonText: 'Retry',
              buttonColor: Colors.red,
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text(
          'Confirm Payment',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 25, right: 25),
            height: MediaQuery.of(context).size.height / 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color.fromARGB(8, 24, 36, 48),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  title: const Text('Name:'),
                  trailing: Text(
                    '${widget.userName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Department:'),
                  trailing: Text(
                    widget.deptName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Payment Reason:'),
                  trailing: Text(
                    widget.paymentName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Levy Amount:'),
                  trailing: Text(
                    '# ${widget.levyAmount.toString()}.00',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.red,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Your Email:'),
                  trailing: Text(
                    widget.userEmail,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Config.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: CustomElevated(
                    buttonText: 'Make Payment',
                    icon: Icons.payment,
                    function: () {
                      chargeCard();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
