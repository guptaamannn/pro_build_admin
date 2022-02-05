import 'package:flutter/material.dart';
import 'package:nanoid/async.dart';
import 'package:pro_build_attendance/core/enums/view_state.dart';
import 'package:pro_build_attendance/core/model/invoice.dart';
import 'package:pro_build_attendance/core/model/user.dart';
import 'package:pro_build_attendance/core/services/firestore_service.dart';
import 'package:pro_build_attendance/core/services/storage_service.dart';
import 'package:pro_build_attendance/core/viewModel/base_model.dart';
import 'package:pro_build_attendance/locator.dart';

class PaymentModel extends BaseModel {
  final _firestore = locator<FirestoreService>();
  final _storage = locator<StorageService>();

  Stream<Iterable<Invoice>> invoiceStream() {
    var stream = _firestore.invoiceStream();
    return stream
        .map((event) => event.docs.map((doc) => Invoice.fromJson(doc.data())));
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

    await _firestore.createInvoice(invoice.toJson(), eDate);
    setState(ViewState.idle);
  }

  Future<String?> getDpUrl(User user) async {
    return await _storage.downloadUrl(user.id!);
  }

  IconData getProductIcon(String product) {
    switch (product) {
      case "Gym":
        return Icons.fitness_center;

      case "Locker":
        return Icons.lock;

      case "Registration":
        return Icons.how_to_reg;

      default:
        return Icons.inventory_2;
    }
  }

  Future<void> deleteReceipt(String? invoiceId) async {
    await _firestore.deleteReceipt(invoiceId);
  }
}
