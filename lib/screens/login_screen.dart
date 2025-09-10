import 'package:dr_urticaria/cubits/login/login_cubit.dart';
import 'package:dr_urticaria/cubits/profile/profile_cubit.dart';
import 'package:dr_urticaria/utils/shared_preferences_manager.dart';
import 'package:dr_urticaria/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../constant/config.dart';
import '../cubits/auth_cubit.dart';
import '../models/user_model.dart';
import '../utils/app_theme.dart';
import 'dashboard/doctor_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final _cubitLogin = LoginCubit();
  final sharedPreferences = GetIt.instance<SharedPreferencesManager>();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    checkAutoLogin();
    super.initState();
  }

  void checkAutoLogin() async {
    // final isTokenExpired = await context.read<AuthCubit>().isTokenExpired();
    // if (isTokenExpired) {
    final sp = GetIt.instance.get<SharedPreferencesManager>();
    final user = sp.getString(AppConfig.SL_USERNAME);
    final pass = sp.getString(AppConfig.SL_PASSWORD);
    if (user != null && pass != null && user.isNotEmpty && pass.isNotEmpty) {
      _cubitLogin.handleLogin(phone: user, password: pass);
    }
    //}
  }

  void _navigateToRoleDashboard(UserRole role) {
    Widget dashboard;
    switch (role) {
      case UserRole.doctor:
        dashboard = const DoctorDashboard();
        break;
      case UserRole.nurse:
        dashboard = const DoctorDashboard();
        break;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => dashboard),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => _cubitLogin,
        ),
      ],
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: BlocListener<LoginCubit, LoginAppState>(
          listener: (context, state) {
            if (state is LoggedInState) {
              _navigateToRoleDashboard(UserRole.doctor);
              sharedPreferences.putString(
                  AppConfig.SL_USERNAME, _emailController.text);
              sharedPreferences.putString(
                  AppConfig.SL_PASSWORD, _passwordController.text);
              // context.read<AuthCubit>().login(
              //     username: _emailController.text,
              //     password: _passwordController.text);
              context.read<ProfileUserCubit>().getProfile();
            } else if (state is LoginErrorState) {
              context.showSnackBarFail(text: state.error);
            }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Logo and Title
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(60),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.local_hospital_rounded,
                        size: 60,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Hệ thống quản lý mề đay',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Login Form
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Chào mừng trở lại',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Vui lòng đăng nhập để tiếp tục',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'User name',
                                prefixIcon: Icon(Icons.email_rounded),
                                hintText: 'Nhập user name của bạn',
                              ),
                              //  keyboardType: TextInputType.emailAddress,

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập số điện thoại';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Mật khẩu',
                                prefixIcon: const Icon(Icons.lock_rounded),
                                hintText: 'Nhập mật khẩu của bạn',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  _cubitLogin.handleLogin(
                                    phone: _emailController.text,
                                    password: _passwordController.text,
                                  );
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập mật khẩu';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),
                            BlocBuilder<LoginCubit, LoginAppState>(
                              builder: (context, state) {
                                return Container(
                                  width: double.infinity,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(28),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: state is LoginInLoadingState
                                        ? null
                                        : () {
                                            if (_formKey.currentState
                                                    ?.validate() ??
                                                false) {
                                              _cubitLogin.handleLogin(
                                                phone: _emailController.text,
                                                password:
                                                    _passwordController.text,
                                              );
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                    ),
                                    child: state is LoginInLoadingState
                                        ? const CircularProgressIndicator(
                                            color: Color(0xFF0066CC))
                                        : const Text(
                                            'Đăng nhập',
                                            style: TextStyle(
                                              color: Color(0xFF0066CC),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                            // BlocBuilder<AuthCubit, AuthState>(
                            //   builder: (context, state) {
                            //     return SizedBox(
                            //       width: double.infinity,
                            //       height: 50,
                            //       child: ElevatedButton(
                            //         onPressed:
                            //             state.isLoading ? null : _login,
                            //         style: ElevatedButton.styleFrom(
                            //           shape: RoundedRectangleBorder(
                            //             borderRadius:
                            //                 BorderRadius.circular(12),
                            //           ),
                            //           elevation: 3,
                            //         ),
                            //         child: state.isLoading
                            //             ? const SizedBox(
                            //                 width: 24,
                            //                 height: 24,
                            //                 child: CircularProgressIndicator(
                            //                   color: Colors.white,
                            //                   strokeWidth: 2,
                            //                 ),
                            //               )
                            //             : const Text(
                            //                 'Đăng nhập',
                            //                 style: TextStyle(
                            //                   fontSize: 16,
                            //                   fontWeight: FontWeight.bold,
                            //                 ),
                            //               ),
                            //       ),
                            //     );
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Demo Accounts
                    // Container(
                    //   padding: const EdgeInsets.all(16),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white.withOpacity(0.15),
                    //     borderRadius: BorderRadius.circular(12),
                    //     border:
                    //         Border.all(color: Colors.white.withOpacity(0.3)),
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       const Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Icon(Icons.info_outline,
                    //               color: Colors.white, size: 16),
                    //           SizedBox(width: 8),
                    //           Text(
                    //             'Tài khoản demo',
                    //             style: TextStyle(
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       const SizedBox(height: 12),
                    //       const Text(
                    //         'Bác sĩ: chuyen\nY tá: chuyen\nMật khẩu: 123456',
                    //         style: TextStyle(
                    //           color: Colors.white70,
                    //           fontSize: 14,
                    //           height: 1.5,
                    //         ),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
