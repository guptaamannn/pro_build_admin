import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '/core/enums/payments_mode.dart';
import '/core/enums/products.dart';
import '/core/model/invoice.dart';
import '/core/model/user.dart';
import '/core/utils/formatter.dart';
import '/core/viewModel/payment_form_model.dart';

import '/ui/shared/input_decoration.dart';
import '/ui/widgets/autocomplete_user_search.dart';
import '/ui/widgets/image_avatar.dart';

class PaymentForm extends StatelessWidget {
  final User? user;
  final Invoice? invoice;

  const PaymentForm({Key? key, this.user, this.invoice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PaymentFormModel(invoice, user),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: const _BuildAppBar(),
        ),
        body: const _BuildBody(),
      ),
    );
  }
}

class _BuildBody extends StatelessWidget {
  const _BuildBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          const _OrderDateField(),
          addSpace(),
          const _BuildUserField(),
          addSpace(),
          const _BuildProducts(),
          addSpace(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    context.read<PaymentFormModel>().addProduct();
                  },
                  child: const Text("+ Item")),
              Text(context.read<PaymentFormModel>().getTotalAmount),
            ],
          ),
          addSpace(),
          const Text("Mode of Payment"),
          const _PaymentModeRadio(),
          addSpace(),
          TextFormField(
            initialValue: context.read<PaymentFormModel>().getNotes,
            decoration:
                getInputDecoration("Notes").copyWith(hintText: "Optional"),
            onChanged: (value) {
              context.read<PaymentFormModel>().setNotes(value);
            },
          ), //Notes
          addSpace(),
          ElevatedButton(
            onPressed: () async {
              await context.read<PaymentFormModel>().submitForm();
              Navigator.pop(context);
            },
            child: const Text("Submit"),
            style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 18)),
          )
        ],
      ),
    );
  }
}

class _BuildProducts extends StatelessWidget {
  const _BuildProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> productWidgets = [];

    for (var i = 0;
        i < context.watch<PaymentFormModel>().getInvoice.order!.length;
        i++) {
      productWidgets.add(_ProductDetails(
        product: context.read<PaymentFormModel>().getInvoice.order![i],
        index: i,
      ));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: productWidgets,
    );
  }
}

class _BuildUserField extends StatelessWidget {
  const _BuildUserField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? _user = context.watch<PaymentFormModel>().getUser;
    String? userId = context.watch<PaymentFormModel>().getInvoice.userId;

    if (userId != null) {
      return ListTile(
        leading: CachedImageAvatar(
          fileName: _user!.id!,
          name: _user.name,
        ),
        title: Text(_user.name!),
        subtitle: Text(_user.phone!),
        trailing: CloseButton(
          onPressed: () {
            context.read<PaymentFormModel>().setUser(null);
          },
        ),
      );
    } else {
      return SearchUser(
        onSelected: (User user) {
          context.read<PaymentFormModel>().setUser(user);
        },
        searchUsing: "name",
      );
    }
  }
}

class _OrderDateField extends HookWidget {
  const _OrderDateField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(
        text: context.read<PaymentFormModel>().getOrderDate());
    return TextFormField(
      decoration: getInputDecoration("Order Date"),
      controller: controller,
      readOnly: true,
      onTap: () async {
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2021),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          controller.text = Formatter.fromDateTime(date);
          context.read<PaymentFormModel>().setOrderDate(date);
        }
      },
    );
  }
}

class _ProductDetails extends HookWidget {
  final Product? product;
  final int index;

  const _ProductDetails({Key? key, this.product, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useState(context.read<PaymentFormModel>().getProduct(index));

    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<Products>(
                    decoration: getInputDecoration("Product"),
                    value: state.value,
                    items: Products.values
                        .map(
                          (e) => DropdownMenuItem(
                              child: Text(e.toName()), value: e),
                        )
                        .toList(),
                    onChanged: (value) {
                      state.value = value!;
                      if (value != Products.other) {
                        context
                            .read<PaymentFormModel>()
                            .setOrderDescription(value.name, index);
                      }
                    },
                  ),
                ),
                addSpace(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: getInputDecoration("Price"),
                    initialValue:
                        context.read<PaymentFormModel>().getPrice(index),
                    onChanged: (value) {
                      context
                          .read<PaymentFormModel>()
                          .setPrice(index, double.parse(value));
                    },
                  ),
                ),
              ],
            ),
            addSpace(),
            _ProductSupportingWidget(
              product: state.value,
              index: index,
            ),
            addSpace(),
          ],
        ),
        index != 0
            ? Positioned(
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    context.read<PaymentFormModel>().removeProduct(index);
                  },
                ),
                right: 1,
                top: 1,
              )
            : Container(),
      ],
    );
  }
}

class _ProductSupportingWidget extends HookWidget {
  final int index;
  final Products product;
  const _ProductSupportingWidget(
      {Key? key, required this.product, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fromController = useTextEditingController(
        text: context.read<PaymentFormModel>().getValidFrom(index));
    final tillController = useTextEditingController(
        text: context.read<PaymentFormModel>().getValidTill(index));
    switch (product) {
      case Products.gym:
      case Products.locker:
        return Row(
          children: [
            Expanded(
                child: TextFormField(
              controller: fromController,
              decoration: getInputDecoration("Valid From"),
              readOnly: true,
              onTap: () async {
                var range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2021),
                  lastDate: DateTime(2030),
                );
                if (range != null) {
                  fromController.text = Formatter.fromDateTime(range.start);
                  tillController.text = Formatter.fromDateTime(range.end);
                  context
                      .read<PaymentFormModel>()
                      .setOrderValidFrom(product, index, range.start);
                  context
                      .read<PaymentFormModel>()
                      .setOrderValidTill(product, index, range.end);
                }
              },
            )),
            addSpace(width: 10),
            Expanded(
                child: TextFormField(
              controller: tillController,
              readOnly: true,
              decoration: getInputDecoration("Valid Till"),
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2021),
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  context
                      .read<PaymentFormModel>()
                      .getInvoice
                      .order![index]
                      .validTill = date;
                }
              },
            )),
          ],
        );
      case Products.registration:
        return Container();
      default:
        return TextFormField(
          decoration: getInputDecoration("Product Name"),
          initialValue:
              context.read<PaymentFormModel>().getProductDescription(index),
          onChanged: (value) {
            context.read<PaymentFormModel>().setOrderDescription(value, index);
          },
        );
    }
  }
}

class _PaymentModeRadio extends HookWidget {
  const _PaymentModeRadio({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useState(context.read<PaymentFormModel>().getPaymentMode);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: PaymentMode.values
          .map(
            (e) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<PaymentMode>(
                  value: e,
                  groupValue: state.value,
                  onChanged: (value) {
                    state.value = value!;
                    context.read<PaymentFormModel>().setPaymentMode(value.name);
                  },
                ),
                Text(e.toName()),
              ],
            ),
          )
          .toList(),
    );
  }
}

class _BuildAppBar extends StatelessWidget {
  const _BuildAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const CloseButton(),
      title: const Text("Add Payment"),
      centerTitle: true,
    );
  }
}
