import 'package:flutter/material.dart';
import 'package:pro_build_attendance/ui/widgets/bottom_navigation_bar.dart';

class HomeView extends StatelessWidget {
  static const String id = "/home";

  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Hero(
          tag: "nav",
          child: CustomBottomNavigation(
            currentRoute: id,
          )),
      body: Center(child: const Text("Home Page")),
    );
  }
}
