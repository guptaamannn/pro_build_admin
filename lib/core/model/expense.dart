class Expense {
  DateTime? date;
  String? type;
  int? amount;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['type'] = this.type;
    data['amount'] = this.amount;
    data['source'] = this.source;
    data['notes'] = this.notes;
    data['expenseId'] = this.expenseId;
    return data;
  }
}
