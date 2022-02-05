import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<dynamic> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Stream<User?> idTokenChanges() {
    return _auth.idTokenChanges();
  }

  //Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
