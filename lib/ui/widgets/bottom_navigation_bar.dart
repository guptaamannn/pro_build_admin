import 'package:flutter/material.dart';
import 'package:pro_build_attendance/ui/views/attendance_view.dart';
import 'package:pro_build_attendance/ui/views/expenses_view.dart';
import 'package:pro_build_attendance/ui/views/home_view.dart';
import 'package:pro_build_attendance/ui/views/payments_view.dart';
import 'package:pro_build_attendance/ui/views/users_view.dart';

class CustomBottomNavigation extends StatelessWidget {
  final String currentRoute;

  CustomBottomNavigation({Key? key, required this.currentRoute})
      : super(key: key);

  final List<String> navItems = [
    HomeView.id,
    AttendanceView.id,
    UsersView.id,
    PaymentsView.id,
    ExpensesView.id,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (value) {
        Navigator.pushReplacementNamed(context, navItems[value]);
      },
      currentIndex: navItems.indexOf(currentRoute),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Theme.of(context).colorScheme.onSurface,
      unselectedItemColor: Theme.of(context).colorScheme.secondaryContainer,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: "Dashboard",
            activeIcon: Icon(Icons.dashboard_rounded)),
        BottomNavigationBarItem(
            icon: Icon(Icons.badge_outlined),
            label: "Attendance",
            activeIcon: Icon(Icons.badge_rounded)),
        BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: "Users",
            activeIcon: Icon(Icons.people_alt_rounded)),
        BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on_outlined),
            label: "Money",
            activeIcon: Icon(Icons.monetization_on_rounded)),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: "Expwnse",
            activeIcon: Icon(Icons.shopping_bag_rounded)),
      ],
    );
  }
}
