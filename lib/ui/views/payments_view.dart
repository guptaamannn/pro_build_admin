import 'package:flutter/material.dart';
import 'package:pro_build_admin/ui/widgets/no_data_image.dart';
import '/core/model/invoice.dart';
import '/core/utils/formatter.dart';
import '/core/viewModel/transaction_model.dart';
import '/ui/views/payment_view.dart';
import '/ui/widgets/bottom_navigation_bar.dart';
import '/ui/widgets/image_avatar.dart';
import 'package:provider/provider.dart';

import 'payment_form.dart';

class PaymentsView extends StatelessWidget {
  static const String id = '/payments';
  final String? userId;

  const PaymentsView({Key? key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: NavigationDrawer(currentRoute: id),
      bottomNavigationBar:
          Hero(tag: "nav", child: CustomBottomNavigation(currentRoute: id)),
      appBar: AppBar(
        title: const Text("Pro Build"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
        bottom: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Payments"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PaymentForm()));
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: StreamBuilder<Iterable<Invoice>>(
            stream: context.read<Transaction>().invoiceStream(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data == null ||
                  !snapshot.hasData ||
                  snapshot.data?.length == 0) {
                return const Center(
                  child: NoDataSign(),
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
                                  padding: const EdgeInsets.all(4),
                                  margin: const EdgeInsets.only(right: 8),
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
