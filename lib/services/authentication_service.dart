import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<dynamic> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  //Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  Widget authWrapper(BuildContext context, Widget loginPage, Widget homePage) {
    return StreamBuilder(
      stream: _auth.idTokenChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return loginPage;
          } else {
            return homePage;
          }
        }
        return Material(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
