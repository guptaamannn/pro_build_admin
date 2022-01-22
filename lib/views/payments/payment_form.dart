import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pro_build_attendance/model/invoice.dart';
import 'package:pro_build_attendance/model/user.dart';
import 'package:pro_build_attendance/utils/formatter.dart';
import 'package:pro_build_attendance/utils/input_decoration.dart';
import 'package:pro_build_attendance/views/payments/payments_view_model.dart';
import 'package:pro_build_attendance/widgets/image_avatar.dart';

enum PaymentMode { cash, transfer }

class PaymentForm extends HookWidget {
  final User? user;

  final _formKey = GlobalKey<FormState>();
  final invoice = Invoice(orderDate: DateTime.now());
  final PaymentsViewModel model = PaymentsViewModel();

  PaymentForm({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderDate = useTextEditingController(
      text: Formatter.fromDateTime(DateTime.now()),
    );
    final validFromController =
        useTextEditingController(text: Formatter.fromDateTime(user!.eDate));
    final validTillController = useTextEditingController(
        text: Formatter.fromDateTime(DateTime(
            user!.eDate.year, user!.eDate.month + 1, user!.eDate.day)));
    final modelOfPayment = useState(PaymentMode.cash);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Create Invoice"),
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(10),
            children: [
              Stack(
                children: [
                  Center(
                    child: Hero(
                      tag: user!.id,
                      child: ImageAvatar(
                        imageUrl: user!.dpUrl,
                        name: user!.name,
                        radius: 40,
                      ),
                    ),
                  ),
                  // Align(alignment: Alignment.topRight, child: CloseButton())
                ],
              ),
              addSpace(height: 5),
              Center(
                child: Text(user!.name,
                    style: Theme.of(context).textTheme.headline5),
              ),
              addSpace(),
              //Order Date
              TextFormField(
                readOnly: true,
                controller: orderDate,
                decoration: getInputDecoration("Order Date"),
                onTap: () async {
                  var date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: user!.joinedDate!,
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    invoice.orderDate = date;
                    orderDate.text = Formatter.fromDateTime(date);
                  }
                },
              ),
              addSpace(),

              //Valid From
              Row(
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
                            firstDate: user!.joinedDate!,
                            lastDate: DateTime(2030));
                        if (range != null) {
                          invoice.validFrom = range.start;
                          invoice.validTill = range.end;
                          validFromController.text =
                              Formatter.fromDateTime(range.start);
                          validTillController.text =
                              Formatter.fromDateTime(range.end);
                        }
                      },
                    ),
                  ),
                  addSpace(width: 12),
                  //Valid till
                  Expanded(
                    child: TextFormField(
                      decoration: getInputDecoration('To'),
                      readOnly: true,
                      controller: validTillController,
                    ),
                  ),
                ],
              ),
              addSpace(),
              Text("Mode of Payment"),
              Row(
                children: [
                  Radio(
                    value: PaymentMode.cash,
                    groupValue: modelOfPayment.value,
                    onChanged: (value) =>
                        modelOfPayment.value = PaymentMode.cash,
                  ),
                  Text("Cash"),
                  SizedBox(width: 12),
                  Radio(
                    value: PaymentMode.transfer,
                    groupValue: modelOfPayment.value,
                    onChanged: (value) =>
                        modelOfPayment.value = PaymentMode.transfer,
                  ),
                  Text('Bank Transfer'),
                ],
              ),
              // addSpace(),
              TextFormField(
                decoration: getInputDecoration(
                  'Amount',
                ).copyWith(prefixText: '\u{20B9} '),
                initialValue: '1500',
                onSaved: (value) => invoice.amount = value,
              ),
              addSpace(),
              TextFormField(
                decoration: getInputDecoration('Notes'),
                onSaved: (newValue) => invoice.notes = newValue,
              ),
              ListTile(
                trailing:
                    TextButton(onPressed: () {}, child: Text("+ More Items")),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    invoice.userId = user!.id;
                    invoice.userName = user!.name;
                    print(invoice.toJson());
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text("Confirm"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
