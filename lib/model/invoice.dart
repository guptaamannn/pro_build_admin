class Invoice {
  String? invoiceId;
  DateTime? orderDate;
  String? userId;
  String? userName;
  String? userEmail;
  String? userPhone;
  DateTime? validFrom;
  DateTime? validTill;
  String? mop;
  String? notes;
  String? amount;

  Invoice(
      {this.invoiceId,
      this.orderDate,
      this.userId,
      this.userName,
      this.userEmail,
      this.userPhone,
      this.validFrom,
      this.validTill,
      this.amount,
      this.mop,
      this.notes});

  Invoice.fromJson(Map<String, dynamic> json) {
    invoiceId = json['invoiceId'];
    orderDate = json['orderDate'];
    userId = json['userId'];
    userName = json['userName'];
    userEmail = json['userEmail'];
    userPhone = json['userPhone'];
    validFrom = json['validFrom'];
    validTill = json['validTo'];
    mop = json['mop'];
    amount = json['amount'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoiceId'] = this.invoiceId;
    data['orderDate'] = this.orderDate;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['userEmail'] = this.userEmail;
    data['userPhone'] = this.userPhone;
    data['validFrom'] = this.validFrom;
    data['validTo'] = this.validTill;
    data['amount'] = this.amount;
    data['mop'] = this.mop;
    data['notes'] = this.notes;
    return data;
  }
}
