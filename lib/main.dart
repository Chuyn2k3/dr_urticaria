import 'package:dr_urticaria/cubits/profile/profile_cubit.dart';
import 'package:dr_urticaria/di/locator.dart';
import 'package:dr_urticaria/firebase_options.dart';
import 'package:dr_urticaria/medical_record_v2/create_medical_record/cubit/patient_search_cubit.dart';

import 'package:dr_urticaria/screens/live/live_detail.dart';
import 'package:dr_urticaria/screens/live/live_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 👇 THÊM: localizations
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/services/firebase_service/remote_config_service.dart';
import 'cubits/auth_cubit.dart';
import 'cubits/medical_record_cubit.dart';
import 'cubits/appointment_cubit.dart';
import 'cubits/notification_cubit.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard/doctor_dashboard.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FireBaseRemoteConfigService.getConfig();
  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()..checkLogin()),
        BlocProvider(create: (context) => MedicalRecordCubit()),
        //  BlocProvider(create: (context) => AppointmentCubit()),
        BlocProvider(create: (context) => NotificationCubit()),
        // BlocProvider(create: (context) => AcuteUrticariaCubit()),
        //BlocProvider(create: (context) => ChronicInitialCubit()),
        //  BlocProvider(create: (context) => ChronicFollowupCubit()),
        BlocProvider(
          create: (_) => serviceLocator<ProfileUserCubit>(),
        ),
        BlocProvider(create: (context) => serviceLocator<PatientSearchCubit>()),
      ],
      child: MaterialApp(
        title: 'Urticaria Management',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,

        // 👇 THÊM: cấu hình i18n để DatePicker/TimePicker/Nút, tháng… dùng tiếng Việt
        locale: const Locale(
            'vi'), // ép UI tiếng Việt; muốn theo máy thì bỏ dòng này
        supportedLocales: const [
          Locale('vi'),
          Locale('en'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        home: const SplashScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/doctor-dashboard': (context) => const DoctorDashboard(),
          '/nurse-dashboard': (context) => const DoctorDashboard(),
          '/live_page': (context) => const LivePage(),
          //'/live-detail': (context) => const LiveDetailPage(),
        },
      ),
    );
  }
}
