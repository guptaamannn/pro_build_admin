import 'package:flutter/material.dart';
import '/ui/widgets/bottom_navigation_bar.dart';
import 'payment_form.dart';

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
      body: const Center(child: Text("Hello World")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PaymentForm(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
