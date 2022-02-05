import 'package:get_it/get_it.dart';
import 'package:pro_build_attendance/core/services/authentication_service.dart';
import 'package:pro_build_attendance/core/services/firestore_service.dart';
import 'package:pro_build_attendance/core/services/storage_service.dart';
import 'package:pro_build_attendance/core/viewModel/attendance_model.dart';
import 'package:pro_build_attendance/core/viewModel/login_model.dart';
import 'package:pro_build_attendance/core/viewModel/user_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator.registerLazySingleton<StorageService>(() => StorageService());
  locator.registerLazySingleton<FirestoreService>(() => FirestoreService());

  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => AttendanceModel());
  locator.registerLazySingleton(() => UserModel());
}
