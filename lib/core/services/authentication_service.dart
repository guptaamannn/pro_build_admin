import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Stream<User?> idTokenChanges() {
    return _auth.idTokenChanges();
  }

  //<-------------- Sign in with phone ----------------->

  // Future<void> signInWithPhone(String phone)async {
  //   await _auth.verifyPhoneNumber(phoneNumber: phone, verificationCompleted: (credential) async {
  //     value =
  //   }, verificationFailed: verificationFailed, codeSent: codeSent, codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
  // }

  //Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
