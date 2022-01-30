import 'package:flutter/material.dart';
import 'package:pro_build_attendance/model/invoice.dart';
import 'package:pro_build_attendance/utils/formatter.dart';
import 'package:pro_build_attendance/views/payments/payments_view_model.dart';

class PaymentsView extends StatelessWidget {
  PaymentsView({Key? key}) : super(key: key);
  final model = PaymentsViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Navigate to payments creation page");
        },
        child: Icon(Icons.attach_money_rounded),
      ),
      body: SafeArea(
        child: StreamBuilder<Iterable<Invoice>>(
            stream: model.invoiceStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.data == null || !snapshot.hasData) {
                return Center(
                  child: Text("No Data"),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Invoice invoice = snapshot.data!.toList()[index];
                  return ListTile(
                    leading: Text(Formatter.fromDateTime(invoice.orderDate)),
                    title: Text(invoice.account!.name.toString()),
                    subtitle: Text(
                      Formatter.fromDateTime(
                          snapshot.data!.toList()[index].orderDate),
                    ),
                    trailing:
                        Text("\u{20B9} " + invoice.totalAmount.toString()),
                  );
                },
              );
            }),
      ),
    );
  }
}
