import 'package:dr_urticaria/di/locator.dart';
import 'package:dr_urticaria/medical_record_v2/cubits/acute_urticaria/acute_urticaria_cubit.dart';
import 'package:dr_urticaria/medical_record_v2/cubits/chronic_followup/chronic_followup_cubit.dart';
import 'package:dr_urticaria/medical_record_v2/cubits/chronic_initital/chronic_initial_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/auth_cubit.dart';
import 'cubits/medical_record_cubit.dart';
import 'cubits/appointment_cubit.dart';
import 'cubits/notification_cubit.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard/doctor_dashboard.dart';
import 'screens/dashboard/nurse_dashboard.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => MedicalRecordCubit()),
        BlocProvider(create: (context) => AppointmentCubit()),
        BlocProvider(create: (context) => NotificationCubit()),
        BlocProvider(create: (context) => AcuteUrticariaCubit()),
        BlocProvider(create: (context) => ChronicInitialCubit()),
        BlocProvider(create: (context) => ChronicFollowupCubit()),
      ],
      child: MaterialApp(
        title: 'Urticaria Management',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/doctor-dashboard': (context) => const DoctorDashboard(),
          '/nurse-dashboard': (context) => const NurseDashboard(),
        },
      ),
    );
  }
}
