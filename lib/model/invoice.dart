import 'package:pro_build_attendance/model/user.dart';

class Invoice {
  String? invoiceId;
  DateTime? orderDate;
  String? userId;
  User? account;
  List<Order>? order;
  String? mop;
  String? notes;
  String? totalAmount;

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
    account =
        json['account'] != null ? new User.fromUsers(json['account']) : null;
    if (json['order'] != null) {
      order = <Order>[];
      json['order'].forEach((v) {
        order!.add(new Order.fromJson(v));
      });
    }
    mop = json['mop'];
    totalAmount = getTotal();
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoiceId'] = this.invoiceId;
    data['orderDate'] = this.orderDate;
    data['userId'] = this.userId;
    if (this.account != null) {
      data['account'] = {
        'name': this.account!.name,
        'phone': this.account!.phone,
        'email': this.account!.email,
      };
    }
    if (this.order != null) {
      data['order'] = this.order!.map((v) => v.toJson()).toList();
    }
    data['mop'] = this.mop;
    data['notes'] = this.notes;
    data['totalAmount'] = getTotal();
    return data;
  }

  String getTotal() {
    double sum = 0;
    if (order != null && order!.isNotEmpty) {
      order!.forEach(
        (element) {
          if (element.amount != null && element.amount!.isNotEmpty) {
            sum += double.parse(element.amount!);
          }
        },
      );
    }
    return sum.toString();
  }
}

class Account {
  String? name;
  String? phone;
  String? email;

  Account({this.name, this.phone, this.email});

  Account.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    return data;
  }
}

class Order {
  String? decription;
  String? amount;
  DateTime? validFrom;
  DateTime? validTill;

  Order({this.decription, this.amount, this.validFrom, this.validTill});

  Order.fromJson(Map<String, dynamic> json) {
    decription = json['decription'];
    amount = json['amount'];
    validFrom = json['validFrom'] != null ? json['validFrom'].toDate() : null;
    validTill = json['validTill'] != null ? json['validTill'].toDate() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['decription'] = this.decription;
    data['amount'] = this.amount;
    data['validFrom'] = this.validFrom;
    data['validTill'] = this.validTill;
    return data;
  }
}
