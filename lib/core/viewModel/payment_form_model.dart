import 'package:nanoid/async.dart';
import 'package:pro_build_admin/core/services/firestore_service.dart';

import '../enums/view_state.dart';
import '../utils/formatter.dart';
import '/core/enums/payments_mode.dart';
import '/core/enums/products.dart';
import '/core/model/invoice.dart';
import '/core/model/user.dart';
import '/core/viewModel/base_model.dart';

class PaymentFormModel extends BaseModel {
  final FirestoreService _firestore = FirestoreService();

  PaymentFormModel([Invoice? invoice, User? user]) {
    if (invoice != null) {
      updateInvoice(invoice);
    }
    if (user != null && invoice == null) {
      setUser(user);
    }
  }

  Invoice _invoice = Invoice(
    orderDate: DateTime.now(),
    mop: PaymentMode.cash.name,
    order: [
      Product(
        description: Products.gym.name,
        amount: 1500,
      ),
    ],
  );

  User? _user;
  User? get getUser => _user;

  String? get getNotes => _invoice.notes;

  void setUser(User? user) {
    _user = user;
    _invoice.userId = user?.id;
    _invoice.account = user;

    notifyListeners();
  }

  Invoice get getInvoice => _invoice;

  void updateInvoice(Invoice invoice) {
    _invoice = invoice;
    setUser(User(
        id: invoice.userId,
        name: invoice.account!.name,
        email: invoice.account!.email,
        phone: invoice.account!.phone));
    notifyListeners();
  }

  void setOrderDate(DateTime date) {
    _invoice.orderDate = date;
  }

  void addProduct() {
    _invoice.order!.add(Product(description: Products.gym.name, amount: 1500));
    notifyListeners();
  }

  void updateProduct(Product product, int index) {
    _invoice.order![index] = product;
    notifyListeners();
  }

  void removeProduct(int index) {
    _invoice.order!.removeAt(index);
    notifyListeners();
  }

  void setPaymentMode(String mode) {
    _invoice.mop = mode;
    notifyListeners();
  }

  void setNotes(String notes) {
    _invoice.notes = notes;
    notifyListeners();
  }

  void setOrderDescription(String description, int index) {
    _invoice.order![index].description = description;
    if (description != Products.gym.name &&
        description != Products.locker.name) {
      _invoice.order![index].validFrom = null;
      _invoice.order![index].validTill = null;
    }
    notifyListeners();
  }

  void setOrderValidFrom(Products product, int index, DateTime date) {
    if (product == Products.gym || product == Products.locker) {
      _invoice.order![index].validFrom = date;
    }
    notifyListeners();
  }

  void setOrderValidTill(Products product, int index, DateTime date) {
    if (product == Products.gym || product == Products.locker) {
      _invoice.order![index].validTill = date;
    }
    notifyListeners();
  }

  void setPrice(int index, double price) {
    _invoice.order![index].amount = price;
    _invoice.totalAmount = _invoice.getTotal();
    notifyListeners();
  }

  String get getTotalAmount => _invoice.totalAmount.toString();

  void setOtherDescription(String description) {}

  Future<void> submitForm() async {
    setState(ViewState.busy);
    DateTime? eDate;
    if (_invoice.invoiceId == null) {
      String id = await nanoid(12);
      _invoice.invoiceId = id;

      for (var order in _invoice.order!) {
        if (order.description == "gym") {
          eDate = order.validTill!;
        }
      }
    }
    await _firestore.createInvoice(
        _invoice.toJson(), eDate, _invoice.forUser());
    setState(ViewState.idle);
  }

  String getPrice(int index) {
    return _invoice.order![index].amount.toString();
  }

  String? getValidFrom(int index) {
    var order = _invoice.order?[index].validFrom;
    if (order != null) return Formatter.fromDateTime(order);
    return null;
  }

  String? getValidTill(int index) {
    var order = _invoice.order?[index].validTill;
    if (order != null) return Formatter.fromDateTime(order);

    return null;
  }

  String? getOrderDate() {
    return Formatter.fromDateTime(_invoice.orderDate);
  }

  PaymentMode get getPaymentMode {
    for (var mode in PaymentMode.values) {
      if (mode.name == _invoice.mop) return mode;
    }
    return PaymentMode.cash;
  }

  Products getProduct(int index) {
    for (var item in Products.values) {
      if (item.name == _invoice.order![index].description) {
        return item;
      }
    }
    return Products.other;
  }

  String? getProductDescription(int index) {
    return _invoice.order?[index].description;
  }
}
