import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro_build_attendance/model/user.dart';
import 'package:pro_build_attendance/services/firestore_service.dart';
import 'package:pro_build_attendance/services/url_launch_service.dart';
import 'package:pro_build_attendance/views/user/user_edit_view.dart';

class UserViewModel {
  Firestore _firestore = Firestore();
  final BuildContext context;

  UserViewModel(this.context);

  Stream<User> getUserStream(String documentId) {
    return Firestore()
        .getUserStream(documentId)
        .map((e) => User.fromUsers(e.data()));
  }

  Future<void> updateEDate(User user, DateTime date) async {
    await _firestore.updateEDate(user.id, date);
  }

  Future<void> callUser(String phone) async {
    UrlService().call(phone);
  }

  Future<void> messageUser(String phone) async {
    UrlService().message(phone);
  }

  void mailUser(User user) {
    if (user.email != null && user.email != "" && user.email!.isNotEmpty) {
      UrlService().mail(user.email.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("User doesn't have an email address."),
        ),
      );
    }
  }

  editUser(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.getUser(userId);
    User user = User.fromUsers(snapshot.data());

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return UserEditView(user: user);
    }));
  }

  Future<int> useAfterEnd(User user) async {
    if (user.eDate.isBefore(DateTime.now())) {
      int days = await _firestore.daysAfterExp(user.id, user.eDate);
      return days;
    } else
      return 0;
  }

  addPayments() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Payments Feature Coming Soon!"),
    ));
  }
}
