import 'package:firebase_auth/firebase_auth.dart';
import 'package:pro_build_attendance/core/enums/view_state.dart';
import 'package:pro_build_attendance/core/services/authentication_service.dart';
import 'package:pro_build_attendance/core/viewModel/base_model.dart';

class LoginModel extends BaseModel {
  final AuthService _auth = AuthService();

  Future<dynamic> login(String email, String password) async {
    setState(ViewState.busy);
    var loginResult = await _auth.signInWithEmail(email, password);
    setState(ViewState.idle);
    if (loginResult is UserCredential) {
      return true;
    }
    return loginResult;
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
