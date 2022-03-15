import 'package:flutter/material.dart';
import 'package:nanoid/async.dart';
import '/core/enums/view_state.dart';
import '/core/model/expense.dart';
import '/core/model/invoice.dart';
import '/core/model/user.dart';
import '/core/services/firestore_service.dart';
import '/core/services/storage_service.dart';
import '/core/viewModel/base_model.dart';
import '/locator.dart';

class Transaction extends BaseModel {
  final _firestore = locator<FirestoreService>();
  final _storage = locator<StorageService>();

  Stream<Iterable<Invoice>> invoiceStream(String? userId) {
    if (userId == null) {
      var stream = _firestore.invoiceStream();
      return stream.map(
          (event) => event.docs.map((doc) => Invoice.fromJson(doc.data())));
    } else {
      var stream = _firestore.userInvoiceStream(userId);
      return stream.map(
          (event) => event.docs.map((doc) => Invoice.fromJson(doc.data())));
    }
  }

  Future<void> createInvoice(Invoice invoice) async {
    setState(ViewState.busy);
    String id = await nanoid(12);
    invoice.invoiceId = id;
    DateTime? eDate;
    for (var order in invoice.order!) {
      if (order.description == "Gym") {
        eDate = order.validTill!;
      }
    }

    await _firestore.createInvoice(invoice.toJson(), eDate, invoice.forUser());
    setState(ViewState.idle);
  }

  Future<String?> getDpUrl(User user) async {
    return await _storage.downloadUrl(user.id!);
  }

  ///Returns [IconData] based on product supplied.
  IconData getProductIcon(String product) {
    switch (product) {
      case "gym":
        return Icons.fitness_center;

      case "locker":
        return Icons.lock;

      case "registration":
        return Icons.how_to_reg;

      default:
        return Icons.inventory_2;
    }
  }

  ///Returns [IconData] based on expense supplied.
  IconData getExpenseIcon(String expense) {
    switch (expense) {
      case "gym":
        return Icons.fitness_center;

      case "personal":
        return Icons.person_outline_rounded;

      case "protein":
        return Icons.medication_rounded;

      case "rent":
        return Icons.business_rounded;

      case "sportswear":
        return Icons.shopping_bag_rounded;

      default:
        return Icons.monetization_on_outlined;
    }
  }

  Future<void> deleteReceipt(String? invoiceId) async {
    await _firestore.deleteReceipt(invoiceId);
  }

  //<--------------- Expenses ------------------>
  Stream<Iterable<Expense>> expenseStream() {
    return _firestore.expenseStream().map(
          (event) => event.docs.map(
            (doc) => Expense.fromJson(doc.data()),
          ),
        );
  }

  Future<void> recordExpense(Expense expense) async {
    setState(ViewState.busy);
    String id = await nanoid(12);
    expense.expenseId = id;
    await _firestore.recordExpense(expense.toJson(), id);
    setState(ViewState.idle);
  }

  Future<void> deleteExpense(Expense expense) async {
    setState(ViewState.busy);
    await _firestore.deleteExpense(expense.expenseId);
    setState(ViewState.idle);
  }

  Future<void> updateExpense(Expense value) async {
    setState(ViewState.busy);
    await _firestore.updateExpense(value.expenseId, value.toJson());
    setState(ViewState.idle);
  }
}
