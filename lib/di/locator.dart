import 'package:dio/dio.dart';
import 'package:dr_urticaria/core/repositories/appointments_repository.dart';
import 'package:dr_urticaria/core/repositories/user_repository.dart';
import 'package:dr_urticaria/core/services/appointments_service.dart';
import 'package:dr_urticaria/core/services/user_service.dart';
import 'package:dr_urticaria/cubits/login/login_cubit.dart';
import 'package:dr_urticaria/utils/http_services.dart';
import 'package:dr_urticaria/utils/navigation_service.dart';
import 'package:dr_urticaria/utils/shared_preferences_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt serviceLocator = GetIt.instance;

Future<void> setupLocator() async {
  //serviceLocator
  serviceLocator.registerLazySingleton(() => NavigationService());
  final sharedPreferences = await SharedPreferences.getInstance();
  //serviceLocator.registerLazySingleton(() => ProfileUserCubit());
  serviceLocator.registerLazySingleton(
      () => SharedPreferencesManager(sharedPreferences: sharedPreferences));

  final Dio dio =
      await setupDio(baseUrl: "https://hospital.huyit.lat", isHaveToken: true);
  serviceLocator.registerLazySingleton(() => LoginCubit());
  serviceLocator.registerLazySingleton<UserServices>(() => UserServices(dio));
  // sl.registerLazySingleton<UrticariaApiService>(
  //   () => UrticariaApiService(dio),
  // );
  // serviceLocator.registerLazySingleton<UrticariaRepository>(
  //   () => UrticariaRepositoryImpl(sl<UrticariaApiService>()),
  // );

  // Cubits
  serviceLocator.registerLazySingleton<AppointmentsService>(
      () => AppointmentsService(dio));

// Repositories
  serviceLocator.registerLazySingleton<AppointmentsRepository>(
      () => AppointmentsRepositoryImpl(serviceLocator<AppointmentsService>()));

  serviceLocator.registerFactory<UserRepository>(
      () => UserRepositoryImpl(userServices: serviceLocator<UserServices>()));
}
