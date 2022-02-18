import 'package:flutter/material.dart';
import 'package:pro_build_attendance/ui/views/attendance_view.dart';
import 'package:pro_build_attendance/ui/views/auth_wrapper_view.dart';
import 'package:pro_build_attendance/ui/views/expenses_view.dart';
import 'package:pro_build_attendance/ui/views/home_view.dart';
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

    case ExpensesView.id:
      return MaterialPageRoute(builder: (context) => ExpensesView());

    case HomeView.id:
      return MaterialPageRoute(builder: (context) => HomeView());

    case AttendanceView.id:
      return MaterialPageRoute(builder: (context) => AttendanceView());

    case UserView.id:
      dynamic userId = settings.arguments;
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
