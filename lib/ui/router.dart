import 'package:flutter/material.dart';
import 'package:pro_build_attendance/ui/views/auth_wrapper_view.dart';
import 'package:pro_build_attendance/ui/views/payments_view.dart';
import 'package:pro_build_attendance/ui/views/user_view.dart';
import 'package:pro_build_attendance/ui/views/users_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AuthWrapperView.id:
      return MaterialPageRoute(builder: (context) => AuthWrapperView());

    case PaymentsView.id:
      return MaterialPageRoute(builder: (context) => PaymentsView());

    case UsersView.id:
      return MaterialPageRoute(builder: (context) => UsersView());

    case UserView.id:
      var userId = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => UserView(userId: userId.toString()));

    default:
      return MaterialPageRoute(
        builder: ((_) => Scaffold(
              body: Center(
                child: Text("No route defined for ${settings.name}"),
              ),
            )),
      );
  }
}
