import 'package:flutter/material.dart';
import '/ui/views/attendance_view.dart';
import '/ui/views/expenses_view.dart';
import '/ui/views/home_view.dart';
import '/ui/views/payments_view.dart';
import '/ui/views/users_view.dart';

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
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: "Dashboard",
            activeIcon: Icon(Icons.dashboard_rounded)),
        BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined),
            label: "Attendance",
            activeIcon: Icon(Icons.event_note_rounded)),
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
