import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pro_build_attendance/core/enums/products.dart';
import 'package:pro_build_attendance/core/model/invoice.dart';
import 'package:pro_build_attendance/core/model/user.dart';
import 'package:pro_build_attendance/core/utils/formatter.dart';
import 'package:pro_build_attendance/core/viewModel/transaction_model.dart';
import 'package:pro_build_attendance/ui/shared/input_decoration.dart';
import 'package:pro_build_attendance/ui/views/payment_form.dart';
import 'package:pro_build_attendance/ui/views/user_view.dart';
import 'package:pro_build_attendance/ui/widgets/image_avatar.dart';
import 'package:provider/provider.dart';

class PaymentView extends StatelessWidget {
  final Invoice invoice;

  const PaymentView({Key? key, required this.invoice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<Transaction>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Receipt"),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert_rounded),
            onSelected: (value) async {
              if (value == "delete") {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Heads Up!"),
                        content:
                            Text("Permanently delete receipt from records?"),
                        actions: [
                          OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel")),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.red[300]),
                            onPressed: () async {
                              await model.deleteReceipt(invoice.invoiceId);
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                            },
                            child: Text("Delete"),
                          )
                        ],
                      );
                    });
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text("Delete"),
                  value: 'delete',
                )
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Order Id: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(invoice.invoiceId!),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Date: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(Formatter.fromDateTime(invoice.orderDate)),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Mode of Payment: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(invoice.mop!),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Notes: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(invoice.notes.toString()),
                ],
              ),
              Divider(),
              Text(
                "Billed To:",
                style: Theme.of(context).textTheme.headline5,
              ),
              ListTile(
                leading: CachedImageAvatar(
                  fileName: invoice.userId!,
                  name: invoice.account!.name!,
                ),
                title: Text(invoice.account!.name!),
                subtitle: Text(
                    invoice.account!.phone! + "\n" + invoice.account!.email!),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
                selectedTileColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                onTap: () => Navigator.pushNamed(context, UserView.id,
                    arguments: invoice.userId),
              ),
              Divider(),
              Text(
                "Items:",
                style: Theme.of(context).textTheme.headline5,
              ),
              Column(
                children: invoice.order!
                    .map<Widget>((e) => ListTile(
                          leading: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child:
                                  Icon(model.getProductIcon(e.description!))),
                          title: Text(e.description!),
                          subtitle: e.validFrom != null
                              ? Text(Formatter.fromDateTime(e.validFrom) +
                                  " - " +
                                  Formatter.fromDateTime(e.validTill))
                              : null,
                          trailing: Text("Rs " + e.amount!),
                        ))
                    .toList(),
              ),
              Divider(),
              ListTile(
                title: Text(
                  "Total:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Text("Rs " + invoice.totalAmount!),
              ),
              Row(
                children: [
                  Expanded(
                      child: OutlinedButton(
                    child: Text("Edit"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PaymentForm(null, invoice)));
                    },
                  )),
                  SizedBox(width: 10),
                  Expanded(
                      child: ElevatedButton(
                    child: Text("Send"),
                    onPressed: () {
                      print("send receipt");
                    },
                  ))
                ],
              )
            ],
          ),
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
                                      firstDate: user.joinedDate!,
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
                                      firstDate: user.joinedDate!,
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
