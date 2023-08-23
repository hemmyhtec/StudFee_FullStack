import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:studfees/components/button.dart';
import 'package:studfees/util/config.dart';
import 'dart:ui' as ui;

class PaymentHistoryDetails extends StatefulWidget {
  String? fullname;
  int feeAmount;
  String levyName;
  String? paymentStatus;
  String? referenceId;
  String date;
  PaymentHistoryDetails(
      {super.key,
      this.fullname,
      required this.feeAmount,
      required this.levyName,
      this.paymentStatus,
      this.referenceId,
      required this.date});

  @override
  State<PaymentHistoryDetails> createState() => _PaymentHistoryDetailsState();
}

class _PaymentHistoryDetailsState extends State<PaymentHistoryDetails> {
  final GlobalKey _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text(
          'Share receipt',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          RepaintBoundary(
            key: _globalKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                height: 550,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            width: 50,
                            height: 50,
                          ),
                          const Text('Transaction Receipt')
                        ],
                      ),
                    ),
                    ListTile(
                      title: Text(
                        '#${widget.feeAmount.toString()}.00',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Config.primaryColor,
                        ),
                      ),
                      subtitle: widget.paymentStatus == 'Success'
                          ? const Text(
                              'Successful transaction',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                              ),
                            )
                          : const Text(
                              'Failed transaction',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                              ),
                            ),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Fullname Name:'),
                      trailing: Text(
                        widget.fullname.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text('Reason for payment:'),
                      trailing: Text(
                        widget.levyName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text('Reference Id:'),
                      trailing: Text(
                        widget.referenceId.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text('Date:'),
                      trailing: Text(
                        widget.date,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(),
                    const ListTile(
                      title: Text('Support'),
                      subtitle: Text('studfees@gmail.com'),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 300,
            child: CustomElevated(
              buttonText: 'Save Receipt',
              icon: Icons.save,
              function: () async {
                RenderRepaintBoundary? boundary = _globalKey.currentContext!
                    .findRenderObject() as RenderRepaintBoundary;
                ui.Image image = await boundary.toImage(pixelRatio: 3.0);

                ByteData? byteData =
                    await image.toByteData(format: ui.ImageByteFormat.png);
                var pngBytes = byteData!.buffer.asUint8List();

                Directory appDocDir = await getApplicationDocumentsDirectory();
                String appDocPath = appDocDir.path;

                final file = File('$appDocPath/receipt.png');

                try {
                  await file.writeAsBytes(pngBytes);
                  print(file.path);
                } catch (e) {
                  print(e);
                }
                // await file.writeAsBytes(pngBytes);
              },
            ),
          )
        ],
      ),
    );
  }
}
