import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? name;
  String? phone;
  String? dpUrl;
  String? id;
  DateTime? eDate;
  String? email;
  DateTime? joinedDate;
  String? address;
  String? attendTime;

  User({
    required this.name,
    this.phone,
    this.dpUrl,
    required this.id,
    required this.eDate,
    this.email,
    this.joinedDate,
    this.address,
    this.attendTime,
  });

  factory User.fromUsers(Map<String, dynamic>? data) {
    var _timestamp = data?["eDate"];
    var _joinedDate = data?["joinedDate"];
    return User(
        name: data?['name'],
        phone: data?["phone"],
        dpUrl: data?["dpUrl"],
        id: data?["id"],
        eDate: _timestamp is Timestamp ? _timestamp.toDate() : _timestamp,
        email: data?["email"] == null ? "" : data?["email"],
        joinedDate:
            _joinedDate is Timestamp ? _joinedDate.toDate() : _joinedDate,
        address: data?["address"] == null ? "" : data?["address"]);
  }

  factory User.fromAttendance(Map<String, dynamic> data) {
    Timestamp _timestamp = data["eDate"];

    return User(
        name: data["name"],
        id: data["id"],
        eDate: _timestamp.toDate(),
        attendTime: data["time"],
        dpUrl: data["dpUrl"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "dpUrl": dpUrl,
      "id": id,
      "eDate": eDate,
      "email": email,
      "joinedDate": joinedDate,
      "address": address,
    };
  }

  Map<String, dynamic> toAttendance() {
    return {
      "name": name,
      "dpUrl": dpUrl,
      "id": id,
      "eDate": eDate,
      "time": attendTime,
    };
  }

  @override
  String toString() {
    return '$name, $phone';
  }
}
