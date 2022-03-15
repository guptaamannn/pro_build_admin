enum PaymentMode { cash, transfer }

extension ParseToString on PaymentMode {
  String toName() {
    return "${name[0].toUpperCase()}${name.substring(1)}";
  }
}
