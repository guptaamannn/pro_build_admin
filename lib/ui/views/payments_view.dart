import 'package:flutter/material.dart';
import 'package:pro_build_attendance/core/model/invoice.dart';
import 'package:pro_build_attendance/core/utils/formatter.dart';
import 'package:pro_build_attendance/core/viewModel/transaction_model.dart';
import 'package:pro_build_attendance/ui/views/payment_form.dart';
import 'package:pro_build_attendance/ui/views/payment_view.dart';
import 'package:pro_build_attendance/ui/widgets/bottom_navigation_bar.dart';
import 'package:pro_build_attendance/ui/widgets/image_avatar.dart';
import 'package:provider/provider.dart';

class PaymentsView extends StatelessWidget {
  static const String id = '/payments';
  PaymentsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: NavigationDrawer(currentRoute: id),
      bottomNavigationBar:
          Hero(tag: "nav", child: CustomBottomNavigation(currentRoute: id)),
      appBar: AppBar(
        title: const Text("Pro Build"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        bottom: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Payments"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PaymentForm()));
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: StreamBuilder<Iterable<Invoice>>(
            stream: context.read<Transaction>().invoiceStream(),
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
                    leading: CachedImageAvatar(
                      fileName: invoice.userId!,
                      name: invoice.account!.name!,
                    ),
                    title: Text(invoice.account!.name.toString()),
                    subtitle: Row(
                        children: invoice.order!
                            .map((e) => Container(
                                  padding: EdgeInsets.all(4),
                                  margin: EdgeInsets.only(right: 8),
                                  child: Icon(
                                    context
                                        .read<Transaction>()
                                        .getProductIcon(e.description!),
                                    size: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground
                                        .withOpacity(0.70),
                                  ),
                                ))
                            .toList()),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          Formatter.fromDateTime(invoice.orderDate),
                          style:
                              Theme.of(context).textTheme.labelSmall!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground
                                        .withOpacity(0.75),
                                  ),
                        ),
                        Text(
                          "Rs " + invoice.totalAmount.toString(),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
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
