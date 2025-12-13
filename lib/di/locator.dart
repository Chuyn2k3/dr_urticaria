import 'package:dio/dio.dart';
import 'package:dr_urticaria/core/repositories/appointments_repository.dart';
import 'package:dr_urticaria/core/repositories/medical_records_repository.dart';
import 'package:dr_urticaria/core/repositories/patient_repository.dart';
import 'package:dr_urticaria/core/repositories/uas7_repository.dart';
import 'package:dr_urticaria/core/repositories/user_repository.dart';
import 'package:dr_urticaria/core/repositories/vital_record_repository.dart';
import 'package:dr_urticaria/core/services/appointments_service.dart';
import 'package:dr_urticaria/core/services/medical_record_service.dart';
import 'package:dr_urticaria/core/services/medical_records_service.dart';
import 'package:dr_urticaria/core/services/patient_service.dart';
import 'package:dr_urticaria/core/services/uas7_service.dart';
import 'package:dr_urticaria/core/services/user_service.dart';
import 'package:dr_urticaria/cubits/login/login_cubit.dart';
import 'package:dr_urticaria/cubits/profile/profile_cubit.dart';
import 'package:dr_urticaria/medical_record_v2/create_medical_record/cubit/patient_search_cubit.dart';
import 'package:dr_urticaria/utils/http_services.dart';
import 'package:dr_urticaria/utils/navigation_service.dart';
import 'package:dr_urticaria/utils/shared_preferences_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/services/firebase_service/remote_config_service.dart';

GetIt serviceLocator = GetIt.instance;

Future<void> setupLocator() async {
  //serviceLocator
  serviceLocator.registerLazySingleton(() => NavigationService());
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => ProfileUserCubit());
  serviceLocator.registerLazySingleton(() => PatientSearchCubit());
  serviceLocator.registerLazySingleton(
      () => SharedPreferencesManager(sharedPreferences: sharedPreferences));
  final url = await FireBaseRemoteConfigService.getSavedUrl();
  final Dio dio = await setupDio(
      baseUrl: url ?? "https://hospital.huyit.lat", isHaveToken: true);
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
  serviceLocator.registerLazySingleton<AppointmentsRepository>(
      () => AppointmentsRepositoryImpl(serviceLocator<AppointmentsService>()));
// Repositories
  serviceLocator.registerLazySingleton<MedicalRecordsRepository>(() =>
      MedicalRecordsRepositoryImpl(serviceLocator<MedicalRecordsService>()));
  serviceLocator.registerLazySingleton<MedicalRecordsService>(
      () => MedicalRecordsService(dio));

// Repositories

  serviceLocator.registerFactory<UserRepository>(
      () => UserRepositoryImpl(userServices: serviceLocator<UserServices>()));

  serviceLocator.registerLazySingleton<MedicalRecordService>(
      () => MedicalRecordService(dio));
  serviceLocator.registerFactory<PatientRepository>(() => PatientRepositoryImpl(
      patientServices: serviceLocator<PatientServices>()));

  serviceLocator
      .registerLazySingleton<PatientServices>(() => PatientServices(dio));
// Repositories
  serviceLocator.registerLazySingleton<VitalRecordRepository>(() =>
      VitalRecordRepositoryImpl(
          service: serviceLocator<MedicalRecordService>()));

  serviceLocator.registerLazySingleton<Uas7Service>(() => Uas7Service(dio));

  serviceLocator.registerLazySingleton<Uas7Repository>(
    () => Uas7RepositoryImpl(service: serviceLocator<Uas7Service>()),
  );
}
