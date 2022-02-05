import 'package:flutter/material.dart';
import 'package:pro_build_attendance/app.dart';
import 'package:pro_build_attendance/locator.dart';

void main() {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}
