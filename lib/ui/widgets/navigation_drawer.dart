import 'package:flutter/material.dart';
import 'package:pro_build_attendance/core/model/user.dart';
import 'package:pro_build_attendance/ui/views/auth_wrapper_view.dart';
import 'package:pro_build_attendance/core/viewModel/login_model.dart';
import 'package:pro_build_attendance/ui/views/attendance_view.dart';
import 'package:pro_build_attendance/ui/views/expenses_view.dart';
import 'package:pro_build_attendance/ui/views/home_view.dart';
import 'package:pro_build_attendance/ui/views/payment_form.dart';
import 'package:pro_build_attendance/ui/views/payments_view.dart';
import 'package:pro_build_attendance/ui/views/search_view.dart';
import 'package:pro_build_attendance/ui/views/user_view.dart';
import 'package:pro_build_attendance/ui/views/users_view.dart';
import 'package:pro_build_attendance/ui/widgets/user_create_form.dart';
import 'package:provider/provider.dart';

class NavigationDrawer extends StatelessWidget {
  final String currentRoute;

  const NavigationDrawer({Key? key, required this.currentRoute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(currentRoute);
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          children: [
            Text("Pages"),
            DrawerTile(
              title: "Home",
              isActive: currentRoute == HomeView.id,
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              onTap: () => navigate(context, currentRoute, HomeView.id),
            ),
            DrawerTile(
              isActive: currentRoute == AttendanceView.id,
              title: "Attendance",
              icon: Icons.verified_user_outlined,
              activeIcon: Icons.verified_user_rounded,
              onTap: () {
                if (currentRoute != AttendanceView.id) {
                  Navigator.pushReplacementNamed(context, AuthWrapperView.id);
                } else
                  Navigator.pop(context);
              },
            ),
            DrawerTile(
              activeIcon: Icons.person_rounded,
              icon: Icons.person_outline_rounded,
              isActive: currentRoute == UsersView.id,
              title: "Users",
              onTap: () {
                if (currentRoute != UsersView.id) {
                  Navigator.pushReplacementNamed(context, UsersView.id);
                } else
                  Navigator.pop(context);
              },
            ),
            DrawerTile(
              activeIcon: Icons.attach_money_outlined,
              isActive: currentRoute == PaymentsView.id,
              icon: Icons.attach_money_rounded,
              title: "Payments",
              onTap: () {
                if (currentRoute != PaymentsView.id) {
                  Navigator.pushReplacementNamed(context, PaymentsView.id);
                } else
                  Navigator.pop(context);
              },
            ),
            DrawerTile(
                activeIcon: Icons.shopping_bag_rounded,
                isActive: currentRoute == ExpensesView.id,
                icon: Icons.shopping_bag_outlined,
                title: "Expenses",
                onTap: () => navigate(context, currentRoute, ExpensesView.id)),
            Divider(),
            Text("Actions"),
            DrawerTile(
              isActive: false,
              icon: Icons.search,
              title: "Search",
              onTap: () async {
                var result = await showSearch<User?>(
                    context: context, delegate: CustomSearchDelegate());
                if (result != null) {
                  print("user received");
                  Navigator.popAndPushNamed(context, UserView.id,
                      arguments: result.id!);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            DrawerTile(
              title: "Create User",
              icon: Icons.account_circle_outlined,
              onTap: () async {
                showModalBottomSheet(
                  isScrollControlled: true,
                  useRootNavigator: true,
                  context: context,
                  builder: (context) {
                    return UserAttendanceAdd();
                  },
                );
              },
            ),
            DrawerTile(
              title: "Record Payment",
              icon: Icons.attach_money,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PaymentForm()));
              },
            ),
            Divider(),
            Text("Settings"),
            DrawerTile(
                isActive: false,
                title: "User Settings",
                icon: Icons.manage_accounts_outlined),
            DrawerTile(
              isActive: false,
              title: "App Settings",
              icon: Icons.settings_outlined,
              activeIcon: Icons.settings,
            ),
            DrawerTile(
              title: "Log Out",
              icon: Icons.logout_rounded,
              onTap: () async {
                await context.read<LoginModel>().logout();
                // Navigator.pushNamed(context, LoginView.id);
              },
            ),
            AboutListTile(
              applicationIcon: Image.asset("no_data.png", height: 40),
              applicationLegalese: "© ${DateTime.now().year} Aman Gupta",
              applicationName: "Pro Build Admin",
              applicationVersion: "1.0.3",
            ),
          ],
        ),
      ),
    );
  }

  void navigate(BuildContext context, String currentRoute, String route) {
    if (currentRoute != route) {
      Navigator.pushReplacementNamed(context, route);
    } else
      Navigator.pop(context);
  }
}

class DrawerTile extends StatelessWidget {
  final bool? isActive;
  final IconData icon;
  final IconData? activeIcon;
  final String title;
  final Function()? onTap;

  const DrawerTile(
      {Key? key,
      this.isActive,
      required this.title,
      required this.icon,
      this.activeIcon,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        // margin: EdgeInsets.symmetric(horizontal: 12),
        height: 56,
        width: 336,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: isActive == null || !isActive!
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.secondaryContainer,
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Icon(isActive == null || !isActive! ? icon : activeIcon ?? icon),
              SizedBox(width: 12),
              Text(title)
            ],
          ),
        ));
  }
}
