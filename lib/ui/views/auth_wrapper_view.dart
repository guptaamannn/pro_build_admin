import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/core/viewModel/login_model.dart';
import '/ui/views/attendance_view.dart';
import '/ui/views/login_view.dart';
import '/ui/widgets/dumbbell_spinner.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';

class AuthWrapperView extends StatelessWidget {
  static const String id = "/";
  const AuthWrapperView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return authWrapper(context, const LoginView(), const AttendanceView());
  }
}

Widget authWrapper(BuildContext context, Widget loginPage, Widget homePage) {
  return ChangeNotifierProvider<LoginModel>(
    create: (context) => locator<LoginModel>(),
    child: Consumer<LoginModel>(builder: (context, model, child) {
      return StreamBuilder(
        stream: model.authStatus(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              return loginPage;
            } else {
              return homePage;
            }
          }
          return const Material(
            child: Center(
              child: DumbbellSpinner(),
            ),
          );
        },
      );
    }),
  );
}
