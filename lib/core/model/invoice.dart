import '/core/model/user.dart';

class Invoice {
  String? invoiceId;
  DateTime? orderDate;
  String? userId;
  User? account;
  List<Product>? order;
  String? mop;
  String? notes;
  double? totalAmount;

  Invoice(
      {this.invoiceId,
      this.orderDate,
      this.userId,
      this.account,
      this.order,
      this.mop,
      this.totalAmount,
      this.notes});

  Invoice.fromJson(Map<String, dynamic> json) {
    invoiceId = json['invoiceId'];
    orderDate = json['orderDate'].toDate();
    userId = json['userId'];
    account = json['account'] != null ? User.fromUsers(json['account']) : null;
    if (json['order'] != null) {
      order = <Product>[];
      json['order'].forEach((v) {
        order!.add(Product.fromJson(v));
      });
    }
    mop = json['mop'];
    totalAmount = getTotal();
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['invoiceId'] = invoiceId;
    data['orderDate'] = orderDate;
    data['userId'] = userId;
    if (account != null) {
      data['account'] = {
        'name': account!.name,
        'phone': account!.phone,
        'email': account!.email,
      };
    }
    if (order != null) {
      data['order'] = order!.map((v) => v.toJson()).toList();
    }
    data['mop'] = mop;
    data['notes'] = notes;
    data['totalAmount'] = getTotal();
    return data;
  }

  Map<String, dynamic> forUser() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["invoiceId"] = invoiceId;
    data["orderDate"] = orderDate;
    data["mop"] = mop;
    data["notes"] = notes;
    data["totalAmount"] = totalAmount;
    data["order"] = order;

    return data;
  }

  double getTotal() {
    double sum = 0;
    if (order != null && order!.isNotEmpty) {
      for (var element in order!) {
        if (element.amount != null) {
          sum += element.amount!;
        }
      }
    }
    return sum;
  }
}

class Product {
  String? description;
  double? amount;
  DateTime? validFrom;
  DateTime? validTill;

  Product({this.description, this.amount, this.validFrom, this.validTill});

  Product.fromJson(Map<String, dynamic> json) {
    description = json['decription'];
    amount = json['amount'];
    if (json['validFrom'] != null) {
      validFrom = json['validFrom'].toDate();
    } else {
      validFrom = null;
    }
    if (json['validTill'] != null) {
      validTill = json['validTill'].toDate();
    } else {
      validTill = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['decription'] = description;
    data['amount'] = amount;
    if (description != "gym" || description != "locker") {
      data['validFrom'] = validFrom;
      data['validTill'] = validTill;
    }
    return data;
  }
}
