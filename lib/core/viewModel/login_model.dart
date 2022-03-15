import 'package:firebase_auth/firebase_auth.dart';
import '/core/enums/view_state.dart';
import '/core/services/authentication_service.dart';
import '/core/viewModel/base_model.dart';

class LoginModel extends BaseModel {
  final AuthService _auth = AuthService();

  User? _user;

  Future<String> login(String email, String password) async {
    setState(ViewState.busy);
    try {
      UserCredential credential = await _auth.signInWithEmail(email, password);
      _user = credential.user!;
      setState(ViewState.idle);
      return "success";
    } on FirebaseAuthException catch (e) {
      setState(ViewState.idle);

      return e.message!;
    }

    // if (loginResult is UserCredential) {
    //   return true;
    // }
    // return loginResult;
  }

  Future<void> logout() async {
    setState(ViewState.busy);
    await _auth.signOut();
    setState(ViewState.idle);
  }

  Stream<User?> authStatus() {
    return _auth.idTokenChanges();
  }
}
