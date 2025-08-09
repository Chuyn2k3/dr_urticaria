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

void main() {
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
