import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:pro_build_attendance/provider/ui_provider.dart';
import 'package:pro_build_attendance/services/authentication_service.dart';
import 'package:pro_build_attendance/views/login/login_view.dart';
import 'package:pro_build_attendance/views/attendance/attendance_view.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
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
          return Text(
            "Something went wrong",
            textDirection: TextDirection.ltr,
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider(
            create: (_) => Ui(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              showPerformanceOverlay: false,
              darkTheme: ThemeData.dark(),
              themeMode: ThemeMode.system,
              home: AuthService()
                  .authWrapper(context, LoginView(), AttendanceView()),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
