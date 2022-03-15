enum Products { registration, gym, locker, other }

extension ParseToString on Products {
  String toName() {
    return "${name[0].toUpperCase()}${name.substring(1)}";
  }
}
