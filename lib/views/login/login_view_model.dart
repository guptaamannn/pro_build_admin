import 'package:flutter/material.dart';
import 'package:pro_build_attendance/services/authentication_service.dart';

class LoginViewModel {
  final AuthService _auth = AuthService();
  final BuildContext context;

  LoginViewModel(this.context);

  Future<void> login(String email, String password) async {
    var loginResult = await _auth.signInWithEmail(email, password);
    if (loginResult != null && loginResult is String) {
      String message = "";
      if (loginResult == "user-not-found") {
        message = "User not found.";
      } else if (loginResult == "wrong-password") {
        message = "Incorrect password.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            child: Text(message),
          ),
        ),
      );
    }
  }
}
