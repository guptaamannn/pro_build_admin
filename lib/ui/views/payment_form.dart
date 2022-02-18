import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pro_build_attendance/core/enums/payments_mode.dart';
import 'package:pro_build_attendance/core/enums/products.dart';
import 'package:pro_build_attendance/core/enums/view_state.dart';
import 'package:pro_build_attendance/core/model/invoice.dart';
import 'package:pro_build_attendance/core/model/user.dart';
import 'package:pro_build_attendance/core/utils/formatter.dart';
import 'package:pro_build_attendance/core/viewModel/transaction_model.dart';
import 'package:pro_build_attendance/ui/shared/input_decoration.dart';
import 'package:pro_build_attendance/ui/widgets/autocomplete_user_search.dart';
import 'package:pro_build_attendance/ui/widgets/image_avatar.dart';
import 'package:pro_build_attendance/ui/widgets/loading_overlay.dart';

import 'package:provider/provider.dart';

class PaymentForm extends HookWidget {
  final User? user;
  final Invoice? invoice;

  PaymentForm([this.user, this.invoice]);

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final invoiceState = useState(invoice == null
        ? Invoice(
            orderDate: DateTime.now(),
            account: user,
            userId: user?.id,
            mop: "Cash",
            totalAmount: "1500",
            order: [
                Product(
                    description: "Gym",
                    amount: "1500",
                    validFrom: user?.eDate,
                    validTill: user?.eDate!.add(
                      Duration(days: 30),
                    ))
              ])
        : invoice!);
    final userState = useState(user);
    final numberOfProducts = useState(1);
    final ValueNotifier<PaymentMode> modeOfPayment = useState(PaymentMode.Cash);
    final orderDateController = useTextEditingController(
        text: Formatter.fromDateTime(invoiceState.value.orderDate));
    final totalAmount = useState('1500');

    return Scaffold(
      body: ModalProgressIndicator(
        isLoading: context.watch<Transaction>().state == ViewState.busy,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              expandedHeight: 160.0,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                titlePadding: EdgeInsets.fromLTRB(10, 8, 0, 20),
                title: Text(
                  'Record Payment',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
              actions: [CloseButton()],
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(8.0, 20, 8, 8),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    TextFormField(
                      controller: orderDateController,
                      decoration: getInputDecoration("Order Date"),
                      readOnly: true,
                      onTap: () async {
                        var orderDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: user?.joinedDate ?? DateTime(2021),
                          lastDate: DateTime(2030),
                        );
                        if (orderDate != null) {
                          invoiceState.value.orderDate = orderDate;
                          orderDateController.text =
                              Formatter.fromDateTime(orderDate);
                        }
                      },
                    ),
                    userState.value != null || invoice != null
                        ? ListTile(
                            leading: CachedImageAvatar(
                              fileName: userState.value == null
                                  ? invoice!.userId!
                                  : userState.value!.id!,
                              name: userState.value == null
                                  ? invoice!.account!.name
                                  : userState.value!.name,
                            ),
                            title: Text(userState.value == null
                                ? invoice!.account!.name!
                                : userState.value!.name!),
                            subtitle: Text(userState.value == null
                                ? invoice!.account!.phone!
                                : userState.value!.phone!),
                            trailing: Icon(Icons.arrow_forward_ios_rounded),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: SearchUser(
                                onSelected: (user) {
                                  userState.value = user;
                                },
                                searchUsing: 'name'),
                          )
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ProductDetails(
                      index: index,
                      invoice: invoiceState,
                      user: userState.value,
                      totalItem: numberOfProducts,
                      totalAmount: totalAmount,
                    );
                  },
                  childCount: numberOfProducts.value,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 8),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () {
                            numberOfProducts.value += 1;
                            invoiceState.value.order?.add(Product());
                          },
                          child: Text("+ Item"),
                        ),
                        Spacer(),
                        Text("Total:  ",
                            style: Theme.of(context).textTheme.subtitle2),
                        Text(
                          "Rs " + totalAmount.value + " ",
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    Text("Mode of Payment"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: PaymentMode.values
                          .map(
                            (e) => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<PaymentMode>(
                                  value: e,
                                  groupValue: modeOfPayment.value,
                                  onChanged: (value) {
                                    modeOfPayment.value = value!;
                                    invoiceState.value.mop = value.name;
                                  },
                                ),
                                Text(e.name),
                                SizedBox(width: 20),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                    TextFormField(
                      decoration: getInputDecoration("Notes"),
                      onChanged: (value) => invoiceState.value.notes = value,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await context
                              .read<Transaction>()
                              .createInvoice(invoiceState.value);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14)),
                        child: Text(invoice == null ? "Submit" : "Update"))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProductDetails extends HookWidget {
  final User? user;
  final int index;
  final ValueNotifier<Invoice> invoice;
  final ValueNotifier<int> totalItem;
  final ValueNotifier<String> totalAmount;

  ProductDetails({
    this.user,
    required this.invoice,
    required this.index,
    required this.totalItem,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final product = useState(Products.Gym);
    final validFromController = useTextEditingController(
      text: invoice.value.order?[index].validFrom != null
          ? Formatter.fromDateTime(invoice.value.order![index].validFrom)
          : null,
    );
    final validTillController = useTextEditingController(
      text: invoice.value.order?[index].validTill != null
          ? Formatter.fromDateTime(invoice.value.order![index].validTill)
          : null,
    );
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(30),
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white,
              )),
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<Products>(
                        value: Products.Gym,
                        items: Products.values
                            .map(
                              (e) => DropdownMenuItem<Products>(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      product.value == e
                                          ? Icon(Icons.check)
                                          : Container(width: 24),
                                      SizedBox(width: 20),
                                      Text(e.name),
                                    ],
                                  ),
                                  value: e),
                            )
                            .toList(),
                        selectedItemBuilder: (context) {
                          return Products.values
                              .map((e) => Text(e.name))
                              .toList();
                        },
                        onChanged: (value) {
                          product.value = value!;
                          if (value != Products.Other) {
                            invoice.value.order![index].description =
                                value.name;
                          } else {
                            invoice.value.order![index].validFrom = null;
                            invoice.value.order![index].validTill = null;
                          }
                        },
                        decoration: getInputDecoration('Product'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) => {
                          invoice.value.order![index].amount = value,
                          totalAmount.value = invoice.value.getTotal(),
                        },
                        decoration: getInputDecoration("Price"),
                        keyboardType: TextInputType.number,
                        initialValue: invoice.value.order![index].amount,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                product.value == Products.Registration
                    ? Container()
                    : product.value != Products.Other
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: getInputDecoration('From'),
                                  controller: validFromController,
                                  readOnly: true,
                                  onTap: () async {
                                    var range = await showDateRangePicker(
                                      context: context,
                                      firstDate:
                                          user?.joinedDate ?? DateTime(2021),
                                      lastDate: DateTime(2030),
                                      initialDateRange: invoice.value
                                                  .order?[index].validFrom ==
                                              null
                                          ? null
                                          : DateTimeRange(
                                              start: invoice.value.order![index]
                                                  .validFrom!,
                                              end: invoice.value.order![index]
                                                  .validTill!),
                                    );
                                    if (range?.start != null) {
                                      validFromController.text =
                                          Formatter.fromDateTime(range!.start);
                                      validTillController.text =
                                          Formatter.fromDateTime(range.end);
                                      invoice.value.order?[index].validFrom =
                                          range.start;
                                      invoice.value.order?[index].validTill =
                                          range.end;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  decoration: getInputDecoration('To'),
                                  readOnly: true,
                                  controller: validTillController,
                                  onTap: () async {
                                    var validTill =
                                        invoice.value.order?[index].validTill;
                                    var date = await showDatePicker(
                                      context: context,
                                      initialDate: validTill == null
                                          ? DateTime.now()
                                          : validTill,
                                      firstDate:
                                          user?.joinedDate ?? DateTime(2021),
                                      lastDate: DateTime.now().add(
                                        Duration(days: 730),
                                      ),
                                    );
                                    if (date != null) {
                                      validTillController.text =
                                          Formatter.fromDateTime(date);
                                      invoice.value.order?[index].validTill =
                                          date;
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                        : TextFormField(
                            decoration: getInputDecoration('Product Name'),
                            onChanged: (value) =>
                                invoice.value.order![index].description = value,
                          ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: index == 0
              ? Container()
              : IconButton(
                  icon: Icon(Icons.highlight_off),
                  onPressed: () {
                    invoice.value.order!.removeAt(index);
                    totalItem.value -= 1;
                  },
                ),
        ),
      ],
    );
  }
}
