import 'package:flutter/material.dart';
import '/ui/views/attendance_view.dart';
import '/ui/views/auth_wrapper_view.dart';
import '/ui/views/expenses_view.dart';
import '/ui/views/home_view.dart';
import '/ui/views/login_view.dart';
import '/ui/views/payments_view.dart';
import '/ui/views/user_view.dart';
import '/ui/views/users_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AuthWrapperView.id:
      return MaterialPageRoute(builder: (context) => const AuthWrapperView());

    case PaymentsView.id:
      return MaterialPageRoute(builder: (context) => const PaymentsView());

    case UsersView.id:
      return MaterialPageRoute(builder: (context) => const UsersView());

    case ExpensesView.id:
      return MaterialPageRoute(builder: (context) => const ExpensesView());

    case HomeView.id:
      return MaterialPageRoute(builder: (context) => const HomeView());

    case AttendanceView.id:
      return MaterialPageRoute(builder: (context) => const AttendanceView());

    case UserView.id:
      dynamic userId = settings.arguments;
      return MaterialPageRoute(
        builder: (context) => UserView(userId: userId.toString()),
      );

    case LoginView.id:
      return MaterialPageRoute(builder: (context) => const LoginView());

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
