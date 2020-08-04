import 'package:casino/datasource/remote/api_client.dart';
import 'package:casino/datasource/repo/user_repo.dart';
import 'package:casino/feature/auth/auth_viewmodel.dart';
import 'package:casino/feature/counter/counter_viewmodel.dart';
import 'package:casino/feature/report/report_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:casino/datasource/local/shared_preferences_repo.dart';
import 'package:casino/datasource/repo/auth_repo.dart';
import 'package:casino/feature/splash_screen/splash_viewmodel.dart';

GetIt locator = GetIt.instance;

void setUpInjector() {
  ///  Inject SharedPreferencesRepository

  locator.registerLazySingleton(() => SharedPreferencesRepository());
  locator.registerLazySingleton(() => ApiClient());

  /// Inject repo
  locator.registerLazySingleton(() => AuthRepo());
  locator.registerLazySingleton(() => UserRepo());

  /// Inject view model
  locator.registerFactory<SplashScreenViewModel>(() => SplashScreenViewModel());
  locator.registerFactory<AuthViewModel>(() => AuthViewModel());
  locator.registerFactory<CounterViewModel>(() => CounterViewModel());
  locator.registerFactory<ReportViewModel>(() => ReportViewModel());
}
