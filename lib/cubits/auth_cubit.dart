import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_model.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  // Demo users
  final List<UserModel> _demoUsers = [
    UserModel(
      id: 'doctor1',
      name: 'Nguyễn Văn A',
      email: 'doctor@hospital.com',
      phone: '0123456789',
      role: UserRole.doctor,
      specialization: 'Da liễu',
      roomNumber: 'P101',
      department: 'Khoa Da liễu',
    ),
    UserModel(
      id: 'nurse1',
      name: 'Trần Thị B',
      email: 'nurse@hospital.com',
      phone: '0987654321',
      role: UserRole.nurse,
      department: 'Khoa Da liễu',
    ),
  ];

  Future<void> login(String email, String password) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final user = _demoUsers.firstWhere(
        (u) => u.email == email,
        orElse: () => throw Exception('Invalid credentials'),
      );

      emit(state.copyWith(user: user, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void logout() {
    emit(AuthState());
  }
}
