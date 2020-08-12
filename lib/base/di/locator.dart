import 'package:commission_counter/datasource/remote/api_client.dart';
import 'package:commission_counter/datasource/repo/order_repo.dart';
import 'package:commission_counter/datasource/repo/store_repo.dart';
import 'package:commission_counter/datasource/repo/user_repo.dart';
import 'package:commission_counter/feature/auth/auth_viewmodel.dart';
import 'package:commission_counter/feature/counter/counter_viewmodel.dart';
import 'package:commission_counter/feature/counter/input_user_code_viewmodel.dart';
import 'package:commission_counter/feature/report/report_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:commission_counter/datasource/local/shared_preferences_repo.dart';
import 'package:commission_counter/datasource/repo/auth_repo.dart';
import 'package:commission_counter/feature/splash_screen/splash_viewmodel.dart';

GetIt locator = GetIt.instance;

void setUpInjector() {
  ///  Inject SharedPreferencesRepository
  locator.registerLazySingleton(() => ApiClient());

  /// Inject repo
  locator.registerLazySingleton(() => SharedPreferencesRepo());
  locator.registerLazySingleton(() => AuthRepo());
  locator.registerLazySingleton(() => UserRepo());
  locator.registerLazySingleton(() => OrderRepo());
  locator.registerLazySingleton(() => StoreRepo());

  /// Inject view model
  locator.registerFactory<SplashScreenViewModel>(() => SplashScreenViewModel());
  locator.registerFactory<AuthViewModel>(() => AuthViewModel());
  locator.registerFactory<CounterViewModel>(() => CounterViewModel());
  locator.registerFactory<ReportViewModel>(() => ReportViewModel());
  locator
      .registerFactory<InputUserCodeViewModel>(() => InputUserCodeViewModel());
}
