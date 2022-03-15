import 'package:flutter/material.dart';
import '/core/model/expense.dart';
import '/core/utils/formatter.dart';
import '/core/viewModel/transaction_model.dart';
import '/ui/views/expense_form.dart';
import '/ui/widgets/bottom_navigation_bar.dart';
import '/ui/widgets/delete_dialog.dart';
import '/ui/widgets/dumbbell_spinner.dart';
import 'package:provider/provider.dart';

class ExpensesView extends StatelessWidget {
  static const String id = "/expenses";
  const ExpensesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<Transaction>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pro Build"),
        actions: const [
          Icon(Icons.search),
          SizedBox(width: 12),
          Icon(Icons.sort),
          SizedBox(width: 12)
        ],
        bottom: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Expenses"),
        ),
      ),
      // drawer: NavigationDrawer(currentRoute: id),
      bottomNavigationBar:
          Hero(tag: "nav", child: CustomBottomNavigation(currentRoute: id)),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ExpenseForm()));
          }),
      body: SafeArea(
        child: StreamBuilder<Iterable<Expense>>(
            stream: model.expenseStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: DumbbellSpinner());
              }
              if (snapshot.data == null ||
                  !snapshot.hasData ||
                  snapshot.hasError ||
                  snapshot.data!.isEmpty) {
                return const Center(child: Text("No data available."));
              }

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Expense expense = snapshot.data!.toList()[index];
                  return ListTile(
                    leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(model.getExpenseIcon(expense.type!))),
                    title: Text(
                        "${expense.type![0].toUpperCase()}${expense.type!.substring(1)}"),
                    subtitle: Text(expense.notes == null
                        ? "${expense.source![0].toUpperCase()}${expense.source!.substring(1)}"
                        : expense.notes!),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          Formatter.fromDateTime(expense.date),
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Text(
                          "Rs ${expense.amount.toString()}",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Stack(
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: expense
                                        .toJson()
                                        .entries
                                        .map<Widget>((e) => ListTile(
                                              leading: Baseline(
                                                  baseline: 18,
                                                  baselineType:
                                                      TextBaseline.alphabetic,
                                                  child: Text(
                                                      "${e.key.toUpperCase()}:")),
                                              title: Text(e.value.toString()),
                                            ))
                                        .toList()),
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: PopupMenuButton<String>(
                                    onSelected: (value) async {
                                      switch (value) {
                                        case 'edit':
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ExpenseForm(
                                                          expense: expense)));
                                          break;
                                        case 'delete':
                                          await showDialog(
                                              context: context,
                                              builder: (context) {
                                                return DeleteDialog(
                                                  onPressed: () async {
                                                    await model
                                                        .deleteExpense(expense);
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              });
                                      }
                                    },
                                    child: const Icon(Icons.more_vert_rounded),
                                    itemBuilder: (context) {
                                      return [
                                        const PopupMenuItem(
                                          child: Text("Edit"),
                                          value: "edit",
                                        ),
                                        const PopupMenuItem(
                                          child: Text("Delete"),
                                          value: "delete",
                                        )
                                      ];
                                    },
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                  );
                },
              );
            }),
      ),
    );
  }
}
