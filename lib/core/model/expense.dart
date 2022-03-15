class Expense {
  DateTime? date;
  String? type;
  double? amount;
  String? source;
  String? notes;
  String? expenseId;

  Expense(
      {this.date,
      this.type,
      this.amount,
      this.source,
      this.notes,
      this.expenseId});

  Expense.fromJson(Map<String, dynamic> json) {
    date = json['date'].toDate();
    type = json['type'];
    amount = json['amount'];
    source = json['source'];
    notes = json['notes'];
    expenseId = json['expenseId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['type'] = type;
    data['amount'] = amount;
    data['source'] = source;
    data['notes'] = notes;
    data['expenseId'] = expenseId;
    return data;
  }
}
