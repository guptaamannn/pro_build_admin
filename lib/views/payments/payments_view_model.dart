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

  Future<void> createInvoice(User user, Invoice invoice) async {
    invoice.userId = user.id;
    invoice.userName = user.name;
    invoice.userEmail = user.email;
    invoice.userPhone = user.phone;
    // await _firestore.createInvoice(invoice.toJson);
    print(invoice.toJson());
  }

  Future<String?> getDpUrl(User user) async {
    return await _storage.downloadUrl(user.id);
  }
}
