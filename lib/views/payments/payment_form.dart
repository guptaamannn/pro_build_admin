import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pro_build_attendance/model/invoice.dart';
import 'package:pro_build_attendance/model/user.dart';
import 'package:pro_build_attendance/provider/ui_provider.dart';
import 'package:pro_build_attendance/utils/formatter.dart';
import 'package:pro_build_attendance/utils/input_decoration.dart';
import 'package:pro_build_attendance/views/payments/payments_view_model.dart';
import 'package:pro_build_attendance/widgets/image_avatar.dart';
import 'package:pro_build_attendance/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';

enum Products { Registration, Gym, Locker, Other }
enum PaymentMode { Cash, Transfer }

class PaymentForm extends HookWidget {
  final User user;

  PaymentForm(this.user);

  @override
  Widget build(BuildContext context) {
    final invoice = useState(
      Invoice(
          orderDate: DateTime.now(),
          account: user,
          userId: user.id,
          mop: "Cash",
          totalAmount: "1500",
          order: [
            Order(
                decription: "Gym",
                amount: "1500",
                validFrom: user.eDate,
                validTill: user.eDate!.add(
                  Duration(days: 30),
                ))
          ]),
    );
    final numberOfProducts = useState(1);
    final ValueNotifier<PaymentMode> modeOfPayment = useState(PaymentMode.Cash);
    final orderDateController = useTextEditingController(
        text: Formatter.fromDateTime(invoice.value.orderDate));
    final totalAmount = useState('1500');

    return Scaffold(
      body: ModalProgressIndicator(
        isLoading: context.watch<Ui>().isLoading,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              expandedHeight: 160.0,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                titlePadding: EdgeInsets.fromLTRB(10, 8, 0, 20),
                title: Text('Record Payment'),
              ),
              actions: [CloseButton()],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
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
                          firstDate: user.joinedDate!,
                          lastDate: DateTime(2030),
                        );
                        if (orderDate != null) {
                          invoice.value.orderDate = orderDate;
                          orderDateController.text =
                              Formatter.fromDateTime(orderDate);
                        }
                      },
                    ),
                    ListTile(
                      leading:
                          ImageAvatar(imageUrl: user.dpUrl, name: user.name),
                      title: Text(user.name!),
                      subtitle: Text(user.phone!),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ProductDetails(
                      index: index,
                      invoice: invoice,
                      user: user,
                      totalItem: numberOfProducts,
                      totalAmount: totalAmount,
                    );
                  },
                  childCount: numberOfProducts.value,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total"),
                        Text("Rs " + totalAmount.value)
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          numberOfProducts.value += 1;
                          invoice.value.order?.add(Order());
                        },
                        child: Text("Add Item"),
                      ),
                    ),
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
                                    invoice.value.mop = value.name;
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
                      onChanged: (value) => invoice.value.notes = value,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          context.read<Ui>().setLoading();
                          await PaymentsViewModel()
                              .createInvoice(invoice.value);
                          context.read<Ui>().setLoading();
                          Navigator.pop(context);
                        },
                        child: Text("Submit"))
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
  final User user;
  final int index;
  final ValueNotifier<Invoice> invoice;
  final ValueNotifier<int> totalItem;
  final ValueNotifier<String> totalAmount;

  ProductDetails({
    required this.user,
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
                          invoice.value.order![index].decription = value.name;
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
                                    firstDate: user.joinedDate!,
                                    lastDate: DateTime(2030),
                                    initialDateRange:
                                        invoice.value.order?[index].validFrom ==
                                                null
                                            ? null
                                            : DateTimeRange(
                                                start: invoice.value
                                                    .order![index].validFrom!,
                                                end: invoice.value.order![index]
                                                    .validTill!),
                                  );
                                  if (range != null) {
                                    validFromController.text =
                                        Formatter.fromDateTime(range.start);
                                    validTillController.text =
                                        Formatter.fromDateTime(range.end);
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
                              ),
                            ),
                          ],
                        )
                      : TextFormField(
                          decoration: getInputDecoration('Product Name'),
                          onChanged: (value) =>
                              invoice.value.order![index].decription = value,
                        ),
            ],
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
