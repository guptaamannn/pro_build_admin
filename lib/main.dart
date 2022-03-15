import 'package:flutter/material.dart';

import 'app.dart';
import 'locator.dart';

void main() {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}
