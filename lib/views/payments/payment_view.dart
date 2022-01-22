import 'package:flutter/material.dart';
import 'package:pro_build_attendance/model/invoice.dart';

class PaymentView extends StatelessWidget {
  final Invoice invoice;

  const PaymentView({Key? key, required this.invoice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Text(invoice.amount.toString()),
            Text(invoice.userName.toString()),
          ],
        ),
      ),
    );
  }
}
