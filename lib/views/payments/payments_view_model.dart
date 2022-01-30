import 'package:nanoid/async.dart';
import 'package:pro_build_attendance/model/invoice.dart';
import 'package:pro_build_attendance/model/user.dart';
import 'package:pro_build_attendance/services/firestore_service.dart';
import 'package:pro_build_attendance/services/storage_service.dart';

class PaymentsViewModel {
  Firestore _firestore = Firestore();
  StorageService _storage = StorageService();

  Stream<Iterable<Invoice>> invoiceStream() {
    var stream = _firestore.invoiceStream();
    return stream
        .map((event) => event.docs.map((doc) => Invoice.fromJson(doc.data())));
  }

  Future<void> createInvoice(Invoice invoice) async {
    String id = await nanoid(12);
    invoice.invoiceId = id;
    DateTime? eDate;
    for (var order in invoice.order!) {
      if (order.decription == "Gym") {
        eDate = order.validTill!;
      }
    }
    await _firestore.createInvoice(invoice.toJson(), eDate);
  }

  Future<String?> getDpUrl(User user) async {
    return await _storage.downloadUrl(user.id!);
  }
}
