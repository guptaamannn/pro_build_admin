import 'package:flutter/material.dart';
import 'package:pro_build_attendance/core/model/invoice.dart';
import 'package:pro_build_attendance/core/utils/formatter.dart';
import 'package:pro_build_attendance/core/viewModel/payment_model.dart';
import 'package:pro_build_attendance/ui/views/payment_view.dart';
import 'package:pro_build_attendance/ui/widgets/navigation_drawer.dart';
import 'package:provider/provider.dart';

class PaymentsView extends StatelessWidget {
  static const String id = '/payments';
  PaymentsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(currentRoute: id),
      appBar: AppBar(
        title: Text("Payments"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.attach_money_rounded),
      ),
      body: SafeArea(
        child: StreamBuilder<Iterable<Invoice>>(
            stream: context.read<PaymentModel>().invoiceStream(),
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
                    leading: Baseline(
                        baseline: 18,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(Formatter.fromDateTime(invoice.orderDate))),
                    title: Text(invoice.account!.name.toString()),
                    subtitle: Text(invoice.account!.phone.toString()),
                    trailing: Text("Rs " + invoice.totalAmount.toString()),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PaymentView(invoice: invoice))),
                  );
                },
              );
            }),
      ),
    );
  }
}
