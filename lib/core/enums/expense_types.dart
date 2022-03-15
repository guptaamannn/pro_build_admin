enum ExpenseTypes { rent, gym, personal, sportsWear, protein, other }

extension ParseToString on ExpenseTypes {
  String toName() {
    return "${name[0].toUpperCase()}${name.substring(1)}";
  }
}
