import 'package:flutter/material.dart';
import 'package:pro_build_attendance/model/invoice.dart';
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
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text(
                        snapshot.data!.toList()[index].userName.toString()),
                    subtitle: Text(
                        snapshot.data!.toList()[index].orderDate.toString()),
                    trailing:
                        Text(snapshot.data!.toList()[index].amount.toString()),
                  );
                },
              );
            }),
      ),
    );
  }
}
