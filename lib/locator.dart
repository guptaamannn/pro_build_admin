import 'package:get_it/get_it.dart';

import 'core/services/authentication_service.dart';
import 'core/services/firestore_service.dart';
import 'core/services/storage_service.dart';
import 'core/viewModel/attendance_model.dart';
import 'core/viewModel/login_model.dart';
import 'core/viewModel/user_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator.registerLazySingleton<StorageService>(() => StorageService());
  locator.registerLazySingleton<FirestoreService>(() => FirestoreService());

  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => AttendanceModel());
  locator.registerLazySingleton(() => UserModel());
}
