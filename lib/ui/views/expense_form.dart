import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '/core/enums/expense_types.dart';
import '/core/enums/payments_mode.dart';
import '/core/enums/view_state.dart';
import '/core/model/expense.dart';
import '/core/utils/formatter.dart';
import '/core/viewModel/transaction_model.dart';
import '/ui/shared/input_decoration.dart';
import '/ui/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';

class ExpenseForm extends HookWidget {
  final Expense? expense;

  const ExpenseForm({Key? key, this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Expense> expenseState = useState(expense == null
        ? Expense(
            date: DateTime.now(),
            type: "gym",
            source: "cash",
          )
        : expense!);

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
              titlePadding: const EdgeInsets.fromLTRB(10, 8, 0, 20),
              title: Text(
                'Record Expense',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            ),
            actions: const [CloseButton()],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  TextFormField(
                    decoration: getInputDecoration("Date"),
                    initialValue:
                        Formatter.fromDateTime(expenseState.value.date),
                    readOnly: true,
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        expenseState.value.date = date;
                      }
                    },
                  ),
                  addSpace(),
                  DropdownButtonFormField<ExpenseTypes>(
                    value: ExpenseTypes.gym,
                    decoration: getInputDecoration("Type"),
                    items: ExpenseTypes.values
                        .map((e) => DropdownMenuItem<ExpenseTypes>(
                              child: Text(e.toName()),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (ExpenseTypes? type) {
                      if (type != null) {
                        expenseState.value.type = type.name;
                      }
                    },
                  ),
                  addSpace(),
                  TextFormField(
                    decoration: getInputDecoration("Amount"),
                    keyboardType: TextInputType.number,
                    initialValue: expenseState.value.amount != null
                        ? expenseState.value.amount.toString()
                        : "",
                    onChanged: ((value) =>
                        expenseState.value.amount = double.parse(value)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: PaymentMode.values
                        .map(
                          (e) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio<String>(
                                value: e.name,
                                groupValue: expenseState.value.source,
                                onChanged: (value) {
                                  expenseState.value.source = value!;
                                },
                              ),
                              Text(e.toName()),
                              const SizedBox(width: 20),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                  TextFormField(
                    decoration: getInputDecoration("Notes"),
                    initialValue: expenseState.value.notes,
                    onChanged: (note) {
                      expenseState.value.notes = note;
                    },
                  ),
                  addSpace(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16)),
                    onPressed: () async {
                      expense == null
                          ? await context
                              .read<Transaction>()
                              .recordExpense(expenseState.value)
                          : await context
                              .read<Transaction>()
                              .updateExpense(expenseState.value);
                      Navigator.pop(context);
                    },
                    child: Text(expense == null ? "Submit" : "Update"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
