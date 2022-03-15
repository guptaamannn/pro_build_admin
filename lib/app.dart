import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '/ui/views/auth_wrapper_view.dart';
import '/ui/shared/theme.dart';
import '/core/viewModel/transaction_model.dart';
import '/core/viewModel/user_model.dart';
import 'package:provider/provider.dart';
import '/ui/router.dart' as router;

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text(
            "Something went wrong",
            textDirection: TextDirection.ltr,
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              // ChangeNotifierProvider<LoginModel>(
              //     create: (context) => LoginModel()),
              ChangeNotifierProvider<Transaction>(create: (_) => Transaction()),
              ChangeNotifierProvider<UserModel>(create: (_) => UserModel()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              showPerformanceOverlay: false,
              darkTheme: ThemeBuilder().getDarkTheme(),
              theme: ThemeBuilder().getLightTheme(),
              themeMode: ThemeMode.system,
              initialRoute: AuthWrapperView.id,
              onGenerateRoute: router.generateRoute,
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
